# QuestSummary.sdb

任务概要配置文件，定义游戏中主线任务的概要信息，包括任务标题、子标题和任务要求。

## 文件路径

```
.\Init\QuestSummary.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| QuestNum | Integer | 任务编号 | `pq^.rQuestNumber := DB.GetFieldValueInteger(iname, 'QuestNum')` |
| QuestMainTitle | String | 任务主标题 | `pq^.rQuestMainTitle := DB.GetFieldValueString(iname, 'QuestMainTitle')` |
| QuestSubTitle | String | 任务子标题（章节名） | `pq^.rQuestSubTitle := DB.GetFieldValueString(iname, 'QuestSubTitle')` |
| Request | String | 任务要求描述 | `pq^.rRequest := DB.GetFieldValueString(iname, 'Request')` |

### 使用场景

任务概要数据用于任务日志窗口显示。通过 `QuestSummaryClass` 的 `GetMainQuestTitle`、`GetSubQuestTitle`、`GetRequest`、`GetDesc` 方法获取各任务的显示信息。

## 数据示例

| QuestNum | QuestMainTitle | QuestSubTitle | Request |
|----------|---------------|---------------|---------|
| 1100 | I. 西域魔人的阴谋 | 第1章：万年雪参 | 寻求万年雪参 |
| 1150 | I. 西域魔人的阴谋 | 第2章：东天北霸 | 把灵魂囚禁在葫芦瓶中 |
| 1200 | I. 西域魔人的阴谋 | 第3章：侠客戒指 | 寻找侠客戒指 |
| 1300 | II. 南帝王任务 | 第4章：南帝王 | 杀死南帝王 |
| 1500 | II. 南帝王任务 | 第6章：邪恶降临 | 2. 决战西域魔人 |
| 1550 | 任务结束 | | 所有任务的完成 |
| 9998 | I. 神功 2 级 任务 | 第1章：查寻神功秘密 | |
| 9999 | II. 神功 3 级 任务 | 第2章：查寻神功秘密 | |

## 相关源码

- `svClass.pas` — `TQuestSummaryClass.LoadFromFile`（第 7914 行）
- `svClass.pas` — `GetMainQuestTitle/GetSubQuestTitle/GetRequest/GetDesc`（第 7944-7993 行）
- `1000ydef\deftype.pas` — `TQuestSummaryData` 记录定义（第 2427 行）
- `uUserSub.pas` — 任务日志显示（第 4599 行）
