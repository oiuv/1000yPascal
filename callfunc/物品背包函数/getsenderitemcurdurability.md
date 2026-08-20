# getsenderitemcurdurability

## 功能与语法

读取玩家指定穿戴槽的当前耐久度。

```pascal
Str := callfunc('getsenderitemcurdurability <穿戴槽索引>');
```

参数经 `_StrToInt` 转为槽位索引。返回十进制字符串；槽位无效、读取失败或没有物品时返回 `0`。源码最终读取 `ItemData.rCurDurability`。

## 源码依据

`uScriptManager.pas` 调用 `TUser.SGetWearItemCurDurability`；实际槽位范围由 `WearItemClass.ViewItem` 判定，脚本层不预先限制。
