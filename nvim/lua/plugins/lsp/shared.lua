-- Shared LSP configuration across all devices.
--
-- This should probably stick to Lua only, since using Vim
-- implies Lua is needed, which can't be guaranteed elsewhere.
return {
	lua_ls = {
		settings = {
			Lua = {
				completion = { callSnippet = "Replace" },
				diagnostics = {
					globals = { "vim" },
					disable = { "missing-fields" },
				},
			},
		},
	},
}
