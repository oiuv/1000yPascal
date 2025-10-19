# gotoxy

## 功能描述
将玩家传送到指定的地图坐标位置。

## 语法格式
```pascal
print('gotoxy X坐标 Y坐标');
```

## 参数说明
- **X坐标**：Integer - 目标位置的X坐标
- **Y坐标**：Integer - 目标位置的Y坐标

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'gotoxy' then begin
   TBasicObject (aSender).SGoToXY (_StrToInt (Params [0]), _StrToInt (Params [1]));
```

## 使用示例

### 基础传送
```pascal
// 传送到指定坐标
print('gotoxy 100 200');

// 传送到地图中心
print('gotoxy 500 400');
```

### 条件传送
```pascal
// 根据玩家等级传送到不同区域
level_str := callfunc('getsenderage');
level := StrToInt(level_str);

if level < 1000 then begin
    print('gotoxy 100 100');  // 新手区域
    print('say 欢迎来到新手村！');
end else if level < 5000 then begin
    print('gotoxy 300 300');  // 中级区域
    print('say 你已进入中级区域');
end else begin
    print('gotoxy 500 500');  // 高级区域
    print('say 欢迎来到高级区域');
end;
```

### 任务传送
```pascal
// 传送任务目标地点
quest_status := callfunc('getsenderqueststr');

if quest_status = 'talk_to_king' then begin
    print('gotoxy 800 600');  // 皇宫位置
    print('say 你已传送到皇宫，去见国王吧');
end else if quest_status = 'kill_dragon' then begin
    print('gotoxy 1200 800');  // 龙穴位置
    print('say 小心！这里是龙的巢穴');
end;
```

### 安全传送
```pascal
// 检查传送位置是否安全后再传送
function SafeTeleport(x, y: Integer): Boolean;
begin
    // 这里可以添加安全检查逻辑
    // 比如检查目标位置是否有怪物、是否可以行走等
    Result := True;  // 简化示例
end;

if SafeTeleport(200, 300) then begin
    print('gotoxy 200 300');
    print('say 传送成功！');
end else begin
    print('say 目标位置不安全，传送失败');
end;
```

### 随机传送
```pascal
// 在安全区域内随机传送
random_x := 100 + Random(50);  // 100-150之间
random_y := 100 + Random(50);  // 100-150之间

print('gotoxy ' + IntToStr(random_x) + ' ' + IntToStr(random_y));
print('say 随机传送完成！');
```

### 组队传送
```pascal
// 传送整个队伍到指定位置
party_info := callfunc('getparty');
if party_info <> '' then begin
    // 传送队长
    print('gotoxy 600 700');
    print('say 队长已传送，队员跟随传送');

    // 这里可能需要额外的逻辑来传送队员
    // 具体实现取决于游戏的组队系统
end;
```

### 特殊区域传送
```pascal
// 传送到特殊功能区域
// 传送至银行
print('gotoxy 400 300');
print('say 你已到达银行');

// 传送至商店
print('gotoxy 350 250');
print('say 欢迎光临商店');

// 传送至练功房
print('gotoxy 450 350');
print('say 这里是练功房');
```

## 注意事项

1. **坐标有效性**：坐标必须在当前地图的有效范围内
2. **地图边界**：传送到地图边界外可能导致玩家卡住
3. **障碍物检查**：传送不会自动检查障碍物，可能传送到墙内或其他不可达位置
4. **安全检查**：重要传送前应先检查目标位置的安全性
5. **权限限制**：某些区域可能需要特殊权限才能进入
6. **冷却时间**：频繁传送可能有冷却时间限制
7. **状态影响**：传送可能会中断某些状态（如战斗状态）

## 常用坐标参考
根据游戏地图设计，常见的功能区域坐标：
- **新手村**: (100, 100) 附近
- **主城**: (500, 400) 附近
- **银行**: (400, 300)
- **商店**: (350, 250)
- **练功房**: (450, 350)
- **皇宫**: (800, 600)

## 相关命令
- `reposition` - 重新定位（可能是更安全的传送方式）
- `mapregen` - 地图重生
- `boMapEnter` - 地图进入处理