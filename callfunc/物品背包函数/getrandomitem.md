# getrandomitem

## 功能

从 `Event/RandomEventItemN.sdb` 对应的随机池抽取一项。

```pascal
Item := callfunc('getrandomitem 0');
```

参数是池编号，不是由源码定义的“品质等级”。当前随包说明把 0、1、2、3 分别用于新手村比武、中央比武、活动和犀牛猎人奖励。

## 返回值

成功时返回 `物品名:数量`，可直接拼入 `putsendermagicitem`：

```pascal
Item := callfunc('getrandomitem 0');
if Item <> '' then begin
   Cmd := 'putsendermagicitem ' + Item + ' @一级比武老人 4';
   print(Cmd);
end;
```

源码没有为非法编号、空列表或未覆盖的随机区间提供可靠失败保护，不能依赖其稳定返回空串。

## 随机表规则

加载器读取 `ItemName`、`Kind`、`ItemCount`、`TotalRandom` 和 `MaxValue`，忽略 `randomrate`。它以首行 `MaxValue` 为随机上限，并按 `TotalRandom` 累计阈值选择记录。列表必须非空，阈值应递增并覆盖完整随机范围。

## 当前版本风险

当前 `DataList` 仅声明 0～2，但加载循环和随包数据包含编号 3，`犀牛猎人.txt` 也调用 3；这是确认的源码/随包越界矛盾。神武线上脚本还使用 4、5，那是旧版程序行为，不能迁移到当前炎黄接口。

详细文件对应关系见 [Event 运行数据](../../help/Event.md)。源码依据：`uScriptManager.pas` 的 `getrandomitem` 分派及 `svClass.pas` 的 `TRandomEventItemList`。
