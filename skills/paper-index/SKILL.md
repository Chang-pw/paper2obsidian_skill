---
name: paper-index
description: 扫描 Obsidian vault 中的论文笔记，自动生成按主题、作者、阅读状态分类的索引，维护论文之间的双链关联
---

# Paper Index

扫描 `$OBSIDIAN_VAULT/papers/` 目录下的所有论文笔记，读取 frontmatter，生成和更新索引文件。

## 索引文件

生成以下索引到 `$OBSIDIAN_VAULT/indexes/` 目录：

### reading-list.md
按阅读状态分类（unread / reading / done），显示标题、作者、评分。

### by-topic.md
按 frontmatter 中的 tags 分类，同一个 tag 下的论文归为一组。

### by-author.md
按第一作者分类。

## 格式要求

- 使用 Obsidian 双链：`[[papers/arxiv_id|论文标题]]`
- 每篇论文显示：标题、年份、评分（如有）
- 索引文件顶部标注自动生成时间
- 如果 vault 中有 Dataview 插件，额外生成一个 `dataview-queries.md` 包含常用查询
