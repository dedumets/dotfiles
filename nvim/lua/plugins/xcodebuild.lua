if vim.fn.has("macunix") then
	return {
		"wojciech-kulik/xcodebuild.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("xcodebuild").setup()
			vim.lsp.enable("sourcekit")
		end,
	}
else
	return {}
end
