# say

## 功能描述
让当前对象（NPC、Monster、DynamicObject）说话，显示对话内容。

## 语法格式
```pascal
print('say 对话内容');
print('say 对话内容 延迟时间');
```

## 参数说明
- **对话内容**：String - 要显示的对话文本，文本中的空格需要用下划线 `_` 代替
- **延迟时间**：Integer（可选）- 对话显示的延迟时间，以毫秒为单位，如果不指定则使用默认延迟

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
if Cmd = 'say' then begin
   Str := ChangeScriptString (Params [0], '_', ' ');
   TBasicObject (aSelf).PushCommand (CMD_SAY, Str, _StrToInt (Params [1]));
end;
```

基于 `BasicObj.pas` 中的实现：

```pascal
procedure TBasicObject.PushCommand(aCmd: Byte; aParams: array of string; aInterval: Integer);
begin
   WorkSet := TWorkSet.Create;
   WorkSet.Cmd := aCmd;
   WorkSet.Interval := aInterval;  // 设置延迟时间
   // ...
   case aCmd of
      CMD_SAY:
         begin
            WorkSet.Priority := wsp_tera;
            WorkSet.AddsParam(wpt_string, aParams[0]);
         end;
   end;
end;
```

## 参数处理机制
- **第1个参数**：对话内容，通过 `ChangeScriptString` 函数将下划线 `_` 转换为空格 ` `
- **第2个参数**：延迟时间，使用 `_StrToInt` 转换为整数，传递给 `WorkSet.Interval`
- **延迟执行**：系统会在 `FTick + FInterval` 时间后执行对话显示

## 使用示例

### 基础对话
```pascal
// 简单对话（立即显示）
print('say 你好，欢迎来到千年世界！');

// 带延迟的对话（延迟3秒显示）
print('say 重要提示 3000');
```

### 复杂对话内容
```pascal
// 对话内容中的空格用下划线代替
print('say 这是一条很长的对话内容_包含多个单词');

// 延迟显示复杂对话（延迟2秒）
print('say 请注意_前方有危险 2000');
```

### 真实游戏示例
基于 `quest神医.txt` 中的使用：

```pascal
// 检查物品存在性的对话
Str := callfunc ('getsenderitemexistence 神医丹药:1');
if Str = 'true' then
   print ('say 你不需要药吗?');
   exit;
end;

// 背包空间不足的对话
Str := callfunc ('checkenoughspace');
if Str = 'false' then
   print ('say 物品栏满了...');
   exit;
end;
```

基于其他脚本中的使用：

```pascal
// 提示信息
print ('say 需要高级英雄令');

// 确认对话（延迟0.1秒显示）
print ('say 不胜感激... 100');
```

## 注意事项

1. **空格处理**：对话文本中的空格必须用下划线 `_` 代替，系统会自动转换
2. **延迟时间**：延迟时间以毫秒为单位，1000 = 1秒，用于控制对话显示的时机
3. **对象限制**：`say` 命令只能让脚本绑定的对象说话，不能让其他对象说话
4. **编码问题**：对话内容使用GBK编码，在脚本中直接使用即可
5. **字符限制**：对话内容可能有长度限制，超长内容可能被截断
6. **时间计算**：系统使用游戏内部时钟计算延迟，实际显示时间可能略有偏差

## 相关命令
- `saybyname` - 让指定对象说话
- `sendsenderchatmessage` - 发送聊天消息给玩家
- `sendsendertopmsg` - 发送顶部公告