# changesenderdynobjstate

## 功能

把一个动态对象步阶变更请求加入当前脚本对象 `aSelf` 的工作队列。命令名含 `sender`，但实现没有在 `aSender` 上执行。

```pascal
print('changesenderdynobjstate 动态对象名 true|false');
```

## 源码行为

```pascal
TBasicObject(aSelf).PushCommand(CMD_CHANGESTEP, Params, 0);
```

队列保存前两个字符串参数。`uSkills.pas` 的 `CMD_CHANGESTEP` 处理器在当前 `Manager.DynamicObjectList` 中按第一个参数调用 `ChangeStep`：第二个参数不区分大小写等于 `TRUE` 时递增步阶，否则递减步阶。

这与 `changedynobjstate` 的目标和最终动作相同，但后者直接调用 `SChangeDynobjState`，不经过工作队列。

依据：`uScriptManager.pas`、`BasicObj.pas`、`uSkills.pas`。
