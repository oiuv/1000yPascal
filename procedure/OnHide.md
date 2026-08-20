# OnHide

> ⚠️ **预留事件，当前版本未实现**

该事件已在脚本引擎中注册，但源码中没有任何触发点，实际不会被调用。

## 声明

```pascal
procedure OnHide (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 未定义（无触发点） |

## 触发条件

**无**。`CheckScriptEvent` 注册了该事件槽位（`BasicObj.pas` 第 2877 行），但整个源码中没有任何 `CallEvent('OnHide', ...)` 调用。

## 状态

预留事件，不可用。与 [OnShow](OnShow.md) 配对，但 OnShow 已在 `uNpc.pas` 第 471-472 行通过 `FM_SHOW` 消息实际触发（当邻域对象从隐藏变为可见时），OnHide 则仍无触发点。

## 相关事件

- [OnShow](OnShow.md) — 对象变为可见时触发（NPC 类已实现，通过 FM_SHOW 消息调用）
- [OnChangeState](OnChangeState.md) — 对象状态变化时触发（可用）
