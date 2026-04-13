-- Harpoon v2 - Modern file bookmarking
-- Make sure to clean old harpoon data: rm -rf ~/.local/share/nvim/harpoon
return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        -- REQUIRED: Setup harpoon2
        harpoon:setup()

        -- Keymaps for harpoon2 (using new API)
        -- Add file to harpoon list
        vim.keymap.set("n", "<leader>hm", function()
            harpoon:list():add()
            vim.notify("File added to harpoon", vim.log.levels.INFO)
        end, { desc = "[H]arpoon [M]ark file" })

        -- Toggle harpoon quick menu
        vim.keymap.set("n", "<leader>ho", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "[H]arpoon [O]pen menu" })

        -- Navigate through marks
        vim.keymap.set("n", "<leader>hl", function()
            harpoon:list():next()
        end, { desc = "[H]arpoon next (L->right)" })

        vim.keymap.set("n", "<leader>hh", function()
            harpoon:list():prev()
        end, { desc = "[H]arpoon prev (H->left)" })

        -- Quick access to first 4 marks
        vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
        vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
        vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
        vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

        -- Clear any old VimLeave autocommands that might reference old harpoon
        vim.api.nvim_create_autocmd("VimLeave", {
            group = vim.api.nvim_create_augroup("HarpoonCleanup", { clear = true }),
            callback = function()
                -- Force save harpoon data on exit
                pcall(function() harpoon:list():sync() end)
            end,
        })
    end,
}
