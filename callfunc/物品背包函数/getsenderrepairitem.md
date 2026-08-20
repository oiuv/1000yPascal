# getsenderrepairitem

维修当前触发玩家的指定类型物品。

## 语法

```pascal
Result := callfunc('getsenderrepairitem <Key> <Kind>');
```

参数顺序与源码一致：`Key` 是穿戴栏索引，`Kind` 是 `ITEM_KIND_*`。当 `Kind=ITEM_KIND_EIGHTANGLES`（59）时忽略 `Key`，改在背包中按类型查找；其他可维修类型从穿戴栏 `Key` 读取。

## 返回代码

| 值 | 当前实现 |
| ---: | --- |
| `-1` | 初始/未完成状态，也包括钱不足或类型未进入维修分支 |
| `0` | 索引无效、物品为空、未找到或特定不可维修物品 |
| `1` | 最大耐久为 0 |
| `2` | 当前耐久已等于最大耐久 |
| `3` | `ITEM_KIND_PICKAX` 增加耐久失败 |
| `4` | 维修并扣款成功 |

穿戴栏实现只处理 `ITEM_KIND_PICKAX`（27）、`ITEM_KIND_HIGHPICKAX`（57）、`ITEM_KIND_DURAWEAPON`（60）；背包实现只处理 `ITEM_KIND_EIGHTANGLES`（59）。费用来自物品的 `rRepairPrice`，部分类型再乘缺失耐久。

```pascal
Result := callfunc('getsenderrepairitem 9 60');
```

源码入口：`TScriptManager.CallFunction` → `TUser.SRepairItem` → `TWearItemClass.RepairItem` 或 `THaveItemClass.RepairItem`。
