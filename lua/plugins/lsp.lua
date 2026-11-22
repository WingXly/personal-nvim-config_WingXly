-- LSP：使用 Neovim 0.12 内置的 vim.lsp.config / vim.lsp.enable
-- 不需要 nvim-lspconfig。语言服务器需要自己装：
--   C/C++ : clangd        (sudo apt install -y clangd)
--   Python: pyright       (npm install -g --prefix ~/.local pyright)

-- 向所有 LSP 客户端声明补全能力（由 cmp-nvim-lsp 提供）
-- 不声明的话服务器只会返回最基础的补全项，没有 snippet 和文档
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- C / C++：clangd
vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', 'CMakeLists.txt', 'Makefile', '.git' },
})

-- Python：pyright
vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
})

vim.lsp.enable({ 'clangd', 'pyright' })

-- 诊断显示
vim.diagnostic.config({
  virtual_text = { prefix = '●' },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = true },
})

-- LSP 挂载到缓冲区后的快捷键
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
  callback = function(event)
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = event.buf, desc = desc })
    end
    map('gd', vim.lsp.buf.definition, '跳转定义')
    map('gD', vim.lsp.buf.declaration, '跳转声明')
    map('gr', vim.lsp.buf.references, '查找引用')
    map('gi', vim.lsp.buf.implementation, '查找实现')
    map('K', vim.lsp.buf.hover, '悬停文档')
    map('<leader>rn', vim.lsp.buf.rename, '重命名符号')
    map('<leader>ca', vim.lsp.buf.code_action, '代码操作')
    map('<leader>e', vim.diagnostic.open_float, '诊断详情')
    map('[d', function() vim.diagnostic.jump({ count = -1 }) end, '上一个诊断')
    map(']d', function() vim.diagnostic.jump({ count = 1 }) end, '下一个诊断')
  end,
})
