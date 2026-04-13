-- minuet-ai.nvim configuration for AriaHome FIM
-- Connects to llm-fim (Qwen2.5-Coder-7B-Instruct Q8_0) via gateway
-- Endpoint: https://ai.stronghold/gw/v1/completions

return {
  "milanglacier/minuet-ai.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("minuet").setup({
      provider = "openai_fim_compatible",
      provider_options = {
        openai_fim_compatible = {
          model = "llm-fim",
          end_point = "https://ai.stronghold/gw/v1/completions",
          -- api_key must be an env var name (not a raw value).
          -- TERM always exists; the gateway doesn't check auth.
          api_key = "TERM",
          stream = true,
          name = "llm-fim",
          optional = {
            max_tokens = 128,
            temperature = 0.1,
            top_p = 0.95,
            top_k = 40,
          },
          -- llama.cpp /v1/completions does NOT support the "suffix"
          -- field, so we disable it and inject Qwen FIM tokens manually.
          template = {
            suffix = false,
            prompt = function(prefix, suffix)
              return "<|fim_prefix|>" .. prefix .. "<|fim_suffix|>" .. suffix .. "<|fim_middle|>"
            end,
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = { "*" },
        keymap = {
          accept = "<Tab>",
          accept_line = "<A-a>",
          dismiss = "<C-]>",
          accept_n_lines = "<A-z>",
          prev = "<A-[>",
          next = "<A-]>",
        },
      },
      -- Debounce delay in milliseconds before triggering completion
      debounce = 300,
      -- Throttle delay in milliseconds between requests
      throttle = 1000,
    })
  end,
}
