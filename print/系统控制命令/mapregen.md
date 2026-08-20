# mapregen

按地图/服务器编号请求重新生成地图。

## 语法

```pascal
print('mapregen <MapID>');
```

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `MapID` | Integer | 传给 `ManagerList.RegenById` 的编号 |

命令作用对象是 `aSelf`，而不是 `aSender`。`CommandScript` 立即调用 `SMapRegen(_StrToInt(Params[0]))`；基础实现再调用 `ManagerList.RegenById(aMapID)`。

```pascal
print('mapregen 41');
```

此命令没有源码内置的玩家数、时间、权限或安全位置检查。是否调用以及调用时机应由脚本自行控制；不要把无来源的地图坐标或刷新效果写成固定规则。
