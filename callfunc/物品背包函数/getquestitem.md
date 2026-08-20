# getquestitem

## 功能

从 `QuestNotice/` 中指定的任务奖励池随机抽取一项。

```pascal
Item := callfunc('getquestitem 1');
```

## 参数对应

| 编号 | 当前加载文件 |
|---|---|
| 1 | `QuestItem_1stBeginnerPrize.sdb` |
| 2 | `QuestItem_1stPrize.sdb` |
| 3 | `QuestItem_2ndPrize.sdb` |
| 4 | `QuestItem_GoldCoin.sdb` |
| 5 | `QuestItem_PickAx.sdb` |
| 6 | `QuestItem_AttributePiece.sdb` |
| 7 | `QuestItem_Weapon.sdb` |

该映射同时由炎黄源码常量、加载分支和随包 `QuestNotice/ReadMe.txt` 证明。

## 返回值与随机规则

成功时返回 `物品名:数量`，不是单独的物品名。各表读取 `ItemName`、`ItemCount`、`TotalRandom` 和 `MaxValue`；抽取以首行 `MaxValue` 为上限，再按累计阈值 `TotalRandom` 命中。

```pascal
Item := callfunc('getquestitem 4');
if Item <> '' then begin
   Cmd := 'putsendermagicitem ' + Item + ' @任务奖励 4';
   print(Cmd);
end;
```

非法编号会走空分支，但有效编号对应的列表为空时源码仍会直接访问第 1 项；随机阈值未覆盖完整范围时也没有可靠保护。部署前应确认文件存在、列表非空、物品名存在于 `Init/Item.SDB`，且累计阈值覆盖 `0..MaxValue-1`。

完整配置说明见 [QuestNotice 任务公告与奖励](../../help/QuestNotice.md)。源码依据：`uScriptManager.pas` 的 `getquestitem` 分派及 `svClass.pas` 的 `TRandomEventItemList.GetQuestItembyRandom`。
