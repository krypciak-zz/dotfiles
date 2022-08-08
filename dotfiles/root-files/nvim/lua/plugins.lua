return require('packer')
.startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    tag = 'nightly'
  }

  use 'itchyny/lightline.vim'

  use 'rubixninja314/vim-mcfunction'

  use 'vim-syntastic/syntastic'

  use 'euclidianAce/BetterLua.vim'

  use 'junegunn/fzf.vim'

  use 'ervandew/supertab'
  end)
