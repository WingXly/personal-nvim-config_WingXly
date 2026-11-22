-- bufferline.nvim：顶部缓冲区标签栏（依赖 nvim-web-devicons）
require('bufferline').setup({
  options = {
    mode = 'buffers',
    numbers = 'none',
    separator_style = 'thin',
    show_close_icon = false,
    show_buffer_close_icons = true,
    always_show_bufferline = true,
    -- 让 nvim-tree 打开时标签栏自动右移，不被树挡住
    offsets = {
      {
        filetype = 'NvimTree',
        text = '文件树',
        highlight = 'Directory',
        separator = true,
      },
    },
  },
})

-- 缓冲区切换快捷键
vim.keymap.set('n', '<leader>bn', ':BufferLineCycleNext<CR>', { desc = '下一个 buffer' })
vim.keymap.set('n', '<leader>bp', ':BufferLineCyclePrev<CR>', { desc = '上一个 buffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = '关闭当前 buffer' })
vim.keymap.set('n', '<leader>bo', ':BufferLineCloseOthers<CR>', { desc = '关闭其他 buffer' })
