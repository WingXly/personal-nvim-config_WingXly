local opt = vim.opt

-- 行号
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- 防止包裹
opt.wrap = false

-- 光标
opt.cursorline = true
opt.mouse:append("a")

-- 剪切板
opt.clipboard:append("unnamedplus")

-- 默认新窗口位置
opt.splitright = true
opt.splitbelow = true

-- 搜索
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
-- 明确指定背景色，避免终端不支持 OSC11 时启动报 E1568
vim.o.background = "dark"
opt.signcolumn = "yes"

-- 自动选用主题
vim.cmd[[colorscheme tokyonight-moon]]
