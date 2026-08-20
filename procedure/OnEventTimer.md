# OnEventTimer

地图（Manager）级别的定时器事件，在特定地图类型下周期性触发。

## 声明

```pascal
procedure OnEventTimer (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串 |

## 触发条件

在 `MAP_TYPE_KILLONLYONE`（最后一人存活模式）地图中，当再生倒计时剩余 30 秒时触发。

> 源码: `uManager.pas` 第 301-302 行

## 适用对象

- 地图脚本（System.txt 等地图级脚本）

## 注意

此事件是**地图级别**事件，不是单个游戏对象的事件。它绑定在地图的 Manager 对象上，而非 NPC/Monster/DynamicObject。

## 示例

```pascal
procedure OnEventTimer (aStr : String);
begin
  // 地图事件定时器触发
  // 可用于倒计时提示、生成怪物等
end;
```

## 相关事件

- [OnTimer](OnTimer.md) — 对象级别的定时器事件（每 1 秒触发）
