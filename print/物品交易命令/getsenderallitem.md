# getsenderallitem

## 功能描述
回收玩家背包中指定名称的**全部**物品。与 `getsenderitem` 不同，此命令不需要指定数量，会将玩家身上该名称的所有物品全部删除。

## 语法格式
```pascal
print('getsenderallitem 物品名');
```

## 参数说明
- **物品名**：String - 要回收的物品名称，不需要指定数量

## 源码实现
基于 `uScriptManager.pas` 第269-270行：

```pascal
end else if cmd = 'getsenderallitem' then begin
   TBasicObject (aSender).SGetAllItem (Params [0]);
```

基于 `UUser.pas` 第10419-10422行的实现：

```pascal
procedure TUser.SGetAllItem (aItem : String);
begin
   DeleteAllItembyName (aItem);
end;
```

**实现细节：**
- 直接调用 `DeleteAllItembyName`，遍历整个背包删除所有匹配名称的物品
- 不需要解析数量参数
- 会删除玩家身上该物品的所有堆叠

## 使用示例

### 初始化时清空所有任务相关物品
基于 `quest玉仙.txt` 中的使用：

```pascal
// 清空所有任务相关物品
print ('getsenderallitem 布条');
print ('getsenderallitem 男尸的魂魄');
print ('getsenderallitem 东海野兽王内丹');
print ('getsenderallitem 死者灵魂');
print ('getsenderallitem 石大王内丹');
print ('getsenderallitem 石巨人心脏');
print ('getsenderallitem 四臂金刚内丹');
print ('getsenderallitem 千年冰玉1');
print ('getsenderallitem 北方魔人内丹');
print ('getsenderallitem 蜘蛛血');
print ('getsenderallitem 北方魔人魂');
print ('getsenderallitem 石大王魂');
print ('getsenderallitem 四臂金刚魂');
print ('getsenderallitem 东海野兽王魂');
print ('getsenderallitem 玩具');
```

### 放弃任务时回收物品
基于 `quest风兄.txt` 中的使用：

```pascal
// 放弃任务时：回收全部布条，退还材料书札
print ('getsenderallitem 布条');
print ('getsenderitem 风兄材料书札:1');
```

### 任务完成时回收收集品
基于 `quest上古雨中客.txt` 中的使用：

```pascal
// 回收锦囊和全部灵符
print ('getsenderitem 雨中客锦囊:1');
print ('getsenderallitem 疾风灵符');
// 给予奖励
print ('putsendermagicitem 龙虎灵符:2 @上古雨中客 3');
```

### 迷宫任务回收
基于 `quest迷宫老侠客.txt` 中的使用：

```pascal
// 回收任务武器和全部召唤物
print ('getsenderitem 玉仙的无情双刀:1');
print ('getsenderallitem 黑马武士');
```

## 注意事项

1. **无需数量**：与 `getsenderitem` 不同，参数只有物品名，不需要冒号和数量
2. **全部删除**：会删除玩家背包中该名称的所有物品，包括多个堆叠
3. **谨慎使用**：因为会删除全部数量，使用前应确保这是预期行为
4. **常见用途**：任务初始化清理、放弃任务回收、收集类任务完成时清空收集品

## 相关命令
- `getsenderitem` - 回收玩家指定数量的物品
- `getsenderitem2` - 回收玩家物品（方式2）
- `deletequestitem` - 删除任务物品
- `putsendermagicitem` - 给予玩家物品
