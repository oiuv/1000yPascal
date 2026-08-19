# OnRightClick

> ⚠️ **预留事件，当前版本未实现**

该事件已在脚本引擎中注册，但源码中没有任何触发点，实际不会被调用。

## 声明

```pascal
procedure OnRightClick (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 未定义（无触发点） |

## 触发条件

**无**。`CheckScriptEvent` 注册了该事件槽位（`BasicObj.pas` 第 2881 行），但整个源码中没有任何 `CallEvent('OnRightClick', ...)` 调用。

## 状态

预留事件，不可用。如需右键交互功能，请使用 [OnLeftClick](OnLeftClick.md) 或 [OnDblClick](OnDblClick.md)。

## 相关事件

- [OnLeftClick](OnLeftClick.md) — 左键点击触发
- [OnDblClick](OnDblClick.md) — 双击触发
