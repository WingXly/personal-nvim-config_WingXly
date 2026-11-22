-- telescope.nvim：模糊查找（依赖 plenary.nvim + ripgrep）
local ok, telescope = pcall(require, 'telescope')
if not ok then
  return
end

telescope.setup({
  defaults = {
    path_display = { 'smart' },
    -- 隐藏目录/编译产物，避免搜索结果被噪音淹没
    file_ignore_patterns = {
      '^%.git/',
      'node_modules/',
      '__pycache__/',
      '%.o$',
      '%.so$',
      '%.a$',
      '%.pyc$',
    },
    mappings = {
      i = {
        ['<C-u>'] = false, -- 避免和 vim 的删除行冲突
        ['<C-d>'] = false,
      },
    },
  },
  pickers = {
    -- 用 ripgrep 列文件，省掉对 fd 的依赖
    find_files = {
      find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/*' },
    },
  },
})

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '查找文件' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '全文搜索' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '缓冲区列表' })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '最近打开的文件' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '帮助文档' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '诊断列表' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '快捷键列表' })
vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = '搜索光标下的词' })
