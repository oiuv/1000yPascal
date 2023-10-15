unit SVMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, inifiles, ExtCtrls,
  uAnsTick, uUser, uconnect, mapunit, fieldmsg, ulevelexp, deftype,
  svClass, basicobj, uMonster, uNpc, aUtil32, Spin, uGuild, Menus, ComCtrls,
  uLetter, uManager, AnsStringCls, uDoorGen, uArena, uZhuang,uFuck;

type

  TFrmMain = class(TForm)
    TimerProcess: TTimer;
    TimerDisplay: TTimer;
    TimerSave: TTimer;
    TimerClose: TTimer;
    MainMenu1: TMainMenu;
    Files1: TMenuItem;
    Save1: TMenuItem;
    Exit1: TMenuItem;
    Env1: TMenuItem;
    LoadBadIpAndNotice1: TMenuItem;
    TimerRain: TTimer;
    MRain: TMenuItem;
    TimerRainning: TTimer;
    MConnection: TMenuItem;
    MDrop100: TMenuItem;
    MView: TMenuItem;
    MGate: TMenuItem;
    MDelGuild: TMenuItem;
    Label5: TLabel;
    lblProcessCount: TLabel;
    Label6: TLabel;
    lblConnectionCount: TLabel;
    Label3: TLabel;
    lblMaxConnectionCount: TLabel;
    lblUserCount: TLabel;
    Label7: TLabel;
    Label2: TLabel;
    SEProcessListCount: TSpinEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lblMonsterCount: TLabel;
    lblNpcCount: TLabel;
    lblItemCount: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    SESelServer: TSpinEdit;
    chkSaveUserData: TCheckBox;
    chkWeather: TCheckBox;
    ViewTrace1: TMenuItem;
    ViewLog1: TMenuItem;
    Label4: TLabel;
    lblDynCount: TLabel;
    Label11: TLabel;
    lblMapUserCount: TLabel;
    LoadHelpFiles1: TMenuItem;
    SaveViewLog1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerProcessTimer(Sender: TObject);
    procedure TimerDisplayTimer(Sender: TObject);
    procedure TimerSaveTimer(Sender: TObject);
    procedure TimerCloseTimer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure LoadBadIpAndNotice1Click(Sender: TObject);
    procedure SEProcessListCountChange(Sender: TObject);
    procedure TimerRainTimer(Sender: TObject);
    procedure MRainClick(Sender: TObject);
    procedure TimerRainningTimer(Sender: TObject);
    procedure MDrop100Click(Sender: TObject);
    procedure MGateClick(Sender: TObject);
    procedure MDelGuildClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure ViewTrace1Click(Sender: TObject);
    procedure ViewLog1Click(Sender: TObject);
    procedure LoadHelpFiles1Click(Sender: TObject);
  private
    BadIpStringList: TStringList;
    NoticeStringList: TStringList;
    CurNoticePosition: integer;

    Rain : TSRainning;
  public
    ServerIni : TIniFile;
    boConnectRemote : Boolean;

    boCloseFlag : Boolean;
    ProcessCount : integer;

    IniDate : string;
    IniHour : integer;

    procedure WriteLogInfo (const aStr : String);
    procedure WriteBadUserLog (aStr : String);
    procedure WriteUserIDLog (aStr : String);
    procedure WriteDumpInfo (aData : PChar; aSize : Integer);
  end;

  procedure AddTrace (const aStr : String);
  procedure AddLog (const aStr : String);

var
  FrmMain: TFrmMain;

  BufferSizeS2S : Integer = 1048576;
  BufferSizeS2C : Integer = 8192;
// add by Orber at 2004-09-10 14:44
  WAITPLAYERTICK: integer = 100000;

  CurrentDate : TDateTime;
  CurrentHour, ItemLogHour : Word;

  boServerActive : Boolean = false;
  MarryBallID : Integer;

// add by minds 050916
  MsgProcTick: Integer = 10;
  CheckMsgProcTick: Boolean = False;

implementation

uses
   FSockets, FGate, FLog, FTrace, uGConnect, uItemLog, uSendCls, uScriptManager, uUtil;

{$R *.DFM}

procedure AddTrace (const aStr : String);
begin
   if boServerActive = true then begin
      frmTrace.txtTrace.Lines.Add (format ('[%s] %s', [TimeToStr (Time), aStr]));
   end;
end;

procedure AddLog (const aStr : String);
begin
   if boServerActive = true then begin
      frmLog.AddLog(format ('[%s] %s', [TimeToStr (Time), aStr]));
   end;
end;

procedure TFrmMain.WriteLogInfo (const aStr : String);
var
   Stream : TFileStream;
   tmpFileName : String;
   szBuf : array[0..1024] of Byte;
begin
   try
      StrPCopy(@szBuf, '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + '] ' + aStr + #13#10);
      tmpFileName := 'TGS1000.LOG';
      if FileExists (tmpFileName) then
         Stream := TFileStream.Create (tmpFileName, fmOpenReadWrite)
      else
         Stream := TFileStream.Create (tmpFileName, fmCreate);

      Stream.Seek(0, soFromEnd);
      Stream.WriteBuffer (szBuf, StrLen(@szBuf));
      Stream.Destroy;
   except
   end;
end;

procedure TFrmMain.WriteBadUserLog (aStr : String);
var
   Stream : TFileStream;
   tmpFileName : String;
   szBuf : array[0..1024] of Byte;
begin
   try
      StrPCopy(@szBuf, '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + '] ' + aStr + #13#10);
      tmpFileName := 'BadUser.LOG';
      if FileExists (tmpFileName) then
         Stream := TFileStream.Create (tmpFileName, fmOpenReadWrite)
      else
         Stream := TFileStream.Create (tmpFileName, fmCreate);

      Stream.Seek(0, soFromEnd);
      Stream.WriteBuffer (szBuf, StrLen(@szBuf));
      Stream.Destroy;
   except
   end;
end;

procedure TFrmMain.WriteUserIDLog (aStr : String);
var
   Stream : TFileStream;
   tmpFileName : String;
   szBuf : array[0..1024] of Byte;
begin
   try
      StrPCopy(@szBuf, '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + '] ' + aStr + #13#10);
      tmpFileName := 'UserLogInID.LOG';
      if FileExists (tmpFileName) then
         Stream := TFileStream.Create (tmpFileName, fmOpenReadWrite)
      else
         Stream := TFileStream.Create (tmpFileName, fmCreate);

      Stream.Seek(0, soFromEnd);
      Stream.WriteBuffer (szBuf, StrLen(@szBuf));
      Stream.Destroy;
   except
   end;
end;

procedure TFrmMain.WriteDumpInfo (aData : PChar; aSize : Integer);
var
   Stream : TFileStream;
   tmpFileName : String;
   iCount : Integer;
begin
   try
      iCount := 0;
      while true do begin
         tmpFileName := 'DUMP' + IntToStr (iCount) + '.BIN';
         if not FileExists (tmpFileName) then break;
         iCount := iCount + 1;
      end;

      Stream := TFileStream.Create (tmpFileName, fmCreate);
      Stream.Seek(0, soFromEnd);
      Stream.WriteBuffer (aData^, aSize);
      Stream.Destroy;
   except
   end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
   cnt : integer;
   nHour, nMin, nSec, nMSec : Word;
    strCode: string;
    wSalt: Word;
begin
   StrCode := ReadCode;
   wSalt := ExtractSalt(strCode);
   if wSalt < GetDefaultSalt then begin
      //Close;
      //exit;
   end;

   Case NATION_VERSION of
      NATION_KOREA, NATION_KOREA_TEST : WriteLogInfo ('GameServer Started (KOREA)');
      NATION_TAIWAN, NATION_TAIWAN_TEST : WriteLogInfo ('GameServer Started (TAIWAN)');
      NATION_CHINA_1, NATION_CHINA_1_TEST : WriteLogInfo ('GameServer Started (CHINA)');
   end;

   CurrentDate := Date;
   DecodeTime (Time, nHour, nMin, nSec, nMSec);
   CurrentHour := nHour;
   ItemLogHour := nHour;

   SEProcessListCount.Value := ProcessListCount;

   boConnectRemote := FALSE;
   boCloseFlag := FALSE;

   BadIpStringList := TStringList.Create;
   NoticeStringList := TStringList.Create;

   ServerINI := TIniFile.Create ('.\sv1000.Ini');

   GameStartDateStr := DateToStr (EncodeDate (GameStartYear, GameStartMonth, GameStartDay));

   GameStartDateStr := ServerIni.ReadString ('SERVER', 'GAMESTARTDATE', GameStartDateStr);
   GameCurrentDate := Round ( Date - StrToDate (GameStartDateStr));
   BufferSizeS2S := ServerINI.ReadInteger ('SERVER', 'BUFFERSIZES2S', 1048576);
   BufferSizeS2C := ServerINI.ReadInteger ('SERVER', 'BUFFERSIZES2C', 8192);
// add by Orber at 2004-09-10 14:44
   WAITPLAYERTICK := ServerINI.ReadInteger ('SERVER', 'WAITPLAYERTIME', 10000);

   cnt := ServerINI.ReadInteger ('DATABASE','COUNT', 0);
   Inc (cnt);
   ServerINI.WriteInteger ('DATABASE', 'COUNT', cnt);

   IniDate := ServerINI.ReadString ('DATABASE', 'DATE', '');
   IniHour := ServerINI.ReadInteger ('DATABASE','HOUR', 0);

   Udp_Item_IpAddress := ServerIni.ReadString ('UDP_ITEM', 'IPADDRESS', '127.0.0.1');
   Udp_Item_Port := ServerIni.ReadInteger ('UDP_ITEM', 'PORT', 6001);

   Udp_MouseEvent_IpAddress := ServerIni.ReadString ('UDP_MOUSEEVENT', 'IPADDRESS', '127.0.0.1');
   Udp_MouseEvent_Port := ServerIni.ReadInteger ('UDP_MOUSEEVENT', 'PORT', 6001);

   Udp_Moniter_IpAddress := ServerIni.ReadString ('UDP_MONITER', 'IPADDRESS', '127.0.0.1');
   Udp_Moniter_Port := ServerIni.ReadInteger ('UDP_MONITER', 'PORT', 6000);

   Udp_Connect_IpAddress := ServerIni.ReadString ('UDP_CONNECT', 'IPADDRESS', '127.0.0.1');
   Udp_Connect_Port := ServerIni.ReadInteger ('UDP_CONNECT', 'PORT', 6022);

   Udp_Pay_IpAddress := ServerIni.ReadString ('UDP_PAY', 'IPADDRESS', '127.0.0.1');
   Udp_Pay_Port := ServerIni.ReadInteger ('UDP_PAY', 'PORT', 6000);

   Udp_Object_IpAddress := ServerIni.ReadString ('UDP_OBJECT', 'IPADDRESS', '127.0.0.1');
   Udp_Object_Port := ServerIni.ReadInteger ('UDP_OBJECT', 'PORT', 3003);

   Udp_Relation_IpAddress := ServerIni.ReadString ('UDP_RELATION', 'IPADDRESS', '127.0.0.1');
   Udp_Relation_Port := ServerIni.ReadInteger ('UDP_RELATION', 'PORT', 3005);

   DBServerIPAddress := ServerIni.ReadString ('DB_SERVER', 'IPADDRESS', '127.0.0.1');
   DBServerPort := ServerIni.ReadInteger ('DB_SERVER', 'PORT', 3051);
   BattleServerIPAddress := ServerIni.ReadString ('BATTLE_SERVER', 'IPADDRESS', '127.0.0.1');
   BattleServerPort := ServerIni.ReadInteger ('BATTLE_SERVER', 'PORT', 3040);

   NoticeServerIpAddress := ServerIni.ReadString ('NOTICE_SERVER', 'IPADDRESS', '127.0.0.1');
   NoticeServerPort := ServerIni.ReadInteger ('NOTICE_SERVER', 'PORT', 3020);

   ScriptManager.LoadFromFile ('.\Script\Script.SDB');

   ManagerList := TManagerList.Create;

   SESelServer.MaxValue := ManagerList.Count - 1;

   GateConnectorList := TGateConnectorList.Create;

   ConnectorList := TConnectorList.Create;
   UserList := TUserList.Create (100);
   ArenaObjList := TArenaObjList.Create;
   GuildList := TGuildList.Create;
   ExitGuildList := TExitGuildList.Create;
   Zhuang := TZhuangObject.Create;
   GateList := TGateList.Create;
   GateListEx := TGateListEx.Create;
   GroupMoveList := TGroupMoveList.Create;
   MirrorList := TMirrorList.Create;
   ZoneEffectList := TZoneEffectList.Create;

   SoundObjList := TSoundObjList.Create;

   LetterManager := TLetterManager.Create (7, 1000, 'UserLetter.TXT');

   TimerProcess.Interval := 10;
   TimerProcess.Enabled := TRUE;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
   TimerProcess.Enabled := false;
   TimerSave.Enabled := false;
   TimerDisplay.Enabled := false;

   SoundObjList.Free;

   LetterManager.Free;

   MirrorList.Free;
   GateList.Free;
   GateListEx.Free;
   GroupMoveList.Free;
   ZoneEffectList.Free;
   Zhuang.Free;
   GuildList.Free;
   ExitGuildList.Free;

   UserList.free;
   ConnectorList.free;
   GateConnectorList.Free;
   ManagerList.Free;

   ServerINI.Free;
   NoticeStringList.Free;
   BadIpStringList.Free;

   WriteLogInfo ('GameServer Exit');
end;

procedure TFrmMain.TimerSaveTimer(Sender: TObject);
const
   OldDate : string = '';
var
   n, nCount : integer;
   Str: string;
   usd : TStringData;
   nYear, nMonth, nDay : Word;
   nHour, nMin, nSec, nMSec : Word;
begin
   if TimerClose.Enabled = true then exit;

   if OldDate <> DateToStr (Date) then begin
      OldDate := DateToStr (Date);
      GameCurrentDate := Round ( Date - StrToDate (GameStartDateStr));
      NameStringListForDeleteMagic.Clear;
   end;

   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
      DecodeTime (Time, nHour, nMin, nSec, nMSec);
      if nHour <> ItemLogHour then begin
         if nHour = 3 then begin
            Str := '.\ItemLog\Backup\ItemLog' + GetDateByStr (Date) + '.SDB';
            ItemLog.SaveToSDB (Str);
         end;
         ItemLogHour := nHour;
      end;
   end else begin
      if Date <> CurrentDate then begin
         DecodeDate (CurrentDate, nYear, nMonth, nDay);
         Str := '.\ItemLog\Backup\ItemLog';
         Str := Str + IntToStr (nYear) + '-';
         if nMonth < 10 then Str := Str + '0';
         Str := Str + IntToStr (nMonth) + '-';
         if nDay < 10 then Str := Str + '0';
         Str := Str + IntToStr (nDay) + '.SDB';
         ItemLog.SaveToSDB (Str);

         CurrentDate := Date;
      end;
   end;

   str := TimeToStr (Time);
   if Pos (Conv('AM'), str) > 0 then GrobalLightDark := gld_dark
   else GrobalLightDark := gld_light;

   if NoticeStringList.Count > 0 then begin
      if CurNoticePosition >= NoticeStringList.Count then CurNoticePosition := 0;
      UserList.SendNoticeMessage ( NoticeStringList[CurNoticePosition], SAY_COLOR_NOTICE);
      inc (CurNoticePosition);
   end;

   usd.rmsg := 1;

   nCount := UserList.Count;
   SetWordString (usd.rWordString, IntToStr (nCount));
   n := sizeof(TStringData) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);
   FrmSockets.UdpMoniterAddData (n, @usd);
end;

procedure TFrmMain.TimerCloseTimer(Sender: TObject);
begin
   if (UserList.Count = 0) and (ConnectorList.Count = 0) and (ConnectorList.GetSaveListCount = 0) then begin
      if TimerClose.Interval = 1000 then begin
         TimerClose.Interval := 5000;
         exit;
      end;
      Close;
   end else begin
      ConnectorList.CloseAllConnect;
   end;
end;

procedure TFrmMain.Exit1Click(Sender: TObject);
begin
   boCloseFlag := true;

   TimerClose.Interval := 1000;
   TimerClose.Enabled := TRUE;
end;

procedure TFrmMain.LoadBadIpAndNotice1Click(Sender: TObject);
begin
   if FileExists ('BadIpAddr.txt') then BadIpStringList.LoadFromFile ('BadIpAddr.txt');
   if FileExists ('Notice.txt') then NoticeStringList.LoadFromFile ('Notice.txt');
   if FileExists ('Tip.txt') then TipStrList.LoadFromFile ('Tip.txt');

   Udp_Item_IpAddress := ServerIni.ReadString ('UDP_ITEM', 'IPADDRESS', '127.0.0.1');
   Udp_Item_Port := ServerIni.ReadInteger ('UDP_ITEM', 'PORT', 6001);

   Udp_MouseEvent_IpAddress := ServerIni.ReadString ('UDP_MOUSEEVENT', 'IPADDRESS', '127.0.0.1');
   Udp_MouseEvent_Port := ServerIni.ReadInteger ('UDP_MOUSEEVENT', 'PORT', 6001);

   Udp_Moniter_IpAddress := ServerIni.ReadString ('UDP_MONITER', 'IPADDRESS', '127.0.0.1');
   Udp_Moniter_Port := ServerIni.ReadInteger ('UDP_MONITER', 'PORT', 6000);

   Udp_Connect_IpAddress := ServerIni.ReadString ('UDP_CONNECT', 'IPADDRESS', '127.0.0.1');
   Udp_Connect_Port := ServerIni.ReadInteger ('UDP_CONNECT', 'PORT', 6022);

   Udp_Pay_IpAddress := ServerIni.ReadString ('UDP_PAY', 'IPADDRESS', '127.0.0.1');
   Udp_Pay_Port := ServerIni.ReadInteger ('UDP_PAY', 'PORT', 6000);
   
   Udp_Object_IpAddress := ServerIni.ReadString ('UDP_OBJECT', 'IPADDRESS', '127.0.0.1');
   Udp_Object_Port := ServerIni.ReadInteger ('UDP_OBJECT', 'PORT', 3003);

   Udp_Relation_IpAddress := ServerIni.ReadString ('UDP_RELATION', 'IPADDRESS', '127.0.0.1');
   Udp_Relation_Port := ServerIni.ReadInteger ('UDP_RELATION', 'PORT', 3005);

   NoticeServerIpAddress := ServerIni.ReadString ('NOTICE_SERVER', 'IPADDRESS', '127.0.0.1');
   NoticeServerPort := ServerIni.ReadInteger ('NOTICE_SERVER', 'PORT', 3020);

   frmSockets.ReConnectNoticeServer (NoticeServerIPAddress, NoticeServerPort);

   CurNoticePosition := 0;

   LoadGameIni ('.\game.ini');

   SystemAlert.LoadFromFile;                    
end;

procedure TFrmMain.SEProcessListCountChange(Sender: TObject);
begin
   ProcessListCount := SEProcessListCount.Value;
end;

procedure TFrmMain.TimerDisplayTimer(Sender: TObject);
var
   Manager : TManager;
   nHour, nMin, nSec, nMSec : Word;
begin
   lblProcessCount.Caption := IntToStr (ProcessCount);
   ProcessCount := 0;

   if ConnectorList <> nil then begin
      if MaxConnectionCount < ConnectorList.Count then begin
         MaxConnectionCount := ConnectorList.Count;
         lblMaxConnectionCount.Caption := IntToStr (MaxConnectionCount);
      end;
      lblConnectionCount.Caption := IntToStr (ConnectorList.Count);
   end;

   if UserList <> nil then begin
      lblUserCount.Caption := IntToStr (UserList.Count);
   end;

   if ManagerList <> nil then begin
      Manager := ManagerList.GetManagerByIndex (SeSelServer.Value);
      if Manager <> nil then begin
         lblMonsterCount.Caption := IntToStr (TMonsterList (Manager.MonsterList).Count);
         lblNpcCount.Caption := IntToStr (TNpcList (Manager.NpcList).Count);
         lblItemCount.Caption := IntToStr (TItemList (Manager.ItemList).Count);
         lblDynCount.Caption := IntToStr (TDynamicObjectList (Manager.DynamicObjectList).Count);
         lblMapUserCount.Caption := IntToStr (Manager.UserCount);
      end;
   end;

   if NATION_VERSION = NATION_KOREA then begin
      Caption := format ('VirtueMulti : %d, ExpMulti : %d Real Server', [VirtueMulti, ExpMulti]);//º»¼·
   end else if NATION_VERSION = NATION_KOREA_TEST then begin
      Caption := format ('VirtueMulti : %d, ExpMulti : %d Test Server', [VirtueMulti, ExpMulti]);//½ÇÇè¼·
   end;

   DecodeTime (Time, nHour, nMin, nSec, nMSec);
   if nHour <> CurrentHour then begin
      // GuildList.CompactGuild;
      GuildList.SaveToFile ('.\Guild\CreateGuild.SDB');
//      if nHour = 6 then begin
//         GuildList.SaveToFileForWeb ('.\Web\Guild' + GetDateByStr (Date) + '.SDB');
//      end;
      CurrentHour := nHour;
   end;
end;

procedure TFrmMain.TimerProcessTimer(Sender: TObject);
var
   CurTick : integer;
begin
   CurTick := mmAnsTick;

   GateConnectorList.Update (CurTick);

   WaitPlayerList.Update (CurTick);

   PrisonClass.Update (CurTick);

   ConnectorList.Update (CurTick);
   UserList.Update (CurTick);
   if boCloseFlag = false then begin
      ManagerList.Update (CurTick);
   end;

   GateList.Update (CurTick);
   GateListEx.Update (CurTick);

   GuildList.Update (CurTick);
   MirrorList.Update (CurTick);
   ZoneEffectList.Update (CurTick);

  // add by Orber at 2005-01-28 07:24:03
   ArenaObjList.Update(CurTick);
   Zhuang.Update(CurTick);
   // ItemGen.Update (CurTick);
   // ObjectChecker.Update (CurTick);

   SoundObjList.Update (CurTick);
   ScriptManager.Update (CurTick);

   inc (ProcessCount);
end;

procedure TFrmMain.TimerRainTimer(Sender: TObject);
var
   nYear, nMonth, nDay : Word;
   nHour, nMin, nSec, nMSec : Word;
   boSnow : boolean;
begin
   if chkWeather.Checked = false then exit;

   try
      DecodeDate (Date, nYear, nMonth, nDay);
      DecodeTime (Time, nHour, nMin, nSec, nMSec);
   except
      exit;
   end;

   boSnow := true;
   if (nMonth > 2) and (nMonth < 12) then begin
      boSnow := false;
   end else if (nMonth = 2) or (nMonth = 12) then begin
      if Random (10) > 2 then begin
         boSnow := false;
      end;
   end;

   if boSnow = false then begin
      Rain.rmsg := SM_RAINNING;
      Rain.rspeed := 10;
      Rain.rCount := 200;
      Rain.rOverray := 50;
      Rain.rTick := 600;
      Rain.rRainType := RAINTYPE_RAIN;
   end else begin
      Rain.rmsg := SM_RAINNING;
      Rain.rspeed := 1;
      Rain.rCount := 200;
      Rain.rOverray := 20;
      Rain.rTick := 600;
      Rain.rRainType := RAINTYPE_SNOW;
   end;

   TimerRainning.Enabled := TRUE;
end;

procedure TFrmMain.MRainClick(Sender: TObject);
begin
   TimerRainTimer (Self);
end;

procedure TFrmMain.TimerRainningTimer(Sender: TObject);
const
   RainTick : integer = 0;
var
   SendCount : Integer;
begin
   if chkWeather.Checked = false then exit;
   
   // Speed, Count, Overray, Tick
   UserList.SendRaining (Rain);

   SendCount := 20;
   if Rain.rRainType = RAINTYPE_SNOW then SendCount := 60;
   RainTick := RainTick + 1;
   if RainTick > SendCount then begin
      RainTick := 0;
      TimerRainning.Enabled := FALSE;
   end;
end;

procedure TFrmMain.MDrop100Click(Sender: TObject);
begin
   //
end;

procedure TFrmMain.MGateClick(Sender: TObject);
begin
   frmGate.Show;
end;

procedure TFrmMain.MDelGuildClick(Sender: TObject);
begin
   GuildList.CompactGuild;
end;

procedure TFrmMain.FormActivate (Sender: TObject);
begin
   boServerActive := true;
   LoadBadIpAndNotice1Click (Self);
end;

procedure TFrmMain.FormClick(Sender: TObject);
begin
   MaxPacketCount := 0;
   MaxViewCount := 0;
   MaxDelayUserTick := 0;
   MaxDelayMonsterTick := 0;
   MaxDelayNpcTick := 0;
   MaxDelayGuildTick := 0;
   MaxDelayGateTick := 0;
   MaxDelayGateConnectorTick := 0;
   MaxDelayDynamicTick := 0;
   MaxDelayMineTick := 0;
end;

procedure TFrmMain.ViewTrace1Click(Sender: TObject);
begin
   frmTrace.Show;
end;

procedure TFrmMain.ViewLog1Click(Sender: TObject);
begin
   frmLog.Show;
end;

procedure TFrmMain.LoadHelpFiles1Click(Sender: TObject);
begin
   HelpFiles.LoadHelpFiles;
end;

end.
