require('plugins')
require('nvim-tree').setup{}


-- Sync system keyboard to vim
vim.g.clipboard = {
	copy = {
		['+'] = {'copyq', 'copy', '-'},
		['*'] = {'copyq', 'copy', '-'},
	},
        paste = {
                ['+'] = {'copyq', 'clipboard'},
		['*'] = {'copyq', 'clipboard'},
	},
	cache_enabled = 1,
}
vim.cmd('set clipboard+=unnamedplus')
-- Turn on relative line numbering
vim.o.relativenumber = true
vim.wo.number = true

vim.cmd('highlight NvimTreeFolderIcon guibg=blue')


-- keybindings
local function map(mode, combo, mapping, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, combo, mapping, options)
end

-- NvimTree keybindings
map('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true })
-- fzf.vim keybindings
map('n', '<C-d>', ':Files<CR>', { noremap = true })

-- Run/Compile keybinding
map('n', 'T', '', { 
	noremap = true,
	callback = function()
		local filetype = vim.o.filetype
		if(filetype == "rust") then
			vim.cmd(":CargoRun")
		elseif(filetype == "kotlin") then
		
		else 
			print('Unsupported filetype: '..filetype)
		end
	end
})

-- Tab completion
vim.g.SuperTabDefaultCompletionType = "<c-n>"

-- d stands for delete not cut
map('n', 'x', '"_x', { noremap = true })
map('n', 'X', '"_X', { noremap = true })
map('n', 'd', '"_d', { noremap = true })
map('n', 'D', '"_D', { noremap = true })
map('v', 'd', '"_d', { noremap = true })


map('n', '<leader>d', '"+d', { noremap = true })
map('n', '<leader>D', '"+D', { noremap = true })
map('v', '<leader>d', '"+d', { noremap = true })

