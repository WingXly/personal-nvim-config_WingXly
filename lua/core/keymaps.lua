-- 设置主键
vim.g.mapleader = " "

local keymap = vim.keymap

-- 插入模式
keymap.set("i", "<leader><leader>", "<ESC>")

-- 视觉模式：上下移动选中的行
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- 新建分屏
keymap.set("n", "<leader>LL", "<C-w>v")
keymap.set("n", "<leader>KK", "<C-w>s")

-- 取消搜索高亮
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- 打开文档树
keymap.set("n", "<leader><leader>", ":NvimTreeToggle<CR>")

-- 保存 / 退出
keymap.set("n", "<C-s>", ":w<CR>")
keymap.set("n", "<C-x>", ":q<CR>")

-- ── 窗口间移动 ────────────────────────────────────────────────
-- Ctrl+i 上 / Ctrl+k 下 / Ctrl+j 左 / Ctrl+l 右
-- 注意：<C-i> 在终端里与 <Tab> 是同一个键码，
--       所以普通模式下按 Tab 也会向上移动窗口（插入模式不受影响）。
keymap.set("n", "<C-i>", "<Cmd>wincmd k<CR>", { desc = "窗口：向上" })
keymap.set("n", "<C-k>", "<Cmd>wincmd j<CR>", { desc = "窗口：向下" })
keymap.set("n", "<C-j>", "<Cmd>wincmd h<CR>", { desc = "窗口：向左" })
keymap.set("n", "<C-l>", "<Cmd>wincmd l<CR>", { desc = "窗口：向右" })

-- ── 标签（buffer）间移动 ──────────────────────────────────────
-- Shift+j 上一个 / Shift+l 下一个
-- 用内置 :bprevious / :bnext 而非 BufferLineCycle*：
--   后者依赖 bufferline 内部渲染状态，在部分场景下不切换，内置命令更可靠；
--   且 bufferline 默认按 buffer 编号排序，视觉顺序与之一致。
-- 注意：这会覆盖默认的 J（合并行）和 L（跳到屏幕末行）。
keymap.set("n", "J", "<Cmd>bprevious<CR>", { desc = "上一个标签" })
keymap.set("n", "L", "<Cmd>bnext<CR>", { desc = "下一个标签" })
