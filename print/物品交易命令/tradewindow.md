# tradewindow

## 功能描述
打开 NPC 买卖（交易）窗口，让玩家可以在 NPC 处买入或卖出物品。根据模式参数决定是卖出界面还是买入界面。

## 语法格式
```pascal
print('tradewindow NPC名称 模式');
```

## 参数说明
- **NPC名称**：String - 触发交易的 NPC 名称，通常通过 `getsendername` 获取
- **模式**：Integer - 交易模式
  - `0` = 卖出模式（玩家卖物品给 NPC）
  - `1` = 买入模式（玩家从 NPC 买物品）
  - `3` = 特价卖出模式（使用 Sale Skill 配置）

## 源码实现
基于 `uScriptManager.pas` 第253-254行：

```pascal
end else if cmd = 'tradewindow' then begin
   TBasicObject (aSelf).STradeWindow (Params [0], _StrToInt (Params [1]));
```

基于 `uNpc.pas` 第859-885行的实现：

```pascal
procedure TNpc.STradeWindow (aName : String; aKind : Byte);
var
   ItemStr : String;
   User : TUser;
begin
   User := UserList.GetUserPointer (aName);
   if User = nil then exit;

   Case aKind of
      0 : begin  // 卖出模式
         if BuySellSkill = nil then exit;
         With BuySellSkill do begin
            ItemStr := GetSellItemString;
            User.TradeWindow (SellTitle, SellCaption, BasicData.Feature.rImageNumber,
               SellImage, ItemStr, aKind);
         end;
      end;
      1 : begin  // 买入模式
         if BuySellSkill = nil then exit;
         With BuySellSkill do begin
            ItemStr := GetBuyItemString;
            User.TradeWindow (BuyTitle, BuyCaption, BasicData.Feature.rImageNumber,
               BuyImage, ItemStr, aKind);
         end;
      end;
      3 : begin  // 特价卖出模式
         if SaleSkill = nil then exit;
         With SaleSkill do begin
            ItemStr := GetSellItemString;
            // ... 使用 Sale 配置
         end;
      end;
   end;
end;
```

**实现细节：**
- `aSelf` 是 NPC 对象，`Params[0]` 是玩家名称
- 通过 `UserList.GetUserPointer` 获取玩家指针
- 根据模式从 NPC 的 `BuySellSkill` 或 `SaleSkill` 获取交易物品列表
- 模式 0（卖出）：使用 `GetSellItemString` 获取 NPC 收购的物品列表
- 模式 1（买入）：使用 `GetBuyItemString` 获取 NPC 出售的物品列表
- 模式 3（特价）：使用 `SaleSkill` 的配置
- 若 NPC 没有配置对应的买卖技能（`BuySellSkill = nil`），命令无效

## 使用示例

### 卖出模式（玩家卖物品给 NPC）
基于多个 NPC 脚本中的通用模式：

```pascal
if aStr = 'sell' then begin
  Name := callfunc ('getsendername');
  Str := 'tradewindow ' + Name;
  Str := Str + ' 0';
  print (Str);
end;
```

### 买入模式（玩家从 NPC 买物品）
```pascal
if aStr = 'buy' then begin
  Name := callfunc ('getsendername');
  Str := 'tradewindow ' + Name;
  Str := Str + ' 1';
  print (Str);
end;
```

### 药材商完整示例
基于 `药材商.txt` 中的使用：

```pascal
// 卖出药材
if aStr = 'sell' then begin
  Name := callfunc ('getsendername');
  Str := 'tradewindow ' + Name;
  Str := Str + ' 0';
  print (Str);
end;

// 买入药材
if aStr = 'buy' then begin
  Name := callfunc ('getsendername');
  Str := 'tradewindow ' + Name;
  Str := Str + ' 1';
  print (Str);
end;
```

### 铁匠买卖
基于 `铁匠.txt` 中的使用：

```pascal
// 铁匠卖出（收购玩家物品）
if aStr = 'sell' then begin
  Name := callfunc ('getsendername');
  Str := 'tradewindow ' + Name + ' 0';
  print (Str);
end;

// 铁匠买入（玩家购买物品）
if aStr = 'buy' then begin
  Name := callfunc ('getsendername');
  Str := 'tradewindow ' + Name + ' 1';
  print (Str);
end;
```

## 注意事项

1. **NPC 名称参数**：第一个参数是**玩家名称**（不是 NPC 名称），通过 `getsendername` 获取，因为 `STradeWindow` 在 NPC 对象上执行，需要知道目标玩家
2. **NPC 配置依赖**：NPC 必须在配置中设置了 `BuySellSkill`（买卖技能）或 `SaleSkill`（特价技能），否则命令无效
3. **模式 0 vs 1**：
   - 模式 0 = 卖出 = 玩家把物品卖给 NPC（NPC 收购列表）
   - 模式 1 = 买入 = 玩家从 NPC 购买物品（NPC 出售列表）
4. **物品列表来源**：买卖的物品列表、标题、图片等由 NPC 的 `BuySellSkill` 配置决定，不是脚本控制的
5. **广泛使用**：这是最常用的交易命令，几乎所有商人 NPC 都使用此命令

## 相关命令
- `logitemwindow` - 打开物品日志窗口
- `putsendermagicitem` - 给予玩家物品
- `getsenderitem` - 回收玩家物品
- `getsendername` - 获取玩家名称
