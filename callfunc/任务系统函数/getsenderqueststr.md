# getsenderqueststr

## 功能描述
获取玩家的任务字符串状态信息。

## 语法格式
```pascal
Str := callfunc('getsenderqueststr');
```

## 参数说明
无参数。

## 返回值
- **成功**：返回玩家的任务状态字符串
- **失败**：返回空字符串

## 源码实现
基于 `!UUser.pas` 中的 `SGetQuestStr` 函数：

```pascal
function TUser.SGetQuestStr : String;
begin
   Result := AttribClass.QuestStr;
end;
```

## 使用示例

### 基础任务状态检查
```pascal
// 获取玩家任务状态
quest_str := callfunc('getsenderqueststr');
if quest_str <> '' then begin
    print('say 你有进行中的任务');
    // 处理任务逻辑
end;
```

### 任务状态解析
```pascal
// 检查特定任务标记
quest_str := callfunc('getsenderqueststr');

// 检查是否包含特定任务标记（假设标记用逗号分隔）
if Pos('main_quest_1', quest_str) > 0 then begin
    print('say 主线任务第一章已完成，可以开始第二章');
end;

if Pos('side_quest_5', quest_str) > 0 then begin
    print('say 支线任务5已完成，可以领取奖励');
end;
```

### 任务进度管理
```pascal
// 获取任务状态并更新进度
quest_str := callfunc('getsenderqueststr');

// 检查任务完成情况
if quest_str = 'completed' then begin
    print('say 恭喜你完成了当前任务！');
    print('putsendermagicitem 经验丹:5 @quest任务奖励 4');
    // 清空任务状态（假设有相应函数）
    // callfunc('clearqueststr');
end else if quest_str = 'in_progress' then begin
    print('say 任务还在进行中，继续努力！');
end;
```

### 多任务标记处理
```pascal
// 处理多个任务标记
quest_str := callfunc('getsenderqueststr');
quest_list := SplitString(quest_str, ','); // 假设有分割字符串的函数

for i := 0 to Length(quest_list) - 1 do begin
    task := Trim(quest_list[i]);
    if task <> '' then begin
        case task of
            'kill_monsters_10':
                print('say 击杀怪物任务：已完成');
            'collect_items_5':
                print('say 收集物品任务：已完成');
            'talk_to_npc':
                print('say NPC对话任务：已完成');
        else
            print('say 未知任务标记：' + task);
        end;
    end;
end;
```

## 注意事项

1. **返回值类型**：返回的是字符串，可能包含多个任务标记
2. **字符串格式**：任务字符串的格式由游戏任务系统定义，可能包含：
   - 单个任务标记：`'main_quest_1'`
   - 多个任务标记：`'main_quest_1,side_quest_2,achievement_5'`
   - 任务状态：`'completed'`, `'in_progress'`, `'failed'`
3. **空字符串处理**：返回空字符串可能表示没有进行中的任务
4. **自定义解析**：具体的任务字符串解析逻辑需要根据游戏任务系统的设计来实现
5. **性能考虑**：频繁调用此函数可能影响性能，建议在需要时才调用

## 相关函数
- `getsenderfirstquest` - 获取玩家的第一个任务
- `getsendercurrentquest` - 获取玩家当前任务
- `getsendercompletequest` - 获取玩家已完成的任务
- `getfirstquest` - 获取第一个任务
- `getquestitem` - 获取任务物品