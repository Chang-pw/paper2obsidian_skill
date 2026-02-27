# ArXiv Paper Skills for OpenCode / Claude Code / Cursor...

在 Obsidian 中用 AI 编程助手自动下载论文、提取图片、生成带原图的详细解读笔记。

兼容 40+ AI coding agents（OpenCode, Claude Code, Cursor, Codex 等）。

## 一键安装

```bash
# 安装到 opencode
npx skills add your-github-username/paper-skill -a opencode

# 安装到 claude code
npx skills add your-github-username/paper-skill -a claude-code

# 安装到所有已安装的 agent
npx skills add your-github-username/paper-skill --all

# 只安装特定 skill
npx skills add your-github-username/paper-skill --skill read-arxiv-paper

# 全局安装（所有项目可用）
npx skills add your-github-username/paper-skill -g
```

## 包含的 Skills

| Skill | 说明 |
|-------|------|
| `read-arxiv-paper` | 下载论文 PDF，提取图片，生成 AlphaXiv 风格的详细笔记 |
| `paper-index` | 扫描论文笔记，生成按主题/作者/状态分类的索引 |

## 前置依赖

```bash
pip install pymupdf
```

设置环境变量：
```bash
export OBSIDIAN_VAULT="$HOME/你的Vault路径"
```

## 使用方式

安装后在 opencode 中直接对话即可，agent 会自动发现并加载 skill：

```
帮我下载并解读这篇论文 https://arxiv.org/abs/2401.12345
```

```
更新一下我的论文索引
```

```
在我的论文库里搜索和 attention mechanism 相关的论文
```

## Vault 目录结构

```
your-vault/
├── papers/          # 论文笔记 (Markdown + 原图嵌入)
├── figures/         # 提取的论文图片
├── pdfs/            # 原始 PDF
└── indexes/         # 自动生成的索引
```

## 发布你自己的版本

1. Fork 这个仓库
2. 修改 SKILL.md 中的模板（比如加入你的研究方向）
3. Push 到 GitHub
4. 别人就能用 `npx skills add your-username/paper-skill` 安装
