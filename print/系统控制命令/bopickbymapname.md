# bopickbymapname

按地图标题设置 `Manager.boPick`。

## 语法

```pascal
print('bopickbymapname <地图标题> <true|false>');
```

命令作用对象是 `aSelf`。`SboPickbyMapName` 通过 `ManagerList.GetManagerByTitle` 查找地图；找不到时直接返回。第二个参数只有精确的小写 `true`、`false` 会分别写入 `Manager.boPick`，其他值不产生修改。

```pascal
print('bopickbymapname 地下采石场2层 false');
```

源码能确认的是 `boPick` 标志的设置，不应仅凭命令名扩展解释为所有采集行为或推断某个 Boss 事件的设计意图。
