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

## 工作流程

当用户给你一个 arxiv URL 或 ID 时，按以下步骤执行：

### Step 1: 下载 PDF

```bash
ARXIV_ID="从URL中提取的ID，如 2401.12345"
mkdir -p "$OBSIDIAN_VAULT/pdfs"
curl -sL "https://arxiv.org/pdf/$ARXIV_ID.pdf" -o "$OBSIDIAN_VAULT/pdfs/$ARXIV_ID.pdf"
```

### Step 2: 提取文本和图片

运行以下 Python 脚本提取论文全文和所有图片：

```bash
python3 << 'EOF'
import fitz, os, sys

arxiv_id = os.environ.get("ARXIV_ID", "REPLACE_ME")
vault = os.environ.get("OBSIDIAN_VAULT", "REPLACE_ME")

pdf_path = f"{vault}/pdfs/{arxiv_id}.pdf"
fig_dir = f"{vault}/figures/{arxiv_id}"
os.makedirs(fig_dir, exist_ok=True)

doc = fitz.open(pdf_path)

# 提取全文
full_text = ""
for page in doc:
    full_text += page.get_text() + "\n\n"
with open(f"/tmp/{arxiv_id}_text.md", "w") as f:
    f.write(full_text)

# 提取嵌入图片
for pn in range(len(doc)):
    for idx, img in enumerate(doc[pn].get_images(full=True)):
        xref = img[0]
        pix = fitz.Pixmap(doc, xref)
        if pix.n >= 5:
            pix = fitz.Pixmap(fitz.csRGB, pix)
        pix.save(f"{fig_dir}/page{pn+1}_img{idx+1}.png")

# 渲染每页为高清图片（完整保留 figure/table 排版）
for pn in range(len(doc)):
    pix = doc[pn].get_pixmap(matrix=fitz.Matrix(2, 2))
    pix.save(f"{fig_dir}/page_{pn+1}.png")

print(f"Done: {len(doc)} pages, figures saved to {fig_dir}")
doc.close()
EOF
```

### Step 3: 生成论文笔记

读取 `/tmp/{arxiv_id}_text.md` 中的论文全文，查看 `$OBSIDIAN_VAULT/figures/{arxiv_id}/` 中的可用图片，然后严格按照下面的模板生成笔记，写入 `$OBSIDIAN_VAULT/papers/{arxiv_id}.md`。

## 笔记模板

输出的笔记必须严格遵循以下结构：

```markdown
---
title: "论文完整标题"
authors: [作者1, 作者2, 作者3]
year: 2025
arxiv: "xxxx.xxxxx"
tags: [tag1, tag2, tag3]
status: unread
rating: 
date_added: YYYY-MM-DD
---

# 论文完整标题

> **一句话总结：** 用一句通俗的话概括这篇论文最核心的贡献

## 📋 基本信息
- **作者：** 作者1 (机构1), 作者2 (机构2)
- **发表：** 会议/期刊名称 年份
- **链接：** [arXiv](https://arxiv.org/abs/xxxx.xxxxx) | [PDF](../pdfs/xxxx.xxxxx.pdf)

## 🎯 研究动机与问题

用 3-5 段话详细说明：
- 这篇论文要解决什么问题？
- 为什么这个问题重要？现实中的痛点是什么？
- 现有方法有什么不足？具体的 gap 在哪里？

## 💡 核心方法

像写技术博客一样，用通俗易懂的语言分步骤讲解方法。
不要只翻译原文，要用自己的话重新组织，让读者能真正理解。

![[figures/xxxx.xxxxx/page_X.png]]
*Figure X: 方法概览图*

对上图的详细解读：逐步解释图中的每个组件和数据流向。

### 步骤一：xxx
详细解释...

### 步骤二：xxx
详细解释...

### 关键创新点
- 创新点1：为什么这样设计，相比之前的方法好在哪里
- 创新点2：...

## 🏗️ 模型架构 / 系统设计

![[figures/xxxx.xxxxx/page_X.png]]
*Figure X: 模型架构图*

逐模块解读架构图中的每个组件。

## 📊 实验与结果

### 实验设置
- **数据集：** 列出使用的数据集及规模
- **Baseline：** 列出对比方法
- **评估指标：** 列出使用的指标

### 主要结果

![[figures/xxxx.xxxxx/page_X.png]]
*Table X: 主要实验结果*

对表格的详细分析：不要只列数字，要解读趋势、对比差异、分析原因。

### 主要发现
1. 发现1 —— 解释其意义
2. 发现2 —— 解释其意义
3. 发现3 —— 解释其意义

## 🔍 消融实验 / 分析

![[figures/xxxx.xxxxx/page_X.png]]
*Table/Figure X: 消融实验结果*

分析每个消融实验的结论：哪个组件最重要？去掉什么会导致性能下降最多？

## 💭 个人思考
- **优点：** 这篇论文做得好的地方
- **局限：** 方法的局限性和潜在问题
- **启发：** 对后续研究的启发
- **可能的改进方向：** 你觉得可以怎么改进

## 🔗 相关论文
- [[papers/相关论文ID]] - 与本文的关系说明
- [[papers/相关论文ID]] - 与本文的关系说明

## 📝 关键引用
> "论文中最值得记住的一句原文"
```

## 图片处理规则

1. 优先使用页面渲染图 `page_N.png`（完整保留原始排版）
2. 嵌入图片 `pageN_imgM.png` 作为补充
3. **每张图都必须有中文说明和详细解读**
4. 架构图要逐模块解读，不能只说"如图所示"
5. 实验结果图/表要分析具体数字和趋势
6. 使用 Obsidian 嵌入语法：`![[figures/arxiv_id/filename.png]]`
7. 先用 `ls` 查看可用图片，选择最相关的插入

## 质量要求

- 核心方法部分是重点，要像写 blog 一样深入浅出，至少 500 字
- 不能只是翻译摘要或 introduction
- 每个 section 都要有实质内容
- 图片是笔记的核心组成部分，不能省略
- 相关论文尽量链接到 vault 中已有的笔记
- 整篇笔记至少 2000 字
