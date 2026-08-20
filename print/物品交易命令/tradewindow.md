# tradewindow

## 功能与语法

让脚本自身 NPC 为指定玩家打开普通商店或 Sale 商店窗口。

```pascal
print('tradewindow 玩家角色名 模式');
```

| 参数 | 类型 | 说明 |
|---|---|---|
| 玩家角色名 | String | `TNpc.STradeWindow` 用它在全局 `UserList` 查找窗口接收者；通常来自 `getsendername` |
| 模式 | Integer | 只处理 0、1、3、4，其他值无动作 |

## 模式与配置

| 模式 | 所需技能 | 读取列表 | 打开方法 |
|---:|---|---|---|
| 0 | `TBuySellSkill` | `SELLITEM` / `GetSellItemString` | `User.TradeWindow` |
| 1 | `TBuySellSkill` | `BUYITEM` / `GetBuyItemString` | `User.TradeWindow` |
| 3 | `TSaleSkill` | `SALEITEM` / `GetSellItemString` | `User.SaleWindow` |
| 4 | `TSaleSkill` | `SALEITEM` 对应的 `GetBuyItemString` | `User.SaleWindow` |

普通模式的标题、说明和图片分别来自 `SELL*` 或 `BUY*` 配置；Sale 模式使用 `SALETITLE`、`SALECAPTION`、`SALEIMAGE`。源码没有把模式命名成“玩家买入/卖出”，文档应按实际配置分支描述，避免因视角不同把含义写反。

## 示例

```pascal
Name := callfunc('getsendername');
Cmd := 'tradewindow ' + Name + ' 0';
print(Cmd);
```

命令在 `aSelf` 上执行，所以 `Self` 必须是已加载相应商店技能的 NPC；玩家不存在或技能未配置时直接返回。配置字段与重载限制见 [NpcSetting 配置](../../help/NpcSetting.md)。

源码依据：`uScriptManager.pas` 的 `tradewindow` 分派、`uNpc.pas` 的 `TNpc.STradeWindow` 和 `uSkills.pas` 的商店加载器。
