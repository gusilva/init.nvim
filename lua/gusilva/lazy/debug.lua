-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

-- Build debug adapters
--
-- vscode-js-debug (for Node.js, React Native Hermes, modern JS debugging)
-- cd ~
-- git clone https://github.com/microsoft/vscode-js-debug.git
-- cd vscode-js-debug
-- npm install --legacy-peer-deps
-- npx gulp dapDebugServer
--
-- vscode-chrome-debug (legacy: for React Native with JSC engine only)
-- cd ~
-- git clone https://github.com/Microsoft/vscode-chrome-debug
-- cd ./vscode-chrome-debug
-- npm install
-- npm run build

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

		-- "mxsdev/nvim-dap-vscode-js",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_go = require("dap-go")

		for _, adapterType in ipairs({ "node", "chrome", "msedge" }) do
			local pwaType = "pwa-" .. adapterType

			dap.adapters[pwaType] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			}

			-- this allow us to handle launch.json configurations
			-- which specify type as "node" or "chrome" or "msedge"
			dap.adapters[adapterType] = function(cb, config)
				local nativeAdapter = dap.adapters[pwaType]

				config.type = pwaType

				if type(nativeAdapter) == "function" then
					nativeAdapter(cb, config)
				else
					cb(nativeAdapter)
				end
			end
		end

		local enter_launch_url = function()
			local co = coroutine.running()
			return coroutine.create(function()
				vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:" }, function(url)
					if url == nil or url == "" then
						return
					else
						coroutine.resume(co, url)
					end
				end)
			end)
		end

		for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file using Node.js (nvim-dap)",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to process using Node.js (nvim-dap)",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
				-- requires ts-node to be installed globally or locally
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file using Node.js with ts-node/register (nvim-dap)",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeArgs = { "-r", "ts-node/register" },
				},
				{
					type = "pwa-chrome",
					request = "launch",
					name = "Launch Chrome (nvim-dap)",
					url = enter_launch_url,
					webRoot = "${workspaceFolder}",
					sourceMaps = true,
					runtimeExecutable = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
				},
				{
					type = "pwa-msedge",
					request = "launch",
					name = "Launch Edge (nvim-dap)",
					url = enter_launch_url,
					webRoot = "${workspaceFolder}",
					sourceMaps = true,
				},
			}
		end
		-- require("dap-vscode-js").setup({
		-- 	-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
		-- 	debugger_path = "/Users/gustavo/vscode-js-debug", -- Path to vscode-js-debug installation.
		-- 	-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
		-- 	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
		-- 	-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
		-- 	-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
		-- 	-- log_file_level = 1, -- Logging level for output to file. Set to false to disable file logging.
		-- 	-- log_console_level = vim.log.levels.TRACE, -- Logging level for output to console. Set to false to disable console output.
		-- })
		-- Point to vscode-js-debug
		-- local js_debug_path = vim.fn.expand("$HOME/vscode-js-debug/dist/src/dapDebugServer.js")
		--
		-- require("dap").adapters["pwa-node"] = {
		-- 	type = "server",
		-- 	host = "localhost",
		-- 	port = "${port}",
		-- 	executable = {
		-- 		command = "node",
		-- 		-- 💀 Make sure to update this path to point to your installation
		-- 		-- args = { "/path/to/js-debug/src/dapDebugServer.js", "${port}" },
		-- 		args = { js_debug_path, "${port}" },
		-- 		-- args = { js_debug_path, "8123" },
		-- 	},
		-- }
		-- for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
		-- 	require("dap").configurations[language] = {
		-- 		-- {
		-- 		-- 	type = "pwa-node",
		-- 		-- 	request = "launch",
		-- 		-- 	name = "Launch file",
		-- 		-- 	program = "${file}",
		-- 		-- 	cwd = "${workspaceFolder}",
		-- 		-- },
		-- 		{
		-- 			type = "pwa-node",
		-- 			request = "launch",
		-- 			name = "Launch file",
		-- 			port = 8123,
		-- 			program = "${file}",
		-- 			cwd = "${workspaceFolder}",
		-- 		},
		-- 		{
		-- 			type = "pwa-node",
		-- 			request = "attach",
		-- 			name = "Attach",
		-- 			processId = require("dap.utils").pick_process,
		-- 			cwd = "${workspaceFolder}",
		-- 		},
		-- 		{
		-- 			type = "pwa-node",
		-- 			request = "launch",
		-- 			-- port = 8123,
		-- 			-- port = 8081,
		-- 			program = "${file}",
		-- 			-- url =
		-- 			-- remote
		-- 			name = "Launch RN with Metro",
		-- 			cwd = "${workspaceFolder}",
		-- 			runtimeExecutable = "npm",
		-- 			runtimeArgs = { "run", "ios" },
		-- 			-- cmd = "npm run ios",
		-- 			console = "integratedTerminal",
		-- 			sourceMaps = true,
		-- 			resolveSourceMapLocations = {
		-- 				"${workspaceFolder}/**",
		-- 				"!**/node_modules/**",
		-- 			},
		-- 			skipFiles = { "<node_internals>/**" },
		-- 			restart = true,
		-- 		},
		--
		-- 		{
		-- 			type = "pwa-node",
		-- 			request = "attach",
		-- 			-- port = 8123,
		-- 			port = 8081,
		-- 			name = "Attach RN with Metro",
		-- 			cwd = "${workspaceFolder}",
		-- 			console = "integratedTerminal",
		-- 			sourceMaps = true,
		-- 			resolveSourceMapLocations = {
		-- 				"${workspaceFolder}/**",
		-- 				"!**/node_modules/**",
		-- 			},
		-- 			skipFiles = { "<node_internals>/**" },
		-- 			restart = true,
		-- 		},
		-- 	}
		-- end
		-- -- Point to vscode-js-debug
		-- local js_debug_path = vim.fn.expand("$HOME/vscode-js-debug/dist/src/dapDebugServer.js")
		--
		-- -- Setup the adapter
		-- dap.adapters["pwa-node"] = {
		-- 	type = "server",
		-- 	host = "localhost",
		-- 	port = "${port}",
		-- 	-- port = 53641,
		-- 	executable = {
		-- 		command = "node",
		-- 		args = { js_debug_path, "${port}" },
		-- 	},
		-- }
		--
		-- -- Debug configurations for JS/TS
		-- local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
		-- for _, ft in ipairs(js_filetypes) do
		-- 	dap.configurations[ft] = {
		-- 		{
		-- 			type = "pwa-node",
		-- 			request = "launch",
		-- 			name = "Launch file",
		-- 			program = "${file}",
		-- 			cwd = "${workspaceFolder}",
		-- 		},
		-- 		-- {
		-- 		-- 	type = "pwa-node",
		-- 		-- 	request = "attach",
		-- 		-- 	name = "Attach to Chrome",
		-- 		-- 	-- port = 8081,
		-- 		-- 	address = "localhost",
		-- 		-- 	-- program = "${file}",
		-- 		-- 	cwd = vim.fn.getcwd(),
		-- 		-- 	sourceMaps = true,
		-- 		-- 	protocol = "inspector",
		-- 		-- 	webRoot = "${workspaceFolder}",
		-- 		-- },
		-- 		-- {
		-- 		-- 	type = "pwa-node",
		-- 		-- 	request = "attach",
		-- 		-- 	name = "Attach to Hermes (iOS)",
		-- 		-- 	address = "localhost",
		-- 		-- 	-- port = 8081,
		-- 		-- 	cwd = "${workspaceFolder}",
		-- 		-- 	continueOnAttach = true,
		-- 		-- 	sourceMaps = true,
		-- 		-- 	urlFilter = "*",
		-- 		-- 	sourceMapPathOverrides = {
		-- 		-- 		["webpack:///./*"] = "${workspaceFolder}/*",
		-- 		-- 		["webpack:///*"] = "*",
		-- 		-- 		["metro:///*"] = "${workspaceFolder}/*",
		-- 		-- 	},
		-- 		-- 	resolveSourceMapLocations = {
		-- 		-- 		"${workspaceFolder}/**",
		-- 		-- 		"!**/node_modules/**",
		-- 		-- 	},
		-- 		-- 	skipFiles = { "<node_internals>/**", "**/node_modules/**" },
		-- 		-- 	timeout = 30000,
		-- 		-- },
		-- 		-- -- Direct Metro: Simplified config for direct Metro connection
		-- 		-- {
		-- 		-- 	type = "pwa-node",
		-- 		-- 	request = "attach",
		-- 		-- 	name = "Attach to Metro (Direct)",
		-- 		-- 	address = "localhost",
		-- 		-- 	port = 8081,
		-- 		-- 	cwd = "${workspaceFolder}",
		-- 		-- 	sourceMaps = true,
		-- 		-- 	protocol = "inspector",
		-- 		-- 	skipFiles = { "<node_internals>/**", "**/node_modules/**" },
		-- 		-- },
		-- 		--
		-- 		-- -- Launch Mode: Start Metro and attach (experimental)
		-- 		-- {
		-- 		-- 	type = "pwa-node",
		-- 		-- 	request = "attach",
		-- 		-- 	port = 8081,
		-- 		-- 	name = "Launch RN with Metro",
		-- 		-- 	cwd = "${workspaceFolder}",
		-- 		-- 	runtimeExecutable = "npm",
		-- 		-- 	runtimeArgs = { "run", "start" },
		-- 		-- 	console = "integratedTerminal",
		-- 		-- 	sourceMaps = true,
		-- 		-- 	resolveSourceMapLocations = {
		-- 		-- 		"${workspaceFolder}/**",
		-- 		-- 		"!**/node_modules/**",
		-- 		-- 	},
		-- 		-- 	skipFiles = { "<node_internals>/**" },
		-- 		-- 	restart = true,
		-- 		-- },
		-- 	}
		-- end
		--
		-- dap.set_log_level("TRACE")

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
				port = "2345",
				-- additional args to pass to dlv
				-- port = "${port}",
				args = {},
				build_flags = "-v -tags=unit,integration,e2e,end2end,test",
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

		require("nvim-dap-virtual-text").setup()
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
				"js",
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
