# mapregenbyname

## 功能

把“按地图 ID 刷新”的命令加入指定对象的工作队列。命令名中的 `byname` 指按名称查找承载命令的对象，不是按地图名称查找地图。

## 语法

```pascal
print('mapregenbyname 地图ID 对象名 对象类型');
```

| 参数 | 说明 |
| --- | --- |
| `地图ID` | 最终传给 `ManagerList.RegenById` 的整数 |
| `对象名` | 要查找的对象名称 |
| `对象类型` | `MONSTER`、`NPC` 或 `USER`，比较时不区分大小写 |

## 执行逻辑

`uScriptManager.pas` 把完整参数数组及 `Params[1]`、`Params[2]` 传给 `SMapRegenByName`。该方法按类型查找对象：怪物和 NPC 在当前 `Manager` 中查找，玩家在全局 `UserList` 中查找。找到后向该对象加入 `CMD_MAPREGEN`；命令执行时读取 `Params[0]`，调用 `SMapRegen(地图ID)`。

目标对象不存在或类型不是上述三种时，不会加入命令。`bin/Script` 中未发现现成调用示例。

## 相关命令

- `mapregen`：立即按地图 ID 调用刷新。
