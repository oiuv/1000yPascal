# getnearxy

让脚本自身对象所在地图修正一组坐标，并返回修正结果。

## 语法

```pascal
XY := callfunc('getnearxy <X> <Y>');
```

`X`、`Y` 经 `_StrToInt` 转换后传给 `TBasicObject(FSelf).SGetNearXY`。该方法调用当前 `Maper.GetNearXY(xx, yy)`，再返回：

```text
X_Y
```

```pascal
XY := callfunc('getnearxy 100 200');
```

当前仓库没有 `TMaper.GetNearXY` 的实现源码，因此文档只能确认委托调用和返回格式，不能进一步保证搜索半径、障碍物规则或一定改变原坐标。
