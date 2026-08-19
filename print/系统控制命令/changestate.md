# changestate

## 功能描述
改变当前对象的状态。通过命令队列执行，具体效果取决于传入的参数。

## 语法格式
```pascal
print('changestate <参数>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 参数 | String | 状态变化相关参数（具体含义取决于游戏逻辑） |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if Cmd = 'changestate' then begin
   TBasicObject (aSelf).PushCommand (CMD_CHANGESTATE, Params, 0);
```

通过 `PushCommand` 将命令放入队列，延迟为0（尽快执行），使用 `CMD_CHANGESTATE` 命令类型。

## 使用示例

目前游戏脚本中暂无直接使用 `changestate` 命令的 print 调用示例。脚本中出现的 `OnChangeState` 是事件回调函数，不是此命令的调用。

## 注意事项

1. **命令队列**：通过 `PushCommand` 执行，不是立即生效
2. **与 OnChangeState 的区别**：`OnChangeState` 是状态变化时触发的事件回调，`changestate` 是主动改变状态的命令
3. **参数含义**：具体参数含义需要参考 `CMD_CHANGESTATE` 的处理逻辑

## 相关命令
- `changedynobjstate` — 改变动态对象状态
- `selfchangedynobjstate` — 改变自身动态对象状态
