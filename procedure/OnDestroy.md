# OnDestroy

游戏对象销毁前触发的事件，与 `OnCreate` 配对使用。

## 声明

```pascal
procedure OnDestroy (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串 |

## 触发条件

> ⚠️ **当前版本未启用**
>
> `FM_BEFOREDESTROY` 消息的发送代码在 `fieldmsg.pas` 第 284 行已被注释：
> ```pascal
> // SendMessage (hfu, FM_BEFOREDESTROY, SenderInfo, aSubData);
> ```
> 虽然 `BasicObj.pas` 第 1638-1645 行保留了消息处理分支，但由于消息从未被发出，此事件在当前版本中**不会被触发**。

对象收到 `FM_BEFOREDESTROY` 消息时触发，在对象被从地图移除之前调用。

## 适用对象

- NPC
- Monster
- DynamicObject

## 示例

目前游戏脚本中暂无使用此事件的示例。可用于对象销毁前的清理逻辑，如通知其他对象、播放特效等。

```pascal
procedure OnDestroy (aStr : String);
begin
  // 对象即将被销毁，可在此执行清理逻辑
end;
```

## 相关事件

- [OnCreate](OnCreate.md) — 对象创建时触发
- [OnRegen](OnRegen.md) — 对象重生时触发
