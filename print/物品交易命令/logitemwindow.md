# logitemwindow

## 功能描述
打开物品日志窗口（福袋窗口），允许玩家查看物品获取/消耗的记录。窗口会关联到触发此命令的 NPC 对象。

## 语法格式
```pascal
print('logitemwindow');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 第257-258行：

```pascal
end else if cmd = 'logitemwindow' then begin
   TBasicObject (aSender).SLogItemWindow (FSelf);
```

基于 `UUser.pas` 第10335-10338行的实现：

```pascal
procedure TUser.SLogItemWindow (aCommander : TBasicObject);
begin
   ShowWindowClass.Commander := aCommander;
   ShowWindowClass.ShowItemLogWindow;
end;
```

**实现细节：**
- `aSender` 是玩家对象（`TUser`），`FSelf` 是触发命令的 NPC 对象
- 先将 NPC 设置为窗口的 `Commander`（命令者），用于后续窗口交互
- 调用 `ShowItemLogWindow` 显示物品日志窗口
- `FSelf` 在 `ScriptCommand` 中设置，指向当前执行脚本的 NPC

## 使用示例

### NPC 对话中打开日志窗口
基于 `药材商.txt` 中的使用：

```pascal
if aStr = 'log' then begin
  Str := 'logitemwindow';
  print (Str);
  exit;
end;
```

### 一级药材商
基于 `一级药材商.txt` 中的使用：

```pascal
if aStr = 'log' then begin
  Str := 'logitemwindow';
  print (Str);
  exit;
end;
```

### 帝王石谷药材商
基于 `帝王石谷药材商.txt` 中的使用：

```pascal
if aStr = 'log' then begin
  Str := 'logitemwindow';
  print (Str);
  exit;
end;
```

### 双击物品触发
基于 `储物袋.txt` 中的使用：

```pascal
procedure OnDblClick(aStr : String);
var
  Str : String;
  Race : Integer;
begin
  // 检查玩家种族
  Str := callfunc ('getsenderrace');
  Race := StrToInt (Race);
  if Race = 1 then begin
    Str := 'logitemwindow';
    print (Str);
    exit;
  end;
end;
```

## 注意事项

1. **无参数**：此命令不接受参数，窗口内容自动关联到当前 NPC
2. **NPC 关联**：窗口会将触发命令的 NPC 设为 `Commander`，用于后续交互
3. **常见用途**：药材商类 NPC 提供物品日志查询功能，玩家可查看物品获取记录
4. **种族限制**：在 `储物袋.txt` 中，只有种族为 1 的玩家才能打开
5. **与 guilditemwindow 的区别**：`logitemwindow` 打开个人物品日志，`guilditemwindow` 打开公会物品日志

## 相关命令
- `tradewindow` - 打开买卖窗口
- `guilditemwindow` - 打开公会物品窗口
- `showwindow` - 显示对话窗口
