# changecompletequest

调用当前脚本对象 `aSelf` 的 `SChangeCompleteQuest`。

```pascal
print ('changecompletequest <任务编号>');
```

基础 `TBasicObject` 实现为空操作；只有 `TUser` 覆盖实现会写入 `UserQuestClass.CompleteQuestNo`。因此不能用它维护 NPC/Monster/DynamicObject 的“自身任务状态”。

仅当调用上下文中的 `Self` 是玩家时，本命令才修改玩家。常规 NPC 交互要修改触发玩家，应使用 `changesendercompletequest`。

相关命令：`changesendercompletequest`、`changecurrentquest`、`changefirstquest`。
