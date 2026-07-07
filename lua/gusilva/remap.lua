local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- (conflict with <leader>pw) keep copied stuffs in the buffer when pasting it
-- map("n", "<leader>p", "\"_dP")

-- map("n", "<leader>pv", vim.cmd.Lexplore)
map("n", "<leader>pv", vim.cmd.Ex)
map("n", "<F10>", vim.cmd.Ex)

-- Save
map("n", "<leader>w", "<CMD>update<CR>")

-- Quit
map("n", "<c-c>", "<CMD>q<CR>")

-- Exit insert mode
map("i", "jj", "<ESC>")

-- Window resize
map("n", "<s-Left>", "<c-w><")
map("n", "<s-Right>", "<c-w>>")
map("n", "<s-Up>", "<c-w>+")
map("n", "<s-Down>", "<c-w>-")

-- Move selected line / block of text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv-gv")

map("n", "J", "mzJ`z")
-- map("n", "<C-d>", "<C-d>zz")
-- map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Buffer
map("n", "<TAB>", "<CMD>bnext<CR>")
map("n", "<s-TAB>", "<CMD>bprevious<CR>")

map("n", "Q", "<Nop>")

-- LSP format
map("n", "<leader>f", function()
	vim.lsp.buf.format()
end)

-- Search and replace
-- map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Reset highlight
map("n", "<CR>", "<CMD>noh<CR><CR>")

-- Hover documentation
map("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "[S]ignature [D]ocumentation" })

-- spell check
vim.keymap.set("n", "<F3>", "<CMD>set spell!<CR>", { silent = true, desc = "Toggle spell check" })
vim.keymap.set("i", "<F3>", "<C-O>:set spell!<CR>", { silent = true, desc = "Toggle spell check" })

-- Hide windows
vim.keymap.set("n", "<leader>hw", "<CMD>only<CR>", { silent = true, desc = "Hide windows" })

-- delete buffer
vim.api.nvim_set_keymap(
	"n",
	"<leader>db",
	":bdelete!<CR>",
	{ noremap = true, silent = true, desc = "[D]elete current [B]uffer" }
)

-- jump to beginning/end of line
vim.api.nvim_set_keymap("n", "H", "^", { noremap = true, silent = true, desc = "Jump to [H]ome" })
vim.api.nvim_set_keymap("v", "H", "^", { noremap = true, silent = true, desc = "Jump to [H]ome" })
vim.api.nvim_set_keymap("n", "L", "$", { noremap = true, silent = true, desc = "Jump to [L]ast" })
vim.api.nvim_set_keymap("v", "L", "$", { noremap = true, silent = true, desc = "Jump to [L]ast" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.api.nvim_set_keymap("n", "gcl", "gcc", { desc = "Toggle comment line", expr = true })

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- terminal
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- neorg
-- in your init.lua or a file in lua/...
vim.api.nvim_create_autocmd("FileType", {
	pattern = "norg",
	callback = function()
		local opts = { buffer = true, noremap = true, silent = true }
		local todo_opts = function(desc)
			return { buffer = true, noremap = true, silent = true, desc = desc }
		end
		-- vim.keymap.set("n", "<leader>nn", "<Cmd>Neorg index<CR>", opts)
		vim.keymap.set("n", "<leader>nj", "<Cmd>Neorg journal<CR>", opts)

		vim.keymap.set("n", "<leader>ntd", "<Plug>(neorg.qol.todo-items.todo.task-done)", todo_opts("Neorg task: done"))
		vim.keymap.set("n", "<leader>ntu", "<Plug>(neorg.qol.todo-items.todo.task-undone)", todo_opts("Neorg task: undone"))
		vim.keymap.set("n", "<leader>ntp", "<Plug>(neorg.qol.todo-items.todo.task-pending)", todo_opts("Neorg task: pending"))
		vim.keymap.set("n", "<leader>nth", "<Plug>(neorg.qol.todo-items.todo.task-on-hold)", todo_opts("Neorg task: on hold"))
		vim.keymap.set("n", "<leader>ntc", "<Plug>(neorg.qol.todo-items.todo.task-cancelled)", todo_opts("Neorg task: cancelled"))
		vim.keymap.set("n", "<leader>ntr", "<Plug>(neorg.qol.todo-items.todo.task-recurring)", todo_opts("Neorg task: recurring"))
		vim.keymap.set("n", "<leader>nti", "<Plug>(neorg.qol.todo-items.todo.task-important)", todo_opts("Neorg task: important"))
		vim.keymap.set("n", "<leader>nta", "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)", todo_opts("Neorg task: ambiguous"))
		vim.keymap.set("n", "<leader>ntt", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", todo_opts("Neorg task: cycle"))
		vim.keymap.set(
			"n",
			"<leader>ntT",
			"<Plug>(neorg.qol.todo-items.todo.task-cycle-reverse)",
			todo_opts("Neorg task: cycle reverse")
		)
	end,
})
