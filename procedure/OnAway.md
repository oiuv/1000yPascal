# OnAway

其他对象离开本对象视野范围时触发的事件回调。

## 声明
```pascal
procedure OnAway (aStr : String);
```

## 参数
| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串，无附加信息。可通过 `callfunc('getsenderrace')` 获取离开者的种族类型 |

## 触发条件
当原本在视野范围内的对象离开时，引擎向本对象发送 `FM_AWAY` 消息触发。可用于：
- 玩家离开时播放告别语音
- 重置因玩家靠近而改变的状态
- 清理与特定玩家相关的临时数据

**源码位置**: `BasicObj.pas` 第 1722-1725 行

## 适用对象
- NPC
- Monster
- DynamicObject

## 示例

### 示例 1：玩家离开时显示对话
> 来源：`bin/Script/一级僧侣.txt`

```pascal
procedure OnAway (aStr : String);
var
   Str : String;
   Race : Integer;
begin
   Str := callfunc ('getsenderrace');
   Race := StrToInt (Str);
   if Race = 1 then begin
      print ('say 南无阿弥陀佛...');
      exit;
   end;
end;
```

此示例检测离开者的种族（Race=1 表示玩家），如果是玩家则让 NPC 念诵佛号。

## 相关事件
- [OnApproach](OnApproach.md) — 对象进入视野时触发
- [OnCreate](OnCreate.md) — 对象创建时触发
- [OnDestroy](OnDestroy.md) — 对象销毁时触发
