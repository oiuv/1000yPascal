# putsendermagicitem

## 功能

根据 `ItemClass` 中的模板构造物品，写入所有者字段，记录一条 UDP 对象日志，然后尝试加入事件发送者 `aSender` 的背包。

## 语法

```pascal
print('putsendermagicitem 物品名:数量 所有者名 所有者种族');
```

| 参数 | 说明 |
| --- | --- |
| `物品名:数量` | 以冒号拆分；物品模板不存在时直接退出。数量转换结果为 `0` 时改为 `1`，所以省略冒号和数量也会给 1 个 |
| `所有者名` | 原样写入 `ItemData.rOwnerName`；源码没有要求 `@` 前缀 |
| `所有者种族` | 经 `_StrToInt` 转换并作为 `Byte` 传入，写入 `rOwnerRace` |

服务器还把当前 `ServerID`、玩家坐标写入 `rOwnerServerID`、`rOwnerX`、`rOwnerY`，并把 `rOwnerIP` 清空。

## 执行顺序

1. 调用 `ItemClass.GetItemData` 取得物品模板。
2. 设置数量及所有者字段。
3. 通过 `FrmSockets.UdpObjectAddData` 发送 `Item:物品名,数量,`。
4. 调用 `HaveItemClass.AddItem`；成功时向玩家发送侧边消息。

UDP 内容不含所有者名或种族，而且日志发送发生在 `AddItem` 之前。因此这条 UDP 记录表示一次发放尝试，不能单独证明物品已经成功进入背包。

## 注意

- `bin/Script` 中确有 `@任务或事件名` 形式的所有者名，这是现有脚本约定，不是命令入口强制格式。
- 本方法自身不预检背包空位；需要保证发放成功时，脚本可先调用 `checkenoughspace`。
