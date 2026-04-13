-- nvim-web-devicons configuration with YAML/YML icon fix
-- This MUST load before alpha-nvim and other plugins that use icons
return {
    "nvim-tree/nvim-web-devicons",
    lazy = false, -- Load immediately
    priority = 1000, -- Load VERY early (before alpha which has priority 900)
    config = function()
        local icons = require("nvim-web-devicons")

        -- Setup with custom overrides
        icons.setup({
            -- Override by file extension
            override = {
                -- YML extension
                yml = {
                    icon = "",
                    color = "#cb171e",
                    cterm_color = "196",
                    name = "Yml",
                },
                -- YAML extension  
                yaml = {
                    icon = "",
                    color = "#cb171e",
                    cterm_color = "196",
                    name = "Yaml",
                },
            },
            -- Override by filetype (important for alpha dashboard MRU)
            override_by_filename = {
                [".yml"] = {
                    icon = "",
                    color = "#cb171e",
                    cterm_color = "196",
                    name = "Yml",
                },
                [".yaml"] = {
                    icon = "",
                    color = "#cb171e",
                    cterm_color = "196",
                    name = "Yaml",
                },
            },
            strict = true,
            default = true,
        })

        -- Explicitly set icons after setup
        icons.set_icon({
            yml = {
                icon = "",
                color = "#cb171e",
                cterm_color = "196",
                name = "Yml",
            },
            yaml = {
                icon = "",
                color = "#cb171e",
                cterm_color = "196",
                name = "Yaml",
            },
        })
    end,
}
