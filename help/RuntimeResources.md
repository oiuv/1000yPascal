# 程序根目录文本资源

以下文件位于游戏服务端工作目录，不属于 `Init/` 或 `Setting/`，但由当前源码直接读取。

| 文件 | 当前用途 | 加载时机 |
|---|---|---|
| `Notice.txt` | 按行循环向在线玩家发送公告 | 服务窗口激活及菜单重载 |
| `Tip.txt` | 玩家进入地图后随机发送一行系统提示 | 同上 |
| `BadIpAddr.txt` | 读入 `BadIpStringList` | 同上 |
| `DontChar.TXT` | 禁止用于门派武功名的子串列表 | 单元初始化 |
| `GameAgree.TXT` | 登录后的协议确认窗口 | 系统提示类初始化 |
| `Information.TXT` | 普通信息窗口的后备文件 | 系统提示类初始化 |
| `tgs1000.acs` | `Conv()` 使用的本地化字符串映射 | `AnsStringCls` 初始化 |

## 已核实行为

`Notice.txt` 由定时事件逐行轮播，播放到末尾后回到第一行。`Tip.txt` 在用户对象启动完成后随机选一行。`BadIpAddr.txt` 在当前 Pascal 项目中只找到创建、加载和释放，没有找到实际拦截查询路径；不能仅凭文件名宣称其已启用封禁。

`DontChar.TXT` 通过 `Pos(禁用串, 名称)` 检查，当前调用位置是门派武功名称验证，不是通用角色名过滤器。文件由初始化代码直接加载，部署时应保留。

若 `GameAgree.TXT` 存在，加载器立即返回，不再读取 `Information.TXT`。两者第一行作为标题，其余行拼成正文；前者打开需要确认的游戏协议窗口，后者打开信息窗口。

`tgs1000.acs` 被大量 `Conv()` 调用依赖。缺失或版本不匹配会影响服务端界面、命令和玩家消息的字符串转换，不能当作可选说明文件。

随包的 `wintosan.tbl` 在 `uGramerId.pas` 中只出现在整段注释掉的初始化代码里，当前没有实际加载证据；保留文件即可，不应宣称它正在参与字符转换。

## 源码保留但当前未部署的入口

- `NpcFunc/NpcFunc.SDB`：`TNpcFunction` 会在启动时尝试读取，但当前随包没有该目录，而且 `GetFunction` 在本项目中没有调用点，不能宣称旧式 NPC 功能表已启用。
- `Init/BestMagicEnergyPoint.sdb`：相关加载代码整体位于 Pascal 注释块内，当前随包也无此文件；现行最佳武功数据以实际 `BestMagic*Cycle`、`BestMagicStateData` 等表为准。

这些路径用于识别历史残留，不是要求补造缺失文件。

## 运维规则

- 这些文本按随包习惯使用 GBK；上线前在副本中验证中文。
- `notice - bak.txt` 等备份名不会被加载。
- Notice/Tip/BadIp 可由现有菜单路径重载；GameAgree、Information、DontChar、ACS 应安排重启生效。
- 修改前保留整套同版本文件，避免把神武线上文本直接覆盖到炎黄程序目录。

源码依据：`SVMain.pas`、`svClass.pas`、`Common/AnsStringCls.pas`。
