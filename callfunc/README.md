# CallFunc 函数总览

## 概述

CallFunc 是千年游戏脚本系统中的核心函数调用机制，通过 `callfunc('参数1 参数2 ...')` 的格式调用服务器端的查询函数，返回字符串格式的结果。

## 调用格式

```pascal
Str := callfunc('函数名 参数1 参数2 参数3 ...');
```

- **返回值**：String - 所有 callfunc 函数都返回字符串结果
- **参数**：通过空格分隔，部分函数支持带空格的参数（如物品名用冒号分隔）

## 重要说明

1. **字符串参数处理**：部分函数的参数中包含空格时，需要用下划线 `_` 代替空格，系统会自动转换
2. **返回值格式**：所有函数都返回字符串，通常需要使用 `StrToInt()` 转换为数值
3. **错误处理**：函数调用失败时通常返回空字符串或特定错误码（如 'false'）
4. **参数格式**：严格按照源码中定义的格式传递参数

## 基础使用示例

```pascal
// 获取玩家名称
player_name := callfunc('getsendername');

// 获取玩家等级并转换为整数
level_str := callfunc('getsenderage');
level := StrToInt(level_str);

// 检查武功使用状态
magic_status := callfunc('checksendercurusemagic 0');
if magic_status = 'true' then
begin
    // 玩家正在使用武功
end;
```

## 真实游戏脚本示例

以下是从实际游戏脚本中收集的 callfunc 使用示例，按功能分类：

### 地图场景相关示例
```pascal
// 检查指定地图中存活怪物数量
Str := callfunc ('checkalivemopcount 96 monster 蜘蛛女王B');

// 检查是否可以进入指定地图
Str := callfunc ('checkentermap 87');

// 检查地图中特定对象存活状态
Str := callfunc ('checkobjectalive 北海雪原 dynamicobject 被捆绑的北霸王');
Str := callfunc ('checkobjectalive 北海雪原 monster 北霸王魂1');

// 获取地图剩余时间
Str := callfunc ('getremainmaptime 5 0');

// 获取当前地图用户数量
Str := callfunc ('getusercount 97');
```

### 武功技能相关示例
```pascal
// 检查玩家当前使用的武功类型
Str := callfunc ('checksendercurusemagic 0');  // 普通武功攻击
Str := callfunc ('checksendercurusemagic 1');  // 超级武功攻击
Str := callfunc ('checksendercurusemagic 2');  // 护身武功
Str := callfunc ('checksendercurusemagic 3');  // 攻击武功
Str := callfunc ('checksendercurusemagic 4');  // 高级护身武功
Str := callfunc ('checksendercurusemagic 5');  // 特殊护身武功
Str := callfunc ('checksendercurusemagic 6');  // 绝世攻击武功

// 按等级检查绝世武功使用情况
Str := callfunc ('checkusemagicbygrade 5 0 -1');
Str := callfunc ('checkusemagicbygrade 5 1 -1');
Str := callfunc ('checkusemagicbygrade 6 0 0');
Str := callfunc ('checkusemagicbygrade 6 0 1');
Str := callfunc ('checkusemagicbygrade 6 0 2');
Str := callfunc ('checkusemagicbygrade 6 0 3');
Str := callfunc ('checkusemagicbygrade 6 0 4');
Str := callfunc ('checkusemagicbygrade 6 1 0');
Str := callfunc ('checkusemagicbygrade 6 1 1');
Str := callfunc ('checkusemagicbygrade 6 1 2');
Str := callfunc ('checkusemagicbygrade 6 1 3');
Str := callfunc ('checkusemagicbygrade 6 1 4');

// 检查特定武功的使用条件
Str := callfunc ('checkmagic 3 9 北冥神功');
Str := callfunc ('checkmagic 3 9 日月神功');
Str := callfunc ('checkmagic 3 9 血天魔功');
Str := callfunc ('checkmagic 3 9 紫霞神功');

// 检查绝世武功条件
Str := callfunc ('conditionbestattackmagic 凤凰雷电戟');
Str := callfunc ('conditionbestattackmagic 寒阴指');
Str := callfunc ('conditionbestattackmagic 金刚指');
Str := callfunc ('conditionbestattackmagic 金蛇剑法');
Str := callfunc ('conditionbestattackmagic 狂风刀法');
Str := callfunc ('conditionbestattackmagic 六脉神剑');
Str := callfunc ('conditionbestattackmagic 罗汉刀法');
Str := callfunc ('conditionbestattackmagic 蓉沼抉');
Str := callfunc ('conditionbestattackmagic 乌龙索命枪');
Str := callfunc ('conditionbestattackmagic 五狐断刎槌');
Str := callfunc ('conditionbestattackmagic 玉霄剑法');
Str := callfunc ('conditionbestattackmagic 昭巫枪法');
```

### 物品背包相关示例
```pascal
// 检查背包空间
Str := callfunc ('checkenoughspace');
Str := callfunc ('checkenoughspace 4');

// 检查玩家属性物品
Str := callfunc ('checksenderattribitem 9');

// 检查玩家装备的力量属性物品
Str := callfunc ('checksenderpowerwearitem');

// 获取物品数量
Str := callfunc ('getsenderitemcountbyname 侠客指环');

// 检查物品存在性
Str := callfunc ('getsenderitemexistence 装雪参的筐:1');

// 按种类检查物品存在性
Str := callfunc ('getsenderitemexistencebykind 59');
Str := callfunc ('getsenderitemexistencebykind 60 1');

// 获取装备物品名称
Str := callfunc ('getsenderwearitemname 6');

// 获取拾取检查状态
Str := callfunc ('getcheckpickup');

// 物品销毁和修理
Str := callfunc ('getsenderdestroyitem 0 59');
Str := callfunc ('getsenderdestroyitem 9 60');
Str := callfunc ('getsenderrepairitem 0 59');
Str := callfunc ('getsenderrepairitem 9 27');
Str := callfunc ('getsenderrepairitem 9 60');
```

### 任务系统相关示例
```pascal
// 获取任务状态
Str := callfunc ('getcompletequest');
Str := callfunc ('getcurrentquest');
Str := callfunc ('getsenderfirstquest');
Str := callfunc ('getsendercurrentquest');
Str := callfunc ('getsendercompletequest');
Str := callfunc ('getsenderqueststr');

// 获取任务物品
Str := callfunc ('getquestitem 1');
Str := callfunc ('getquestitem 2');
Str := callfunc ('getquestitem 3');
Str := callfunc ('getquestitem 5');
Str := callfunc ('getquestitem 6');
Str := callfunc ('getquestitem 7');

// 检查等级任务物品
Str := callfunc ('gethavegradequestitem');

// 任务计时
Str := callfunc ('getpassmissiontime');
Str := callfunc ('startmissiontime');
```

### 玩家属性相关示例
```pascal
// 基础属性
Str := callfunc ('getsendername');
Str := callfunc ('getsenderage');
Str := callfunc ('getsenderrace');
Str := callfunc ('getsendersex');
Str := callfunc ('getsendertalent');
Str := callfunc ('getsendervirtue');
Str := callfunc ('getsenderposition');
Str := callfunc ('getsenderlife');

// 职业相关
Str := callfunc ('getsenderjobgrade');
Str := callfunc ('getsenderjobkind');
Str := callfunc ('getjobgrade');

// 力量等级
Str := callfunc ('getsendercurpowerlevel');
Str := callfunc ('getsendercurpowerlevelname');

// 服务器信息
Str := callfunc ('getsenderserverid');

// 状态信息
Str := callfunc ('getsendercurdurawatercase');

// 通用获取函数
Str := callfunc ('getname');
Str := callfunc ('getrace');
Str := callfunc ('getlife');
Str := callfunc ('getmarryclothes');
Str := callfunc ('getmarryinfo');
```

### 事件和系统相关示例
```pascal
// 事件状态
Str := callfunc ('getevent 0');
Str := callfunc ('getevent 1');
Str := callfunc ('getevent 2');
Str := callfunc ('getsetevent 0');
Str := callfunc ('getsetevent 1');
Str := callfunc ('getsetevent 2');

// 竞技场相关
Str := callfunc ('getintoarena 0');
Str := callfunc ('getstartarena');

// 山庄相关
Str := callfunc ('getintozhuang');
Str := callfunc ('getzhuangfight');
Str := callfunc ('getzhuangticketprice');

// 组队系统
Str := callfunc ('getparty');
Str := callfunc ('setparty');

// 随机系统
Str := callfunc ('getrandomitem 0');
Str := callfunc ('getrandomitem 1');
Str := callfunc ('getrandomitem 3');

// 等级和可能等级
Str := callfunc ('getpossiblegrade 0 0');
Str := callfunc ('getpossiblegrade 0 1');
```

## CallFunc 函数参考列表

以下是在游戏脚本中发现的所有callfunc函数，按字母顺序排列，可作为快速参考：

### 完整函数列表
- `checkalivemopcount` - 检查指定地图中存活怪物数量
- `checkenoughspace` - 检查玩家背包是否有足够空位
- `checkentermap` - 检查是否可以进入指定地图
- `checkmagic` - 检查武功使用条件
- `checkobjectalive` - 检查地图中对象存活状态
- `checksenderattribitem` - 检查玩家属性物品
- `checksendercurusemagic` - 检查玩家当前使用的武功
- `checksenderpowerwearitem` - 检查玩家装备的力量属性物品
- `checkusemagicbygrade` - 按等级检查武功使用情况
- `conditionbestattackmagic` - 检查绝世武功条件
- `getcheckpickup` - 获取拾取检查状态
- `getcompletequest` - 获取完成的任务
- `getcurrentquest` - 获取当前任务
- `getevent` - 获取事件状态
- `getfirstquest` - 获取第一个任务
- `gethavegradequestitem` - 获取等级任务物品状态
- `getintoarena` - 获取竞技场进入状态
- `getintozhuang` - 获取山庄进入状态
- `getjobgrade` - 获取职业等级
- `getlife` - 获取生命值
- `getmarryclothes` - 获取结婚服装信息
- `getmarryinfo` - 获取结婚信息
- `getname` - 获取名称
- `getparty` - 获取组队信息
- `getpassmissiontime` - 获取通过任务时间
- `getpossiblegrade` - 获取可能等级
- `getquestitem` - 获取任务物品
- `getrace` - 获取种族
- `getrandomitem` - 获取随机物品
- `getremainmaptime` - 获取地图剩余时间
- `getsenderage` - 获取玩家年龄/等级
- `getsendercompletequest` - 获取玩家完成的任务
- `getsendercurdurawatercase` - 获取玩家当前毒水状态
- `getsendercurpowerlevel` - 获取玩家当前力量等级
- `getsendercurpowerlevelname` - 获取玩家当前力量等级名称
- `getsendercurrentquest` - 获取玩家当前任务
- `getsenderdestroyitem` - 获取玩家销毁物品信息
- `getsenderfirstquest` - 获取玩家第一个任务
- `getsenderitemcountbyname` - 按名称获取物品数量
- `getsenderitemexistence` - 检查物品存在性
- `getsenderitemexistencebykind` - 按种类检查玩家物品存在性
- `getsenderjobgrade` - 获取玩家职业等级
- `getsenderjobkind` - 获取玩家职业类型
- `getsendername` - 获取玩家名称
- `getsenderposition` - 获取玩家位置
- `getsenderqueststr` - 获取玩家任务字符串
- `getsenderrace` - 获取玩家种族
- `getsenderrepairitem` - 获取玩家修理物品信息
- `getsenderserverid` - 获取玩家服务器ID
- `getsendersex` - 获取玩家性别
- `getsendertalent` - 获取玩家天赋
- `getsendervirtue` - 获取玩家品德
- `getsenderwearitemname` - 获取玩家装备物品名称
- `getsetevent` - 获取设置事件状态
- `getstartarena` - 获取竞技场开始状态
- `getusercount` - 获取用户数量
- `getzhuangfight` - 获取山庄战斗状态
- `getzhuangticketprice` - 获取山庄门票价格
- `setparty` - 设置组队状态
- `startmissiontime` - 开始任务计时

## 函数分类

### 玩家属性函数
获取玩家的基本信息、状态和属性值。

### 武功技能函数
检查和使用武功相关的功能，包括武功等级、使用状态等。

### 物品背包函数
操作和查询玩家的物品和背包信息。

### 任务系统函数
管理和查询任务相关的状态信息。

### 地图场景函数
处理地图、位置和场景相关的查询。

### 系统工具函数
提供各种系统级别的工具和查询功能。

---

## 详细函数文档

按功能分类的详细函数说明，请查看各分类目录：

- [玩家属性函数](玩家属性函数/)
- [武功技能函数](武功技能函数/)
- [物品背包函数](物品背包函数/)
- [任务系统函数](任务系统函数/)
- [地图场景函数](地图场景函数/)
- [系统工具函数](系统工具函数/)