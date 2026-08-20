# NpcSetting 配置

`NpcSetting/` 保存 NPC 商店和发言/交换数据。当前炎黄随包包含 37 个 `.txt` 和 44 个 `.sdb`，但不同文件类型的加载入口与实际可达功能不同。

## 商店 TXT

`Init/NPC.SDB` 中 `boSeller=true` 时，服务器把 `NpcText` 作为文件名交给 `TBuySellSkill`。支持的键为：

- `SELLITEM`、`BUYITEM`
- `SELLTITLE`、`SELLCAPTION`、`SELLIMAGE`
- `BUYTITLE`、`BUYCAPTION`、`BUYIMAGE`

每行使用 `键:值`。物品名必须能在当前 `Item.SDB` 找到，否则该行不会加入列表。

`boSale=true` 使用 `TSaleSkill` 读取同一个 `NpcText`，其文件键是 `SALEITEM`、`SALETITLE`、`SALECAPTION`、`SALEIMAGE`。不要把 `SALE*` 与普通 `SELL*` 混用。

## 发言与交换 SDB

Setting 的 `CreateNpc` 可传入 `BookName`，NPC 会用它同时加载 `TSpeechSkill` 和 `TDeallerSkill`：

- `boSelfSay=true`：读取 `SayString`、`DelayTime`，NPC 按行循环自动发言。
- 其他行：读取 `HearString`、`SayString`、`NeedItem`、`GiveItem`；物品串最多 5 组 `名称:数量`，非正数量被修正为 1。

当前 `TNpc.FieldProc` 中 `DeallerSkill.ProcessMessage` 调用被整段注释，实际玩家说话只进入脚本 `OnHear`。因此非 `boSelfSay` 的交换行虽然被加载，但在当前源码流程中没有生效证据。`CountLimit`、`RecoverTime` 等未见上述加载器读取的列也不能按字段名推断用途。

## 重载与编码

NPCSETTING 重载路径只刷新匹配 NPC 的 `<NPC名>.txt` 普通买卖表和 `<NPC名>.sdb` 自动发言表；它不刷新 `SaleSkill` 或 `DeallerSkill`，并且文件名与 `NpcText/BookName` 不一致时可能不是原加载文件。

所有原始配置按 GBK 保存。修改前核对 `NPC.SDB`、对应 `CreateNpc%d.SDB` 和实际文件名，复杂变更优先停服验证。

源码依据：`uNpc.pas` 的 `TNpc.Initial`、`ReLoadFromNpcSetting`，以及 `uSkills.pas` 的四个技能加载器。
