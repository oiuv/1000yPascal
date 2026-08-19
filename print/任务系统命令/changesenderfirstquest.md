# changesenderfirstquest

## 功能描述
修改玩家的首要任务编号。首要任务用于标识玩家的整体进度阶段，通常与考试/晋级系统相关。

## 语法格式
```pascal
print('changesenderfirstquest <任务编号>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 任务编号 | Integer | 要设置的首要任务编号 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'changesenderfirstquest' then begin
   TBasicObject (aSender).SChangeFirstQuest (_StrToInt (Params [0]));
```

作用于 `aSender`（触发脚本的玩家），传入任务编号。

## 使用示例

### 通过一级考试后推进首要任务
```pascal
// 来自 一级捕盗大将.txt - 击败考官后首要任务设为2
print ('changesenderfirstquest 2');
print ('putsendermagicitem 初级竞技场兑奖券:1 @一级捕盗大将 4');
```

### 各考官对应的首要任务编号
```pascal
// 来自 一级比武老人.txt
print ('changesenderfirstquest 1');

// 来自 一级梅花夫人.txt
print ('changesenderfirstquest 3');

// 来自 一级牛俊.txt
print ('changesenderfirstquest 4');

// 来自 一级雨中客.txt
print ('changesenderfirstquest 5');

// 来自 一级老侠客.txt
print ('changesenderfirstquest 6');
```

### 检查首要任务决定奖励
```pascal
// 来自 一级捕盗大将.txt - 根据首要任务编号给予不同奖励
Str := callfunc ('getsenderfirstquest');
FirstQuest := StrToInt (Str);

if FirstQuest < 2 then begin
   print ('changesenderfirstquest 2');
   print ('putsendermagicitem 初级竞技场兑奖券:1 @一级捕盗大将 4');
end;

if FirstQuest > 2 then begin
   print ('putsendermagicitem 天桃:5 @一级捕盗大将 4');
end;
```

## 注意事项

1. **作用于玩家**：通过 `aSender` 执行
2. **与考试系统关联**：首要任务编号通常对应玩家通过的考试等级
3. **奖励差异**：不同首要任务编号可能获得不同的考试奖励
4. **与 changefirstquest 的区别**：`changesenderfirstquest` 修改玩家的任务，`changefirstquest` 修改自身（NPC/系统）的任务

## 相关命令
- `changesendercompletequest` — 修改玩家已完成任务
- `changesendercurrentquest` — 修改玩家当前任务
- `changefirstquest` — 改变自身首要任务
