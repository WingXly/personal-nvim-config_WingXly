-- gitsigns.nvim：git 状态标记（增删行、hunk 操作）
require('gitsigns').setup({
  signs = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signs_staged = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  current_line_blame = false,
  preview_config = {
    border = 'rounded',
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- 在 hunk 之间跳转
    map('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, '下一个 hunk')

    map('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, '上一个 hunk')

    -- hunk 操作
    map('n', '<leader>hs', gs.stage_hunk, '暂存 hunk')
    map('n', '<leader>hr', gs.reset_hunk, '撤销 hunk')
    map('v', '<leader>hs', function()
      gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, '暂存选中的行')
    map('v', '<leader>hr', function()
      gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, '撤销选中的行')
    map('n', '<leader>hS', gs.stage_buffer, '暂存整个文件')
    map('n', '<leader>hp', gs.preview_hunk, '预览 hunk')
    map('n', '<leader>hb', function()
      gs.blame_line({ full = true })
    end, '显示行 blame')
    map('n', '<leader>hd', gs.diffthis, '对比当前文件')
    map('n', '<leader>ht', gs.toggle_current_line_blame, '切换行 blame')
  end,
})
