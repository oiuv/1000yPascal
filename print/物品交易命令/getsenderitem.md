# getsenderitem

## 功能描述
从玩家背包中回收（删除）指定名称和数量的物品。通过物品名称匹配删除，不校验物品归属信息。

## 语法格式
```pascal
print('getsenderitem 物品名:数量');
```

## 参数说明
- **物品名**：String - 要回收的物品名称，必须与 `Item.sdb` 中的定义一致
- **数量**：Integer - 要回收的数量，默认为 1

## 源码实现
基于 `uScriptManager.pas` 第265-266行：

```pascal
end else if cmd = 'getsenderitem' then begin
   TBasicObject (aSender).SGetItem (Params [0]);
```

基于 `UUser.pas` 第10385-10400行的实现：

```pascal
procedure TUser.SGetItem (aItem : String);
var
   Str, ItemName, ItemCount : String;
   ItemData : TItemData;
begin
   Str := aItem;
   Str := GetValidStr3 (Str, ItemName, ':');
   Str := GetValidStr3 (Str, ItemCount, ':');

   ItemClass.GetItemData (ItemName, ItemData);
   if ItemData.rName [0] = 0 then exit;
   ItemData.rCount := _StrToInt (ItemCount);
   if ItemData.rCount = 0 then ItemData.rCount := 1;

   HaveItemClass.DeleteItem (@ItemData);
end;
```

**实现细节：**
- 通过 `GetValidStr3` 按冒号分隔解析物品名和数量
- 调用 `ItemClass.GetItemData` 从数据库获取物品基础数据
- 若物品不存在（`rName[0] = 0`）则直接退出
- 数量默认为 1
- 最终调用 `HaveItemClass.DeleteItem` 按物品数据匹配删除

## 使用示例

### 回收单个任务物品
```pascal
// 回收1个神秘箱子
print ('getsenderitem 神秘箱子:1');
```

### 批量回收多种材料
基于 `quest铁匠.txt` 中的使用：

```pascal
// 回收任务材料
print ('getsenderitem 骨头一:20');
print ('getsenderitem 碳酸水石:20');
print ('getsenderitem 钢铁:5');
```

### 回收多个任务宝物
基于 `quest上古雨中客.txt` 中的使用：

```pascal
// 回收四个任务宝物
print ('getsenderitem 王妃金冠:1');
print ('getsenderitem 公主戒指:1');
print ('getsenderitem 公主项链:1');
print ('getsenderitem 王子宝剑:1');
```

### 配合条件检查使用
基于 `quest玉仙.txt` 中的使用：

```pascal
// 先检查物品是否存在，再回收
Str := callfunc ('getsenderitemexistence 神秘箱子:1 1');
if Str = 'true' then begin
  print ('getsenderitem 神秘箱子:1');
end;
```

## 注意事项

1. **物品名格式**：物品名和数量用冒号 `:` 分隔，格式为 `物品名:数量`
2. **默认数量**：若未指定数量或数量为 0，默认回收 1 个
3. **物品必须存在**：物品名必须在 `Item.sdb` 数据库中有定义，否则命令无效
4. **匹配方式**：通过 `DeleteItem` 按物品数据匹配删除，与 `getsenderitem2` 的 `DeleteItembyName` 不同
5. **不记录日志**：与 `putsendermagicitem` 不同，回收物品不发送 UDP 日志

## 相关命令
- `getsenderitem2` - 回收玩家物品（按名称匹配方式2）
- `getsenderallitem` - 回收玩家所有指定物品
- `putsendermagicitem` - 给予玩家物品
- `getsenderitemexistence` - 检查玩家是否拥有指定物品
- `deletequestitem` - 删除任务物品
