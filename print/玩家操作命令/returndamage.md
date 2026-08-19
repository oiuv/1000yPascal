# returndamage

## 功能描述
反弹伤害给玩家。根据指定的最大伤害值和百分比速率，按玩家最大生命值的比例扣除生命值。

## 语法格式
```pascal
print('returndamage 伤害值 百分比');
```

## 参数说明
- **伤害值**：Integer - 反弹的基础伤害值（通常来自 OnHit 事件的 aStr 参数）
- **百分比**：Integer - 伤害扣除百分比（按玩家最大生命值的百分比计算）

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'returndamage' then begin
   TBAsicObject (aSelf).SReturnDamage (aSender, _StrToInt (Params [0]), _StrToInt (Params [1]));
```

`SReturnDamage` 实现在 `BasicObj.pas` 中：

```pascal
procedure TBasicObject.SReturnDamage(aBo: TBasicObject; aMaxDamage, aDecRate: Integer);
var
   Damage, MaxLife, reDamage: Integer;
begin
   if aBo.BasicData.Feature.rrace <> RACE_HUMAN then
      exit;

   MaxLife := TUser(aBO).SGetMaxLife;

   reDamage := (aMaxDamage * aDecRate) div 100;
   Damage := (reDamage * 100) div MaxLife;
   TUser(aBO).CommandDecLifePercent(Damage);
end;
```

伤害计算公式：
1. `reDamage = (伤害值 × 百分比) / 100`
2. `Damage = (reDamage × 100) / 玩家最大生命值`
3. 按 `Damage` 百分比扣除玩家生命值

## 使用示例

### 石大王脚本（真实示例）
来自 `bin/Script/石大王.txt`：

```pascal
procedure OnHit (aStr : String);
var
   Str : String;
   Damage, n : Integer;
begin
   Str := callfunc ('getsenderrace');
   if Str <> '1' then exit;

   print ('reposition');

   Str := 'returndamage ' + aStr;
   Str := Str + ' 20';
   print (Str);
end;
```

石大王被攻击时，将攻击伤害（aStr）按 20% 的比例反弹给玩家。例如玩家攻击伤害为 1000，则反弹伤害为 `(1000 × 20) / 100 = 200`，再按玩家最大生命值百分比扣除。

## 注意事项

1. **仅对玩家有效**：如果 aSender 不是人类种族（RACE_HUMAN），命令不执行
2. **百分比扣血**：最终伤害按玩家最大生命值的百分比扣除，对高血量玩家影响更大
3. **常与 reposition 配合**：典型用法是先 reposition 弹开玩家，再 returndamage 反弹伤害
4. **伤害值来源**：通常在 OnHit 事件中使用，aStr 参数为本次攻击的实际伤害值

## 相关命令
- `reposition` - 重新定位玩家（弹开）
- `attack` - 攻击目标
