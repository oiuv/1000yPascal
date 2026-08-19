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
| NumberParam1-5 | Integer | 数值参数（最多5个），用途因武功类型而异。医病术：恢复量/消耗/效果值；吸血术：吸取量/上限/倍数；召唤术：召唤数量/间隔；必杀技：伤害倍数/伤害值 | `pd^.NumberParam[j] := DB.GetFieldValueInteger(iName, 'NumberParam'+IntToStr(j+1))` |

### 武功类型参数说明

| 武功类型 | NameParam 用途 | NumberParam 用途 |
|----------|---------------|-----------------|
| 变身术 | 1:变身目标名 | 1-3:变身相关参数 |
| 医病术 | 1:所需物品名 | 1:恢复量, 2:消耗, 3:效果值 |
| 搜集术 | 无 | 1:搜集数量 |
| 吸血术 | 无 | 1:吸取量, 2:上限, 3:倍数 |
| 召唤术 | 1:召唤怪物名:数量 | 1:召唤数量, 2:间隔 |
| 必杀技 | 无 | 1:伤害倍数, 2:伤害值 |
| 再生术 | 1-3:复活目标名 | 1:恢复量, 2:消耗, 3:效果值 |
| 隐身术 | 无 | 无 |
| 分身术 | 无 | 1:分身数量, 2:分身参数 |
| 透视 | 无 | 无 |

## 数据示例

| ObjectName | MagicName | 说明 |
|------------|-----------|------|
| 白狐狸 | 变身术 | 可变身，NameParam1=白狐狸变身 |
| 白狐狸 | 医病术 | 使用生肉治疗，恢复60点 |
| 吸血木 | 吸血术 | 吸取500点，上限1000 |
| 青铜火炉 | 再生术 | 可复活九法僧1/2/3 |
| 四臂金刚 | 透视 | 具有透视能力 |

## 相关源码

- `svClass.pas` — `TMagicParamClass.LoadFromFile`（第 4382 行）
- `svClass.pas` — `TMagicParamClass.GetMagicParamData`（第 4421 行）
- `docs\help\deftype.pas` — `TMagicParamData` 记录定义（第 1805 行）
- `uMopSub.pas` — 怪物武功加载（第 732 行）
