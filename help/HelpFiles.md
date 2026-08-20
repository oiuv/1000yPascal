# help 窗口文本

服务端启动时由 `THelpFiles` 缓存 `./help/` 顶层的窗口文本。当前炎黄随包有 279 个顶层文件。

## 加载规则

- 只枚举 `./help/*.*`，不会递归子目录。
- 只有扩展名精确等于小写 `.txt` 的文件进入缓存。
- 每行重新以 CRLF 拼接后保存在内存中。
- `FindFile` 对完整相对路径执行不区分大小写的匹配。

`showwindow <文件> <kind>` 先检查磁盘文件存在，再从缓存取内容。`kind=0` 打开帮助窗口，其他值打开交易窗口。窗口打开时会保存脚本事件的 `Self` 为 Commander；客户端提交选择后，它可通过 `PutResult` 触发该对象的 `OnGetResult`。

## 文本标签边界

Pascal 服务端不解析 help 文本内部标签，只把整段文本发给客户端。当前真实文件可确认使用了 `<title>`、`<text>`、`<trade>`、`<image ...>`、`<command send=...>` 等标签；其完整语法属于客户端协议，不能仅凭服务端源码扩展或猜测。

## 运维注意

- 原始文本使用 GBK。UTF-8 保存可能导致旧客户端或服务端显示乱码。
- 修改已缓存文件后，使用服务端菜单的 Help Files 重载功能，或在维护窗口重启；仅替换磁盘文件不会自动更新内存。
- 文件名、脚本 `showwindow` 路径和 `OnGetResult` 分支值必须一起核对。
- 不要把运维 Markdown 放进运行时 `bin/help/`；加载器会缓存其中所有小写 `.txt`。

源码依据：`svClass.pas` 的 `THelpFiles`、`UUser.pas` 的 `TUser.SShowWindow`、`uUserSub.pas` 的窗口选择处理。
