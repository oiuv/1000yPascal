# guilditemwindow

## 功能与语法

为触发脚本的玩家打开门派共享仓库窗口，而不是只读的物品流通日志。

```pascal
print('guilditemwindow');
```

无参数。`CommandScript` 调用 `TUser.SGuildItemWindow(FSelf)`；玩家对象把脚本自身保存为窗口 `Commander`，随后执行 `ShowGuildItemLogWindow(1)`。

`ShowGuildItemLogWindow(1)` 从玩家所属门派对象读取仓库页并发送物品，后续拖放由门派仓库交互路径处理。真实配置脚本 `bin/Script/药材商.txt` 使用此命令。该命令作用于 `aSender`，只能在存在触发玩家的事件中调用。

门派仓库二进制数据见 [运行时 SDB 与 Guild 数据](../../help/RuntimeData.md)。
