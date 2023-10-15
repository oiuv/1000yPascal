unit uEvent;

interface

uses
   Classes, SysUtils, DefType, UserSDB, uManager, uMonster, uNpc, uUser;

type
   TEventData = record
      Kind : Byte;
      NameParam : String [20];
      NumberParam : Integer;
      ParamCode : Word;
   end;
   PTEVentData = ^TEventData;

   TEventParamData = record
      Code : Word;
      NameParam : array [0..5 - 1] of String [50];
      NumberParam : array [0..5 - 1] of Integer;
   end;
   PTEventParamData = ^TEventParamData;

   TEventClass = class
   private
      DataList : TList;
      ParamList : TList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure LoadFromFile;

      function isDynObjDieEvent (aSelfName : String) : Byte;
      function isMopDieEvent (aSelfName : String) : Byte;

      function RunDynObjDieEvent (aCode : Byte) : Boolean;
      function RunMopDieEvent (aCode : Byte) : Boolean;
   end;

var
   EventClass : TEventClass = nil;

implementation

constructor TEventClass.Create;
begin
   DataList := TList.Create;
   ParamList := TList.Create;
end;

destructor TEventClass.Destroy;
begin
   Clear;
   ParamList.Free;
   DataList.Free;
   inherited Destroy;
end;

procedure TEventClass.Clear;
var
   i : Integer;
   ped : PTEventData;
   ppd : PTEVentParamData;
begin
   for i := 0 to ParamList.Count - 1 do begin
      ppd := ParamList.Items [i];
      Dispose (ppd);
   end;
   ParamList.Clear;
   for i := 0 to DataList.Count - 1 do begin
      ped := DataList.Items [i];
      Dispose (ped);
   end;
   DataList.Clear;
end;

procedure TEventClass.LoadFromFile;
var
   i, j : Integer;
   iName, fName1, fName2 : String;
   Db : TUserStringDb;
   ped : PTEventData;
   ppd : PTEVentParamData;
begin
   fName1 := '.\Init\Event.SDB';
   fName2 := '.\Init\EventParam.SDB';

   if not FileExists (fName1) then exit;

   Clear;
   DB := TUserStringDB.Create;
   DB.LoadFromFile (fName1);
   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      New (ped);

      ped^.Kind := DB.GetFieldValueInteger (iName, 'Kind');
      ped^.NameParam := DB.GetFieldValueString (iName, 'NameParam');
      ped^.NumberParam := DB.GetFieldValueInteger (iName, 'NumberParam');
      ped^.ParamCode := DB.GetFieldValueInteger (iName, 'ParamCode');

      DataList.Add (ped);
   end;
   DB.Free;

   if not FileExists (fName2) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (fName2);
   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      New (ppd);

      ppd^.Code := DB.GetFieldValueInteger (iName, 'Code');

      for j := 0 to 5 - 1 do begin
         ppd^.NameParam [j] := DB.GetFieldValueString (iName, 'NameParam' + InttoStr (j + 1));
      end;

      for j := 0 to 5 - 1 do begin
         ppd^.NumberParam [j]:= DB.GetFieldValueInteger (iName, 'NumberParam' + IntToStr (j + 1));
      end;

      ParamList.Add (ppd);
   end;
   DB.Free;
end;

function TEventClass.isDynObjDieEvent (aSelfName : String) : Byte;
var
   i : Integer;
   ped : PTEventData;
begin
   Result := 0;

   for i := 0 to DataList.Count - 1 do begin
      ped := DataList.Items [i];
      if ped^.Kind = EVENTKIND_DIE_DYNOBJ then begin
         if ped^.NameParam = aSelfName then begin
            Result := ped^.ParamCode;
            exit;
         end;
      end;
   end;
end;

function TEventClass.isMopDieEvent (aSelfName : String) : Byte;
var
   i : Integer;
   ped : PTEventData;
begin
   Result := 0;

   for i := 0 to DataList.Count - 1 do begin
      ped := DataList.Items [i];
      if ped^.Kind = EVENTKIND_DIE_MOP then begin
         if ped^.NameParam = aSelfName then begin
            Result := ped^.ParamCode;
            exit;
         end;
      end;
   end;
end;

function TEventClass.RunDynObjDieEvent (aCode : Byte) : Boolean;
var
   i : Integer;
   ppd : PTEVentparamData;
   Name1, Name2, SayStr : String;
   Kind1, Kind2 : Byte;
   MapID, MapX, MapY : Word;
   Npc : TNpc;
   Monster : TMonster;
   Manager : TManager;
   Sound : String;
begin
   Result := true;

   for i := 0 to ParamList.Count - 1 do begin
      ppd := ParamList.Items [i];
      if ppd^.Code = aCode then begin
         Name1 := ppd^.NameParam [0];
         Name2 := ppd^.NameParam [1];
         Kind1 := ppd^.NumberParam [0];
         Kind2 := ppd^.NumberParam [1];
         SayStr := ppd^.NameParam [2];
         Sound := ppd^.NameParam [3];

         MapID := 0; MapX := 0; MapY := 0;
         if Kind1 = RACE_MONSTER then begin
            // Npc := ManagerList.GetObjectByName (RACE_NPC, Name2);
            // if Npc <> nil then exit;

            Monster := ManagerList.GetObjectByName (Kind1, Name1);
            if Monster <> nil then begin
               Monster.boAllowDelete := true;
               MapID := Monster.Manager.ServerID;
               MapX := Monster.CreateX;
               MapY := Monster.CreateY;
            end;
         end else if Kind1 = RACE_NPC then begin
            Monster := ManagerList.GetObjectByName (RACE_MONSTER, Name2);
            if Monster <> nil then exit;

            Npc := ManagerList.GetObjectByName (Kind1, Name1);
            if Npc <> nil then begin
               if Npc.State <> los_break then begin
                  Npc.State := los_dieandbreak;
                  MapID := Npc.Manager.ServerID;
                  MapX := Npc.CreateX;
                  MapY := Npc.CreateY;
               end;
            end;
         end;

         Manager := ManagerList.GetManagerByServerID (MapID);
         if Manager <> nil then begin
            if Kind2 = RACE_MONSTER then begin
               TMonsterList(Manager.MonsterList).AddMonster (Name2, MapX, MapY, 2, 0, '');
            end else if Kind2 = RACE_NPC then begin
               Npc := ManagerList.GetObjectByName (Kind2, Name2);
               if Npc <> nil then begin
                  if Npc.State = los_break then begin
                     Npc.State := los_exit;                     
                  end;
               end;
            end;
         end;

         UserList.SendNoticeMessage ('<' + Name2 + '>: ' + SayStr, SAY_COLOR_GRADE5);
         UserList.SendSoundMessage (Sound + '.wav', -1);
         exit;
      end;
   end;
end;

function TEventClass.RunMopDieEvent (aCode : Byte) : Boolean;
var
   i, ScriptNo : Integer;
   ppd : PTEVentparamData;
   Name1, Name2, BookName : String;
   Kind1, Kind2 : Byte;
   MapID, MapX, MapY : Word;
   Npc : TNpc;
   Monster : TMonster;
   Manager : TManager;
begin
   Result := true;

   for i := 0 to ParamList.Count - 1 do begin
      ppd := ParamList.Items [i];
      if ppd^.Code = aCode then begin
         Name1 := ppd^.NameParam [0];
         Name2 := ppd^.NameParam [1];
         BookName := ppd^.NameParam [2];
         Kind1 := ppd^.NumberParam [0];
         Kind2 := ppd^.NumberParam [1];
         ScriptNo := ppd^.NumberParam [2];

         MapID := 0; MapX := 0; MapY := 0;
         if Kind1 = RACE_MONSTER then begin
            // Npc := ManagerList.GetObjectByName (RACE_NPC, Name2);
            // if Npc <> nil then exit;

            Monster := ManagerList.GetObjectByName (Kind1, Name1);
            if Monster <> nil then begin
               Monster.boRegen := false;
               MapID := Monster.Manager.ServerID;
               MapX := Monster.CreateX;
               MapY := Monster.CreateY;
            end;
         end else if Kind1 = RACE_NPC then begin
            Monster := ManagerList.GetObjectByName (RACE_MONSTER, Name2);
            if Monster <> nil then exit;

            Npc := ManagerList.GetObjectByName (Kind1, Name1);
            if Npc <> nil then begin
               if Npc.State <> los_break then begin
                  Npc.State := los_dieandbreak;
                  MapID := Npc.Manager.ServerID;
                  MapX := Npc.CreateX;
                  MapY := Npc.CreateY;
               end;
            end;
         end;

         Manager := ManagerList.GetManagerByServerID (MapID);
         if Manager <> nil then begin
            if Kind2 = RACE_MONSTER then begin
               TMonsterList(Manager.MonsterList).AddMonster (Name2, MapX, MapY, 2, ScriptNo, '');
            end else if Kind2 = RACE_NPC then begin
               Npc := ManagerList.GetObjectByName (Kind2, Name2);
               if Npc <> nil then begin
                  if Npc.State = los_break then begin
                     Npc.State := los_exit;                     
                  end;
               end;
            end;
         end;
         exit;
      end;
   end;
end;

initialization
begin
   EventClass := TEventClass.Create;
   EventClass.LoadFromFile;
end;

finalization
begin
   EventClass.Free;
end;

end.
