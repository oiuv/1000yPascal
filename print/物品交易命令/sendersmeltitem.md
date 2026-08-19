# sendersmeltitem

## 功能描述
冶炼（提炼）玩家背包中的物品。根据 `SmeltItem` 配置表查找冶炼配方，验证玩家是否拥有足够的材料后，弹出数量确认窗口让玩家确认冶炼操作。

## 语法格式
```pascal
print('sendersmeltitem 产物名');
```

## 参数说明
- **产物名**：String - 冶炼后产出的物品名称，系统会根据此名称查找对应的冶炼配方（需要的材料、数量等）

## 源码实现
基于 `uScriptManager.pas` 第356-357行：

```pascal
end else if cmd = 'sendersmeltitem' then begin
   TBasicObject (aSender).SSmeltItem (Params [0]);
```

基于 `UUser.pas` 第10580-10583行的实现：

```pascal
procedure TUser.SSmeltItem (aMakeName : String);
begin
   HaveJobClass.SmeltItem (aMakeName, ShowWindowClass);
end;
```

基于 `uUserSub.pas` 第12346-12395行的底层实现：

```pascal
procedure THaveJobClass.SmeltItem (aMakeName : String; aShowWindowClass : TShowWindowClass);
var
   SmeltItemData : TSmeltItemData;
   ItemData, MakeItemData : TItemData;
   nPos : Integer;
begin
   FSmeltItem := '';
   if aMakeName = '' then exit;

   // 密码保护检查
   if TUser (FBasicObject).Password <> '' then begin
      TUser (FBasicObject).SendClass.SendChatMessage (Conv('密码保护中不可冶炼'), SAY_COLOR_SYSTEM);
      exit;
   end;

   // 获取冶炼配方
   if ItemClass.GetSmeltItemData (aMakeName, SmeltItemData) = false then begin
      FSendClass.SendChatMessage (Conv('无法冶炼'), SAY_COLOR_SYSTEM);
      exit;
   end;

   // 检查材料是否存在
   nPos := FHaveItemClass.FindItemKeyByName (StrPas (@SmeltItemData.rNeedItem));
   if nPos < 0 then begin
      FSendClass.SendChatMessage (format (Conv('%s 需要 %s %d个'),
         [StrPas (@SmeltItemData.rName), StrPas (@SmeltItemData.rNeedItem), SmeltItemData.rNeedCount]), SAY_COLOR_SYSTEM);
      exit;
   end;

   // 获取产物物品数据
   if ItemClass.GetItemData (aMakeName, MakeItemData) = false then begin
      FSendClass.SendChatMessage (Conv('无法冶炼'), SAY_COLOR_SYSTEM);
      exit;
   end;

   // 验证材料名称和数量
   // ... (验证逻辑)

   // 弹出数量确认窗口
   FSmeltItem := aMakeName;
   aShowWindowClass.FCurrentWindow := swk_count;
   FSendClass.SendShowCount (DRAGACTION_SMELLTITEM, nPos, nPos, 10000, FSmeltItem);
end;
```

**实现细节：**
1. 检查玩家是否有密码保护（锁定的物品不可冶炼）
2. 通过 `GetSmeltItemData` 从冶炼配方表获取所需材料信息
3. 通过 `FindItemKeyByName` 检查玩家背包中是否有对应材料
4. 验证材料名称和数量是否满足配方要求
5. 验证通过后弹出数量确认窗口（`swk_count`），由玩家确认最终操作

## 使用示例

### 钢铁类冶炼
基于 `铁匠.txt` 中的使用：

```pascal
// 五级钢铁冶炼
if aStr = 'steel1' then print ('sendersmeltitem 钢铁');
if aStr = 'steel2' then print ('sendersmeltitem 墨铁');
if aStr = 'steel3' then print ('sendersmeltitem 玄铁');
if aStr = 'steel4' then print ('sendersmeltitem 熔岩铁');
if aStr = 'steel5' then print ('sendersmeltitem 千年衔铁');
```

### 金属类冶炼
```pascal
// 五级金属冶炼
if aStr = 'metal1' then print ('sendersmeltitem 青铜');
if aStr = 'metal2' then print ('sendersmeltitem 黄铜');
if aStr = 'metal3' then print ('sendersmeltitem 砂金');
if aStr = 'metal4' then print ('sendersmeltitem 黄金');
if aStr = 'metal5' then print ('sendersmeltitem 白金');
if aStr = 'metal6' then print ('sendersmeltitem 千年纯金');
```

### 矿石类冶炼
```pascal
// 六级矿石冶炼
if aStr = 'rock1' then print ('sendersmeltitem 硅石');
if aStr = 'rock2' then print ('sendersmeltitem 黑石');
if aStr = 'rock3' then print ('sendersmeltitem 月石');
if aStr = 'rock4' then print ('sendersmeltitem 玄石');
if aStr = 'rock5' then print ('sendersmeltitem 耀阳石');
if aStr = 'rock6' then print ('sendersmeltitem 千年金刚石');
```

### 宝石类冶炼
```pascal
// 六级宝石冶炼
if aStr = 'jewel1' then print ('sendersmeltitem 青玉');
if aStr = 'jewel2' then print ('sendersmeltitem 绿玉');
if aStr = 'jewel3' then print ('sendersmeltitem 黄玉');
if aStr = 'jewel4' then print ('sendersmeltitem 白玉');
if aStr = 'jewel5' then print ('sendersmeltitem 黑珍珠');
if aStr = 'jewel6' then print ('sendersmeltitem 千年水晶');
```

## 注意事项

1. **参数是产物名**：参数指定的是冶炼**产出**的物品名，系统自动查找所需材料
2. **冶炼配方**：材料和产出物的对应关系由 `SmeltItem` 配置表定义
3. **密码保护**：若玩家设置了物品密码保护，无法进行冶炼
4. **材料验证**：系统会自动检查玩家是否拥有足够材料，不足时提示所需材料名和数量
5. **确认窗口**：命令执行后弹出数量确认窗口，玩家需确认后才完成冶炼
6. **与 sendersmeltitem2 的区别**：`sendersmeltitem` 使用 `GetSmeltItemData`（基础冶炼表），`sendersmeltitem2` 使用 `GetSmeltItemData2`（高级冶炼表）

## 相关命令
- `sendersmeltitem2` - 冶炼物品交换（高级冶炼）
- `getsenderitem` - 回收玩家物品
- `changesendercurdurabyname` - 改变物品耐久度
