#!/bin/bash
# 使用 opencode 生成论文笔记
# 用法: ./summarize.sh <arxiv_id> [vault_path]

set -euo pipefail

ARXIV_ID="$1"
VAULT="${2:-$OBSIDIAN_VAULT}"

CACHE_DIR="$VAULT/.paper-cache"
TEXT_FILE="$CACHE_DIR/${ARXIV_ID}_text.md"
META_FILE="$CACHE_DIR/${ARXIV_ID}.xml"
FIG_DIR="$VAULT/figures/$ARXIV_ID"
OUTPUT="$VAULT/papers/$ARXIV_ID.md"

mkdir -p "$VAULT/papers"

if [[ ! -f "$TEXT_FILE" ]]; then
    echo "❌ 文本文件不存在，请先运行 extract.sh"
    exit 1
fi

# 列出可用的图片
FIGURES=$(ls "$FIG_DIR"/*.png 2>/dev/null | sort || echo "无图片")

echo "🤖 正在生成论文笔记..."

# 构建 prompt
PROMPT=$(cat << PROMPTEOF
你是一个论文解读专家。请根据以下论文全文，生成一份详细的 Obsidian 笔记。

## 要求：
1. 严格按照下面的模板格式输出
2. 每个 section 都要详细展开，不要敷衍
3. 核心方法部分要像写 blog 一样，用通俗的语言解释清楚
4. 在合适的位置插入图片引用（使用 Obsidian 格式 ![[figures/${ARXIV_ID}/xxx.png]]）
5. 对每张图都要有解读说明
6. 相关论文部分用 [[]] 双链格式
7. frontmatter 中的 tags 要准确反映论文领域

## 可用图片文件：
${FIGURES}

## 论文全文：
$(cat "$TEXT_FILE")

## 输出模板：
---
title: "论文标题"
authors: [作者列表]
year: 年份
arxiv: "${ARXIV_ID}"
tags: [标签]
status: unread
rating: 
date_added: $(date +%Y-%m-%d)
---

# 论文标题

> **一句话总结：** 

## 📋 基本信息
- **作者：**
- **机构：**
- **发表：**
- **链接：** [arXiv](https://arxiv.org/abs/${ARXIV_ID}) | [PDF](../pdfs/${ARXIV_ID}.pdf)

## 🎯 研究动机与问题

## 💡 核心方法
（详细分步骤讲解，插入相关 figure）

## 🏗️ 模型架构 / 系统设计
（插入架构图并解读）

## 📊 实验与结果
（插入关键表格/图表并分析）

### 主要发现

## 🔍 消融实验 / 分析

## 💭 个人思考
- **优点：**
- **局限：**
- **启发：**
- **可能的改进方向：**

## 🔗 相关论文

## 📝 关键引用
PROMPTEOF
)

# 调用 opencode 生成笔记
echo "$PROMPT" | opencode -p > "$OUTPUT"

echo "✅ 笔记已生成: $OUTPUT"
