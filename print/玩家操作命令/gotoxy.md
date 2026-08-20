# gotoxy

让脚本对象 `aSelf` 向当前地图内的指定坐标移动。

## 语法

```pascal
print('gotoxy <X> <Y>');
```

`X`、`Y` 通过 `_StrToInt` 转为整数，随后以 `CMD_GOTOXY` 压入 `aSelf` 的工作队列。生命对象执行该命令时调用 `GotoXyStand(X, Y)`；它不是跨地图传送命令，也不直接作用于 `aSender`。

```pascal
print('gotoxy 100 200');
```

坐标是否可达由移动寻路逻辑处理。源码没有为该脚本命令附加“安全区”“等级”“权限”或固定功能坐标规则，配置值必须来自对应地图和实际脚本。
