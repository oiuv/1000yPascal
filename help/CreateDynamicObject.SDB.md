# CreateDynamicObject%d.SDB

按地图服务器编号创建动态对象，例如箱子、可破坏机关或脚本对象。`%d` 使用 `Manager.ServerID`；以 `@CreateDynamicObject*.sdb` 命名的文件不会被这条加载路径读取。

## 数据结构

当前有效表头为：

```text
No,Name,Script,NeedAge,NeedSkill,NeedItem,GiveItem,DropItem,DropMop,CallNpc,X,Y,DropX,DropY,Width,boDelay
```

| 字段 | 类型 | 说明 |
|------|------|------|
| No | String/Integer | SDB 记录索引；加载器只用于遍历记录 |
| Name | String | 动态对象名称，必须能在 `Init/DynamicObject.sdb` 找到 |
| Script | Integer | `Script/Script.SDB` 编号；大于 0 时绑定 |
| NeedAge | Integer | 开启对象所需最低年龄 |
| NeedSkill | String | `武功名:等级`，最多 5 组 |
| NeedItem | String | `物品名:数量`，最多 5 组；验证通过后删除 |
| GiveItem | String | `物品名:数量:随机权重`，最多 5 组；权重小于等于 0 时按 1 处理 |
| DropItem | String | `物品名:数量:随机权重`，最多 5 组 |
| DropMop | String | `怪物名:数量`，最多 5 组 |
| CallNpc | String | `NPC名:数量`，最多 5 组 |
| X / Y | String | 冒号分隔的坐标列表，各最多解析 5 个值 |
| DropX / DropY | Integer | 怪物和 NPC 的固定召唤坐标；任一为 0 时改在对象附近寻找可移动位置 |
| Width | Integer | 对象创建/作用范围 |
| boDelay | Boolean | `FALSE` 时加载后立即 `StartProcess`；`TRUE` 时只创建并加入列表，不在加载阶段启动 |

## 运行注意

- `Name` 无法在 `DynamicObject.sdb` 解析时，整条记录不会加入对象列表。
- `NeedSkill`、物品、怪物和 NPC 名称都会先回查各自当前数据表；无效名称不会形成有效运行数据。
- `GiveItem` 和 `DropItem` 的随机权重会登记到 `RandomClass`。如果相关 `EventDropItem` 流程引用了对象/物品却没有对应概率数据，运行日志会出现 `Random Chance Not Found`。
- 对象被攻击致死前会依次执行年龄、武功和物品条件；条件通过后才删除 `NeedItem`、推进对象步骤并发放物品。

## 源码依据

- `svClass.pas` — `LoadCreateDynamicObject`
- `BasicObj.pas` — `TDynamicObjectList.ReLoadFromFile`、`TDynamicObject.CommandAttackedMagic`
- `1000ydef/deftype.pas` — `TCreateDynamicObjectData`
