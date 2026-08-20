# setsenderjobkind

设置当前触发玩家的职业类型，并重置其职业成长数据。

## 语法

```pascal
print('setsenderjobkind <Kind>');
```

| 值 | `game.ini` 默认职业名 |
| ---: | --- |
| 1 | 铸造师（`JOB_KIND_ALCHEMIST`） |
| 2 | 炼丹师（`JOB_KIND_CHEMIST`） |
| 3 | 裁缝（`JOB_KIND_DESIGNER`） |
| 4 | 工匠（`JOB_KIND_CRAFTSMAN`） |

`TUser.SSetJobKind` 只接受 1..`JOB_KIND_MAX`（4）；0 和其他值直接忽略，不能用本命令取消职业。成功设置时，`THaveJobClass.SetJobKind` 会把职业天赋重置为 0、重新计算职业等级，并按新职业工具更新工作音效。

由于该命令会重置天赋，脚本必须先完成自己的资格和确认流程。
