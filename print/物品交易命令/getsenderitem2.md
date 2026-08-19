# getsenderitem2

## 功能描述
从玩家背包中回收（删除）指定名称和数量的物品。与 `getsenderitem` 功能类似，但底层使用 `DeleteItembyName` 按名称直接匹配删除，而非 `DeleteItem` 按完整物品数据匹配。

## 语法格式
```pascal
print('getsenderitem2 物品名:数量');
```

## 参数说明
- **物品名**：String - 要回收的物品名称，必须与 `Item.sdb` 中的定义一致
- **数量**：Integer - 要回收的数量，默认为 1

## 源码实现
基于 `uScriptManager.pas` 第267-268行：

```pascal
end else if cmd = 'getsenderitem2' then begin
   TBasicObject (aSender).SGetItem2 (Params [0]);
```

基于 `UUser.pas` 第10402-10417行的实现：

```pascal
procedure TUser.SGetItem2 (aItem : String);
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

   HaveItemClass.DeleteItembyName (@ItemData);
end;
```

**与 getsenderitem 的区别：**
- `getsenderitem` 调用 `HaveItemClass.DeleteItem` — 按完整物品数据匹配
- `getsenderitem2` 调用 `HaveItemClass.DeleteItembyName` — 按物品名称直接匹配删除
- 两种删除方式在物品匹配策略上存在差异，`DeleteItembyName` 更宽松，仅按名称匹配

## 使用示例

### 物品回收交换
基于 `物品回收商.txt` 中的使用：

```pascal
// 先检查玩家是否拥有物品
Str := callfunc ('getsenderitemexistence 三叉剑:1 1');
if Str = 'true' then begin
  // 回收三叉剑
  print ('getsenderitem2 三叉剑:1');
  // 给予替换物品
  print ('putsendermagicitem 三叉戟:1 @物品回收商 4');
  print ('say 接住了!!_请妥善保管!!');
end;
```

## 注意事项

1. **物品名格式**：物品名和数量用冒号 `:` 分隔，格式为 `物品名:数量`
2. **默认数量**：若未指定数量或数量为 0，默认回收 1 个
3. **匹配方式**：通过 `DeleteItembyName` 按名称匹配，比 `getsenderitem` 的匹配更宽松
4. **使用场景**：适用于物品交换类 NPC，回收旧物品并给予新物品
5. **建议先检查**：使用前建议先用 `getsenderitemexistence` 确认物品存在

## 相关命令
- `getsenderitem` - 回收玩家物品（方式1）
- `getsenderallitem` - 回收玩家所有指定物品
- `putsendermagicitem` - 给予玩家物品
- `getsenderitemexistence` - 检查玩家是否拥有指定物品
