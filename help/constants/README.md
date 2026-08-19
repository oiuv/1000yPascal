# 游戏常量定义参考手册

> 源码位置: `1000ydef/deftype.pas` (3967行)

本文档整理了千年游戏中所有关键常量定义，按功能分类组织。

---

## 📑 目录

| 文档 | 内容 |
|------|------|
| [ITEM_KIND.md](ITEM_KIND.md) | 物品类型常量 (60+种) |
| [ITEM_ATTRIBUTE.md](ITEM_ATTRIBUTE.md) | 物品属性常量 |
| [ITEM_SPKIND.md](ITEM_SPKIND.md) | 物品特殊类型 |
| [MAGICCLASS.md](MAGICCLASS.md) | 武功分类 |
| [MAGICTYPE.md](MAGICTYPE.md) | 武功类型 |
| [MAGIC_KIND.md](MAGIC_KIND.md) | 武功门派 |
| [JOB.md](JOB.md) | 职业种类与品级 |
| [RACE_CLASS.md](RACE_CLASS.md) | 种族与对象分类 |
| [MAP_GATE.md](MAP_GATE.md) | 地图类型与传送门类型 |
| [WINDOW.md](WINDOW.md) | 窗口类型常量 |
| [MESSAGES.md](MESSAGES.md) | 消息类型 (SM/CM/FM) |

---

## 快速查阅

### 物品系统
- **物品类型**: `ITEM_KIND_*` — 定义物品的功能和行为
- **物品属性**: `ITEM_ATTRIBUTE_*` — 火/水/冰/套装等属性
- **物品特殊类型**: `ITEM_SPKIND_*` — 纹章/装饰/珠宝等

### 武功系统
- **武功分类**: `MAGICCLASS_*` — 基本/上升/酒术/绝世
- **武功类型**: `MAGICTYPE_*` — 拳/剑/刀/枪/锤/弓等
- **武功门派**: `MAGIC_KIND_*` — 正派/邪派各2种

### 职业系统
- **职业种类**: `JOB_KIND_*` — 炼金/炼丹/服饰/匠人/矿工
- **职业品级**: `JOB_GRADE_*` — 无名工→功能工→熟练工→达人→名人→大人

### 地图与对象
- **地图类型**: `MAP_TYPE_*` — 冰/火/初学/战斗等
- **传送门类型**: `GATE_KIND_*` — 普通/特殊时间/限制人数等
- **种族**: `RACE_*` — 人类/物品/怪物/NPC/动态对象
- **对象分类**: `CLASS_*` — 人类/怪物/NPC/物品/动态对象等

### UI 与通信
- **窗口类型**: `WINDOW_*` — 物品/装备/魔法/交易等
- **消息类型**: `SM_*` (服务端) / `CM_*` (客户端) / `FM_*` (场景)

---

## 源码位置

所有常量定义在 `1000ydef/deftype.pas` 文件中，按以下顺序组织：

1. **包消息定义** (PACKET_*) — 第 8-15 行
2. **游戏消息** (GM_SM_*/GM_CM_*) — 第 17-35 行
3. **国家版本** (NATION_*) — 第 37-48 行
4. **游戏容量** (HAVE*SIZE) — 第 56-67 行
5. **说话颜色** (SAY_COLOR_*) — 第 87-101 行
6. **物品类型** (ITEM_KIND_*) — 第 105-170 行
7. **物品属性** (ITEM_ATTRIBUTE_*) — 第 172-193 行
8. **魔物类型** (MOP_KIND_*) — 第 205-210 行
9. **传送门类型** (GATE_KIND_*) — 第 212-223 行
10. **地图类型** (MAP_TYPE_*) — 第 229-241 行
11. **职业系统** (JOB_KIND_*/JOB_GRADE_*) — 第 259-283 行
12. **武功系统** (MAGICCLASS_*/MAGICTYPE_*) — 第 293-360 行
13. **种族与分类** (RACE_*/CLASS_*) — 第 395-420 行
14. **窗口类型** (WINDOW_*) — 第 960-1020 行
15. **消息类型** (SM_*/CM_*/FM_*) — 第 700-1100 行
