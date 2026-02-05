return {
	"nvim-neorg/neorg",
	-- lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	-- version = "*", -- Pin Neorg to the latest stable release
	-- config = true,
	build = ":Neorg sync-parsers",
	dependencies = { "nvim-lua/plenary.nvim" },
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
						journal_folder = vim.fn.expand("/journal"), -- absolute path
						-- or: vim.fn.stdpath('data') .. "/neorg/journal"
					},
				},
			},
		})

		vim.wo.foldlevel = 99
		vim.wo.conceallevel = 2
	end,
}
