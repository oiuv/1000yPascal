# ItemDrug.sdb

药品数据配置文件，定义游戏中各种药品的服用效果，包括恢复属性、加成效果及持续时间等。

## 文件路径

```
.\Init\ItemDrug.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | String | 药品名称（主键） | `StrPCopy (@pd^.rName, DB.GetFieldValueString (iName, 'Name'))` |
| Type | Integer | 药品类型。0=固定值恢复，1=按属性上限百分比恢复，2=有持续时间的临时属性加成 | `pd^.rType := DB.GetFieldValueInteger (iName, 'Type')` |
| UseInterval | Integer | 使用间隔（单位：10ms tick，即值 100 = 1 秒）。源码中已加载但服务端未实际使用此字段做时间判定 | `pd^.rUseInterval := DB.GetFieldValueInteger (iName, 'UseInterval')` |
| UseCount | Integer | 效果执行次数。服务端每秒执行一次 Type 0/1/2 分支并增加 `rUsedCount`，达到此值后清空药品效果槽 | `pd^.rUseCount := DB.GetFieldValueInteger (iName, 'UseCount')` |
| StillInterval | Integer | 药效持续时间（单位：10ms tick，即值 120000 = 20 分钟），仅 Type=2 的药品使用。药效到期判定：`CurTick >= DrugUseTick + DrugInterval` | `pd^.rStillInterval := DB.GetFieldValueInteger (iName, 'StillInterval')` |
| eEnergy | Integer | 元气效果值。Type 0 加载时应用下方倍率，Type 1/2 直接读取原值；具体用法还取决于类型分支 | `svClass.pas` 第 6686-6703 行 |
| eInPower | Integer | 内功增加量 | `pd^.rEventInPower := Db.GetFieldValueinteger (iName, 'eInPower') * ITEMDRUG_MUL_EVENTINPOWER div ITEMDRUG_DIV_VALUE` |
| eOutPower | Integer | 外力增加量 | `pd^.rEventOutPower := Db.GetFieldValueinteger (iName, 'eOutPower') * ITEMDRUG_MUL_EVENTOUTPOWER div ITEMDRUG_DIV_VALUE` |
| eMagic | Integer | 法力增加量 | `pd^.rEventMagic := Db.GetFieldValueinteger (iName, 'eMagic') * ITEMDRUG_MUL_EVENTMAGIC div ITEMDRUG_DIV_VALUE` |
| eLife | Integer | 活力增加量 | `pd^.rEventLife := Db.GetFieldValueinteger (iName, 'eLife') * ITEMDRUG_MUL_EVENTLIFE div ITEMDRUG_DIV_VALUE` |
| eHeadLife | Integer | 头部活力增加量 | `pd^.rEventHeadLife := Db.GetFieldValueinteger (iName, 'eHeadLife') * ITEMDRUG_MUL_EVENTHEADLIFE div ITEMDRUG_DIV_VALUE` |
| eArmLife | Integer | 手臂活力增加量 | `pd^.rEventArmLife := Db.GetFieldValueinteger (iName, 'eArmLife') * ITEMDRUG_MUL_EVENTARMLIFE div ITEMDRUG_DIV_VALUE` |
| eLegLife | Integer | 腿部活力增加量 | `pd^.rEventLegLife := Db.GetFieldValueinteger (iName, 'eLegLife') * ITEMDRUG_MUL_EVENTLEGLIFE div ITEMDRUG_DIV_VALUE` |
| DamageBody | Integer | 身体攻击力加成 | `pd^.rDamageBody := Db.GetFieldValueinteger (iName, 'DamageBody')` |
| DamageHead | Integer | 头部攻击力加成 | `pd^.rDamageHead := Db.GetFieldValueinteger (iName, 'DamageHead')` |
| DamageArm | Integer | 手臂攻击力加成 | `pd^.rDamageArm := Db.GetFieldValueinteger (iName, 'DamageArm')` |
| DamageLeg | Integer | 腿部攻击力加成 | `pd^.rDamageLeg := Db.GetFieldValueinteger (iName, 'DamageLeg')` |
| ArmorBody | Integer | 身体防御力加成 | `pd^.rArmorBody := Db.GetFieldValueinteger (iName, 'ArmorBody')` |
| ArmorHead | Integer | 头部防御力加成 | `pd^.rArmorHead := Db.GetFieldValueinteger (iName, 'ArmorHead')` |
| ArmorArm | Integer | 手臂防御力加成 | `pd^.rArmorArm := Db.GetFieldValueinteger (iName, 'ArmorArm')` |
| ArmorLeg | Integer | 腿部防御力加成 | `pd^.rArmorLeg := Db.GetFieldValueinteger (iName, 'ArmorLeg')` |
| AttackSpeed | Integer | 攻击速度加成 | `pd^.rAttackSpeed := Db.GetFieldValueinteger (iName, 'AttackSpeed')` |
| Avoid | Integer | 闪避加成 | `pd^.rAvoid := Db.GetFieldValueinteger (iName, 'Avoid')` |
| Recovery | Integer | 恢复力加成 | `pd^.rRecovery := Db.GetFieldValueinteger (iName, 'Recovery')` |
| Accuracy | Integer | 命中加成 | `pd^.rAccuracy := Db.GetFieldValueinteger (iName, 'Accuracy')` |
| KeepRecovery | Integer | 维持恢复加成 | `pd^.rKeepRecovery := Db.GetFieldValueinteger (iName, 'KeepRecovery')` |
| LightDark | Integer | 明暗效果（待确认具体用途） | `pd^.rLightDark := Db.GetFieldValueinteger (iName, 'LightDark')` |

### 药品类型说明

- **Type 0**（固定值恢复）：每秒把加载后的效果值加到当前属性，最多不超过属性上限。Type 0 加载时会应用下方倍率，其中活力及部位活力倍率为 `15/10`。
- **Type 1**（百分比恢复）：每秒按属性**上限**计算恢复量，公式为 `属性上限 × 效果值 / 100 / UseCount`。源码的外功计算实际沿用了 `InPower` 和 `eInPower`，文档按当前代码记录此行为，不推断其设计意图。
- **Type 2**（临时属性加成）：把内功、外功、武功、活力及攻防等字段写入临时加成结构，并在 `StillInterval` 到期后统一清除。时间单位为 10ms tick，例如 120000 为 20 分钟。

所有类型的效果槽每 100 tick（约 1 秒）处理一次；`UseCount` 控制处理次数，不表示物品可被玩家重复服用的次数。

### 常量定义

```pascal
ITEMDRUG_DIV_VALUE         = 10;
ITEMDRUG_MUL_EVENTENERGY   = 10;
ITEMDRUG_MUL_EVENTINPOWER  = 10;
ITEMDRUG_MUL_EVENTOUTPOWER = 10;
ITEMDRUG_MUL_EVENTMAGIC    = 10;
ITEMDRUG_MUL_EVENTLIFE     = 15;
ITEMDRUG_MUL_EVENTHEADLIFE = 15;
ITEMDRUG_MUL_EVENTARMLIFE  = 15;
ITEMDRUG_MUL_EVENTLEGLIFE  = 15;
```

## 数据示例

| Name | Type | 说明 |
|------|------|------|
| 汤药 | 0 | 基础药品，主恢复元气 |
| 仙豆一 | 0 | 高级恢复药品 |
| 承气汤 | 0 | 大量恢复元气（eEnergy=700） |
| 青盐精 | 1 | 百分比药品，恢复各属性50% |
| 阴阳丹 | 2 | 持续型药品，StillInterval=120000（20 分钟） |
| 千年山参 | 2 | 最高级药品，StillInterval=180000（30 分钟），全属性大幅提升 |

## 相关源码

- `svClass.pas` — `TItemDrugClass.ReLoadFromFile`（第 6661 行）
- `svClass.pas` — `TItemDrugClass.GetItemDrugData`（第 6731 行）
- `uUserSub.pas` — `TAttribClass.AddItemDrug`（第 1925 行）
- `uUserSub.pas` — 药品效果应用逻辑（第 2005-2104 行）
- `docs\help\deftype.pas` — `TItemDrugData` 记录定义（第 1694 行）
