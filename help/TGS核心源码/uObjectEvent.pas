unit uObjectEvent;

interface

uses
   Classes, SysUtils, AUtil32, DefType;

type
   TItemTextData = record
      ItemName : String [20];
      ItemCount : Integer;
      SayText : TStringList;
   end;
   PTItemTextData = ^TItemTextData;
   TDragDropEventData = record
      ItemName : String [20];
      ItemCount : Integer;
      EventCount : Integer;
      boRandom : Boolean;
      GiveItems : TList;
   end;
   PTDragDropEventData = ^TDragDropEventData;

   TDragDropEvent = class
   private
      BasicObject : Pointer;

      DragDropList : TList;

      CurSpeech : Integer;
      SpeechInterval : Integer;
      SpeechLoopInterval : Integer;
      LastSpeechTick : Integer;
      SpeechList : TStringList;
   public
      constructor Create (aBasicObject : Pointer);
      destructor Destroy; override;

      procedure LoadFromFile (aFileName : String);

      function EventAddItem (aItemName : String; var SenderInfo : TBasicData) : Boolean;
      procedure EventSay (CurTick : Integer);
   end;

implementation

uses
   svClass, BasicObj, uUser;

constructor TDragDropEvent.Create (aBasicObject : Pointer);
begin
   BasicObject := aBasicObject;

   DragDropList := TList.Create;
   SpeechList := TStringList.Create;

   CurSpeech := 0;
   SpeechInterval := 300;
   SpeechLoopInterval := 500;
   LastSpeechTick := 0;

   LoadFromFile ('.\NpcSetting\' + StrPas (@TBasicObject (BasicObject).BasicData.Name) + '.TXT');
end;

destructor TDragDropEvent.Destroy;
var
   i, j : Integer;
   pt : PTItemTextData;
   pd : PTDragDropEventData;
begin
   for i := 0 to DragDropList.Count - 1 do begin
      pd := DragDropList.Items [i];
      if pd^.GiveItems <> nil then begin
         for j := 0 to pd^.GiveItems.Count - 1 do begin
            pt := pd^.GiveItems.Items [j];
            pt^.SayText.Clear;
            pt^.SayText.Free;
            Dispose (pt);
         end;
         pd^.GiveItems.Clear;
         pd^.GiveItems.Free;
      end;
      Dispose (pd);
   end;
   DragDropList.Clear;
   DragDropList.Free;

   SpeechList.Clear;
   SpeechList.Free;

   inherited Destroy;
end;

procedure TDragDropEvent.LoadFromFile (aFileName : String);
   procedure GetKeyAndValue (aStr : String; var aKey, aValue : String);
   var
      nPos : Integer;
   begin
      aKey := ''; aValue := '';

      nPos := Pos ('=', aStr);
      if nPos <= 0 then exit;
      aKey := UpperCase (Copy (aStr, 1, nPos - 1));
      aValue := Copy (aStr, nPos + 1, Length (aStr));
   end;
var
   i, nPos : Integer;
   Str, KeyStr, ValueStr, rdStr : String;
   StrList : TStringList;
   ParseSt : Byte;
   pt : PTItemTextData;
   pd : PTDragDropEventData;
begin
   if not FileExists (aFileName) then exit;

   StrList := TStringList.Create;
   StrList.LoadFromFile (aFileName);

   pd := nil; pt := nil;
   ParseSt := 0;

   for i := 0 to StrList.Count - 1 do begin
      Str := StrList.Strings [i];
      if Str = '' then continue;

      if Copy (Str, 1, 1) = '@' then ParseSt := 0;
      Case ParseSt of
         0 :
            begin
               if Str = '@DRAGDROPEVENT' then begin
                  ParseSt := 1;
               end else if Str = '@SELFSPEECH' then begin
                  ParseSt := 2;
               end else if Str = '@END' then begin
                  break;
               end;
            end;
         1 :
            begin
               GetKeyAndValue (Str, KeyStr, ValueStr);
               if KeyStr = 'ITEM' then begin
                  New (pd);
                  FillChar (pd^, SizeOf (TDragDropEventData), 0);
                  pd^.GiveItems := TList.Create;
                  ValueStr := GetValidStr3 (ValueStr, rdStr, ':');
                  pd^.ItemName := rdStr;
                  ValueStr := GetValidStr3 (ValueStr, rdStr, ':');
                  pd^.ItemCount := _StrToInt (rdStr);
                  DragDropList.Add (pd);
                  continue;
               end;
               if pd = nil then continue;
               if KeyStr = 'RANDOM' then begin
                  if UpperCase (Trim(ValueStr)) = 'TRUE' then begin
                     pd^.boRandom := true;
                  end;
               end else if KeyStr = 'GIVEITEM' then begin
                  New (pt);
                  FillChar (pt^, SizeOf (TItemTextData), 0);
                  pt^.SayText := TStringList.Create;
                  ValueStr := GetValidStr3 (ValueStr, rdStr, ':');
                  pt^.ItemName := rdStr;
                  ValueStr := GetValidStr3 (ValueStr, rdStr, ':');
                  pt^.ItemCount := _StrToInt (rdStr);
                  pd^.GiveItems.Add (pt);
               end;
               if pt <> nil then continue;
               if KeyStr = 'SAY' then begin
                  pt^.SayText.Add (ValueStr);
               end;
            end;
         2 :
            begin
               nPos := Pos ('=', Str);
               if nPos <= 0 then continue;
               KeyStr := UpperCase (Copy (Str, 1, nPos - 1));
               ValueStr := Copy (Str, nPos + 1, Length (Str));
               if KeyStr = 'SAY' then begin
                  SpeechList.Add (ValueStr);
               end else if KeyStr = 'INTERVAL' then begin
                  SpeechInterval := _StrToInt (ValueStr);
               end else if KeyStr = 'LOOPINTERVAL' then begin
                  SpeechLoopInterval := _StrToInt (ValueStr);
               end;
            end;
      end;
   end;

   StrList.Clear;
   STrList.Free;
end;

function TDragDropEvent.EventAddItem (aItemName : String; var SenderInfo : TBasicData) : Boolean;
var
   i, j, n, xx, yy : Integer;
   Str : String;
   pt : PTItemTextData;
   pd : PTDragDropEventData;
   SubData : TSubData;
begin
   Result := false;

   if SenderInfo.Feature.rRace <> RACE_HUMAN then exit;

   for i := 0 to DragDropList.Count - 1 do begin
      pd := DragDropList.Items [i];
      if pd^.ItemName = aItemName then begin
         Inc (pd^.EventCount);

         ItemClass.GetItemData (aItemName, SubData.ItemData);
         SubData.ItemData.rCount := 1;
         TBasicObject (BasicObject).SendLocalMessage (SenderInfo.ID, FM_DELITEM, TBasicObject (BasicObject).BasicData, SubData);

         SubData.HitData.ToHit := 1000;
         TBasicObject (BasicObject).SendLocalMessage (TBasicObject (BasicObject).BasicData.ID, FM_HEAL, TBasicObject (BasicObject).BasicData, SubData);

         if pd^.EventCount < pd^.ItemCount then begin
            Result := true;
            exit;
         end;
         
         pd^.EventCount := 0;         

         xx := TBasicObject (BasicObject).BasicData.nX;
         yy := TBasicObject (BasicObject).BasicData.nY;

         TBasicObject (BasicObject).BasicData.nX := SenderInfo.X;
         TBasicObject (BasicObject).BasicData.nY := SenderInfo.Y;

         if pd^.GiveItems.Count > 0 then begin
            n := Random (pd^.GiveItems.Count);
            pt := pd^.GiveItems.Items[n];

            ItemClass.GetItemData (pt^.ItemName, SubData.ItemData);
            SubData.ItemData.rCount := pt^.ItemCount;
            SubData.ServerId := TBasicObject (BasicObject).Manager.ServerID;

            SignToItem (SubData.ItemData, SubData.ServerID, TBasicObject (BasicObject).BasicData, '');            
            if TBasicObject (BasicObject).SendLocalMessage (SenderInfo.id, FM_ADDITEM, TBasicObject(BasicObject).BasicData, SubData) = PROC_FALSE then begin
               TBasicObject (BasicObject).Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, TBasicObject (BasicObject).BasicData, SubData);
            end;

            for j := 0 to pt^.SayText.Count - 1 do begin
               Str := pt^.SayText.Strings [j];
               TBasicObject (BasicObject).BocSay (Str);
            end;

            Result := true;
         end;

         TBasicObject (BasicObject).BasicData.nX := xx;
         TBasicObject (BasicObject).BasicData.nY := yy;

         exit;
      end;
   end;
end;

procedure TDragDropEvent.EventSay (CurTick : Integer);
var
   Str : String;
begin
   if SpeechList.Count = 0 then exit;
   if CurTick < LastSpeechTick + SpeechInterval then exit;

   LastSpeechTick := CurTick;

   if CurSpeech >= SpeechList.Count then CurSpeech := 0;

   Str := SpeechList.Strings [CurSpeech];

   TBasicObject (BasicObject).BocSay (Str);

   Inc (CurSpeech);
   if CurSpeech = SpeechList.Count then begin
      LastSpeechTick := LastSpeechTick + SpeechLoopInterval;
   end;
end;

end.
