# selfkill

## 功能描述
令玩家自杀。将自杀命令（CMD_SELFKILL）推入NPC的工作队列，由NPC执行自杀动作。

## 语法格式
```pascal
print('selfkill');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'selfkill' then begin
   TBasicObject (aSelf).PushCommand (CMD_SELFKILL, Params, 0);
```

通过 `PushCommand` 将 `CMD_SELFKILL`（值为 5）推入 aSelf（NPC）的工作队列，间隔为 0 表示立即执行。

## 使用示例

### NPC自杀
```pascal
// 任务完成后NPC消失
print ('say 我的使命已经完成了...');
print ('selfkill');
```

### 条件触发NPC消失
```pascal
// 检查任务状态后NPC自杀
quest_status := callfunc ('getsendercompletequest');

if quest_status = '1' then begin
   print ('say 谢谢你救了我');
   print ('selfkill');
end;
```

## 注意事项

1. **作用于NPC**：命令作用于 aSelf（NPC自身），不是玩家。NPC执行自杀后从地图消失
2. **队列执行**：通过 PushCommand 推入工作队列，不是立即执行，会在当前动作完成后执行
3. **与重生配合**：NPC自杀后可通过 `regen` 命令在指定时间后重新生成
4. **无脚本实例**：当前 bin/Script/ 目录下未找到此命令的实际使用脚本

## 相关命令
- `regen` - 重生NPC
- `changedynobjstate` - 改变动态对象状态
