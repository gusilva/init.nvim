local copilot_windows_secret = {
	"pwsh",
	"-Command",
	'Write-Output $((Get-Content -Path ~\\.config\\github-copilot\\hosts.json -Raw | ConvertFrom-Json)."github.com".oauth_token)',
}

local copilot_linux_secret = {
	"bash",
	"-c",
	"cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
}

-- Determine the operating system and set the appropriate secret configuration
local secret = nil

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	secret = copilot_windows_secret
else
	secret = copilot_linux_secret
end

return {
	"robitx/gp.nvim",
	config = function()
		local conf = {
			curl_params = { "--insecure" },
			providers = {
				openai = {
					disable = true,
					endpoint = "https://api.openai.com/v1/chat/completions",
				},
				copilot = {
					disable = false,
					endpoint = "https://api.githubcopilot.com/chat/completions",
					secret = secret,
				},

				-- pplx = {
				-- 	endpoint = "https://api.perplexity.ai/chat/completions",
				-- 	secret = os.getenv("PPLX_API_KEY"),
				-- },
				--
				-- ollama = {
				-- 	endpoint = "http://localhost:11434/v1/chat/completions",
				-- },
				--
				-- googleai = {
				-- 	endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
				-- 	secret = os.getenv("GOOGLEAI_API_KEY"),
				-- },
				--
				-- anthropic = {
				-- 	endpoint = "https://api.anthropic.com/v1/messages",
				-- 	secret = os.getenv("ANTHROPIC_API_KEY"),
				-- },
			},
		}
		require("gp").setup(conf)

		-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
	end,
}
