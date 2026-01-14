return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = true,
	opts = {
		fast_wrap = {
			map = "<C-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = [=[[%'%"%>%]%)%}%,]]=],
			end_key = "$",
			before_key = "h",
			after_key = "l",
			cursor_pos_before = false,
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			manual_position = true,
			highlight = "Search",
			highlight_grey = "Comment",
		},
	},
	-- use opts = {} for passing setup options
	-- this is equivalent to setup({}) function
}
