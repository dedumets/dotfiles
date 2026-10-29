-- Highlight selection when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Update the `updated` Markdown frontmatter tag with the current time on save
-- This is primarily used with `zk`, but, obviously, works with other Markdown files too.
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.md",
	callback = function(args)
		local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
		local in_frontmatter = false

		for i, line in ipairs(lines) do
			if line:match("^%-%-%-$") then
				if not in_frontmatter then
					in_frontmatter = true
				else
					break
				end
			elseif in_frontmatter and line:match("^updated:%s") then
				local new_line = "updated: " .. os.date("%Y-%m-%d %H:%M")
				vim.api.nvim_buf_set_lines(args.buf, i - 1, i, false, { new_line })
				return
			end
		end
	end,
})
