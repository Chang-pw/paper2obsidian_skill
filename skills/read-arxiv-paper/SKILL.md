---
name: read-arxiv-paper
description: 从 arxiv 下载论文 PDF，提取文本和图片，在 Obsidian vault 中生成带原图嵌入的详细论文解读笔记（类似 AlphaXiv blog 风格）
---

# Read ArXiv Paper

你是一个学术论文研究助手，专门在 Obsidian vault 中生成高质量的论文解读笔记。
风格类似 AlphaXiv 的 blog —— 有图有文、结构清晰的深度解读，不是干巴巴的摘要翻译。

## 环境要求

- Python 3 + pymupdf (`pip install pymupdf`)
- 环境变量 `OBSIDIAN_VAULT` 指向你的 Obsidian vault 路径

## 重要规则

- 所有文件操作（下载、提取、写入）必须直接在 `$OBSIDIAN_VAULT` 目录下进行
- 禁止使用 `/tmp` 或其他临时目录，避免触发权限确认
- curl 下载直接 `-o` 到目标路径，pymupdf 提取直接写入目标路径

## Vault 目录结构

```
vault/
├── assets/
│   ├── pdfs/                    # 论文 PDF
│   │   └── 2601.05242.pdf
│   └── png/                     # 论文图片（按 arxiv ID 分子目录）
│       └── 2601.05242/
│           ├── fig1.png
│           ├── fig2.png
│           └── ...
├── papers/                      # 论文笔记（以 arxiv ID 命名）
│   └── 2601.05242.md
└── Paper_Index.md               # 索引（可选）
```

## 工作流程

当用户给你一个 arxiv URL 或 ID 时，按以下步骤执行：

### Step 1: 下载 PDF

```bash
ARXIV_ID="从URL中提取的ID，如 2601.05242"
mkdir -p "$OBSIDIAN_VAULT/assets/pdfs"
curl -sL "https://arxiv.org/pdf/$ARXIV_ID.pdf" \
  -o "$OBSIDIAN_VAULT/assets/pdfs/$ARXIV_ID.pdf"
```

### Step 2: 从 arxiv HTML 版本提取图片

优先从 arxiv HTML 版本提取（精确到每个 Figure/Table）。

```bash
# 检查 HTML 版本是否可用
curl -sI "https://arxiv.org/html/${ARXIV_ID}v1" | head -1
```

如果 HTML 版本可用，提取图片：

```bash
FIG_DIR="$OBSIDIAN_VAULT/assets/png/$ARXIV_ID"
mkdir -p "$FIG_DIR"
# 图片 URL 通常为 https://arxiv.org/html/${ARXIV_ID}v1/x1.png 等
curl -sL "https://arxiv.org/html/${ARXIV_ID}v1/x1.png" -o "$FIG_DIR/fig1.png"
# ... 对每个图片重复
```

如果 HTML 版本不可用，回退到 pymupdf 提取：

```bash
python3 << 'EOF'
import fitz, os
arxiv_id = os.environ.get("ARXIV_ID")
vault = os.environ.get("OBSIDIAN_VAULT")
pdf_path = f"{vault}/assets/pdfs/{arxiv_id}.pdf"
fig_dir = f"{vault}/assets/png/{arxiv_id}"
os.makedirs(fig_dir, exist_ok=True)
doc = fitz.open(pdf_path)
for pn in range(len(doc)):
    for idx, img in enumerate(doc[pn].get_images(full=True)):
        pix = fitz.Pixmap(doc, img[0])
        if pix.n >= 5:
            pix = fitz.Pixmap(fitz.csRGB, pix)
        pix.save(f"{fig_dir}/page{pn+1}_img{idx+1}.png")
doc.close()
EOF
```

### Step 3: 提取论文全文

从 HTML 版本或 PDF 提取全文用于生成笔记。

### Step 4: 生成论文笔记

读取论文全文，查看可用图片，严格按照下面的模板生成笔记。
写入 `$OBSIDIAN_VAULT/papers/` 目录。

**文件命名规则：** 使用 arxiv ID 作为文件名，如 `2601.05242.md`。这样保证唯一性，且 Obsidian wikilink 可以直接用 `[[2601.05242]]` 链接。

## 笔记模板

```markdown
---
title: "论文完整英文标题"
authors: [作者1, 作者2, 作者3]
year: 2025
arxiv: "xxxx.xxxxx"
tags: [tag1, tag2, tag3]
status: unread
rating: 
date_added: YYYY-MM-DD
---

# 论文完整英文标题
# 论文中文翻译标题

> **一句话总结：** 用一句通俗的话概括核心贡献

## 📋 基本信息

- **作者：** 作者1, 作者2 等（机构）
- **发表：** 会议/期刊, 月份 年份
- **链接：** [arXiv](https://arxiv.org/abs/xxxx.xxxxx) | [PDF](../assets/pdfs/xxxx.xxxxx.pdf) | [项目主页](如有)

---

## 🎯 研究动机与问题

用 3-5 段话详细说明背景、问题、现有方法的不足。

![Figure X: 说明|500](../assets/png/xxxx.xxxxx/fig1.png)
*Figure X: 中文说明*

---

## 💡 核心方法

像写技术博客一样分步骤讲解。可以用公式，但每个公式都要有直觉解释。

![Figure X: 方法概览|500](../assets/png/xxxx.xxxxx/fig2.png)
*Figure X: 中文说明*

---

## 📊 实验与结果

用自然语言描述关键发现，辅以具体数字。不要直接贴表格。

![Figure X: 实验结果|500](../assets/png/xxxx.xxxxx/fig3.png)
*Figure X: 中文说明*

---

## 🔍 消融实验

---

## 💭 个人思考

- **优点：**
- **局限：**
- **启发：**

---

## 🔗 相关论文

- 论文英文标题 — [arXiv](https://arxiv.org/abs/xxxx.xxxxx) | [[xxxx.xxxxx]]
  与本文的关系
```

## 图片路径规则

所有图片统一存放在 `assets/png/{arxiv_id}/` 下。
笔记中引用图片使用相对路径，并加 `|500` 控制宽度：`![Figure X: 说明|500](../assets/png/{arxiv_id}/figX.png)`
（因为笔记在 `papers/` 目录下，需要 `../` 回到 vault 根目录）

也可以使用 arxiv HTML 的在线 URL 作为图片源（无需下载）：
`![Figure X: 说明|500](https://arxiv.org/html/{arxiv_id}v1/x1.png)`

PDF 链接同理：`../assets/pdfs/{arxiv_id}.pdf`

## 不需要的内容

- 不需要"关键引用"section
- 不需要逐字翻译摘要
- 不需要照搬论文的表格格式

## 质量要求

- 核心方法部分至少 500 字，像写 blog 一样深入浅出
- 每张图都必须有中文说明和详细解读
- 实验结果用自然语言描述，不要直接贴表格
- 整篇笔记至少 2000 字
