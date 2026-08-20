# checkalivemopcount

## 功能

按地图管理器和对象类型查询数量或查找结果，返回十进制整数字符串。

```pascal
Str := callfunc('checkalivemopcount 地图ID 类型 名称');
```

| 类型 | 当前源码行为 |
|---|---|
| `MONSTER` | 在目标地图的 `MonsterList` 中返回指定名称的存活怪物数 |
| `NPC` | 返回目标地图 `NpcList.AliveCount`，第三个“名称”参数不参与筛选 |
| `DYN` | 返回 `DynamicObjectList.FindDynamicObject(名称)` 的整数结果 |

类型比较不区分大小写。找不到对应 `Manager` 或类型不匹配时返回 `0`。

```pascal
Result := IntToStr(TBasicObject(FSelf).SCheckAliveMonsterCount(
  _StrToInt(Params[0]), Params[1], Params[2]));
```

注意：函数名中的 `mop` 不代表三个分支都返回“同名存活数量”。只有 `MONSTER` 分支具有这一语义；使用 `NPC` 或 `DYN` 时应按上表理解。

依据：`uScriptManager.pas`、`BasicObj.pas` 的 `SCheckAliveMonsterCount`。
