# directmovespace

## 功能

按名称查找对象并立即改变位置。命令作用于 `aSelf` 所在的服务上下文，不进入工作队列。

```pascal
print('directmovespace 名称 类型 地图ID X Y');
```

## 参数与行为

| 参数 | 源码行为 |
|---|---|
| 名称 | 要查找的玩家、怪物或 NPC 名称 |
| 类型 | 不区分大小写的 `USER`、`MONSTER` 或 `NPC`；其他值不处理 |
| 地图ID | 仅 `USER` 分支使用，写入 `SubData.ServerId` 后发送 `FM_GATE` |
| X、Y | 目标坐标 |

- `USER`：从全局 `UserList` 查找玩家，先写入 `BasicData.nx/ny`，再发送跨地图的 `FM_GATE` 消息。
- `MONSTER`：从当前 `Manager.MonsterList` 取第一个同名存活对象，调用 `CallMe(X, Y)`；地图 ID 被忽略。
- `NPC`：从当前 `Manager.NpcList` 取第一个同名存活对象，调用 `CallMe(X, Y)`；地图 ID 被忽略。

## 源码入口

```pascal
TBasicObject(aSelf).SMoveSpace(
  Params[0], Params[1], _StrToInt(Params[2]),
  _StrToInt(Params[3]), _StrToInt(Params[4]));
```

依据：`uScriptManager.pas`、`BasicObj.pas` 的 `TBasicObject.SMoveSpace`。
