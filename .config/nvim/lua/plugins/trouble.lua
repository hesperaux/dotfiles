return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        vim.keymap.set("n", "<leader>tt", ":TroubleToggle<CR>", {})
        vim.keymap.set("n", "<leader>tx", "<cmd>TroubleToggle<cr>",
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>td", "<cmd>TroubleToggle document_diagnostics<cr>",
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>tl", "<cmd>TroubleToggle loclist<cr>",
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>tq", "<cmd>TroubleToggle quickfix<cr>",
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>tr", "<cmd>TroubleToggle lsp_references<cr>",
            { silent = true, noremap = true }
        )

        -- Diagnostic signs
        -- https://github.com/folke/trouble.nvim/issues/52
        local signs = {
            Error = " ",
            Warning = " ",
            Hint = " ",
            Information = " "
        }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
    end,
}
