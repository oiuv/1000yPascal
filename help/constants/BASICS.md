# 游戏基础常量

> 源码: `1000ydef/deftype.pas`

本文档整理了游戏中的基础容量、尺寸、版本等常量。

---

## 版本信息

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `PROGRAM_VERSION` | 40 | 程序版本号 |

## 国家版本 (NATION_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `NATION_KOREA` | 1 | 韩国 |
| `NATION_TAIWAN` | 2 | 台湾 |
| `NATION_CHINA_1` | 3 | 中国大陆 |
| `NATION_TAIWAN_TEST` | 4 | 台湾测试 |
| `NATION_CHINA_1_TEST` | 5 | 中国测试 |
| `NATION_KOREA_TEST` | 6 | 韩国测试 |

通过条件编译 `_CHINA` / `_TAIWAN` 确定 `NATION_VERSION`。

---

## 容量限制

### 背包与物品

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `HAVEITEMSIZE` | 30 | 背包物品格数 |
| `HAVEMATERIALITEMSIZE` | 5 | 材料栏格数 |
| `HAVEMARKETITEMSIZE` | 10 | 个人商店栏格数 |
| `MONEYMAX` | 61000 | 金钱上限 |

### 武功容量

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `HAVEBASICMAGICSIZE` | 20 | 基本武功最大数量 |
| `HAVEMAGICSIZE` | 30 | 普通武功最大数量 |
| `HAVEMAGICRISESIZE` | 30 | 上升武功最大数量 |
| `HAVEMYSTERYMAGICSIZE` | 30 | 酒浆法武功最大数量 |
| `HAVEBESTSPECIALMAGICSIZE` | 15 | 绝世超式武功最大数量 |
| `HAVEBESTPROTECTMAGICSIZE` | 5 | 绝世公力武功最大数量 |
| `HAVEBESTATTACKMAGICSIZE` | 5 | 绝世必杀武功最大数量 |
| `TOTALBESTMAGICNUM` | 25 | 绝世武功总数上限 |

### 视野与地图

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `VIEWRANGEWIDTH` | 10 | 视野宽度（格） |
| `VIEWRANGEHEIGHT` | 8 | 视野高度（格） |

### 名称长度

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `NAME_SIZE` | 19 | 角色名最大字节数（韩文9字/中文9字） |
| `CAPTION_SIZE` | 40 | 标题最大字节数（韩文20字/中文20字） |

---

## 游戏参数

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `DEFAULTEXP` | 10000 | 事件获得的基本经验值 |
| `OBJECTUPDATETICK` | 20 | 怪物/NPC 更新的最小 TICK 间隔 |
| `BOSSVIRTUEVALUE` | 10000 | BOSS 道德值 |
| `STARTNEWID` | 10000 | 新 ID 起始值 |
| `USERMANAGERPOST` | 1000 | 用户管理器端口偏移 |
| `FIELDPOST` | 100 | 场景端口偏移 |
| `MAXCONDITIONCOUNT` | 3 | 最大条件计数 |
| `SAVE_USERDATA_DELAY_TIME` | 75000 | 用户数据保存延迟（5×60×100 = 5分钟，单位10ms） |

---

## 电话/邮递系统

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `NOTARGETPHONE` | 0 | 无目标电话 |
| `MANAGERPHONE` | 1 | 管理器电话 |

---

## 效果开关

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `EFFECT_OFF` | 0 | 效果关闭 |
| `EFFECT_ON` | 1 | 效果开启 |

## 战斗效果类型

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `BTEFFECT_KIND_NONE` | 0 | 无战斗效果 |
| `BTEFFECT_KIND_DECLIFE` | 1 | 减少生命效果 |

---

## 事件类型 (EVENTKIND_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `EVENTKIND_NONE` | 0 | 无事件 |
| `EVENTKIND_DIE_DYNOBJ` | 1 | 动态对象死亡事件 |
| `EVENTKIND_DIE_MOP` | 2 | 怪物死亡事件 |

---

## 默认武功索引 (DEFAULT_*)

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `DEFAULT_WRESTLING` | 0 | 拳法 |
| `DEFAULT_FENCING` | 1 | 剑法 |
| `DEFAULT_SWORDSHIP` | 2 | 刀法 |
| `DEFAULT_HAMMERING` | 3 | 锤法 |
| `DEFAULT_SPEARING` | 4 | 枪法 |
| `DEFAULT_BOWING` | 5 | 弓术 |
| `DEFAULT_THROWING` | 6 | 投掷 |
| `DEFAULT_RUNNING` | 7 | 轻功 |
| `DEFAULT_BREATHNG` | 8 | 呼吸 |
| `DEFAULT_PROTECTING` | 9 | 护身 |

---

## 魔法书图标

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `MAGIC_BOOK_ICON` | 53 | 武功秘籍图标编号 |

---

## 关闭原因 (RET_CLOSE_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `RET_CLOSE_NONE` | 0 | 无 |
| `RET_CLOSE_RUNNING` | 1 | 轻功关闭 |
| `RET_CLOSE_BREATHNG` | 2 | 呼吸关闭 |
| `RET_CLOSE_ATTACK` | 3 | 攻击关闭 |
| `RET_CLOSE_PROTECTING` | 4 | 护身关闭 |
| `RET_CLOSE_BESTSPECIAL` | 5 | 绝世超式关闭（2003-10） |
| `RET_CLOSE_ECTMAGIC` | 6 | 其他武功关闭 |
| `RET_CLOSE_BESTPROTECT` | 7 | 绝世公力关闭 |

---

## 选择武功结果 (SELECTMAGIC_RESULT_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `SELECTMAGIC_RESULT_FALSE` | -1 | 失败 |
| `SELECTMAGIC_RESULT_NONE` | 0 | 无 |
| `SELECTMAGIC_RESULT_NORMAL` | 1 | 正常 |
| `SELECTMAGIC_RESULT_SITDOWN` | 2 | 坐下 |
| `SELECTMAGIC_RESULT_RUNNING` | 3 | 跑步中 |

---

## 拖放动作 (DRAGACTION_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `DRAGACTION_NONE` | 0 | 无 |
| `DRAGACTION_ADDEXCHANGEITEM` | 15 | 添加到交换 |
| `DRAGACTION_DROPITEM` | 2 | 丢弃物品 |
| `DRAGACTION_FROMITEMTOLOG` | 16 | 物品→日志 |
| `DRAGACTION_FROMLOGTOITEM` | 17 | 日志→物品 |
| `DRAGACTION_FROMITEMTOTRADE` | 18 | 物品→交易 |
| `DRAGACTION_FROMTRADETOITEM` | 19 | 交易→物品 |
| `DRAGACTION_FROMITEMTOSKILL` | 20 | 物品→制造 |
| `DRAGACTION_FROMSKILLTOITEM` | 21 | 制造→物品 |
| `DRAGACTION_FROMITEMTOSALE` | 22 | 物品→商店 |
| `DRAGACTION_FROMSALETOITEM` | 23 | 商店→物品 |
| `DRAGACTION_SMELTITEM` | 24 | 冶炼物品 |
| `DRAGACTION_SMELTITEM2` | 25 | 冶炼交换 |
| `DRAGACTION_FROMINDIVIDUALMARKETTOITEM` | 26 | 个人购买→物品 |
| `DRAGACTION_FROMGUILDTOITEM` | 27 | 门派→物品 |
| `DRAGACTION_FROMITEMTOGUILD` | 28 | 物品→门派 |

---

## 挂起状态 (HANGON_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `HANGON_NONE` | 0 | 无挂起 |

---

## 结果码

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `INTRESULT_FALSE` | -1 | 整数结果-假 |
| `INTRESULT_ARREADY` | -2 | 已存在 |
| `PROC_TRUE` | 0 | 过程-成功 |
| `PROC_FALSE` | -1 | 过程-失败 |
| `PROC_ARREAY` | -2 | 过程-已存在 |
| `PROC_DONTDROP` | -3 | 过程-禁止丢弃（门派初石不能扔地上） |
| `UPDATE_TRUE` | 0 | 更新-成功 |
| `UPDATE_FALSE` | -1 | 更新-失败 |

---

## 相关文档

- [README.md](README.md) — 常量定义总览
