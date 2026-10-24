return {
	-- Lua language server, specializing in the Neovim API
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	-- Main LSP configuration for individual plugins and LSPs to work together
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			{ "mason-org/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local telescope = require("telescope.builtin")

					-- Utility function for auto-generating keymaps
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- View code actions
					map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })

					-- Display a hint about the word under the cursor
					map("K", vim.lsp.buf.hover, "Hint")

					-- Rename the variable under the cursor
					map("grn", vim.lsp.buf.rename, "Rename")

					-- Find references for the word under the cursor
					map("gr", telescope.lsp_references, "Goto references")

					-- Find implementations of the word under the cursor
					map("gi", telescope.lsp_implementations, "Goto implementation")

					-- Jump to the definition of the word under the cursor
					map("gd", telescope.lsp_definitions, "Goto definition")

					-- Jump to the declaration of the word under the cursor
					map("gD", vim.lsp.buf.declaration, "Goto declaration")

					-- Jump to the type of the word under your cursor
					map("gt", telescope.lsp_type_definitions, "type definition")

					-- Fuzzy find symbols in the buffer
					map("gS", telescope.lsp_document_symbols, "Document symbols")

					-- Fuzzy find symbols in the workspace
					map("gW", telescope.lsp_dynamic_workspace_symbols, "Workspace symbols")

					-- Highlight references to the current word within the open buffer
					-- when the cursor stays in place for some amount of time.
					--
					-- The first autocommand takes care of highlighting after some idling,
					-- the second autocommand clears the highlighting when the cursor moves.
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
					then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- Toggle inlay hints
					if
						client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle inlay hints")
					end
				end,
			})

			-- Diagnostics
			--  See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			-- Enabled language servers, which are set on a per-device basis
			--
			-- To add a new device to the list, create a new configuration derived
			-- from its hostname below. Each new configuration should extend from the
			-- `shared` LSP configuration, ensuring some consistency between devices.
			--
			-- The objects support overriding some features of the server:
			--  - cmd (table): Override the command used to start the server
			--  - filetypes (table): Override the associated filetypes for the server
			--  - capabilities (table): Override capabilities; e.g., to disable LSP features
			--  - settings (table): Override the settings passed when initializing
			--
			-- See `:help lspconfig-all` for pre-configured and available LSPs
			local servers
			local hostname = vim.uv.os_gethostname()
			if hostname == "Lauriss-MacBook-Pro.local" then
				servers = require("plugins.lsp.laptop")
			elseif hostname == "Fractal" then
				servers = require("plugins.lsp.desktop")
			elseif hostname == "Lauris-M5.local" then
				servers = require("plugins.lsp.work")
			else
				servers = require("plugins.lsp.shared")
			end

			-- Ensure the servers are always installed
			require("mason-lspconfig").setup({ ensure_installed = servers })

			-- Configure each server with their specific configuration
			for server_name, server_config in pairs(servers) do
				vim.lsp.config(server_name, server_config)
			end

			-- Enable all installed LSP servers
			for _, lsp in pairs(servers) do
				vim.lsp.enable(lsp)
			end
		end,
	},
}
