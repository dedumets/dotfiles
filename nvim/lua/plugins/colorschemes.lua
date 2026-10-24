-- Meta definition of the colorschemes to install:
-- `repo` defines the plugins name for lazy.nvim
-- `variants` defines the possible colorschemes to enable
local plugins = {
	{
		repo = "dedumets/alabaster.nvim",
		variants = { "alabaster" },
	},
}

-- The active colorscheme to use.
-- Setting this to the correct value ensures lazy.nvim prioritizes it.
local colorscheme = "alabaster"

-- All colorschemes that should be installed.
local colorschemes = {}

for _, plugin in pairs(plugins) do
	local scheme = { plugin.repo, lazy = true }
	for _, variant in pairs(plugin.variants) do
		if colorscheme == variant then
			scheme["lazy"] = false
			scheme["priority"] = 1000
			scheme["config"] = function()
				vim.cmd("colorscheme " .. colorscheme)
			end
		end
	end
	table.insert(colorschemes, scheme)
end

return colorschemes
