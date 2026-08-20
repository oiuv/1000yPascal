# MineObject.sdb

采矿对象基础数据配置文件，定义各种采矿点的基础属性，包括采集常量、产出物品、刷新间隔等。

## 文件路径

```
.\Init\MineObject.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | String | 采矿对象名称（如"金属B"、"岩石A"、"水石B"等） | `StrPCopy(@pmd^.rName, Db.GetFieldValueString(iName, 'Name'))` |
| ViewName | String | 显示名称（如"金属"、"岩石"、"宝石"、"水石"、"铁矿石"、"药草"） | `StrPCopy(@pmd^.rViewName, Db.GetFieldValueString(iName, 'ViewName'))` |
| PickConst | Integer | 采集速度常数。每次采矿命中时累加 `PickConst × FToolConst(=5)` 到采集量，超过 100 则产出一个矿石（埋藏量-1）。值越大采集越快。常见值：6（4次/个）、9（3次/个）、12（2次/个） | `pmd^.rPickConst := Db.GetFieldValueInteger(iName, 'PickConst')`；使用处：`uUserSub.pas` 第 12464 行 `FMinePickAmount := FMinePickAmount + (aSubData.HitData.PickConst * FToolConst)` |
| Deposits | String | 埋藏量列表，冒号分隔的5个数值 | `pmd^.rDeposits[j] := _StrToInt(rdStr)` |
| Item1-Item10 | String | 可产出的物品名称（最多10种），按品质从低到高排列（Item1 最常见，Item10 最稀有）。实际产出由 ToolRate 概率表 + `Random(10000)` 决定 | `ItemClass.GetItemData(Str, ItemData)` → `pmd^.rAvailItems[j]` |
| Sound | String | 采集音效数据 | `StrToEffectData(pmd^.rSoundData, Db.GetFieldValueString(iName, 'Sound'))` |
| RegenIntervals | String | 刷新间隔列表，冒号分隔的3个数值（毫秒） | `pmd^.rRegenIntervals[j] := _StrToInt(rdStr)` |
| DropMop | String | 采集时可能掉落的怪物，格式为"怪物名:数量" | `StrPCopy(@pmd^.rDropMop[j].rName, rdStr)` |

### 采矿对象分类

| 名称 | 类型 | PickConst（A/B） | 主要产出 |
|------|------|-----------------|---------|
| 金属A/B | 金属 | 9/12 | 白金/黄金/砂金/黄铜/青铜原石 |
| 岩石A/B | 岩石 | 9/12 | 耀阳/玄石/月石/黑石/硅石原石 |
| 宝石A/B | 宝石 | 9/12 | 黑珍珠/白玉/黄玉/绿玉/青玉原石 |
| 水石A/B/C/D | 水石 | 6/9/9/6 | 各类水石原石 |
| 生铁A/B | 铁矿石 | 9/12 | 千年衔铁/熔岩铁/玄铁/墨铁/钢铁/生铁 |
| 草药A/B/C | 药草 | 9/12/待确认 | 各类药材 |

A 类为高级矿点（PickConst=9，需 3 次命中产出一个矿石），B 类为普通矿点（PickConst=12，需 2 次命中产出一个矿石）。PickConst 值越小采集越慢。

## 相关源码

- `svClass.pas` — `TMineObjectClass.LoadFromFile`（第 6301 行）
- `svClass.pas` — `TMineObjectClass.GetMineObjectData`（第 6442 行）
- `svClass.pas` — `TMineObjectClass.ChoiceMineItemPos`（第 6572 行）— 产出物品概率选择
- `1000ydef\deftype.pas` — `TMineObjectData` 记录定义（第 1580 行）
- `BasicObj.pas` — `TMineObject` 类实现（第 7910 行）
- `uUserSub.pas` — 采集公式 `FMinePickAmount += PickConst * FToolConst`（第 12464 行）
