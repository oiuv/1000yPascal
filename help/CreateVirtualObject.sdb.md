# CreateVirtualObject%d.sdb

创建地图中的虚拟物品，如水池，用于回血等。文件中的`%d`为地图编号。

### Kind（类型）

```
Kind 类别 作用
1 绿洲 物品
2 药水池 玩家
3 王陵药水 数值

Kind=1 对Item.sdb文件Kind=35产生效果。

Kind=2 对玩家产生效果，按数值恢复状态条。（500=5.00）

Kind=3 对Item.sdb文件Kind=35产生效果，按数值补充。

   VIRTUALOBJ_KIND_NONE       = 0;   # 虚拟物品种类：无
   VIRTUALOBJ_KIND_OASIS      = 1;   # 虚拟物品种类：帝王石窟的沙漠绿洲
   VIRTUALOBJ_KIND_FILLLIFE   = 2;   # 虚拟物品种类：新手村，增加活力、内力、外力、武功
   VIRTUALOBJ_KIND_FILLOASISLIFE = 3;  # 虚拟物品种类：安全区，增加活力、内力、外力、武功、元气

```
