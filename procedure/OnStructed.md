# OnStructed

> ⚠️ **预留事件，当前版本未实现**

该事件已在脚本引擎中注册，但源码中没有任何触发点，实际不会被调用。

## 声明

```pascal
procedure OnStructed (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 未定义（无触发点） |

## 触发条件

**无**。`CheckScriptEvent` 注册了该事件槽位（`BasicObj.pas` 第 2876 行），但整个源码中没有任何 `CallEvent('OnStructed', ...)` 调用。

> 注：`FM_STRUCTED` 消息在引擎中广泛使用（受击硬直反馈），但并未触发脚本事件。

## 状态

预留事件，不可用。如需响应受击事件，请使用 [OnHit](OnHit.md)。

## 相关事件

- [OnHit](OnHit.md) — 动态对象被攻击时触发
- [OnBow](OnBow.md) — 动态对象被弓箭命中时触发
