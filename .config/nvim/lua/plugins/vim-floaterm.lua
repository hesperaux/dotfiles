return {
    "voldikss/vim-floaterm",
    config = function()
        vim.keymap.set("n", "<leader>ft", ":FloatermToggle<CR>", { noremap = true })
        vim.keymap.set("t", "<leader>ft", '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true })
    end
}
