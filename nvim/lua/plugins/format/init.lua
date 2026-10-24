-- File formatting
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "Conform: Code format",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable automatic formatting for certain languages
			local disable_filetypes = {}
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end
		end,
		formatters_by_ft = (function()
			-- Enabled file type formatters, which are set on a per-device basis
			--
			-- To add a new device to the list, create a new configuration derived
			-- from its hostname below. Each new configuration should extend from the
			-- `shared` configuration, ensuring some consistency between devices.
			local hostname = vim.loop.os_gethostname()
			if hostname == "Lauriss-MacBook-Pro-2.local" then
				return require("plugins.format.work")
			elseif hostname == "Lauriss-MacBook-Pro.local" then
				return require("plugins.format.laptop")
			elseif hostname == "Fractal" then
				return require("plugins.format.desktop")
			else
				return require("plugins.format.shared")
			end
		end)(),
	},
}
