# movespacebyname

## 功能描述
按名称传送对象到指定地图坐标。与 `movespace` 不同，此命令使用对象名称而非玩家名称进行定位，支持 NPC 和玩家两种类型。

## 语法格式
```pascal
print('movespacebyname <名称> <类型> <地图ID> <X坐标> <Y坐标>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 名称 | String | 对象名称（玩家名或NPC名） |
| 类型 | String | 对象类型：`user`（玩家）或 `npc`（NPC） |
| 地图ID | Integer | 目标地图编号 |
| X坐标 | Integer | 目标 X 坐标 |
| Y坐标 | Integer | 目标 Y 坐标 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'movespacebyname' then begin
//      TBasicObject (aSelf).SMoveSpaceByName (Params, Params [5], Params [6], _StrToInt (Params [7]));
// add by Orber at 2004-09-29 10:51
      TBasicObject (aSelf).SMoveSpaceByName (Params, Params [0], Params [1], 1);
```

注意原始代码中有一段被注释掉的旧实现。当前命令只把前五个参数打包为名称、类型、地图、X、Y，并以固定延迟 1 调用 `SMoveSpaceByName`；第五个参数之后的内容不会参与传送逻辑。

## 使用示例

### NPC 随机传送
```pascal
// 来自 彼岸花.txt - 将NPC随机传送到不同位置
rInt := Random(5);
if rInt = 0 then begin
   print ('movespacebyname 彼岸花 NPC 98 30 191');
end;
if rInt = 1 then begin
   print ('movespacebyname 彼岸花 NPC 98 93 266');
end;
if rInt = 2 then begin
   print ('movespacebyname 彼岸花 NPC 98 133 207');
end;
```

### 玩家传送到固定坐标
```pascal
// 将发送者传送到地图 1 的 (165, 775)
Name := callfunc ('getsendername');
Str := 'movespacebyname ' + Name + ' user 1 165 775';
print (Str);
```

部分旧脚本会在坐标后附加 NPC 名称、类型和数字；当前实现会忽略这些额外内容，不能据此实现“传送到指定 NPC”。

## 注意事项

1. **类型区分**：`user` 表示玩家，`npc` 表示 NPC，必须正确指定
2. **与 movespace 的区别**：`movespace` 直接按玩家名传送，`movespacebyname` 可以传送 NPC
3. **延迟参数**：当前实现中延迟固定为 1

## 相关命令
- `movespace` — 传送玩家到指定地图坐标
- `directmovespace` — 直接改变对象位置
