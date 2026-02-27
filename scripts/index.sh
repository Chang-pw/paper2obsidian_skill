#!/bin/bash
# 生成论文索引（按主题、作者、时间线）
# 用法: ./index.sh [vault_path]

set -euo pipefail

VAULT="${1:-$OBSIDIAN_VAULT}"
PAPERS_DIR="$VAULT/papers"
INDEX_DIR="$VAULT/indexes"

mkdir -p "$INDEX_DIR"

echo "📚 生成论文索引..."

# 使用 opencode 分析所有论文笔记并生成索引
PAPER_LIST=""
for f in "$PAPERS_DIR"/*.md; do
    if [[ -f "$f" ]]; then
        # 提取 frontmatter
        TITLE=$(grep '^title:' "$f" | head -1 | sed 's/title: *"*//;s/"*$//')
        TAGS=$(grep '^tags:' "$f" | head -1)
        AUTHORS=$(grep '^authors:' "$f" | head -1)
        YEAR=$(grep '^year:' "$f" | head -1)
        FNAME=$(basename "$f" .md)
        PAPER_LIST+="- [[$FNAME|$TITLE]] $TAGS $YEAR\n"
    fi
done

# 生成阅读列表
cat > "$INDEX_DIR/reading-list.md" << EOF
# 📚 论文阅读列表

> 自动生成于 $(date +%Y-%m-%d)

## 全部论文
$(echo -e "$PAPER_LIST")

## 按状态

### 📖 待读
$(grep -rl 'status: unread' "$PAPERS_DIR" 2>/dev/null \
    | while read f; do echo "- [[$(basename "$f" .md)]]"; done)

### 📝 在读
$(grep -rl 'status: reading' "$PAPERS_DIR" 2>/dev/null \
    | while read f; do echo "- [[$(basename "$f" .md)]]"; done)

### ✅ 已读
$(grep -rl 'status: done' "$PAPERS_DIR" 2>/dev/null \
    | while read f; do echo "- [[$(basename "$f" .md)]]"; done)
EOF

echo "✅ 索引已更新: $INDEX_DIR/"
