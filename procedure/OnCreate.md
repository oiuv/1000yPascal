# OnCreate

对象创建完成后触发的事件回调，用于初始化 NPC/Monster/DynamicObject 的行为。

## 声明
```pascal
procedure OnCreate (aStr : String);
```

## 参数
| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串，无附加信息 |

## 触发条件
当游戏对象（NPC、Monster、DynamicObject）被创建并放入地图后，引擎通过 `TFieldPhone.SendMessage` 向邻域对象广播 `FM_AFTERCREATE` 消息时触发（`fieldmsg.pas` 第 307 行，在处理 `FM_CREATE` 后自动向周围对象发送）。此事件在对象生命周期中只触发一次，适合用于：
- 向进入视野的玩家弹出对话窗口
- 初始化对象的状态变量
- 设置对象的初始行为

**源码位置**: `BasicObj.pas` 第 1632-1635 行

## 适用对象
- NPC
- Monster
- DynamicObject

## 示例

### 示例 1：创建时向玩家弹出对话窗口
> 来源：`bin/Script/2级黑捕校.txt`

```pascal
procedure OnCreate (aStr : String);
var
   Str : String;
begin
   Str := callfunc ('getsenderrace');
   if Str <> '1' then begin
      exit;
   end;

   Str := 'showwindow .\help\2级黑捕教.txt 1';
   print (Str);
   exit;
end;
```

此示例在 NPC 创建后，检测触发者是否为玩家（Race=1），如果是则弹出对话窗口。

### 示例 2：创建后清理工作区并定位
> 来源：`bin/Script/密室太极老人.txt`

```pascal
procedure OnCreate (aStr : String);
begin
   print ('clearworkbox');
   print ('gotoxy 20 16');
end;
```

此示例在对象创建后清理工作区并将视角定位到指定坐标。

## 相关事件
- [OnDestroy](OnDestroy.md) — 对象销毁时触发
- [OnRegen](OnRegen.md) — 对象重生时触发
- [OnApproach](OnApproach.md) — 对象进入视野时触发
