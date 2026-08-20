# getuseattackmagic

## 功能与语法

读取脚本自身对象的当前攻击武功名称。

```pascal
Str := callfunc('getuseattackmagic');
```

无参数。返回当前攻击武功名称；没有当前攻击武功时返回空字符串。

## 源码依据

`TScriptManager.CallFunction` 的有效分支执行：

```pascal
Result := TBasicObject(FSelf).SGetUseAttackMagic;
```

玩家有当前攻击武功时返回其 `rName`，否则返回空字符串；基础对象默认返回空字符串。

## 注意事项

- 作用对象是 `FSelf`，不要与带 `sender` 的玩家版本混用。
- 仅在对应对象有效的脚本事件中调用；源码没有为每个分支单独检查空指针。
