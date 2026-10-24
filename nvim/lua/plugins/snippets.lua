-- Autocompletion snippets
return {
	"hrsh7th/nvim-cmp",
	dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		cmp.setup({
			snippet = {
				expand = function(a)
					require("luasnip").lsp_expand(a.body)
				end,
			},
			sources = { { name = "nvim_lsp" }, { name = "luasnip" } },
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif cmp.visible() then
						cmp.confirm({ select = true })
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
		})
	end,
}
