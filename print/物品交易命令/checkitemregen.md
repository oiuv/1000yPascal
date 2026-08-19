# checkitemregen

## 功能描述
在地图指定坐标处生成（重生）物品。通常用于定时器脚本中，定时在固定位置刷新物品供玩家拾取。

## 语法格式
```pascal
print('checkitemregen 物品名 地图X 地图Y 范围 数量');
```

## 参数说明
- **物品名**：String - 要生成的物品名称
- **地图X**：Integer - 地图上的 X 坐标
- **地图Y**：Integer - 地图上的 Y 坐标
- **范围**：Integer - 物品生成的扩散范围（以坐标为中心的方形区域）
- **数量**：Integer - 生成的物品数量

## 源码实现
基于 `uScriptManager.pas` 第213-215行（注意：此命令在 `CommandScript` 之前的 `ScriptCommand` 过程中处理）：

```pascal
if Cmd = 'checkitemregen' then begin
   FManager.CheckItemRegen (Params [0], _StrToInt (Params [1]), _StrToInt (Params [2]), _StrToInt (Params [3]), _StrToInt (Params [4]));
end;
```

基于 `uManager.pas` 第378-381行的实现：

```pascal
procedure TManager.CheckItemRegen (aName : String; aX, aY, aW, aCount : Integer);
begin
   TItemList (ItemList).AddItemSpecial (aName, ax, ay, aw, aCount);
end;
```

**实现细节：**
- 参数顺序：`物品名`、`X坐标`、`Y坐标`、`范围(W)`、`数量`
- 调用 `TItemList.AddItemSpecial` 在指定坐标范围内生成物品
- 此命令在 `ScriptCommand`（非 `CommandScript`）中处理，说明它是由地图管理器（`FManager`）执行而非由 NPC 对象执行
- `aW` 参数控制物品在坐标周围的分布范围

## 使用示例

### 定时刷新怪物掉落物
基于 `狐狸洞.txt` 中的使用：

```pascal
procedure OnTimer (aStr : String);
begin
  // 在地图坐标(100,84)处，范围10格内，生成10个生肉
  print ('checkitemregen 生肉 100 84 10 60');
end;
```

## 注意事项

1. **执行上下文**：此命令由地图管理器执行，不是由 NPC 对象执行，因此参数中的坐标是地图绝对坐标
2. **定时器使用**：通常在 `OnTimer` 事件中使用，定时刷新物品
3. **范围参数**：`范围` 参数决定物品在坐标周围的分布区域，值越大分布越分散
4. **数量参数**：最后一个参数是生成数量，不是时间间隔
5. **物品可拾取**：生成的物品会出现在地图上，玩家可以拾取

## 相关命令
- `putsendermagicitem` - 给予玩家物品（直接进入背包）
- `getsenderitem` - 回收玩家物品
