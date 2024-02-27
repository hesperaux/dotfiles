return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				-- null_ls.builtins.formatting.beautysh,
				null_ls.builtins.formatting.black,
				-- null_ls.builtins.formatting.clang_format,
				null_ls.builtins.formatting.csharpier,
				null_ls.builtins.formatting.sql_formatter,
				null_ls.builtins.formatting.rustywind,
				null_ls.builtins.formatting.djlint,
				null_ls.builtins.formatting.prettier,
				-- null_ls.builtins.diagnostics.eslint_d,
				null_ls.builtins.diagnostics.cmake_lint,
				-- null_ls.builtins.diagnostics.cpplint,
				null_ls.builtins.diagnostics.djlint,
				null_ls.builtins.diagnostics.trivy,
				-- null_ls.builtins.diagnostics.jsonlint,
			},
		})
	end,
}
