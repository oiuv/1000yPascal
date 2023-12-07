unit FGate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, StdCtrls, ExtCtrls, ComCtrls, WinSock, uPackets, AUtil32, BSCommon,
  AnsStringCls, BasicObj, DefType, uFuck, uCookie, uItemLog, uGuild;

type
  TfrmGate = class(TForm)
    sckGateAccept: TServerSocket;
    PageControl1: TPageControl;
    tsGate1: TTabSheet;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    lblSendByte1: TLabel;
    Label6: TLabel;
    lblRecvByte1: TLabel;
    Label8: TLabel;
    lblWBCount1: TLabel;
    shpWBSign1: TShape;
    Label10: TLabel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    lblSendByte3: TLabel;
    Label3: TLabel;
    lblRecvByte3: TLabel;
    Label12: TLabel;
    lblWBCount3: TLabel;
    shpWBSign3: TShape;
    Label14: TLabel;
    GroupBox3: TGroupBox;
    Label15: TLabel;
    lblSendByte2: TLabel;
    Label17: TLabel;
    lblRecvByte2: TLabel;
    Label19: TLabel;
    lblWBCount2: TLabel;
    shpWBSign2: TShape;
    Label21: TLabel;
    GroupBox4: TGroupBox;
    Label22: TLabel;
    lblSendByte4: TLabel;
    Label24: TLabel;
    lblRecvByte4: TLabel;
    Label26: TLabel;
    lblWBCount4: TLabel;
    shpWBSign4: TShape;
    Label28: TLabel;
    timerDisplay: TTimer;
    sckDBConnect: TClientSocket;
    timerProcess: TTimer;
    Label2: TLabel;
    Label5: TLabel;
    Shape1: TShape;
    Label7: TLabel;
    Label9: TLabel;
    GroupBox5: TGroupBox;
    Label11: TLabel;
    lblDBSendBytes: TLabel;
    Label16: TLabel;
    lblDBReceiveBytes: TLabel;
    Label20: TLabel;
    lblDBWBCount: TLabel;
    shpDBWBSign: TShape;
    Label25: TLabel;
    TabSheet1: TTabSheet;
    Label13: TLabel;
    lblNameKeyCount: TLabel;
    Label18: TLabel;
    lblUniqueKeyCount: TLabel;
    Label27: TLabel;
    lblSaveListCount: TLabel;
    Label23: TLabel;
    lblConnectListCount: TLabel;
    sckBattleConnect: TClientSocket;
    GroupBox6: TGroupBox;
    Label29: TLabel;
    lblBattleSendBytes: TLabel;
    Label31: TLabel;
    lblBattleReceiveBytes: TLabel;
    Label33: TLabel;
    lblBattleWBCount: TLabel;
    shpBattleWBSign: TShape;
    Label35: TLabel;
    txtLog: TMemo;
    procedure sckGateAcceptAccept(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckGateAcceptClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckGateAcceptClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckGateAcceptClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckGateAcceptClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckGateAcceptClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure timerDisplayTimer(Sender: TObject);
    procedure sckDBConnectConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckDBConnectDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckDBConnectError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure sckDBConnectRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckDBConnectWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure timerProcessTimer(Sender: TObject);
    procedure sckBattleConnectConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckBattleConnectDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckBattleConnectError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckBattleConnectRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckBattleConnectWrite(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    { Private declarations }
    procedure DBMessageProcess (aPacket : PTPacketData);
    procedure BattleMessageProcess (aPacket : PTPacketData);

    // add by minds 050620
    // about Remote process
    function ItemLogDataToStr(var ItemLogData: TItemLogData): string;
    procedure StrToItemLogData(str: string; var ItemLogData: TItemLogData);
    procedure GuildItemLogSelect(nRequestID: integer; const strGuildName: string);
    procedure GuildItemLogUpdate(nRequestID: integer; var str: string);
  public
    { Public declarations }

    procedure AddLog (aStr : String);
    function AddSendDBServerData (aMsg : Byte; aData : PChar; aCount : Integer) : Boolean;
    function AddSendBattleData (aID : Integer; aMsg : Byte; aRetCode : Byte; aData : PChar; aCount : Integer) : Boolean;
  end;

var
  frmGate: TfrmGate;

  DBServerIPAddress : String;
  DBServerPort : Integer;
  BattleServerIPAddress : String;
  BattleServerPort : Integer;

  DBSender : TPacketSender = nil;
  BattleSender : TPacketSender = nil;
  DBReceiver : TPacketReceiver = nil;
  BattleReceiver : TPacketReceiver = nil;

implementation

uses
   SVMain, uGConnect, uConnect;

{$R *.DFM}

procedure TfrmGate.AddLog (aStr : String);
begin
   if txtLog.Lines.Count >= 30 then begin
      txtLog.Lines.Delete (0);
   end;
   txtLog.Lines.Add (aStr);
end;

procedure TfrmGate.sckGateAcceptAccept(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Size, OptLen : Integer;
  strCode, strFingerPrint: string;
  wSalt: Word;
begin
   StrCode := ReadCode;
   wSalt := ExtractSalt(strCode);
   // change by minds 051008
   AddLog (format ('Gate Server Accepted %s', [Socket.RemoteAddress]));
   strFingerPrint := GetFingerPrint;

//   if MakeCode(wSalt, strFingerPrint, 'GameServer') = StrCode then begin
   GateConnectorList.CreateConnect (Socket);
//   end else begin
//      AddLog(Format('(%s),(%d),(%s)', [strFingerPrint, wSalt, strCode]));
//      Exit;
//   end;

   Size := 1024 * 64;
   OptLen := SizeOf (Integer);
   SetSockOpt (Socket.SocketHandle, SOL_SOCKET, SO_RCVBUF, @Size, OptLen);

   SetSockOpt (Socket.SocketHandle, SOL_SOCKET, SO_SNDBUF, @Size, OptLen);
end;

procedure TfrmGate.sckGateAcceptClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   //
end;

procedure TfrmGate.sckGateAcceptClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if Socket.Connected = true then begin
      GateConnectorList.DeleteConnect (Socket);
      AddLog (format ('Gate Server Disconnected %s', [Socket.RemoteAddress]));
   end;
end;

procedure TfrmGate.sckGateAcceptClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   AddLog (format ('Gate Accept Socket Error (%d, %s)', [ErrorCode, Socket.RemoteAddress]));

   if ErrorCode = 10053 then Socket.Close;
   if ErrorCode = 10061 then Socket.Close;
   ErrorCode := 0;
end;

procedure TfrmGate.sckGateAcceptClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   nRead : Integer;
   buffer : array [0..PROCESS_BYTES - 1] of Char;
begin
   while true do begin
      nRead := Socket.ReceiveBuf (buffer, PROCESS_BYTES);
      if nRead > 0 then begin
         GateConnectorList.AddReceiveData (Socket, @buffer, nRead);
      end else begin
         break;
      end;
   end;
end;

procedure TfrmGate.sckGateAcceptClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   GateConnectorList.SetWriteAllow (Socket);
end;

procedure TfrmGate.FormCreate(Sender: TObject);
begin
   DBSender := nil;
   DBReceiver := nil;

   BattleSender := nil;
   BattleReceiver := nil;

   GateList.SetBSGateActive (false);

   sckDBConnect.Address := DBServerIPAddress;
   sckDBConnect.Port := DBServerPort;
   sckDBConnect.Active := true;

   sckBattleConnect.Address := BattleServerIPAddress;
   sckBattleConnect.Port := BattleServerPort;
   sckBattleConnect.Active := true;

   sckGateAccept.Port := 3052;
   sckGateAccept.Active := true;

   timerDisplay.Interval := 1000;
   timerDisplay.Enabled := true;

   timerProcess.Interval := 10;
   timerProcess.Enabled := true;
end;

procedure TfrmGate.FormDestroy(Sender: TObject);
begin
   timerDisplay.Enabled := false;
   timerProcess.Enabled := false;
   
   if DBSender <> nil then begin
      DBSender.Free;
      DBSender := nil;
   end;
   if DBReceiver <> nil then begin
      DBReceiver.Free;
      DBReceiver := nil;
   end;

   if BattleSender <> nil then begin
      BattleSender.Free;
      BattleSender := nil;
   end;
   if BattleReceiver <> nil then begin
      BattleReceiver.Free;
      BattleReceiver := nil;
   end;

   if sckGateAccept.Active = true then begin
      sckGateAccept.Socket.Close;
   end;
   if sckDBConnect.Active = true then begin
      sckDBConnect.Socket.Close;
   end;
end;

procedure TfrmGate.timerDisplayTimer(Sender: TObject);
var
   GateConnector : TGateConnector;
begin
   if sckDBConnect.Active = false then begin
      sckDBConnect.Socket.Close;
      sckDBConnect.Active := true;
   end else begin
   end;

   if sckBattleConnect.Active = false then begin
      sckBattleConnect.Socket.Close;
      sckBattleConnect.Active := true;
   end else begin
   end;

   // Gate 1-1
   if GateConnectorList.Count > 0 then begin
      GateConnector := GateConnectorList.Items [0];
      with GateConnector do begin
         lblSendByte1.Caption := IntToStr (SendBytesPerSec) + 'K';
         lblRecvByte1.Caption := IntToStr (ReceiveBytesPerSec) + 'K';
         lblWBCount1.Caption := IntToStr (WBCount);

         if WriteAllow = true then begin
            shpWBSign1.Brush.Color := clLime;
         end else begin
            shpWBSign1.Brush.Color := clRed;
         end;
      end;
   end;
   // Gate 1-2
   if GateConnectorList.Count > 1 then begin
      GateConnector := GateConnectorList.Items [1];
      with GateConnector do begin
         lblSendByte2.Caption := IntToStr (SendBytesPerSec) + 'K';
         lblRecvByte2.Caption := IntToStr (ReceiveBytesPerSec) + 'K';
         lblWBCount2.Caption := IntToStr (WBCount);

         if WriteAllow = true then begin
            shpWBSign2.Brush.Color := clLime;
         end else begin
            shpWBSign2.Brush.Color := clRed;
         end;
      end;
   end;
   // Gate 1-3
   if GateConnectorList.Count > 2 then begin
      GateConnector := GateConnectorList.Items [2];
      with GateConnector do begin
         lblSendByte3.Caption := IntToStr (SendBytesPerSec) + 'K';
         lblRecvByte3.Caption := IntToStr (ReceiveBytesPerSec) + 'K';
         lblWBCount3.Caption := IntToStr (WBCount);

         if WriteAllow = true then begin
            shpWBSign3.Brush.Color := clLime;
         end else begin
            shpWBSign3.Brush.Color := clRed;
         end;
      end;
   end;
   // Gate 1-4
   if GateConnectorList.Count > 3 then begin
      GateConnector := GateConnectorList.Items [3];
      with GateConnector do begin
         lblSendByte4.Caption := IntToStr (SendBytesPerSec) + 'K';
         lblRecvByte4.Caption := IntToStr (ReceiveBytesPerSec) + 'K';
         lblWBCount4.Caption := IntToStr (WBCount);

         if WriteAllow = true then begin
            shpWBSign4.Brush.Color := clLime;
         end else begin
            shpWBSign4.Brush.Color := clRed;
         end;
      end;
   end;
   // DB Connection
   if (DBSender <> nil) and (DBReceiver <> nil) then begin
      lblDBSendBytes.Caption := IntToStr (DBSender.SendBytesPerSec) + 'K';
      lblDBReceiveBytes.Caption := IntToStr (DBReceiver.ReceiveBytesPerSec) + 'K';
      lblDBWBCount.Caption := IntToStr (DBSender.WouldBlockCount);

      if DBSender.WriteAllow = true then begin
         shpDBWBSign.Brush.Color := clLime;
      end else begin
         shpDBWBSign.Brush.Color := clRed;
      end;
   end;

   lblSaveListCount.Caption := IntToStr (ConnectorList.GetSaveListCount);

   lblConnectListCount.Caption := IntToStr (ConnectorList.Count);
   lblNameKeyCount.Caption := IntToStr (ConnectorList.NameKeyCount);
   lblUniqueKeyCount.Caption := IntToStr (ConnectorList.UniqueKeyCount);
end;

procedure TfrmGate.sckDBConnectConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
   Size, OptLen : Integer;
   buffer : array [0..20 - 1] of char;
    strCode, strCode2: string;
    wSalt: Word;
begin
   StrCode := ReadCode;
   wSalt := ExtractSalt(strCode);
   if DBSender <> nil then begin
      DBSender.Free;
      DBSender := nil;
   end;
   if DBReceiver <> nil then begin
      DBReceiver.Free;
      DBReceiver := nil;
   end;
   // change by minds 051008
   AddLog(Format('DB Connected %s', [Socket.RemoteAddress]));
   StrCode2 := MakeCode(wSalt, GetFingerPrint, 'GameServer');
//   if StrCode2 <> StrCode then exit;

   DBSender := TPacketSender.Create ('DB_SENDER', BufferSizeS2S, Socket, true, true);
   DBReceiver := TPacketReceiver.Create ('DB_RECEIVER', BufferSizeS2C, true);

   FillChar (buffer, SizeOf (buffer), 0);
   StrPCopy (@buffer, 'GAMESERVER');
   DBSender.PutPacket (0, DB_CONNECTTYPE, 0, @buffer, SizeOf (buffer));

   Size := 1024 * 64;
   OptLen := SizeOf (Integer);
   SetSockOpt (Socket.SocketHandle, SOL_SOCKET, SO_RCVBUF, @Size, OptLen);
   SetSockOpt (Socket.SocketHandle, SOL_SOCKET, SO_SNDBUF, @Size, OptLen);
end;

procedure TfrmGate.sckDBConnectDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if DBSender <> nil then begin
      DBSender.Free;
      DBSender := nil;
   end;
   if DBReceiver <> nil then begin
      DBReceiver.Free;
      DBReceiver := nil;
   end;
end;

procedure TfrmGate.sckDBConnectError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   if (ErrorCode <> 10061) and (ErrorCode <> 10038) then begin
      AddLog (format ('DBConnect Socket Error (%d)', [ErrorCode]));
   end;

   if ErrorCode = 10053 then Socket.Close;
   if ErrorCode = 10061 then Socket.Close;

   ErrorCode := 0;
end;

procedure TfrmGate.sckDBConnectRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   nRead : Integer;
   buffer : array [0..PROCESS_BYTES - 1] of Char;
begin
   while true do begin
      nRead := Socket.ReceiveBuf (buffer, PROCESS_BYTES);
      if nRead > 0 then begin
         if DBReceiver <> nil then DBReceiver.PutData (@buffer, nRead);
      end else begin
         break;
      end;
   end;
end;

procedure TfrmGate.sckDBConnectWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if DBSender <> nil then DBSender.WriteAllow := true;
end;

function TfrmGate.AddSendDBServerData (aMsg : Byte; aData : PChar; aCount : Integer) : Boolean;
begin
   Result := false;
   if (aCount >= 0) and (aCount < SizeOf (TPacketData)) then begin
      if DBSender <> nil then begin
         Result := DBSender.PutPacket (0, aMsg, 0, aData, aCount);
      end;
   end;
end;

procedure TfrmGate.DBMessageProcess (aPacket : PTPacketData);
var
   i, j, n : Integer;
   ItemLogData : TItemLogRecord;
   OldStr, Str, rdstr, ColumnStr, LineStr ,ChangedColStr: String;
   Name, Password, ItemName, ItemColor, ItemCount : String;
   ItemDura, ItemCurDura, ItemUpgrade, ItemAddType,ItemunLockTime,ItemLockState : String;
   No : Integer;
   GuildObject: TGuildObject;

   buffer : array [0..2048 - 1] of char;
begin
   Case aPacket^.RequestMsg of
      DB_UPDATE :
         begin
            if aPacket^.ResultCode = DB_OK then begin
               AddLog (format ('User Data Saved %s', [StrPas (@aPacket^.Data)]));
            end else begin
               AddLog (format ('User Data Save Failed %s', [StrPas (@aPacket^.Data)]));
            end;
         end;
  // add by Orber at 2004-11-29 15:27:17
      DB_UPDATE_END :
         begin
            if aPacket^.ResultCode = DB_OK then begin
                WaitPlayerList.Release(StrPas (@aPacket^.Data));
                AddLog (format ('User Data Saved %s', [StrPas (@aPacket^.Data)]));
            end else begin
               AddLog (format ('User Data Save Failed %s', [StrPas (@aPacket^.Data)]));
            end;
         end;
      DB_ITEMSELECT :
         begin
            Name := StrPas (@aPacket^.Data);
            // add by minds 050620
            //n := ItemLog.GetRoomCount (Name);
            if (Name[1] = '@') and (Name[2] = '@') then begin
              Delete(Name, 1, 2);
              GuildItemLogSelect(aPacket^.RequestID, Name);
              exit;
            end else begin
              n := ItemLog.GetRoomCount (Name);
            end;

            if n <= 0 then begin
               StrPCopy (@buffer, format (Conv('%s 没有储存的空间'), [Name]));
               DBSender.PutPacket (aPacket^.RequestID, DB_ITEMSELECT, 1, @buffer, SizeOf (buffer));
               exit;
            end;
            if n > 4 then n := 4;
            Str := '';
            for i := 0 to n - 1 do begin
               if ItemLog.GetLogRecord (Name, i, ItemLogData) = true then begin
                  Str := Str + Name + ',' + IntToStr (i) + ',' + StrPas (@ItemLogData.Header.LockPassword);
                  for j := 0 to 10 - 1 do begin
                     ItemName := StrPas (@ItemLogData.ItemData[j].Name);
                     ItemColor := IntToStr (ItemLogData.ItemData[j].Color);
                     ItemCount := IntToStr (ItemLogData.ItemData[j].Count);
                     ItemDura := IntToStr (ItemLogData.ItemData[j].Durability);
                     ItemUpgrade := IntToStr (ItemLogData.ItemData[j].UpGrade);
                     ItemCurDura := IntToStr (ItemLogData.ItemData[j].CurDurability);
                     ItemAddType := IntToStr (ItemLogData.ItemData[j].AddType);
                     ItemAddType := IntToStr (ItemLogData.ItemData[j].AddType);
                     ItemAddType := IntToStr (ItemLogData.ItemData[j].AddType);
                     // add by Orber at 2004-09-08 15:52
                     ItemunLockTime := IntToStr (ItemLogData.ItemData[j].runLockTime);
                     ItemLockState := IntToStr (ItemLogData.ItemData[j].rLockState);
                     Str := Str + ',' + ItemName + ':' + ItemColor + ':' + ItemCount + ':' +
                        ItemCurDura + ':' + ItemDura + ':' + ItemUpgrade + ':' + ItemAddType + ':' + ItemLockState + ':' + ItemunLockTime;
                  end;
                  if ItemLogData.CRCKey <> oz_CRC32(@ItemLogData,SizeOf(ItemLogData)-4) then begin
                      Str := Str + ',' + 'ErrorCRCKey';
                  end else begin
                      Str := Str + ',' + 'OK';
                  end;
                  Str := Str + #13;
               end else begin
                  StrPCopy (@buffer, Conv('因有错误被取消'));
                  DBSender.PutPacket (aPacket^.RequestID, DB_ITEMSELECT, 1, @buffer, SizeOf (buffer));
                  exit;
               end;
            end;
            StrPCopy (@buffer, Str);
            DBSender.PutPacket (aPacket^.RequestID, DB_ITEMSELECT, 0, @buffer, SizeOf (buffer));
         end;
      DB_ITEMUPDATE :
         begin
            Str := StrPas (@aPacket^.Data);

            if (Str[1] = '@') and (Str[2] = '@') then begin
              GuildItemLogUpdate(aPacket^.RequestID, Str);
              exit;
            end;

            while Str <> '' do begin
               Str := GetValidStr3 (Str, LineStr, #13);
               if LineStr = '' then break;

               LineStr := GetValidStr3 (LineStr, Name, ',');
               LineStr := GetValidStr3 (LineStr, rdStr, ',');
               No := _StrToInt (rdstr);
               LineStr := GetValidStr3 (LineStr, Password, ',');

               if ItemLog.GetLogRecord (Name, No, ItemLogData) = false then begin
                  StrPCopy (@buffer, Conv('因有错误被取消'));
                  DBSender.PutPacket (aPacket^.RequestID, DB_ITEMUPDATE, 1, @buffer, SizeOf (buffer));
                  exit;
               end;

               StrPCopy (@ItemLogData.Header.LockPassword, Password);
               for i := 0 to 10 - 1 do begin
                  LineStr := GetValidStr3 (LineStr, ColumnStr, ',');

                  //Author:Steven Date: 2004-12-09 16:29:04
                  //Note:
                        OldStr := StrPas(@ItemLogData.ItemData[i].Name) + ':' +
                          IntToStr(ItemLogData.ItemData[i].Color) + ':' +
                          IntToStr(ItemLogData.ItemData[i].Count) + ':' +
                          IntToStr(ItemLogData.ItemData[i].CurDurability) + ':' +
                          IntToStr(ItemLogData.ItemData[i].Durability) + ':' +
                          IntToStr(ItemLogData.ItemData[i].UpGrade) + ':' +
                          IntToStr(ItemLogData.ItemData[i].AddType) + ':' +
                          IntToStr(ItemLogData.ItemData[i].rLockState) + ':' +
                          IntToStr(ItemLogData.ItemData[i].runLockTime);


                  if ColumnStr <> OldStr then
                  begin
                    ChangedColStr := Format(' Name:%s Item%d%d: %s -> %s;', [Name, No,
                      i, OldStr, ColumnStr]);

                    StrPCopy(@Buffer, ChangedColStr);
                    DBSender.PutPacket(aPacket^.RequestID, DB_ITEMUPDATE, 0, @Buffer,
                      SizeOf(buffer));

                  end;

                  //=======================================
                  ColumnStr := GetValidStr3 (ColumnStr, rdstr, ':');
                  StrPCopy (@ItemLogData.ItemData[i].Name, rdstr);
                  ColumnStr := GetValidStr3 (ColumnStr, rdstr, ':');
                  ItemLogData.ItemData[i].Color := _StrToInt (rdstr);
                  ColumnStr := GetValidStr3 (ColumnStr, rdstr, ':');
                  ItemLogData.ItemData[i].Count := _StrToInt (rdstr);
                  ColumnStr := GetValidStr3 (ColumnStr, rdstr, ':');
                  ItemLogData.ItemData[i].CurDurability := _StrToInt (rdstr);
                  ColumnStr := GetValidStr3 (ColumnStr, rdstr, ':');
                  ItemLogData.ItemData[i].Durability := _StrToInt (rdstr);
                  ColumnStr := GetValidStr3 (ColumnStr, rdstr, ':');
                  ItemLogData.ItemData[i].UpGrade := _StrToInt (rdstr);
                  ColumnStr := GetValidStr3 (ColumnStr, rdstr, ':');
                  ItemLogData.ItemData[i].AddType := _StrToInt (rdstr);
                  ColumnStr := GetValidStr3 (ColumnStr, rdstr, ':');
                  ItemLogData.ItemData[i].rLockState := _StrToInt (rdstr);
                  ColumnStr := GetValidStr3 (ColumnStr, rdstr, ':');
                  ItemLogData.ItemData[i].runLockTime := _StrToInt (rdstr);
               end;

               ItemLog.SetLogRecord (Name, No, ItemLogData);
            end;

            StrPCopy (@buffer, Conv('处理完毕'));
            DBSender.PutPacket (aPacket^.RequestID, DB_ITEMUPDATE, 0, @buffer, SizeOf (buffer));
         end;
   end;
end;

// add by minds 050620
function TfrmGate.ItemLogDataToStr(var ItemLogData: TItemLogData): string;
begin
  Result := StrPas(@ItemLogData.Name)
    + ':' + IntToStr(ItemLogData.Color)
    + ':' + IntToStr(ItemLogData.Count)
    + ':' + IntToStr(ItemLogData.CurDurability)
    + ':' + IntToStr(ItemLogData.Durability)
    + ':' + IntToStr(ItemLogData.Upgrade)
    + ':' + IntToStr(ItemLogData.AddType)
    + ':' + IntToStr(ItemLogData.rLockState)
    + ':' + IntToStr(ItemLogData.runLockTime);
end;

procedure TfrmGate.StrToItemLogData(Str: string; var ItemLogData: TItemLogData);
var
  rdstr: string;
begin
  Str := GetValidStr3 (Str, rdstr, ':');
  StrPCopy (@ItemLogData.Name, rdstr);
  Str := GetValidStr3 (Str, rdstr, ':');
  ItemLogData.Color := _StrToInt (rdstr);
  Str := GetValidStr3 (Str, rdstr, ':');
  ItemLogData.Count := _StrToInt (rdstr);
  Str := GetValidStr3 (Str, rdstr, ':');
  ItemLogData.CurDurability := _StrToInt (rdstr);
  Str := GetValidStr3 (Str, rdstr, ':');
  ItemLogData.Durability := _StrToInt (rdstr);
  Str := GetValidStr3 (Str, rdstr, ':');
  ItemLogData.UpGrade := _StrToInt (rdstr);
  Str := GetValidStr3 (Str, rdstr, ':');
  ItemLogData.AddType := _StrToInt (rdstr);
  Str := GetValidStr3 (Str, rdstr, ':');
  ItemLogData.rLockState := _StrToInt (rdstr);
  Str := GetValidStr3 (Str, rdstr, ':');
  ItemLogData.runLockTime := _StrToInt (rdstr);
end;

procedure TfrmGate.GuildItemLogSelect(nRequestID: integer; const strGuildName: string);
var
  go: TGuildObject;
  str: string;
  i, j: integer;
begin
  go := GuildList.GetGuildObject(strGuildName);
  if not Assigned(go) then begin
    str := Format(Conv('%s 没有储存的空间'), [strGuildName]);
    DBSender.PutPacket (nRequestID, DB_ITEMSELECT, 1, PChar(str), Length(str)+1);
    exit;
  end;

  str := '';
  for i := 0 to 7 do begin
    str := str + '@@' + strGuildName + ',' + IntToStr(i) + ',,';
    for j := 0 to 9 do begin
      str := str + ItemLogDataToStr(go.FGuildItemLog.ItemData[i*10+j]) + ',';
    end;
    str := str + 'OK'#13;
  end;

  DBSender.PutPacket(nRequestID, DB_ITEMSELECT, 0, PChar(str), Length(str)+1);
end;

procedure TfrmGate.GuildItemLogUpdate(nRequestID: integer; var str: string);
var
  go: TGuildObject;
  strLine, strGuildName, strColumn, strOldColumn, strLog: string;
  nLine, i: integer;
  bSuccess: Boolean;
begin
  bSuccess := False;
  while str <> '' do begin
    // Get a line
    str := GetValidStr3(str, strLine, #13);
    if strLine = '' then Break;
    bSuccess := False;

    // Get GuildName
    strLine := GetValidStr3(strLine, strGuildName, ',');
    if strGuildName = '' then break;
    if (strGuildName[1] <> '@') or (strGuildName[2] <> '@') then break;
    Delete(strGuildName, 1, 2);

    // Get GuildObject
    go := GuildList.GetGuildObject(strGuildName);
    if not Assigned(go) then break;

    // Get LineNumber
    strLine := GetValidStr3(strLine, strColumn, ',');
    nLine := _StrToInt(strColumn);

    // Skip Password column
    strLine := GetValidStr3(strLine, strColumn, ',');

    // Get, Check and Update ItemData
    for i := 0 to 9 do begin
      strLine := GetValidStr3(strLine, strColumn, ',');
      strOldColumn := ItemLogDataToStr(go.FGuildItemLog.ItemData[nLine*10+i]);

      if strColumn <> strOldColumn then
      begin
        strLog := Format(' Guild:%s Item%d%d: %s -> %s;',
                         [strGuildName, nLine, i, strOldColumn, strColumn]);
        DBSender.PutPacket(nRequestID, DB_ITEMUPDATE, 0,
                           PChar(strLog), Length(strLog)+1);
        StrToItemLogData(strColumn, go.FGuildItemLog.ItemData[nLine*10+i]);
      end;
    end;

    bSuccess := True;
  end;

  // send message
  if bSuccess then begin
    strLog := Conv('处理完毕');
    DBSender.PutPacket(nRequestID, DB_ITEMUPDATE, 0, PChar(strLog), Length(strLog)+1);
  end else begin
    strLog := Conv('因有错误被取消');
    DBSender.PutPacket(nRequestID, DB_ITEMUPDATE, 1, PChar(strLog), Length(strLog)+1);
  end;
end;

function TfrmGate.AddSendBattleData (aID : Integer; aMsg : Byte; aRetCode : Byte; aData : PChar; aCount : Integer) : Boolean;
begin
   Result := false;
   if BattleSender <> nil then begin
      Result := BattleSender.PutPacket (aID, aMsg, aRetCode, aData, aCount);
   end;
end;

procedure TfrmGate.BattleMessageProcess (aPacket : PTPacketData);
begin
   Case aPacket^.RequestMsg of
      BG_USERCLOSE :
         begin
            ConnectorList.ReStartChar (aPacket^.RequestID);
         end;
      BG_GAMEDATA :
         begin
            ConnectorList.AddSendData (aPacket);
         end;
   end;
end;

procedure TfrmGate.timerProcessTimer(Sender: TObject);
var
   Packet : TPacketData;
begin
   if DBSender <> nil then DBSender.Update;
   if DBReceiver <> nil then begin
      DBReceiver.Update;
      while DBReceiver.Count > 0 do begin
         if DBReceiver.GetPacket (@Packet) = false then break;
         DBMessageProcess (@Packet);
      end;
   end;

   if BattleSender <> nil then BattleSender.Update;
   if BattleReceiver <> nil then begin
      BattleReceiver.Update;
      while BattleReceiver.Count > 0 do begin
         if BattleReceiver.GetPacket (@Packet) = false then break;
         BattleMessageProcess (@Packet);
      end;
   end;
end;

procedure TfrmGate.sckBattleConnectConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
   Size, OptLen : Integer;
begin
   if BattleSender <> nil then begin
      BattleSender.Free;
      BattleSender := nil;
   end;
   if BattleReceiver <> nil then begin
      BattleReceiver.Free;
      BattleReceiver := nil;
   end;
   BattleSender := TPacketSender.Create ('Battle_SENDER', BufferSizeS2S, Socket, true, false);
   BattleReceiver := TPacketReceiver.Create ('Battle_RECEIVER', BufferSizeS2C, true);

   GateList.SetBSGateActive (true);

   Size := 1024 * 64;
   OptLen := SizeOf (Integer);
   SetSockOpt (Socket.SocketHandle, SOL_SOCKET, SO_RCVBUF, @Size, OptLen);
   SetSockOpt (Socket.SocketHandle, SOL_SOCKET, SO_SNDBUF, @Size, OptLen);
end;

procedure TfrmGate.sckBattleConnectDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if BattleSender <> nil then begin
      BattleSender.Free;
      BattleSender := nil;
   end;
   if BattleReceiver <> nil then begin
      BattleReceiver.Free;
      BattleReceiver := nil;
   end;

   GateList.SetBSGateActive (false);
end;

procedure TfrmGate.sckBattleConnectError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   if (ErrorCode <> 10061) and (ErrorCode <> 10038) then begin
      AddLog (format ('BattleConnect Socket Error (%d)', [ErrorCode]));
   end;

   if ErrorCode = 10053 then Socket.Close;
   if ErrorCode = 10061 then Socket.Close;
   
   ErrorCode := 0;
end;

procedure TfrmGate.sckBattleConnectRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   nRead : Integer;
   buffer : array [0..PROCESS_BYTES - 1] of Char;
begin
   while true do begin
      nRead := Socket.ReceiveBuf (buffer, PROCESS_BYTES);
      if nRead > 0 then begin
         if BattleReceiver <> nil then BattleReceiver.PutData (@buffer, nRead);
      end else begin
         break;
      end;
   end;
end;

procedure TfrmGate.sckBattleConnectWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if BattleSender <> nil then BattleSender.WriteAllow := true;
end;

end.
