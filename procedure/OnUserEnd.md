# OnUserEnd

## 声明

```pascal
procedure OnUserEnd (aStr : String);
```

## 参数

- `aStr`：空字符串。此事件不传递额外参数。

## 触发条件

玩家离开游戏世界时触发。此事件**仅在系统脚本 `System.txt` 中有效**，由引擎通过 `CheckScriptEvent` 注册并调用。每个玩家退出游戏（断开连接）时都会触发一次，可用于清理数据、记录日志、发送告别消息等全局逻辑。

## 适用对象

仅限系统脚本 `System.txt`。普通 NPC 脚本中声明此事件不会被调用。

## 示例

### System.txt —— 当前实现为空

```pascal
procedure OnUserEnd (aStr : String);
begin

end;
```

> 当前 `System.txt` 中此事件已声明但实现为空。可在此处添加玩家下线时的处理逻辑，例如：
>
> ```pascal
> procedure OnUserEnd (aStr : String);
> var
>    Str : String;
> begin
>    Str := callfunc ('getname');
>    Str := 'sendsendertopmsg 玩家[' + Str + ']离开了千年世界';
>    print (Str);
> end;
> ```

目前游戏脚本中暂无此事件的完整实现示例。

## 源码位置

- `BasicObj.pas` 第 2890 行（`CheckScriptEvent` 注册）

## 相关事件

- [`OnUserStart`](OnUserStart.md) —— 玩家进入游戏世界时触发（与 `OnUserEnd` 配对）
- [`OnDestroy`](OnDestroy.md) —— 对象被销毁时触发
