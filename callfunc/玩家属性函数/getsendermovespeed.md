# getsendermovespeed

## 功能与语法

读取触发脚本玩家的移动速度接口值。

```pascal
Str := callfunc('getsendermovespeed');
```

无参数。返回字符串；数值结果由 `IntToStr` 转换为十进制文本。

## 源码依据

`TScriptManager.CallFunction` 的有效分支执行：

```pascal
Result := IntToStr(TBasicObject(FSender).SGetMoveSpeed);
```

当前源码只有 `TBasicObject` 实现并固定返回 0，未找到 `TUser` 覆盖。

## 注意事项

- 作用对象是 `FSender`，不要与不带 `sender` 的自身对象版本混用。
- 仅在对应对象有效的脚本事件中调用；源码没有为每个分支单独检查空指针。
