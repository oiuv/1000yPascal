# OnBow

## 声明

```pascal
procedure OnBow (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 攻击者的 SayString（通常是武功名称字符串） |

## 触发条件

动态对象被弓箭或远程技能命中时，收到 `FM_BOW` 消息，且对象具有 `DYNOBJ_EVENT_BOW` 事件标记时触发。

源码位置：`BasicObj.pas` 第 6864-6867 行

## 适用对象

- DynamicObject（动态对象）— 需设置 `DYNOBJ_EVENT_BOW` 标记

## 示例

### 示例 1：火炉被火箭点燃（火炉.txt）

配合 `OnDanger` 判断远程攻击类型，火箭命中时触发点燃逻辑：

```pascal
function OnDanger (aStr : String) : String;
begin
   if aStr = '火箭' then begin
      Result := 'true';
      exit;
   end;
   Result := 'false';
end;

procedure OnBow (aStr : String);
begin
   // 被远程攻击命中时，配合 OnDanger 判断是否为火箭
   // OnDanger 返回 true 后触发 IncStep 点燃炉火
end;
```

### 示例 2：火坛计数器（火坛.txt）

与 OnTurnOn/OnTurnOff 配合，远程攻击命中火坛时递增计数器，达到阈值后开启机关：

```pascal
procedure OnBow (aStr : String);
begin
   // 被远程攻击命中，触发 IncStep 使炉火开启
   // 随后 OnTurnOn 中递增计数，达到 4 时允许攻击 Boss
end;
```

## 相关事件

- [OnDanger](../procedure/OnHit.md) — 远程攻击判定回调（决定是否接受伤害）
- [OnTurnOn](OnTurnOn.md) / [OnTurnOff](OnTurnOff.md) — 开关状态事件（OnBow 触发 IncStep 后联动）
- [OnHit](OnHit.md) — 近战命中事件
