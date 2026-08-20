# getmovespeed

## 功能与语法

读取脚本自身对象的移动速度接口值。

```pascal
Str := callfunc('getmovespeed');
```

无参数。返回字符串；数值结果由 `IntToStr` 转换为十进制文本。

## 源码依据

`TScriptManager.CallFunction` 的有效分支执行：

```pascal
Result := IntToStr(TBasicObject(FSelf).SGetMoveSpeed);
```

当前源码只有 `TBasicObject` 实现并固定返回 0，未找到子类覆盖。

## 注意事项

- 作用对象是 `FSelf`，不要与带 `sender` 的玩家版本混用。
- 仅在对应对象有效的脚本事件中调用；源码没有为每个分支单独检查空指针。
