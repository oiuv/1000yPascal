# OnTurnOn

## 声明

```pascal
procedure OnTurnOn (aStr : String);
```

动态对象执行 `IncStep` 后，仅在步进值到达 `FStepList.Count`、即进入最终开启状态时触发。它不是固定的“Step 从 0 变为 1”事件；多步对象的中间步不会调用此事件。`aStr` 为空字符串，`Self` 是该动态对象，`Sender` 为空。

## 示例

云端神武版与炎黄随包的 `火坛.txt` 都在四个火坛全部点燃后开放 Boss 受击：

```pascal
procedure OnTurnOn (aStr : String);
begin
   if n < 4 then begin
      inc (n);
   end;

   if n >= 4 then begin
      print ('setallowhitbyname 太极公子 monster true');
   end;
end;
```

实际脚本还包括 `东天王火炉.txt` 的召唤准备、`蜡台.txt` 的多对象计数以及 `火炉.txt` 的机关联动。复制示例前应核对目标版本中的对象名和地图名。

源码依据：`BasicObj.pas` 的 `TDynamicObject.IncStep`。

## 相关事件

- [OnTurnOff](OnTurnOff.md)
- [OnRegen](OnRegen.md)
- [OnTimer](OnTimer.md)
