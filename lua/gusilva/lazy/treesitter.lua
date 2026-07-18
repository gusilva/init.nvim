-- return {
--   "nvim-treesitter/nvim-treesitter",
--   branch = "master",
--   lazy = false,
--   build = ":TSUpdate",
--   require'nvim-treesitter.configs'.setup {
--   -- A list of parser names, or "all" (the listed parsers MUST always be installed)
--   ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
--
--   -- Install parsers synchronously (only applied to `ensure_installed`)
--   sync_install = false,
--
--   -- Automatically install missing parsers when entering buffer
--   -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
--   auto_install = true,
--
--   -- List of parsers to ignore installing (or "all")
--   ignore_install = { "javascript" },
--
--   ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
--   -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
--
--   highlight = {
--     enable = true,
--
--     -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
--     -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
--     -- the name of the parser)
--     -- list of language that will be disabled
--     disable = { "c", "rust" },
--     -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
--     disable = function(lang, buf)
--         local max_filesize = 100 * 1024 -- 100 KB
--         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
--         if ok and stats and stats.size > max_filesize then
--             return true
--         end
--     end,
--
--     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--     -- Using this option may slow down your editor, and you may see some duplicate highlights.
--     -- Instead of true it can also be a list of languages
--     additional_vim_regex_highlighting = false,
--   },
-- }
-- }
--
return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function(_, opts)
		-- CLI 0.24.7 max ABI 14; nvim 0.11 default requests 15. Pin to 14 (accepted).
		require("nvim-treesitter.install").ts_generate_args = { "generate", "--no-bindings", "--abi", "14" }
		require("nvim-treesitter.configs").setup(opts)
	end,
	opts = {
		ensure_installed = {
			"go",
			"lua",
			"tsx",
			"javascript",
			"typescript",
			"vimdoc",
			"vim",
			"bash",
			"http",
			"json",
			"regex",
			"markdown",
			"markdown_inline",
			"toml",
			"yaml",
			"css",
			"html",
			"templ",
			"terraform",
			"hcl",
			"xml",
			"dockerfile",
			"swift",
			"objc",
			"kotlin",
		},

		-- ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
		-- Autoinstall languages that are not installed
		auto_install = true,
		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },
	},
	-- There are additional nvim-treesitter modules that you can use to interact
	-- with nvim-treesitter. You should go explore a few and see what interests you:
	--
	--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
	--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
	--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}

-- return {
-- 	-- Highlight, edit, and navigate code
-- 	"nvim-treesitter/nvim-treesitter",
-- 	dependencies = {
-- 		"nvim-treesitter/nvim-treesitter-textobjects",
-- 	},
-- 	build = ":TSUpdate",
-- 	config = function()
-- 		-- [[ Configure Treesitter ]]
-- 		-- See `:help nvim-treesitter`
-- 		-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
-- 		vim.defer_fn(function()
-- 			require("nvim-treesitter.configs").setup({
-- 				-- Add languages to be installed here that you want installed for treesitter
-- 				ensure_installed = {
-- 					-- "go",
-- 					-- "lua",
-- 					-- "tsx",
-- 					-- "javascript",
-- 					-- "typescript",
-- 					-- "vimdoc",
-- 					-- "vim",
-- 					-- "bash",
-- 					-- "http",
-- 					-- "json",
-- 					-- "regex",
-- 					-- "markdown",
-- 					-- "markdown_inline",
-- 					-- "toml",
-- 					-- "yaml",
-- 					-- "css",
-- 					-- "html",
-- 					-- "templ",
-- 					-- "terraform",
-- 					-- "hcl",
-- 					-- "xml",
-- 					-- "dockerfile",
-- 				},
--
-- 				-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
-- 				auto_install = true,
--
-- 				-- Install languages synchronously (only applied to `ensure_installed`)
-- 				sync_install = false,
-- 				-- List of parsers to ignore installing
-- 				ignore_install = {},
-- 				-- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
-- 				modules = {},
-- 				highlight = { enable = true },
-- 				indent = { enable = true },
-- 				incremental_selection = {
-- 					enable = true,
-- 					keymaps = {
-- 						init_selection = "<c-space>",
-- 						node_incremental = "<c-space>",
-- 						scope_incremental = "<c-s>",
-- 						node_decremental = "<M-space>",
-- 					},
-- 				},
-- 				textobjects = {
-- 					select = {
-- 						enable = true,
-- 						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
-- 						keymaps = {
-- 							-- You can use the capture groups defined in textobjects.scm
-- 							["aa"] = "@parameter.outer",
-- 							["ia"] = "@parameter.inner",
-- 							["af"] = "@function.outer",
-- 							["if"] = "@function.inner",
-- 							["ac"] = "@class.outer",
-- 							["ic"] = "@class.inner",
-- 						},
-- 					},
-- 					move = {
-- 						enable = true,
-- 						set_jumps = true, -- whether to set jumps in the jumplist
-- 						goto_next_start = {
-- 							["]m"] = "@function.outer",
-- 							["]]"] = "@class.outer",
-- 						},
-- 						goto_next_end = {
-- 							["]M"] = "@function.outer",
-- 							["]["] = "@class.outer",
-- 						},
-- 						goto_previous_start = {
-- 							["[m"] = "@function.outer",
-- 							["[["] = "@class.outer",
-- 						},
-- 						goto_previous_end = {
-- 							["[M"] = "@function.outer",
-- 							["[]"] = "@class.outer",
-- 						},
-- 					},
-- 					swap = {
-- 						enable = true,
-- 						swap_next = {
-- 							["<leader>a"] = "@parameter.inner",
-- 						},
-- 						swap_previous = {
-- 							["<leader>A"] = "@parameter.inner",
-- 						},
-- 					},
-- 				},
-- 			})
-- 		end, 0)
-- 	end,
-- }
