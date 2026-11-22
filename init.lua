-- 插件管理：Neovim 0.12 内置 vim.pack（不再依赖 packer.nvim）
-- 插件安装在 stdpath('data')/site/pack/core/opt
-- 更新：:lua vim.pack.update()  删除：:lua vim.pack.del({'名字'})
vim.pack.add({
  { src = 'https://github.com/folke/tokyonight.nvim' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/HiPhish/rainbow-delimiters.nvim' },
  -- nvim 0.12 必须用 main 分支（master 是为 0.11 冻结的）
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  -- 自动补全
  { src = 'https://github.com/hrsh7th/nvim-cmp' },
  { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
  { src = 'https://github.com/hrsh7th/cmp-buffer' },
  { src = 'https://github.com/hrsh7th/cmp-path' },
  -- 编辑增强
  { src = 'https://github.com/numToStr/Comment.nvim' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/akinsho/bufferline.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  -- 模糊查找（telescope 依赖 plenary）
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  -- 注意：已移除 christoomey/vim-tmux-navigator
  -- 它会把 <C-h>/<C-j>/<C-k>/<C-l> 抢走，和下面的窗口移动映射冲突；
  -- 以后真要用 tmux，再把它加回来并改用它的 TmuxNavigate 映射。
}, { confirm = false })

require("core.options")
require("core.keymaps")

-- 插件配置
require("plugins.lualine")
require("plugins.nvim-tree")
require("plugins.nvim-treesitter")

-- 自动补全 / LSP
require("plugins.cmp")
require("plugins.lsp")

-- 编辑增强
require("plugins.comment")
require("plugins.autopairs")
require("plugins.bufferline")
require("plugins.gitsigns")
require("plugins.telescope")
