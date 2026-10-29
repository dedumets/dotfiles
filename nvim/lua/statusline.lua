local signs = {
	[vim.diagnostic.severity.ERROR] = "",
	[vim.diagnostic.severity.WARN] = "",
	[vim.diagnostic.severity.INFO] = "",
	[vim.diagnostic.severity.HINT] = "",
}

-- Retrieve the corresponding Nerd Font icon for the current buffer on-demand.
--
-- Adapted from Lualine
-- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/filetype.lua
local function file_type_icon()
	local icon
	local ok, devicons = pcall(require, "nvim-web-devicons")

	if ok then
		icon = devicons.get_icon(vim.fn.expand("%:t"))
		if icon == nil then
			icon = devicons.get_icon_by_filetype(vim.bo.filetype)
		end
		if icon == nil then
			icon = ""
		end
		if icon then
			icon = icon .. " "
		end
	else
		ok = vim.fn.exists("*WebDevIconsGetFileTypeSymbol")
		if ok ~= 0 then
			icon = vim.fn.WebDevIconsGetFileTypeSymbol()
			if icon then
				icon = icon .. " "
			end
		end
	end

	return icon
end

-- Get the current diagnostics count in the active buffer, indexed by the severity.
--
-- Adapted from Lualine
-- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/diagnostics/sources.lua
local function diagnostic_count()
	local count = { 0, 0, 0, 0 }

	-- Neovim >= 0.10.0
	if vim.diagnostic.count ~= nil then
		local diagnostics = vim.diagnostic.count(0)
		count[vim.diagnostic.severity.ERROR] = diagnostics[vim.diagnostic.severity.ERROR] or 0
		count[vim.diagnostic.severity.WARN] = diagnostics[vim.diagnostic.severity.WARN] or 0
		count[vim.diagnostic.severity.INFO] = diagnostics[vim.diagnostic.severity.INFO] or 0
		count[vim.diagnostic.severity.HINT] = diagnostics[vim.diagnostic.severity.HINT] or 0
		return count
	end

	-- Fallback
	local diagnostics = vim.diagnostic.get(0)
	for _, diagnostic in ipairs(diagnostics) do
		count[diagnostic.severity] = count[diagnostic.severity] + 1
	end
	return count
end

-- Retrieve the current Git branch string on-demand.
_G.statusline_gitbranch = function()
	local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
	if string.len(branch) > 0 then
		return string.format(" %s • ", branch)
	else
		return ""
	end
end

-- Retrieve the current buffer's diagnostics string on-demand.
_G.statusline_diagnostics = function()
	local items = {}
	local diagnostics = diagnostic_count()
	for severity, count in ipairs(diagnostics) do
		if count > 0 then
			if #items == 0 then
				table.insert(items, " •")
			end
			table.insert(items, ("%s %s"):format(signs[severity], count))
		end
	end
	return table.concat(items, " ")
end

-- Retrieve the current buffer's filetype string on-demand.
_G.statusline_filetype = function()
	local filetype = vim.bo.filetype
	local icon = file_type_icon()

	if filetype == "" then
		return ""
	end

	if icon and icon ~= "" then
		return icon .. filetype .. " • "
	end

	return filetype .. " • "
end

-- Get the format of the left side of the status line.
local function left()
	local branch = "%{v:lua.statusline_gitbranch()}"
	local file_name = "%f"
	local modified = "%m"
	local diagnostics = "%{v:lua.statusline_diagnostics()}"
	return string.format("%s%s%s%s", branch, file_name, modified, diagnostics)
end

-- Get the format of the right side of the status line.
local function right()
	local fileencoding = "%{&fileencoding?&fileencoding:&encoding} • "
	local fileformat = "%{&fileformat} • "
	local filetype = "%{v:lua.statusline_filetype()}"
	local linecol = "%l:%c"
	return string.format("%s%s%s%s", fileencoding, fileformat, filetype, linecol)
end

-- Get the format of the status line.
local function statusline()
	local color = "%#LineNr#"
	local align_right = "%="
	return string.format("%s %s%s%s ", color, left(), align_right, right())
end

vim.opt.statusline = statusline()
