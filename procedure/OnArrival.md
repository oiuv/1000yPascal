# OnArrival

## 声明

```pascal
procedure OnArrival (aStr : String);
```

## 参数

- `aStr`：空字符串。此事件不传递额外参数。

## 触发条件

NPC 或 Monster 的 AI 状态机回到空闲状态（`los_none`）时触发。表示该单位完成了移动或攻击等动作后到达目的地，进入空闲状态。此事件由引擎内部的 AI 循环在状态切换时自动调用。

## 适用对象

NPC 脚本对象和 Monster 脚本对象。

## 示例

### 一级僧侣（一级僧侣.txt）—— 到达目的地后的处理

```pascal
procedure OnArrival (aStr : String);
var
   Str : String;
begin
   // 此脚本中 OnArrival 已声明但在 implementation 中未给出具体实现
   // 表明该事件已被注册，可用于在 NPC 到达目的地后执行逻辑
end;
```

> 目前游戏脚本中仅有 `一级僧侣.txt` 声明了此事件，但实现部分为空。以下为事件声明：

```pascal
// interface 部分声明
procedure OnArrival (aStr : String);
```

目前游戏脚本中暂无此事件的完整实现示例。

## 源码位置

- `uNpc.pas` 第 731-734 行（NPC）
- `uMonster.pas` 第 1005-1008 行（Monster）

## 相关事件

- [`OnApproach`](OnApproach.md) —— 玩家接近时触发
- [`OnAway`](OnAway.md) —— 玩家离开时触发
- [`OnChangeState`](OnChangeState.md) —— AI 状态变化时触发
