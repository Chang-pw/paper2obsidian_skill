# ArXiv Paper Skills for OpenCode / Claude Code / Cursor...

在 Obsidian 中用 AI 编程助手自动下载论文、提取关键图片、生成深度解读笔记，并维护论文数据库索引。

兼容 40+ AI coding agents（OpenCode, Claude Code, Cursor, Codex 等）。

## 一键安装

```bash
# 安装所有 skills
npx skills add your-github-username/paper-skill --all

# 只安装特定 skill
npx skills add your-github-username/paper-skill --skill read-arxiv-paper
npx skills add your-github-username/paper-skill --skill paper-index

# 更新（重新安装最新版）
npx skills remove read-arxiv-paper
npx skills add your-github-username/paper-skill --skill read-arxiv-paper
```

## 包含的 Skills

| Skill | 说明 |
|-------|------|
| `read-arxiv-paper` | 下载 PDF，从 arxiv HTML 提取关键 Figure，生成深度解读笔记，完成后自动调用 paper-index 更新索引 |
| `paper-index` | 扫描论文笔记 frontmatter，按分类维护论文数据库索引表 |
| `paper-summary` | 根据指定论文或分类，生成聚焦于研究问题和方法论的综述报告（可作为面试复习材料） |

## 前置依赖

```bash
pip install pymupdf
```

设置环境变量：
```bash
export OBSIDIAN_VAULT="$HOME/你的Vault路径"
```

## 使用方式

安装后直接对话，agent 会自动加载 skill：

```
帮我下载并解读这篇论文 https://arxiv.org/abs/2601.05242
```

```
帮我读这三篇论文：2402.03300, 2503.14476, 2503.20783
```

```
帮我总结 2402.03300, 2503.14476, 2503.20783 这几篇的关系
```

```
帮我总结 LLM-RL 分类的论文
```

```
更新一下我的论文索引
```

## 工作流程

```
arxiv URL/ID
    │
    ├── Step 1: 下载 PDF → assets/pdfs/{id}.pdf
    ├── Step 2: 读取论文全文（必须读完才动笔）
    ├── Step 3: 生成解读笔记 → papers/{id}.md
    ├── Step 4: 按需下载引用的 Figure → assets/png/{id}/
    └── Step 5: 自动调用 paper-index 更新索引 → Paper_Index.md
```

## Vault 目录结构

```
your-vault/
├── assets/
│   ├── pdfs/              # 论文 PDF
│   │   └── 2601.05242.pdf
│   └── png/               # 论文图片（按 arxiv ID 分目录，只存引用的图）
│       └── 2601.05242/
│           ├── fig1.png
│           └── fig2.png
├── papers/                # 论文笔记（以 arxiv ID 命名）
│   └── 2601.05242.md
├── knowledge/
│   └── Summary/           # 综述报告（按分类中文名命名）
│       └── 大模型强化学习.md
└── Paper_Index.md         # 论文数据库索引
```

## 笔记特点

- 中文解读，保留英文原标题
- 侧重研究动机和核心方法，实验结果简要总结
- 图片从 arxiv HTML 精确提取，`|500` 控制宽度
- 相关论文用 `[[arxiv_id]]` wikilink 互相链接
- 索引按分类自动分表（LLM-RL、Alignment、Architecture 等）

## 自定义

Fork 后可以修改 `skills/read-arxiv-paper/SKILL.md` 中的：

- **写作风格偏好** — 调整各 section 的详略程度
- **分类规则** — 在 `skills/paper-index/SKILL.md` 中自定义 tag → 分类映射
- **笔记模板** — 增删 section、调整格式
