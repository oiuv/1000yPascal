# sendersmeltitem2

## 功能描述
高级冶炼（提炼交换）玩家背包中的物品。与 `sendersmeltitem` 类似，但使用第二套冶炼配方表（`GetSmeltItemData2`），用于处理更高级的材料冶炼。源码注释表明此命令用于"冶炼后的交换"场景。

## 语法格式
```pascal
print('sendersmeltitem2 产物名');
```

## 参数说明
- **产物名**：String - 冶炼后产出的物品名称，系统会根据此名称查找对应的第二套冶炼配方

## 源码实现
基于 `uScriptManager.pas` 第358行（含韩文注释）：

```pascal
end else if cmd = 'sendersmeltitem2' then begin           // 제련한거 교환때문에
   TBasicObject (aSender).SSmeltItem2 (Params [0]);
```

基于 `UUser.pas` 第10585-10588行的实现：

```pascal
procedure TUser.SSmeltItem2 (aMakeName : String);
begin
   HaveJobClass.SmeltItem2 (aMakeName, ShowWindowClass);
end;
```

基于 `uUserSub.pas` 第12397-12443行的底层实现：

```pascal
procedure THaveJobClass.SmeltItem2 (aMakeName : String; aShowWindowClass : TShowWindowClass);
var
   SmeltItemData : TSmeltItemData;
   ItemData, MakeItemData : TItemData;
   nPos : Integer;
begin
   FSmeltItem2 := '';
   if aMakeName = '' then exit;

   // 密码保护检查
   if TUser (FBasicObject).Password <> '' then begin
      TUser (FBasicObject).SendClass.SendChatMessage (Conv('密码保护中不可冶炼'), SAY_COLOR_SYSTEM);
      exit;
   end;

   // 获取第二套冶炼配方
   if ItemClass.GetSmeltItemData2 (aMakeName, SmeltItemData) = false then begin
      FSendClass.SendChatMessage (Conv('无法高级冶炼'), SAY_COLOR_SYSTEM);
      exit;
   end;

   // 检查材料是否存在
   nPos := FHaveItemClass.FindItemKeyByName (StrPas (@SmeltItemData.rNeedItem));
   if nPos < 0 then begin
      FSendClass.SendChatMessage (format (Conv('高级冶炼 %s 需要 %s %d个'),
         [StrPas (@SmeltItemData.rName), StrPas (@SmeltItemData.rNeedItem), SmeltItemData.rNeedCount]), SAY_COLOR_SYSTEM);
      exit;
   end;

   // ... (验证材料名称和数量)

   FSmeltItem2 := aMakeName;
   // 弹出确认窗口
end;
```

**与 sendersmeltitem 的区别：**
| 特性 | sendersmeltitem | sendersmeltitem2 |
|------|----------------|-----------------|
| 配方表 | `GetSmeltItemData` | `GetSmeltItemData2` |
| 存储变量 | `FSmeltItem` | `FSmeltItem2` |
| 用途 | 基础材料冶炼 | 高级材料冶炼交换 |
| 错误提示 | "无法冶炼" | "无法高级冶炼" |

## 使用示例

### 高级金属类冶炼
基于 `铁匠.txt` 中的使用：

```pascal
// 高级金属冶炼（对应 metal7-metal10）
if aStr = 'metal7' then print ('sendersmeltitem2 黄铜');
if aStr = 'metal8' then print ('sendersmeltitem2 砂金');
if aStr = 'metal9' then print ('sendersmeltitem2 黄金');
if aStr = 'metal10' then print ('sendersmeltitem2 白金');
```

### 高级矿石类冶炼
```pascal
// 高级矿石冶炼（对应 rock7-rock10）
if aStr = 'rock7' then print ('sendersmeltitem2 黑石');
if aStr = 'rock8' then print ('sendersmeltitem2 月石');
if aStr = 'rock9' then print ('sendersmeltitem2 玄石');
if aStr = 'rock10' then print ('sendersmeltitem2 耀阳石');
```

### 高级宝石类冶炼
```pascal
// 高级宝石冶炼（对应 jewel7-jewel10）
if aStr = 'jewel7' then print ('sendersmeltitem2 绿玉');
if aStr = 'jewel8' then print ('sendersmeltitem2 黄玉');
if aStr = 'jewel9' then print ('sendersmeltitem2 白玉');
if aStr = 'jewel10' then print ('sendersmeltitem2 黑珍珠');
```

## 注意事项

1. **参数是产物名**：与 `sendersmeltitem` 一致，参数指定冶炼产出的物品名
2. **第二套配方表**：使用 `GetSmeltItemData2` 查找配方，与基础冶炼使用不同的配置
3. **密码保护**：同样受密码保护限制
4. **材料验证**：同样会验证材料名称和数量
5. **使用场景**：主要用于铁匠 NPC 的高级材料冶炼，对应 metal7+、rock7+、jewel7+ 等高级材料

## 相关命令
- `sendersmeltitem` - 冶炼物品（基础冶炼）
- `getsenderitem` - 回收玩家物品
- `changesendercurdurabyname` - 改变物品耐久度
