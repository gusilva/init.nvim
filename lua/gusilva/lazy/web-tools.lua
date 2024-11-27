return {
	"ray-x/web-tools.nvim",
	ft = { "html", "javascript", "hurl", "http", "svelte" },
	cmd = { "HurlRun", "BrowserOpen", "Npm", "Yarn", "Tsc" },
	lazy = true,
	config = function()
		require("web-tools").setup({})
	end,
}
