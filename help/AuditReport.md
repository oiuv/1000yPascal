# 源码与资料审查记录

审查日期：2026-08-20。本文记录本轮资料校核的范围、结论和仍需由程序修复的问题，便于后续更新时复查。

## 资料边界

现行行为只由仓库 Pascal 源码和 `gameserver-tgs1000/bin` 实际文件确定；`炎黄新章游戏资料` 用于核对玩家可见规则。`docs/Script` 是真实神武奇章线上脚本，证明旧版本用法，但不能覆盖炎黄接口定义。未使用网络资料或按字段名猜测。

## 已完成校核

- 对照全部 197 个神武 `.txt` 及 `Script.SDB`：与炎黄目录有 164 个同名数据文件（含 `Script.SDB`），其中 60 个相同、104 个不同；另有 34 个神武独有 `.txt`，炎黄独有 `火炉1.txt`。
- 复核脚本解释器、`callfunc`/`print` 分派、`Self`/`Sender` 上下文和现有事件页；修正任务函数、对象创建/删除、冻结、延迟 tick、事件返回值等错误说明。
- 用当前分派器反向校验索引：109 个有效 `callfunc`、76 个有效 `print`（含入口专用 `checkitemregen`）和 29 个实际事件名均有独立页面；`getjobgrade`、`changequeststr` 只作为未实现迁移说明，不计入有效接口。
- 当前 `Init/` 的 38 个主数据表均有对应页，未单列的 4 个文件是随包备份/改名副本；11 类有效 `Setting` 场景表均已覆盖，`@CreateDynamicObject*` 作为备份名不算加载族。
- 对照 `Init/Item.SDB` 和玩家资料修正制造配方；补齐 AdditionalAttrib、地图二进制、NpcSetting、help 窗口、Event、ITEMLOG、根目录资源、Guild/运行数据等文档。
- 清理脚本示例中的对象名乱码，建立神武/炎黄版本标注和迁移检查规则，并确认 96 篇炎黄玩家资料均已进入目录索引。

## 已确认但未修改的程序问题

这些不是文档待猜项，且本轮按约束不改游戏源码：

- 两版 `龙师父.txt` 调用未注册的 `getjobgrade`；当前替代接口是 `getsenderjobgrade`。
- 炎黄随包三个脚本把 `say` 与正文连写，神武线上对应行反而保留了正确空格；两版 `绣球.txt` 又把普通正文直接交给 `print`，这些字符串均不会命中当前 `CommandScript`。
- `RandomEventItem` 只分配 0～2，却加载并调用编号 3；神武脚本的 4、5 也不兼容当前结构。
- `Marry.SDB` 的新记录标志初始化、离婚日期计算、保存列和姓名查询各有明确源码缺陷。
- `Event/NameList.SDB` 的存在检查与实际加载目录不一致。
- `NpcSetting` 的 `DeallerSkill.ProcessMessage` 被注释；`BadIpAddr.txt` 只加载未见拦截调用。
- `NpcFunc.SDB` 无随包数据且无消费调用；`BestMagicEnergyPoint.sdb` 加载代码被注释。

## 维护要求

原始 SDB/TXT 和线上脚本保留 GBK/CP936；Markdown 使用 UTF-8。更新说明前必须同时核对加载器、调用点和随包文件，代码缺陷应明确标为缺陷，不得用推测补成“可用功能”。
