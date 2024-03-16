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
                    "clangd",
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
                    "tsserver",
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
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            lspconfig.lua_ls.setup({ capabilities = capabilities })
            -- lspconfig.csharp_ls.setup({ capabilities = capabilities })
            local pid = vim.fn.getpid()

            lspconfig.omnisharp.setup({
                cmd = { 'omnisharp', '--languageserver', '--hostPID', tostring(pid) },
                capabilities = capabilities,
                enable_roslyn_analysers = true,
                enable_import_completion = true,
                organize_imports_on_format = true,
                enable_decompilation_support = true,
                filetypes = { 'cs', 'vb', 'csproj', 'sln', 'slnx', 'props', 'csx', 'props', 'targets' }
            })
            lspconfig.clangd.setup({
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--offset-encoding=utf-16",
                },
            })
            lspconfig.rust_analyzer.setup({ capabilities = capabilities })
            lspconfig.bashls.setup({ capabilities = capabilities })
            lspconfig.pylsp.setup({ capabilities = capabilities })
            lspconfig.tsserver.setup({ capabilities = capabilities })
            lspconfig.yamlls.setup({ capabilities = capabilities })
            lspconfig.lemminx.setup({
                capabilities = capabilities,
                filetypes = { "xml", "xsd", "xsl", "xslt", "svg", "xaml", "axaml" }
            })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            -- Global mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set("n", "<leader>wl", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
                end,
            })
        end,
    },
}
