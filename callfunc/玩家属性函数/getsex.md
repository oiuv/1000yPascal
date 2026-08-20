# getsex

## 功能与语法

读取脚本自身对象的性别代码。

```pascal
Str := callfunc('getsex');
```

无参数。返回字符串；数值结果由 `IntToStr` 转换为十进制文本。

## 源码依据

`TScriptManager.CallFunction` 的有效分支执行：

```pascal
Result := IntToStr(TBasicObject(FSelf).SGetSex);
```

`rboMan=true` 返回 1，否则返回 2。

## 注意事项

- 作用对象是 `FSelf`，不要与带 `sender` 的玩家版本混用。
- 仅在对应对象有效的脚本事件中调用；源码没有为每个分支单独检查空指针。
