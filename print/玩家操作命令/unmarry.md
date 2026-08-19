# unmarry

## 功能描述
弹出离婚确认窗口。向玩家发送离婚请求界面，让玩家确认是否解除婚约。如果玩家没有配偶，则提示需要支付罚金。

## 语法格式
```pascal
print('unmarry 提示文本');
```

## 参数说明
- **提示文本**：String - 离婚窗口中显示的提示文本

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'unmarry' then begin
   TUser(aSender).UnMarryWindow(Params [0]);
```

`TUser.UnMarryWindow` 实现在 `UUser.pas` 中：

```pascal
procedure TUser.UnMarryWindow (aHelpText:String);
var
   aUser :TUser;
   ItemData : TItemData;
begin
   if Lover <> '' then begin
      aUser := UserList.GetUserPointer(Lover);
      if aUser = nil then begin
         SSendChatMessage(Conv('对方不在线,需要交纳罚金20万,交纳后20天可重新结婚'), SAY_COLOR_SYSTEM);
         ItemClass.GetItemData (Conv('金币'), ItemData);
         ItemData.rCount := 200000;
         if Not DeleteItem(@ItemData) then begin
            SSendChatMessage(Conv('金钱不足离婚条件.'), SAY_COLOR_SYSTEM);
            Exit;
         end;
         // ... 后续离婚处理
      end;
      // ... 在线离婚处理
   end;
end;
```

## 使用示例

### 婚礼司仪脚本（真实示例）
来自 `bin/Script/婚礼司仪.txt`：

```pascal
if aStr = 'unmarry' then begin
   print('unmarry 您的配偶希望跟您解除婚约');
   exit;
end;
```

玩家点击离婚选项后，弹出离婚确认窗口并显示提示文本"您的配偶希望跟您解除婚约"。

## 注意事项

1. **配偶在线/离线处理不同**：
   - 配偶在线：直接弹出离婚确认窗口
   - 配偶离线：需要缴纳 20 万金币罚金，且 20 天后才能重新结婚
2. **金币检查**：离线离婚需要 20 万金币，金币不足则提示"金钱不足离婚条件"
3. **提示文本**：参数文本显示在离婚窗口中，用于引导玩家操作
4. **需要已婚状态**：如果玩家没有配偶（Lover 为空），命令不执行

## 相关命令
- `marry` - 结婚
- `setmarryclothes` - 设置结婚服装
- `getmarryinfo` - 查询结婚信息（callfunc 函数）
