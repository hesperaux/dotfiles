-- DISABLED: This plugin conflicts with nvim-cmp which is your main completion engine.
-- You're using nvim-cmp with minuet-ai, luasnip, and cmp-nvim-lsp.
-- If you want to use coq instead, disable completions.lua and enable this one.
return {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    enabled = false, -- Disabled to avoid conflict with nvim-cmp
    config = function()
    end
}
