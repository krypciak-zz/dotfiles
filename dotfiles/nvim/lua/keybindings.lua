function map(mode, combo, mapping, opts)
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
map('n', 'T', '', { noremap = true, 
   callback = function() print('Unsupported filetype: '..vim.o.filetype) end })


-- Build keybinding
map('n', 'B', '', { noremap = true, 
   callback = function() print('Unsupported filetype: '..vim.o.filetype) end })


-- d stands for delete not cut
map('n', 'x', '"_x', { noremap = true })
map('n', 'X', '"_X', { noremap = true })
map('n', 'd', '"_d', { noremap = true })
map('n', 'D', '"_D', { noremap = true })
map('v', 'd', '"_d', { noremap = true })


map('n', '<leader>d', '"+d', { noremap = true })
map('n', '<leader>D', '"+D', { noremap = true })
map('v', '<leader>d', '"+d', { noremap = true })

-- Set jk to <esc>
map('i', 'jk', '<esc>', { noremap = true})
map('i', '<esc>', '<nop>', { noremap = true })

local foldcolumn = 0;
cmd(':set foldcolumn=' .. foldcolumn)
map('n', '<leader>f', '', { noremap = true, callback = function() 
        foldcolumn = foldcolumn + 1
        if foldcolumn > 4 then foldcolumn = 0 end
        cmd(':set foldcolumn='..foldcolumn)
    end,})


--if vim.o.filetype == "rust" then 
require("lang/rust") 
