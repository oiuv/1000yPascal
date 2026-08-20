# changefirstquest

调用当前脚本对象 `aSelf` 的 `SChangeFirstQuest`。

```pascal
print ('changefirstquest <任务编号>');
```

基础 `TBasicObject` 实现为空操作，`TUser` 覆盖实现才写入 `UserQuestClass.FirstQuestNo`。因此命令是否修改玩家取决于 `Self` 的实际类型。

## 真实用法

`System.OnUserStart` 由登录玩家作为 `Self` 调用，所以神武线上和炎黄随包脚本都可以这样初始化该玩家：

```pascal
Str := callfunc ('getfirstquest');
FirstQuest := StrToInt (Str);
if FirstQuest < 1 then begin
   print ('changefirstquest 1');
end;
```

这里没有“系统全局任务对象”；写入的是当前登录玩家。普通 NPC 脚本中该命令只会进入基础空实现。NPC 交互要修改触发玩家，应使用 `changesenderfirstquest`。

相关命令：`changesenderfirstquest`、`changecurrentquest`、`changecompletequest`。
