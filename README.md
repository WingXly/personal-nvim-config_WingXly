# nvim-config

个人 Neovim 配置，面向 **Neovim 0.12+**，插件管理用内置的 `vim.pack`（不依赖 packer/lazy）。

## 快速搭建（换新机器三步）

```bash
# 1. 拿到配置（git clone 或解压 tar）
git clone <你的仓库地址> ~/.config/nvim

# 2. 一键安装依赖 + 部署
cd ~/.config/nvim && chmod +x install.sh && ./install.sh

# 3. 打开 nvim 验证
nvim
```

如果已经把仓库 clone 到别的位置：

```bash
./install.sh          # 复制到 ~/.config/nvim
./install.sh --link   # 符号链接（仓库改完立即生效，推荐长期用）
./install.sh --deps   # 只装依赖，不动配置
```

> 脚本自动处理：tree-sitter CLI、ripgrep、pyright 的安装，检查 clangd，首次启动还会自动
> clone 插件并编译 c/cpp/python 的 tree-sitter parser。

## 外部依赖

| 依赖 | 用途 | 安装方式 |
|---|---|---|
| Neovim >= 0.12 | `vim.pack` / `vim.lsp.config` / nvim-treesitter main 分支 | 手动（snap / 官方二进制 / 源码） |
| git | `vim.pack` 拉取插件 | 系统包管理器 |
| tree-sitter CLI >= 0.26 | 编译 parser（**必需**） | `install.sh` 自动装到 `~/.local/bin` |
| ripgrep | telescope 的 `find_files` / `live_grep` | `install.sh` 自动装（免 sudo） |
| clangd | C/C++ LSP | `sudo apt install -y clangd` |
| Node.js + npm | 安装 pyright | 系统包管理器 |
| pyright | Python LSP | `install.sh` 自动装到 `~/.local` |

插件本体和 parser **不在仓库里**，由 `vim.pack` / nvim-treesitter 安装到
`~/.local/share/nvim`，所以仓库很小、可跨架构使用。

## 目录结构

```
init.lua                  # 入口：插件清单 + 加载顺序
nvim-pack-lock.json       # 插件版本锁定（可提交，保证可复现）
lua/core/options.lua      # 编辑器选项、主题
lua/core/keymaps.lua      # 通用快捷键
lua/plugins/*.lua         # 每个插件的配置
install.sh                # 一键部署脚本
```

## 维护命令

```vim
:lua vim.pack.update()   " 更新全部插件（差异确认后 :write 应用）
:lua =vim.pack.get()     " 查看插件状态
:TSUpdate                " 更新 tree-sitter parser
:checkhealth             " 自检
```

## 快捷键（主要）

| 键 | 功能 |
|---|---|
| `<leader><leader>` | 开关文件树（nvim-tree） |
| `<leader>ff/fg/fb/fr/fh` | telescope：文件 / 全文搜索 / 缓冲区 / 最近 / 帮助 |
| `<C-i>/<C-k>/<C-j>/<C-l>` | 窗口 上 / 下 / 左 / 右 |
| `J` / `L` | 上一个 / 下一个 buffer 标签 |
| `<leader>bn/bp/bd` | buffer 下一个 / 上一个 / 关闭 |
| `gcc`、`gc<motion>` | 注释（Comment.nvim） |
| `gd` `gr` `K` `<leader>rn` `<leader>ca` | LSP：定义 / 引用 / 文档 / 重命名 / 代码操作 |
| `[d` / `]d` | 上一个 / 下一个诊断 |
| `]c` / `[c`、`<leader>hs/hr/hp` | gitsigns：hunk 跳转 / 暂存 / 撤销 / 预览 |
| `<C-Space>` `<Tab>` `<CR>` | 补全：手动触发 / 下一个 / 确认 |

`<leader>` 是空格。

## 注意

- nvim-treesitter 用的是 **main 分支**，必须 Neovim 0.12+；`master` 分支是为 0.11 冻结的
- 老的 treesitter 生态插件（依赖 `nvim-treesitter.configs` / `.query`）**不兼容**，
  需要换等价的新版插件
- 普通模式下 `<Tab>` 与 `<C-i>` 等价（终端限制），按 Tab 也会移动窗口
