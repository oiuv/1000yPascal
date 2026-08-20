# startwindow

## 功能

在当前脚本对象 `aSelf` 上调用 `SShowWindow`，并把脚本所属对象 `FSelf` 作为窗口 `Commander`。

## 语法

```pascal
print('startwindow 文件路径 类型');
```

`类型` 经 `_StrToInt` 转为 `Byte`。如果 `aSelf` 的实际类型是 `TUser`，类型 `0` 调用 `ShowHelpWindow`，非 `0` 调用 `ShowTradeWindow`，并执行与 `showwindow` 相同的窗口状态和文件存在性检查。

## 与 showwindow 的区别

- `showwindow`：在事件发送者 `aSender` 上调用。
- `startwindow`：在当前对象 `aSelf` 上调用。

`TBasicObject.SShowWindow` 的基础实现为空，只有实际类型覆盖该方法时才会产生效果；当前源码中可确认的覆盖实现是 `TUser.SShowWindow`。`bin/Script` 中未发现 `startwindow` 调用示例。
