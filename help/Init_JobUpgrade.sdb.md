# JobUpgrade.sdb

职业升段数据配置文件，定义物品升段（强化）的成功率、失败惩罚及各属性的提升百分比。

## 文件路径

```
.\Init\JobUpgrade.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | String | 升段等级名称（1段-4段） | 行索引 |
| Upgrade | Integer | 升段步骤编号 | `JobUpgradeData[iNum-1].UpgradeStep := iNum` |
| SuccessRate | Integer | 升段成功率（百分比） | `JobUpgradeData[iNum-1].SuccessRate := Db.GetFieldValueInteger(iName, 'SuccessRate')` |
| DungeonRate | Integer | 失败时物品损坏率（百分比） | `JobUpgradeData[iNum-1].DungeonRate := Db.GetFieldValueInteger(iName, 'DungeonRate')` |
| DamageBody | Integer | 身体攻击力提升百分比 | `JobUpgradeData[iNum-1].DamageBody := Db.GetFieldValueInteger(iName, 'DamageBody')` |
| DamageHead | Integer | 头部攻击力提升百分比 | `JobUpgradeData[iNum-1].DamageHead := Db.GetFieldValueInteger(iName, 'DamageHead')` |
| DamageArm | Integer | 手臂攻击力提升百分比 | `JobUpgradeData[iNum-1].DamageArm := Db.GetFieldValueInteger(iName, 'DamageArm')` |
| DamageLeg | Integer | 腿部攻击力提升百分比 | `JobUpgradeData[iNum-1].DamageLeg := Db.GetFieldValueInteger(iName, 'DamageLeg')` |
| ArmorBody | Integer | 身体防御力提升百分比 | `JobUpgradeData[iNum-1].ArmorBody := Db.GetFieldValueInteger(iName, 'ArmorBody')` |
| ArmorHead | Integer | 头部防御力提升百分比 | `JobUpgradeData[iNum-1].ArmorHead := Db.GetFieldValueInteger(iName, 'ArmorHead')` |
| ArmorArm | Integer | 手臂防御力提升百分比 | `JobUpgradeData[iNum-1].ArmorArm := Db.GetFieldValueInteger(iName, 'ArmorArm')` |
| ArmorLeg | Integer | 腿部防御力提升百分比 | `JobUpgradeData[iNum-1].ArmorLeg := Db.GetFieldValueInteger(iName, 'ArmorLeg')` |
| AttackSpeed | Integer | 攻击速度提升百分比（源码中已注释，未生效） | `// aItemData.rLifeData.AttackSpeed` |
| Avoid | Integer | 闪避提升百分比 | `aItemData.rLifeData.Avoid + (Avoid * JobUpgradeData[].Avoid) div 100` |
| Recovery | Integer | 恢复力提升百分比（源码中已注释，未生效） | `// aItemData.rLifeData.Recovery` |
| Accuracy | Integer | 命中提升百分比 | `aItemData.rLifeData.Accuracy + (Accuracy * JobUpgradeData[].Accuracy) div 100` |
| KeepRecovery | Integer | 维持恢复提升百分比 | `aItemData.rLifeData.KeepRecovery + (KeepRecovery * JobUpgradeData[].KeepRecovery) div 100` |

### 升段计算公式

升段后的属性值 = 原始属性值 + (原始属性值 × 提升百分比) div 100

### 数据示例

| 段数 | 成功率 | 损坏率 | 攻击/防御提升 |
|------|--------|--------|-------------|
| 1段 | 70% | 80% | 20% |
| 2段 | 40% | 50% | 50% |
| 3段 | 25% | 30% | 100% |
| 4段 | 20% | 20% | 150% |

## 相关源码

- `svClass.pas` — 加载逻辑（第 7064 行）
- `svClass.pas` — `GetUpgradeData`（第 7153 行）
- `svClass.pas` — 属性计算（第 7177-7190 行）
- `svClass.pas` — `TJobUpgradeData` 记录定义（第 102 行）
