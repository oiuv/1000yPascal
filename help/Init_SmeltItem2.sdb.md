# SmeltItem2.sdb

冶炼物品数据配置文件2（材料精炼），定义从低级材料精炼为高级材料的配方。

## 文件路径

```
.\Init\SmeltItem2.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | String | 冶炼产物名称（主键） | `StrPCopy(@psd^.rName, iName)` |
| NeedItem | String | 所需原料，格式为"原料名:数量" | `Str := GetValidStr3(Str, ItemName, ':')` → `psd^.rNeedItem`; `psd^.rNeedCount` |
| Price | Integer | 冶炼费用 | `psd^.rPrice := DB.GetFieldValueInteger(iName, 'Price')` |

### 与 SmeltItem.sdb 的区别

- **SmeltItem.sdb**：矿石原石 → 成品材料（初级冶炼）
- **SmeltItem2.sdb**：低级材料 → 高级材料（精炼/提纯）

SmeltItem2 使用 `FSmeltList2` 存储，通过 `GetSmeltItemData2` 查询，对应 `DRAGACTION_SMELTITEM2` 操作。

### 精炼配方列表

| 产物 | 所需原料 | 费用 |
|------|---------|------|
| 黄铜 | 青铜×10 | 100 |
| 砂金 | 黄铜×10 | 1,000 |
| 黄金 | 砂金×10 | 10,000 |
| 白金 | 黄金×10 | 100,000 |
| 黑石 | 硅石×10 | 100 |
| 月石 | 黑石×10 | 1,000 |
| 玄石 | 月石×10 | 10,000 |
| 耀阳石 | 玄石×10 | 100,000 |
| 绿玉 | 青玉×10 | 100 |
| 黄玉 | 绿玉×10 | 1,000 |
| 白玉 | 黄玉×10 | 10,000 |
| 黑珍珠 | 白玉×10 | 100,000 |

## 相关源码

- `svClass.pas` — 加载逻辑（第 5379 行）
- `svClass.pas` — `TItemClass.GetSmeltItemData2`（第 5764 行）
- `1000ydef\deftype.pas` — `TSmeltItemData` 记录定义（第 1956 行）
- `uUserSub.pas` — `THaveJobClass.SmeltItem2`（第 12397 行）
- `uUserSub.pas` — 精炼执行逻辑（第 13567 行）
