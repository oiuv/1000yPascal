# changecurrentquest

## 功能描述
改变自身（NPC/对象）的当前任务编号。与 `changesendercurrentquest` 不同，此命令修改的是脚本对象自身的当前任务。

## 语法格式
```pascal
print('changecurrentquest <任务编号>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 任务编号 | Integer | 要设置的当前任务编号 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'changecurrentquest' then begin
   TBasicObject (aSelf).SChangeCurrentQuest (_StrToInt (Params [0]));
```

作用于 `aSelf`（脚本对象自身），传入任务编号。

## 使用示例

目前游戏脚本中暂无直接使用 `changecurrentquest` 的示例。脚本中通常使用 `changesendercurrentquest` 来修改玩家的任务。

## 注意事项

1. **作用于自身**：通过 `aSelf` 执行，修改的是脚本对象自身的当前任务
2. **与 changesendercurrentquest 的区别**：`changesendercurrentquest` 修改玩家的任务，`changecurrentquest` 修改自身的任务

## 相关命令
- `changesendercurrentquest` — 修改玩家当前任务
- `changecompletequest` — 改变自身已完成任务
- `changefirstquest` — 改变自身首要任务
