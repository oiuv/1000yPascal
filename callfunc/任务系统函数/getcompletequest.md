# getcompletequest

## 功能描述
获取自身（NPC自身）已完成的任务编号。

## 语法格式
```pascal
Str := callfunc('getcompletequest');
```

## 参数说明
- 无参数

## 返回值
- **整数（字符串）**：已完成的任务编号

## 源码实现
```pascal
// uScriptManager.pas 第548行
end else if cmd = 'getcompletequest' then begin
   Result := IntToStr (TBasicObject (FSelf).SGetCompleteQuest);
```

调用 `TBasicObject.SGetCompleteQuest`，注意此处使用 `FSelf`（NPC自身）而非 `FSender`（触发者/玩家）。

## 使用示例

### 获取NPC已完成任务
```pascal
Str := callfunc ('getcompletequest');
nQuest := StrToInt (Str);
if nQuest > 0 then begin
    print ('say 我已经完成了相关任务');
end;
```

## 注意事项

1. **返回值格式**：返回字符串类型的整数，需要 `StrToInt` 转换
2. **FSelf 对象**：此函数获取的是 NPC 自身的完成任务状态，不是玩家的
3. **与 getsendercompletequest 的区别**：`getcompletequest` 获取 NPC 自身的，`getsendercompletequest` 获取触发者（玩家）的
4. **无参数**：不需要传入任何参数

## 相关函数
- `getsendercompletequest` - 获取触发者完成任务
- `getcurrentquest` - 获取自身当前任务
- `getfirstquest` - 获取自身第一任务
