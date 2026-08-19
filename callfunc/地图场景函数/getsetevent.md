# getsetevent

## 功能描述
获取并切换触发者（玩家）的事件状态值。该函数会读取当前事件状态，然后将其取反（0→1，1→0），返回切换后的新值。

## 语法格式
```pascal
Str := callfunc('getsetevent 事件编号');
```

## 参数说明
- **事件编号**：Integer - 事件代码，范围 0-19。超出范围返回 '0'

## 返回值
- **切换后为已触发**：返回 '1'（原值为 0，切换为 1）
- **切换后为未触发**：返回 '0'（原值为 1，切换为 0）
- **参数越界**：返回 '0'（EventCode > 19 或 < 0 时）

## 源码实现
基于 `UUser.pas` 中的 `SGetSetEvent` 函数：

```pascal
function TUser.SGetSetEvent(EventCode: Integer): String;
var aEventResult: Byte;
begin
    if (EventCode > 20 - 1) or (EventCode < 0) then begin
        result := '0';
        Exit;
    end;
    aEventResult := aEventRecord[EventCode];
    if aEventResult = 1 then begin
        Result := '0';
    end;
    if aEventResult = 0 then begin
        aEventRecord[EventCode] := 1;
        Result := '1';
    end;
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getsetevent' then begin
   Result := TBasicObject(FSender).SGetSetEvent(StrToIntDef(Params[0], 0));
```

## 使用示例

### 设置任务完成标记（来自一级老板娘脚本）
```pascal
// 先检查事件是否已触发
Str := callfunc('getevent 2');
FirstQuest := StrToInt(Str);
if FirstQuest <> 0 then begin
   print('say 我们似乎在哪儿见过...');
   Exit;
end;

// 检查物品条件
Name := callfunc('getsenderitemexistence 红彼岸花:1');
if Name = 'false' then begin
   print('say 年轻人,你还没出发么?');
   exit;
end;

// 给予奖励并设置事件标记
print('getsenderitem 红彼岸花:1');
print('getsenderitem 蓝彼岸花:1');
print('putsendermagicitem 疾速靴:2 @老板娘 4');
Str := callfunc('getsetevent 2');
print('say 你的勇敢和真诚让我感动和钦佩!');
```

### 任务奖励发放后标记（来自犀牛猎人脚本）
```pascal
// 检查事件状态
Str := callfunc('getevent 0');
FirstQuest := StrToInt(Str);

if FirstQuest = 0 then begin
   // 首次完成，给予奖励
   print('putsendermagicitem 九转金丹:1 @犀牛猎人 4');
   // 设置事件标记，防止重复领取
   Str := callfunc('getsetevent 0');
end;
```

### 剧情事件触发（来自萧郎脚本）
```pascal
// 检查事件1
Str := callfunc('getevent 1');
FirstQuest := StrToInt(Str);
if FirstQuest <> 0 then begin
   print('say 我们似乎在哪儿见过...');
   Exit;
end;

// ... 任务逻辑 ...

// 设置事件标记
Str := callfunc('getsetevent 1');
```

## 注意事项

1. **返回值类型**：返回字符串 '0' 或 '1'
2. **切换行为**：该函数会修改玩家的事件状态，0→1 并返回 '1'，1→0 并返回 '0'
3. **事件编号范围**：有效范围 0-19，共 20 个事件位
4. **越界处理**：EventCode 超出范围时返回 '0'，不修改任何状态
5. **FSender 上下文**：操作的是触发者（玩家）的事件记录
6. **典型用法**：先 `getevent` 检查是否已完成，再 `getsetevent` 标记为已完成
7. **持久化**：事件状态保存在玩家数据中

## 相关函数
- `getevent` - 获取事件状态值（只读）
- `getsenderfirstquest` - 获取触发者首次任务状态
