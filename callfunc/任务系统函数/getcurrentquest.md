# getcurrentquest

读取当前脚本对象 `FSelf` 的当前任务编号，返回十进制数字字符串。

```pascal
Str := callfunc ('getcurrentquest');
CurrentQuest := StrToInt (Str);
```

分派器调用 `TBasicObject(FSelf).SGetCurrentQuest`。基础对象实现固定返回 `0`，只有 `TUser` 覆盖实现读取 `UserQuestClass.CurrentQuestNo`。所以该函数只在 `Self` 确实是玩家的调用上下文中有玩家任务语义；普通 NPC/Monster/DynamicObject 不保存这项任务状态。

NPC 交互中读取触发玩家应使用 `getsendercurrentquest`。不要把本函数用于“NPC 自身任务计数器”；对象脚本需要自己的状态时应使用脚本变量或已有事件字段。

相关函数：`getsendercurrentquest`、`getfirstquest`、`getcompletequest`。
