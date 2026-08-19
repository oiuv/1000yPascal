# getfirstquest

## 功能描述
获取自身（NPC自身）的第一任务编号。

## 语法格式
```pascal
Str := callfunc('getfirstquest');
```

## 参数说明
- 无参数

## 返回值
- **整数（字符串）**：第一任务编号

## 源码实现
```pascal
// uScriptManager.pas 第558行
end else if cmd = 'getfirstquest' then begin
   Result := IntToStr (TBasicObject (FSelf).SGetFirstQuest);
```

调用 `TBasicObject.SGetFirstQuest`，注意此处使用 `FSelf`（NPC自身）而非 `FSender`（触发者/玩家）。

## 使用示例

### System.txt 中新玩家检测
```pascal
// 获取第一任务状态（注意：此处实际使用 getfirstquest 获取玩家状态）
Str := callfunc ('getfirstquest');
FirstQuest := StrToInt (Str);
if FirstQuest < 1 then begin
    Str := callfunc ('getname');
    Str := 'sendsendertopmsg 欢迎新玩家[' + Str;
    Str := Str + '],来到云端千年的武侠世界';
    print (str);
    Str := 'changefirstquest 1';
    print (str);
end;
```
> 来源：`System.txt`

## 注意事项

1. **返回值格式**：返回字符串类型的整数，需要 `StrToInt` 转换
2. **FSelf 对象**：此函数获取的是 NPC 自身的第一任务状态
3. **新玩家检测**：常用于 System 脚本中检测新玩家并发送欢迎消息
4. **与 getsenderfirstquest 的区别**：`getfirstquest` 获取 NPC 自身的，`getsenderfirstquest` 获取触发者（玩家）的
5. **无参数**：不需要传入任何参数

## 相关函数
- `getsenderfirstquest` - 获取触发者第一任务
- `getcompletequest` - 获取自身完成任务
- `getcurrentquest` - 获取自身当前任务
