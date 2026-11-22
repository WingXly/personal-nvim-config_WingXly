-- nvim-treesitter（main 分支）
-- 依赖：Neovim 0.12+、tree-sitter-cli >= 0.26.1、C 编译器
require('nvim-treesitter').setup {
  -- parser 与 query 的安装目录（默认就是 stdpath('data')/site）
  install_dir = vim.fn.stdpath('data') .. '/site',
}

-- 需要语法高亮的语言
local ensure = { 'c', 'cpp', 'python' }

-- 首次启动时自动补齐缺失的 parser；已装则跳过，不联网
local installed = {}
for _, lang in ipairs(require('nvim-treesitter').get_installed('parsers') or {}) do
  installed[lang] = true
end

local missing = {}
for _, lang in ipairs(ensure) do
  if not installed[lang] then
    table.insert(missing, lang)
  end
end

if #missing > 0 then
  require('nvim-treesitter').install(missing)
end

-- 打开对应文件时启用 treesitter 语法高亮
vim.api.nvim_create_autocmd('FileType', {
  pattern = ensure,
  callback = function()
    local ok = pcall(vim.treesitter.start)
    if not ok then
      vim.notify(
        'treesitter: 缺少该语言的 parser，请运行 :TSInstall ' .. vim.bo.filetype,
        vim.log.levels.WARN
      )
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})
