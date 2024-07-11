return {
    'romgrk/barbar.nvim',
    dependencies = {
        'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
        -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
        -- animation = true,
        -- insert_at_start = true,
        -- …etc.

        -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
        -- Valid options are 'left' (the default), 'previous', and 'right'
        focus_on_close = 'left',

        -- Disable highlighting alternate buffers
        highlight_alternate = false,

        -- Disable highlighting file icons in inactive buffers
        highlight_inactive_file_icons = false,

        -- Enable highlighting visible buffers
        highlight_visible = true,

        icons = {
            -- Configure the base icons on the bufferline.
            -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
            buffer_index = false,
            buffer_number = false,
            button = '',
            -- Enables / disables diagnostic symbols
            diagnostics = {
                [vim.diagnostic.severity.ERROR] = { enabled = false, icon = ' ' },
                [vim.diagnostic.severity.WARN] = { enabled = false, icon = ' ' },
                [vim.diagnostic.severity.INFO] = { enabled = false },
                [vim.diagnostic.severity.HINT] = { enabled = false },
            },
            gitsigns = {
                added = { enabled = true, icon = '+' },
                changed = { enabled = true, icon = '~' },
                deleted = { enabled = true, icon = '-' },
            },
            filetype = {
                -- Sets the icon's highlight group.
                -- If false, will use nvim-web-devicons colors
                custom_colors = false,

                -- Requires `nvim-web-devicons` if `true`
                enabled = true,
            },
            separator = { left = '', right = '' },

            -- If true, add an additional separator at the end of the buffer list
            separator_at_end = false,

            -- Configure the icons on the bufferline when modified or pinned.
            -- Supports all the base icon options.
            modified = { button = '●' },
            pinned = { button = '', filename = true },

            -- Configure the icons on the bufferline based on the visibility of a buffer.
            -- Supports all the base icon options, plus `modified` and `pinned`.
            alternate = { filetype = { enabled = false } },
            current = { buffer_index = true },
            inactive = { button = '×' },
            visible = { modified = { buffer_number = false } },
        },

        -- If true, new buffers will be inserted at the start/end of the list.
        -- Default is to insert after current buffer.
        insert_at_end = false,
        insert_at_start = false,

        -- Sets the maximum padding width with which to surround each tab
        maximum_padding = 1,

        -- Sets the minimum padding width with which to surround each tab
        minimum_padding = 1,

        -- Sets the maximum buffer name length.
        maximum_length = 30,

        -- Sets the minimum buffer name length.
        minimum_length = 0,

        -- If set, the letters for each buffer in buffer-pick mode will be
        -- assigned based on their name. Otherwise or in case all letters are
        -- already assigned, the behavior is to assign letters in order of
        -- usability (see order below)
        semantic_letters = true,

        -- New buffer letters are assigned in this order. This order is
        -- optimal for the qwerty keyboard layout but might need adjustment
        -- for other layouts.
        letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
}
