-- nvim-autopairs：自动补全括号 / 引号
local ok, autopairs = pcall(require, 'nvim-autopairs')
if not ok then
  return
end

autopairs.setup({
  check_ts = true, -- 用 treesitter 判断是否该补全（避免字符串里乱补）
  ts_config = {
    lua = { 'string' },
    javascript = { 'string' },
    python = { 'string' },
  },
  fast_wrap = {
    map = '<M-e>', -- Alt+e 快速包裹
    chars = { '{', '[', '(', '"', "'" },
  },
})

-- 与 nvim-cmp 联动：确认补全项后自动补上右括号
local cmp_ok, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
if cmp_ok then
  pcall(function()
    require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end)
end
