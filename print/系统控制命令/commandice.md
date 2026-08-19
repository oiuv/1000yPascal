# commandice

## 功能描述
暂停（冻结）当前对象指定毫秒数。冻结期间对象无法移动或执行动作。

## 语法格式
```pascal
print('commandice <冻结毫秒>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 冻结毫秒 | Integer | 冻结持续的毫秒数 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'commandice' then begin
   TBasicObject (aSelf).SCommandIce (_StrToInt (Params [0]));
```

直接调用 `SCommandIce`，传入冻结毫秒数。

## 使用示例

目前游戏脚本中暂无直接使用 `commandice` 的示例，通常使用其变体 `commandicebyname`。

## 注意事项

1. **作用于自身**：冻结的是当前脚本对象自身
2. **变体命令**：实际脚本中更常用 `commandicebyname`（按名称冻结指定对象）

## 相关命令
- `commandicebyname` — 按名称冻结对象
- `boiceallbyname` — 设置所有目标是否冻结
