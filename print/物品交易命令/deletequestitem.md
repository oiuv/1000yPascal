# deletequestitem

## 功能描述
删除玩家背包中所有任务类型的物品。会遍历整个背包，删除所有种类为任务物品（`ITEM_KIND_QUESTITEM`）、任务物品2（`ITEM_KIND_QUESTITEM2`）、任务日志（`ITEM_KIND_QUESTLOG`）和护符（`ITEM_KIND_CHARM`）的物品。

## 语法格式
```pascal
print('deletequestitem');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 第271-272行：

```pascal
end else if cmd = 'deletequestitem' then begin
   TBasicObject (aSender).SDeleteQuestItem;
```

基于 `UUser.pas` 第10424-10426行的实现：

```pascal
procedure TUser.SDeleteQuestItem;
begin
   HaveItemClass.DeleteQuestItem;
end;
```

基于 `uUserSub.pas` 第3386-3423行的底层实现：

```pascal
procedure THaveItemClass.DeleteQuestItem;
var
   i : integer;
   tempList : TList;
   pIndex : ^Integer;
begin
   if FAttribClass = nil then exit;

   tempList := TList.Create;

   for i := 0 to HAVEITEMSIZE - 1 do begin
      if (HaveItemArr[i].rKind = ITEM_KIND_QUESTITEM) or
         (HaveItemArr[i].rKind = ITEM_KIND_QUESTITEM2) or
         (HaveItemArr[i].rKind = ITEM_KIND_QUESTLOG) or
         (HaveItemArr[i].rKind = ITEM_KIND_CHARM) then
      begin
         if HaveItemArr[i].rKind = ITEM_KIND_CHARM then begin
            FboAttribData := true;
         end;
         new (pIndex);
         pIndex^ := i;
         tempList.Add(pIndex);
      end;
   end;

   for i := 0 to tempList.Count - 1 do begin
      pIndex := tempList.Items[i];
      FillChar (HaveItemArr[pIndex^], sizeof(TItemData), 0);
      FSendClass.SendHaveItem (pIndex^, HaveItemArr[pIndex^]);
   end;

   // ... 释放临时列表
   tempList.Free;
end;
```

**实现细节：**
- 遍历背包所有槽位（`HAVEITEMSIZE`）
- 匹配四种物品类型：`ITEM_KIND_QUESTITEM`、`ITEM_KIND_QUESTITEM2`、`ITEM_KIND_QUESTLOG`、`ITEM_KIND_CHARM`
- 使用临时列表收集待删除索引，避免遍历中修改数组
- 删除时用 `FillChar` 清零物品数据
- 通过 `SendHaveItem` 通知客户端更新背包显示
- 若删除了护符类型物品，会设置 `FboAttribData := true` 标记属性数据变更

## 使用示例

### 远程任务完成时删除任务物品
基于 `玉仙.txt` 中的使用：

```pascal
if aStr = 'remotequest' then begin
  // 删除所有任务物品
  print ('deletequestitem');
  // 设置完成任务编号
  print ('changesendercompletequest 100');
  // 设置当前任务编号
  print ('changesendercurrentquest 100');
  exit;
end;
```

## 注意事项

1. **无参数**：此命令不接受任何参数，一次性删除所有任务类物品
2. **删除范围广**：不仅删除任务物品，还会删除任务日志和护符类物品
3. **与 getsenderallitem 的区别**：`getsenderallitem` 按名称删除指定物品的全部数量；`deletequestitem` 按物品类型批量删除所有任务相关物品
4. **客户端同步**：删除后会逐个通知客户端更新背包显示
5. **属性标记**：若涉及护符类物品，会自动标记属性数据需要刷新

## 相关命令
- `getsenderitem` - 回收玩家指定物品
- `getsenderallitem` - 回收玩家所有指定名称物品
- `changesendercompletequest` - 设置完成任务编号
- `changesendercurrentquest` - 设置当前任务编号
