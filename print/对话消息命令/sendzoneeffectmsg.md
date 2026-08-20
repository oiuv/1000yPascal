# sendzoneeffectmsg

## 功能

让当前动态对象按名称触发一个区域效果对象。

```pascal
print('sendzoneeffectmsg 区域效果名');
```

命令在 `aSelf` 上调用 `SSendZoneEffectMessage(Params[0])`。基类实现为空，`TDynamicObject` 的重写才会调用：

```pascal
ZoneEffectList.SendMsgZoneEffectObject(aName);
```

区域效果列表逐项比较 `ZEObject.SelfData.Name = aName`；每个匹配项执行 `SendFMMessage`，并将结果置为 `true`。比较使用 Pascal 字符串直接相等，名称必须完全一致。

该命令是否有效由 `aSelf` 的实际类型决定；当前源码明确实现的是 `TDynamicObject`。

依据：`uScriptManager.pas`、`BasicObj.pas` 的 `TDynamicObject.SSendZoneEffectMessage` 与 `TZoneEffectList.SendMsgZoneEffectObject`。
