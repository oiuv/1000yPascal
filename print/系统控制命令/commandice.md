# commandice

## 功能描述
设置当前生命对象的冻结 tick。当前 `TBasicObject.SCommandIce` 是空实现，实际行为来自 `TLifeObject` 覆盖。

## 语法格式
```pascal
print('commandice <冻结tick>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 冻结 tick | Integer | 正常倍率下 1 tick 约 10 ms；0 会立即清除冻结计时 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'commandice' then begin
   TBasicObject (aSelf).SCommandIce (_StrToInt (Params [0]));
```

直接调用 `Self.SCommandIce`。生命对象把当前 `mmAnsTick` 和间隔保存到 `FIceTick/FIceInterval`；若已处于计时冻结，再次调用非 0 值不会延长时间。

## 使用示例

目前游戏脚本中暂无直接使用 `commandice` 的示例，通常使用其变体 `commandicebyname`。

## 注意事项

1. **作用于自身**：冻结的是当前脚本对象自身
2. **变体命令**：实际脚本中更常用 `commandicebyname`（按名称冻结指定对象）
3. **对象限制**：动态对象只继承空实现，不能据此认为所有对象都会冻结

## 相关命令
- `commandicebyname` — 按名称冻结对象
- `boiceallbyname` — 设置所有目标是否冻结
