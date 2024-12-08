return {
	"jellydn/hurl.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- Optional, for markdown rendering with render-markdown.nvim
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown" },
			},
			ft = { "markdown", "rest", "http" },
		},
	},
	ft = "hurl",
	opts = {
		-- Show debugging info
		debug = false,
		-- Show notification on run
		show_notification = true,
		-- Show response in popup or split
		mode = "split",
		-- Default formatter
		formatters = {
			json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
			html = {
				"prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
				"--parser",
				"html",
			},
			xml = {
				"tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
				"-xml",
				"-i",
				"-q",
			},
		},
		-- Default mappings for the response popup or split views
		mappings = {
			close = "q", -- Close the response popup or split view
			next_panel = "<C-n>", -- Move to the next response popup window
			prev_panel = "<C-p>", -- Move to the previous response popup window
		},
	},
	keys = {
		-- Run API request
		{ "<leader>hiA", "<cmd>HurlRunner --insecure<CR>", desc = "Run All requests" },
		{ "<leader>hA", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
		{ "<leader>hia", "<cmd>HurlRunnerAt --insecure<CR>", desc = "Run Api request" },
		{ "<leader>ha", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
		{ "<leader>he", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
		{ "<leader>hE", "<cmd>HurlRunnerToEnd<CR>", desc = "Run Api request from current entry to end" },
		{ "<leader>hv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
		{ "<leader>hV", "<cmd>HurlVeryVerbose<CR>", desc = "Run Api in very verbose mode" },
		{ "<leader>hr", "<cmd>HurlRerun<CR>", desc = "Rerun last command" },
		-- Run Hurl request in visual mode
		{ "<leader>hih", ":HurlRunner --insecure<CR>", desc = "Hurl Runner", mode = "v" },
		{ "<leader>hh", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
		-- Show last response
		{ "<leader>hh", "<cmd>HurlShowLastResponse<CR>", desc = "History", mode = "n" },
		-- Manage variable
		{ "<leader>hg", ":HurlSetVariable", desc = "Add global variable" },
		{ "<leader>hG", "<cmd>HurlManageVariable<CR>", desc = "Manage global variable" },
		-- Toggle
		{ "<leader>ht", "<cmd>HurlToggleMode<CR>", desc = "Toggle Hurl Split/Popup" },
	},
}
