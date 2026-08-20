# changesenderfirstquest

## 功能

直接设置触发脚本玩家 `aSender` 的 `UserQuestClass.FirstQuestNo`。

```pascal
print('changesenderfirstquest 任务编号');
```

参数经 `_StrToInt` 转成整数；当前实现没有在此命令中检查范围、顺序或前置任务。

```pascal
TBasicObject(aSender).SChangeFirstQuest(_StrToInt(Params[0]));

procedure TUser.SChangeFirstQuest(aQuest: Integer);
begin
   UserQuestClass.FirstQuestNo := aQuest;
end;
```

任务编号的业务含义必须以实际服务器脚本和配置为准，不能由字段名推导。

依据：`uScriptManager.pas`、`UUser.pas`。
