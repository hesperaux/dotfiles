return {
    "ThePrimeagen/harpoon",
    dependencies = {
    },
    config = function()
        require('harpoon').setup({
            width = vim.api.nvim_win_get_width(0) - 4,
        })
        require("telescope").load_extension('harpoon')
        vim.keymap.set("n", "<leader>hm", require("harpoon.mark").add_file(), { desc = "[H]arpoon [M]ark" })
        vim.keymap.set("n", "<leader>ho", require("harpoon.ui").toggle_quick_menu(), { desc = "[H]arpoon [O]pen" })
        vim.keymap.set("n", "<leader>hl", require("harpoon.ui").nav_next(), { desc = "[H]arpoon Next" }) -- navigates to next mark
        vim.keymap.set("n", "<leader>hh", require("harpoon.ui").nav_prev(), { desc = "[H]arpoon Prev" }) -- navigates to previous mark
    end
}
