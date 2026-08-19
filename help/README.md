# 千年开发指南

本目录中包括了TGS核心代码、炎黄新章游戏资料、游戏开发文档，游戏开发手册。

## 常量定义

游戏常量（物品类型、武功分类、职业品级、地图类型等）详见 [constants/ 目录](constants/README.md)。

## 资料说明

### Init目录

Init目录中包含了游戏初始化的数据文件，包括物品、NPC、魔物、地图、武功、任务索引等。

#### Dynamicobject.sdb（动态对象）

游戏中动态物品（不可移动但可互交物品）对象数据库，具体内容见[Init_DynamicObject.Sdb.md](Init_DynamicObject.Sdb.md)

#### Event.sdb（事件）

事件主要有2类，魔物死亡触发或动态物品被摧毁触发，触发效果为在地图上增加Mop和NPC，具体见[Init_Event.SDB.md](Init_Event.SDB.md)

#### EventParam.sdb（事件参数）

和Event.sdb对应，用于描述事件参数，具体见[Init_Event.SDB.md](Init_Event.SDB.md)

#### Item.sdb（物品）

这是游戏中所有物品的数据文件，包括物品的属性、物品的描述、物品的图标等。具体介绍见[Init_Item.sdb.md](Init_item.sdb.md)

#### JobUpgrade.sdb（升段）

升段成功率相关算法

```pascal
   case aItemData.rMaxUpgrade of
      3 : Rate := JobClass.GetItemUpgradeSuccessRate (aUpgrade);
      4 : Rate := JobClass.GetItemUpgradeDungeonRate (aUpgrade);
      else exit;
   end;

   SuccessCount := Rate + (Rate * aSubDrugRate div 100);   // 基础成功率 + 辅助药品成功率
   RandomCount := Random (100);
   if RandomCount < SuccessCount then begin
      // 加工成功
   end else begin
      // 加工失败
   end;
```

#### magic.sdb（武功）

游戏中所有武功的数据文件，包括武功的属性、武功的描述等。具体介绍见[Init_Magic.sdb.md](Init_magic.sdb.md)

#### Map.sdb（地图）

这里是游戏所有地图的配置文件，包括地图的编号、地图的属性等。具体介绍见[Init_Map.sdb.md](Init_map.sdb.md)

#### Monster.sdb（魔物）

游戏中所有魔物的数据文件，包括魔物的属性、魔物的描述等。具体介绍见[Init_Monster.sdb.md](Init_monster.sdb.md)

### Setting目录

Setting目录中包含了游戏设置相关的数据文件，包括地图上生成NPC、魔物、矿物、传送门、动态对象、虚拟对象等。

#### CreateGate.sdb 和 CreateGateEx.SDB

游戏中所有传送点的配置数据，具体介绍见[CreateGate.SDB.md](CreateGate.SDB.md)

#### CreateGroupMove.sdb

游戏中集体传送的配置数据，具体介绍见[CreateGroupMove.sdb.md](CreateGroupMove.sdb.md)

#### CreateDynamicObject%d.sdb

游戏场景中动态物品的配置数据，具体介绍见[CreateDynamicObject.sdb.md](CreateDynamicObject.SDB.md)

#### CreateMonster%d.SDB

游戏场景中魔物的配置数据，具体介绍见[CreateMonster.SDB.md](CreateMonster.SDB.md)

#### CreateNpc%d.SDB

游戏场景中NPC的配置数据，具体介绍见[CreateNpc.SDB.md](CreateNpc.SDB.md)

#### CreateSoundObject.sdb

设置场景音效，声音文件在客户端`wav\effect.atw`中。

Name|SoundName|MapID|X|Y|PlayInterval
---|---|---|---|---|---
音效名称|音效文件名|地图ID|X坐标|Y坐标|播放间隔

#### CreateVirtualObject.sdb（创建虚拟对象）

虚拟对象，主要是水池等恢复效果区域，具体介绍见[CreateVirtualObject.sdb.md](CreateVirtualObject.sdb.md)

### 服务端Smp

south.sma - 长城以南地图属性：/where显示内容

## 游戏开发指南

千年游戏脚本使用的是Pascal语言，脚本在Script目录，开发示例见[Script.md](Script.md)

基本结构如下：

```pascal
unit Script;

interface

// Function and procedure declarations go here

implementation

// Procedure implementations go here

end.
```

具体开发细节参考以下项目

- https://github.com/oiuv/1000yPascal.git

当脚本有错时会在tgs1000目录中生成错误日志，如：

```
// Error-帝王石谷药材商-onleftclick.log
#callfunc str #nn1
#strtoint race str
#notequal #nn3 race #nn2
#notifgoto #nn3 #nn4
#exit
#label #nn4
#callfunc str #nn5
#strtoint nvirtue str
```
