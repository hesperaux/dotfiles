return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8', -- Updated to latest stable tag
    dependencies = {
        'nvim-lua/plenary.nvim',
        'BurntSushi/ripgrep',
        'nvim-telescope/telescope-ui-select.nvim', -- Moved from separate file
    },
    config = function()
        local builtin = require("telescope.builtin")
        local telescope = require("telescope")
        local themes = require("telescope.themes")

        -- Setup telescope with extensions
        telescope.setup({
            extensions = {
                ["ui-select"] = {
                    themes.get_dropdown {
                        -- even more opts
                    }
                }
            }
        })

        -- Load extensions
        telescope.load_extension("ui-select")

        -- Telescope keymaps
        vim.keymap.set('n', '<leader>f?', builtin.oldfiles,
            { desc = '[?] Find recently opened files' })
        vim.keymap.set('n', '<leader>f/', function()
            builtin.current_buffer_fuzzy_find(themes.get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer]' })

        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<leader>fS', builtin.git_status, { desc = 'Git Status' })
        vim.keymap.set('n', '<leader>fT', ":Telescope find_template type=insert<CR>", { desc = '[F]ind [T]emplates' })
        -- Note: harpoon2 doesn't have a telescope extension, use <leader>ho for harpoon menu instead

        -- Git worktree and notify extensions (if available)
        local silent = { silent = true }
        vim.keymap.set("n", "<Leader>fr", function()
            local ok, _ = pcall(require("telescope").extensions.git_worktree.git_worktrees)
            if not ok then
                vim.notify("Git worktree extension not available", vim.log.levels.WARN)
            end
        end, silent)
        vim.keymap.set("n", "<Leader>fR", function()
            local ok, _ = pcall(require("telescope").extensions.git_worktree.create_git_worktree)
            if not ok then
                vim.notify("Git worktree extension not available", vim.log.levels.WARN)
            end
        end, silent)
        vim.keymap.set("n", "<Leader>fn", function()
            local ok, _ = pcall(require("telescope").extensions.notify.notify)
            if not ok then
                vim.notify("Notify extension not available", vim.log.levels.WARN)
            end
        end, silent)
    end
}
