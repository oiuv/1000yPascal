# startmissiontime

## 功能描述
开始玩家的任务计时，记录任务开始时间。

## 语法格式
```pascal
Str := callfunc('startmissiontime');
```

## 参数说明
- 无参数

## 返回值
- **整数（字符串）**：计时开始的标记值（取整后的值）

## 源码实现
```pascal
// uScriptManager.pas 第572行
end else if cmd = 'startmissiontime' then begin
   Result := IntToStr(Trunc(TBasicObject (FSender).SStartMissionTime));
```

调用 `TBasicObject.SStartMissionTime`，记录任务开始时间，返回取整后的值转为字符串。

## 使用示例

### 萧郎任务 - 开始计时
```pascal
// 检查背包空间
Name := callfunc ('checkenoughspace');
if Name = 'false' then begin
    print ('say 物品栏已满');
    exit;
end;

// 给予任务物品并开始计时
print ('putsendermagicitem 血红色的玛瑙石:1 @萧郎 4');
print ('getsenderitem 血石:249');
Name := callfunc ('startmissiontime');
print ('say 这是一颗珍贵的"血红色的玛瑙石" 100');
print ('say 我想拜托你把它交给我的素莲手中，你不要辜负我的希望！ 200');
```
> 来源：`萧郎.txt`

### 完整的限时任务流程
```pascal
// 1. 开始计时（NPC给予任务物品时）
Name := callfunc ('startmissiontime');

// 2. 后续检查已过时间（交付NPC处）
Str := callfunc ('getpassmissiontime');
nValue := StrToInt (Str);
if nValue > 30 then begin
    // 超过30分钟，任务失败
    print ('say 你超时了！');
    exit;
end;
// 30分钟内完成，任务成功
print ('say 任务完成！');
```

## 注意事项

1. **返回值格式**：返回字符串类型的整数
2. **配合 getpassmissiontime 使用**：先通过 `startmissiontime` 开始计时，再用 `getpassmissiontime` 查询已过时间
3. **限时任务**：用于限时任务场景，如护送、传递物品等
4. **取整处理**：源码中使用 `Trunc` 对浮点数取整
5. **无参数**：不需要传入任何参数

## 相关函数
- `getpassmissiontime` - 获取任务通过时间
