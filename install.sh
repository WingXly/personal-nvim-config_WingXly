#!/usr/bin/env bash
# Neovim 配置一键部署 / 依赖安装（Linux x86_64 / aarch64）
#
#   ./install.sh            复制本仓库到 ~/.config/nvim 并安装全部依赖
#   ./install.sh --link     用符号链接部署（仓库即配置源头，改完立即生效）
#   ./install.sh --deps     只安装/检查依赖，不动配置
#
# 依赖：Neovim >= 0.12、git、curl、tar；可选 npm（pyright）
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
BIN="$HOME/.local/bin"
MODE="copy"

for a in "$@"; do
  case "$a" in
    --link) MODE="link" ;;
    --deps) MODE="deps" ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    *) echo "未知参数: $a" >&2; exit 1 ;;
  esac
done

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m  ✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m  !\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m  ✗\033[0m %s\n' "$*" >&2; exit 1; }

# ── 1. Neovim 版本 ────────────────────────────────────────────
say "检查 Neovim"
command -v nvim >/dev/null || die "未找到 nvim（本配置需要 >= 0.12）"
ver="$(nvim --version | head -1 | sed 's/^NVIM v//')"
major="${ver%%.*}"
rest="${ver#*.}"
minor="${rest%%.*}"
minor="${minor%%[^0-9]*}"
if [ "${major:-0}" -lt 1 ] && [ "${minor:-0}" -lt 12 ]; then
  die "当前 nvim $ver，本配置需要 >= 0.12（依赖 vim.pack 与 nvim-treesitter main 分支）"
fi
ok "nvim $ver"

# ── 2. ~/.local/bin 加入 PATH ─────────────────────────────────
mkdir -p "$BIN"
case ":$PATH:" in
  *":$BIN:"*) ;;
  *)
    export PATH="$BIN:$PATH"
    if ! grep -q '用户级可执行目录' "$HOME/.bashrc" 2>/dev/null; then
      printf '\n# 用户级可执行目录\ncase ":$PATH:" in\n  *":$HOME/.local/bin:"*) ;;\n  *) PATH="$HOME/.local/bin:$PATH" ;;\nesac\nexport PATH\n' >> "$HOME/.bashrc"
      warn "$BIN 已加入 ~/.bashrc（新开 shell 生效）"
    fi
    ;;
esac

# ── 3. tree-sitter CLI（nvim-treesitter main 分支硬依赖）───────
say "tree-sitter CLI（>= 0.26）"
need_ts=1
if command -v tree-sitter >/dev/null; then
  tsver="$(tree-sitter --version | awk '{print $2}')"
  case "$tsver" in
    0.2[6-9].*|0.[3-9][0-9].*|[1-9].*) need_ts=0; ok "已安装 $tsver" ;;
    *) warn "已装 $tsver，低于 0.26，重新安装" ;;
  esac
fi
if [ "$need_ts" = 1 ]; then
  case "$(uname -m)" in
    x86_64)         asset=tree-sitter-cli-linux-x64.zip ;;
    aarch64|arm64)  asset=tree-sitter-cli-linux-arm64.zip ;;
    *) die "不支持的架构 $(uname -m)" ;;
  esac
  tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
  curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/latest/download/$asset" -o "$tmp/ts.zip"
  if command -v unzip >/dev/null; then
    unzip -oq "$tmp/ts.zip" -d "$tmp"
  else
    python3 -c 'import sys,zipfile;zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])' "$tmp/ts.zip" "$tmp"
  fi
  install -m 755 "$tmp/tree-sitter" "$BIN/tree-sitter"
  ok "已安装 $(tree-sitter --version)"
fi

# ── 4. ripgrep（telescope 搜索）───────────────────────────────
say "ripgrep"
if command -v rg >/dev/null; then
  ok "已安装 $(rg --version | head -1)"
elif command -v apt-get >/dev/null && command -v dpkg-deb >/dev/null; then
  tmp="$(mktemp -d)"
  ( cd "$tmp" && apt-get download ripgrep >/dev/null 2>&1 ) || true
  deb="$(ls "$tmp"/ripgrep_*.deb 2>/dev/null | head -1 || true)"
  if [ -n "$deb" ]; then
    dpkg-deb -x "$deb" "$tmp/x"
    install -m 755 "$tmp/x/usr/bin/rg" "$BIN/rg"
    ok "已安装 $(rg --version | head -1)"
  else
    warn "自动安装失败，请手动执行：sudo apt install -y ripgrep"
  fi
  rm -rf "$tmp"
else
  warn "请手动安装 ripgrep（telescope 的搜索依赖）"
fi

# ── 5. pyright（Python LSP）───────────────────────────────────
say "pyright"
if command -v pyright-langserver >/dev/null; then
  ok "已安装"
elif command -v npm >/dev/null; then
  if npm install -g --prefix "$HOME/.local" pyright >/dev/null 2>&1; then
    ok "已安装 $(pyright --version 2>/dev/null || echo '')"
  else
    warn "npm 安装失败，Python 的补全/诊断将不可用"
  fi
else
  warn "未找到 npm，跳过（需要 Node.js）"
fi

# ── 6. clangd（C/C++ LSP，需要 sudo）──────────────────────────
say "clangd"
if command -v clangd >/dev/null; then
  ok "已安装 $(clangd --version | head -1)"
else
  warn "未安装，请手动执行：sudo apt install -y clangd"
fi

# ── 7. 部署配置 ───────────────────────────────────────────────
if [ "$MODE" != "deps" ]; then
  if [ "$SRC" = "$DST" ]; then
    ok "配置已在目标位置（$DST）"
  elif [ "$MODE" = "link" ]; then
    [ -e "$DST" ] && mv "$DST" "$DST.bak.$(date +%s)"
    mkdir -p "$(dirname "$DST")"
    ln -s "$SRC" "$DST"
    ok "$DST -> $SRC（符号链接）"
  else
    [ -e "$DST" ] && mv "$DST" "$DST.bak.$(date +%s)"
    mkdir -p "$(dirname "$DST")"
    cp -r "$SRC" "$DST"
    rm -rf "$DST/.git" "$DST/_backup"
    ok "已复制到 $DST"
  fi
fi

# ── 8. 首次启动：装插件 + 编译 parser ─────────────────────────
if [ "$MODE" != "deps" ]; then
  say "安装插件（vim.pack 首次启动会自动 clone）"
  nvim --headless -c 'qa' 2>&1 | tail -3 || true

  say "编译 tree-sitter parser：c / cpp / python（耗时约 1 分钟）"
  nvim --headless \
    -c "lua require('nvim-treesitter').install({'c','cpp','python'}):wait(1800000)" \
    -c 'qa!' 2>&1 | tail -5 \
    || warn "parser 安装未完成，可稍后在 nvim 里执行 :lua require('nvim-treesitter').install({'c','cpp','python'})"
fi

echo
say "完成。打开 nvim 即可使用；后续维护："
echo "    :lua vim.pack.update()    更新插件"
echo "    :TSUpdate                 更新 treesitter parser"
echo "    :checkhealth              自检"
