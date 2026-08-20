# getcompletequest

读取当前脚本对象 `FSelf` 的已完成任务编号，返回十进制数字字符串。

```pascal
Str := callfunc ('getcompletequest');
CompleteQuest := StrToInt (Str);
```

分派器调用 `TBasicObject(FSelf).SGetCompleteQuest`。基础对象实现固定返回 `0`，只有 `TUser` 覆盖实现读取 `UserQuestClass.CompleteQuestNo`。因此本函数并不读取“NPC 自身任务”；只有事件中的 `Self` 是玩家时才会取得玩家数据。

NPC 交互脚本读取触发玩家应使用 `getsendercompletequest`。普通 NPC/Monster/DynamicObject 若需要保存流程状态，应使用脚本变量或对应配置机制。

相关函数：`getsendercompletequest`、`getfirstquest`、`getcurrentquest`。
