-- Comment.nvim：快速注释
-- 内置映射（basic + extra）：
--   gcc / gbc      行注释（当前行 / 块注释）
--   gc<motion>     按动作注释（如 gcip 注释整段）
--   gcO / gco      上方 / 下方插入注释行
--   gcA            行尾追加注释
require('Comment').setup({
  mappings = {
    basic = true,
    extra = true,
  },
  padding = true,       -- 注释符号后留空格
  sticky = true,        -- 光标停在首字符
  ignore = nil,
})
