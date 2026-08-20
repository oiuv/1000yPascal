# MineObjectAvail.sdb

采矿点可用配置数据文件，定义各地图中采矿点的分布、可用矿石类型及概率范围。

## 文件路径

```
.\Init\MineObjectAvail.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 记录编号 | 行索引 |
| GroupName | String | 采矿组名称 | `StrPCopy(@pad^.rGroupName, DB.GetFieldValueString(iName, 'GroupName'))` |
| MapID | Integer | 所在地图 ID | `pad^.rMapID := DB.GetFieldValueInteger(iName, 'MapID')` |
| PositionCount | Integer | 该区域的采矿位置总数 | `pad^.rPositionCount := DB.GetFieldValueInteger(iName, 'PositionCount')` |
| SettingCount | Integer | 已设置的采矿位置数量 | `pad^.rSettingCount := DB.GetFieldValueInteger(iName, 'SettingCount')` |
| Mine1-Mine5 | String | 可用矿石配置，格式为"矿石名:起始概率:结束概率" | `StrPCopy(@pad^.rAvailMines[j], rdStr); pad^.rMineSFreq[j]; pad^.rMineEFreq[j]` |
| Desc | String | 描述信息 | 未直接使用 |

### 概率机制

每个 Mine 字段包含矿石名称和概率范围（起始:结束），系统通过 `Random(100)` 生成随机数（范围 0-99），匹配落入的概率区间选择产出矿石类型。此过程不受采集经验影响。

## 数据示例

| 编号 | 区域 | 地图 | 矿石配置 |
|------|------|------|---------|
| 1 | 地下采石场1层 | 33 | 水石B(0-100%) |
| 3 | 铁矿1层 | 35 | 生铁B(0-100%) |
| 5 | 矿山1层 | 37 | 金属B(0-100%) |
| 11 | 长城以南1 | 1 | 草药A(0-35%), 草药B(35-100%) |

实际表头为 `Name,GroupName,MapID,PositionCount,SettingCount,Mine1,Mine2,Mine3,Mine4,Mine5,Desc`，不存在 `ViewName` 字段；上表示例中的“区域”对应 `GroupName`。

## 已知加载器缺陷

`TMineObjectClass.LoadFromFile` 为 `TMineObjectAvailData` 分配记录后，却调用 `FillChar(pad^, SizeOf(TMineObjectShapeData), 0)`。清零长度使用了另一种、更小的记录类型，可能使未被文件覆盖的字段保留未初始化值。这是 Pascal 源码缺陷，不应通过添加虚构字段规避；修改数据时应完整填写当前表头定义的矿石槽位。

## 相关源码

- `svClass.pas` — `TMineObjectClass.LoadFromFile`（第 6383 行）
- `svClass.pas` — `TMineObjectClass.GetBuildChance`（第 6520 行）
- `svClass.pas` — `TMineObjectClass.ChoiceMineObjectName`（第 6543 行）
- `1000ydef\deftype.pas` — `TMineObjectAvailData` 记录定义（第 1601 行）
