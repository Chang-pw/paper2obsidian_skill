---
name: paper-index
description: 扫描 Obsidian vault 中的论文笔记，生成和更新论文数据库索引（按分类自动分表）
---

# Paper Index

维护论文库的索引数据库。

## 触发条件

当用户要求"更新索引"、"整理论文"、"生成论文列表"时加载此 skill。
也会在 read-arxiv-paper skill 完成后自动执行。

## 工作流程

1. 扫描 `$OBSIDIAN_VAULT/papers/` 目录下所有 `.md` 文件
2. 读取每篇笔记的 YAML frontmatter（title, authors, year, arxiv, tags）
3. 读取现有的 `$OBSIDIAN_VAULT/Paper_Index.md`（如果存在）
4. 将新论文追加到总表和对应分类子表中，不要覆盖已有条目
5. 如果论文的分类在现有索引中不存在，新建一个分类 section

## 分类规则

根据论文的 tags 判断分类。常见分类映射：

- `reinforcement-learning`, `GRPO`, `PPO`, `RLHF` → **LLM-RL**（大模型强化学习）
- `alignment`, `DPO`, `preference` → **LLM-Alignment**（大模型对齐）
- `attention`, `transformer`, `architecture` → **Architecture**（模型架构）
- `reasoning`, `chain-of-thought`, `math` → **Reasoning**（推理）
- `data`, `pretraining`, `scaling` → **Pretraining**（预训练）

如果一篇论文的 tags 跨多个分类，放入最相关的那个分类。分类名写在总表的"分类"列中。
遇到无法归类的新领域时，自行创建合理的分类名。

## 索引格式

```markdown
# 📚 论文数据库

> 最后更新：YYYY-MM-DD

---

## 全部论文

| arXiv | 标题 | 一作 | 年份 | 分类 | 标签 |
|-------|------|------|------|------|------|
| [[xxxx.xxxxx]] | 论文标题 | 一作 | 年份 | 分类名 | tag1, tag2 |

---

## 按分类

### 分类名（中文说明）

| arXiv | 简称 | 核心贡献 | 年份 |
|-------|------|----------|------|
| [[xxxx.xxxxx]] | 简称 | 一句话贡献 | 年份 |
```

## 更新规则

- 新论文追加到总表末尾，同时追加到对应分类子表
- 已存在的条目（按 arxiv ID 判断）不要重复添加
- 保留用户手动添加的备注和自定义 section
- 更新"最后更新"日期
