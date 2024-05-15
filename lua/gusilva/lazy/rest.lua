return {
	"diepm/vim-rest-console",
	config = function()
		vim.g.vrc_set_default_mappings = 0
		vim.g.vrc_response_default_content_type = "application/json"
		vim.g.vrc_output_buffer_name = "_output.json"
		vim.g.vrc_auto_format_response_patterns = {
			json = "jq",
		}
		vim.g.vrc_curl_opts = {
			["--connect-timeout"] = 10,
			["--max-time"] = 60,
			-- ["-k"] = "", -- insecure
			-- ["-s"] = "", -- silent
		}
		-- pipe the output to another buffer
		--:'<,'>y | vnew | set ft=json | 0put | %!jq ".systemCode"

		-- vim.keymap.set("n", "<leader>rc", "<CMD>VrcQuery()<CR>", { silent = true, desc = "Run rest" })
	end,
}

-- return {
-- 	"rest-nvim/rest.nvim",
-- 	dependencies = { "luarocks.nvim" },
-- 	ft = "http",
-- 	config = function()
-- 		require("telescope").load_extension("rest")
-- 		-- require("telescope").extensions.rest.select_env()
--
-- 		local rest_nvim = require("rest-nvim")
--
-- 		rest_nvim.setup({
-- 			client = "curl",
-- 			env_file = ".env",
-- 			env_pattern = "\\.env$",
-- 			env_edit_command = "tabedit",
-- 			encode_url = true,
-- 			skip_ssl_verification = false,
-- 			custom_dynamic_variables = {},
-- 			logs = {
-- 				level = "info",
-- 				save = true,
-- 			},
-- 			highlight = {
-- 				enable = true,
-- 				timeout = 150,
-- 			},
-- 			result = {
-- 				behavior = {
-- 					decode_url = true,
-- 					show_info = {
-- 						url = true,
-- 						headers = true,
-- 						http_info = true,
-- 						curl_command = true,
-- 					},
-- 					statistics = {
-- 						enable = true,
-- 						---@see https://curl.se/libcurl/c/curl_easy_getinfo.html
-- 						stats = {
-- 							{ "total_time", title = "Time taken:" },
-- 							{ "size_download_t", title = "Download size:" },
-- 						},
-- 					},
-- 					formatters = {
-- 						json = "jq",
-- 						html = function(body)
-- 							if vim.fn.executable("tidy") == 0 then
-- 								return body, { found = false, name = "tidy" }
-- 							end
-- 							local fmt_body = vim.fn
-- 								.system({
-- 									"tidy",
-- 									"-i",
-- 									"-q",
-- 									"--tidy-mark",
-- 									"no",
-- 									"--show-body-only",
-- 									"auto",
-- 									"--show-errors",
-- 									"0",
-- 									"--show-warnings",
-- 									"0",
-- 									"-",
-- 								}, body)
-- 								:gsub("\n$", "")
--
-- 							return fmt_body, { found = true, name = "tidy" }
-- 						end,
-- 					},
-- 				},
-- 				split = {
-- 					horizontal = false,
-- 					in_place = false,
-- 					stay_in_current_window_after_split = true,
-- 				},
-- 				keybinds = {
-- 					buffer_local = true,
-- 					prev = "H",
-- 					next = "L",
-- 				},
-- 			},
-- 			keybinds = {
-- 				{
-- 					"<localleader>rc",
-- 					"<cmd>Rest run<cr>",
-- 					"Run request under the cursor",
-- 				},
-- 				{
-- 					"<localleader>rl",
-- 					"<cmd>Rest run last<cr>",
-- 					"Re-run latest request",
-- 				},
-- 			},
-- 		})
-- 	end,
-- }
