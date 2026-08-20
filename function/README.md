# 脚本函数与返回值事件

本目录记录解释器内建的基础函数，以及服务器会读取返回值的事件。游戏专用查询统一通过 `callfunc` 分派，详见根目录的 `callfunc/` 分类页面。

## 内建函数

```pascal
function GetToken(aStr, aToken, aSep: String): String;
function CompareStr(aStr1, aStr2: String): Boolean;
function callfunc(aText: String): String;
function Random(aScope: Integer): Integer;
function Length(aText: String): Integer;
function StrToInt(aStr: String): Integer;
function IntToStr(aInt: Integer): String;
```

## 返回值事件

- [OnMove](OnMove.md) — 动态门路径仅在返回精确小写 `false` 时阻止进入；普通移动调用不读取结果。
- [OnDanger](OnDanger.md) — 危险判定事件，以对应调用点对返回值的解释为准。

无返回值事件见 [procedure 事件索引](../procedure/README.md)。事件能否触发取决于 Pascal 源码中是否存在对应 `CallEvent` 路径，不由脚本声明本身决定。
