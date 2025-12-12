local vscode = require("vscode")

local open = false

vim.keymap.set("n", "<leader>e", function()
	if open then
		vscode.call("workbench.action.toggleSidebarVisibility")
	else
		vscode.call("workbench.files.action.focusFilesExplorer")
		open = true
	end
end)

vim.keymap.set("n", "<leader>go", function()
	vscode.call("git.openChange")
end)

vim.keymap.set("n", "<leader>v", function()
	local uri = "/Users/merlendo/.config/nvim/init.lua"
	vscode.call("vscode.open", { args = { uri } })
end)
