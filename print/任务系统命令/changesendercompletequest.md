# changesendercompletequest

## 功能描述
修改玩家已完成任务的编号。用于标记玩家完成了某个任务阶段。

## 语法格式
```pascal
print('changesendercompletequest <任务编号>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 任务编号 | Integer | 要设置的已完成任务编号 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'changesendercompletequest' then begin
   TBasicObject (aSender).SChangeCompleteQuest (_StrToInt (Params [0]));
```

作用于 `aSender`（触发脚本的玩家），传入任务编号。

## 使用示例

### 完成任务后更新进度
```pascal
// 来自 东海沼泽抽屉.txt - 完成任务后更新已完成任务编号
print ('changesendercurrentquest 1250');
print ('changesendercompletequest 1200');
```

### 阴阳师任务完成标记
```pascal
// 来自 帝王石谷阴阳师.txt
print ('changesendercompletequest 1450');
print ('changesendercurrentquest 1500');
```

### 南帝王任务完成
```pascal
// 来自 南帝王.txt
print ('changesendercompletequest 1300');
print ('changesendercurrentquest 1350');
```

## 注意事项

1. **作用于玩家**：通过 `aSender` 执行，修改的是触发脚本的玩家的已完成任务
2. **与 changecompletequest 的区别**：`changesendercompletequest` 修改玩家的任务，`changecompletequest` 修改自身（NPC）的任务
3. **通常配合 changesendercurrentquest**：完成当前任务后同时更新已完成和当前任务编号

## 相关命令
- `changesendercurrentquest` — 修改玩家当前任务
- `changesenderfirstquest` — 修改玩家第一个任务
- `changesenderqueststr` — 修改玩家任务字符串
- `changecompletequest` — 改变自身已完成任务
