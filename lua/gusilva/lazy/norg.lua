return {
	"nvim-neorg/neorg",
	-- lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	-- version = "*", -- Pin Neorg to the latest stable release
	-- config = true,
	build = ":Neorg sync-parsers",
	dependencies = {
		{ "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
		{ "nvim-lua/plenary.nvim" },
	},
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/Sync",
						},
						default_workspace = "notes",
					},
				},
				["core.journal"] = {
					config = {
						journal_folder = vim.fn.stdpath("data") .. "/neorg/journal", -- absolute path
						-- or: vim.fn.stdpath('data') .. "/neorg/journal"
						-- strategy = "flat", -- or "nested"
						use_templates = false,
					},
				},
				["external.templates"] = {
					config = {
						-- templates_dir = vim.fn.stdpath("config") .. "/templates/norg",
						-- default_subcommand = "add", -- or "fload", "load"
						keywords = { -- Add your own keywords.
							TODAY_OF_ORG = function() -- detect date from filename and return in org date format
								local ls = require("luasnip")
								local s = require("neorg.modules.external.templates.default_snippets")
								return ls.text_node(s.parse_date(0, s.file_name_date(), [[%Y-%m-%d]])) -- 2006-11-01
							end,
							TITLE_TODAY = function()
								local ls = require("luasnip")
								local s = require("neorg.modules.external.templates.default_snippets")
								return ls.text_node(s.parse_date(0, s.file_name_date(), [[%a, %d %b %Y]])) -- Fri, 06 Feb 2026
							end,
							NOW_IN_DATETIME = function() -- print current date+time of invoke
								local ls = require("luasnip")
								local s = require("neorg.modules.external.templates.default_snippets")
								return ls.text_node(s.parse_date(0, os.time(), [[%Y-%m-%d %a %X]])) -- 2023-11-01 Wed 23:48:10
							end,
						},
						-- snippets_overwrite = {},
					},
				},
				-- ["core.keybinds"] = {
				-- 	config = {
				-- 		-- default_keybinds = false, -- disable default neorg keybinds
				-- 		hook = function(keybinds)
				-- 			-- mode, lhs, rhs (rhs can be a command string)
				-- 			keybinds.map("n", "<leader>nn", "<cmd>Neorg index<CR>")
				-- 			keybinds.map("n", "<leader>nj", "<cmd>Neorg journal<CR>")
				-- 			keybinds.map("n", "<leader>nt", "<cmd>Neorg toc<CR>")
				-- 		end,
				-- 	},
				-- },
			},
		})

		vim.wo.foldlevel = 99
		vim.wo.conceallevel = 2
	end,
}
