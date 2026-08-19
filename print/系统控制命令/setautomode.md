# setautomode

## 功能描述
设置当前对象为自动模式。用于将 NPC 切换到自动行为模式。

## 语法格式
```pascal
print('setautomode');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'setautomode' then begin
   TBasicObject (aSelf).SSetAutoMode;
```

直接调用 `SSetAutoMode` 方法，无参数。

## 使用示例

目前游戏脚本中暂无使用此命令的示例。

## 注意事项

1. **无参数**：此命令不需要任何参数
2. **作用于自身**：设置的是当前脚本对象的自动模式
3. **自动模式**：切换到自动模式后，NPC 将按照预设的 AI 逻辑自动行动

## 相关命令
- `changedynobjstate` — 改变动态对象状态
