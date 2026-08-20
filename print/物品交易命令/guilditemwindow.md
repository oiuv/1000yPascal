# guilditemwindow

## 功能与语法

为触发脚本的玩家打开门派物品记录窗口。

```pascal
print('guilditemwindow');
```

无参数。`CommandScript` 调用 `TUser.SGuildItemWindow(FSelf)`；玩家对象把脚本自身保存为窗口 `Commander`，随后执行 `ShowGuildItemLogWindow(1)`。

真实配置脚本 `bin/Script/药材商.txt` 使用此命令。该命令作用于 `aSender`，只能在存在触发玩家的事件中调用。
