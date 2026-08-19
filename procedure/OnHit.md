# OnHit

动态对象被玩家近战/远程攻击命中时触发的事件回调。

## 声明
```pascal
procedure OnHit (aStr : String);
```

## 参数
| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串，无附加信息。伤害值等攻击信息需通过 `callfunc` 获取 |

## 触发条件
当玩家对 DynamicObject、Monster 等动态对象发起近战或远程攻击并命中时触发。每次命中都会触发一次。适合用于：
- 实现反伤机制
- 根据生命值触发阶段变化
- 命中时召唤援军
- 累计攻击次数触发特殊效果

**源码位置**: `BasicObj.pas` 第 6562-6600 行

## 适用对象
- Monster
- DynamicObject
- NPC（可被攻击的情况）

## 示例

### 示例 1：反弹伤害给攻击者
> 来源：`bin/Script/石大王.txt`

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

此示例先检查攻击者是否为玩家（Race=1），然后执行重新定位并将 20% 的伤害反弹给攻击者。

### 示例 2：根据生命值触发阶段变化
> 来源：`bin/Script/霸王石.txt`

```pascal
procedure OnHit (aStr : String);
var
   Str : String;
   Life : Integer;
begin
   if n = 1 then exit;

   Str := callfunc ('getlife');
   Life := StrToInt (Str);

   if Life <= 50000 then begin
      print ('boiceallbyname 地下石巨人 monster false');
      print ('bohitallbyname 地下石巨人 monster true');
      n := 1;
      exit;
   end;
end;
```

此示例在霸王石生命值降到 50000 以下时，停止地下石巨人的冻结状态并允许它们攻击。

### 示例 3：首次命中时召唤援军
> 来源：`bin/Script/东海名所2.txt`

```pascal
procedure OnHit (aStr : String);
var
   Str : String;
begin
   Inc (n);
   if n > 1 then begin
      exit;
   end;

   print ('mapaddobjbyname monster 陶약잼柰准2 129 317 2 0 false');
   print ('mapaddobjbyname monster 陶약잼柰准2 132 322 2 0 false');
   print ('mapaddobjbyname monster 陶약잼柰准2 137 323 2 0 false');
   print ('mapaddobjbyname monster 陶약잼柰准2 142 321 2 0 false');
   exit;
end;
```

此示例使用计数器确保只在首次命中时在地图指定位置召唤 4 只怪物援军。

## 相关事件
- [OnDie](OnDie.md) — 对象死亡后触发
- [OnDieBefore](OnDieBefore.md) — 对象死亡前触发
- [OnRegen](OnRegen.md) — 对象重生时触发
