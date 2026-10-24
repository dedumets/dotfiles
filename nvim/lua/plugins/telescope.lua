-- Modal fuzzy-finder
return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-telescope/telescope-file-browser.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			pickers = {
				find_files = {
					find_command = { "rg", "--ignore", "--follow", "--files" },
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				file_browser = {
					hidden = true,
					noignore = true,
					respect_gitignore = false,
				},
			},
		})

		-- Enable Telescope extensions
		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")
		pcall(telescope.load_extension, "file_browser")

		-- Utility function for creating keymaps
		local function map(mode, l, r, desc)
			vim.keymap.set(mode, l, r, { desc = "Telescope: " .. desc })
		end

		-- Configure Telescope-specific keymaps
		local builtin = require("telescope.builtin")
		map("n", "<leader>fh", builtin.help_tags, "Find help")
		map("n", "<leader>fk", builtin.keymaps, "Find keymaps")
		map("n", "<leader>ff", builtin.find_files, "Find files")
		map("n", "<leader>fb", ":Telescope file_browser<CR>", "Find by file browser")
		map(
			"n",
			"<leader>fB",
			":Telescope file_browser path=%:p:h select_buffer=true<CR>",
			"Find by file browser relative to buffer"
		)
		map("n", "<leader>fw", builtin.grep_string, "Find current word")
		map("n", "<leader>fg", builtin.live_grep, "Find by grep")
		map("n", "<leader>fd", builtin.diagnostics, "Find diagnostics")
		map("n", "<leader>f.", builtin.oldfiles, "Find recent files")
		map("n", "<leader><leader>", function()
			builtin.buffers({ ignore_current_buffer = true, sort_lastused = true })
		end, "find buffers")
		map("n", "<leader>fn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, "Find Neovim files")
	end,
}
