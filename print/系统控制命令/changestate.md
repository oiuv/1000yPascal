# changestate

## 功能

把状态修改加入当前脚本对象 `aSelf` 的工作队列，延时参数为 `0`。

## 语法

```pascal
print('changestate 状态值');
```

`状态值` 先经 `_StrToInt` 转为整数，入队后再按 `Byte` 读取。

## 状态含义

执行 `CMD_CHANGESTATE` 时会调用对象的虚方法 `SChangeState`：

- 普通 `TBasicObject` 实现写入 `BasicData.Feature.rfeaturestate`。`TFeatureState` 的枚举顺序为：`0=wfs_normal`、`1=wfs_care`、`2=wfs_sitdown`、`3=wfs_die`、`4=wfs_running`、`5=wfs_running2`、`6=wfs_shop`。
- `TDynamicObject` 覆盖此方法，改写 `ObjectStatus`。`TDynamicObjectState` 的枚举顺序为：`0=dos_Closed`、`1=dos_Openning`、`2=dos_Openned`、`3=dos_Scroll`。

因此同一个数字的含义取决于 `aSelf` 的实际对象类型。源码没有在脚本入口校验枚举范围，脚本应只传入对应类型的有效值。`bin/Script` 中未发现直接调用示例。

## 注意

`OnChangeState` 是脚本事件回调，不是本命令。
