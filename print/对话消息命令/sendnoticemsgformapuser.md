# sendnoticemsgformapuser

## 功能描述
向指定地图（ServerID）上的所有在线玩家发送通知消息，显示在聊天窗口中。

## 语法格式
```pascal
print('sendnoticemsgformapuser 地图ID 消息内容 颜色值');
```

## 参数说明
| 参数 | 说明 |
|------|------|
| 地图ID | Integer - 目标地图的 ServerID，消息只发送给该地图上的玩家 |
| 消息内容 | String - 要发送的通知文本，文本中的空格需要用下划线 `_` 代替 |
| 颜色值 | Integer - 消息的颜色代码（Byte 类型，0-255） |

## 说明
该命令遍历所有在线玩家，筛选出位于指定地图（ServerID）上的玩家，向他们发送聊天消息。消息通过 `SendChatMessage` 协议发送，显示在玩家的聊天窗口中。

**源码实现（uScriptManager.pas）：**
```pascal
end else if Cmd = 'sendnoticemsgformapuser' then begin
   Str := ChangeScriptString (Params [1], '_', ' ');
   TBasicObject (aSelf).SSendNoticeMessageForMapUser (_StrToInt (Params [0]), Str, _StrToInt (Params [2]));
end;
```

**底层实现（BasicObj.pas）：**
```pascal
procedure TBasicObject.SSendNoticeMessageForMapUser(aServerID: Integer; aStr: string; aColor: Integer);
begin
   UserList.SayByServerID(aServerID, aStr, aColor);
end;
```

**消息分发（UUser.pas）：**
```pascal
procedure TUserList.SayByServerID(aServerID: Integer; const aStr: String; aColor: Byte);
var
   i: integer;
   User: TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items[i];
      if User.Manager.ServerID = aServerID then begin
         User.SendClass.SendChatMessage(aStr, aColor);
      end;
   end;
end;
```

## 示例

### 王陵装置事件通知（王陵装置.txt）
```pascal
// 入侵警报（地图70，颜色15）
print ('sendnoticemsgformapuser 70 <雨中客>_有人侵入王陵 15');
print ('sendnoticemsgformapuser 70 <雨中客>_启动机关装置! 15');

// 剧情推进通知
print ('sendnoticemsgformapuser 70 <雨中客>_损失比预计的要惨重 15');
print ('sendnoticemsgformapuser 70 <雨中客>_封锁秘密通道 15');

// 紧急通知
print ('sendnoticemsgformapuser 70 <雨中客>_再也支撑不住了 15');
print ('sendnoticemsgformapuser 70 <雨中客>_封锁所有的出入口 15');
```

## 注意事项

1. **地图范围限制**：消息只发送给指定 ServerID 地图上的玩家，其他地图的玩家不会收到
2. **空格处理**：消息内容中的空格必须用下划线 `_` 代替
3. **颜色值**：颜色代码由客户端定义，不同数值对应不同颜色显示
4. **显示位置**：消息显示在玩家的聊天窗口中，与 `sendsenderchatmessage` 类似，但范围是整张地图的玩家
5. **与 sendsenderchatmessage 的区别**：`sendsenderchatmessage` 只发给触发脚本的玩家，`sendnoticemsgformapuser` 发给指定地图上的所有玩家

## 相关命令
- `sendsenderchatmessage` — 发送聊天消息给触发脚本的玩家
- `sendsendertopmsg` — 发送顶部公告
- `say` — NPC 对话
- `saybyname` — 指定对象说话
