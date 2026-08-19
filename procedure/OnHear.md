# OnHear

## 声明

```pascal
procedure OnHear (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 说话的内容字符串（已去除说话者名字前缀） |

## 触发条件

动态对象收到 `FM_SAY` 消息时触发，即有玩家在该对象附近说话（发送聊天消息）时激活。对象需要具有 `DYNOBJ_EVENT_HEAR` 事件标记才能接收此回调。

源码位置：`BasicObj.pas` 第 6477-6481 行

## 适用对象

- DynamicObject（动态对象）

## 示例

> 当前脚本目录中未发现 OnHear 的实际使用示例。以下为基于引擎行为的参考实现：

```pascal
procedure OnHear (aStr : String);
var
   Str, Name : String;
begin
   // 监听玩家说话并响应
   if aStr = '开门' then begin
      print ('changedynobjstate 铁闸门 true');
      print ('say 听到指令，开启大门');
      exit;
   end;

   if aStr = '点火' then begin
      print ('selfchangedynobjstate TRUE');
      exit;
   end;
end;
```

## 相关事件

- [OnTimer](OnTimer.md) — 定时触发事件
- [OnDropItem](OnDropItem.md) — 投放物品事件
- [OnChangeState](OnChangeState.md) — 状态变化事件
