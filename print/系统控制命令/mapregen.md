# mapregen

## 功能描述
重新生成当前地图，通常用于重置怪物、物品等地图元素。

## 语法格式
```pascal
print('mapregen');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'mapregen' then begin
   TBasicObject (aSender).SMapRegen;
```

## 使用示例

### 基础地图重置
```pascal
// 重置当前地图
print('mapregen');
print('say 地图已重置');
```

### 任务完成后的地图重置
```pascal
// 检查任务完成后重置地图
quest_status := callfunc('getsendercurrentquest');
if quest_status = 'completed' then begin
    print('say 任务完成，地图即将重置...');
    print('mapregen');
    print('say 地图重置完成，新的挑战开始了！');
end;
```

### 副本地图重置
```pascal
// 副本重置逻辑
function ResetDungeon: Boolean;
var
    player_count: Integer;
begin
    player_count := StrToInt(callfunc('getusercount'));

    // 检查是否只有当前玩家在副本中
    if player_count = 1 then begin
        print('say 副本即将重置...');
        print('mapregen');
        Result := True;
    end else begin
        print('say 副本中还有其他玩家，无法重置');
        Result := False;
    end;
end;

// 调用副本重置
if ResetDungeon() then begin
    print('say 副本重置成功');
end;
```

### Boss战斗后重置
```pascal
// Boss被击败后重置地图
boss_count := callfunc('checkalivemopcount 96 monster 魔人B');
if boss_count = '0' then begin
    print('say 恭喜！你们击败了Boss！');
    print('say 地图将在30秒后重置...');

    // 这里可以添加延时重置的逻辑
    // 或者通过其他方式触发重置

    print('mapregen');
    print('say 地图已重置，Boss重新刷新');
end;
```

### 定时重置
```pascal
// 根据时间重置地图
// 这可能需要与外部时间系统配合
current_hour := GetCurrentHour(); // 假设有获取当前时间的函数

if current_hour = 0 then begin  // 零点重置
    print('say 每日地图重置开始...');
    print('mapregen');
    print('say 每日地图重置完成');
end;
```

### 事件重置
```pascal
// 特殊事件触发地图重置
event_status := callfunc('getevent');
if event_status = 'boss_spawn' then begin
    print('say 特殊事件：Boss刷新');
    print('mapregen');
    print('say 地图已重置，Boss已刷新到新位置');
end;
```

### 条件重置
```pascal
// 满足特定条件时重置地图
player_level := StrToInt(callfunc('getsenderage'));
if player_level >= 1000 then begin
    // 高级玩家可以请求重置地图
    print('say 地图重置请求已受理...');
    print('mapregen');
    print('say 地图重置完成，怪物已刷新');
end else begin
    print('say 你的等级不足，无法重置地图');
end;
```

## 注意事项

1. **玩家影响**：地图重置会影响地图中的所有玩家，使用时需要谨慎
2. **怪物重置**：所有怪物会重新生成到初始位置
3. **物品重置**：地面物品会清空，宝箱等会重新刷新
4. **玩家位置**：玩家的位置通常不会改变，但周围环境会重置
5. **状态影响**：玩家在地图上的某些状态可能会被重置
6. **性能影响**：地图重置是一个耗时的操作，频繁使用可能影响服务器性能
7. **权限检查**：普通玩家通常无法直接使用此命令，主要用于GM或系统脚本
8. **副本使用**：在副本地图中使用比较安全，因为只影响副本内的玩家

## 使用场景

- **副本重置**：完成副本后重新生成怪物和宝箱
- **Boss刷新**：Boss被击败后重新刷新
- **活动重置**：特殊活动地图的重置
- **维护操作**：GM进行地图维护时使用
- **错误修复**：地图出现异常时进行重置

## 相关命令
- `reposition` - 重新定位玩家
- `gotoxy` - 传送到指定坐标
- `boMapEnter` - 地图进入处理