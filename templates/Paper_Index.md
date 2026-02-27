# 📚 论文管理中心

## 全部论文

```dataview
TABLE
  title as "标题",
  authors[0] as "一作",
  year as "年份",
  join(tags, ", ") as "标签",
  status as "状态",
  rating as "评分",
  date_added as "添加日期"
FROM "papers"
SORT date_added DESC
```

## 📖 按阅读状态

### 待读
```dataview
TABLE title as "标题", join(tags, ", ") as "标签", date_added as "添加日期"
FROM "papers"
WHERE status = "unread"
SORT date_added DESC
```

### 在读
```dataview
TABLE title as "标题", join(tags, ", ") as "标签", date_added as "添加日期"
FROM "papers"
WHERE status = "reading"
SORT date_added DESC
```

### 已读
```dataview
TABLE title as "标题", rating as "评分", join(tags, ", ") as "标签"
FROM "papers"
WHERE status = "done"
SORT rating DESC
```

## 🏷️ 按主题

### Reinforcement Learning
```dataview
TABLE title as "标题", year as "年份", status as "状态"
FROM "papers"
WHERE contains(tags, "reinforcement-learning")
SORT year DESC
```

### LLM Alignment
```dataview
TABLE title as "标题", year as "年份", status as "状态"
FROM "papers"
WHERE contains(tags, "LLM-alignment")
SORT year DESC
```

### Reasoning
```dataview
TABLE title as "标题", year as "年份", status as "状态"
FROM "papers"
WHERE contains(tags, "reasoning") OR contains(tags, "math-reasoning") OR contains(tags, "code-reasoning")
SORT year DESC
```

## 📊 统计

- 总论文数：`$= dv.pages('"papers"').length`
- 已读：`$= dv.pages('"papers"').where(p => p.status == "done").length`
- 在读：`$= dv.pages('"papers"').where(p => p.status == "reading").length`
- 待读：`$= dv.pages('"papers"').where(p => p.status == "unread").length`

## 🔍 按一作查找

```dataview
TABLE title as "标题", year as "年份", join(tags, ", ") as "标签"
FROM "papers"
SORT authors[0] ASC
```
