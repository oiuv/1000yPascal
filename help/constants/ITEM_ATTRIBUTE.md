# 物品属性常量 (ITEM_ATTRIBUTE_*)

> 源码: `1000ydef/deftype.pas` 第 172-193 行

定义物品的元素属性和特殊标记，对应 `Init_Item.sdb` 中的 `attrib` 字段。

---

## 元素属性

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `ITEM_ATTRIBUTE_NONE` | 0 | 无属性 | 没有元素属性 |
| `ITEM_ATTRIBUTE_FIRE` | 1 | 火属性 | 火的性质物品 |
| `ITEM_ATTRIBUTE_WATER` | 2 | 水属性 | 水的性质物品 |
| `ITEM_ATTRIBUTE_ICE` | 3 | 冰属性 | 冰冷的性质物品 |
| `ITEM_ATTRIBUTE_FILL` | 4 | 恢复属性 | 恢复活力/内/外/武功的物品 |
| `ITEM_ATTRIBUTE_SET` | 5 | 套装属性 | 套装物品标记 |
| `ITEM_ATTRIBUTE_DIRECT` | 6 | 直接获取 | 直接进入物品栏（不掉落地面） |
| `ITEM_ATTRIBUTE_PAPERBESTPROTECT` | 7 | 四大公力全书 | 绝世武功-公力类全书 |
| `ITEM_ATTRIBUTE_PAPERBESTSPECIAL` | 8 | 超式全书 | 绝世武功-超式类全书 |
| `ITEM_ATTRIBUTE_QUESTSIGN` | 9 | 任务标记 | 任务相关标记 |

## 特殊属性

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `ITEM_ATTRIBUTE_TAEGUK` | 199 | 太极属性 |
| `ITEM_ATTRIBUTE_LOWEST` | 201 | 最低等级 |
| `ITEM_ATTRIBUTE_LOWEER` | 202 | 低级 |
| `ITEM_ATTRIBUTE_NORMAL` | 203 | 普通等级 |
| `ITEM_ATTRIBUTE_HIGHER` | 204 | 高级 |
| `ITEM_ATTRIBUTE_HIGHEST` | 205 | 最高等级 |

---

## 属性相克关系

火(1) → 冰(3) → 水(2) → 火(1)（循环相克）

相关源码: `AM_WHRelationTable` 在 `svClass.pas` 中定义

---

## 相关文档

- [ITEM_KIND.md](ITEM_KIND.md) — 物品类型常量
- [Init_item.sdb.md](../Init_item.sdb.md) — 物品数据库结构
