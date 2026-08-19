# ToolRate.sdb

工具成功率配置文件，定义不同采矿工具在各种矿点上的采集成功率分布。

## 文件路径

```
.\Init\ToolRate.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 记录编号 | 行索引 |
| Mine | String | 采矿对象名称（与 MineObject.sdb 中的 Name 对应） | `Str := DB.GetFieldValueString(iName, 'Mine')` |
| Tool | String | 工具名称（青铜十字镐/钢铁十字镐/象牙十字镐/高级象牙十字镐） | `rdStr := DB.GetFieldValueString(iName, 'Tool')` |
| SFreq1-SFreq10 | Integer | 第1-10档起始频率（概率阈值下限） | `ptd^.rSFreq[j] := DB.GetFieldValueInteger(iName, 'SFreq'+IntToStr(j+1))` |
| EFreq1-EFreq10 | Integer | 第1-10档结束频率（概率阈值上限） | `ptd^.rEFreq[j] := DB.GetFieldValueInteger(iName, 'EFreq'+IntToStr(j+1))` |

### 工具查找键

系统将 Mine + Tool 拼接作为查找键：`ptd^.Name := Str + rdStr`

### 概率机制

SFreq/EFreq 定义了10个概率区间，每个区间对应 MineObject.sdb 中的一个产出物品。系统根据玩家的采集经验值在概率区间中随机选择，决定产出哪种物品。

### 工具等级

| 工具 | 说明 |
|------|------|
| 青铜十字镐 | 最低级工具 |
| 钢铁十字镐 | 初级工具 |
| 象牙十字镐 | 中级工具 |
| 高级象牙十字镐 | 最高级工具 |

高级工具在稀有物品档位有更高的概率。

## 数据示例

金属B + 青铜十字镐：
- 档位1: 0-1, 档位2: 1-6, 档位3: 6-50, 档位4: 50-500, 档位5: 500-10000

金属A + 高级象牙十字镐：
- 档位1: 0-1, 档位2: 1-11, 档位3: 11-60, 档位4: 60-302, 档位5: 302-2720, 档位6: 2720-10000

## 相关源码

- `svClass.pas` — `TMineObjectClass.LoadFromFile`（第 6417 行）
- `svClass.pas` — `TMineObjectClass.ChoiceMineItemPos`（第 6572 行）
- `docs\help\deftype.pas` — `TToolRateData` 记录定义（第 2781 行）
- `BasicObj.pas` — `TMineObject.FieldProc` 采集处理（第 7925 行）
