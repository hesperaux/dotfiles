return {
    'glepnir/template.nvim',
    cmd = { 'Template', 'TemProject' },
    config = function()
        require('template').setup({
            temp_dir = vim.fn.expand("~/.config/nvim/templates/"),
            author = "David Bieber",
            email = "hesperaux@gmail.com"
        })
        require("telescope").load_extension('find_template')
        -- keymaps are in telescope.nvim
    end
}
