-- Highlighter, navigator, and syntax highlighter for code
--  See `:help nvim-treesitter`

-- List of filetypes that should always be setup for use with Treesitter
local ensure_installed = {
	"lua",
	"markdown",
}

-- The main function that configures treesitter within a buffer
local ts_init = function()
	-- Highlighting
	vim.treesitter.start()
	-- Indentation
	vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

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

			-- Always installed Treesitter parsers
			ts.install(ensure_installed)

			-- Main Treesiter setup for functionality in an open buffer
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "<filetype>" },
				callback = ts_init,
			})

			-- Auto-install parsers for any file types that aren't always installed
			vim.api.nvim_create_autocmd("BufRead", {
				callback = function(event)
					local bufnr = event.buf
					local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

					if filetype == "" then
						return
					end

					-- Skip if always installed
					if vim.tbl_contains(ensure_installed, filetype) then
						return
					end

					local parser_name = vim.treesitter.language.get_lang(filetype)
					if not parser_name then
						return
					end

					local parser_configs = require("nvim-treesitter.parsers")
					if not parser_configs[parser_name] then
						return
					end

					local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

					if not parser_installed then
						require("nvim-treesitter").install({ parser_name }):wait(30000)
					end

					parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

					if parser_installed then
						ts_init()
					end
				end,
			})

			-- Auto-update parsers when Treesitter updates
			vim.api.nvim_create_autocmd("PackChanged", {
				callback = function(ev)
					local name, kind = ev.data.spec.name, ev.data.kind
					if name == "nvim-treesitter" and kind == "update" then
						if not ev.data.active then
							vim.cmd.packadd("nvim-treesitter")
						end
						vim.cmd("TSUpdate")
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
