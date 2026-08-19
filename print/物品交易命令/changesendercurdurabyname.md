# changesendercurdurabyname

## 功能描述
按物品名称修改玩家背包中指定物品的当前耐久度。通过名称查找物品，找到后直接设置其当前耐久度值。

## 语法格式
```pascal
print('changesendercurdurabyname 物品名 耐久值');
```

## 参数说明
- **物品名**：String - 要修改耐久度的物品名称
- **耐久值**：Integer - 新的当前耐久度值（设为 0 表示清空耐久，如倒空容器中的水）

## 源码实现
基于 `uScriptManager.pas`（含韩文注释，标注日期 03.04.03）：

```pascal
end else if cmd = 'changesendercurdurabyname' then begin   // 아이템 내구성 바꿔주는거... 03.04.03
   TBasicObject (aSender).SChangeCurDuraByName (Params [0], _StrToInt (Params [1]));
```

基于 `UUser.pas` 第10595-10598行的实现：

```pascal
procedure TUser.SChangeCurDuraByName (aName : String; aCurDura : Integer);
begin
   HaveItemClass.ChangeCurDuraByName (aName, aCurDura);
end;
```

基于 `uUserSub.pas` 第4699-4709行的底层实现：

```pascal
procedure THaveItemClass.ChangeCurDuraByName (aName : String; aCurDura : Integer);
var
   nKey : Integer;
begin
   nKey := FindItemKeybyName (aName);
   if nKey = -1 then exit;
   if HaveItemArr [nKey].rName [0] = 0 then exit;

   if Strpas (@HaveItemArr [nKey].rName) = aName then begin
      HaveItemArr [nKey].rCurDurability := aCurDura;
   end;
end;
```

**实现细节：**
- 通过 `FindItemKeybyName` 按名称查找物品在背包中的位置
- 未找到（`nKey = -1`）或物品为空（`rName[0] = 0`）时直接退出
- 找到后直接修改 `rCurDurability` 字段为指定值
- 只修改第一个匹配的物品

## 使用示例

### 清空容器中的水
基于 `迷宫玉仙.txt` 中的使用：

```pascal
if aStr = 'givewater' then begin
  // 检查竹筒是否有水
  Str := callfunc ('getsendercurdurawatercase');
  if Str = '0' then begin
    print ('sendsenderchatmessage 没有竹筒_竹筒无水_都拿不到2');
    exit;
  end;
  // 将大型竹筒和竹筒的耐久度都设为0（清空水）
  print ('changesendercurdurabyname 大型竹筒 0');
  print ('changesendercurdurabyname 竹筒 0');
  print ('showwindow .\help\迷宫玉仙1.txt 1');
end;
```

## 注意事项

1. **耐久度含义**：耐久度在不同物品上有不同含义，对于容器类物品（如竹筒）代表水量，对于武器/防具代表磨损程度
2. **设为 0**：将耐久度设为 0 通常表示清空/耗尽（如倒空竹筒中的水）
3. **只修改第一个**：如果背包中有多个同名物品，只修改找到的第一个
4. **不通知客户端**：源码中未看到主动发送客户端更新的逻辑，可能需要配合其他命令刷新显示
5. **添加日期**：此命令于 2003-04-03 添加（源码注释标注）

## 相关命令
- `getsenderitemcurdurability` - 获取物品当前耐久度
- `getsenderitemmaxdurability` - 获取物品最大耐久度
- `getsendercurdurawatercase` - 获取容器类物品的耐久度（水量）
- `getsenderitem` - 回收玩家物品
