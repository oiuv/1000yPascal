# putsendermagicitem

## 功能描述
给予玩家物品，并记录物品来源和归属信息。

## 语法格式
```pascal
print('putsendermagicitem 物品名:数量 归属者 归属者种族');
```

## 参数说明
- **物品名:数量**：String - 物品名称和数量，用冒号分隔
- **归属者**：String - 物品的来源或归属者，通常以 `@` 开头（如 `@quest神医`）
- **归属者种族**：Integer - 归属者的种族值（通常为数字）

## 源码实现
基于 `uScriptManager.pas` 第263-264行：

```pascal
end else if cmd = 'putsendermagicitem' then begin
   TBasicObject (aSender).SPutMagicItem (Params [0], Params [1], _StrToInt (Params [2]));
```

基于 `!UUser.pas` 第10284-10319行的实现：

```pascal
procedure TUser.SPutMagicItem (aWeapon, aMopName : String; aRace : Byte);
var
   Str, ItemName, ItemCount : String;
   ItemData : TItemData;
   cnt : Integer;
   usd : TStringData;
begin
   Str := aWeapon;
   Str := GetValidStr3 (Str, ItemName, ':');
   Str := GetValidStr3 (Str, ItemCount, ':');

   ItemClass.GetItemData (ItemName, ItemData);
   if ItemData.rName [0] = 0 then exit;
   ItemData.rCount := _StrToInt (ItemCount);
   if ItemData.rCount = 0 then ItemData.rCount := 1;

   if ItemData.rName[0] > 0 then begin
      ItemData.rOwnerRace := aRace;        // 设置物品所有者种族
      ItemData.rOwnerServerID := ServerID;    // 设置物品所有者服务器ID
      StrPCopy(@ItemData.rOwnerName, aMopName); // 设置物品所有者名称
      StrPCopy (@ItemData.rOwnerIP, '');
      ItemData.rOwnerX := BasicData.x;
      ItemData.rOwnerY := BasicData.y;
   end;

   // UDP日志记录
   usd.rmsg := 1;
   SetWordString (usd.rWordString, 'Item:' + StrPas (@ItemData.rName) + ',' + IntToStr (ItemData.rCount) + ',');
   cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);
   FrmSockets.UdpObjectAddData (cnt, @usd);

   // 给予物品
   if HaveItemClass.AddItem (ItemData) then begin
      SendClass.SendSideMessage (format (Conv('%s ��� %d��'), [StrPas (@ItemData.rViewName), ItemData.rCount]));
   end;
```

## 使用示例

### 基础物品给予
```pascal
// 给予1个物品
print('putsendermagicitem 生肉:1 @quest神医 4');
```

### 真实游戏示例
基于 `quest神医.txt` 中的使用：

```pascal
// 给予神医丹药 (实际物品名根据游戏数据库确定)
print ('putsendermagicitem 神医丹药:1 @quest神医 4');
```

基于 `event龙师父.txt` 中的使用：

```pascal
// 获取随机物品并给予
Name := callfunc ('getrandomitem 0');
Str := 'putsendermagicitem ' + Name;
Str := Str + ' @event龙师父 4';
print (Str);
```

## 物品归属者说明

### 归属者格式
- **@quest神医** - 来自神医任务
- **@event龙师父** - 来自龙师父事件
- **@一级老侠客** - 来自NPC一级老侠客
- **@quest** - 通用任务来源

### UDP日志机制
所有物品给予操作都会通过UDP记录到日志中，格式为：
```
Item:物品名,数量,
```

归属者的 `@` 前缀用于在UDP日志服务中区分玩家和非玩家的物品来源。

## 注意事项

1. **物品格式**：物品名和数量用冒号分隔，数量默认为1
2. **归属者格式**：归属者名称通常以 `@` 开头，用于UDP日志记录
3. **种族值**：归属者的种族值，通常是整数
4. **空格处理**：参数之间用空格分隔，不能有多余空格
5. **物品限制**：物品必须存在于 `Item.sdb` 数据库中
6. **背包空间**：给予前应先检查背包空间是否足够

## 相关命令
- `getsenderitem` - 获取玩家物品
- `getsenderitemexistence` - 检查物品是否存在
- `deletequestitem` - 删除任务物品
- `checkenoughspace` - 检查背包空间