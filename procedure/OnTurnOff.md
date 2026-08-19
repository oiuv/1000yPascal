# OnTurnOff

## 声明

```pascal
procedure OnTurnOff (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串 |

## 触发条件

动态对象执行 `DecStep` 使状态从开启变为关闭时触发。典型场景包括：炉火熄灭、蜡台被扑灭、机关被关闭等。对象的 Step 值从 1 减少到 0 时触发此回调。

源码位置：`BasicObj.pas` 第 7423-7425 行

## 适用对象

- DynamicObject（动态对象）

## 示例

### 示例 1：炉火熄灭后清除 Boss（东天王火炉.txt）

炉火熄灭时检查并删除已召唤的 Boss 和护卫怪物：

```pascal
procedure OnTurnOff (aStr : String);
var
   Str : String;
begin
   Str := callfunc ('checkobjectalive 东海沼泽 monster 东天王魂1');
   if Str = 'true' then begin
      print ('mapdelobjbyname monster 东天王魂1');
   end;

   Str := callfunc ('checkobjectalive 东海沼泽 monster 远距离野神族3');
   if Str = 'true' then begin
      print ('mapdelobjbyname monster 远距离野神族3');
   end;
   exit;
end;
```

### 示例 2：蜡台熄灭递减计数（蜡台.txt）

蜡台熄灭时递减计数器，与 OnTurnOn 的递增逻辑对称：

```pascal
procedure OnTurnOff (aStr : String);
begin
   if n > 0 then begin
      Dec (n);
   end;
end;
```

### 示例 3：火坛熄灭后禁止攻击 Boss（火坛.txt）

点燃数量不足 4 时，禁止玩家攻击 Boss 怪物：

```pascal
procedure OnTurnOff (aStr : String);
begin
   if n > 0 then begin
      dec (n);
   end;

   if n < 4 then begin
      print ('setallowhitbyname 格섐무綾 monster false');
   end;
end;
```

### 示例 4：简单状态联动（火炉.txt）

炉火熄灭后关闭石棺洞入口：

```pascal
procedure OnTurnOff (aStr : String);
begin
   dec (n);
   print ('changedynobjstate 石棺洞入口 false');
end;
```

## 相关事件

- [OnTurnOn](OnTurnOn.md) — 开启事件（与 OnTurnOff 成对）
- [OnBow](OnBow.md) — 远程攻击事件（灭火的触发源之一）
- [OnRegen](OnRegen.md) — 重生事件（重生后状态重置）
