#!/bin/bash
# 从 PDF 中提取文本和图片
# 用法: ./extract.sh <arxiv_id> [vault_path]

set -euo pipefail

ARXIV_ID="$1"
VAULT="${2:-$OBSIDIAN_VAULT}"

PDF_PATH="$VAULT/pdfs/$ARXIV_ID.pdf"
FIG_DIR="$VAULT/figures/$ARXIV_ID"
CACHE_DIR="$VAULT/.paper-cache"

if [[ ! -f "$PDF_PATH" ]]; then
    echo "❌ PDF 不存在: $PDF_PATH"
    exit 1
fi

mkdir -p "$FIG_DIR"
mkdir -p "$CACHE_DIR"

echo "🔍 提取图片和文本..."

# 使用 Python 提取图片和文本
python3 << 'PYEOF'
import fitz  # pymupdf
import sys
import os
import json

arxiv_id = sys.argv[1] if len(sys.argv) > 1 else os.environ.get("ARXIV_ID")
vault = sys.argv[2] if len(sys.argv) > 2 else os.environ.get("OBSIDIAN_VAULT")

pdf_path = f"{vault}/pdfs/{arxiv_id}.pdf"
fig_dir = f"{vault}/figures/{arxiv_id}"
cache_dir = f"{vault}/.paper-cache"

doc = fitz.open(pdf_path)

# 提取全文
full_text = ""
for page in doc:
    full_text += page.get_text() + "\n\n"

# 保存全文
with open(f"{cache_dir}/{arxiv_id}_text.md", "w") as f:
    f.write(full_text)

# 提取图片
img_count = 0
for page_num in range(len(doc)):
    page = doc[page_num]
    images = page.get_images(full=True)
    for img_idx, img in enumerate(images):
        xref = img[0]
        pix = fitz.Pixmap(doc, xref)
        if pix.n < 5:  # GRAY or RGB
            img_path = f"{fig_dir}/page{page_num+1}_img{img_idx+1}.png"
            pix.save(img_path)
        else:  # CMYK: convert to RGB
            pix2 = fitz.Pixmap(fitz.csRGB, pix)
            img_path = f"{fig_dir}/page{page_num+1}_img{img_idx+1}.png"
            pix2.save(img_path)
        img_count += 1

# 也把每页渲染成图片（用于捕获 figure/table 的完整渲染）
for page_num in range(len(doc)):
    page = doc[page_num]
    # 2x 分辨率渲染
    mat = fitz.Matrix(2, 2)
    pix = page.get_pixmap(matrix=mat)
    pix.save(f"{fig_dir}/page_{page_num+1}.png")

print(f"✅ 提取完成: {img_count} 张嵌入图片, {len(doc)} 页渲染图")

doc.close()
PYEOF

echo "✅ 图片保存至: $FIG_DIR"
echo "✅ 文本保存至: $CACHE_DIR/${ARXIV_ID}_text.md"
