# OnTurnOn

## 声明

```pascal
procedure OnTurnOn (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串 |

## 触发条件

动态对象执行 `IncStep` 使状态从关闭变为开启时触发。典型场景包括：炉火被火箭点燃、蜡台被点亮、机关被激活等。对象的 Step 值从 0 增加到 1 时触发此回调。

源码位置：`BasicObj.pas` 第 7399-7401 行

## 适用对象

- DynamicObject（动态对象）

## 示例

### 示例 1：火炉点燃后召唤 Boss（东天王火炉.txt）

检查条件后开启炉火，设置计时器准备召唤 Boss：

```pascal
procedure OnTurnOn (aStr : String);
var
   Str : String;
begin
   Str := callfunc ('checkobjectalive 东海沼泽 dynamicobject 被束缚的东天王');
   if Str = 'false' then begin
      exit;
   end;

   Str := callfunc ('checkobjectalive 东海沼泽 monster 东天王魂1');
   if Str = 'true' then begin
      exit;
   end;
   print ('changedynobjstate 被束缚的东天王 true');
   n := 1;
   boCall := 'true';
end;
```

### 示例 2：蜡台计数开启机关（蜡台.txt）

多个蜡台逐个点燃，全部点亮后检查怪物是否已清除，满足条件则开启机关门：

```pascal
procedure OnTurnOn (aStr : String);
var
   iCount, nCount : Integer;
   Str, nStr : String;
begin
   if n < 6 then begin
      inc (n);
   end;

   if n = 6 then begin
      Str := callfunc ('checkalivemopcount 31 monster 石棺赦龙组');
      iCount := StrToInt (Str);

      nStr := callfunc ('checkalivemopcount 31 monster 石棺青龙刺客');
      nCount := StrToInt (nStr);

      if iCount = 0 then begin
         if nCount = 0 then begin
            print ('changedynobjstate 机关区域门 true');
            print ('sendsound 9171.wav 31');
            exit;
         end;
      end;
   end;
end;
```

### 示例 3：火坛计数解锁 Boss 可攻击（火坛.txt）

4 个火坛全部点燃后，允许攻击 Boss 怪物：

```pascal
procedure OnTurnOn (aStr : String);
begin
   if n < 4 then begin
      inc (n);
   end;

   if n >= 4 then begin
      print ('setallowhitbyname 格섐무綾 monster true');
   end;
end;
```

### 示例 4：简单状态联动（火炉.txt）

点燃炉火后开启石棺洞入口：

```pascal
procedure OnTurnOn (aStr : String);
begin
   inc (n);
   print ('changedynobjstate 石棺洞入口 true');
end;
```

## 相关事件

- [OnTurnOff](OnTurnOff.md) — 关闭事件（与 OnTurnOn 成对）
- [OnBow](OnBow.md) — 远程攻击事件（火箭点燃炉火的触发源）
- [OnRegen](OnRegen.md) — 重生事件（重生后状态重置）
- [OnTimer](OnTimer.md) — 定时器事件（常配合 OnTurnOn 实现延时逻辑）
