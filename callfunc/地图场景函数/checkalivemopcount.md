# checkalivemopcount

## 功能描述
检查指定地图中存活怪物的数量。

## 语法格式
```pascal
Str := callfunc('checkalivemopcount 地图编号 怪物类型 怪物名称');
```

## 参数说明
- **地图编号**：Integer - 要检查的地图ID
- **怪物类型**：String - 怪物类型（如 'monster', 'npc' 等）
- **怪物名称**：String - 要检查的具体怪物名称

## 返回值
- **成功**：返回存活怪物的数量（字符串格式的数字）
- **失败**：返回 '0' 或空字符串

## 源码实现
基于 `!UUser.pas` 中的 `SCheckAliveMopCount` 函数：

```pascal
function TUser.SCheckAliveMopCount (aMapIdx, aMopType, aMopName : String) : String;
var
   i : Integer;
   Count : Integer;
begin
   Result := '0';
   Count := 0;

   for i := 0 to MaxMonsterCount - 1 do begin
      if MonsterList [i] <> nil then begin
         if MonsterList [i]^.MapIdx = _StrToInt (aMapIdx) then begin
            if MonsterList [i]^.MopType = aMopType then begin
               if MonsterList [i]^.Name = aMopName then begin
                  if MonsterList [i]^.Alive then begin
                     Inc (Count);
                  end;
               end;
            end;
         end;
      end;
   end;

   Result := IntToStr (Count);
end;
```

## 使用示例

### 基础怪物数量检查
```pascal
// 检查地图93中魔人A的数量
monster_count := callfunc('checkalivemopcount 93 monster 魔人A');
count := StrToInt(monster_count);

if count > 0 then
    print('say 地图中还有 ' + monster_count + ' 只魔人A')
else
    print('say 地图中没有魔人A了');
```

### 任务进度检查
```pascal
// 检查任务怪物是否全部清除
monster_count := callfunc('checkalivemopcount 95 monster 石巨人A');
count := StrToInt(monster_count);

if count = 0 then begin
    print('say 恭喜！你已经清除了所有石巨人A');
    print('putsendermagicitem 任务奖励:1 @quest石巨人任务 4');
end else begin
    print('say 还有 ' + IntToStr(count) + ' 只石巨人A需要消灭');
end;
```

### 多种怪物检查
```pascal
// 检查多种怪物的存活情况
monsters := ['魔人A', '西域魔人A', '太古魔人A', '石巨人A'];
map_id := '93';

for i := 0 to Length(monsters) - 1 do begin
    count_str := callfunc('checkalivemopcount ' + map_id + ' monster ' + monsters[i]);
    count := StrToInt(count_str);
    if count > 0 then begin
        print('say ' + monsters[i] + ' 剩余：' + IntToStr(count) + ' 只');
    end;
end;
```

### 地图安全检查
```pascal
// 检查地图是否安全（没有怪物）
function IsMapSafe(map_id: String): Boolean;
var
    i: Integer;
    monster_types: array of String;
    count_str: String;
begin
    Result := True;
    monster_types := ['魔人A', '西域魔人A', '石巨人A', '冰雪巨人A2'];

    for i := 0 to Length(monster_types) - 1 do begin
        count_str := callfunc('checkalivemopcount ' + map_id + ' monster ' + monster_types[i]);
        if StrToInt(count_str) > 0 then begin
            Result := False;
            break;
        end;
    end;
end;

// 使用示例
if IsMapSafe('93') then
    print('say 地图93现在是安全的')
else
    print('say 地图93中还有危险怪物，请小心！');
```

### Boss检查
```pascal
// 检查Boss怪物状态
boss_count := callfunc('checkalivemopcount 96 monster 魔人B');
if boss_count = '1' then begin
    print('say Boss魔人B还活着，准备好战斗！');
end else if boss_count = '0' then begin
    print('say Boss已经被击败，可以领取奖励了');
end;
```

## 注意事项

1. **返回值类型**：返回字符串格式的数字，需要使用 `StrToInt()` 转换
2. **地图编号**：地图编号必须是有效的整数，否则可能返回错误结果
3. **怪物名称匹配**：怪物名称必须完全匹配，包括大小写
4. **存活状态**：只统计 `Alive = true` 的怪物
5. **性能考虑**：此函数会遍历所有怪物，频繁调用可能影响性能
6. **范围限制**：只能检查当前服务器实例中的怪物
7. **参数顺序**：严格按照地图编号、怪物类型、怪物名称的顺序传递参数

## 常见地图和怪物
根据游戏脚本中的使用示例：
- **地图93**: 魔人A、西域魔人A、太古魔人A、石巨人A、冰雪巨人A2、西域野人A2、银背巨猿A2、童子魔人A
- **地图95**: 类似93的怪物分布
- **地图96**: 魔人B（Boss怪物）

## 相关函数
- `checkentermap` - 检查是否可以进入地图
- `getremainmaptime` - 获取地图剩余时间
- `getsenderposition` - 获取玩家当前位置