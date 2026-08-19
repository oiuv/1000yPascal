# OnShow

## 声明

```pascal
procedure OnShow (aStr : String);
```

## 参数

- `aStr`：空字符串。此事件不传递额外参数。

## 触发条件

NPC 收到 `FM_SHOW` 消息时触发。当另一个原本隐藏的对象变为可见（出现在 NPC 视野范围内）时，系统向该 NPC 发送此消息。与 `OnCreate`（新对象出现）不同，`OnShow` 专门针对从隐藏状态变为可见状态的对象。

## 适用对象

NPC 脚本对象。

## 示例

目前游戏脚本中暂无使用此事件的示例。

## 源码位置

- `uNpc.pas` 第 471 行

## 相关事件

- [`OnCreate`](OnCreate.md) —— 新对象出现在视野范围内时触发
- [`OnHide`](OnHide.md) —— 对象从视野中隐藏时触发（与 `OnShow` 相反）
- [`OnDestroy`](OnDestroy.md) —— 对象被销毁时触发
