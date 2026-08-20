# changecurrentquest

调用当前脚本对象 `aSelf` 的 `SChangeCurrentQuest`。

```pascal
print ('changecurrentquest <任务编号>');
```

基础 `TBasicObject` 实现为空操作；只有 `TUser` 覆盖实现会写入 `UserQuestClass.CurrentQuestNo`。所以本命令不是“NPC 自身任务状态”接口，也不适合给 NPC 保存进度。

仅当事件中的 `Self` 确实是玩家时，本命令才修改玩家数据。常规 NPC 交互要修改触发者，应使用 `changesendercurrentquest`。

相关命令：`changesendercurrentquest`、`changefirstquest`、`changecompletequest`。
