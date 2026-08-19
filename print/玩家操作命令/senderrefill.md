# senderrefill

## 功能描述
补满玩家的活力、内功和外功（三功补满）。向玩家发送 FM_REFILL 消息，完全恢复生命值、内力值和体力值。

## 语法格式
```pascal
print('senderrefill');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'senderrefill' then begin
   TBasicObject (aSender).SRefill;
```

`SRefill` 实现在 `BasicObj.pas` 中：

```pascal
procedure TBasicObject.SRefill;
var
   SubData: TSubData;
begin
   SendLocalMessage(NOTARGETPHONE, FM_REFILL, BasicData, SubData);
end;
```

## 使用示例

### 捕盗系统脚本（真实示例）
来自 `bin/Script/一级捕盗大将.txt`：

```pascal
print ('setallowhitbytick true 1000');

Name := callfunc ('getsendername');
Str := 'commandicebyname ' + Name;
Str := Str + ' user 1000';
print (Str);

print ('senderrefill');

print ('say 你还太嫩! 50');
print ('say 留神啦_我可不会手下留情 400');
exit;
```

### 比武NPC脚本（真实示例）
比武系统中的NPC广泛使用此命令，在挑战开始前为玩家补满状态：

```pascal
// 比武石大王、比武青龙刺客、比武雨中客等NPC脚本中均有使用
print ('senderrefill');
```

### 捕校系统脚本（真实示例）
来自各级捕校NPC脚本（`2级黑捕校.txt`、`3级白捕校.txt` 等）：

```pascal
print ('senderrefill');
```

## 注意事项

1. **完全恢复**：一次性补满所有生命、内力和体力值
2. **无参数**：不接受任何参数，恢复量由玩家自身最大值决定
3. **常用场景**：常用于比武、挑战、捕盗等战斗开始前，确保玩家以满状态进入战斗
4. **配合冻结使用**：典型用法是先 commandicebyname 冻结玩家，再 senderrefill 补满，最后解冻开始战斗

## 相关命令
- `commandicebyname` - 冻结玩家
- `setallowhitbytick` - 设置可攻击状态
- `regen` - 重生NPC/怪物
