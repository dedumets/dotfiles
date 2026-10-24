local base = require("plugins.lsp.shared")

-- Personal 14" M1 MacBook Pro
return vim.tbl_deep_extend("force", base, {
	-- Python
	pylsp = {},
	ruff = {},
})
