# athleticprocess

## 功能与语法

执行源码中固定的竞技活动结算：先按服务器/地图 ID 和队伍字符串发放物品，再把该 ID 上的全部玩家移动到服务器 1 的坐标 `(554,119)`。

```pascal
print('athleticprocess <服务器ID> <队伍字符串> <物品名:数量>');
```

## 源码行为

1. `AddItemByEventTeam(ID, Team, Item)` 遍历在线玩家；仅对 `User.ServerID=ID` 且 `User.EventTeam<>Team` 的玩家调用 `SPutMagicItem`。
2. `MoveByServerID(ID, 1, 554, 119)` 设置该 ID 上所有玩家的新服务器与目标坐标。

队伍比较使用“不等于”，文档按现有实现记录，不推断其设计意图。目标服务器和坐标写死在 `uScriptManager.pas`，脚本参数不能覆盖。
