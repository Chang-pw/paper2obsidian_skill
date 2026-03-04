# 📄 Paper Skills

[English](#english) | [中文](#中文)

Agent skills for reading, indexing, and summarizing arXiv papers in Obsidian. Automatically downloads PDFs, extracts key figures, generates detailed Chinese notes, maintains a paper database, and creates interview-ready summary reports.

Compatible with 40+ AI coding agents via the [Agent Skills](https://agentskills.io/) format.

---

<a id="english"></a>

## Available Skills

### read-arxiv-paper

Download arXiv papers and generate in-depth reading notes in your Obsidian vault. Extracts key figures from arXiv HTML, writes structured Chinese notes with formulas and illustrations, and auto-updates the paper index.

**Use when:**
- "Read this paper https://arxiv.org/abs/2402.03300"
- "Download and summarize 2503.14476"
- "Read these three papers: 2402.03300, 2503.14476, 2503.20783"

**Features:**
- Downloads PDF to `assets/pdfs/`
- Extracts key figures from arXiv HTML version (per-figure, not whole-page)
- Generates structured notes with research motivation, core method, experiments
- Customizable writing style (currently optimized for LLM researchers)
- Auto-triggers `paper-index` skill after completion
- Image width controlled with `|500` for Obsidian rendering
- Cross-references via `[[arxiv_id]]` wikilinks

### paper-index

Scan paper notes and maintain categorized paper database using Obsidian Bases (.base files).

**Use when:**
- "Update my paper index"
- "Organize my papers"
- "Generate paper list"

**Features:**
- Reads frontmatter from all notes in `papers/notes/`
- Auto-generates `.base` files in `papers/index/`
- One master base (All-Papers.base) for all papers
- Per-category bases with tag-based filters (e.g. Reinforcement-Learning.base)
- Papers can appear in multiple category bases
- Requires Obsidian 1.9+ (Bases is a core plugin)

### paper-summary

Generate structured survey reports from multiple related papers. Designed as interview preparation material — every section is structured so you can "speak it out loud".

**Use when:**
- "Summarize 2402.03300, 2503.14476, 2503.20783"
- "Summarize the LLM-RL category"
- "Help me review the GRPO paper series"

**Features:**
- TLDR paragraph for quick interview prep
- Overview table: problem solved, core method, limitations per paper
- Evolution chain with mermaid diagram
- Per-paper deep dive: problem → prior work gaps → method with formulas → limitations
- Side-by-side method comparison table
- Open questions and future directions

## Installation

```bash
# Install all skills
npx skills add Chang-pw/paper2obsidian_skill --all

# Install specific skill
npx skills add Chang-pw/paper2obsidian_skill --skill read-arxiv-paper

# Install to specific agent
npx skills add Chang-pw/paper2obsidian_skill -a opencode --all
npx skills add Chang-pw/paper2obsidian_skill -a claude-code --all

# Update (re-install latest)
npx skills remove read-arxiv-paper paper-index paper-summary
npx skills add Chang-pw/paper2obsidian_skill --all
```

## Prerequisites

```bash
pip install pymupdf
```

Set your Obsidian vault path:
```bash
export OBSIDIAN_VAULT="$HOME/path/to/your/vault"
```

## Vault Structure

```
your-vault/
├── assets/
│   ├── pdfs/                  # Paper PDFs
│   │   └── 2402.03300.pdf
│   └── png/                   # Figures (by arXiv ID, only referenced ones)
│       └── 2402.03300/
│           ├── fig1.png
│           └── fig2.png
├── papers/
│   ├── index/                 # Obsidian Bases index (.base files)
│   │   ├── All-Papers.base    # All papers
│   │   ├── Reinforcement-Learning.base  # Category
│   │   └── ...
│   └── notes/                 # Paper notes (named by arXiv ID)
│       └── 2402.03300.md
├── knowledge/
│   └── Summary/               # Survey reports (named by category in Chinese)
│       └── 大模型强化学习.md
```

## Usage

Once installed, just talk to your agent:

```
Read this paper: https://arxiv.org/abs/2402.03300
```

```
Read these papers: 2402.03300, 2503.14476, 2503.20783
```

```
Summarize the LLM-RL category
```

```
Update my paper index
```

## Customization

Fork this repo and edit the SKILL.md files to fit your needs:

- `skills/read-arxiv-paper/SKILL.md` — Note template, writing style preferences, section priorities
- `skills/paper-index/SKILL.md` — Category mapping rules, index table format
- `skills/paper-summary/SKILL.md` — Survey report structure, detail level per section

## Skill Structure

```
paper2obsidian_skill/
├── skills/
│   ├── read-arxiv-paper/
│   │   └── SKILL.md          # Paper reading & note generation
│   ├── paper-index/
│   │   └── SKILL.md          # Database index maintenance
│   └── paper-summary/
│       └── SKILL.md          # Survey report generation
├── scripts/                   # Standalone shell scripts (optional)
└── README.md
```

## License

MIT

---

<a id="中文"></a>

## 中文说明

### 这是什么？

一套用于在 Obsidian 中阅读、索引和总结 arXiv 论文的 Agent Skills。自动下载 PDF、提取关键图片、生成详细的中文论文解读笔记、维护论文数据库、生成面试复习用的综述报告。

兼容 40+ AI 编程助手（OpenCode、Claude Code、Cursor、Codex 等），基于 [Agent Skills](https://agentskills.io/) 开放标准。

### 包含的 Skills

| Skill | 说明 |
|-------|------|
| `read-arxiv-paper` | 下载论文 PDF，从 arXiv HTML 提取关键 Figure，生成深度解读笔记，自动更新索引 |
| `paper-index` | 使用 Obsidian Bases 维护论文数据库，自动生成分类 .base 文件（需要 Obsidian 1.9+） |
| `paper-summary` | 根据指定论文或分类，生成面试复习用的综述报告（含公式对比、演化脉络、方法对比表） |

### 安装

```bash
# 安装所有 skills
npx skills add Chang-pw/paper2obsidian_skill --all

# 只安装特定 skill
npx skills add Chang-pw/paper2obsidian_skill --skill read-arxiv-paper

# 安装到指定 agent
npx skills add Chang-pw/paper2obsidian_skill -a opencode --all

# 更新（重新安装最新版）
npx skills remove read-arxiv-paper paper-index paper-summary
npx skills add Chang-pw/paper2obsidian_skill --all
```

### 前置依赖

```bash
pip install pymupdf
export OBSIDIAN_VAULT="$HOME/你的Vault路径"
```

### 使用方式

安装后直接和 agent 对话：

```
帮我读这篇论文 https://arxiv.org/abs/2402.03300
```

```
帮我读这三篇论文：2402.03300, 2503.14476, 2503.20783
```

```
帮我总结 LLM-RL 分类的论文
```

```
更新一下我的论文索引
```

### Vault 目录结构

```
your-vault/
├── assets/
│   ├── pdfs/                  # 论文 PDF
│   └── png/                   # 论文图片（按 arXiv ID 分目录，只存引用的图）
├── papers/
│   ├── index/                 # Obsidian Bases 索引（.base 文件）
│   │   ├── All-Papers.base
│   │   ├── Reinforcement-Learning.base
│   │   └── ...
│   └── notes/                 # 论文笔记（以 arXiv ID 命名）
│       └── 2402.03300.md
├── knowledge/
│   └── Summary/               # 综述报告（以分类中文名命名）
```

### 笔记特点

- 中文撰写，保留英文原标题
- 侧重研究动机和核心方法（适合大模型研究者），实验结果简要总结
- 图片从 arXiv HTML 精确提取关键 Figure，不全量下载
- 相关论文用 `[[arxiv_id]]` wikilink 互相链接
- 索引按分类自动分表

### 自定义

Fork 后修改 `skills/` 下的 SKILL.md 文件：

- **写作风格** — 在 `read-arxiv-paper/SKILL.md` 的"写作风格偏好"section 调整各部分详略
- **分类规则** — 在 `paper-index/SKILL.md` 中自定义 tag → 分类映射和 .base 文件模板
- **综述结构** — 在 `paper-summary/SKILL.md` 中调整报告模板和详细程度

### License

MIT
