local o = vim.o
local g = vim.g

-- Share system clipboard with vim clipboard
cmd('set clipboard+=unnamedplus')
g.clipboard = {
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
--
g.SuperTabDefaultCompletionType = "<c-n>"


o.relativenumber = true
vim.wo.number = true
o.wrap = false
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
