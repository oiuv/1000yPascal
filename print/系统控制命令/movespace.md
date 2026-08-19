# movespace

## 功能描述
传送玩家到指定地图坐标。支持延迟执行（通过 tick 参数控制延迟毫秒数）。

## 语法格式
```pascal
print('movespace <玩家名> user <地图ID> <X坐标> <Y坐标> <延迟毫秒>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 玩家名 | String | 要传送的玩家名称 |
| user | String | 目标类型，固定为 `user` |
| 地图ID | Integer | 目标地图编号 |
| X坐标 | Integer | 目标 X 坐标 |
| Y坐标 | Integer | 目标 Y 坐标 |
| 延迟毫秒 | Integer | 延迟执行的毫秒数（0 为立即执行） |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'movespace' then begin
   TBasicObject (aSelf).PushCommand (CMD_MOVESPACE, Params, _StrToInt (Params [5]));
```

通过 `PushCommand` 将传送命令放入命令队列，延迟时间由 `Params[5]`（第6个参数）决定。

## 使用示例

### 基础传送
```pascal
// 将玩家传送到地图49的坐标(106, 55)，延迟100毫秒
Name := callfunc ('getsendername');
Str := 'movespace ' + Name;
Str := Str + ' user 49 106 55 100';
print (Str);
```

### 考试失败后传送回出发点
```pascal
// 来自 一级捕盗大将.txt
print ('say 回去再修炼个10年吧 50');
print ('say 到那时我再用双手跟你打 400');

Name := callfunc ('getsendername');
Str := 'movespace ' + Name;
Str := Str + ' user 49 106 55 600';
print (Str);
```

### 考试成功后传送到下一关
```pascal
// 来自 捕盗大将.txt - 传送玩家进入考试地图
print ('mapregen 78');
print ('getsenderitem 金元:60');

Name := callfunc ('getsendername');
Str := 'movespace ' + Name;
Str := Str + ' user 78 15 21';
print (Str);
print ('boMapEnter 78 false');
```

### 禁止开镜时传送离开
```pascal
// 来自 2级牛俊.txt - 检测到开镜后传送玩家离开
Str := callfunc ('getsendercurpowerlevelname');
if Str <> '' then begin
   print ('say 禁止开镜进入');
   Name := callfunc ('getsendername');
   Str := 'movespace ' + Name;
   Str := Str + ' user 1 789 531 100';
   print (Str);
   exit;
end;
```

## 注意事项

1. **玩家名必须正确**：通常通过 `getsendername` 获取当前交互玩家名称
2. **延迟参数**：最后一个参数为延迟毫秒数，用于在对话等操作后再传送
3. **地图进入控制**：传送后通常需要配合 `boMapEnter` 控制地图进入权限
4. **坐标有效性**：目标坐标必须是地图上的可到达位置

## 相关命令
- `movespacebyname` — 按名称传送玩家
- `directmovespace` — 直接改变对象位置
- `boMapEnter` — 地图进入检查
- `mapregen` — 刷新地图
