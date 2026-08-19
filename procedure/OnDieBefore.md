# OnDieBefore

Monster/NPC/DynamicObject 生命值首次降到 0 时、在死亡处理之前触发的事件回调。

## 声明
```pascal
procedure OnDieBefore (aStr : String);
```

## 参数
| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串，无附加信息 |

## 触发条件
当 Monster、NPC 或 DynamicObject 的生命值首次降到 0 时，在执行死亡动画和 `OnDie` 之前触发。此事件适合用于：
- 播放死亡音效
- 在对象真正消失前执行最后的逻辑
- 实现"假死"或"多阶段生命"机制（可配合状态修改阻止死亡）

与 `OnDie` 的区别：`OnDieBefore` 在死亡处理流程的最早阶段触发，此时对象尚未执行死亡动画和清理逻辑；`OnDie` 在死亡处理完成后触发。

**源码位置**: `BasicObj.pas` 第 6253-6256 行

## 适用对象
- Monster
- NPC
- DynamicObject

## 示例

### 示例 1：死亡前播放破坏音效
> 来源：`bin/Script/东海名所2.txt`

```pascal
procedure OnDieBefore (aStr : String);
begin
   // 名所 부서지는 소리（景点破坏声）
   print ('sendsound 9329.wav 43');
   exit;
end;
```

此示例在可破坏的名所对象死亡前播放破坏音效。

### 示例 2：天蚕死亡前播放音效
> 来源：`bin/Script/雪上天蚕.txt`

```pascal
procedure OnDieBefore (aStr : String);
begin
   print ('sendsound 9372.wav 45');
   exit;
end;
```

### 示例 3：名所被破坏时的音效
> 来源：`bin/Script/冰壁.txt`

```pascal
procedure OnDieBefore (aStr : String);
begin
   print ('sendsound 9329.wav 43');
   exit;
end;
```

目前游戏脚本中 `OnDieBefore` 主要用于在可破坏对象（名所、岩石、栅栏等）被摧毁前播放音效。

## 相关事件
- [OnDie](OnDie.md) — 死亡后触发（在死亡处理完成后）
- [OnHit](OnHit.md) — 被攻击命中时触发
- [OnDropItem](OnDropItem.md) — 死亡掉落物品时触发
