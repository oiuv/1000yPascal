# bohitallbyname

## 功能

在当前 `Manager` 中按名称批量设置怪物是否允许被攻击。

```pascal
print('bohitallbyname 怪物名 MONSTER true|false');
```

- 类型参数仅接受不区分大小写的 `MONSTER`；其他值不处理。
- 状态参数仅接受小写的 `true` 或 `false`；源码对该参数使用区分大小写的直接比较。
- 最终调用 `Manager.MonsterList.boHitAllMonsterByName`，作用范围是当前地图管理器中的同名怪物。

```pascal
TBasicObject(aSelf).SboHitAllbyName(Params[0], Params[1], Params[2]);
```

依据：`uScriptManager.pas`、`BasicObj.pas`。
