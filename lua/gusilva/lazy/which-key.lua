return {
	"folke/which-key.nvim",
	opts = {},
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
		require("which-key").setup()

		-- Document existing key chains
		require("which-key").add({
			{ "<leader>W", desc = "[W]orkspace" },
			{ "<leader>c", desc = "[C]ode" },
			{ "<leader>d", desc = "[D]ocument" },
			{ "<leader>r", desc = "[R]ename" },
			{ "<leader>s", desc = "[S]earch" },
			{ "<leader>t", desc = "[T]oggle" },
			{ "<leader>h", desc = "Git [H]unk" },
			{ "<leader>h", desc = "Git [H]unk", mode = "v" },
		})
	end,
}
