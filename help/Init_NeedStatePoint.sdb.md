# NeedStatePoint.sdb

绝世武功需要状态点配置文件，定义学习绝世武功（最高级武功）所需的境界状态点数。

## 文件路径

```
.\Init\NeedStatePoint.sdb
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 境界等级编号（对应武功品级） | 行索引，用于 `FNeedStatePoint[i]` |
| NeedPoint | Integer | 学习该等级绝世武功所需的状态点数 | `FNeedStatePoint[i] := NeedStateDB.GetFieldValueInteger(mname, 'NeedPoint')` |

### 使用场景

该配置被 `TMagicCycleClass` 加载，用于绝世武功（最高级武功）的学习条件判断。当玩家尝试学习绝世武功时，系统检查其状态点是否满足 `NeedStatePoint[MagicData.rGrade]` 的要求。

## 数据示例

| 等级 | 需要状态点 |
|------|-----------|
| 1 | 200 |
| 2 | 300 |

## 相关源码

- `svClass.pas` — `TMagicCycleClass` 加载逻辑（第 3288 行）
- `svClass.pas` — `GetNeedStatePoint` 属性（第 3146 行）
- `uUserSub.pas` — 绝世武功学习判断（第 8693 行）
- `uUserSub.pas` — 绝世武功窗口显示（第 9606 行）
- `uSendCls.pas` — `SendShowBestSpecialMagicWindow`（第 1705 行）
