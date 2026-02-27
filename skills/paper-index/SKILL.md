---
name: paper-index
description: 扫描 Obsidian vault 中的论文笔记，生成和更新论文管理索引表格（支持 Dataview 动态表格和静态 Markdown 表格两种模式）
---

# Paper Index

维护论文库的索引和管理表格。

## 触发条件

当用户要求"更新索引"、"整理论文"、"生成论文列表"时加载此 skill。

## 工作流程

1. 扫描 `$OBSIDIAN_VAULT/papers/` 目录下所有 `.md` 文件
2. 读取每篇笔记的 YAML frontmatter（title, authors, year, arxiv, tags, status, rating, date_added）
3. 生成/更新 `$OBSIDIAN_VAULT/Paper_Index.md`

## 静态索引格式

如果用户没有安装 Dataview 插件，生成静态 Markdown 表格：

```markdown
# 📚 论文管理中心

> 最后更新：YYYY-MM-DD

## 全部论文

| 标题 | 一作 | 年份 | 标签 | 状态 | 评分 | arXiv |
|------|------|------|------|------|------|-------|
| [论文标题](papers/文件名.md) | 作者 | 2026 | tag1, tag2 | unread | ⭐⭐⭐ | [2601.05242](https://arxiv.org/abs/2601.05242) |

## 按主题分类

### Reinforcement Learning
| 标题 | 年份 | 状态 | 核心贡献 |
|------|------|------|----------|
| [GDPO](papers/GDPO_xxx.md) | 2026 | unread | 解耦多奖励归一化 |

### （其他主题按 tags 自动分组）

## 按时间线

### 2026
- [论文标题](papers/文件名.md) — 一句话总结

### 2025
- ...
```

## 更新规则

- 每次添加新论文后自动提示更新索引
- 保留用户手动添加的备注和分组
- 按 tags 自动分组，同一篇论文可以出现在多个主题下
- 表格按 date_added 倒序排列（最新的在最上面）
