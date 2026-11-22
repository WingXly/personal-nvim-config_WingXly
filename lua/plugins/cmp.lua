-- 自动补全：nvim-cmp（纯 Lua 实现，ARM64 无编译依赖）
-- 选它而不是 blink.cmp：blink 的 Rust 模糊匹配没有 aarch64 预编译二进制，
-- 本机也没有 cargo/rustc，用 Lua 回退反而更慢，不如直接上 nvim-cmp。
local cmp = require('cmp')

cmp.setup({
  -- 使用 Neovim 内置 snippet 支持（0.10+），不需要 LuaSnip
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },

  sources = {
    { name = 'nvim_lsp' }, -- LSP（clangd / pyright）
    { name = 'buffer' },   -- 当前缓冲区单词
    { name = 'path' },     -- 文件路径
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(), -- 手动触发
    ['<C-e>'] = cmp.mapping.abort(),        -- 关闭补全
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  completion = {
    completeopt = 'menu,menuone,noinsert',
  },

  experimental = {
    ghost_text = true, -- 行内灰色预览
  },
})
