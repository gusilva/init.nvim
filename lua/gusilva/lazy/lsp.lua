-- Enable the following language servers
local servers = {
	gopls = {
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		cmd = { "gopls" },
		gopls = {
			analyses = {
				unreachable = true,
				nilness = true,
				unusedparams = true,
				useany = true,
				unusedwrite = true,
				undeclaredname = true,
				fillreturns = true,
				nonewvars = true,
				fieldalignment = true,
				shadow = true,
				unusedvariable = true,
				ST1003 = true,
				ST1008 = true,
			},
			codelenses = {
				generate = true, -- show the `go generate` lens.
				gc_details = true, -- Show a code lens toggling the display of gc's choices.
				test = true,
				tidy = true,
				vendor = true,
				regenerate_cgo = true,
				upgrade_dependency = true,
				run_govulncheck = true,
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			matcher = "Fuzzy",
			diagnosticsDelay = "500ms",
			symbolMatcher = "fuzzy",
			buildFlags = { "-tags", "integration,end2end" },
			vulncheck = "Imports",
			hints = {
				constantValues = true,
				rangeVariableTypes = true,
			},
		},
	},
	-- tsserver = {},
	ts_ls = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				-- diagnostics = { disable = { 'missing-fields' } },
			},
		},
	},
	templ = {
		filetypes = { "templ" },
	},
	html = {
		filetypes = { "html", "gohtml", "templ" },
	},
	-- htmx = {},
	tailwindcss = {
		filetypes = { "html", "css", "scss", "javascript", "typescript", "templ", "gohtml" },
	},
	tflint = {},
	terraformls = {
		filetypes = { "terraform", "tf", "tfvars" },
	},
	docker_compose_language_service = {},
	dockerls = {},
	golangci_lint_ls = {},
}

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		-- Enable underline, use default values
		underline = false,

		-- disable virtual text
		virtual_text = true,

		-- show signs
		signs = true,

		-- delay update diagnostics
		update_in_insert = false,

		float = true,
	})
end

return {
	-- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		-- { 'williamboman/mason.nvim', config = true },
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",

		-- Autocompletion
		"hrsh7th/nvim-cmp",
		"saadparwaiz1/cmp_luasnip",

		-- Adds LSP completion capabilities
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",

		-- Adds a number of user-friendly snippets
		-- 'rafamadriz/friendly-snippets',
		"L3MON4D3/LuaSnip",

		"onsails/lspkind-nvim",
		{ "roobert/tailwindcss-colorizer-cmp.nvim", config = true },

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		"folke/neodev.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("neodev").setup()
		--
		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- before setting up the servers.
		require("mason").setup()
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
			-- "golangci-lint", -- Used to lint Go code
			"markdownlint", -- Used to lint Markdown files
			"goimports", -- Used to format Go code
			-- "yamllint", -- Used to lint YAML files
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- local mason_lspconfig = require 'mason-lspconfig'
		-- mason_lspconfig.setup {
		--   ensure_installed = ensure_installed,
		-- }
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					-- require('lspconfig')[server_name].setup(server)

					require("lspconfig")[server_name].setup({
						capabilities = server.capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
						-- init_options = (servers[server_name] or {}).init_options,
					})
				end,
			},
		})

		-- mason_lspconfig.setup_handlers {
		--   function(server_name)
		--     require('lspconfig')[server_name].setup {
		--       capabilities = capabilities,
		--       on_attach = on_attach,
		--       settings = servers[server_name],
		--       filetypes = (servers[server_name] or {}).filetypes,
		--       -- init_options = (servers[server_name] or {}).init_options,
		--     }
		--   end,
		-- }

		-- [[ Configure nvim-cmp ]]
		-- See `:help cmp`
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		require("luasnip.loaders.from_vscode").lazy_load()

		local lspkind = require("lspkind")
		lspkind.init({
			mode = "symbol_text",
			preset = "codicons",
		})

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete({}),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
			},
			formatting = {
				fields = { "abbr", "kind", "menu" },
				format = function(entry, item)
					item.kind = lspkind.presets.default[item.kind]
					item.menu = ({
						nvim_lsp = "[LSP]",
						nvim_lua = "[Lua]",
						buffer = "[Buffer]",
						path = "[Path]",
						calc = "[Calc]",
						look = "[Dict]",
					})[entry.source.name]
					return require("tailwindcss-colorizer-cmp").formatter(entry, item)
				end,
				expandable_indicator = true,
			},
			experimental = {
				-- I like the new menu better! Nice work hrsh7th
				native_menu = false,

				-- Let's play with this for a day or two
				ghost_text = false,
			},
		})
	end,
}
