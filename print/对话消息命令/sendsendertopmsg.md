# sendsendertopmsg

## 功能

通过全局 `UserList` 向在线玩家广播顶部消息。

```pascal
print('sendsendertopmsg 消息文本');
```

命令先把第一个参数中的 `_` 转为空格，再在 `aSender` 上调用 `SSendTopMessage`。该方法的实现为：

```pascal
procedure TBasicObject.SSendTopMessage(aStr: string);
begin
   UserList.SendTopMessage(aStr);
end;
```

因此消息不是仅发给 `aSender`，而是交给全局玩家列表广播。源码没有定义逗号换行、消息长度或优先级规则，脚本不应依赖这些未经实现证明的格式。

依据：`uScriptManager.pas`、`BasicObj.pas`。
