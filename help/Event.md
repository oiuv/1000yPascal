## BattleMap说明

玩家组队对战，每个地图需要配置2队数据。

## EventItem说明

```pascal
// 2~8 为QuestNotice目录中的物品
Name := callfunc ('getrandomitem 0');
Name := callfunc ('getrandomitem 1');
```

- RandomEventItem0: 中央比武老人高级兑换奖励|高级宝箱|礼盒
- RandomEventItem1: 犀牛猎人兑换

从源码看，可以有RandomEventItem0到RandomEventItem3，共4个文件(神武生效0和1)。另外，如果Item的kind值为55，双击可掉落RandomEventItem0.sdb中的物品。

### 相关源码

```pascal

procedure TRandomEventItemList.LoadFromFile;
var
   DB : TUserStringDB;
   iName, FileName : String;
   i, j : Integer;
   RandomEventItem : TRandomEventItem;
begin
   for j := 0 to 4 - 1 do begin
      FileName := format ('.\Event\RandomEventItem%d.sdb', [j]);
      if FileExists (FileName) then begin
         DB := TUserStringDb.Create;
         DB.LoadFromFile(FileName);

         for i := 0 to DB.Count - 1 do begin
            iName := DB.GetIndexName(i);
            if iName = '' then continue;

            RandomEventItem := TRandomEventItem.Create;
            RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
            RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
            RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
            RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
            RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

            DataList [j].Add (RandomEventItem);
         end;
         DB.Free;
      end;
   end;

   FileName := '.\QuestNotice\QuestItem_1stBeginnerPrize.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         BeginnerQuestList.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_1stPrize.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         QuestList1.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_2ndPrize.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         QuestList2.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_GoldCoin.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         GoldCoinList.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_PickAx.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         PickAxList.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_AttributePiece.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         AttributePieceList.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_Weapon.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         WeaponList.Add (RandomEventItem);
      end;
      DB.Free;
   end;
end;
```