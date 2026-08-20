# getparty

## 功能与语法

读取当前事件发送者婚姻记录中的 `Party` 标志。

```pascal
Result := callfunc('getparty');
```

返回小写字符串 `true` 或 `false`。这里的 `Party` 是 `Event/Marry.SDB` 中由婚礼流程维护的字段，不是通用玩家组队状态，也不会查询队伍成员列表。

`TUser.SGetParty` 调用 `MarryList.isParty(Name)`；后者按姓名匹配 `Girl` 或 `Boy`。没有婚姻记录时返回 `false`。`setparty` 会把匹配记录的该标志设为 `True`，但即使没有匹配记录也固定返回 `true`，不能依靠写入返回值判断成功。

婚姻表结构与已知保存问题见 [Event 运行数据](../../help/Event.md)。源码依据：`uScriptManager.pas`、`UUser.pas` 的 `SGetParty` 和 `svClass.pas` 的 `TMarryClass.isParty`。
