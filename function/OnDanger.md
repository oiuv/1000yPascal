# OnDanger

## 声明

```pascal
function OnDanger (aStr : String) : String;
```

对象在伤害结算前收到攻击时触发。`Self` 是受击对象，`Sender` 是攻击者。

## 参数与返回值

- 弓箭攻击会把攻击数据中的 `SayString` 传入 `aStr`，实际脚本可据此识别“火箭”等类型。
- 暴击、掌风和近战路径传入空字符串。
- 仅精确返回小写字符串 `false` 会立即取消本次攻击；其他返回值继续结算。

若脚本用于限制攻击，应覆盖所有分支并显式设置 `Result`。

## 示例

以下逻辑见云端神武版与炎黄随包的 `火坛.txt`：

```pascal
function OnDanger (aStr : String) : String;
begin
   if aStr = '火箭' then begin
      Result := 'true';
      exit;
   end;

   Result := 'false';
end;
```

该对象只允许火箭攻击。源码依据：`uSkills.pas` 的弓箭、暴击、掌风和近战处理分支。
