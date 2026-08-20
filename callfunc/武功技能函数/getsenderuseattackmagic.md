# getsenderuseattackmagic

## 功能与语法

读取触发脚本玩家的当前攻击武功名称。

```pascal
Str := callfunc('getsenderuseattackmagic');
```

无参数。返回当前攻击武功名称；没有当前攻击武功时返回空字符串。

## 源码依据

`TScriptManager.CallFunction` 的有效分支执行：

```pascal
Result := TBasicObject(FSender).SGetUseAttackMagic;
```

有当前攻击武功时返回其 `rName`，否则返回空字符串。

## 注意事项

- 作用对象是 `FSender`，不要与不带 `sender` 的自身对象版本混用。
- 仅在对应对象有效的脚本事件中调用；源码没有为每个分支单独检查空指针。
