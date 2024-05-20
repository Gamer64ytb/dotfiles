-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable line numbers
vim.opt.number = true

-- Set shortmess option to suppress ATTENTION messages
vim.opt.shortmess:append('A')

-- Enable 24-bit colour
vim.opt.termguicolors = true

-- Load the Packer plugin manager
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
if not packer_exists then
    local packer_install_path = vim.fn.stdpath('data')..'\\site\\pack\\packer\\opt\\packer.nvim'
    vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_install_path})
    vim.cmd('packadd packer.nvim')
end

-- Initialize Packer
require('packer').startup(function()
    -- Packer plugins
    use("petertriho/nvim-scrollbar")
    use 'akinsho/nvim-bufferline.lua'
    use 'lambdalisue/suda.vim'
    use 'Exafunction/codeium.vim'
    use { "catppuccin/nvim", as = "catppuccin" }
end)


-- Set up the color scheme
vim.g.vscode_style = "dark"  -- Set the style to dark
vim.cmd.colorscheme "catppuccin"

--Vscode theme config
local function open_nvim_tree(data)

    -- buffer is a real file on the disk
    local real_file = vim.fn.filereadable(data.file) == 1
  
    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
  
    if not real_file and not no_name then
      return
    end
  
    -- open the tree, find the file but don't focus it
    require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
end

-- Enable nvim-bufferline
vim.o.hidden = true
require'bufferline'.setup{}
vim.opt.termguicolors = true
require("bufferline").setup{}

--nvim-scrollbar config
require("scrollbar").setup()
