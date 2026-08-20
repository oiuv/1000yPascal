# MagicParam.sdb

武功参数配置文件，定义怪物/NPC 的武功使用参数，包括变身术、医病术、吸血术、召唤术、必杀技等特殊技能的行为参数。

## 文件路径

```
.\Init\MagicParam.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 记录编号 | 行索引 |
| ObjectName | String | 对象（怪物/NPC）名称 | `pd^.ObjectName := DB.GetFieldValueString(iName, 'ObjectName')` |
| MagicName | String | 武功名称（变身术/医病术/搜集术/吸血术/召唤术/必杀技/隐身术/分身术/再生术/透视等） | `pd^.MagicName := DB.GetFieldValueString(iName, 'MagicName')` |
| NameParam1-5 | String | 名称参数（最多5个），用途因武功类型而异。变身术：变身目标名；医病术：所需物品名；召唤术：召唤怪物名:数量；再生术：复活目标名列表 | `pd^.NameParam[j] := DB.GetFieldValueString(iName, 'NameParam'+IntToStr(j+1))` |
| NumberParam1-5 | Integer | 数值参数（最多5个），用途因武功类型而异（详见下方参数表）。吸血术：冷却/伤害/范围/特效；召唤术：触发范围/重复标志；必杀技：技能种类/修炼值 | `pd^.NumberParam[j] := DB.GetFieldValueInteger(iName, 'NumberParam'+IntToStr(j+1))` |

### 武功类型参数说明

> 以下参数含义均来自 `uMopSub.pas` 中各 `RunHave*Magic` 函数的实际调用。

| 武功类型 | NumberParam 用途 | NameParam 用途 |
|----------|-----------------|---------------|
| 同属性法术 (SAME) | 1:HP 百分比阈值（低于此值触发）, 2:伤害值 | 无 |
| 治疗术 (HEAL) | 1:HP 百分比阈值, 2:治疗量, 3:冷却间隔（tick） | 1-5:目标名称过滤（攻击者名称需匹配其中之一） |
| 交换术 (SWAP) | 1:HP 百分比阈值, 2:是否掉落物品（0/1） | 1:目标名称 |
| 食人术 (EAT) | 1:HP 百分比上限, 2:伤害值, 3:冷却间隔（tick） | 1:消耗物品名称 |
| 挑击术 (PICK) | 1:HP 百分比阈值 | 1-5:攻击者名称过滤 |
| 显形术 (SHOW) | 无 | 无 |
| 隐身术 (HIDE) | 1:HP 百分比下限, 2:HP 百分比上限（同时用作冷却间隔）, 3:冷却启用标志（>0 时启用冷却） | 无 |
| 吸血术 (BLOOD) | 1:冷却间隔（tick）, 2:法术伤害（SpellDamage）, 3:范围格数（半径）, 4:对方受到的特效编号, 5:自身释放特效编号 | 无 |
| 召唤术 (CALL) | 1:触发范围（格数）, 2:是否可重复召唤（0=仅一次，非 0=可重复） | 1-5:召唤怪物定义，格式"怪物名:数量" |
| 必杀技 (DEADBLOW) | 1:技能种类（2=八阵撃, 3=五线방）, 2:修炼值 | 无 |
| 变身术 | 待确认 | 1:变身目标名 |
| 医病术 | 待确认 | 1:所需物品名 |
| 搜集术 | 待确认 | 无 |
| 再生术 | 待确认 | 1-3:复活目标名 |
| 分身术 | 待确认 | 无 |
| 透视 | 待确认 | 无 |

## 数据示例

| ObjectName | MagicName | 说明 |
|------------|-----------|------|
| 白狐狸 | 变身术 | 可变身，NameParam1=白狐狸变身 |
| 白狐狸 | 医病术 | 使用生肉治疗，恢复60点 |
| 吸血木 | 吸血术 | 吸血攻击，NumberParam 定义冷却/伤害/范围/特效 |
| 青铜火炉 | 再生术 | 可复活九法僧1/2/3 |
| 四臂金刚 | 透视 | 具有透视能力 |

## 相关源码

- `svClass.pas` — `TMagicParamClass.LoadFromFile`（第 4382 行）
- `svClass.pas` — `TMagicParamClass.GetMagicParamData`（第 4421 行）
- `docs\help\deftype.pas` — `TMagicParamData` 记录定义（第 1805 行）
- `uMopSub.pas` — 怪物武功加载（第 732 行）
