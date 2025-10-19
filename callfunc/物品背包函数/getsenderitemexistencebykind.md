# getsenderitemexistencebykind

## 功能描述
检查玩家背包中是否存在指定种类的物品。

## 语法格式
```pascal
Str := callfunc('getsenderitemexistencebykind 物品种类');
```

## 参数说明
- **物品种类**：String - 要检查的物品种类名称

## 返回值
- **成功**：'true' - 玩家背包中存在指定种类的物品
- **失败**：'false' - 玩家背包中不存在指定种类的物品

## 源码实现
基于 `!UUser.pas` 中的 `SGetItemExistenceByKind` 函数：

```pascal
function TUser.SGetItemExistenceByKind (aItemKind : String) : String;
var
   i : Integer;
begin
   Result := 'false';

   for i := 0 to MAXITEM - 1 do begin
      if HaveItemClass.ItemList [i] <> nil then begin
         if HaveItemClass.ItemList [i]^.rItemKind = aItemKind then begin
            Result := 'true';
            exit;
         end;
      end;
   end;
end;
```

## 使用示例

### 基础物品检查
```pascal
// 检查是否有武器类物品
weapon_status := callfunc('getsenderitemexistencebykind 武器');
if weapon_status = 'true' then
    print('say 你背包中有武器');
```

### 任务物品检查
```pascal
// 检查是否有任务所需物品类型
quest_item := callfunc('getsenderitemexistencebykind 任务物品');
if quest_item = 'true' then begin
    print('say 你带着任务物品，可以继续任务');
    // 继续任务逻辑
end else begin
    print('say 你需要先获取任务物品');
    exit;
end;
```

### 装备检查
```pascal
// 检查各类装备
armor_status := callfunc('getsenderitemexistencebykind 防具');
accessory_status := callfunc('getsenderitemexistencebykind 饰品');

if armor_status = 'true' and accessory_status = 'true' then
    print('say 你的装备很齐全')
else if armor_status = 'true' then
    print('say 你有防具但缺少饰品')
else if accessory_status = 'true' then
    print('say 你有饰品但缺少防具')
else
    print('say 你需要装备一些防具和饰品');
```

### 药品检查
```pascal
// 检查药品库存
medicine_status := callfunc('getsenderitemexistencebykind 药品');
if medicine_status = 'false' then begin
    print('say 你的药品不足，需要补充');
    print('putsendermagicitem 金疮药:10 @quest药店 4');
end;
```

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'，需要进行字符串比较
2. **种类匹配**：检查的是物品的 `rItemKind` 属性，不是物品名称
3. **遍历背包**：函数会遍历玩家整个背包来查找匹配的物品种类
4. **存在性检查**：只要背包中有一个匹配的物品就返回true
5. **种类定义**：物品种类需要在游戏数据库中定义，常见的种类包括：
   - 武器
   - 防具
   - 饰品
   - 药品
   - 任务物品
   - 材料

## 相关函数
- `getsenderitemexistence` - 检查指定名称的物品是否存在
- `getsenderitemcountbyname` - 获取指定名称物品的数量
- `checkenoughspace` - 检查背包是否有足够空间