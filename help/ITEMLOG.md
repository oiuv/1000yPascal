## ITEMLOG

服务端ITEMLOG为福袋数据库，记录了玩家福袋物品，文件名为ItemLog.BIN，文件格式为二进制。

使用GM指令 `@保存福袋库` 保存到文件ITEMLOG.SDB，文件格式为文本。

如果存在目录Backup，则每日会自动备份福袋数据到目录Backup中。

ITEMLOG.SDB和Backup目录下的文件格式相关代码如下：

```pascal
    rdstr := StrPas (@LogData.ItemData[j].Name) + ':' +
        IntToStr (LogData.ItemData[j].Color) + ':' +
        IntToStr (LogData.ItemData[j].Count) + ':' +
        IntToStr (LogData.ItemData[j].CurDurability) + ':' +
        IntToStr (LogData.ItemData[j].Durability) + ':' +
        IntToStr (LogData.ItemData[j].UpGrade) + ':' +
        IntToStr (LogData.ItemData[j].AddType) + ':' +
        IntToStr (LogData.ItemData[j].rLockState) + ':' +
        IntToStr (LogData.ItemData[j].runLockTime);
    if rdstr = ':0:0:0:0:0:0:0:0' then rdstr := '';
```
