# OnApproach

其他对象进入本对象视野范围时触发的事件回调。

## 声明
```pascal
procedure OnApproach (aStr : String);
```

## 参数
| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串，无附加信息。可通过 `callfunc('getsenderrace')` 获取触发者的种族类型来判断是玩家还是其他对象 |

## 触发条件
当其他对象（通常是玩家）进入本对象的视野范围时，引擎向本对象发送 `FM_APPROACH` 消息触发。可用于：
- 玩家靠近时自动播放语音或显示文字
- 根据接近者身份触发不同反应
- 实现区域感知逻辑

**源码位置**: `BasicObj.pas` 第 1714-1718 行

## 适用对象
- NPC
- Monster
- DynamicObject

## 示例

### 示例 1：玩家靠近时显示对话
> 来源：`bin/Script/一级僧侣.txt`

```pascal
procedure OnApproach (aStr : String);
var
   Str : String;
   Race : Integer;
begin
   Str := callfunc ('getsenderrace');
   Race := StrToInt (Str);
   if Race = 1 then begin
      print ('say 施给僧侣，给您带来好运...');
      exit;
   end;
end;
```

此示例检测接近者的种族（Race=1 表示玩家），如果是玩家则让 NPC 说出祝福语。

## 相关事件
- [OnAway](OnAway.md) — 对象离开视野时触发
- [OnCreate](OnCreate.md) — 对象创建时触发
- [OnArrival](OnArrival.md) — 对象到达目的地时触发
