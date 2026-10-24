-- Visual and keymap utilities for working with Git
return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		signs_staged = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		current_line_blame_opts = {
			-- Configured for quick scanning of files, but not enabled by default
			-- Toggle to enable blame with '<leader>tb'
			virt_text_pos = "right_align",
			delay = 0,
		},
		on_attach = function()
			local gitsigns = require("gitsigns")

			-- Utility function for setting keymaps
			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { desc = "Git: " .. desc })
			end

			-- [[ Navigation ]]
			map("n", "]h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]h", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, "jump to next hunk")
			map("n", "[h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[h", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, "jump to previous hunk")

			-- [[ Actions ]]
			map("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage hunk")
			map("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset hunk")
			map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
			map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
			map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
			map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")
			map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
			map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Inline preview hunk")
			map("n", "<leader>hb", gitsigns.blame_line, "Blame line")
			map("n", "<leader>hd", gitsigns.diffthis, "Diff index")
			map("n", "<leader>hD", function()
				gitsigns.diffthis("@")
			end, "Diff commit")
			map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle line blame")
		end,
	},
}
