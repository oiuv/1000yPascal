# getsenderage

## 功能与语法

读取触发脚本玩家的年龄/修炼值。

```pascal
Str := callfunc('getsenderage');
```

无参数。返回字符串；数值结果由 `IntToStr` 转换为十进制文本。

## 源码依据

`TScriptManager.CallFunction` 的有效分支执行：

```pascal
Result := IntToStr(TBasicObject(FSender).SGetAge);
```

`TUser.SGetAge` 返回 `AttribClass.Age`。

## 注意事项

- 作用对象是 `FSender`，不要与不带 `sender` 的自身对象版本混用。
- 仅在对应对象有效的脚本事件中调用；源码没有为每个分支单独检查空指针。
