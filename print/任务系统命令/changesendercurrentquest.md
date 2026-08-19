# changesendercurrentquest

## 功能描述
修改玩家当前任务的编号。用于推进玩家的任务进度到下一阶段。

## 语法格式
```pascal
print('changesendercurrentquest <任务编号>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 任务编号 | Integer | 要设置的当前任务编号 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'changesendercurrentquest' then begin
   TBasicObject (aSender).SChangeCurrentQuest (_StrToInt (Params [0]));
```

作用于 `aSender`（触发脚本的玩家），传入任务编号。

## 使用示例

### 推进任务到下一阶段
```pascal
// 来自 东海沼泽抽屉.txt
print ('changesendercurrentquest 1250');
print ('changesendercompletequest 1200');
```

### 阴阳师任务推进
```pascal
// 来自 帝王石谷阴阳师.txt
print ('changesendercompletequest 1450');
print ('changesendercurrentquest 1500');
```

### 铁匠任务推进
```pascal
// 来自 帝王石谷铁匠.txt
print ('changesendercurrentquest 1500');
print ('changesendercompletequest 1450');
```

### 南帝王任务推进
```pascal
// 来自 南帝王.txt
print ('changesendercompletequest 1300');
print ('changesendercurrentquest 1350');
```

## 注意事项

1. **作用于玩家**：通过 `aSender` 执行
2. **任务编号含义**：编号代表任务的特定阶段，不同编号对应不同的任务进度
3. **与 changesendercompletequest 配合**：通常先完成当前任务，再设置新的当前任务

## 相关命令
- `changesendercompletequest` — 修改玩家已完成任务
- `changesenderfirstquest` — 修改玩家第一个任务
- `changecurrentquest` — 改变自身当前任务
