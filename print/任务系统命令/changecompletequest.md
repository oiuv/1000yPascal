# changecompletequest

## 功能描述
改变自身（NPC/对象）的已完成任务编号。与 `changesendercompletequest` 不同，此命令修改的是脚本对象自身的任务状态。

## 语法格式
```pascal
print('changecompletequest <任务编号>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 任务编号 | Integer | 要设置的已完成任务编号 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'changecompletequest' then begin
   TBasicObject (aSelf).SChangeCompleteQuest (_StrToInt (Params [0]));
```

作用于 `aSelf`（脚本对象自身），传入任务编号。

## 使用示例

目前游戏脚本中暂无直接使用 `changecompletequest` 的示例。脚本中通常使用 `changesendercompletequest` 来修改玩家的任务。

## 注意事项

1. **作用于自身**：通过 `aSelf` 执行，修改的是脚本对象（NPC/怪物）自身的已完成任务
2. **与 changesendercompletequest 的区别**：`changesendercompletequest` 修改玩家的任务，`changecompletequest` 修改自身的任务
3. **使用场景**：用于 NPC 自身需要跟踪任务状态的场景

## 相关命令
- `changesendercompletequest` — 修改玩家已完成任务
- `changecurrentquest` — 改变自身当前任务
- `changefirstquest` — 改变自身首要任务
