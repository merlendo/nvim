-- Options
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.winborder = "rounded"
vim.opt.tabstop = 4
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = false
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.helpheight = 25
vim.o.statusline = "%<%f %h%m%r%{FugitiveStatusline()} %=%-14.(%l,%c%V%) %P"

-- Common keymaps
--vim.g.mapleader = ' '
--vim.g.maplocalleader = ' '
local map = vim.keymap.set
map('n', '<leader>o', ':update<CR> :source<CR> :echo "Neovim config file reloaded"<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>r', ':update<CR> :make<CR>')
map('n', '<leader>R', '<leader>r :%s///g<Left><Left><Left>')
map('n', '<leader>q', ':quit<CR>')
map('n', '<leader>Q', ':quit!<CR>')
map('n', '<leader>a', 'ggVG')
map('n', '<leader>v', ':e $MYVIMRC<CR>')
map('n', '<leader>z', ':e ~/.config/zsh/.zshrc<CR>')
map('n', '<leader>s', ':e #<CR>')
map('n', '<leader>S', ':sf #<CR>')
map('n', '<leader>n', ':noh<CR>')
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>p', '"+p')
map({ 'n', 'v' }, '<leader>d', '"+d')

-- VS code
if vim.g.vscode then
	local vscode = require("vscode")
	--map('n', '<leader>e', function()
	--vscode.call('workbench.action.toggleSidebarVisibility')
	--vscode.call('workbench.files.action.focusFilesExplorer')
	--end)
	map('n', '<leader>v', function()
		local uri = "/Users/merlendo/.config/nvim/init.lua"
		vscode.call('vscode.open', { args = { uri } })
	end)
else
	-- plugins
	vim.pack.add({
		{ src = "https://github.com/vague2k/vague.nvim" },
		{ src = "https://github.com/stevearc/oil.nvim" },
		{ src = "https://github.com/echasnovski/mini.pick" },
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
		{ src = "https://github.com/neovim/nvim-lspconfig" },
		{ src = "https://github.com/tpope/vim-fugitive" },
		{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	})

	-- explorer
	require "oil".setup({
		delete_to_trash = true,
		keymaps = {
			["<C-p>"] = { "actions.preview", opts = { split = "belowright" } },
		}
	})
	map('n', '<leader>e', ":Oil<CR>")

	-- lsp
	vim.lsp.enable({"ruff", "lua_ls", "ts_ls", "gopls", "intelephense", "angularls", "biome"})
	map('n', '<leader>lf', function()
		vim.lsp.buf.format()
		vim.lsp.buf.code_action({
			context = {
				only = { "source.organizeImports" },
				diagnostics = {},
			},
			apply = true,
		})
	end
	)
	vim.api.nvim_create_autocmd('LspAttach', {
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
				vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
				vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			end
		end,
	})
	vim.diagnostic.config({
		virtual_text = { current_line = true }
	})

	-- treesitter
	require "nvim-treesitter.configs".setup({
		ensure_installed = { "lua", "python", "javascript", "html", "css", "rust", "go", "php"},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
		},
		modules = {},
		sync_install = false,
		ignore_install = {},
		auto_install = true,
	})

	-- fzf
	require "mini.pick".setup({
		mappings = {
			choose_marked = "<C-G>"
		}
	})
	map('n', '<leader>f', ":Pick files<CR>")
	map('n', '<leader>h', ":Pick help<CR>")

	-- colors
	require "vague".setup({ transparent = true })
	vim.cmd("colorscheme vague")

	-- text highlighting when yanking
	vim.api.nvim_create_autocmd('TextYankPost', {
		desc = 'Highlight when yanking (copying) text',
		group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})

	-- git
	--vim.api.nvim_create_autocmd("FileType", {
	--	pattern = "gitcommit",
	--	callback = function()
	--		vim.cmd("wincmd J")
	--		vim.cmd("resize 8")
	--	end,
	--})
	vim.api.nvim_create_autocmd("User", {
		pattern = {"FugitiveIndex", "FugitiveEditor"},
		callback = function(opts)
			vim.schedule(function()
				vim.cmd("wincmd J")
				vim.cmd("resize 8")
			end)
		end,
	})

	-- gitmoji
	local gitmoji = require("gitmojis")
	vim.keymap.set("n", "<leader>ge", gitmoji.pick, { desc = "Pick a gitmoji" })
end
