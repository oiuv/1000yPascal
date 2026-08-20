# commandicebyname

## 功能描述
按名称设置 NPC、怪物或玩家的冻结 tick，常用于考试/比武场景中暂停移动与战斗流程。

## 语法格式
```pascal
print('commandicebyname <名称> <类型> <冻结tick>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 名称 | String | 要冻结的对象名称（玩家名或NPC/怪物名） |
| 类型 | String | 对象类型：`user`（玩家）、`npc`（NPC）或 `monster`（怪物） |
| 冻结 tick | Integer | 正常倍率下 1 tick 约 10 ms |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'commandicebyname' then begin
   TBasicObject (aSelf).SCommandIceByName (Params [0], Params [1], _StrToInt (Params [2]));
```

按名称取得一个对象后调用其 `SCommandIce`。NPC、Monster、User 都走生命对象覆盖；找不到对象时静默返回。

## 使用示例

### 冻结NPC考官
```pascal
// 来自 2级牛俊.txt - 正常倍率下冻结考官约 5 秒
print ('directmovespace 晋级2牛俊 npc 86 20 21');
print ('commandicebyname 晋级2牛俊 npc 500');
print ('setallowhitbytick true 500');
```

### 冻结玩家
```pascal
// 来自 2级牛俊.txt - 正常倍率下冻结玩家约 5 秒
Name := callfunc ('getsendername');
Str := 'commandicebyname ' + Name;
Str := Str + ' user 500';
print (Str);
```

### 冻结NPC和玩家（比武场景）
```pascal
// 来自 密室太极老人.txt - 正常倍率下同时冻结怪物和玩家约 15 秒
print ('directmovespace 太极公子 monster 32 17 18 0');
print ('commandicebyname 太极公子 monster 1500');

Name := callfunc ('getsendername');
Str := 'commandicebyname ' + Name;
Str := Str + ' user 1500';
print (Str);

print ('say 来这儿不易呀_ 果然是名副其实的侠客 200');
print ('say 看样子是来向太极公子挑战的？ 400');
print ('say 那么_比武正式开始_ 600');
print ('say 开始 800');
```

### 三级考试场景
```pascal
// 来自 3级黑捕校.txt
Str := 'commandicebyname ' + Name;
Str := Str + ' npc 500';
print (Str);
```

## 注意事项

1. **对象类型**：支持 `user`（玩家）、`npc`（NPC）和 `monster`（怪物）
2. **配合使用**：通常与 `setallowhitbytick` 配合，冻结时间等于延迟开放攻击的时间
3. **冻结范围**：当前移动和 AI 路径会检查冻结计时；不要把它扩展解释为服务端所有消息与脚本事件都被暂停
4. **单位与重入**：参数不是毫秒；对象已经有非零冻结计时时，再次设置不会延长

## 相关命令
- `commandice` — 冻结自身
- `boiceallbyname` — 设置所有目标是否冻结
- `setallowhitbytick` — 定时设置允许攻击
