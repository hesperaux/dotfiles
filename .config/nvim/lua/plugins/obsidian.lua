return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
        "hrsh7th/nvim-cmp",
    },
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },

    config = function()
        -- Additional keymaps related to this plugins
        vim.keymap.set('n', "<leader>oa", ":ObsidianNew<CR>", {})
        vim.keymap.set('n', "<leader>oo", ":ObsidianOpen<CR>", {})
        vim.keymap.set('n', "<leader>op", ":ObsidianPasteImage<CR>", {})
        vim.keymap.set('n', "<leader>ot", ":ObsidianTemplate<CR>", {})
        vim.keymap.set('n', "<leader>ow", ":ObsidianWorkspace<CR>", {})
        vim.keymap.set('n', "<leader>o1", ":ObsidianWorkspace notes<CR>", {})
        vim.keymap.set('n', "<leader>o2", ":ObsidianWorkspace work<CR>", {})
        vim.keymap.set('n', "<leader>o3", ":ObsidianWorkspace yoyos<CR>", {})
        vim.keymap.set('n', "<leader>ol", ":ObsidianLink<CR>", {})
        vim.keymap.set('n', "<leader>os", ":ObsidianSearch<CR>", {})
        require("obsidian").setup({
            workspaces = {
                {
                    name = "notes",
                    path = vim.fn.expand("~/Documents/notes"),
                    overrides = {
                        notes_subdir = "0. Inbox"
                    }
                },
                {
                    name = "work",
                    path = "~/Documents/work",
                    overrides = {
                        notes_subdir = "0. Inbox"
                    }
                },
                {
                    name = "webclips",
                    path = "~/Documents/webclips",
                },
                {
                    name = "yoyos",
                    path = "~/Documents/yoyos",
                },
            },
            new_notes_location = "notes_subdir",
            wiki_link_func = function(opts)
                if opts.id == nil then
                    return string.format("[[%s]]", opts.label)
                elseif opts.label ~= opts.id then
                    return string.format("[[%s|%s]]", opts.id, opts.label)
                else
                    return string.format("[[%s]]", opts.id)
                end
            end,
            -- markdown_link_func = function(opts)
            -- end,
            completion = {
                nvim_cmp = true,
                min_chars = 2,
                -- * "current_dir" - put new notes in same directory as current buffer
                -- * "notes_subdir" - put notes in the default notes subdirectory
                -- new_notes_location = "notes_subdir",
            },

            mappings = {
                -- "obsidian follow[link]"
                ["<leader>of"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
                -- Toggle check boxes "obsidian done"
                ["<leader>od"] = {
                    action = function()
                        return require("obsidian").util.toggle_checkbox()
                    end,
                    opts = { buffer = true },
                }
            },

            note_frontmatter_func = function(note)
                -- Equivalent to default frontmatter function
                local out = { id = note.id, aliases = note.aliases, tags = note.tags, area = "", project = "" }

                -- `note.metadata` contains any manually added fields in the frontmatter
                -- So here we just make sure those fields are kept in the frontmatter
                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                    for k, v in pairs(note.metadata) do
                        out[k] = v
                    end
                end
                return out
            end,

            -- Optional, customize how names/IDs for new notes are created.
            note_id_func = function(title)
                -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
                -- In this case a note with the title 'My new note' will be given an ID that looks
                -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
                local prefix = ""
                if title ~= nil then
                    -- If title is given, transform it into valid file name.
                    -- prefix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                    return title
                else
                    -- If title is nil, just add 4 random uppercase letters to the prefix.
                    for _ = 1, 4 do
                        prefix = prefix .. string.char(math.random(65, 90))
                    end
                end
                return prefix .. "-" .. tostring(os.time())
            end,

            templates = {
                subdir = "Templates",
                date_format = "%&-%m-%d",
                time_format = "%H:%M",
                -- A map for custom variables, the key should be the variable and the value a function
                -- substitutions = {},
            },

            -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
            -- URL it will be ignored but you can customize this behavior here.
            follow_url_func = function(url)
                -- Open the URL in the default web browser.
                -- vim.fn.jobstart({ "open", url }) -- Mac OS
                vim.fn.jobstart({ "xdg-open", url }) -- linux
            end,

            picker = {
                -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
                name = "telescope.nvim",
                -- Optional, configure key mappings for the picker. These are the defaults.
                -- Not all pickers support all mappings.
                mappings = {
                    -- Create a new note from your query.
                    new = "<C-x>",
                    -- Insert a link to the selected note.
                    insert_link = "<C-l>",
                },
            },

            -- Optional, sort search results by "path", "modified", "accessed", or "created".
            -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
            -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
            sort_by = "modified",
            sort_reversed = true,

            -- Optional, determines how certain commands open notes. The valid options are:
            -- 1. "current" (the default) - to always open in the current window
            -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
            -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
            open_notes_in = "current",
        })
    end,
}
