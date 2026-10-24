local base = require("plugins.format.shared")

-- Personal 14" M1 MacBook Pro
return vim.tbl_extend("force", base, {
	python = {
		"ruff_fix",
		"ruff_format",
		"ruff_organize_imports",
	},
})
