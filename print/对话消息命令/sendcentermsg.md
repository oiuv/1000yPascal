# sendcentermsg

## 功能描述
在指定玩家的屏幕中间显示通告消息。消息会以系统消息的形式显示在屏幕中央位置，使用系统颜色（SAY_COLOR_SYSTEM）。

## 语法格式
```pascal
print('sendcentermsg 玩家名 消息内容');
```

## 参数说明
| 参数 | 说明 |
|------|------|
| 玩家名 | String - 接收消息的玩家名称 |
| 消息内容 | String - 要显示的通告文本，文本中的空格需要用下划线 `_` 代替 |

## 说明
该命令通过玩家名称查找在线玩家，找到后向该玩家发送屏幕中央消息。消息使用 `SM_SHOWCENTERMSG` 协议包发送，颜色固定为系统颜色。

如果指定的玩家不在线或名称错误，命令会静默失败。

**源码实现（uScriptManager.pas）：**
```pascal
end else if Cmd = 'sendcentermsg' then begin
   Str := ChangeScriptString (Params [1], '_', ' ');
   Params [1] := Str;
   TBasicObject (aSelf).PushCommand (CMD_SENDCENTERMSG, Params, 0);
end;
```

**命令执行（uSkills.pas）：**
```pascal
CMD_SENDCENTERMSG:
   begin
      tmpUser := UserList.GetUserPointer(pWorkParam[0]^.sValue);
      if tmpUser <> nil then begin
         tmpUser.SendClass.SendCenterMessage(pWorkParam[1]^.sValue);
      end;
   end;
```

**协议发送（uSendCls.pas）：**
```pascal
procedure TSendClass.SendCenterMessage(const aStr: String);
var
   ComData: TWordComData;
   psMessage: PTSShowCenterMsg;
begin
   psMessage := @ComData.Data;
   psMessage^.rMsg := SM_SHOWCENTERMSG;
   psMessage^.rColor := SAY_COLOR_SYSTEM;
   SetWordString(psMessage^.rText, aStr);
   // ...
end;
```

## 示例

> **注意**：在当前 `bin/Script/` 目录下的脚本中未找到该命令的实际使用示例。以下为基础语法示例。

### 基础用法
```pascal
// 向玩家显示屏幕中央通知
print('sendcentermsg 张三 欢迎来到千年世界');

// 通知中包含空格（用下划线代替）
print('sendcentermsg 李四 任务已完成_请领取奖励');
```

### 配合任务系统使用
```pascal
// 触发事件时通知玩家
Name := callfunc('getsendername');
Str := 'sendcentermsg ' + Name + ' 重要提示_前方有强敌出没';
print(Str);
```

## 注意事项

1. **仅对指定玩家有效**：消息只发送给参数中指定的玩家，不是全服广播
2. **空格处理**：消息内容中的空格必须用下划线 `_` 代替
3. **玩家必须在线**：如果指定的玩家不在线，命令无效
4. **显示位置**：消息显示在屏幕中央，与 `say`（对话气泡）和 `sendsenderchatmessage`（聊天窗口）的显示位置不同
5. **颜色固定**：消息颜色由客户端系统颜色定义，脚本无法控制

## 相关命令
- `say` — NPC 对话（对话气泡）
- `sendsenderchatmessage` — 发送聊天消息到聊天窗口
- `sendsendertopmsg` — 发送屏幕顶部滚动公告
- `saybyname` — 指定对象说话
