这是一份专门为你配置的环境准备的 **Markdown 综合测试文档**。它包含了标题层级、列表、表格，以及你最关心的 **LaTeX 公式**，可以用来检验实时渲染和 `f` 字符跳转的效果。

---

# Markdown 渲染与跳转测试报告

## 1. 基础样式与跳转测试

这是一个包含 **中文** 和 **English** 的段落。你可以测试你的 `f` 跳转功能：

* 尝试按 `f测` 跳到“测试”。
* 尝试按 `f段` 跳到“段落”。
* 尝试按 `fj` 跳到单词 "jump"。

**列表测试：**

* [ ] 任务一：配置 Emacs 沉浸式环境
* [x] 任务二：实现 `evil-simple-f` 跨行跳转
* [ ] 任务三：测试 LaTeX 实时渲染

## 2. 数学公式测试 (LaTeX)

如果你开启了 `xenops` 或 `markdown-enable-math`，下面的公式应该可以被渲染。

### 行内公式 (Inline)

质能方程是 $E = mc^2$，而勾股定理是 $a^2 + b^2 = c^2$。

### 块级公式 (Display)

这是一个更复杂的麦克斯韦方程组测试：

$$\begin{cases}
\nabla \cdot \mathbf{E} = \frac{\rho}{\varepsilon_0} \\
\nabla \cdot \mathbf{B} = 0 \\
\nabla \times \mathbf{E} = -\frac{\partial \mathbf{B}}{\partial t} \\
\nabla \times \mathbf{B} = \mu_0\mathbf{J} + \mu_0\varepsilon_0\frac{\partial \mathbf{E}}{\partial t}
\end{cases}$$

> **测试提示**：将光标移动到公式上，观察 `xenops` 是否会自动展开源码；离开时是否恢复图片。

## 3. 表格对齐测试

如果你安装了 `valign`，表格即使包含中英文也能对齐：

| 插件名称      | 功能       | 状态 |
|---------------|------------|------|
| Evil-simple-f | 字符跳转   | 满意 |
| Xenops        | LaTeX 渲染 | 待测 |
| Olivetti      | 居中写作   | 待测 |

## 4. 代码块测试

```elisp
(defun hello-emacs ()
  (message "Markdown 写作环境测试成功！"))

```

---

### 如何使用此文档进行调试？

1. **测试 LaTeX**：
* 将此内容保存为 `test.md`。
* 按下 `C-c C-x C-l` 看看公式是否变成精美的数学符号。
* 如果没反应，检查你的 `exec-path` 是否包含 `latex` 和 `dvipng`。


2. **测试视觉消噪**：
* 观察标题 `#` 和加粗 `**` 是否在光标离开后自动消失。


3. **测试跨行跳转**：
* 在第一行按下 `f码`，看光标是否能瞬间飞到最下面的“代码块”位置。



**你现在的渲染效果符合预期吗？如果 LaTeX 图片太小或报错，我可以帮你调优渲染参数。**
