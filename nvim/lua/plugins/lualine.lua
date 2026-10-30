-- Every mode has the same, minimal look to match my Tmux statusline.
local theme_variant = { bg = "#202020", fg = "#565656" }
local theme_entry = { a = theme_variant, b = theme_variant, c = theme_variant }

local COMPONENT = {
	LEFT_PADDING = "left-padding",
	LEFT_MODE = "left-mode",
	LEFT_BRANCH = "left-branch",
	LEFT_DIFF = "left-diff",
	LEFT_DIAGNOSTICS = "left-diagnostics",
	CENTER_FILENAME = "center-filename",
	RIGHT_ENCODING = "right-encoding",
	RIGHT_FILEFORMAT = "right-fileformat",
	RIGHT_FILETYPE = "right-filetype",
	RIGHT_LOCATION = "right-location",
	RIGHT_PADDING = "right-padding",
}

local components = {
	COMPONENT.LEFT_PADDING,
	COMPONENT.LEFT_MODE,
	COMPONENT.LEFT_BRANCH,
	COMPONENT.LEFT_DIFF,
	COMPONENT.LEFT_DIAGNOSTICS,
	COMPONENT.CENTER_FILENAME,
	COMPONENT.RIGHT_ENCODING,
	COMPONENT.RIGHT_FILEFORMAT,
	COMPONENT.RIGHT_FILETYPE,
	COMPONENT.RIGHT_LOCATION,
	COMPONENT.RIGHT_PADDING,
}

-- Calculate and store total width of each component.
local component_widths = {}
local function store_width(str, component)
	if not str or str == "" then
		component_widths[component] = 0
		return str
	end

	local evaluated = vim.api.nvim_eval_statusline(str, {}).str
	component_widths[component] = vim.fn.strdisplaywidth(evaluated)

	return str
end

-- An empty space as a custom component function, since a raw string empty
-- space ends up getting stripped from the Lualine.
--
-- Used to guarantee padding on the far left and far right of the Lualine,
-- regardless of what component ends up being rendered.
local function padding()
	return " "
end

-- Manual mode component as an override to use bracketed, lowercased names.
--
-- Adapted from the cosmicink example
-- https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/cosmicink.lua
local function mode()
	local mode_map = {
		n = "normal", -- Normal
		i = "insert", -- Insert
		v = "visual", -- Visual
		[""] = "visual", -- Visual Block
		V = "visual", -- Visual Line
		c = "command", -- Command-line
		no = "N", -- NInsert
		s = "select", -- Select
		S = "select", -- Select Line
		ic = "insert", -- Insert (completion)
		R = "replace", -- Replace
		Rv = "replace", -- Virtual Replace
		cv = "command", -- Command-line
		ce = "command", -- Ex
		r = "replace", -- Prompt
		rm = "more", -- More
		["r?"] = "confirm", -- Confirm
		["!"] = "shell", -- Shell
		t = "terminal", -- Terminal
	}
	return "[" .. (mode_map[vim.fn.mode()] or "unknown") .. "]"
end

-- Component to fill space evenly between left side of the terminal and the middle.
local function fill_space()
	local used_width = 0
	local center_width = component_widths[COMPONENT.CENTER_FILENAME] or 0
	local terminal_width = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)

	-- Calculate used up space by the left-side components.
	for _, component in ipairs(components) do
		if component == COMPONENT.CENTER_FILENAME then
			break
		end
		local width = component_widths[component] or 0
		used_width = used_width + width
	end

	-- Account for the separators on all left-side components.
	local separator_width = vim.fn.strdisplaywidth(" • ")
	for _, component in ipairs(components) do
		if component == COMPONENT.CENTER_FILENAME then
			break
		end
		local width = component_widths[component] or 0
		if width > 0 and component ~= COMPONENT.LEFT_PADDING then
			used_width = used_width + separator_width
		end
	end

	-- Add spaces between the last left-side component and the filename component.
	local filler_width = math.floor((terminal_width - center_width) / 2) - used_width + 1
	return string.rep(" ", math.max(0, filler_width))
end

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			-- set an empty statusline till lualine loads
			vim.o.statusline = " "
		else
			-- hide the statusline on the starter page
			vim.o.laststatus = 0
		end
	end,
	opts = function()
		local lualine_require = require("lualine_require")
		lualine_require.require = require
		vim.o.laststatus = vim.g.lualine_laststatus
		local opts = {
			options = {
				globalstatus = vim.o.laststatus == 3,
				component_separators = { left = " • ", right = " • " },
				section_separators = { left = "", right = "" },
				padding = 0,
				theme = {
					normal = theme_entry,
					insert = theme_entry,
					visual = theme_entry,
					replace = theme_entry,
					command = theme_entry,
					inactive = theme_entry,
				},
			},
			sections = {
				lualine_a = {
					{
						padding,
						separator = "",
						fmt = function(str)
							return store_width(str, COMPONENT.LEFT_PADDING)
						end,
					},
					{
						mode,
						fmt = function(str)
							return store_width(str, COMPONENT.LEFT_MODE)
						end,
					},
					{
						"branch",
						icon = "",
						fmt = function(str)
							return store_width(str, COMPONENT.LEFT_BRANCH)
						end,
					},
					{
						"diff",
						colored = false,
						fmt = function(str)
							return store_width(str, COMPONENT.LEFT_DIFF)
						end,
					},
					{
						"diagnostics",
						colored = false,
						fmt = function(str)
							return store_width(str, COMPONENT.LEFT_DIAGNOSTICS)
						end,
					},
				},
				lualine_b = {},
				lualine_c = {
					{ fill_space, separator = "" },
					{
						"filename",
						path = 1,
						fmt = function(str)
							return store_width(str, COMPONENT.CENTER_FILENAME)
						end,
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{
						"encoding",
						fmt = function(str)
							return store_width(str, COMPONENT.RIGHT_ENCODING)
						end,
					},
					{
						"fileformat",
						symbols = { unix = "unix", dos = "dos", mac = "mac" },
						fmt = function(str)
							return store_width(str, COMPONENT.RIGHT_FILEFORMAT)
						end,
					},
					{
						"filetype",
						colored = false,
						fmt = function(str)
							return store_width(str, COMPONENT.RIGHT_FILETYPE)
						end,
					},
					{
						"%l:%c", -- `location` but with no pre-allocated space for digits
						separator = "",
						fmt = function(str)
							return store_width(str, COMPONENT.RIGHT_LOCATION)
						end,
					},
					{
						padding,
						fmt = function(str)
							return store_width(str, COMPONENT.RIGHT_PADDING)
						end,
					},
				},
			},
		}
		return opts
	end,
}
