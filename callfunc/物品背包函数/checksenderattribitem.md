# checksenderattribitem

## 功能描述
检查玩家是否持有属性物品（特殊属性装备）。脚本中调用名称为 `checksenderattribitem`。

## 语法格式
```pascal
Str := callfunc('checksenderattribitem 属性类型');
```

## 参数说明
- **属性类型**：Integer - 要检查的属性类型编号
  - 9：特定属性装备检查

## 返回值
- **成功**：'true' - 玩家持有指定属性类型的物品
- **失败**：'false' - 玩家不持有指定属性类型的物品

## 源码实现
```pascal
// uScriptManager.pas 第627行
end else if cmd = 'checksenderattribitem' then begin
   Result := TBasicObject (FSender).SCheckAttribItem (_StrToInt (Params [0]));
```

调用 `TBasicObject.SCheckAttribItem`，检查玩家是否持有指定属性的物品。

## 使用示例

### 任务中检查属性物品
```pascal
// 检查是否持有属性物品(类型9)
Str := callfunc ('checksenderattribitem 9');
if Str = 'true' then begin
    print ('say 没看见我正忙着吗?!');
    exit;
end;
```
> 来源：`quest铁匠.txt`

### 多个任务NPC中使用
```pascal
// 药材商任务中检查
Str := callfunc ('checksenderattribitem 9');
if Str = 'true' then begin
    // 已有属性物品，拒绝任务
    exit;
end;
```
> 来源：`quest药材商.txt`、`quest老板娘.txt`、`quest梅花夫人.txt`、`quest风兄.txt`

## 注意事项

1. **调用名称**：仅使用源码实际注册的 `checksenderattribitem`
2. **返回值格式**：返回字符串 'true' 或 'false'
3. **任务互斥**：常用于任务系统中检查玩家是否已在进行同类任务，避免重复接取
4. **属性类型**：具体属性类型编号的含义由游戏数据定义

## 相关函数
- `checksenderpowerwearitem` - 检查力量属性装备
- `getsenderitemexistence` - 检查物品是否存在
- `getsenderwearitemname` - 获取装备名称
