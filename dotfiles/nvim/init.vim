lua require('config')

let g:clipboard = {
          \   'name': 'copyq',
          \   'copy': {
          \      '+': ['copyq', 'copy', '-'],
          \      '*': ['copyq', 'copy', '-'],
          \    },
          \   'paste': {
          \      '+': ['copyq', 'clipboard'],
          \      '*': ['copyq', 'clipboard'],
          \   },
          \   'cache_enabled': 1,
          \ }

set number relativenumber

"set termguicolors
highlight NvimTreeFolderIcon guibg=blue
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>


nnoremap <C-d> :Files<CR>

let g:SuperTabDefaultCompletionType = "<c-n>"

nmap T :CargoRun
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => pazams opinionated- ‘d is for delete’ & ‘ leader-d is for cut’ (shared clipboard register mode)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap x "_x
nnoremap X "_X
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d

if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
  nnoremap <leader>d "+d
  nnoremap <leader>D "+D
  vnoremap <leader>d "+d
else
  set clipboard=unnamed
  nnoremap <leader>d "*d
  nnoremap <leader>D "*D
  vnoremap <leader>d "*d
endif
