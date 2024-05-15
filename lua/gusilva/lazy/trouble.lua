return {
	"folke/trouble.nvim",
	config = function(_, opts)
		local trouble = require("trouble")
		trouble.setup(opts)

		vim.keymap.set("n", "<leader>xx", function()
			trouble.toggle()
		end)
		vim.keymap.set("n", "<leader>xw", function()
			trouble.toggle("workspace_diagnostics")
		end)
		vim.keymap.set("n", "<leader>xd", function()
			trouble.toggle("document_diagnostics")
		end)
		vim.keymap.set("n", "<leader>xq", function()
			trouble.toggle("quickfix")
		end)
		vim.keymap.set("n", "<leader>xl", function()
			trouble.toggle("loclist")
		end)

		vim.keymap.set("n", "[t", function()
			require("trouble").next({ skip_groups = true, jump = true })
		end)

		vim.keymap.set("n", "]t", function()
			require("trouble").previous({ skip_groups = true, jump = true })
		end)
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		use_diagnostic_signs = true,
	},
}
