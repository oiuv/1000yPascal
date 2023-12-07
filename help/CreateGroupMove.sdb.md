# CreateGroupMove.sdb

多人传送，最多8人（1000y的默认值是8），提供特定物品达到数量后集体传送到目标地图。

此功能可以用来做特殊传送，比如：节日活动，重要副本。

## 相关代码

```pascal
function TGroupMoveObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
var
   SubData: TSubData;
   i, j, index, aLength: Integer;
   oldposx, oldposy: Integer;
   BO: TBasicObject;
begin
   Result := PROC_FALSE;
   if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then
      exit;
   Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then
      exit;

   case Msg of
      FM_ADDITEM:
         begin
            BO := GetViewObjectByID(SenderInfo.ID);
            if BO = nil then
               exit;
            if BO.BasicData.Feature.rRace <> RACE_HUMAN then
               exit;

            aLength := GetLargeLength(BasicData.x, BasicData.y, SenderInfo.x,
               SenderInfo.y);
            if aLength > SelfData.AddWidth then
            begin
               TUser(BO).SSendChatMessage(Conv('距离太远'),
                  SAY_COLOR_SYSTEM);
               exit;
            end;

            if aSubData.ItemData.rCount <> 1 then
               exit;
            if StrPas(@aSubData.ItemData.rName) <>
               StrPas(@SelfData.AddItem.rName) then
               exit;

            Move(aSubData.ItemData, SubData.ItemData, SizeOf(TItemData));
            if SendLocalMessage(SenderInfo.ID, FM_DELITEM, BasicData, SubData) =
               PROC_FALSE then
               exit;

            Strcopy(@selfData.Member[AddItemCount], @BO.BasicData.Name);

            Inc(AddItemCount);
            // AddItemUserIDArr [AddItemCount - 1] := SenderInfo.id;

            SetWordString(SubData.SayString,
               format(Conv('%s放入 %s. 总共剩%d个'),
               [StrPas(@BO.BasicData.Name), StrPas(@SelfData.AddItem.rName), 8 -
               AddItemCount]));
            SendLocalMessage(NOTARGETPHONE, FM_SAYSYSTEM, BasicData, SubData);

            if AddItemCount >= SelfData.MoveNum then
            begin
               for i := 0 to ViewObjectList.Count - 1 do
               begin
                  BO := ViewObjectList.Items[i];
                  if BO.BasicData.Feature.rRace = RACE_HUMAN then
                  begin
                     for j := 0 to 8 - 1 do
                     begin
                        if StrPas(@Bo.BasicData.Name) =
                           StrPas(@SelfData.Member[j]) then
                        begin
                           oldposx := BasicData.nx;
                           oldposy := BasicData.ny;

                           SubData.ServerId := SelfData.TargetMapID;
                           BasicData.nx := SelfData.TargetX;
                           BasicData.ny := SelfData.TargetY;

                           SendLocalMessage(BO.BasicData.ID, FM_GATE, BasicData,
                              SubData);

                           BasicData.nx := oldposx;
                           BasicData.ny := oldposy;
                        end;
                     end;
                  end;
               end;
               AddItemCount := 0;
               FillChar(selfdata.Member, sizeof(SelfData.Member), 0);
            end;
         end;
   end;
end;

procedure TGroupMoveList.LoadFromFile(aFileName: string);
var
   DB: TUserStringDB;
   i, j: Integer;
   iName, str, dest: string;
   UMO: TGroupMoveObject;
   pd: PTCreateGroupMoveData;
   ItemData: TItemData;
   Manager: TManager;
begin
   Clear;

   if not FileExists(aFileName) then
      exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile(aFileName);

   for i := 0 to DB.Count - 1 do
   begin
      iName := DB.GetIndexName(i);
      if iName = '' then
         continue;

      UMO := TGroupMoveObject.Create;
      pd := UMO.GetSelfData;

      pd^.Name := DB.GetFieldValueString(iName, 'GateName');
      pd^.ViewName := Db.GetFieldValueString(iName, 'ViewName');
      pd^.X := Db.GetFieldValueInteger(iName, 'X');
      pd^.Y := Db.GetFieldValueInteger(iName, 'Y');
      pd^.TargetX := Db.GetFieldValueInteger(iName, 'TargetX');
      pd^.TargetY := Db.GetFieldValueInteger(iName, 'TargetY');
      pd^.AddWidth := Db.GetFieldValueInteger(iName, 'AddWidth');
      pd^.MapID := Db.GetFieldValueInteger(iName, 'MapID');
      pd^.TargetMapID := Db.GetFieldValueInteger(iName, 'TargetMapID');
      pd^.Shape := Db.GetFieldValueInteger(iName, 'Shape');
      pd^.SStep := Db.GetFieldValueInteger(iName, 'SStep');
      pd^.EStep := Db.GetFieldValueInteger(iName, 'EStep');

      str := DB.GetFieldValueString(iName, 'AddItem');
      if str <> '' then
      begin
         str := GetValidStr3(str, dest, ':');
         if dest <> '' then
         begin
            ItemClass.GetItemData(dest, ItemData);
            if ItemData.rName[0] <> 0 then
            begin
               str := GetValidStr3(str, dest, ':');
               ItemData.rCount := _StrToInt(dest);
               StrCopy(@pd^.AddItem.rName, @ItemData.rName);
               pd^.AddItem.rCount := ItemData.rCount;
            end;
         end;
      end;

      pd^.MoveNum := Db.GetFieldValueInteger(iName, 'MoveNum');

      Manager := ManagerList.GetManagerByServerID(pd^.MapID);
      if Manager <> nil then
      begin
         UMO.SetManagerClass(Manager);
         UMO.Initial;
         UMO.StartProcess;
         DataList.Add(UMO);
      end
      else
      begin
         UMO.Free;
      end;
   end;

   Db.Free;
end;

```