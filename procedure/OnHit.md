# OnHit

## 声明

```pascal
procedure OnHit (aStr : String);
```

对象被有效命中时触发，`Self` 是受击对象，`Sender` 是攻击者。参数不是所有对象都相同：

- `TDynamicObject` 的掌风和普通命中路径传入空字符串。
- 使用 `uSkills.pas` 战斗处理的生命对象会传入十进制字符串 `damageExp`；`石大王.txt` 的反伤逻辑依赖这个值。

因此，只有确认目标对象走生命对象调用路径时，才能把 `aStr` 当作伤害数值。事件返回值不参与命中判定；需要阻止攻击应使用 [OnDanger](../function/OnDanger.md)。

## 示例

云端神武版与炎黄随包的 `东海名所2.txt` 都在首次命中时召唤四只怪物：

```pascal
procedure OnHit (aStr : String);
begin
   Inc (n);
   if n > 1 then exit;

   print ('mapaddobjbyname monster 远距离野神族2 129 317 2 0 false');
   print ('mapaddobjbyname monster 远距离野神族2 132 322 2 0 false');
   print ('mapaddobjbyname monster 远距离野神族2 137 323 2 0 false');
   print ('mapaddobjbyname monster 远距离野神族2 142 321 2 0 false');
end;
```

另见 `霸王石.txt` 的生命值阶段切换和 `石大王.txt` 的反伤逻辑。

源码依据：`BasicObj.pas` 的动态对象命中分支、`uSkills.pas` 的生命对象命中分支。

## 相关事件

- [OnDanger](../function/OnDanger.md)
- [OnDieBefore](OnDieBefore.md)
- [OnRegen](OnRegen.md)
