# OnRegen

## 声明

```pascal
procedure OnRegen (aStr : String);
```

对象完成重生初始化后触发，`aStr` 为空字符串。当前源码有两处直接调用：`TDynamicObject.Regen` 和 `TMonster.Regen`；没有发现 NPC 的调用路径。调用时 `Self` 是重生对象，`Sender` 为空。

## 真实脚本用法

云端神武版与炎黄随包的 `铁闸门.txt` 都在门重生后联动重生三个酒坛：

```pascal
procedure OnRegen (aStr : String);
begin
   print ('regen 钥匙酒坛 dynamicobject');
   print ('regen 爆破酒坛 dynamicobject');
   print ('regen 电酒坛 dynamicobject');
end;
```

其他已核实实例：

- `钥匙酒坛.txt`：重生时递减共享计数器。
- `狐狸火.txt`：把 `LightCount` 重置为 0。
- `霸王石.txt`：恢复关联怪物的冻结、受击状态并重置阶段变量。

`雪上天蚕.txt` 没有 `OnRegen`，不能作为该事件示例。

源码依据：`BasicObj.pas` 的 `TDynamicObject.Regen`、`uMonster.pas` 的 `TMonster.Regen`。

## 相关事件

- [OnTurnOn](OnTurnOn.md)
- [OnTurnOff](OnTurnOff.md)
- [OnTimer](OnTimer.md)
