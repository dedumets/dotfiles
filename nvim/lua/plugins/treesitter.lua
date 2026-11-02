-- Highlighter, navigator, and syntax highlighter for code
--  See `:help nvim-treesitter`

-- List of filetypes that should always be setup
local ensure_installed = {
	"lua",
	"markdown",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			local ts = require("nvim-treesitter")

			-- Ensure mandatory parsers are always installed
			ts.install(ensure_installed)

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					-- Check if the buffer is supported by Treesitter
					local lang = vim.treesitter.language.get_lang(ev.match)
					local available_langs = ts.get_available()
					local is_available = vim.tbl_contains(available_langs, lang)
					if is_available then
						local installed_langs = ts.get_installed()
						local installed = vim.tbl_contains(installed_langs, lang)
						-- Auto-install a parser if one is not already installed
						if not installed then
							ts.install(lang):wait()
						end
						-- Enable Treesitter features
						vim.treesitter.start()
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufRead",
		opts = {
			multiwindow = true,
		},
	},
}
