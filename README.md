# Emacs 配置

一套以 Vim 使用习惯为中心的 Emacs 配置，结构和键位尽量与 `~/.vim` 对齐。

- 目标版本：Emacs 31+
- 图形界面优先（`valign`、`eldoc-box` 的 childframe 需要 GUI）
- 包管理：内置 `package.el` + `use-package`
- 主题：墨观 Inkstone · 沧海（从 `~/.vim/bundle/vim-inkstone` 移植）

## 目录结构

```text
~/.emacs.d/
├── early-init.el          # 启动最早期设置：GC、包目录、native-comp、UI
├── init.el                # 唯一入口，只按顺序 require
├── lisp/
│   ├── core/              # 基础设施
│   │   ├── options.el     # 基础选项、字体、Vim options 对齐
│   │   ├── packages.el    # package.el、use-package、no-littering
│   │   ├── builtin.el     # recentf、outline、save-place
│   │   ├── theme.el       # Inkstone 主题、Dashboard
│   │   └── keymaps.el     # my-leader-def 与基础 leader
│   ├── conf.d/            # 一个功能一个文件
│   │   ├── evil.el        # evil、sis、which-key、general
│   │   ├── editing.el     # undo、smartparens、rainbow、multiedit
│   │   ├── completion.el  # vertico、consult、corfu、cape、embark
│   │   ├── modeline.el    # doom-modeline 自定义布局
│   │   ├── markdown.el    # markdown-mode、valign、olivetti
│   │   ├── org.el         # Org、org-modern、org-appear
│   │   ├── dired.el       # dired、dirvish
│   │   ├── git.el         # magit、diff-hl
│   │   ├── session.el     # easysession、project.el
│   │   ├── easymotion.el  # evil-easymotion
│   │   ├── terminal.el    # eat
│   │   ├── format.el      # apheleia
│   │   ├── eglot.el       # eglot、flymake、eldoc-box
│   │   ├── spell.el       # jinx（当前未启用）
│   │   └── vim-parity.el  # 与 Vim 对齐的零散键位
│   └── themes/
│       └── inkstone-canghai-theme.el
├── lib/                   # 小型自定义库
├── var/                   # 包、缓存、历史、会话（git 忽略）
└── custom.el              # Customize 生成的变量
```

`init.el` 的加载顺序对应原来 Vim 配置里的 `core/*.vim` 和 `core/conf.d/*.vim`。

## 启动与性能

- `early-init.el` 在包系统初始化前设置：
  - `gc-cons-threshold`
  - `package-user-dir`
  - `native-comp-eln-load-path`
  - `custom-file`
- 启动完成后恢复 GC 和 `file-name-handler-alist`
- 重量级功能按需加载：
  - `eglot` 在打开编程 buffer 时
  - `magit` 在第一次调用时
  - `dirvish` 在 Dired / `SPC ft` 时
  - `eat`、`apheleia`、`evil-easymotion`、`marginalia`、`cape` 等延迟加载
- 安装/升级包后如果发现 package 目录异常，可重启 Emacs 让包索引重新生成。

## 依赖与外部命令

必需：

- Emacs 31+
- Nerd Font，例如 `JetBrainsMono Nerd Font`
- 中文字体 `lxgw wenkai mono`

可选但推荐：

- `ripgrep`：`consult-ripgrep`
- `clangd` / `pyright-langserver` / `rust-analyzer` / `gopls` 等：`eglot`
- `hunspell-en_US`：如果重新启用 `jinx` 拼写检查
- LaTeX / `dvipng`：Markdown 数学公式渲染

## 键位

Leader 是 `SPC`。大部分分组由 `use-package` 的 `:which-key` 提供，`which-key` 显示在底部 side window。

### 基础

| 键 | 功能 |
|---|---|
| `SPC q` | 关闭窗口；最后一个窗口则退出 Emacs |
| `SPC Q` | 退出 Emacs |
| `SPC fs` / `C-s` | 保存 |
| `SPC fS` | 以 root 保存 |
| `SPC ci` | 注释/反注释 |
| `SPC y` | kill-ring 历史 |
| `C-g` | 清除搜索高亮 |
| `M-j` / `M-k` | 当前行下移/上移 |
| `zh/zj/zk/zl` | 窗口左/下/上/右切换 |

### 文件、Buffer、窗口

| 键 | 功能 |
|---|---|
| `SPC ff` / `SPC fr` | 查找文件 / 最近文件 |
| `SPC ft` / `\` | 打开/关闭 dirvish 文件树 |
| `SPC sb` | 切换 buffer |
| `SPC bn` / `SPC bp` | 下一个 / 上一个 buffer |
| `SPC bd` | 关闭当前 buffer |
| `SPC b1..b9` | 切换到第 1..9 个 tab |
| `SPC w1..w9` | 切换到第 1..9 个窗口 |
| `SPC wc` | 关闭窗口 |
| `SPC ws` / `SPC wv` | 上下 / 左右分屏 |

### 搜索

| 键 | 功能 |
|---|---|
| `SPC sl` / `SPC ss` | 当前文件搜索 |
| `SPC sr` | 项目内 ripgrep |
| `SPC sd` | 查找文件 |
| `SPC sh` | 搜索帮助 |
| `SPC sy` | kill-ring 历史 |

### Git

| 键 | 功能 |
|---|---|
| `SPC gg` / `C-x g` | magit status |
| `SPC ga` | stage 所有修改 |
| `SPC gb` | blame |
| `SPC gc` | commit |
| `SPC gd` | diff |
| `SPC gr` | 还原文件 |
| `SPC gps` / `SPC gpl` | push / pull |
| `SPC gx` | 切换 diff-hl 高亮 |
| `SPC gw` | 保存仓库内 buffer |

### LSP

| 键 | 功能 |
|---|---|
| `gd` | 跳转定义 |
| `gy` / `gi` | 类型定义 / 实现 |
| `gr` | 查找引用 |
| `K` / `SPC jk` | 显示文档（GUI 下为 eldoc-box 浮窗） |
| `[g` / `]g` | 上一个 / 下一个诊断 |
| `SPC ja` | code action |
| `SPC jc` | 当前行诊断 |
| `SPC jd` | 诊断列表 |
| `SPC jf` | quickfix |
| `SPC jF` | organize imports |
| `SPC jr` | rename |
| `SPC j=` | 格式化 buffer |
| `SPC jR` / `SPC jS` | 重连 / 关闭 LSP |
| `SPC js` | 工作区符号 |
| `SPC jo` | imenu / outline |

### 项目与会话

| 键 | 功能 |
|---|---|
| `SPC sp` | 切换项目 |
| `SPC pa` | 记住当前项目 |
| `SPC ps` | 保存会话 |
| `SPC po` | 打开会话 |
| `SPC pr` | 重命名会话 |
| `SPC pd` | 删除会话 |
| `SPC pc` | 关闭会话 |

### 终端、包、跳转

| 键 | 功能 |
|---|---|
| `SPC tt` / `SPC tn` / `SPC tk` | 切换 / 新建 / 关闭 eat 终端 |
| `SPC Pi` / `SPC Pu` / `SPC Pg` | 安装 / 升级 / 刷新包 |
| `SPC ef` / `SPC eF` | easymotion 字符跳转 |
| `SPC ew` / `SPC eb` | easymotion 单词跳转 |
| `SPC ej` / `SPC ek` | easymotion 行跳转 |
| `;=` | apheleia 格式化 |

### Tab

| 键 | 功能 |
|---|---|
| `M-1` … `M-8` | 切换到第 1…8 个 tab |
| `M-9` | 最后一个 tab |
| `M-0` | 最近访问的 tab |
| `SPC b1..b9` | 同上，按 tab 编号切换 |

`tab-bar-tab-hints` 已开启，tab 上会显示编号。新建 tab 默认打开 `*scratch*`，不会复制当前 buffer。

### Dashboard

| 键 | 功能 |
|---|---|
| `r` | Recent Files |
| `p` | Projects |
| `s` | Sessions |
| `e` | 新建空 buffer |
| `q` | 关闭窗口；最后一个窗口则退出 Emacs |

## 主题与 modeline

- 主题：`lisp/themes/inkstone-canghai-theme.el`
- 取色：`~/.vim/bundle/vim-inkstone` 的 `canghai`
- modeline：`doom-modeline`
  - 显示 Evil 状态文字：`NORMAL` / `INSERT` / `VISUAL` 等
  - 项目、Git、LSP、诊断、行:列、文件大小、编码、缩进、major mode、时间
  - Dashboard 有独立 modeline 布局

如果不想显示图标，可在 `lisp/conf.d/modeline.el` 或 `custom.el` 中设置：

```elisp
(setq doom-modeline-icon nil
      doom-modeline-major-mode-icon nil
      doom-modeline-vcs-icon nil
      doom-modeline-check-icon nil
      doom-modeline-lsp-icon nil)
```

## 注意事项

### 旧的 Emacs daemon 不会自动加载新配置

修改配置后，如果使用 daemon：

```bash
emacsclient -e '(kill-emacs)'
emacs --daemon
emacsclient -c
```

或者直接在 Emacs 里：

```elisp
M-x load-file RET ~/.emacs.d/init.el RET
```

### valign 只在 GUI 生效

`valign` 在终端下不会工作。终端需要真正修改表格时使用：

```elisp
M-x markdown-table-align RET
```

### Alt+数字被桌面环境占用

如果 `M-1` 等被窗口管理器截获，可以改用 `Super`：

```elisp
(setopt tab-bar-select-tab-modifiers '(super))
```

或 `Control`：

```elisp
(setopt tab-bar-select-tab-modifiers '(control))
```

### 拼写检查

`jinx` 当前未启用。需要时取消 `init.el` 中的注释：

```elisp
(require 'conf.d/spell)
```

并安装英文词典，例如：

```bash
sudo pacman -S hunspell-en_US
```

## 测试文档

`test.md` 是一个手动测试文档，包含：

- 中英文混排
- Markdown 表格
- LaTeX 公式
- 代码块
- `f` 字符跳转

可以用它检查 Markdown、valign、olivetti、数学渲染和 Evil 跳转是否正常。
