# Event 运行数据

本页描述炎黄新章源码实际加载的 `Event/` 数据。神武奇章线上脚本可证明旧版本的调用方式，但参数编号不能直接套用到当前程序。

## 当前随包文件

| 文件 | 当前加载情况 | 用途 |
|---|---|---|
| `BattleMap.sdb` | 启动加载 | 对战地图的两方位置、人数和传送信息 |
| `RandomEventItem0.sdb`～`3.sdb` | 源码尝试加载 | `getrandomitem` 的随机物品池 |
| `RandomEventItem.sdb` | 未被该加载器读取 | 随包保留文件，不能当作无编号默认池 |
| `Marry.sdb` | 启动加载、正常析构时保存 | 婚姻运行数据 |
| `EventItem1.sdb`～`4.sdb` | 当前随包不存在 | 职业制造抽奖的可选奖励表 |
| `TransMonsterList.sdb` | 当前随包不存在 | 可选的随机变身怪物名表 |

文本 SDB 延续随包的 GBK/CP936 编码。

## BattleMap.sdb

实际表头为 `No,MapID,PosX,PosY,GroupKey,MaxUser,DynName,TargetID,TargetX,TargetY,DieX,DieY,GuildName,MopName,`。`No` 只作行索引，其余字段均由 `TBattleMapList` 读取。

同一 `MapID` 必须至少有两行。`SetBattleMapData` 找到匹配行后直接取第 1、2 行，没有“只有一行”的保护；多余行也不会成为第三方队伍。修改后应核对双方出生点、死亡点、人数上限及目标地图坐标。

## RandomEventItem*.sdb

`getrandomitem N` 直接选择编号为 `N` 的池，返回 `物品名:数量`。当前随包 `ReadMe.txt` 的用途标注为：0 新手村比武奖励、1 中央比武高级奖励、2 活动奖励、3 犀牛猎人奖励。加载器读取 `ItemName`、`Kind`、`ItemCount`、`TotalRandom`、`MaxValue`，不读取表中的 `randomrate`。

抽取时以首行 `MaxValue` 生成随机数，再按各行累计阈值 `TotalRandom` 命中。因此列表不能为空，阈值应递增并覆盖 `0..MaxValue-1`，所有物品名还应存在于当前 `Init/Item.SDB`。

> **已确认的源码/数据矛盾：** `TRandomEventItemList.DataList` 只声明并初始化 0～2 三个列表，加载循环却访问 0～3；炎黄随包的 `犀牛猎人.txt` 又调用编号 3。编号 3 会发生越界访问，不能把“文件存在”写成安全可用。神武线上脚本还调用 4、5，更属于旧程序接口，迁移时必须改表或修正程序后再验证。

物品 `Kind=55` 的双击路径固定从池 0 抽取，不使用物品表中的其他池编号。

## Marry.sdb

字段为 `Girl,Boy,Party,GirlClothes,BoyClothes,MarryDate,UnMarry,UnMarryDate,BoyUnMarry,GirlUnMarry`。它是运行数据，不是静态模板；服务正常结束时会用内存状态整体覆盖文件。

当前源码存在四处已确认风险：

- `AddMarry` 新建记录时没有清零或赋值 `BoyUnMarry`、`GirlUnMarry`，两项初值不确定；
- `UnMarry` 把日期设为 `Now + 7`，完成判断又要求 `Now - UnMarryDate >= 7`，按代码实际需要约 14 天；
- 保存时把 `MarryDate` 写进 `UnMarryDate` 列，正常退出后会丢失原离婚日期；
- `Search` 同时要求姓名等于男方和女方，普通婚姻记录无法命中。

这些是源码行为，不应靠手改 SDB 掩盖。在线维护前先停服并备份；需要婚姻功能稳定时应单独修复、编译并回归测试程序。

## 可选但未部署的表

`EventItem1.sdb`～`4.sdb` 的加载字段为 `ItemName,ItemCount,Width`，供职业制造奖励路径使用；`TransMonsterList.sdb` 每行读取 `Name` 并要求名称存在于 `Monster.SDB`。当前随包均无这些文件，因此不能宣称相关奖励池或随机变身已配置。

源码还检查 `Event/NameList.SDB`，却实际从 `EtcSetting/NameList.SDB` 加载；当前随包两处都不存在。这一名单功能按现状没有可用数据路径。

源码依据：`svClass.pas` 的 `TBattleMapList`、`TRandomEventItemList`、`TEventItemClass`、`TTransMonsterListClass`、`TNameClass` 和 `TMarryClass`，以及 `uUserSub.pas`。
