# paper-reading

> 单篇研究论文阅读助手 —— 一个 Claude Code Skill
>
> 📖 [English version](./README.en.md)

把任意论文丢给 Claude（粘贴文本、读 PDF、抓 URL 都行），然后用自然语言提问。Skill 自动识别，按四种模式之一回答：**快速总结 / Q&A 问答 / 术语公式解释 / 批判性评估**。零命令、零学习成本。

## 特性

- **强 Grounding**：每个事实性回答都注明论文出处（章节 / 段 / 图表号）；论文里没说的会明确告知，不脑补、不编造
- **不臆造引用**：不发明论文里不存在的参考文献或作者
- **语言匹配**：用中文问就用中文答，英文反之
- **分层加载**：轻量任务直接处理；批判性评估这种重型任务才加载完整方法论（5C + 三遍法 checklist），不拖慢日常使用
- **极简表面**：纯语义触发，没有任何斜杠命令需要记
- **零副作用**：仅对话输出，不写任何文件

## 安装

### 方式 1：通过 `npx skills`（最简单）

```bash
npx skills add CUTEPKQ/paper-reading -a claude-code -g
```

> ⚠️ 已知 [vercel-labs/skills#851](https://github.com/vercel-labs/skills/issues/851)：有时 `npx skills` 只装到 `~/.agents/skills/` 而没在 `~/.claude/skills/` 建软链，导致 Claude Code 看不到。手动补：
>
> ```bash
> ln -s ~/.agents/skills/paper-reading ~/.claude/skills/paper-reading
> ```

### 方式 2：直接 clone 到 skills 目录

```bash
git clone https://github.com/CUTEPKQ/paper-reading.git ~/.claude/skills/paper-reading
```

### 方式 3：clone 到任意位置 + 软链（推荐想跟踪上游更新的用户）

```bash
git clone https://github.com/CUTEPKQ/paper-reading.git ~/code/paper-reading
cd ~/code/paper-reading && ./install.sh
```

`install.sh` 会把仓库软链到 `~/.claude/skills/paper-reading`。以后 `git pull` 后改动立即生效。

### 验证安装

启动一个新的 Claude Code 会话，输入：

```
列出可用的 skills
```

应该看到 `paper-reading` 出现在列表里。

## 推荐搭配：Marginalia

[Marginalia](https://github.com/chenhaoqcdyq/marginalia-releases) 是一款 macOS 桌面应用——左边读 PDF，右边嵌入真·Claude Code 终端。PDF 上划选的文字、论文全文、每篇论文的对话历史，会自动注入到 Claude 的上下文里。

**和本 skill 是天作之合**：
- **Marginalia** 负责"把论文搬进 Claude 的上下文"——打开 PDF 就能问，无需复制粘贴、无需手动 Read
- **paper-reading** 负责"在上下文里读懂、问答、评估、解释"

工作流：在 Marginalia 打开论文 → 右侧终端直接说"总结一下"或"5C 评估"，skill 自动触发，回答里能直接引用 §3.2 / 公式 4。

## 使用

**前提**：论文内容必须先进入对话上下文。常见做法：

- **用 [Marginalia](https://github.com/chenhaoqcdyq/marginalia-releases)（最丝滑）**：打开 PDF 自动注入，划选片段自动跟踪
- 直接把论文文本粘贴进对话
- 让 Claude 用 Read 工具读本地 PDF
- 让 Claude 用 WebFetch 拉取 URL（arXiv 链接、HTML 论文等）

**然后用自然语言提问**——Skill 会自动按对应模式回答：

| 你想做的 | 怎么说（例） |
|---|---|
| 看个总结 | "总结一下"、"TL;DR"、"这篇讲什么"、"一句话讲清楚" |
| 问具体问题 | "这个方法怎么解决 X"、"实验用的什么数据集"、"为什么选这个 baseline" |
| 解释术语公式 | "公式 3 什么意思"、"什么是 attention"、"这个算法怎么工作" |
| 批判性评估 | "评估这篇"、"5C 分析"、"审稿一下"、"有什么问题" |

## 四种模式

### 1. 快速总结

默认输出 5 要点的结构化短总结（150-250 字）：
- **Problem**：论文解决什么问题
- **Method**：核心技术路线
- **Key insight**：最重要的 idea
- **Results**：主要实验结果
- **Limitations**：作者承认的或显见的局限

用户说"一句话" → 浓缩；说"详细一点" → 展开到 400-600 字。

### 2. Q&A 问答

针对论文内容直接回答。每个事实性陈述都注明论文位置（"§3.2 提到……"、"Table 2 显示……"）。论文里没讨论的，明说"论文没提"，不用通识知识补全。

### 3. 术语 / 公式 / 算法 / 段落解释

**单概念 / 公式 / 算法**——三段式：
1. 在论文上下文里这个概念指什么（先 grounding）
2. 一般意义上的含义（背景，已熟悉则跳过）
3. 类比或最小例子让人秒懂

公式专门处理：拆解符号 → 直觉/物理含义 → 最小数值示例。

**段落 / 一大块文本**（如"解释这部分"）——短意译：
- 默认 1-3 句话 / 段落，全篇 ≤ 200 字，必要时点出 2-3 个非显然术语
- 不逐句拆 + 不"解读"每一句 + 不原文照搬
- 只有明说"逐句解释"才走 sentence-by-sentence

### 4. 批判性评估（最重）

加载 `references/critical-review.md`，按完整 checklist 走，按固定模板输出：

```
## 5C overview
- Category / Context / Correctness / Contributions / Clarity

## Implicit assumptions
## Method / experiment issues
## Missing comparisons or related work
## Reproducibility
```

长度通常 400-800 字。基于 [S. Keshav, *How to Read a Paper*](https://web.stanford.edu/class/ee384m/Handouts/HowtoReadPaper.pdf) 的 5C 框架 + 第三遍 "virtual re-implementation" 思路。

## 设计哲学

1. **分层加载**：轻量能力放主文件，重型方法论放 references/，按需加载——既快又详
2. **强 Grounding**：所有原则围绕"不脑补、不编造、可溯源"——这是论文阅读最关键的反幻觉机制
3. **极简表面**：纯语义触发，零命令；输入由用户/其他工具准备好，skill 只专注"理解和讲解"

## 文件结构

```
paper-reading/
├── SKILL.md                       # 主文件：YAML frontmatter + 核心原则 + 四种模式
└── references/
    └── critical-review.md         # 批判性评估方法论（5C + 三遍法 checklist + 输出模板）
```

## 明确不做的事（YAGNI）

- 不解析 PDF / 不拉 URL / 不抓 arXiv（用 Claude 自带工具足够）
- 不做文献综述、跨论文比较、引用网络分析
- 不与任何笔记系统集成
- 不提供斜杠命令
- 不持久化任何输出

## 致谢

批判性评估方法论改编自 [S. Keshav, *How to Read a Paper*](https://web.stanford.edu/class/ee384m/Handouts/HowtoReadPaper.pdf)。

## License

[MIT](./LICENSE)
