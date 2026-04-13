return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup({
                PATH = "prepend", -- "skip" causes spawning error for omnisharp
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ansiblels",
                    "bashls",
                    "clangd",
                    -- "csharp_ls",
                    "omnisharp",
                    "cmake",
                    "cssls",
                    "dockerls",
                    "docker_compose_language_service",
                    "eslint",
                    "gopls",
                    "gradle_ls",
                    "grammarly",
                    "html",
                    -- "htmx",
                    "jsonls",
                    "jdtls",
                    "marksman",
                    "intelephense",
                    "powershell_es",
                    "pylsp",
                    "rust_analyzer",
                    "sqlls",
                    "taplo",
                    "vuels",
                    "lemminx",
                    "yamlls",
                    "terraformls",
                    "ts_ls",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- For nvim 0.11+, we use vim.lsp.config to avoid the lspconfig deprecation warning
            -- For older nvim, we fall back to lspconfig
            local has_native_lsp_config = vim.fn.has("nvim-0.11") == 1 and vim.lsp.config

            -- Helper to setup a server
            local function setup_server(name, config)
                config = config or {}
                config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})

                if has_native_lsp_config then
                    -- Use the new native vim.lsp.config API (nvim 0.11+)
                    -- This avoids the lspconfig deprecation warning
                    vim.lsp.config[name] = config
                    vim.lsp.enable(name)
                else
                    -- Fall back to lspconfig for older nvim
                    local lspconfig = require("lspconfig")
                    -- Only call setup if lspconfig has this server
                    if lspconfig[name] then
                        lspconfig[name].setup(config)
                    end
                end
            end

            -- Configure diagnostic display globally
            vim.diagnostic.config({
                -- Show virtual text (inline errors)
                virtual_text = {
                    prefix = '●', -- Could be '■', '▎', 'x'
                    spacing = 4,
                    source = "if_many",
                },
                -- Show signs in the sign column
                signs = true,
                -- Underline errors
                underline = true,
                -- Update diagnostics in insert mode
                update_in_insert = false,
                -- Sort diagnostics by severity
                severity_sort = true,
                -- Float window config for <leader>e and gl
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })

            -- Lua
            setup_server("lua_ls", {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        workspace = {
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            -- C/C++
            setup_server("clangd", {
                cmd = {
                    "clangd",
                    "--offset-encoding=utf-16",
                },
            })

            -- C# (Omnisharp)
            local pid = vim.fn.getpid()
            setup_server("omnisharp", {
                cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(pid) },
                capabilities = vim.tbl_deep_extend("force", capabilities, {
                    enable_roslyn_analysers = true,
                    enable_import_completion = true,
                    organize_imports_on_format = true,
                    enable_decompilation_support = true,
                }),
                filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" }
            })

            -- Rust
            setup_server("rust_analyzer")

            -- Bash
            setup_server("bashls")

            -- Python
            setup_server("pylsp")

            -- YAML
            setup_server("yamlls")

            -- Terraform
            setup_server("terraformls")

            -- XML
            setup_server("lemminx", {
                filetypes = { "xml", "xsd", "xsl", "xslt", "svg", "xaml", "axaml" }
            })

            -- TypeScript/JavaScript
            setup_server("ts_ls")

            -- Java
            setup_server("jdtls")

            -- Go
            setup_server("gopls")

            -- Global LSP keymaps (available without LspAttach for diagnostics)
            -- Show current line diagnostic in popup (like hover for errors)
            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
            vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
            -- Navigate diagnostics
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

            -- Auto-show diagnostics on hover (optional - uncomment if you want this)
            -- vim.api.nvim_create_autocmd("CursorHold", {
            --     buffer = buf,
            --     callback = function()
            --         vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
            --     end,
            -- })

            -- Use LspAttach autocommand for buffer-local mappings
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

                    -- Buffer local mappings
                    local opts = { buffer = ev.buf }
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
                    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
                    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
                    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
                    vim.keymap.set("n", "<leader>wl", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
                    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type definition" }))
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
                    vim.keymap.set("n", "<leader>gf", function()
                        vim.lsp.buf.format({ async = true })
                    end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
                end,
            })
        end,
    },
}
