# CreateGate.SDB

传送门

- Kind见下文详细介绍
- Kind为GATE_KIND_FIXPOSITION时TX和TY设置为0，调用BattleMap.sdb中的坐标，由ActiveInterval指定对战时间
- Shape 为item.atz中的形状，主要是8、69和70，也可以使用其它值
- X,Y设置为(0,0)，使用RandomPos指定坐标，随机坐标刷新时间由ActiveInterval指定
- LimitPowerLevel为境界限制，超过境界的玩家进入后境界被限制到该值
- NeedAge为需要年龄，必须超过该年龄才能进入，否则进一步判断AgeNeedItem条件并由boRemainItem决定是否删除物品
- 如果没有设置NeedAge，只设置了AgeNeedItem是无效的
- 符合NeedAge条件还会继续判断以下年龄限制
  - LimitAge为年龄上限，超过该年龄无法进入
  - OverAge为年龄下限，低于该年龄无法进入
- 如果没有设置NeedAge和AgeNeedItem，只设置NeedItem，则有指定物品即可传送，且传送不会删除物品
- NeedItem、DelItem、AddItem最多可设置5种
- DelItem为传送自动删除的物品（有则删除，无则不影响）
- AddItem为GATE_KIND_ORDERADDITEM的奖励设置
- Quest值为3种：1=歼灭怪物，2=步法超过85，3=年龄小于20岁
- RegenInterval为传送门重新激活时间，一般设置目标地图刷新时间一至
- ActiveInterval为传送门生效状态时间，常和RegenInterval配合使用
- OpenClock可设置开启时间在几点（最多5个），Kind为GATE_KIND_SPECIALTIME(用`8:30/10:30`指定时间)、GATE_KIND_FIXPOSITION、GATE_KIND_FIXTIME、GATE_KIND_SPORTSWAR(用`8:10:12:14`指定小时)
- MaxUser限制Kind为GATE_KIND_SPORTSWAR时指定活动人数上限

#### Kind

```
   GATE_KIND_NORMAL        = 0;   # 传送门种类：普通传送门
   GATE_KIND_BS            = 1;   # 传送门种类：对战服务器传送门（单独的服务器）
   GATE_KIND_DOOR          = 2;   # 传送门种类：门
   GATE_KIND_SPECIALTIME   = 3;   # 传送门种类：特定时间开启的传送门（时间获取不对，1899/12/30）
   GATE_KIND_FIXPOSITION   = 4;   # 传送门种类：固定位置的对战传送门（MAP_TYPE_BATTLE）
   GATE_KIND_ORDERADDITEM  = 5;   # 传送门种类：过门后赠送物品（物品由AddItem参数指定第1、2名和3以后的奖励）
   GATE_KIND_LIMITUSER     = 6;   # 传送门种类：限制进入人数（固定上限10人，超过提示参赛人员已满，可设置RegenInterval）
   GATE_KIND_GUILDWAR      = 7;   # 传送门种类：门派对战，和4类似，但判断玩家门派（MAP_TYPE_GUILDBATTLE）
   GATE_KIND_FIXTIME       = 8;   # 传送门种类：只在特定小时开启
   GATE_KIND_SPORTSWAR     = 9;   # 传送门种类：竞技场战斗（炎黄版本）（MAP_TYPE_SPORTBATTLE）
   GATE_KIND_INTOZHUANG    = 10;  # 传送门种类：进入聚贤庄（炎黄版本）
```

# CreateGateEx.SDB

随机传送门