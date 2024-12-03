return {
	"ray-x/web-tools.nvim",
	ft = { "html", "javascript", "hurl", "http", "svelte" },
	cmd = { "HurlRun", "BrowserOpen", "Npm", "Yarn", "Tsc" },
	lazy = true,
	config = function()
		require("web-tools").setup({
			keymaps = {
				rename = nil, -- by default use same setup of lspconfig
				repeat_rename = ".", -- . to repeat
			},
			hurl = { -- hurl default
				show_headers = false, -- do not show http headers
				floating = true, -- use floating windows (need guihua.lua)
				json5 = false, -- use json5 parser require json5 treesitter
				formatters = { -- format the result by filetype
					json = { "jq" },
					html = { "prettier", "--parser", "html" },
				},
			},
		})
	end,
}
