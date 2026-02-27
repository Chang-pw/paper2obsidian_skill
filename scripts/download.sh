#!/bin/bash
# 下载 arxiv 论文 PDF 和元数据
# 用法: ./download.sh <arxiv_id_or_url> [vault_path]

set -euo pipefail

INPUT="$1"
VAULT="${2:-$OBSIDIAN_VAULT}"

# 从 URL 或直接 ID 中提取 arxiv ID
if [[ "$INPUT" == *"arxiv.org"* ]]; then
    ARXIV_ID=$(echo "$INPUT" | grep -oE '[0-9]{4}\.[0-9]{4,5}(v[0-9]+)?')
else
    ARXIV_ID="$INPUT"
fi

if [[ -z "$ARXIV_ID" ]]; then
    echo "❌ 无法解析 arxiv ID: $INPUT"
    exit 1
fi

echo "📥 下载论文: $ARXIV_ID"

PDF_DIR="$VAULT/pdfs"
mkdir -p "$PDF_DIR"

PDF_PATH="$PDF_DIR/$ARXIV_ID.pdf"

if [[ -f "$PDF_PATH" ]]; then
    echo "✅ PDF 已存在: $PDF_PATH"
else
    curl -sL "https://arxiv.org/pdf/$ARXIV_ID.pdf" -o "$PDF_PATH"
    echo "✅ PDF 已下载: $PDF_PATH"
fi

# 下载元数据（用 arxiv API）
META_DIR="$VAULT/.paper-cache"
mkdir -p "$META_DIR"

curl -s "http://export.arxiv.org/api/query?id_list=$ARXIV_ID" -o "$META_DIR/$ARXIV_ID.xml"
echo "✅ 元数据已下载"

echo "$ARXIV_ID"
