// @bun
var PROVIDER_ID = "aria-home";
var API_BASE = "https://ai.stronghold/gw/v1";
var DEFAULT_NPM = "@ai-sdk/openai-compatible";
var EXTRA_HEADERS = { "X-Tool-Name": "opencode" };
var ALLOWED_MODALITIES = new Set(["text", "audio", "image", "video", "pdf"]);
var MODELS_TIMEOUT_MS = 10000;

import { readFileSync } from "fs";
import { appendFileSync } from "fs";
import { join } from "path";
import { homedir } from "os";

var LOG_FILE = "/tmp/aria-home-plugin.log";
function log(message, level = "DEBUG") {
  const line = `[${new Date().toISOString()}] [aria-home-plugin ${level}] ${message}\n`;
  try { appendFileSync(LOG_FILE, line); } catch {}
}

function getAuthKey() {
  try {
    const authPath = join(homedir(), ".local", "share", "opencode", "auth.json");
    const data = JSON.parse(readFileSync(authPath, "utf-8"));
    const auth = data[PROVIDER_ID];
    if (auth?.type === "api" && auth.key) {
      return auth.key;
    }
    return;
  } catch {
    return;
  }
}

function normalizeModalities(values, fallback) {
  const result = (values ?? fallback).map((v) => v.toLowerCase()).filter((v) => ALLOWED_MODALITIES.has(v));
  return result.length > 0 ? result : fallback;
}

function shouldInclude(model) {
  if (!model.id) return false;
  if (model.capabilities?.embeddings) return false;
  if (model.capabilities?.fill_in_middle && !model.capabilities?.completion) return false;
  if (!model.capabilities?.completion) return false;
  if (model.context_window == null || model.max_output_tokens == null) return false;
  return true;
}

function build(model) {
  const npmPackage = model.aisdk_provider || DEFAULT_NPM;
  const inputModalities = normalizeModalities(model.modalities?.input, ["text"]);
  const outputModalities = normalizeModalities(model.modalities?.output, ["text"]);
  const hasFileInput = inputModalities.some((m) => m !== "text");
  const supportsReasoning = model.capabilities?.reasoning ?? false;
  const needsProviderOverride = npmPackage !== DEFAULT_NPM;

  const configModel = {
    id: model.id,
    name: model.name || model.id,
    status: "active",
    temperature: model.capabilities?.temperature ?? true,
    reasoning: supportsReasoning,
    attachment: model.capabilities?.attachment ?? hasFileInput,
    tool_call: model.capabilities?.tool_call ?? model.capabilities?.enable_server_tool_calls ?? true,
    modalities: {
      input: inputModalities,
      output: outputModalities
    },
    cost: {
      input: 0,
      output: 0,
      cache_read: 0,
      cache_write: 0
    },
    limit: {
      context: model.context_window,
      output: model.max_output_tokens
    },
    options: {},
    headers: EXTRA_HEADERS,
    release_date: model.release_date || "",
    ...needsProviderOverride ? { provider: { npm: npmPackage } } : {}
  };

  return configModel;
}

async function getModels(apiKey) {
  const res = await fetch(`${API_BASE}/models`, {
    headers: { Authorization: `Bearer ${apiKey}`, ...EXTRA_HEADERS, Accept: "application/json" },
    signal: AbortSignal.timeout(MODELS_TIMEOUT_MS)
  });
  if (!res.ok) {
    throw new Error(`Failed to fetch models: ${res.status}`);
  }
  const data = await res.json();
  const remoteModels = data.data ?? [];
  const candidates = remoteModels.filter(shouldInclude);
  log(`discovered ${candidates.length} models (trust /v1/models for liveness)`);
  const result = {};
  for (const m of candidates) {
    result[m.id] = build(m);
  }
  return result;
}

async function AriaHomePlugin(input, _options) {
  log("=== Plugin starting ===");
  return {
    config: async (config) => {
      log("config hook called");
      config.provider ??= {};
      config.provider[PROVIDER_ID] ??= {};
      config.provider[PROVIDER_ID].npm = DEFAULT_NPM;
      config.provider[PROVIDER_ID].api = API_BASE;
      const apiKey = getAuthKey();
      if (!apiKey) {
        log("no auth key found in auth.json");
        return;
      }
      log(`fetching models with auth key (prefix: ${apiKey.substring(0, 8)}...)`);
      try {
        const result = await getModels(apiKey);
        const count = Object.keys(result).length;
        log(`fetched ${count} loaded models`);
        config.provider[PROVIDER_ID].models ??= {};
        for (const [id, model] of Object.entries(result)) {
          config.provider[PROVIDER_ID].models[id] = model;
        }
        log(`added ${count} models to provider config`);
      } catch (error) {
        log(`failed to fetch models: ${error instanceof Error ? error.message : String(error)}`, "ERROR");
      }
    },
    auth: {
      provider: PROVIDER_ID,
      async loader(getAuth) {
        const info = await getAuth();
        log(`auth loader called, auth.type=${info?.type || "none"}`);
        if (!info || info.type !== "api") return {};
        return {
          apiKey: "",
          async fetch(request, init) {
            const info2 = await getAuth();
            if (info2.type !== "api") return fetch(request, init);
            const headers = {
              ...init?.headers,
              Authorization: `Bearer ${info2.key}`,
              ...EXTRA_HEADERS
            };
            delete headers["x-api-key"];
            delete headers["authorization"];
            return fetch(request, {
              ...init,
              headers
            });
          }
        };
      },
      methods: [
        {
          type: "api",
          label: "API Key"
        }
      ]
    }
  };
}

var src_default = AriaHomePlugin;
export {
  src_default as default,
  AriaHomePlugin
};
