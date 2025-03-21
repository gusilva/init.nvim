-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	-- NOTE: Yes, you can install new plugins here!
	"mfussenegger/nvim-dap",
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- Add your own debuggers here
		"leoluz/nvim-dap-go",

		-- telescope dap
		"nvim-telescope/telescope-dap.nvim",

		-- add debug description text
		"theHamsta/nvim-dap-virtual-text",

		-- add nio
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_go = require("dap-go")

		-- Install golang specific config
		dap_go.setup({
			-- Additional dap configurations can be added.
			-- dap_configurations accepts a list of tables where each entry
			-- represents a dap configuration. For more details do:
			-- :help dap-configuration
			dap_configurations = {
				{
					-- Must be "go" or it will be ignored by the plugin
					type = "go",
					name = "Attach remote",
					mode = "remote",
					request = "attach",
				},
			},
			-- delve configurations
			delve = {
				-- the path to the executable dlv which will be used for debugging.
				-- by default, this is the "dlv" executable on your PATH.
				path = "dlv",
				-- time to wait for delve to initialize the debug session.
				-- default to 20 seconds
				initialize_timeout_sec = 20,
				-- a string that defines the port to start delve debugger.
				-- default to string "${port}" which instructs nvim-dap
				-- to start the process in a random available port
				-- port = "2345",
				-- additional args to pass to dlv
				-- port = "${port}",
				args = {},
				build_flags = "-v -tags=unit,integration,e2e,end2end",
				detached = vim.fn.has("win32") == 0,
			},
			tests = {
				verbose = true,
			},
		})

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		-- dapui.setup()
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
			-- Layouts define sections of the screen to place windows.
			-- The position can be "left", "right", "top" or "bottom".
			-- The size specifies the height/width depending on position. It can be an Int
			-- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
			-- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
			-- Elements are the elements shown in the layout (in order).
			-- Layouts are opened in order so that earlier layouts take priority in window sizing.
			layouts = {
				{
					elements = {
						-- Elements can be strings or table with id and size keys.
						{ id = "scopes", size = 0.80 },
						{ id = "breakpoints", size = 0.10 },
						{ id = "watches", size = 0.10 },

						-- "breakpoints",
						-- "stacks",
						-- "watches",
					},
					size = 50, -- 40 columns
					position = "left",
				},
				{
					elements = {
						"repl",
						-- "console",
					},
					size = 0.15, -- 25% of total lines
					position = "bottom",
				},
			},
		})

		-- require('nvim-dap-virtual-text').setup()
		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_setup = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"delve",
			},
		})

		-- Basic debugging keymaps, feel free to change to your liking!
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "dap run/continue debug" })
		-- vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "dap run/continue debug" })
		vim.keymap.set("n", "<F4>", dap.terminate, { desc = "dap stop debug" })
		vim.keymap.set("n", "<F1>", dap.step_into, { desc = "dap step into" })
		vim.keymap.set("n", "<F2>", dap.step_over, { desc = "dap step over" })
		-- vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "dap step over" })
		vim.keymap.set("n", "<F3>", dap.step_out, { desc = "dap step out" })
		-- vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'dap open repl' })
		vim.keymap.set("n", "<leader>td", dap_go.debug_test, { desc = "dap debug test" })
		vim.keymap.set("n", "<leader>tl", dap_go.debug_last_test, { desc = "dap debug last test" })
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "dap toggle breakpoint" })
		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "dap breakpoint condition" })

		-- toggle to see last session result. Without this ,you can't see session output in case of unhandled exception.
		vim.keymap.set("n", "<leader>tt", dapui.toggle)
		vim.keymap.set("n", "<leader>tr", function()
			dapui.open({ reset = true })
		end, { desc = "dap reset ui" })
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		-- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
		-- dap.listeners.before.event_exited['dapui_config'] = dapui.close
	end,
}
