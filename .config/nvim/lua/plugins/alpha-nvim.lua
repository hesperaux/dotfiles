return {
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    priority = 800, -- Load after web-devicons (1000) but before other UI plugins
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.startify")

        -- Ensure web-devicons is loaded before setting up alpha
        local icons_ok, web_icons = pcall(require, "nvim-web-devicons")
        if icons_ok then
            -- Force refresh icons to ensure YML icons are loaded
            web_icons.setup({})
        end

        alpha.setup(dashboard.opts)
    end,
}
