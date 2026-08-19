# marry

## 功能描述
弹出结婚确认窗口。向玩家发送结婚请求界面，让玩家输入求婚对象的信息。如果玩家已有配偶（Lover 不为空），则提示已有伴侣。

## 语法格式
```pascal
print('marry 提示文本');
```

## 参数说明
- **提示文本**：String - 结婚窗口中显示的提示文本，引导玩家输入求婚对象信息

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'marry' then begin
   TUser(aSender).MarryWindow(Params[0]);
```

`TUser.MarryWindow` 实现在 `UUser.pas` 中：

```pascal
procedure TUser.MarryWindow (aHelpText:String);
begin
   if Lover = '' then begin
      ShowWindowClass.ShowMarry(aHelpText);
   end else begin
      SSendChatMessage (Conv('你已经有伴侣了.'), SAY_COLOR_SYSTEM);
   end;
end;
```

## 使用示例

### 婚礼司仪脚本（真实示例）
来自 `bin/Script/婚礼司仪.txt`：

```pascal
if aStr = 'marry' then begin
   print('marry 请输入您要求婚的对象');
   exit;
end;
```

玩家点击婚礼司仪的结婚选项后，弹出结婚窗口并显示提示文本"请输入您要求婚的对象"。

## 注意事项

1. **未婚检查**：如果玩家已有配偶（Lover 不为空），不会弹出窗口，而是发送系统提示"你已经有伴侣了"
2. **提示文本**：参数文本显示在结婚窗口中，用于引导玩家操作
3. **配合婚礼系统**：需要与婚礼司仪NPC、喜帖、戒指等物品配合使用
4. **双向确认**：结婚需要双方确认，通过 `unmarry` 可以解除婚约

## 相关命令
- `unmarry` - 离婚
- `setmarryclothes` - 设置结婚服装
- `getmarryinfo` - 查询结婚信息（callfunc 函数）
- `getmarryclothes` - 查询结婚服装领取状态（callfunc 函数）
