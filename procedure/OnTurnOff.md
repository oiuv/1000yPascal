# OnTurnOff

## 声明

```pascal
procedure OnTurnOff (aStr : String);
```

动态对象执行 `DecStep` 时，只有递减前的步进值等于 `FStepList.Count`，即对象正从最终开启状态退出，才会触发。事件在实际 `Dec(FCurrentStep)` 之前调用，因此不是固定的“Step 从 1 变为 0”事件。`aStr` 为空字符串，`Self` 是该动态对象，`Sender` 为空。

## 示例

云端神武版与炎黄随包的 `火坛.txt` 都在点燃数量低于四个后重新禁止攻击 Boss：

```pascal
procedure OnTurnOff (aStr : String);
begin
   if n > 0 then begin
      dec (n);
   end;

   if n < 4 then begin
      print ('setallowhitbyname 太极公子 monster false');
   end;
end;
```

`东天王火炉.txt` 还会删除已召唤怪物，`狐狸火.txt` 会按灯火计数开放对象删除。对象名必须以部署版本脚本为准。

源码依据：`BasicObj.pas` 的 `TDynamicObject.DecStep`。

## 相关事件

- [OnTurnOn](OnTurnOn.md)
- [OnRegen](OnRegen.md)
