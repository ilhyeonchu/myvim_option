local M = {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
	},
}

M.config = function()
	local cmp = require("cmp")
	vim.opt.completeopt = { "menu", "menuone", "noselect" }

	local kind_icons = {
		-- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations
		Text = " ",
		Method = "󰆧",
		Function = "ƒ ",
		Constructor = " ",
		Field = "󰜢 ",
		Variable = " ",
		Constant = " ",
		Class = " ",
		Interface = "󰜰 ",
		Struct = " ",
		Enum = "了 ",
		EnumMember = " ",
		Module = "",
		Property = " ",
		Unit = " ",
		Value = "󰎠 ",
		Keyword = "󰌆 ",
		Snippet = " ",
		File = " ",
		Folder = " ",
		Color = " ",
	}

	cmp.setup({
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		window = {
			-- completion = cmp.config.window.bordered(),
			-- documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
            -- Tab 기능
            ["<Tab>"] = cmp.mapping(function (fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then
                    cmp.confirm({ select = true })
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),

            -- Shift-Tab 기능 (스니펫 이전 점프를 위해 추가)
            ["<S-Tab>"] = cmp.mapping(function (fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),

            -- Enter: 항상 새 줄
            ["<CR>"] = cmp.mapping(function (fallback)
                if cmp.visible() then
                    cmp.abort()
                end
                fallback()
            end, { "i", "s" }),

			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			-- ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = "luasnip" }, -- For luasnip users.
		}, {
			{ name = "buffer" },
			{ name = "path" },
		}, {
			{ name = "neorg" },
		}),

		formatting = {
			format = function(entry, vim_item)
				-- Kind icons
				vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
				-- Source
				vim_item.menu = ({
					buffer = "[Buffer]",
					nvim_lsp = "[LSP]",
					luasnip = "[LuaSnip]",
					nvim_lua = "[NvimAPI]",
					path = "[Path]",
				})[entry.source.name]
				return vim_item
			end,
		},
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})
end

return M
