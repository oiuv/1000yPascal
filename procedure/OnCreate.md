# OnCreate

邻近对象创建后触发的事件回调。它用于响应进入当前对象邻域的新对象，不是当前对象自身的初始化事件。

## 声明
```pascal
procedure OnCreate (aStr : String);
```

## 参数
| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串，无附加信息 |

## 触发条件
对象进入地图并发送 `FM_CREATE` 后，`TFieldPhone.SendMessage` 会向邻域内除创建者自身以外的对象广播 `FM_AFTERCREATE`。每个接收对象随后调用自己的 `OnCreate`，并把新创建对象作为 `aSender`。

因此，同一个 NPC、Monster 或 DynamicObject 的 `OnCreate` 可随着其他对象在附近创建而反复触发，适合用于：
- 向进入视野的玩家弹出对话窗口
- 根据新进入邻域对象的种族或名称执行逻辑
- 响应附近对象生成

**源码位置**: `BasicObj.pas` 第 1632-1635 行

## 适用对象
- NPC
- Monster
- DynamicObject

## 示例

### 示例 1：玩家进入邻域时弹出对话窗口
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

此示例在邻近对象创建后，检测 `aSender` 是否为玩家（Race=1）；如果是则弹出对话窗口。

### 示例 2：收到邻近对象创建事件后执行命令
> 来源：`bin/Script/密室太极老人.txt`

```pascal
procedure OnCreate (aStr : String);
begin
   print ('clearworkbox');
   print ('gotoxy 20 16');
end;
```

此示例每次收到邻近对象创建事件时清理工作区并定位。脚本没有检查发送者，因此可能重复执行。

## 相关事件
- [OnDestroy](OnDestroy.md) — 对象销毁时触发
- [OnRegen](OnRegen.md) — 对象重生时触发
- [OnApproach](OnApproach.md) — 对象进入视野时触发
