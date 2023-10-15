## 千年TGS配置类型说明

```
   # 区域最大常数
   JOB_KIND_MAX               = 4;
   JOB_GRADE_MAX              = 6;
   ITEM_GRADE_MAX             = 10;
   ITEM_UPGRADE_MAX           = 4;

   JOB_SOUND_TRUE             = '9210';  # 职业音效：成功
   JOB_SOUND_FALSE            = '9211';  # 职业音效：失败

   # 职业种类
   JOB_KIND_NONE              = 0;   # 职业种类：无
   JOB_KIND_ALCHEMIST         = 1;   # 职业种类：铸造师
   JOB_KIND_CHEMIST           = 2;   # 职业种类：炼丹师
   JOB_KIND_DESIGNER          = 3;   # 职业种类：裁缝
   JOB_KIND_CRAFTSMAN         = 4;   # 职业种类：工匠
   JOB_KIND_SMELT             = 99;  # 职业种类：冶炼专用定义常数
   JOB_KIND_MINER             = 5;   # 职业种类：矿工

   # 职位
   JOB_GRADE_NONE             = 0;   # 职位：无
   JOB_GRADE_NAMELESSWORKER   = 1;   # 职位：初级工（经验值：100-1999）
   JOB_GRADE_TECHNICIAN       = 2;   # 职位：技能工（经验值：2000-3999）
   JOB_GRADE_SKILLEDWORKER    = 3;   # 职位：熟练工（经验值：4000-5999）
   JOB_GRADE_EXPERT           = 4;   # 职位：达人（经验值：6000-7999）
   JOB_GRADE_MASTER           = 5;   # 职位：名人（经验值：8000-9999）
   JOB_GRADE_VIRTUEMAN        = 6;   # 职位：神工（经验值：9999 完成任务） 
```

### Dynamicobject.sdb（动态对象）

#### Kind（类型）

```
# 0 无任何事件触发
# 1 被打时触发事件
# 2 添加物品时触发事件
# 4 说话时触发事件
# 3 被打和添加物品时同时触发事件
# 5 被打和说话时同时触发事件
# 6 添加物品和说话时同时触发事件
# 7 被打、添加物品和说话时同时触发事件
# 8 由火焰箭触发的事件
# 9 由事件触发的移动计时 03.03.31 saset

Kind 类别 作用
0 普通 装饰物
1 攻击 可攻击
2 拖放 可放物品
3 攻击+拖放 可放物品、攻击
4 说话 对话
5 说话+攻击 可对话、攻击
6 说话+拖放 可放入物品、对话
7 事件 可放入物品、对话、攻击
8 弓术 远程攻击
9 时间 时间段

说明 激活段（Dynamicobject.sdb）
攻击 boRandom、Damage、Life
拖放 EventItem、EventDropItem
说话 EventSay、EventAnswer
时间 ShowInterval、HideInterval

Kind=0 纯用来装饰，玩家无法攻击“动态对象”，可被脚本调用。

Kind=1 玩家可攻击“动态对象”。

Kind=2 将指定物品拖放在“动态对象”，例如：门需要钥匙，或需要某物品才能掉落指定物品。

Kind=3 综合Kind=1与2功能，即可攻击又可拖放物品到“动态对象”。

Kind=4 说话：玩家只要输入指定“内容”，“动态对象”将与你对话。
eventsay=是玩家输入，例如：设置=你好。
eventanswer=是“动态对象”回答，例如：设置=您终于来了！已经等您很久了。

聊天窗口显示：
玩家：你好
动态对象：您终于来了！已经等您很久了。

Kind=5 综合Kind=1与4功能，即可攻击又可与“动态对象”对话。

Kind=6 综合Kind=2与4功能，即可拖放物品又可与“动态对象”对话。

Kind=7 综合Kind=3与4功能。
可在NpcSetting文件夹设置"动态对象"来替换或直接取代Dynamicobject.sdb所有“Event”开头字段。
具体请参考“妖华”与"NpcSetting\妖华.txt"。

Kind=8 只能使用弓术攻击“动态对象”。

Kind=9 可攻击，受ShowInterval、HideInterval影响。
```

拖放物品仅限制EventItem指定的物品，会触发以下过程：

```pascal
procedure OnDropItem (aStr : String);
var
   Str, Name : String;
begin
   

end;
```

#### EventType

```
   DYNOBJ_EVENT_NONE    = 0;   # 动态物品事件：无
   DYNOBJ_EVENT_HIT     = 1;   # 动态物品事件：被击中
   DYNOBJ_EVENT_ADDITEM = 2;   # 动态物品事件：添加物品
   DYNOBJ_EVENT_SAY     = 4;   # 动态物品事件：说话
   DYNOBJ_EVENT_BOW     = 8;   # 动态物品事件：鞠躬
   DYNOBJ_EVENT_MOVETICK = 9;  # 动态物品事件：移动计时
```

### Event.sdb（事件）Kind（类型）

```
Kind 类别
1 召唤者
2 被召唤

Kind=1 能触发事件的对象。

Kind=2 事件触发后的对象。
```

### item.sdb（物品）

#### Kind（类型）

| Kind | Type      | 说明         | 示例   |
|------|-----------|--------------|------|
| 0    | NONE      | 无实物，技能用 | 无名火炉 |
| 1    | COLORDRUG | 染色剂 | 紫色染剂 |
| 2    | BOOK      | 书 | 太极拳 |
| 3    | GOLD      | 钱币，游戏货币 | 钱币   |
| 4    |           |              | 肉 |
| 5    |           |              | 金元 |
| 6    | WEARITEM  | 装备，包括可升级4段装备 | 长剑 |
| 7    | ARROW     | 箭 | 箭 |
| 8    | FLYSWORD | 飞刀 | 仙鹤神针 |
| 9    | GUILDSTONE | 门派石 | 门派石 |
| 10   | DUMMY | 门派娃娃 | 男子卒兵娃娃 |
| 11   | STATICITEM | 静态物品 | |
| 12   ||||
| 13   | DRUG | 药品 | 生药 |
| 14   |||| 
| 15   ||||
| 16   ||||
| 17   | | | 追魂索 |
| 18   | TICKET | 卷轴，可传送 | 回城卷轴 |
| 19   | HIDESKILL | 隐身符，可隐身 | 隐身符 |
| 20   | CANTMOVE | 无法交换的物品 | 青龙牌 |
| 21   | ITEMLOG | 福袋，储物空间 | 福袋 |
| 22   | CHANGER | | 玫瑰脱色药 |
| 23   | SHOWSKILL | 透视符，可看穿隐身 | 透视符 |
| 24   | WEARITEM2 | 类似6，装备，可升级，衣服类？ | 女子梅花战袍 |
| 25   | FOXMIRROR | | 妖华镜 |
| 26   | GUILDLETTER | 可直接加入门派 | 门人推荐书 |
| 27   | PICKAX | 挖矿工具 | 象牙十字镐 |
| 28   | MINERAL | 矿石，职业技能材料 | 黄金 |
| 29   | CAP | 类似6，装备，可升级，帽子类 | 男子流星帽 |
| 30   | PROCESSDRUG | 加工试剂 | 桂圆丹 |
| 31   | HELPDRUG | 提升加工成功率的药品 | 生死梦幻丹 |
| 32   | GROWTHHERB | 草药类材料 | 千年地黄 |
| 33   | SKILLROLLPAPER | 技术密笈，根据职业类型调用help目录对应文件 | 卷轴 |
| 34   | QUESTITEM | 任务物品，可被deletequestitem删除 | 小佛 |
| 35   | WATERCASE | 沙漠用的水桶 | 竹筒 |
| 36   | CHARM | 能增加活力的物品（自动生效），可被deletequestitem删除 | 不灭 |
| 37   | QUESTLOG | 双击查看任务，可被deletequestitem删除，可根据currentquest调用任务详情 | 书函 |
| 38   | SUBITEM | 子物品（装备特殊物品时才生效） | 太极牌 |
| 39   | NAMEDPOSQUEST | 四大宝石 | 翡翠 |
| 40   | QUESTITEM2 | 可叠加的任务物品，可被deletequestitem删除 | 石谷钥匙 |
| 41   | FILL | 定时恢复活力/内/外/武功等属性，要求地图Attribute值为MAP_TYPE_FILL | 五色药水 |
| 42   | SPECIALEFFECT | 类似太极牌和八卦牌的特殊效果物品 ||
| 43   | ADDATTRIBITEM | 增加黄字属性的物品 | 霸王灵符 |
| 44   | GOLDBAG | SpecialKind为5的任务物品，自动删除DelItem | 雨中客锦囊 |
| 45   | DAGGEROFOS | SpecialKind为5的任务物品，自动删除DelItem | 玉仙的无情双刀 |
| 46   | DUBU | 从流放地释放出来时会删除此类物品 ||
| 47   | DELATTRIBITEM | 清除物品黄字属性 | 北海冰玉 |
| 48   | TRANSMONSTER | 变身成怪物，未实现功能 ||
| 49   | RECOVERYHUMAN | 恢复成人类，未实现功能 ||
| 50   | GRADEUPQUESTITEM | 升级神功任务物品，可指定QuestNum，可由gethavegradequestitem判断 | 侠客任务卷轴 |
| 51   | DURABILITY | 所有有耐久度的物品 | 万毒钥匙 |
| 52   | TOPLETTER | 双击可以显示广播的物品 | |
| 53   | GUILDLOTTERY | 门派奖券 | |
| 54   | SET | 套装物品 | |
| 55   | DBLRANDOM | 双击随机掉落物品 | |
| 56   | USESCRIPT | 可双击调用脚本的物品，脚本由Script字段指定 | 四大神功全集 |
| 57   | HIGHPICKAX || 高级象牙十字镐 |
| 58   | SEAL | 封印符咒，可封印Kind为4的Monster | 封印符 |
| 59   | EIGHTANGLES | 类似SUBITEM和SPECIALEFFECT类型，增加玩家属性 | 八卦牌 |
| 60   | DURAWEAPON（WEARITEM_GUILD） | 有耐久度的武器 | 不羁浪人剑 |
| 61   | ScripterSay | 脚本物品 ||
| 100  | WEARITEM_FD| 时装 ||
| 120  | GuildAddLife | 门派加血石头 ||
| 121  | 121 | 宝石 镶嵌，SpecialKind 表示等级 ||
| 130  | 130 | 精炼 石头 ||
| 131  | LifeData_item | 可以吃的附加属性 ||
| 132  | 132 | 精炼 辅助石 rSpecialKind 类型 ||
| 133  | QUEST | 任务物品 ||
| 134  | GOLD_D | 代币 | |
| 200  | EVENT1 | 事件物品1，加工窗口中加工时可以获得随机物品 | |

> kind非常重要，ITEM_KIND_WEARITEM, ITEM_KIND_WEARITEM2, ITEM_KIND_CAP, ITEM_KIND_PICKAX, ITEM_KIND_HIGHPICKAX, ITEM_KIND_DURAWEAPON 都是可装备物品

#### Attribute（属性）

```
   ITEM_ATTRIBUTE_NONE              = 0;  # 物品属性：无
   ITEM_ATTRIBUTE_FIRE              = 1;  # 物品属性：火属性
   ITEM_ATTRIBUTE_WATER             = 2;  # 物品属性：水属性
   ITEM_ATTRIBUTE_ICE               = 3;  # 物品属性：冰属性
   ITEM_ATTRIBUTE_FILL              = 4;  # 物品属性：填充（增加活力、内力、外力、武功）
   ITEM_ATTRIBUTE_SET               = 5;  # 物品属性：套装
   ITEM_ATTRIBUTE_DIRECT            = 6;  # 物品属性：直接放入物品栏（不会掉落地上） 040422 saset
   ITEM_ATTRIBUTE_PAPERBESTPROTECT  = 7;  # 物品属性：防护卷轴
   ITEM_ATTRIBUTE_PAPERBESTSPECIAL  = 8;  # 物品属性：特殊卷轴
   ITEM_ATTRIBUTE_QUESTSIGN         = 9;  # 物品属性：任务标志（无效）
   ITEM_ATTRIBUTE_TAEGUK            = 199;  # 物品属性：太极
   ITEM_ATTRIBUTE_LOWEST            = 201;  # 物品属性：最低
   ITEM_ATTRIBUTE_LOWEER            = 202;  # 物品属性：更低
   ITEM_ATTRIBUTE_NORMAL            = 203;  # 物品属性：正常
   ITEM_ATTRIBUTE_HIGHER            = 204;  # 物品属性：更高
   ITEM_ATTRIBUTE_HIGHEST           = 205;  # 物品属性：最高
```

#### SpecialKind（特殊类型）

```
   ITEM_SPKIND_NONE           = 0;   # 物品特殊种类：无
   ITEM_SPKIND_MUNJANG        = 1;   # 物品特殊种类：属性灵符（工匠）
   ITEM_SPKIND_ZANGSIK        = 2;   # 物品特殊种类：属性饰品（裁缝）
   ITEM_SPKIND_JUMOON         = 3;   # 物品特殊种类：属性卷轴（铸造）
   ITEM_SPKIND_GOLBANG        = 4;   # 物品特殊种类：可以制作其他物品的物品（玩家可以@item 指令制造）
   ITEM_SPKIND_DELALLBYDURA   = 5;   # 物品特殊种类：当耐久度全耗尽时，连同delitem中指定的物品一起消失
   ITEM_SPKIND_DONTDRUG       = 6;   # 物品特殊种类：由炼丹师制作的药，不能服用
   ITEM_SPKIND_ADDALLLIFE     = 7;   # 物品特殊种类：从Item.sdb文件中的cLife字段中的一个数值，增加头部、手部、脚部的HP
   ITEM_SPKIND_1              = 8;   # 物品特殊种类：珍珠
   ITEM_SPKIND_2              = 9;   # 物品特殊种类：翡翠
   ITEM_SPKIND_3              = 10;  # 物品特殊种类：水晶
   ITEM_SPKIND_4              = 11;  # 物品特殊种类：琥珀
```

### magic.sdb（武功）Kind（类型）

```
Kind 类别
1 凌波微步
2 血天魔功
3 日月神功
4 紫霞神功
5 北冥神功

激活段（magic.sdb）
RelationProtect、SameSection

对应派系（同种）：RelationProtect=增加武功属性
相同派系（同类）：SameSection=无附加属性
异类派系：没有填写=降低武功属性
```

### Map.sdb（地图）

### Attribute

```
   MAP_TYPE_ICE   = 1;   # 地图类型：冰属性（装备火属性物品不掉活力）
   MAP_TYPE_FIRE  = 2;   # 地图类型：火属性（装备冰属性物品不掉活力）
   MAP_TYPE_FILL  = 3;   # 地图类型：新手村（带五色药水增加活力、内力、外力、武功）
   MAP_TYPE_BATTLE      = 4;   # 地图类型：大战场（击败对手比赛）
   MAP_TYPE_DONTTICKET  = 5;   # 地图类型：无法使用传送符的区域
   MAP_TYPE_KILLONLYONE = 6;   # 地图类型：只能击败一个指定的怪物...
   MAP_TYPE_GUILDBATTLE = 7;   # 地图类型：门派大战 - 只能吃一种药（中国活动）
   MAP_TYPE_POWERLEVEL  = 8;   # 地图类型：境界等级小于2级会消耗活力
   MAP_TYPE_SPORTBATTLE = 9;   # 比武大会结束
```

### Monster.sdb（魔物）

#### Kind（类型）

```
   MOP_KIND_NONE        = 0;   # 怪物行为种类：无
   MOP_KIND_AUTOCALL    = 1;   # 怪物行为种类：每几秒自动召唤一次
   MOP_KIND_AUTODIE     = 2;   # 怪物行为种类：每几秒自动死亡一次
   MOP_KIND_NEWSKILL    = 3;   # 怪物行为种类：应用新的修炼值公式的怪物
   MOP_KIND_SEAL        = 4;   # 怪物行为种类：由于被封印的九尾狐的原因
```

### CreateGate.sdb（传送门）

- X,Y设置为(0,0)，使用RandomPos指定坐标
- shape 为item.atz中的形状，主要是69和70，也可以使用其它值

#### Kind

```
   GATE_KIND_NORMAL        = 0;   # 传送门种类：普通传送门
   GATE_KIND_BS            = 1;   # 传送门种类：对战传送门
   GATE_KIND_DOOR          = 2;   # 传送门种类：门
   GATE_KIND_SPECIALTIME   = 3;   # 传送门种类：特定时间开启的传送门
   GATE_KIND_FIXPOSITION   = 4;   # 传送门种类：固定位置的传送门
   GATE_KIND_ORDERADDITEM  = 5;   # 传送门种类：过门后赠送前三名的物品（物品由AddItem参数指定）
   GATE_KIND_LIMITUSER     = 6;   # 传送门种类：限制进入人数（活动）
   GATE_KIND_GUILDWAR      = 7;   # 传送门种类：门派大战040307
   GATE_KIND_FIXTIME       = 8;   # 传送门种类：只在特定时间内开启
   GATE_KIND_SPORTSWAR     = 9;   # 传送门种类：竞技场战斗
   GATE_KIND_INTOZHUANG    = 10;  # 传送门种类：进入聚贤庄
```

### CreateVirtualObject.sdb（创建虚拟对象）Kind（类型）

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