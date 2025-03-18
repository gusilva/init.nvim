return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "javascript", "sql", "plsql" }, lazy = true },
	},
	ft = { "javascript", "sql", "plsql" },
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_win_position = "right"
		vim.g.db_ui_save_location = "~/db_ui_queries"
		vim.g.db_ui_execute_on_save = 0
		vim.o.filetype = "javascript"

		vim.g.db_ui_is_oracle_legacy = 1
	end,
	config = function()
		vim.keymap.set("n", "<leader>du", "<CMD>DBUIToggle<CR>")
		vim.keymap.set("n", "<leader>dl", "<CMD>DBUILastQueryInfo<CR>")

		vim.o.filetype = "javascript"
		-- vim.api.nvim_create_autocmd("FileType", {
		-- 	pattern = {
		-- 		"javascript",
		-- 	},
		-- 	command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
		-- })

		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"sql",
				"plsql",
				"javascript",
			},
			callback = function()
				vim.schedule(function()
					require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
				end)
			end,
		})
		-- nnoremap <silent> <leader>du :DBUIToggle<CR>
		-- nnoremap <silent> <leader>df :DBUIFindBuffer<CR>
		-- nnoremap <silent> <leader>dr :DBUIRenameBuffer<CR>
		-- nnoremap <silent> <leader>dl :DBUILastQueryInfo<CR>
	end,
}
