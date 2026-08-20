# getsenderheadlife

## 功能与语法

读取触发脚本的玩家的当前源码实际返回的玩家总活力。

```pascal
Str := callfunc('getsenderheadlife');
```

无参数。返回字符串；数值结果由 `IntToStr` 转换为十进制文本。

## 源码依据

`TScriptManager.CallFunction` 的有效分支执行：

```pascal
Result := IntToStr(TBasicObject(FSender).SGetLife);
```

注意：当前分支调用的是 `SGetLife`，不是 `SGetHeadLife`。函数名与实际返回值不一致。

## 注意事项

- 作用对象是 `FSender`，不要与不带 `sender` 的自身对象版本混用。
- 仅在对应对象有效的脚本事件中调用；源码没有为每个分支单独检查空指针。
