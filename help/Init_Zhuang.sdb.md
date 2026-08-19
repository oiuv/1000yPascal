# Zhuang.sdb

山庄配置文件，记录山庄的占领门派和门票价格信息。这是一个运行时动态读写的配置文件。

## 文件路径

```
.\Init\Zhuang.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| MasterGuildName | String | 占领山庄的主门派名称 | `GuildName := DB.GetFieldValueString(iName, 'MasterGuildName')` → `MasterGuild := GuildList.GetGuildObject(GuildName)` |
| SlaveGuildName | String | 附属门派1名称 | `SlaveGuild[0] := GuildList.GetGuildObject(GuildName)` |
| SlaveGuildName1 | String | 附属门派2名称 | `SlaveGuild[1] := GuildList.GetGuildObject(GuildName)` |
| SlaveGuildName2 | String | 附属门派3名称 | `SlaveGuild[2] := GuildList.GetGuildObject(GuildName)` |
| SlaveGuildName3 | String | 附属门派4名称 | `SlaveGuild[3] := GuildList.GetGuildObject(GuildName)` |
| TicketPrice | Integer | 进入山庄的门票价格 | `SetTicketPrice` / `GetTicketPrice` |

### 山庄机制

- 山庄是一个门派争夺的据点，由一个主门派和最多4个附属门派控制
- 山庄内有旗帜（ZhuangFlag）动态对象，旗帜生命值为 5000000，防御为 1000
- 当旗帜被摧毁时，占领门派被清除，所有非本门派成员被踢出山庄
- 门票价格由占领门派的掌门设置
- 该文件在服务器启动时加载，在山庄状态变化时自动保存

### 门票价格设置

只有占领门派的掌门（GuildSysop）可以设置门票价格。

## 数据示例

当前配置为空（无门派占领）：
```
MasterGuildName,SlaveGuildName,SlaveGuildName1,SlaveGuildName2,SlaveGuildName3,TicketPrice
,,,,,50000
```

默认门票价格为 50000。

## 相关源码

- `uZhuang.pas` — `TZhuangObject` 类完整实现
- `uZhuang.pas` — `SaveToFile`（第 243 行）
- `uZhuang.pas` — `LoadFromFile`（第 263 行）
- `uZhuang.pas` — `SetTicketPrice/GetTicketPrice`（第 64/71 行）
- `uZhuang.pas` — `isZhuangMaster`（第 76 行）
- `uZhuang.pas` — `GetZhuangInto`（第 86 行）
- `UUser.pas` — 山庄进入/门票设置逻辑（第 7994-8015 行、第 5225-5228 行）
