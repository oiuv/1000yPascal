# OnGetChangeStep

## 声明

```pascal
procedure OnGetChangeStep (aStr : String);
```

## 参数

- `aStr`：动作编号的字符串形式，如 `'1'`。表示视野内的对象执行了某个动作变化，编号对应具体的动作类型。

## 触发条件

NPC 收到 `FM_CHANGESTEP` 消息时触发。当 NPC 视野范围内的对象（通常是玩家）执行了动作变化（如移动了一步、改变了姿态等）时，系统向 NPC 发送此消息。NPC 脚本可据此判断玩家的位置变化并做出响应，例如将玩家传送回去或触发机关。

## 适用对象

NPC 脚本对象。主要用于密室、机关类 NPC，用于检测玩家的动作变化。

## 示例

### 密室太极老人（密室太极老人.txt）—— 检测玩家移动并传送回原位

```pascal
procedure OnGetChangeStep (aSTr : String);
var
   Str, rdStr, xStr, yStr : String;
   x, y, xx, yy : Integer;
begin
   if aStr <> '1' then begin
      exit;
   end;

   // 获取玩家当前位置
   Str := callfunc ('getsenderposition');
   Str := GetToken (Str, xStr, '_');
   x := StrToInt (xStr);
   Str := GetToken (Str, yStr, '_');
   y := StrToInt (yStr);

   // 计算附近的合法位置
   rdStr := 'getnearxy ' + xStr;
   rdStr := rdStr + ' ';
   rdStr := rdStr + yStr;
   Str := callfunc (rdStr);

   Str := GetToken (Str, xStr, '_');
   xx := StrToInt (xStr);
   Str := GetToken (Str, yStr, '_');
   yy := StrToInt (yStr);

   // 如果玩家偏离合法位置，传送回去
   if x = xx then begin
      if y = yy then begin
         exit;
      end;
   end;

   Str := 'gotoxy ' + xStr;
   Str := Str + ' ';
   Str := Str + yStr;
   print (Str);

   // 隐藏玩家的动态对象
   rdStr := callfunc ('getsendername');
   Str := 'changesenderdynobjstate ' + rdStr;
   Str := Str + ' false';
   print (Str);
end;
```

> 注意：此脚本中参数名拼写为 `aSTr`（大小写不同），但 Pascal 不区分大小写，功能正常。

## 源码位置

- `uNpc.pas` 第 505 行

## 相关事件

- [`OnGetResult`](OnGetResult.md) —— 玩家选择选项后触发
- [`OnCreate`](OnCreate.md) —— NPC 创建时触发，常用于初始化密室场景
