# showwindow

## 功能

让当前事件发送者 `aSender` 读取服务器上的帮助文件并显示窗口。脚本所属对象 `FSelf` 会记录为窗口的 `Commander`。

## 语法

```pascal
print('showwindow 文件路径 类型');
```

| 参数 | 说明 |
| --- | --- |
| `文件路径` | 服务器可访问的文件路径；源码先用 `FileExists` 检查，再由 `HelpFiles.FindFile` 读取 |
| `类型` | 经 `_StrToInt` 转为 `Byte`；`0` 调用 `ShowHelpWindow`，非 `0` 调用 `ShowTradeWindow` |

## 执行条件

实际窗口逻辑由 `TUser.SShowWindow` 实现，因此正常接收者应为玩家。若 `ShowWindowClass.AllowWindowAction(swk_none)` 返回 `false`，或指定文件不存在，方法直接退出，不显示窗口。

## 真实脚本示例

`bin/Script/龙师父.txt` 中使用：

```pascal
print('showwindow .\help\龙师父.txt 1');
```

类型 `0` 与非 `0` 的区别只能按源码中的帮助窗口/交易窗口分支理解；源码未将它们定义为“多项列表”或“四项列表”。
