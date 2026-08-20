# setoutzhuang

## 功能与语法

把触发脚本玩家的聚贤庄状态标记为离开。

```pascal
print('setoutzhuang');
```

无参数。源码直接执行：

```pascal
TUser(aSender).inZhuang := False;
```

该命令只修改 `inZhuang` 标志，不负责传送、发放物品或更新门派关系；必须在 `aSender` 确实为 `TUser` 的玩家事件中调用。
