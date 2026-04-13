return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")
        local sources = {}

        -- Only add sources for tools that are likely to be installed
        -- Check if command exists before adding source
        local function command_exists(cmd)
            return vim.fn.executable(cmd) == 1
        end

        -- Formatters (only add if tool exists)
        if command_exists("stylua") then
            table.insert(sources, null_ls.builtins.formatting.stylua)
        end
        if command_exists("black") then
            table.insert(sources, null_ls.builtins.formatting.black)
        end
        if command_exists("prettier") then
            table.insert(sources, null_ls.builtins.formatting.prettier)
        end

        -- Diagnostics (only add if tool exists)
        if command_exists("cmake-lint") or command_exists("cmake_lint") then
            table.insert(sources, null_ls.builtins.diagnostics.cmake_lint)
        end

        null_ls.setup({
            sources = sources,
            -- Disable autoformat on save to avoid errors
            on_attach = function(client, bufnr)
                -- Don't autoformat, let user trigger manually
            end,
        })
    end,
}
