# OnDieBefore

## 声明

```pascal
procedure OnDieBefore (aStr : String);
```

当前源码只在 `TDynamicObject` 的受伤处理路径调用该事件。动态对象受到伤害后，生命值被扣到 **小于 0** 时，服务器先把生命值置为 0，再以空字符串调用 `OnDieBefore`。正好扣到 0 的分支不会满足源码中的 `CurLife < 0` 条件。

事件返回值不会被读取，因此不能用它取消死亡或实现“假死”。调用时 `Self` 是动态对象，`Sender` 为空；需要攻击者信息的逻辑不应放在这里。

## 示例

神武线上与炎黄随包的 `东海名所2.txt` 都用它播放破坏音效：

```pascal
procedure OnDieBefore (aStr : String);
begin
   print ('sendsound 9329.wav 43');
   exit;
end;
```

`雪上天蚕.txt` 也在该事件中播放 `9372.wav`。这些是动态对象脚本实例，不能据此扩展为 Monster 或 NPC 通用事件。

源码依据：`BasicObj.pas` 的 `TDynamicObject.FieldProc` 伤害分支。

## 相关事件

- [OnDie](OnDie.md)
- [OnHit](OnHit.md)
- [OnRegen](OnRegen.md)
