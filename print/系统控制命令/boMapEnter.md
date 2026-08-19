# boMapEnter

## 功能描述
设置地图是否允许进入。用于控制副本/考试地图的进入权限，防止其他玩家在考试期间进入。

## 语法格式
```pascal
print('boMapEnter <地图ID> <允许进入>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 地图ID | Integer | 要控制的地图编号 |
| 允许进入 | String | `true` 表示允许进入，`false` 表示禁止进入 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'boMapEnter' then begin                  // 맵에 들어갈수 있는지 없는지 03.05.06 saset
   TBasicObject (aSender).SboMapEnter (_StrToInt (Params [0]), Params [1]);
```

作用于 `aSender`（触发脚本的玩家），传入地图ID和允许状态。

## 使用示例

### 进入考试地图后禁止其他人进入
```pascal
// 来自 捕盗大将.txt - 玩家进入考试地图后关闭入口
print ('mapregen 78');
print ('getsenderitem 金元:60');

Name := callfunc ('getsendername');
Str := 'movespace ' + Name;
Str := Str + ' user 78 15 21';
print (Str);
print ('boMapEnter 78 false');
```

### 考试结束后开放地图
```pascal
// 来自 一级捕盗大将.txt - 考生死亡后开放地图
procedure OnChangeState (aStr : String);
begin
   if aStr <> 'die' then exit;
   // ...
   print ('boMapEnter 50 true');
end;
```

### 禁止进入特定地图
```pascal
// 来自 天王僧侣.txt
print ('boMapEnter 95 false');

// 来自 太极公子.txt
print ('boMapEnter 32 true');
```

### 王陵禁区进入控制
```pascal
// 来自 上古雨中客.txt - 进入王陵禁区后禁止其他人进入
print ('say 小子_明年的今天就是你的忌日');
print ('mapregen 76');
print ('getsenderitem 王陵守护印:1');

Name := callfunc ('getsendername');
Str := 'movespace ' + Name;
Str := Str + ' user 76 14 21';
print (Str);
print ('boMapEnter 76 false');
```

## 注意事项

1. **作用于玩家**：此命令通过 `aSender`（玩家）执行，控制的是玩家相关地图的进入权限
2. **副本控制**：主要用于副本/考试地图，防止其他玩家在考试期间进入
3. **配合 movespace**：通常先传送玩家进入地图，再禁止其他人进入
4. **记得恢复**：考试/副本结束后需要重新设为 `true` 开放地图

## 相关命令
- `movespace` — 传送玩家到指定地图坐标
- `mapregen` — 刷新地图
- `bopickbymapname` — 地图挖掘检查
