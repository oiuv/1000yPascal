# changequeststr

## 功能描述
改变自身的任务字符串参数。与 `changesenderqueststr` 不同，此命令修改的是脚本对象自身的任务字符串。

## 语法格式
```pascal
print('changequeststr <字符串值>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 字符串值 | String | 要设置的任务字符串参数 |

## 源码实现

在 `uScriptManager.pas` 的 `CommandScript` 方法中未找到 `changequeststr` 命令的直接实现。`changesenderqueststr` 的实现如下：

```pascal
end else if cmd = 'changesenderqueststr' then begin
   TBasicObject (aSender).SChangeQuestStr (Params [0]);
```

`changequeststr` 预期应作用于 `aSelf`，调用类似的 `SChangeQuestStr` 方法。

## 使用示例

目前游戏脚本中暂无使用此命令的示例。

## 注意事项

1. **作用于自身**：预期通过 `aSelf` 执行，修改脚本对象自身的任务字符串
2. **与 changesenderqueststr 的区别**：`changesenderqueststr` 修改玩家的任务字符串，`changequeststr` 修改自身的
3. **源码中未找到**：此命令在 `CommandScript` 中没有对应的处理分支，可能未实现或已废弃

## 相关命令
- `changesenderqueststr` — 修改玩家任务字符串
- `changesendercompletequest` — 修改玩家已完成任务
- `changefirstquest` — 改变自身首要任务
