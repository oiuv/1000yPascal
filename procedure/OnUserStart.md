# OnUserStart

## 声明

```pascal
procedure OnUserStart (aStr : String);
```

## 参数

- `aStr`：空字符串。此事件不传递额外参数。

## 触发条件

玩家进入游戏世界时触发。此事件**仅在系统脚本 `System.txt` 中有效**，由引擎通过 `CheckScriptEvent` 注册并调用。每个玩家登录进入游戏时都会触发一次，可用于新手引导、欢迎消息、初始化任务等全局逻辑。

## 适用对象

仅限系统脚本 `System.txt`。普通 NPC 脚本中声明此事件不会被调用。

## 示例

### System.txt —— 新玩家欢迎与首次任务初始化

```pascal
procedure OnUserStart (aStr : String);
var
   Str : String;
   FirstQuest : Integer;
begin
   Str := callfunc ('getfirstquest');
   FirstQuest := StrToInt (Str);
   if FirstQuest < 1 then begin
      Str := callfunc ('getname');
      Str := 'sendsendertopmsg 欢迎新玩家[' + Str;
      Str := Str + '],来到云端千年的武侠世界';
      print (str);
      Str := 'changefirstquest 1';
      print (str);
      exit;
   end;
end;
```

> 此示例在玩家首次进入游戏时（`getfirstquest` 返回值小于 1），向全服发送欢迎消息，并将首次任务标记设为 1，避免重复触发。

## 源码位置

- `BasicObj.pas` 第 2889 行（`CheckScriptEvent` 注册）

## 相关事件

- [`OnUserEnd`](OnUserEnd.md) —— 玩家离开游戏世界时触发（与 `OnUserStart` 配对）
- [`OnCreate`](OnCreate.md) —— NPC 视野中出现新对象时触发
