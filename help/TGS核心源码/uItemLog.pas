unit uItemLog;

interface

uses
   Classes, SysUtils, DefType, uKeyClass, AnsStringCls ,uCookie;

const
   ITEMLOGID = 'ITEMLOG';
type
   TItemLogHeader = record
      ID : array [0..10 - 1] of byte;
      Count : Integer;
      FreeCount : Integer;
   end;
   PTItemLogHeader = ^TItemLogHeader;

// add by Orber at 2004-09-08 13:41
   TItemLogData = record
      Name : array [0..20 - 1] of byte;
      Count : Integer;
      Color : Byte;
      Durability : Word;
      CurDurability : Word;
      UpGrade : byte;
      AddType : Byte;      
      Dummy : Byte;
     //add by Orber at 2004-09-08 13:41
      rLockState : Byte;
      runLockTime : Word;
   end;
   PTItemLogData = ^TItemLogData;

{   TItemLogData = record
      Name : array [0..20 - 1] of byte;
      Count : Integer;
      Color : Byte;
      Durability : Word;
      CurDurability : Word;
      UpGrade : byte;
      AddType : Byte;      
      Dummy : Byte;
   end;
   PTItemLogData = ^TItemLogData;
}
   TItemRecordHeader = record
      boUsed : Boolean;
      boLocked : Boolean;
      OwnerName : array [0..20 - 1] of byte;
      LockPassword : array [0..9 - 1] of byte;
      LastUpdate : array [0..11 - 1] of byte;
   end;
   PTItemRecordHeader = ^TItemRecordHeader;

   TItemLogRecord = record
      Header : TItemRecordHeader;
      ItemData : array [0..10 - 1] of TItemLogData;
      Dummy : array [0..48 - 1] of Byte;
     //add by Orber at 2004-09-08 13:41
      CRCKey : Cardinal;
   end;
   PTItemLogRecord = ^TItemLogRecord;

   TItemLog = class
   private
      LogStream : TFileStream;
      boOpened : Boolean;

      LogHeader : TItemLogHeader;
      LogData : TItemLogRecord;

      KeyList : TMultiStringKeyClass;
      BlankList : TList;

      DataList : TList;

      FEnabled : Boolean;
   public
      AliasPassWord : String;
      
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      function LoadFromFile (aFileName : String) : Boolean;
      function SaveToSDB (aFileName : String) : Boolean;

      function CreateRoom (aCharName : String) : Boolean;
      function GetRoomCount (aCharName : String) : Integer;

      function CheckAddItem (aCharName : String; var aItemData : TItemData) : Boolean;
      function CheckGetItem (aCharName : String; var aItemData : TItemData) : Boolean;

      function GetLogRecord (aCharName : String; aIndex : Integer; var ItemLogRecord : TItemLogRecord) : Boolean;
      function SetLogRecord (aCharName : String; aIndex : Integer; var ItemLogRecord : TItemLogRecord) : Boolean;

      function AddItem (aCharName : String; var aItemData : TItemData) : Boolean;
      function GetItem (aCharName : String; var aItemData : TItemData) : Boolean;

      function isLocked (aCharName : String) : Boolean;
      function SetPassword (aCharName, aPassword : String) : String;
      function FreePassword (aCharName, aPassword : String) : String;

      function ViewItemLogInfo (aCharName : String) : String;

      property Enabled : Boolean read FEnabled write FEnabled;
   end;

var
   ItemLog : TItemLog;

implementation

uses
   svClass,SVMain;

constructor TItemLog.Create;
begin
   LogStream := nil;
   boOpened := false;

   FillChar (LogHeader, SizeOf (TItemLogHeader), 0);
   FillChar (LogData, SizeOf (TItemLogRecord), 0);

   KeyList := TMultiStringKeyClass.Create;
   BlankList := TList.Create;

   DataList := TList.Create;

   LoadFromFile ('.\ItemLog\ItemLog.BIN');

   FEnabled := true;
end;

destructor TItemLog.Destroy;
begin
   Clear;
   KeyList.Free;
   BlankList.Free;
   DataList.Free;
end;

procedure TItemLog.Clear;
var
   i : Integer;
   pi : ^Integer;
   pd : PTItemLogRecord;
begin
   boOpened := false;
   if LogStream <> nil then begin
      LogStream.Seek (0, soFromBeginning);
      LogStream.WriteBuffer (LogHeader, SizeOf (TItemLogHeader));
      LogStream.Free;
   end;
   for i := 0 to BlankList.Count - 1 do begin
      pi := BlankList.Items [i];
      Dispose (pi);
   end;
   BlankList.Clear;
   KeyList.Clear;

   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      Dispose (pd);
   end;
   DataList.Clear;
end;

function TItemLog.LoadFromFile (aFileName : String) : Boolean;
var
   i : Integer;
   pi : ^Integer;
   UsedRecordCount : Integer;
   UnUsedRecordCount : Integer;
   TotalRecordCount : Integer;
   aa : TextFile;
   // boChanged : Boolean;
begin
   Result := false;

   Clear;

   AssignFile(aa,'itemlog.log');
   rewrite(aa);


   if not FileExists (aFileName) then begin
      StrPCopy (@LogHeader.ID, ITEMLOGID);
      LogHeader.Count := 100000 * 2;
      LogHeader.FreeCount := 100000 * 2;
      try LogStream := TFileStream.Create (aFileName, fmCreate); except exit; end;
      LogStream.WriteBuffer (LogHeader, SizeOf (TItemLogHeader));
      LogData.Header.boUsed := false;
      LogData.Header.boLocked := false;
      for i := 0 to LogHeader.FreeCount - 1 do begin
         LogStream.WriteBuffer (LogData, SizeOf (TItemLogRecord));
      end;
      LogStream.Free;
      LogStream := nil;
   end;

   try LogStream := TFileStream.Create (aFileName, fmOpenReadWrite); except exit; end;
   LogStream.ReadBuffer (LogHeader, SizeOf (TItemLogHeader));
   if StrPas (@LogHeader.ID) <> ITEMLOGID then begin
      LogStream.Free;
      LogStream := nil;
      exit;
   end;

   UsedRecordCount := 0;
   UnUsedRecordCount := 0;
   TotalRecordCount := 0;
   for i := 0 to LogHeader.Count - 1 do begin
      try
         LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));
         if LogData.Header.boUsed = true then begin
         if LogData.CRCKey <> oz_CRC32(@LogData,SizeOf(LogData)-4) then begin
            WriteLn(aa,StrPas(@LogData.Header.OwnerName));
         end;
            {
            boChanged := false;
            for j := 0 to 10 - 1 do begin
               ItemClass.GetItemData (StrPas (@LogData.ItemData [j].Name), ItemData);
               if ItemData.rName [0] = 0 then begin
                  FillChar (LogData.ItemData [j], SizeOf (TItemLogData), 0);
                  boChanged := true;
               end;
            end;
            if boChanged = true then begin
               LogStream.Seek (-SizeOf (TItemLogRecord), soFromCurrent);
               LogStream.WriteBuffer (LogData, SizeOf (TItemLogRecord));
            end;
            }
            KeyList.Insert (StrPas (@LogData.Header.OwnerName), TotalRecordCount);
            Inc (UsedRecordCount);
         end else begin
            New (pi);
            pi^ := TotalRecordCount;
            BlankList.Add (pi);
            Inc (UnUsedRecordCount);
         end;
      except
         break;
      end;
      Inc (TotalRecordCount);
   end;
   LogHeader.Count := TotalRecordCount;
   LogHeader.FreeCount := UnUsedRecordCount;

   boOpened := true;

   Result := true;
end;

function TItemLog.SaveToSDB (aFileName : String) : Boolean;
var
   i, j, nPos : Integer;
   str, rdstr : String;
   Stream : TFileStream;
   buffer : array[0..4096 - 1] of byte;
begin
   Result := false;

   if FileExists (aFileName) then DeleteFile (aFileName);
   try
      Stream := TFileStream.Create (aFileName, fmCreate);
   except
      exit;
   end;

   if (NATION_VERSION = NATION_KOREA) or (NATION_VERSION = NATION_KOREA_TEST) then begin
      str := 'Name,';
   end else begin
      str := 'Name,PassWord,';
   end;
   for i := 0 to 10 - 1 do begin
      str := str + 'ITEM' + IntToStr (i) + ',';
   end;
   StrPCopy (@buffer, str + #13#10);
   Stream.WriteBuffer (buffer, StrLen (@buffer));

   for i := 0 to KeyList.Count - 1 do begin
      nPos := KeyList.GetKeyValue (i);

      LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
      LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));

      if (NATION_VERSION = NATION_KOREA) or (NATION_VERSION = NATION_KOREA_TEST) then begin
         str := StrPas (@LogData.Header.OwnerName);
      end else begin
         str := StrPas (@LogData.Header.OwnerName) + ',' + StrPas (@LogData.Header.LockPassword);
      end;
      for j := 0 to 10 - 1 do begin
         // rdstr := StrPas (@LogData.ItemData[j].Name) + ':' + IntToStr (LogData.ItemData[j].Color) + ':' + IntToStr (LogData.ItemData[j].Count) + ':' + StrPas (@LogData.ItemData[j].Code);
        //add by Orber at 2004-09-08 13:57
         rdstr := StrPas (@LogData.ItemData[j].Name) + ':' +
            IntToStr (LogData.ItemData[j].Color) + ':' +
            IntToStr (LogData.ItemData[j].Count) + ':' +
            IntToStr (LogData.ItemData[j].CurDurability) + ':' +
            IntToStr (LogData.ItemData[j].Durability) + ':' +
            IntToStr (LogData.ItemData[j].UpGrade) + ':' +
            IntToStr (LogData.ItemData[j].AddType) + ':' +
            IntToStr (LogData.ItemData[j].rLockState) + ':' +
            IntToStr (LogData.ItemData[j].runLockTime);
         if rdstr = ':0:0:0:0:0:0:0:0' then rdstr := '';
{
         rdstr := StrPas (@LogData.ItemData[j].Name) + ':' +
            IntToStr (LogData.ItemData[j].Color) + ':' +
            IntToStr (LogData.ItemData[j].Count) + ':' +
            IntToStr (LogData.ItemData[j].CurDurability) + ':' +
            IntToStr (LogData.ItemData[j].Durability) + ':' +
            IntToStr (LogData.ItemData[j].UpGrade) + ':' +
            IntToStr (LogData.ItemData[j].AddType);
         if rdstr = ':0:0:0:0:0:0' then rdstr := '';
}
         str := str + ',' + rdstr;
      end;
      if str <> StrPas (@LogData.Header.OwnerName) then begin
         StrPCopy (@buffer, str + #13#10);
         Stream.WriteBuffer (buffer, StrLen (@buffer));
      end;
   end;

   Stream.Free;
   Result := true;
end;

function TItemLog.CreateRoom (aCharName : String) : Boolean;
var
   pi : ^Integer;
   nPos : Integer;
begin
   Result := false;

   if BlankList.Count <= 0 then exit;

   pi := BlankList.Items [0];
   nPos := pi^;
   Dispose (pi);
   BlankList.Delete (0);

   FillChar (LogData, SizeOf (TItemLogRecord), 0);
   
   LogData.Header.boUsed := true;
   LogData.Header.boLocked := false;
   StrPCopy (@LogData.Header.OwnerName, aCharName);
   StrPCopy (@LogData.Header.LastUpdate, DateToStr (Date));

   try
      LogData.Header.boUsed := true;
      LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
  // add by Orber at 2005-02-26 19:59:27
      LogData.CRCKey := oz_CRC32(@LogData,SizeOf(TItemLogRecord)-4);
      LogStream.WriteBuffer (LogData, SizeOf (TItemLogRecord));

      // KeyList.Add (aCharName, nPos);
      KeyList.Insert (aCharName, nPos);
   except
      exit;
   end;

   LogHeader.FreeCount := LogHeader.FreeCount - 1; 

   Result := true;
end;

function TItemLog.GetRoomCount (aCharName : String) : Integer;
var
   nStartPos, nEndPos : Integer;
begin
   Result := KeyList.Select (aCharName, nStartPos, nEndPos);
end;

function TItemLog.AddItem (aCharName : String; var aItemData : TItemData) : Boolean;
var
   i, j, nPos, nStartPos, nEndPos, nCount : Integer;
begin
   Result := false;

   if aItemData.rName [0] = 0 then exit;
   if aItemData.rCount <= 0 then exit;

   nCount := KeyList.Select (aCharName, nStartPos, nEndPos);
   if nCount <= 0 then exit;

   for i := nStartPos to nEndPos do begin
      nPos := KeyList.GetKeyValue (i);
      LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
      LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));

      if aItemData.rboDouble = true then begin
         for j := 0 to 10 - 1 do begin
            if StrPas (@aItemData.rName) = StrPas (@LogData.ItemData[j].Name) then begin
               if aItemData.rcolor = LogData.ItemData[j].Color then begin
                  StrPCopy (@LogData.Header.LastUpdate, DateToStr (Date));
                  LogData.ItemData[j].Count := LogData.ItemData[j].Count + aItemData.rCount;
                  LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
                  LogStream.WriteBuffer (LogData, SizeOf (TItemLogRecord));
                  Result := true;
                  exit;
               end;
            end;
         end;
      end;
   end;

   for i := nStartPos to nEndPos do begin
      nPos := KeyList.GetKeyValue (i);
      LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
      LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));

      for j := 0 to 10 - 1 do begin
         if LogData.ItemData[j].Name[0] = 0 then begin
            StrPCopy (@LogData.Header.LastUpdate, DateToStr (Date));
            StrCopy (@LogData.ItemData[j].Name, @aItemData.rName);
            LogData.ItemData[j].Color := aItemData.rColor;
            LogData.ItemData[j].Count := aItemData.rCount;
            // StrCopy (@LogData.ItemData[j].Code, @aItemData.rCode);

            LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
            LogStream.WriteBuffer (LogData, SizeOf (TItemLogRecord));
            Result := true;
            exit;
         end;
      end;
   end;
end;

function TItemLog.GetItem (aCharName : String; var aItemData : TItemData) : Boolean;
var
   i, j, nPos, nStartPos, nEndPos, nCount : Integer;
begin
   Result := false;

   if aItemData.rName [0] = 0 then exit;
   if aItemData.rCount <= 0 then exit;

   nCount := KeyList.Select (aCharName, nStartPos, nEndPos);
   if nCount <= 0 then exit;

   for i := nStartPos to nEndPos do begin
      nPos := KeyList.GetKeyValue (i);
      LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
      LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));
      for j := 0 to 10 - 1 do begin
         if StrPas (@LogData.ItemData[j].Name) = StrPas (@aItemData.rName) then begin
            if LogData.ItemData[j].Color = aItemData.rColor then begin
               if LogData.ItemData[j].Count >= aItemData.rCount then begin
                  StrPCopy (@LogData.Header.LastUpdate, DateToStr (Date));
                  if LogData.ItemData[j].Count - aItemData.rCount > 0 then begin
                     LogData.ItemData[j].Count := LogData.ItemData[j].Count - aItemData.rCount;
                  end else begin
                     FillChar (LogData.ItemData[j], SizeOf (TItemLogData), 0);
                  end;
                  LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
                  LogStream.WriteBuffer (LogData, SizeOf (TItemLogRecord));
                  Result := true;
                  exit;
               end;
            end;
         end;
      end;
   end;
end;

function TItemLog.CheckAddItem (aCharName : String; var aItemData : TItemData) : Boolean;
var
   i, j, nPos, nStartPos, nEndPos, nCount : Integer;
begin
   Result := false;

   if aItemData.rName [0] = 0 then exit;
   if aItemData.rCount <= 0 then exit;

   nCount := KeyList.Select (aCharName, nStartPos, nEndPos);
   if nCount <= 0 then exit;

   for i := nStartPos to nEndPos do begin
      nPos := KeyList.GetKeyValue (i);
      LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
      LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));

      if aItemData.rboDouble = true then begin
         for j := 0 to 10 - 1 do begin
            if StrPas (@aItemData.rName) = StrPas (@LogData.ItemData[j].Name) then begin
               if aItemData.rcolor = LogData.ItemData[j].Color then begin
                  Result := true;
                  exit;
               end;
            end;
         end;
      end;
   end;

   for i := nStartPos to nEndPos do begin
      nPos := KeyList.GetKeyValue (i);
      LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
      LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));

      for j := 0 to 10 - 1 do begin
         if LogData.ItemData[j].Name[0] = 0 then begin
            Result := true;
            exit;
         end;
      end;
   end;
end;

function TItemLog.CheckGetItem (aCharName : String; var aItemData : TItemData) : Boolean;
var
   i, j, nPos, nStartPos, nEndPos, nCount : Integer;
begin
   Result := false;

   if aItemData.rName [0] = 0 then exit;
   if aItemData.rCount <= 0 then exit;

   nCount := KeyList.Select (aCharName, nStartPos, nEndPos);
   if nCount <= 0 then exit;

   for i := nStartPos to nEndPos do begin
      nPos := KeyList.GetKeyValue (i);
      LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
      LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));
      for j := 0 to 10 - 1 do begin
         if StrPas (@LogData.ItemData[j].Name) = StrPas (@aItemData.rName) then begin
            if LogData.ItemData[j].Color = aItemData.rColor then begin
               if LogData.ItemData[j].Count >= aItemData.rCount then begin
                  Result := true;
                  exit;
               end;
            end;
         end;
      end;
   end;
end;

function TItemLog.GetLogRecord (aCharName : String; aIndex : Integer; var ItemLogRecord : TItemLogRecord) : Boolean;
var
   i, j, nPos, nStartPos, nEndPos, nCount : Integer;
   ItemData : TItemData;
begin
   Result := false;

   FillChar (ItemLogRecord, SizeOf (TItemLogRecord), 0);
   nCount := KeyList.Select (aCharName, nStartPos, nEndPos);
   if nCount <= 0 then exit;

   for i := nStartPos to nEndPos do begin
      if i - nStartPos = aIndex then begin
         nPos := KeyList.GetKeyValue (i);
         LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
         LogStream.ReadBuffer (ItemLogRecord, SizeOf (TItemLogRecord));
//         for j := 0 to 10 - 1 do begin
//            ItemClass.GetItemData (StrPas (@ItemLogRecord.ItemData [j].Name), ItemData);
//            if ItemData.rName [0] = 0 then begin
//               FillChar (ItemLogRecord.ItemData [j], SizeOf (TItemLogData), 0);
//            end;
//         end;
         Result := true;
         exit;
      end;
   end;
end;

function TItemLog.SetLogRecord (aCharName : String; aIndex : Integer; var ItemLogRecord : TItemLogRecord) : Boolean;
var
   i, nPos, nStartPos, nEndPos, nCount : Integer;
begin
   Result := false;

   nCount := KeyList.Select (aCharName, nStartPos, nEndPos);
   if nCount <= 0 then exit;

   for i := nStartPos to nEndPos do begin
      if i - nStartPos = aIndex then begin
         ItemLogRecord.Header.boUsed := true;
         nPos := KeyList.GetKeyValue (i);
         LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
        // add by Orber at 2005-02-26 20:00:29
         ItemLogRecord.CRCKey := oz_CRC32(@ItemLogRecord,SizeOf(ItemLogRecord)-4);
         LogStream.WriteBuffer (ItemLogRecord, SizeOf (TItemLogRecord));
         Result := true;
         exit;
      end;
   end;
end;

function TItemLog.ViewItemLogInfo (aCharName : String) : String;
var
   InfoStr : String;
   i, j, nPos, nStartPos, nEndPos, nCount : Integer;
begin
   Result := '';

   nCount := KeyList.Select (aCharName, nStartPos, nEndPos);
   if nCount <= 0 then exit;

   InfoStr := '';
   for i := nStartPos to nEndPos do begin
      nPos := KeyList.GetKeyValue (i);
      LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
      LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));
      for j := 0 to 10 - 1 do begin
         if LogData.ItemData[j].Name[0] <> 0 then begin
            // InfoStr := InfoStr + StrPas (@LogData.ItemData[j].Name) + ':' + IntToStr (LogData.ItemData[j].Color) + ':' + IntToStr (LogData.ItemData[j].Count) + ':' + StrPas (@LogData.ItemData[j].Code) + ';';
            InfoStr := InfoStr + StrPas (@LogData.ItemData[j].Name) + ':' + IntToStr (LogData.ItemData[j].Color) + ':' + IntToStr (LogData.ItemData[j].Count) + ';';
         end;
      end;
   end;

   Result := InfoStr;
end;

function TItemLog.isLocked (aCharName : String) : Boolean;
var
   nStartPos, nEndPos, nCount, nPos : Integer;
begin
   Result := true;

   nCount := KeyList.Select (aCharName, nStartPos, nEndPos);
   if nCount <= 0 then exit;

   nPos := KeyList.GetKeyValue (nStartPos);
   LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
   LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));

   Result := LogData.Header.boLocked;
end;

function TItemLog.SetPassword (aCharName, aPassword : String) : String;
var
   Password : String;
   nStartPos, nEndPos, nCount, nPos : Integer;
begin
   Result := '';

   Password := Trim (aPassword);
   if (Length (Password) < 4) or (Length (Password) > 8) then begin
      Result := Conv('密码请设定4-8位数');
      exit;
   end;
   nCount := KeyList.Select (aCharName, nStartPos, nEndPos);
   if nCount <= 0 then begin
      Result := aCharName + Conv('此人没有福袋');
      exit;
   end;

   nPos := KeyList.GetKeyValue (nStartPos);
   LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
   LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));

   if LogData.Header.boLocked = true then begin
      Result := Conv('密码已设定');
      exit;
   end;

   LogData.Header.boLocked := true;
   StrPCopy (@LogData.Header.LockPassword, Password);
   AliasPassWord := PassWord;

   LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
   // add by Orber at 2005-02-26 20:02:17
   LogData.CRCKey := oz_CRC32(@LogData,SizeOf(TItemLogRecord)-4);
   LogStream.WriteBuffer (LogData, SizeOf (TItemLogRecord));

   Result := Conv('此福袋已经设定密码');
end;

function TItemLog.FreePassword (aCharName, aPassword : String) : String;
var
   Password : String;
   nStartPos, nEndPos, nCount, nPos : Integer;
begin
   Result := '';

   Password := Trim (aPassword);
   if Password = '' then begin
      Result := Conv('请输入密码');
      exit; 
   end;

   nCount := KeyList.Select (aCharName, nStartPos, nEndPos);
   if nCount <= 0 then begin
      Result := aCharName + Conv('此人没有保管空间');
      exit;
   end;

   nPos := KeyList.GetKeyValue (nStartPos);
   LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
   LogStream.ReadBuffer (LogData, SizeOf (TItemLogRecord));

   if LogData.Header.boLocked = false then begin
      Result := Conv('还没设定密码');
      exit;
   end;

   if StrPas (@LogData.Header.LockPassword) <> aPassword then begin
      Result := Conv('输入的密码不一致');
      exit;
   end;

   PassWord := '';
   StrPCopy (@LogData.Header.LockPassword, Password);

   LogData.Header.boLocked := false;
   LogStream.Seek (SizeOf (TItemLogHeader) + nPos * SizeOf (TItemLogRecord), soFromBeginning);
   // add by Orber at 2005-02-26 20:02:17
   LogData.CRCKey := oz_CRC32(@LogData,SizeOf(TItemLogRecord)-4);
   LogStream.WriteBuffer (LogData, SizeOf (TItemLogRecord));

   Result := Conv('解除了福袋的密码');
end;

end.
