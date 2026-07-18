return {
	"wojciech-kulik/xcodebuild.nvim",
	ft = { "swift" },
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-tree.lua", -- or neo-tree if you prefer
		"nvim-treesitter/nvim-treesitter",
		"mfussenegger/nvim-dap",
	},
	config = function()
		require("xcodebuild").setup({
			code_coverage = { enabled = true },
		})

		local map = vim.keymap.set
		map("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Xcode logs" })
		map("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build" })
		map("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build + run" })
		map("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run tests" })
		map("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Test class" })
		map("n", "<leader>xp", "<cmd>XcodebuildPicker<cr>", { desc = "Action picker" })
		map("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select device" })
		map("n", "<leader>xs", "<cmd>XcodebuildSelectScheme<cr>", { desc = "Select scheme" })
		map("n", "<leader>xq", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix" })
	end,
}
