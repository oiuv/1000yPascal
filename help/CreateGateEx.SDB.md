# CreateGateEx.SDB

`Setting/CreateGateEx.SDB` 由 `TGateListEx.LoadFromFile` 加载，用于创建扩展传送门。它与 `CreateGate.sdb` 的表头和加载器不同，不应混用字段。

## 字段

| 字段 | 实际加载行为 |
| --- | --- |
| `Name` | SDB 行索引；对象内部名称实际取 `GateName` |
| `GateName`、`ViewName`、`Kind`、`Shape` | 对象名称、显示名、门类型和形状 |
| `MapId`、`X`、`Y` | 所在地图与坐标 |
| `TX`、`TY` | 对象的目标坐标成员 |
| `EX`、`EY` | 不能进入或门未激活时的弹出坐标 |
| `TargetServerID0..4`、`TargetX0..4`、`TargetY0..4` | 最多 5 组目标地图及坐标 |
| `boRandom`、`RandomCount`、`RandomTotal` | 随机目标开关、随机抽取次数和目标循环总数 |
| `boCondition`、`Condition` | 条件分流开关及条件字符串；当前处理代码按冒号拆分后用剩余部分与玩家年龄比较，在目标 0、1 间选择 |
| `Width` | 触发区域宽度参数 |
| `NeedAge`、`AgeNeedItem` | 年龄门槛。年龄未达 `NeedAge` 时，只有达到 `AgeNeedItem` 且持有全部 `NeedItem` 才通过；通过该替代条件时物品会被删除 |
| `NeedItem` | 重复的 `物品名:数量`，最多 5 组 |
| `Quest`、`QuestNOtice` | 任务检查编号和失败提示。表头拼写为 `QuestNOtice`，加载器按 `QuestNotice` 查询 |
| `RegenInterval`、`ActiveInterval` | 重新激活与保持激活的 tick 间隔 |
| `EjectNotice` | 拒绝进入时的提示；为空时发送程序内置提示 |

## 目标选择

- `boRandom=true` 时，加载器按 `RandomCount` 构造目标序列，并以 `RandomTotal` 控制 0..4 配置项的循环。
- `boRandom=false` 时仍会读取全部 5 组目标。
- 当前 `GATE_KIND_NORMAL` 处理代码分别执行随机分支和条件分支；若两个开关同时为真，二者不会互斥。配置时应避免无意同时启用。

## 校验依据

- 表头：`gameserver-tgs1000/bin/Setting/CreateGateEx.sdb`
- 加载与运行逻辑：`gameserver-tgs1000/BasicObj.pas` 的 `TGateListEx.LoadFromFile`、`TGateObjectEx.FieldProc`
