return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/neotest-jest",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = "jest.config.js",
					env = { CI = true },
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				}),
			},
		})

		local neotest = require("neotest")

		-- Run the nearest test
		vim.keymap.set("n", "<leader>tn", function()
			neotest.run.run()
		end, { noremap = true, desc = "Run nearest test" })

		-- Run the current file
		vim.keymap.set("n", "<leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { noremap = true, desc = "Run file tests" })

		-- Run all tests
		vim.keymap.set("n", "<leader>ta", function()
			neotest.run.run({ suite = true })
		end, { noremap = true, desc = "Run all tests" })

		-- Toggle test output
		vim.keymap.set("n", "<leader>to", function()
			neotest.output.open({ enter = true })
		end, { noremap = true, desc = "Toggle test output" })

		-- Jump to next/prev test
		vim.keymap.set("n", "<leader>tj", function()
			neotest.jump.next()
		end, { noremap = true, desc = "Jump to next test" })

		vim.keymap.set("n", "<leader>tk", function()
			neotest.jump.prev()
		end, { noremap = true, desc = "Jump to previous test" })

		-- Open the summary window
		vim.keymap.set("n", "<leader>ts", function()
			neotest.summary.toggle()
		end, { noremap = true, desc = "Toggle test summary" })

		-- Debug nearest test (requires nvim-dap)
		vim.keymap.set("n", "<leader>td", function()
			neotest.run.run({ strategy = "dap" })
		end, { noremap = true, desc = "Debug nearest test" })

		-- Stop test run
		vim.keymap.set("n", "<leader>tx", function()
			neotest.run.stop()
		end, { noremap = true, desc = "Stop test run" })
	end,
}
