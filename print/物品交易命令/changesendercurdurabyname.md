# changesendercurdurabyname

按名称修改当前触发玩家背包内第一个匹配物品的当前耐久。

## 语法

```pascal
print('changesendercurdurabyname <物品名> <当前耐久>');
```

实现调用 `HaveItemClass.ChangeCurDuraByName`：先用 `FindItemKeybyName` 定位，未找到或槽位为空时直接返回；名称再次精确匹配后，将 `rCurDurability` 直接赋为参数值。

```pascal
print('changesendercurdurabyname 竹筒 0');
```

源码没有在此方法中限制最小值、最大值，也没有同步修改 `rDurability`。该命令只处理背包 `HaveItemArr`，不处理穿戴栏。
