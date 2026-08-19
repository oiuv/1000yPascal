# sendsound

## 功能描述
向玩家播放音效。可以指定地图 ID 来控制音效的播放范围，只对指定地图上的玩家播放，或对所有在线玩家播放。

## 语法格式
```pascal
print('sendsound 音效文件名 地图ID');
```

## 参数说明
| 参数 | 说明 |
|------|------|
| 音效文件名 | String - WAV 音效文件名（如 `9171.wav`） |
| 地图ID | Integer - 目标地图的 ServerID。`>= 0` 时只对该地图上的玩家播放；`< 0` 时对所有在线玩家播放 |

## 说明
该命令遍历所有在线玩家，根据地图 ID 过滤后，向符合条件的玩家发送音效播放指令。音效通过 `SendSoundEffect` 协议发送，客户端根据文件名播放对应的 WAV 音效。

**源码实现（uScriptManager.pas）：**
```pascal
end else if cmd = 'sendsound' then begin
   TBasicObject (aSelf).SSendSound (Params [0], _StrToInt (Params [1]));
end;
```

**底层实现（BasicObj.pas）：**
```pascal
procedure TBasicObject.SSendSound(aWavName: string; aMapID: Integer);
begin
   UserList.SendSoundMessage(aWavName, aMapID);
end;
```

**消息分发（UUser.pas）：**
```pascal
procedure TUserList.SendSoundMessage(aSoundNum: String; aMapID: Integer);
var
   i: Integer;
   User: TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items[i];
      if (aMapID >= 0) and (User.Manager.ServerID <> aMapID) then continue;
      User.SendClass.SendSoundEffect(aSoundNum, User.BasicData.x, User.BasicData.y);
   end;
end;
```

## 示例

### 场景音效（各场景脚本）
```pascal
// 霸王门场景音效（地图47）
print ('sendsound 9171.wav 47');    // 东天北霸王门.txt

// 冰壁场景音效（地图45）
print ('sendsound 9422.wav 45');    // 冰壁.txt

// 名所场景音效（地图43）
print ('sendsound 9329.wav 43');    // 东海名所1.txt、岩石.txt

// 沙漠场景音效（地图44）
print ('sendsound 9329.wav 44');    // 沙漠名所1.txt、沙漠名所.txt

// 铁栅栏场景音效（地图46）
print ('sendsound 9209.wav 46');    // 铁栅栏.txt
```

### 机关触发音效（蜡台.txt）
```pascal
// 点燃蜡台时播放音效（地图31）
print ('sendsound 9171.wav 31');

// 熄灭时播放不同音效
print ('sendsound 9170.wav 31');
```

### 特殊场景音效
```pascal
// 神龟石像音效（地图49）
print ('sendsound 9416.wav 49');    // 神龟石像.txt

// 小佛像音效（地图43）
print ('sendsound 9416.wav 43');    // 小佛像.txt

// 雪上天蚕音效（地图45）
print ('sendsound 9372.wav 45');    // 雪上天蚕.txt

// 沙漠磐石音效（地图44）
print ('sendsound 9374.wav 44');    // 沙漠磐石.txt
```

## 注意事项

1. **音效文件**：文件名对应客户端 `sound` 目录下的 WAV 文件，必须确保客户端存在该文件
2. **地图过滤**：
   - 地图ID `>= 0`：只对该地图上的玩家播放
   - 地图ID `< 0`：对所有在线玩家播放（不过滤）
3. **音效位置**：音效会以玩家当前坐标为播放位置发送给客户端
4. **常见音效编号**：不同编号对应不同音效类型，具体含义由客户端音效资源决定
5. **与 say 的区别**：`say` 是对话文本，`sendsound` 是纯音效播放，两者互不干扰

## 相关命令
- `say` — NPC 对话
- `showeffect` — 显示特效
- `sendnoticemsgformapuser` — 向地图所有用户发送通知
