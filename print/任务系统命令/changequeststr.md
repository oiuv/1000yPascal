# changequeststr（未实现）

当前 `TScriptManager.CommandScript` 没有 `changequeststr` 分支，因此不要在新脚本中使用这个名称。源码也没有证据表明它“预期作用于 `aSelf`”。

需要修改当前触发玩家的任务字符串时，使用已实现的命令：

```pascal
print('changesenderqueststr <值>');
```

对应实现为：

```pascal
TBasicObject(aSender).SChangeQuestStr(Params[0]);
```

玩家实现将参数写入 `UserQuestClass.QuestStr`。参见 [changesenderqueststr](changesenderqueststr.md)。
