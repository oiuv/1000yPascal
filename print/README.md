# Print 命令总览

## 概述

Print 是千年游戏脚本系统中的命令执行机制，通过 `print('命令 参数1 参数2 ...')` 的格式执行服务器端的操作命令。Print 命令会直接执行动作，而不是返回值。

## 调用格式

```pascal
print('命令名 参数1 参数2 参数3 ...');
```

- **返回值**：无 - Print 命令执行动作，不返回结果
- **参数**：通过空格分隔，不同命令的参数格式和数量不同
- **空格处理**：参数文本内容中的空格需要用下划线 `_` 代替，系统会自动转换

## 重要说明

1. **命令执行**：Print 命令会立即执行相应的动作
2. **参数分隔**：不同参数用空格分隔
3. **空格处理**：参数文本内容中的空格需要用下划线 `_` 代替，系统会自动转换
4. **错误处理**：命令执行失败时不会有返回值，脚本继续执行
5. **参数格式**：严格按照源码中定义的格式传递参数

## 基础使用示例

```pascal
// 让NPC说话 - 注意：文本中的空格用下划线代替
print('say 你不需要药吗?');

// 显示窗口 - 参数1：文件路径，参数2：模式
print('showwindow .\help\help.txt 1');

// 给予物品 - 参数1：物品名:数量，参数2：物品归属者，参数3：归属者种族
print('putsendermagicitem 神医丹药:1 @quest神医 4');

// 发送聊天消息 - 参数1：消息内容，参数2：颜色
print('sendsenderchatmessage 操作成功！ 1');

// 复杂文本示例 - 文本中的空格用下划线
print('say 霸王剑式_能够刺中敌人的要害');
```

## 真实游戏脚本示例

以下是从实际游戏脚本中收集的 print 使用示例，按功能分类：

### 对话消息相关示例
```pascal
// NPC说话
print('say 霸王剑式_能够刺中敌人的要害');
print('say 领教了吧! 50');

// 指定NPC说话
print('saybyname 太极老人 npc 不胜感激... 100');

// 发送聊天消息
print('sendsenderchatmessage 不能使用辅助武功');
print('sendsenderchatmessage 南帝王任务结束了 2');
print('sendsenderchatmessage 你物品栏已满，未能获得过关奖品... 1');

// 全服公告
print('sendnoticemsgformapuser 70 雨中客_有人侵入王陵 15');

// 地区效果消息
print('sendzoneeffectmsg 陷阱区1');
```

### 物品交易相关示例
```pascal
// 给予玩家物品
print('putsendermagicitem 龙虎灵符:2 @上古雨中客 3');

// 回收玩家物品
print('getsenderitem 黄金钥匙:1');
print('getsenderitem2 三叉剑:1');
print('getsenderallitem 东海野兽王内丹');

// 删除任务物品
print('deletequestitem');

// 提炼物品
print('sendersmeltitem 千年水晶');
print('sendersmeltitem2 月石');

// 物品耐久调整
print('changesendercurdurabyname 大型竹筒 0');
print('changesendercurdurabyname 竹筒 0');

// 物品重生
print('checkitemregen 生肉 100 84 10 60');
```

### 玩家操作相关示例
```pascal
// 传送移动
print('gotoxy 20 16');
print('reposition');

// 移动玩家
print('movespacebyname 彼岸花 NPC 98 99 133');

// 状态恢复
print('senderrefill');

// 设置职业
print('setsenderjobkind 1');
print('setsenderjobkind 2');
print('setsenderjobkind 3');
print('setsenderjobkind 4');

// 设置神工等级
print('setsendervirtueman');

// 设置结婚服装
print('setmarryclothes');

// 武功升级
print('usemagicgradeup 0 1');
print('usemagicgradeup 0 2');
print('usemagicgradeup 1 1');
print('usemagicgradeup 1 2');
```

### 地图场景相关示例
```pascal
// 地图进入检查
print('boMapEnter 32 false');
print('boMapEnter 32 true');

// 地图挖掘检查
print('bopickbymapname 地下采石场2层 false');
print('bopickbymapname 地下采石场2层 true');

// 地图对象管理
print('mapaddobjbyname dynamicobject 迷宫门 281 83');
print('mapaddobjbyname dynamicobject 妖华 37 50 4 0 false');
print('mapaddobjbyname monster 大力兽魔王 103 55 10 0 false');
print('mapaddobjbytick monster 上古雨中客2 178 176 1 97 false 800');
print('mapdelobjbyname monster 东天王魂1');

// 地图刷新
print('mapregen 32');
print('regen 爆破酒坛 dynamicobject');
print('regen 地下石巨人 monster');

// 地图通知
print('sendnoticemsgformapuser 70 雨中客_有人侵入王陵 15');
```

### 系统控制相关示例
```pascal
// 动力物体状态
print('changedynobjstate 石棺洞入口 false');
print('changedynobjstate 石棺洞入口 true');
print('changesenderdynobjstate 石棺洞入口 false');
print('changesenderdynobjstate 石棺洞入口 true');

// 攻击设置
print('bohitallbyname 地下石巨人 monster false');
print('bohitallbyname 地下石巨人 monster true');
print('setallowhitbyname 一级捕盗大将 monster true');
print('setallowhitbytick true 500');

// 暂停控制
print('commandicebyname 一级捕盗大将 npc 1000');
print('commandice');

// 删除设置
print('setallowdelete dynamicobject 妖华');
print('setallowdelete monster 死狼女实像');

// 清理工作
print('clearworkbox');

// 银行操作
print('activebank');
print('buymoneychip');
```

### 任务系统相关示例
```pascal
// 任务状态修改
print('changesendercompletequest 100');
print('changesendercurrentquest 100');
print('changesenderfirstquest 1');
print('changesenderqueststr 1');

// 任务时间控制
print('startmissiontime');
print('getpassmissiontime');
```

### 界面和特效相关示例
```pascal
// 显示窗口
print('showwindow .\help\event龙师父.txt 1');
print('showwindow .\help\quest捕盗大将1.txt 0');

// 显示特效
print('showeffect 22 1');

// 播放声音
print('sendsound 9170.wav 31');

// 结婚系统
print('marry 请输入您要求婚的对象');
print('unmarry 您的配偶希望跟您解除婚约');
```

## Print 命令参考列表

以下是在游戏脚本中发现的print命令，按字母顺序排列，可作为快速参考：

### 完整命令列表
- `activebank` - 激活银行功能
- `addaddablestatepoint` - 增加玩家真气值
- `addtotalstatepoint` - 增加总数状态点
- `attack` - 攻击目标
- `bohitallbyname` - 是否打击目标
- `boiceallbyname` - 是否冷冻目标
- `boMapEnter` - 地图进入处理
- `bopickbymapname` - 是否挖掘的地图
- `buymoneychip` - 购买筹码
- `changecompletequest` - 改变已完成任务
- `changecurrentquest` - 改变当前任务
- `changedynobjstate` - 改变动力物体状态
- `changefirstquest` - 改变首要任务
- `changestate` - 改变状态
- `changesendercompletequest` - 修改玩家已完成任务
- `changesendercurdurabyname` - 改变物品耐久
- `changesendercurrentquest` - 修改玩家当前任务
- `changesenderdynobjstate` - 改变玩家动力物体状态
- `changesenderfirstquest` - 修改玩家第一个任务
- `changesenderqueststr` - 修改玩家任务字符串
- `changequeststr` - 改变任务参数
- `checkitemregen` - 检查物品重生
- `clearworkbox` - 清空工作箱
- `commandice` - 暂停
- `commandicebyname` - 暂停指定目标
- `decreasePrisonTime` - 减少监狱时间
- `deletequestitem` - 删除任务物品
- `directmovespace` - 改变指定Npc的位置
- `getsenderallitem` - 回收玩家指定物品所有
- `getsenderitem` - 回收玩家物品
- `getsenderitem2` - 获取玩家物品2
- `gotoxy` - 传送到指定坐标
- `logitemwindow` - 打开福袋窗口
- `mapaddobjbyname` - 本地图中加入某目标
- `mapaddobjbytick` - 规定时间后加入某目标
- `mapdelobjbyname` - 删除本地图某目标
- `mapregen` - 地图重置
- `mapregenbyname` - 刷新地图2
- `marry` - 结婚
- `movespace` - 本体移动玩家
- `movespacebyname` - 指定生物移动玩家
- `reposition` - 重新定位
- `regen` - 刷新
- `returndamage` - 返弹伤害
- `say` - 本体说话
- `saybyname` - 指定目标说话
- `selfchangedynobjstate` - 改变本体状态
- `selfkill` - 自杀
- `sendcentermsg` - 在某玩家屏幕中间显示通告
- `sendersmeltitem` - 提炼物品
- `sendersmeltitem2` - 提炼物品2
- `senderrefill` - 三功补满
- `sendnoticemsgformapuser` - 向某地图发布通知
- `sendsenderchatmessage` - 发送给玩家聊天信息
- `sendsendertopmsg` - 全服左上角公告
- `sendsound` - 播放音乐
- `sendzoneeffectmsg` - 获得地区效果
- `setallowdelete` - 使允许被删除
- `setallowhit` - 使允许被攻击
- `setallowhitbyname` - 是否允许被攻击
- `setallowhitbytick` - 规定时间后是否能被攻击
- `setautomode` - 设定自动方式
- `setmarryclothes` - 设置结婚服装
- `setsenderjobkind` - 给予技能种类
- `setsendervirtueman` - 给予玩家神工等级
- `showeffect` - 显示魔法
- `showwindow` - 打开指定help文件
- `startwindow` - 系统打开help文件
- `tradewindow` - 调出买卖窗口
- `unmarry` - 解除婚约
- `usemagicgradeup` - 武功升级

## 命令分类

### 对话消息命令
控制NPC说话和发送各种消息。

### 系统命令
执行各种系统级别的操作。

### 玩家操作命令
对玩家状态、位置等进行操作。

### 物品交易命令
处理物品给予、获取等操作。

### 地图传送命令
处理地图切换、位置移动等。

### 系统控制命令
控制游戏系统的各种行为。

---

## 详细命令文档

按功能分类的详细命令说明，请查看各分类目录：

- [对话消息命令](对话消息命令/)
- [系统命令](系统命令/)
- [玩家操作命令](玩家操作命令/)
- [物品交易命令](物品交易命令/)
- [地图传送命令](地图传送命令/)
- [系统控制命令](系统控制命令/)