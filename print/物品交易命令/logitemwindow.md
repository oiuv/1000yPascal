# logitemwindow

## 功能与语法

为触发脚本的玩家打开个人福袋/储物空间，而不是“物品获取日志”查询窗口。

```pascal
print('logitemwindow');
```

命令无参数。分派器在 `aSender` 上调用 `SLogItemWindow(FSelf)`：玩家是窗口使用者，脚本自身对象保存为后续交互的 `Commander`。基类实现为空，因此必须有有效玩家 `Sender`。

## 实际数据行为

`ShowItemLogWindow` 从 `ITEMLOG/ItemLog.BIN` 按角色名读取储物房间，每间 10 格，客户端最多显示 4 间。打开前还会检查：

- ITEMLOG 主库是否启用；
- 玩家是否已有其他窗口打开；
- 角色是否分配了储物房间；
- 福袋密码锁是否已解除；
- 每间记录的 CRC 是否有效。

成功后服务器锁定普通背包交互，向客户端发送 `WINDOW_SSAMZIEITEM` 储物窗口及已有物品。窗口中的拖放/确认会继续通过保存的 `Commander` 和物品窗口处理路径执行。

## 随包示例

炎黄 `储物袋.txt` 在 `OnDblClick` 中读取 `getsenderrace`，种族为 1 时执行本命令；`药材商.txt`、`一级药材商.txt`、`帝王石谷药材商.txt` 也有入口。示例只能证明对应脚本的开放条件，不能外推成命令自身的种族限制。

福袋主文件、快照和备份规则见 [ITEMLOG 福袋数据](../../help/ITEMLOG.md)。源码依据：`uScriptManager.pas`、`UUser.pas` 和 `uUserSub.pas` 的 `ShowItemLogWindow`。
