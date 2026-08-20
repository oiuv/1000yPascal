# getname

获取当前脚本关联对象（自身）的名称。注意：此函数操作的是 `FSelf`（脚本关联的对象），而非触发事件的玩家。

## 语法
```pascal
Str := callfunc('getname');
```

## 参数
无参数。

## 返回值
返回字符串，为对象名称。

## 源码实现
```pascal
Result := TBasicObject(FSelf).SGetName;
```

## 示例

### System.txt 中的新玩家欢迎
基于 `System.txt`：
```pascal
procedure OnUserStart (aStr : String);
var
   Str : String;
begin
   Str := callfunc ('getfirstquest');
   FirstQuest := StrToInt (Str);
   if FirstQuest < 1 then begin
      Str := callfunc ('getname');
      Str := 'sendsendertopmsg 欢迎新玩家[' + Str;
      Str := Str + '],来到云端千年的武侠世界';
      print (str);
   end;
end;
```

### NPC 名称显示

按当前 `CommandScript` 的命令格式，应先把完整正文拼到 `say ` 后再调用 `print`：
```pascal
aName := callfunc ('getname');
Str := 'say 等待摆擂征婚者:' + aName;
print (Str);
```

炎黄随包和云端神武版两版 `绣球.txt` 原文都写成 `print('等待摆擂征婚者:' + Str)`。该字符串不以已注册命令开头，不会命中 `CommandScript` 分派，因此这里只保留经当前源码校正后的写法，并把原文视为脚本缺陷。

## 注意事项
1. **重要区别**：`getname` 获取的是脚本关联对象（FSelf）的名称；`getsendername` 获取的是触发事件的玩家名称
2. 在怪物脚本中返回怪物名称，在 NPC 脚本中返回 NPC 名称
3. 常用于拼接消息字符串，向玩家展示对象名称

## 相关函数
- `getsendername` — 获取触发事件的玩家名称
- `getrace` — 获取对象种族
- `getage` — 获取对象年龄
