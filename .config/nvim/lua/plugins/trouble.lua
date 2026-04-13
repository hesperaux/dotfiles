return {
    "folke/trouble.nvim",
    opts = {},
    event = "VeryLazy", -- Load after startup but before user interaction
    keys = {
        -- Diagnostics (toggle mode works for these)
        { "<leader>tx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle Trouble Diagnostics" },
        { "<leader>tw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
        { "<leader>td", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics (Trouble)" },
        -- Lists (toggle mode works for these)
        { "<leader>tl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
        { "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
        -- LSP combined mode
        { "<leader>ta", "<cmd>Trouble lsp toggle<cr>", desc = "All LSP Info (Trouble)" },
        -- Individual LSP modes
        { "<leader>tr", "<cmd>Trouble lsp_references<cr>", desc = "LSP References (Trouble)" },
        { "<leader>ts", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
        { "<leader>ti", "<cmd>Trouble lsp_implementations<cr>", desc = "LSP Implementations (Trouble)" },
        { "<leader>tt", "<cmd>Trouble lsp_type_definitions<cr>", desc = "LSP Type Definitions (Trouble)" },
        { "<leader>tD", "<cmd>Trouble lsp_definitions<cr>", desc = "LSP Definitions (Trouble)" },
        { "<leader>tS", "<cmd>Trouble lsp_document_symbols toggle<cr>", desc = "LSP Document Symbols (Trouble)" },
    },
    config = function(_, opts)
        require("trouble").setup(opts)

        -- Diagnostic signs configuration
        local signs = {
            Error = "",
            Warning = "",
            Hint = "",
            Information = ""
        }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
    end,
}
