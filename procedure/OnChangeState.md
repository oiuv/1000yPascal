# OnChangeState

## 声明

```pascal
procedure OnChangeState (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 状态字符串：`'normal'`（正常）或 `'die'`（死亡） |

## 触发条件

NPC/Monster 收到 `FM_CHANGEFEATURE` 消息时触发，即视野内对象状态发生变化时（如从正常变为死亡）。当 NPC/Monster 的 Feature 状态改变时，会通知视野范围内所有具有 `DYNOBJ_EVENT_CHANGESTATE` 标记的对象。

源码位置：`uNpc.pas` 第 519-521 行

## 适用对象

- NPC
- Monster

## 示例

### 示例 1：比武 NPC 死亡状态处理（3级黑捕校.txt）

当 NPC 死亡时，检测触发者是否为玩家，发送提示并将玩家移出比武场：

```pascal
procedure OnChangeState (aStr : String);
var
   Str, Name : String;
begin
   if aStr <> 'die' then exit;

   Str := callfunc ('getsenderrace');
   if Str <> '1' then exit;

   print ('say 别想蒙混过关,我很严厉的.');
   print ('say 很遗憾.等下次吧.. 300');

   Name := callfunc ('getsendername');
   Str := 'movespace ' + Name;
   Str := Str + ' user 1 305 371 600';
   print (Str);
end;
```

### 示例 2：配合 OnDie 使用（比武类脚本通用模式）

OnChangeState 在状态变化时触发（可用于检测死亡），OnDie 在确认死亡后触发。两者配合实现完整的死亡处理流程：

```pascal
procedure OnDie (aStr : String);
begin
   // 死亡确认后的处理：升级、传送等
   print ('usemagicgradeup 1 2');
end;

procedure OnChangeState (aStr : String);
begin
   // 状态变为死亡时的即时响应
   if aStr <> 'die' then exit;
   print ('say 别想蒙混过关,我很严厉的.');
end;
```

## 相关事件

- [OnDie](OnDie.md) — 死亡事件（OnChangeState 的 'die' 状态与之关联）
- [OnCreate](OnCreate.md) — 创建事件
- [OnRegen](OnRegen.md) — 重生事件
