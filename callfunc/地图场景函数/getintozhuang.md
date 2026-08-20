# getintozhuang

检查当前触发玩家进入聚贤庄的条件。该函数不只是查询：普通成功路径会删除 1 个“聚贤庄进门券”并增加庄园票款累计值。

## 语法

```pascal
Result := callfunc('getintozhuang');
```

## 返回值

| 值 | 条件 |
| --- | --- |
| `ok` | 玩家属于庄主门派；或争夺期间属于庄主/第一附属门派；或成功删除进门券 |
| `fight` | 争夺期间，玩家既不属于庄主门派也不属于第一附属门派 |
| `noticket` | 其他路径下无法删除 1 个“聚贤庄进门券” |

实现链路为 `TUser.SGetZhuangInto` → `TZhuangObject.GetZhuangInto`。调用方应先处理返回值，再决定是否执行地图移动。
