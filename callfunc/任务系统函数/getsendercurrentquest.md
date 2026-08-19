# getsendercurrentquest

## 功能描述
获取触发者（玩家）当前正在进行的任务编号。

## 语法格式
```pascal
Str := callfunc('getsendercurrentquest');
```

## 参数说明
- 无参数

## 返回值
- **整数（字符串）**：触发者（玩家）当前正在进行的任务编号

## 源码实现
```pascal
// uScriptManager.pas 第554行
end else if cmd = 'getsendercurrentquest' then begin
   Result := IntToStr (TBasicObject (FSender).SGetCurrentQuest);
```

调用 `TBasicObject.SGetCurrentQuest`，使用 `FSender`（触发者/玩家）对象。

## 使用示例

### 检查玩家当前任务
```pascal
Str := callfunc ('getsendercurrentquest');
nQuest := StrToInt (Str);
if nQuest > 0 then begin
    print ('say 你当前有任务在进行');
end;
```

## 注意事项

1. **返回值格式**：返回字符串类型的整数，需要 `StrToInt` 转换
2. **FSender 对象**：此函数获取的是触发者（玩家）的当前任务状态
3. **与 getcurrentquest 的区别**：`getsendercurrentquest` 获取玩家的，`getcurrentquest` 获取 NPC 自身的
4. **无参数**：不需要传入任何参数

## 相关函数
- `getcurrentquest` - 获取自身当前任务
- `getsendercompletequest` - 获取触发者完成任务
- `getsenderfirstquest` - 获取触发者第一任务
