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

`TUser.SGetJobGrade` 返回 `HaveJobClass.JobGrade`。仓库脚本中即使仍能找到旧名称，也不能改变当前分派器未注册它的事实。参见 [getsenderjobgrade](getsenderjobgrade.md)。
