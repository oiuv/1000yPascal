# getfirstquest

读取当前脚本对象 `FSelf` 的 `FirstQuestNo`，返回十进制数字字符串。

```pascal
Str := callfunc ('getfirstquest');
FirstQuest := StrToInt (Str);
```

## 对象语义

分派器调用 `TBasicObject(FSelf).SGetFirstQuest`。基础 `TBasicObject` 实现固定返回 `0`；`TUser` 覆盖实现才读取 `UserQuestClass.FirstQuestNo`。

因此不能把本函数解释成“读取 NPC 的任务”：

- `System.OnUserStart` 由登录玩家作为 `Self` 调用，本函数读取该玩家，神武线上和炎黄随包的 `System.txt` 都采用此写法；
- 普通 NPC、Monster、DynamicObject 使用基础实现时只会得到 `0`；
- NPC 交互脚本要读取触发玩家，应使用 `getsenderfirstquest`。

## 真实示例

```pascal
Str := callfunc ('getfirstquest');
FirstQuest := StrToInt (Str);
if FirstQuest < 1 then begin
   Str := 'changefirstquest 1';
   print (Str);
end;
```

来源：神武线上和炎黄随包 `System.txt` 的共同核心逻辑。

相关函数：`getsenderfirstquest`、`getcurrentquest`、`getcompletequest`。
