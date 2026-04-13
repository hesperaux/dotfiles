--[[
  Roslyn.nvim - C# LSP integration

  NOTE: This plugin uses the new roslyn language server (not OmniSharp).
  Make sure you have the roslyn server installed via Mason or manually.

  If you want to use the new C# LSP features, this is the modern approach.
  However, if you prefer OmniSharp, you can disable this plugin.

  For installation:
  - Mason: :MasonInstall roslyn
  - Or manually: dotnet tool install --global microsoft.codeanalysis.languageserver

  The official repo is now at: seblj/roslyn.nvim (the jmederosalvarado fork is old)
--]]
return {
    "seblj/roslyn.nvim",
    ft = { "cs", "csproj", "sln", "props", "targets" },
    opts = {
        -- Configuration options
        config = {
            -- Your roslyn-specific settings here
            settings = {
                ["csharp|inlay_hints"] = {
                    dotnet_enable_inlay_hints_for_parameters = true,
                    dotnet_enable_inlay_hints_for_literal_parameters = true,
                    dotnet_enable_inlay_hints_for_indexer_parameters = true,
                    dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                    dotnet_enable_inlay_hints_for_other_parameters = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                },
                ["csharp|code_lens"] = {
                    dotnet_enable_references_code_lens = true,
                },
            },
        },
        -- Choose whether to use the new built-in LSP client or the old one
        -- By default, this will use vim.lsp.start() on nvim 0.11+
    },
}
