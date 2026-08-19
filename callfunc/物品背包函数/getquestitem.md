# getquestitem

## 功能描述
从随机事件物品列表中按编号获取任务物品名称。

## 语法格式
```pascal
Str := callfunc('getquestitem 编号');
```

## 参数说明
- **编号**：Integer - 任务物品编号
  - 1：第一类任务物品
  - 2：第二类任务物品
  - 3：第三类任务物品
  - 5：第五类任务物品
  - 6：第六类任务物品
  - 7：第七类任务物品

## 返回值
- **成功**：String - 任务物品的名称（可用于后续给予玩家）
- **失败**：空字符串

## 源码实现
```pascal
// uScriptManager.pas 第639行
end else if cmd = 'getquestitem' then begin
   Result := RandomEventItemList.GetQuestItembyRandom (_StrToInt (Params [0]));
```

调用 `RandomEventItemList.GetQuestItembyRandom`，从随机事件物品列表中按编号获取任务物品名称。

## 使用示例

### 梅花夫人任务物品
```pascal
// 获取1号任务物品
Name := callfunc ('getquestitem 1');
```
> 来源：`quest梅花夫人.txt`

### 捕盗大将任务奖励
```pascal
// 根据条件获取不同编号的任务物品
Name := callfunc ('getquestitem 3');
// ...
Name := callfunc ('getquestitem 6');
// ...
Name := callfunc ('getquestitem 7');
```
> 来源：`quest捕盗大将.txt`

### 铁匠任务
```pascal
// 1号任务物品
Name := callfunc ('getquestitem 1');
// 2号任务物品
Name := callfunc ('getquestitem 2');
// 5号任务物品
Name := callfunc ('getquestitem 5');
```
> 来源：`quest铁匠.txt`

### 阴阳师任务
```pascal
Name := callfunc ('getquestitem 3');
// ...
Name := callfunc ('getquestitem 6');
// ...
Name := callfunc ('getquestitem 7');
```
> 来源：`阴阳师.txt`

## 注意事项

1. **返回值格式**：返回物品名称字符串，可直接用于 `putsendermagicitem` 命令
2. **编号含义**：不同编号对应不同的任务物品，具体物品由游戏数据定义
3. **与 getrandomitem 的区别**：`getquestitem` 获取的是确定的任务物品，`getrandomitem` 获取的是随机物品
4. **配合使用**：通常与 `putsendermagicitem` 配合，将任务物品给予玩家

## 相关函数
- `getrandomitem` - 获取随机物品
- `gethavegradequestitem` - 获取等级任务物品状态
- `putsendermagicitem` - 给予玩家物品
