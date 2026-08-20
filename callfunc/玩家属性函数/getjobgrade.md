# getjobgrade（未实现）

当前 `TScriptManager.CallFunction` 没有 `getjobgrade` 分支。调用这个名称不会读取 `SGetJobGrade`，因此不应依赖其结果。

获取当前触发玩家的职业等级应使用：

```pascal
JobGrade := callfunc('getsenderjobgrade');
```

已实现分支为：

```pascal
Result := IntToStr(TBasicObject(FSender).SGetJobGrade);
```

`TUser.SGetJobGrade` 返回 `HaveJobClass.JobGrade`。神武线上和炎黄随包的 `龙师父.txt` 都仍调用旧名称 `getjobgrade`，这是已确认的脚本/分派器兼容缺口，不代表该名称在当前服务端有效。迁移或维护该脚本时，应把两处调用改为 `getsenderjobgrade`。参见 [getsenderjobgrade](getsenderjobgrade.md)。
