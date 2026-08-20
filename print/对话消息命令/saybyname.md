# saybyname

## 功能描述
让指定名称的 NPC、Monster 或 User 说话，显示对话内容。与 `say` 命令不同，`say` 只能让当前脚本绑定的对象说话，而 `saybyname` 可以指定地图上任意对象说话。

## 语法格式
```pascal
print('saybyname 对象名 对象类型 对话内容 延迟时间');
```

## 参数说明
| 参数 | 说明 |
|------|------|
| 对象名 | String - 要让其说话的对象名称（NPC名、Monster名或玩家名） |
| 对象类型 | String - 对象类型：`npc`（NPC）、`monster`（怪物）、`user`（玩家） |
| 对话内容 | String - 要显示的对话文本，文本中的空格需要用下划线 `_` 代替 |
| 延迟时间 | Integer - 相对 `mmAnsTick` 的队列间隔；正常倍率下 100 约为 1 秒 |

## 说明
该命令通过名称查找地图上的对象，找到后让该对象执行说话动作（PushCommand CMD_SAY）。

**对象类型说明：**
- `npc` — 在 NPC 列表中按名称查找
- `monster` — 在 Monster 列表中按名称查找
- `user` — 在在线玩家列表中按名称查找

如果找不到指定名称的对象，命令会静默失败，不会报错。

**源码实现（uScriptManager.pas）：**
```pascal
end else if Cmd = 'saybyname' then begin
   Str := ChangeScriptString (Params [2], '_', ' ');
   TBasicObject (aSelf).SSayByName (Params [0], Params[1], Str, _StrToInt (Params [3]));
end;
```

**底层实现（BasicObj.pas）：**
```pascal
procedure TBasicObject.SSayByName(aName, aRace, aSay: string; aInterval: Integer);
var
   BO: TBasicObject;
begin
   BO := nil;
   if UpperCase(aRace) = 'MONSTER' then
      BO := TMonsterList(Manager.MonsterList).GetMonsterByName(aName, true);
   if UpperCase(aRace) = 'NPC' then
      BO := TNpcList(Manager.NpcList).GetNpcByName(aName, true);
   if UpperCase(aRace) = 'USER' then
      BO := UserList.GetUserPointer(aName);
   if BO <> nil then
      BO.PushCommand(CMD_SAY, aSay, aInterval);
end;
```

## 示例

### 太极公子任务对话（太极公子.txt）
```pascal
print ('saybyname 密室太极老人 npc 请帮我们找回100');
print ('saybyname 密室太极老人 npc 门主留下的太极书札 300');
print ('saybyname 密室太极老人 npc 从<黄金沙漠> 500');
print ('saybyname 密室太极老人 npc 毫无音信~ 700');
print ('saybyname 密室太极老人 npc 担心<青龙帮> 900');
print ('saybyname 密室太极老人 npc 会威胁到本门, 1100');
print ('saybyname 密室太极老人 npc 所以太极公子必须修炼 1300');
```

### 太极老人任务完成对话（太极老人.txt）
```pascal
print ('saybyname 太极老人 npc 不胜感激... 100');
print ('saybyname 太极老人 npc 托你的福_我门的武功密笈 300');
print ('saybyname 太极老人 npc 竟安然无恙... 500');
print ('saybyname 太极老人 npc 如果太极公子来修炼的话, 700');
print ('saybyname 太极老人 npc 门主到来前 900');
print ('saybyname 太极老人 npc 败落的剑门 1100');
print ('saybyname 太极老人 npc 一定能够重建! 1300');
```

## 注意事项

1. **对象必须存在**：指定的对象必须在当前地图上存在，否则命令无效
2. **空格处理**：对话内容中的空格必须用下划线 `_` 代替
3. **延迟时间**：多条对话之间通过递增延迟时间实现依次显示效果（如 100, 300, 500, 700...）
4. **对象类型区分大小写不敏感**：`npc`、`NPC`、`Npc` 均可
5. **与 say 的区别**：`say` 让脚本绑定对象说话，`saybyname` 可让任意指定对象说话
6. **单位不是毫秒**：默认 1 tick 约 10 ms，测试加速倍率会改变实际墙钟时间

## 相关命令
- `say` — 让当前对象说话
- `sendsenderchatmessage` — 发送聊天消息给玩家
- `sendsendertopmsg` — 发送顶部公告
