# OnUserEnd

## 声明

```pascal
procedure OnUserEnd (aStr : String);
```

## 参数

- `aStr`：空字符串。此事件不传递额外参数。

## 触发条件

> ⚠️ **预留事件，当前版本未启用**
>
> 源码中 `SOnUserEnd` 仅在 `BasicObj.pas` 第 2890 行通过 `CheckScriptEvent` 注册了事件槽位，但整个代码库中**不存在** `CallEvent(... SOnUserEnd ...)` 的调用。此事件在当前版本中**不会被触发**。
>
> 作为对比，配对的 `OnUserStart` 事件在 `UUser.pas` 第 4907 行有实际的 `CallEvent` 调用。

~~玩家离开游戏世界时触发。~~ 此事件已注册但无触发调用点，为预留事件。

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
