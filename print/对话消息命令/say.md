# say

## 功能

让当前脚本对象 `aSelf` 按工作队列执行说话命令。

```pascal
print('say 文本 [间隔值]');
```

第一个参数中的 `_` 会转换为空格；第二个参数经 `_StrToInt` 后直接写入 `TWorkSet.Interval`，省略或无法转换时按该转换函数的结果处理。

```pascal
Str := ChangeScriptString(Params[0], '_', ' ');
TBasicObject(aSelf).PushCommand(CMD_SAY, Str, _StrToInt(Params[1]));
```

`CMD_SAY` 到期后调用当前对象的 `SSay`。基类 `TBasicObject.SSay` 为空；具体对象是否产生消息取决于其重写实现，例如 `TDynamicObject.SSay` 调用 `BocSay`。因此不能仅凭命令入口断言所有对象类型都具有相同显示效果。

依据：`uScriptManager.pas`、`BasicObj.pas`、`uWorkBox.pas`。
