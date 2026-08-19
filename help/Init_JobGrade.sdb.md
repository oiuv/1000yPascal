# JobGrade.sdb

职业等级数据配置文件，定义制造系职业的等级划分、对应等级范围、可制造物品等级上限及各品级制造成功率。

## 文件路径

```
.\Init\JobGrade.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 等级编号（1-6） | 行索引 |
| ViewName | String | 等级显示名称（初级工/技能工/熟练工/达人/名人/神工） | `JobGradeData[iNum-1].Name` |
| Grade | Integer | 等级序号 | 用于映射常量 JOB_GRADE_NAMELESSWORKER 到 JOB_GRADE_VIRTUEMAN |
| StartLevel | Integer | 该等级所需的最低技能值 | `JobGradeData[iNum-1].StartLevel := Db.GetFieldValueInteger(iName, 'Startlevel')` |
| EndLevel | Integer | 该等级所需的最高技能值 | `JobGradeData[iNum-1].EndLevel := Db.GetFieldValueInteger(iName, 'EndLevel')` |
| MaxItemGrade | Integer | 该等级可制造的最高物品品级 | `JobGradeData[iNum-1].MaxItemGrade := Db.GetFieldValueInteger(iName, 'MaxItemGrade')` |
| 1Grade-10Grade | Integer | 制造对应品级物品的成功率（百分比） | `JobGradeData[iNum-1].Grade[j] := Db.GetFieldValueInteger(iName, IntToStr(j+1)+'Grade')` |
| Alchemist | String | 炼丹师工具名称 | `AlchemistTool[aJobGrade-1]` |
| Chemist | String | 药剂师工具名称 | `ChemistTool[aJobGrade-1]` |
| Designer | String | 设计师工具名称 | `DesignerTool[aJobGrade-1]` |
| Craftsman | String | 工匠工具名称 | `CraftsmanTool[aJobGrade-1]` |
| MinerExp | String | 采矿经验范围，格式为"起始经验:结束经验:起始等级:结束等级" | `Miner_SExp`, `Miner_EExp`, `Miner_SLevel`, `Miner_ELevel` |

### 等级对应关系

| 编号 | 名称 | 技能值范围 | 可制造最高品级 |
|------|------|-----------|--------------|
| 1 | 初级工 | 0 - 1999 | 9品 |
| 2 | 技能工 | 2000 - 3999 | 7品 |
| 3 | 熟练工 | 4000 - 5999 | 5品 |
| 4 | 达人 | 6000 - 7999 | 3品 |
| 5 | 名人 | 8000 - 9998 | 2品 |
| 6 | 神工 | 9999 - 9999 | 1品 |

## 数据示例

等级 1（初级工）制造成功率：9品=70%, 8品=80%，其余品级=0
等级 6（神工）制造成功率：1品=40%, 2品=50%, ..., 10品=89%

## 相关源码

- `svClass.pas` — `TJobClass` 加载逻辑（第 6996 行）
- `svClass.pas` — `TJobClass.GetJobGrade`（第 7099 行）
- `svClass.pas` — `TJobClass.GetJobGradeData`（第 7113 行）
- `svClass.pas` — `TJobClass.GetJobTool`（第 7195 行）
- `uUserSub.pas` — `THaveJobClass` 制造成功率计算（第 11779 行）
