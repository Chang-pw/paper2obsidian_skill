#!/bin/bash
# 一键处理论文：下载 → 提取 → 生成笔记
# 用法: ./paper.sh <arxiv_url_or_id> [vault_path]
#
# 环境变量:
#   OBSIDIAN_VAULT - Obsidian vault 的路径
#
# 示例:
#   export OBSIDIAN_VAULT=~/Documents/MyVault
#   ./paper.sh https://arxiv.org/abs/2401.12345
#   ./paper.sh 2401.12345

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
INPUT="$1"
VAULT="${2:-$OBSIDIAN_VAULT}"

export OBSIDIAN_VAULT="$VAULT"

echo "📄 论文处理流水线启动"
echo "========================"

# Step 1: 下载
echo ""
echo "📥 Step 1/3: 下载论文..."
ARXIV_ID=$("$SCRIPT_DIR/download.sh" "$INPUT" "$VAULT" | tail -1)

# Step 2: 提取
echo ""
echo "🔍 Step 2/3: 提取文本和图片..."
"$SCRIPT_DIR/extract.sh" "$ARXIV_ID" "$VAULT"

# Step 3: 生成笔记
echo ""
echo "🤖 Step 3/3: AI 生成论文笔记..."
"$SCRIPT_DIR/summarize.sh" "$ARXIV_ID" "$VAULT"

echo ""
echo "========================"
echo "🎉 完成！论文笔记: $VAULT/papers/$ARXIV_ID.md"
echo "📂 图片目录: $VAULT/figures/$ARXIV_ID/"
echo "📄 原始 PDF: $VAULT/pdfs/$ARXIV_ID.pdf"
