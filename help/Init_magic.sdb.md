# Magic.SDB

`Init/Magic.SDB` 定义服务端武功模板。服务启动时由 `TMagicClass.LoadMagicData` 读取；本页字段以实际表头和加载器为准。

## 标识与分类

| 字段 | 加载结果 |
| --- | --- |
| `Name` | 行主键，写入 `rName` |
| `ViewName` | 显示名称 `rViewName` |
| `Kind` | `rKind` |
| `MagicType` | `值 div 100` 写入 `rMagicClass`，`值 mod 100` 写入 `rMagicType`。武功类别常量为 0 基础、1 上乘、2 术掌法、3 绝世 |
| `patternType`、`RelationMagic`、`RangeType`、`AttackCount` | 分别写入 `rPatternType`、`rRelationMagic`、`rRangeType`、`rAttackCount` |
| `NeedMagic`、`MagicRelation`、`Function`、`EnergyPoint` | 分别写入同名运行时成员（带 `r` 前缀） |
| `RelationProtect`、`SameSection` | 写入名称字符串成员 |

## 战斗数值

以下字段由加载器按 `rMagicClass` 转换后写入运行时数据，不能把 SDB 数字一律当作最终战斗值：

- 动作属性：`AttackSpeed`、`Recovery`、`KeepRecovery`、`Avoid`、`accuracy`。
- 伤害：`DamageBody`、`DamageHead`、`DamageArm`、`DamageLeg`、`DamageEnergy`。
- 防御：`ArmorBody`、`ArmorHead`、`ArmorArm`、`ArmorLeg`、`ArmorEnergy`。
- 单次事件消耗：`eEnergy`、`eInPower`、`eOutPower`、`eMagic`、`eLife`、`eDamageHead`、`eDamageArm`、`eDamageLeg`。
- 每 5 秒消耗：`5Energy`、`5InPower`、`5OutPower`、`5Magic`、`5Life`、`5DamageHead`、`5DamageArm`、`5DamageLeg`。
- 保持下限：`kEnergy`、`kInPower`、`kOutPower`、`kMagic`、`kLife`、`kDamageHead`、`kDamageArm`、`kDamageLeg`；加载时乘以 10。

基础、上乘、术掌法和绝世分支采用不同公式；其中部分字段在特定类别不赋值。调整数值时必须对照 `svClass.pas` 中四个 `MAGICCLASS_*` 分支，不能跨类别照搬。

## 表现与施放

| 字段组 | 加载结果 |
| --- | --- |
| `Shape`、`BowSpeed`、`BowImage`、`BowType`、`MotionType` | 形状、飞行表现和动作类型 |
| `SEffectNumber`、`SEffectNumber2`、`CEffectNumber`、`EEffectNumber` | 服务端/客户端/结束效果编号 |
| `SoundStart`、`SoundEnd`、`SoundStrike`、`SoundSwing`、`SoundEvent` | 经 `StrToEffectData` 转为音效数据 |
| `EffectColor` | 写入 `rEffectColor`；配置为 0 时强制改为 1 |
| `MinRange`、`MaxRange`、`EffectDelay` | 有效距离和效果延迟 |
| `PushLength`、`boNotRecovery`、`Stun` | 推动距离、禁止恢复标志和眩晕值 |
| `ScreenEffectNum`、`ScreenEffectDelay` | 屏幕效果编号及延迟 |

## 当前未加载字段

表头中的 `GoodChar`、`BadChar`、`Notice` 没有被当前 `LoadMagicData` 读取。仅修改这三列不能据此认定会产生运行时效果。

## 校验依据

- 配置表头：`gameserver-tgs1000/bin/Init/Magic.SDB`
- 加载器：`gameserver-tgs1000/svClass.pas` 的 `TMagicClass.LoadMagicData`
- 数据结构与类别常量：`1000ydef/deftype.pas` 的 `TMagicData`、`MAGICCLASS_*`
