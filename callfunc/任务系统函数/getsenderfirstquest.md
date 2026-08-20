# getsenderfirstquest

## 功能描述
获取触发者（玩家）的第一任务编号。

## 语法格式
```pascal
Str := callfunc('getsenderfirstquest');
```

## 参数说明
- 无参数

## 返回值
- **整数（字符串）**：触发者（玩家）的第一任务编号

## 源码实现
```pascal
// uScriptManager.pas 第560行
end else if cmd = 'getsenderfirstquest' then begin
   Result := IntToStr (TBasicObject (FSender).SGetFirstQuest);
```

调用 `TBasicObject.SGetFirstQuest`，使用 `FSender`（触发者/玩家）对象。

## 使用示例

### 检查玩家新手任务状态
```pascal
Str := callfunc ('getsenderfirstquest');
nQuest := StrToInt (Str);
if nQuest < 1 then begin
    print ('say 你还没有开始新手引导');
end;
```

## 注意事项

1. **返回值格式**：返回字符串类型的整数，需要 `StrToInt` 转换
2. **FSender 对象**：此函数获取的是触发者（玩家）的第一任务状态
3. **与 getfirstquest 的区别**：本函数固定作用于 `FSender`；`getfirstquest` 作用于 `FSelf`。只有对应对象实际为 `TUser` 时才会读取玩家任务字段
4. **无参数**：不需要传入任何参数

## 相关函数
- `getfirstquest` - 获取 `FSelf` 的第一任务值（基础对象固定返回 0）
- `getsendercompletequest` - 获取触发者完成任务
- `getsendercurrentquest` - 获取触发者当前任务
