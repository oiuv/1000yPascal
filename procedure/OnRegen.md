# OnRegen

## 声明

```pascal
procedure OnRegen (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串 |

## 触发条件

Monster/NPC 重新生成（Regen）后触发。当对象被 `regen` 命令重新生成，或地图刷新导致对象重新出现时调用此回调。

源码位置：`BasicObj.pas` 第 7074-7076 行

## 适用对象

- DynamicObject（动态对象）
- Monster
- NPC

## 示例

### 示例 1：重生时重置计数器（狐狸火.txt）

炉火对象重生时将灯光计数归零：

```pascal
var
   LightCount : Integer = 0;

procedure OnRegen (aStr : String);
begin
   LightCount := 0;
end;
```

### 示例 2：重生时联动刷新其他对象（雪上天蚕.txt）

天蚕重生时，联动刷新关联的三个动态对象：

```pascal
procedure OnRegen (aStr : String);
begin
   print ('regen 笃네아犬 dynamicobject');
   print ('regen 괵팎아犬 dynamicobject');
   print ('regen 든아犬 dynamicobject');
end;
```

### 示例 3：重生时递减计数（钥匙酒坛.txt）

酒坛重生时递减计数器，配合 OnTurnOn 实现多轮机关逻辑：

```pascal
var
   n : Integer = 0;

procedure OnRegen (aStr : String);
begin
   if n > 0 then begin
      Dec (n);
   end;
end;

procedure OnTurnOn (aStr : String);
begin
   inc (n);
   if n >= 5 then begin
      print ('changedynobjstate 铁闸门1 true');
      print ('changedynobjstate 铁闸门2 true');
      print ('changedynobjstate 铁闸门3 true');
      n := 0;
      exit;
   end;
end;
```

### 示例 4：机关门重生重置（机关区域门.txt / 铁闸门.txt）

```pascal
procedure OnRegen (aStr : String);
begin
   // 重生后重置状态，通常用于清空变量
end;
```

## 相关事件

- [OnTurnOn](OnTurnOn.md) / [OnTurnOff](OnTurnOff.md) — 开关状态事件（常与 OnRegen 配合管理机关计数）
- [OnChangeState](OnChangeState.md) — 状态变化事件
- [OnTimer](OnTimer.md) — 定时器事件
