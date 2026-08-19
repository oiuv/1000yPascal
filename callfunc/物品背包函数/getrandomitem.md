# getrandomitem

## 功能描述
从随机事件物品列表中按等级获取一个随机物品名称。

## 语法格式
```pascal
Str := callfunc('getrandomitem 等级');
```

## 参数说明
- **等级**：Integer - 随机物品的等级/品质
  - 0：初级
  - 1：高级
  - 3：特殊级

## 返回值
- **成功**：String - 随机物品的名称（可用于后续给予玩家）
- **失败**：空字符串

## 源码实现
```pascal
// uScriptManager.pas 第637行
end else if cmd = 'getrandomitem' then begin
   Result := RandomEventItemList.GetItemNamebyRandom (_StrToInt (Params [0]));
```

调用 `RandomEventItemList.GetItemNamebyRandom`，从随机事件物品列表中按等级抽取物品名称。

## 使用示例

### 初级英雄牌兑换
```pascal
// 消耗初级英雄牌，获得随机物品
Str := callfunc ('getsenderitemexistence 初级英雄牌:1');
if Str = 'false' then begin
    print ('say 需要有初级英雄牌');
    exit;
end;

print ('getsenderitem 初级英雄牌');

Name := callfunc ('getrandomitem 0');
Str := 'putsendermagicitem ' + Name;
Str := Str + ' @event龙师父 4';
print (Str);
```
> 来源：`event龙师父.txt`

### 高级英雄牌兑换
```pascal
// 消耗高级英雄牌，获得更好的随机物品
Str := callfunc ('getsenderitemexistence 高级英雄牌:1');
if Str = 'false' then begin
    print ('say 需要有高级英雄牌');
    exit;
end;

print ('getsenderitem 高级英雄牌');
Name := callfunc ('getrandomitem 1');
Str := 'putsendermagicitem ' + Name;
Str := Str + ' @event龙师父 4';
print (Str);
```
> 来源：`event龙师父.txt`

### 比武奖励
```pascal
Name := callfunc ('getrandomitem 0');
Str := 'putsendermagicitem ' + Name;
Str := Str + ' @比武老人 4';
print (Str);
```
> 来源：`一级比武老人.txt`、`比武老人.txt`

### 猎人奖励
```pascal
Item := callfunc ('getrandomitem 3');
```
> 来源：`犀牛猎人.txt`

## 注意事项

1. **返回值格式**：返回物品名称字符串，可直接用于 `putsendermagicitem` 命令
2. **等级区分**：不同等级参数对应不同品质的随机物品池
3. **配合使用**：通常与 `getsenderitemexistence`（检查兑换物品）和 `putsendermagicitem`（给予随机物品）配合使用
4. **随机性**：每次调用结果可能不同

## 相关函数
- `getquestitem` - 获取任务物品
- `getsenderitemexistence` - 检查物品是否存在
- `putsendermagicitem` - 给予玩家物品
