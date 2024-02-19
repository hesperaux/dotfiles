return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = {
                "vimdoc",
                "markdown",
                "lua",
                "rust",
                "c",
                "cpp",
                "cmake",
                "git_config",
                "csv",
                "dockerfile",
                "css",
                "c_sharp",
                "bash",
                "java",
                "html",
                "json",
                "javascript",
                "php",
                "python",
                "rasi",
                "scss",
                "sql",
                "ssh_config",
                "typescript",
                "udev",
                "vue",
                "xml",
                "yaml"

            },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
