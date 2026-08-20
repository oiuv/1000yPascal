# sendsenderchatmessage

## 功能

向触发脚本的玩家 `aSender` 发送一条聊天消息。`aSender=nil` 时不执行。

```pascal
print('sendsenderchatmessage 消息文本 颜色整数');
```

| 参数 | 处理方式 |
|---|---|
| 消息文本 | `ChangeScriptString` 把 `_` 转为空格后发送 |
| 颜色整数 | 经 `_StrToInt` 原样传给客户端消息方法 |

## 源码行为

```pascal
if aSender <> nil then begin
   Str := ChangeScriptString(Params[0], '_', ' ');
   TBasicObject(aSender).SSendChatMessage(Str, _StrToInt(Params[1]));
end;
```

`TUser.SSendChatMessage` 只调用 `SendClass.SendChatMessage(aStr, aColor)`。当前服务器源码没有给出颜色整数与具体颜色的映射，因此本文不定义颜色含义。

依据：`uScriptManager.pas`、`UUser.pas`。
