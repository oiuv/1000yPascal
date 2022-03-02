## 千年TGS配置类型说明

### Dynamicobject.sdb（动态对象）Kind（类型）

```
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

### CreateVirtualObject.sdb（创建虚拟对象）Kind（类型）

```
Kind 类别 作用
1 绿洲 物品
2 药水池 玩家
3 王陵药水 数值

Kind=1 对Item.sdb文件Kind=35产生效果。

Kind=2 对玩家产生效果，按数值恢复状态条。（500=5.00）

Kind=3 对Item.sdb文件Kind=35产生效果，按数值补充。
```

### Event.sdb（事件）Kind（类型）

```
Kind 类别
1 召唤者
2 被召唤

Kind=1 能触发事件的对象。

Kind=2 事件触发后的对象。
```