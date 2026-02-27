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

### Step 1: 下载 PDF 和获取元数据

```bash
ARXIV_ID="从URL中提取的ID，如 2601.05242"
mkdir -p "$OBSIDIAN_VAULT/pdfs"
curl -sL "https://arxiv.org/pdf/$ARXIV_ID.pdf" -o "$OBSIDIAN_VAULT/pdfs/$ARXIV_ID.pdf"
```

### Step 2: 从 arxiv HTML 版本提取图片

优先从 arxiv 的 HTML 版本提取图片（精确到每个 Figure/Table），而不是从 PDF 整页渲染。

```bash
# 检查 HTML 版本是否可用
curl -sI "https://arxiv.org/html/${ARXIV_ID}v1" | head -1
```

如果 HTML 版本可用，从 HTML 中提取每个 figure 的图片 URL：
- 图片 URL 格式通常为: `https://arxiv.org/html/${ARXIV_ID}v1/x1.png`, `x2.png` 等
- 或者 `extracted/figures/` 路径下的图片

```bash
FIG_DIR="$OBSIDIAN_VAULT/figures/$ARXIV_ID"
mkdir -p "$FIG_DIR"
# 下载每个 figure 图片，命名为 fig1.png, fig2.png 等
curl -sL "https://arxiv.org/html/${ARXIV_ID}v1/x1.png" -o "$FIG_DIR/fig1.png"
# ... 对每个图片重复
```

如果 HTML 版本不可用，回退到 pymupdf 提取：

```bash
python3 << 'EOF'
import fitz, os

arxiv_id = os.environ.get("ARXIV_ID")
vault = os.environ.get("OBSIDIAN_VAULT")
pdf_path = f"{vault}/pdfs/{arxiv_id}.pdf"
fig_dir = f"{vault}/figures/{arxiv_id}"
os.makedirs(fig_dir, exist_ok=True)

doc = fitz.open(pdf_path)
# 提取全文
with open(f"/tmp/{arxiv_id}_text.md", "w") as f:
    for page in doc:
        f.write(page.get_text() + "\n\n")
# 提取嵌入图片
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

从 HTML 版本或 PDF 提取论文全文用于生成笔记。

### Step 4: 生成论文笔记

读取论文全文，查看可用图片，严格按照下面的模板生成笔记。

**文件命名规则：** 笔记文件名使用论文英文标题（空格替换为下划线，去掉特殊字符），如 `GDPO_Group_reward-Decoupled_Normalization_Policy_Optimization.md`

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

> **一句话总结：** 用一句通俗的话概括这篇论文最核心的贡献

## 📋 基本信息

- **作者：** 作者1, 作者2 等（机构）
- **发表：** 会议/期刊, 月份 年份
- **链接：** [arXiv](https://arxiv.org/abs/xxxx.xxxxx) | [PDF](https://arxiv.org/pdf/xxxx.xxxxx.pdf) | [项目主页](如有)

---

## 🎯 研究动机与问题

用 3-5 段话详细说明背景、问题、现有方法的不足。
像写 blog 一样，让读者理解"为什么需要这篇论文"。

![Figure X: 说明](图片URL或本地路径)
*Figure X: 中文说明，解释图中展示的核心问题*

---

## 💡 核心方法

像写技术博客一样，用通俗易懂的语言分步骤讲解方法。
不要只翻译原文，要用自己的话重新组织。
可以用公式，但每个公式都要有直觉解释。

### 子标题1
详细解释...

![Figure X: 方法概览](图片URL或本地路径)
*Figure X: 中文说明，逐步解释图中的组件和数据流*

### 子标题2
详细解释...

### 关键创新点
- 创新点1：为什么这样设计，好在哪里
- 创新点2：...

---

## 📊 实验与结果

### 1. 任务/数据集名称

简要说明实验设置，然后用自然语言描述结果。
不要直接贴表格，而是用文字总结关键发现，辅以具体数字。

![Figure X: 实验结果](图片URL或本地路径)
*Figure X: 中文说明，分析训练曲线/结果图的关键趋势*

关键发现：
- 发现1 —— 具体数字和解释
- 发现2 —— 具体数字和解释

### 2. 下一个任务...

---

## 🔍 消融实验

用自然语言描述消融实验的结论，不要只列表格。
重点说明哪个组件最重要、去掉什么影响最大。

---

## 💭 个人思考

- **优点：** 这篇论文做得好的地方
- **局限：** 方法的局限性和潜在问题
- **启发：** 对后续研究的启发，可以推广到哪些场景

---

## 🔗 相关论文

- 论文完整英文标题 — [arXiv](https://arxiv.org/abs/xxxx.xxxxx) | [[papers/论文文件名]]
  一句话说明与本文的关系

- 论文完整英文标题 — [arXiv](https://arxiv.org/abs/xxxx.xxxxx) | [[papers/论文文件名]]
  一句话说明与本文的关系
```

## 图片处理规则

1. **优先从 arxiv HTML 版本提取**：精确到每个 Figure/Table，而非整页截图
2. 图片 URL 可以直接使用 arxiv 的 URL（如 `https://arxiv.org/html/xxxx.xxxxxv1/x1.png`），也可以下载到本地 `figures/` 目录后用 Obsidian 嵌入语法
3. 使用 Markdown 标准图片语法：`![说明](URL或路径)`
4. **每张图都必须有中文说明和详细解读**
5. 架构图要逐模块解读
6. 实验结果图要分析具体趋势，不能只说"如图所示"

## 文件命名规则

- 笔记文件名：论文英文标题（下划线连接），如 `GDPO_Group_reward-Decoupled_Normalization_Policy_Optimization.md`
- 标题行：同时包含英文原标题和中文翻译

## 实验结果表达规则

- **不要直接复制论文中的表格**，用自然语言描述关键发现
- 辅以具体数字（如"GDPO 在 AIME 上比 GRPO 高 6.3%"）
- 配合训练曲线图分析趋势
- 像 blog 一样讲故事，而不是罗列数据

## 相关论文格式

每篇相关论文包含：
- 论文完整英文标题
- arXiv 链接
- Obsidian 双链 `[[papers/文件名]]`（如果 vault 中还没有该论文的笔记，也要写上双链占位，方便后续创建时自动关联）
- 一句话说明与本文的关系

## 不需要的内容

- 不需要"关键引用"section
- 不需要逐字翻译摘要
- 不需要照搬论文的表格格式

## 质量要求

- 核心方法部分是重点，要像写 blog 一样深入浅出，至少 500 字
- 每个 section 都要有实质内容
- 图片是笔记的核心组成部分，不能省略
- 整篇笔记至少 2000 字
