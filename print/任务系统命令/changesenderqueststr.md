# changesenderqueststr

## 功能描述
修改玩家的任务字符串参数。用于存储任务的附加状态信息，如任务分支选择、计数器等。

## 语法格式
```pascal
print('changesenderqueststr <字符串值>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 字符串值 | String | 要设置的任务字符串参数 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'changesenderqueststr' then begin
   TBasicObject (aSender).SChangeQuestStr (Params [0]);
```

作用于 `aSender`（触发脚本的玩家），传入字符串值。

## 使用示例

### 任务分支标记
```pascal
// 来自 东海沼泽抽屉.txt - 根据任务字符串决定不同分支
Str := callfunc ('getsenderqueststr');
if Str = '1' then begin
   Name := callfunc ('getsendername');
   Str := 'questcomplete ' + Name;
   Str := Str + ' 西域魔人阴谋';
   print (Str);
   print ('changesenderqueststr 2');
   exit;
end;
```

## 注意事项

1. **作用于玩家**：通过 `aSender` 执行
2. **字符串类型**：参数为字符串，可用于存储各种状态信息
3. **配合 getsenderqueststr**：通常先用 `getsenderqueststr` 读取当前值，再用 `changesenderqueststr` 修改
4. **任务分支**：常用于标记任务的不同分支或阶段

## 相关命令
- `changesendercompletequest` — 修改玩家已完成任务
- `changesendercurrentquest` — 修改玩家当前任务
- `changesenderfirstquest` — 修改玩家首要任务
