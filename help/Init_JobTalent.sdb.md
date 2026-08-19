# JobTalent.sdb

职业天赋数据配置文件，定义各物品品级对应的最大天赋值（技能经验上限）。

## 文件路径

```
.\Init\JobTalent.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 品级编号（1-10） | 行索引 |
| ViewName | String | 显示名称 | 未直接使用 |
| ItemGrade | Integer | 物品品级 | 用于索引 `JobTalentData[iNum-1]` |
| MaxTalent | Integer | 该品级对应的最大天赋值（制造时可获得的最大技能经验） | `JobTalentData[iNum-1] := Db.GetFieldValueInteger(iName, 'MaxTalent')` |

### 天赋值用途

天赋值决定制造物品时获得的技能经验上限。制造成功率越低（品级越高），获得的技能经验越多。计算公式：
```
TalentExp := (MaxTalent * (90 - 成功率) * 25) div 10
```

## 数据示例

| 品级 | 最大天赋值 |
|------|-----------|
| 1 | 0 |
| 2 | 650000 |
| 3 | 45550 |
| 4 | 28450 |
| 5 | 7230 |
| 6 | 4820 |
| 7 | 220 |
| 8 | 165 |
| 9 | 4 |
| 10 | 4 |

## 相关源码

- `svClass.pas` — 加载逻辑（第 7048 行）
- `svClass.pas` — `GetMaxTalent` 函数（第 7132 行）
- `uUserSub.pas` — `THaveJobClass.SetJobTalent`（第 11657 行）
- `uUserSub.pas` — 制造时天赋经验计算（第 11819 行）
