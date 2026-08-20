# PowerLevel.sdb

元气等级数据配置文件，定义玩家的元气境界等级及各等级对应的属性加成。

## 文件路径

```
.\Init\PowerLevel.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 等级编号（1-13） | 行索引，`PowerLevelArr[sn-1]` |
| ViewName | String | 境界名称 | `PowerLevelArr[sn-1].Name := TempDB.GetFieldValueString(iName, 'ViewName')` |
| PowerValue | Integer | 该境界所需的元气值 | `PowerLevelArr[sn-1].PowerValue := TempDB.GetFieldValueInteger(iName, 'PowerValue')` |
| LimitEnergy | Integer | 该境界的元气上限 | `PowerLevelArr[sn-1].LimitEnergy := TempDB.GetFieldValueInteger(iName, 'LimitEnergy')` |
| Damage | Integer | 攻击力加成值 | `PowerLevelArr[sn-1].Damage := TempDB.GetFieldValueInteger(iName, 'Damage')` |
| Armor | Integer | 防御力加成值 | `PowerLevelArr[sn-1].Armor := TempDB.GetFieldValueInteger(iName, 'Armor')` |
| AttackSpeed | Integer | 攻击速度加成；当前表内为空，加载为 0 | `GetPowerLevelAttackSpeed` 返回该值 |
| Avoid | Integer | 闪避加成；当前表内为空，加载为 0 | `GetPowerLevelAvoid` 返回该值 |
| Recovery | Integer | 恢复加成；当前表内为空，加载为 0 | `GetPowerLevelRecovery` 返回该值 |
| Accuracy | Integer | 命中加成；当前表内为空，加载为 0 | `GetPowerLevelAccuracy` 返回该值 |
| KeepRecovery | Integer | 维持恢复加成；当前表内为空，加载为 0 | `GetPowerLevelKeepRecovery` 返回该值 |

### 境界等级列表

| 等级 | 名称 | 元气值 | 元气上限 | 攻击加成 |
|------|------|--------|---------|---------|
| 1 | 出入境 | 4000 | 7999 | 75 |
| 2 | 造化境 | 8000 | 11999 | 150 |
| 3 | 玄妙境 | 12000 | 17999 | 300 |
| 4 | 生死境 | 18000 | 25999 | 450 |
| 5 | 解脱境 | 26000 | 35999 | 600 |
| 6 | 无为境 | 36000 | 47999 | 750 |
| 7 | 神话境 | 48000 | 61999 | 900 |
| 8 | 无上武念 | 62000 | 77999 | 1050 |
| 9 | 天人合一 | 78000 | 95999 | 1200 |
| 10 | 至尊无上 | 96000 | 115999 | 1350 |
| 11 | 一念通天 | 116000 | 137999 | 1500 |
| 12 | 空前绝后 | 138000 | 161999 | 1650 |
| 13 | 泰山北斗 | 162000 | 200000 | 1800 |

### 属性应用

元气等级影响武功的实际伤害和防御计算：
- 攻击力：`DamageBody += MagicClass.GetPowerLevelDamage(FCurPowerLevel)`
- 防御力：`ArmorBody += MagicClass.GetPowerLevelArmor(FCurPowerLevel)`
- 攻速、闪避、恢复、命中和维持恢复也分别通过 `GetPowerLevel*` 加入 `THaveMagicClass.AddPowerLevelLifeData`。当前配置列为空，所以本仓库数据下实际增量为 0。

## 相关源码

- `svClass.pas` — 加载逻辑（第 3806 行）
- `svClass.pas` — `TPowerLevelData` 记录定义（第 73 行）
- `svClass.pas` — `GetPowerLevelDamage/Armor/AttackSpeed` 等函数（第 197-207 行）
- `uUserSub.pas` — `THaveMagicClass.AddPowerLevelLifeData`（第 5895 行）
- `uUserSub.pas` — `PowerLevelUP/PowerLevelDOWN`（第 413-414 行）
