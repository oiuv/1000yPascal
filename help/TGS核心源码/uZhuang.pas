unit uZhuang;

interface

uses
   Classes, SysUtils, BasicObj, DefType, UserSDB, AUtil32, uManager,
   uMonster, AnsStringCls, uUser , uGuild;

const
    FIGHT_TIME  = 20;

type
   TZhuangObject = class
   private
   protected
   public
      ZhuangFlag : TDynamicObject;
      TicketPrice:integer;
      AmountMoney:integer;
      LastFlagLife : Integer;
      LastShootFight : String[2];
      MasterGuild:TGuildObject;
      SlaveGuild:array [0..4-1] of  TGuildObject;
      FightState : Boolean;
      FightStartTick : integer;
      LastCheckMoney: integer;  {上次结算门票收入的时间}
      constructor Create;
      destructor Destroy; override;

      procedure Initial;
      procedure SetTicketPrice (aTicketPrice:integer);
      function GetTicketPrice:integer;
      function isZhuangMaster(aName:String):Boolean;
      function GetZhuangMaster:String;
      function AskConquer(aGuildName:String):Integer;
      function GetZhuangInto(aUser:TUser) : String;

//      function IntoZhuang(aUser:TUser):Boolean;
      procedure LoadFromFile (aFileName :String);
      procedure SaveToFile (aFileName :String);
      procedure Update (CurTick: integer);
   end;

var
    Zhuang : TZhuangObject;
    UpdateItemTick :integer;

implementation

uses
   svClass, SubUtil;

constructor TZhuangObject.Create;
begin
    Initial;
end;

destructor TZhuangObject.Destroy;
begin
   SaveToFile('.\Init\Zhuang.SDB');
    inherited Destroy;
end;

procedure TZhuangObject.SetTicketPrice(aTicketPrice:integer);
begin
    TicketPrice := aTicketPrice;
    if aTicketPrice > 100000 then TicketPrice := 100000;
    if aTicketPrice < 10000 then TicketPrice :=10000;
end;

function TZhuangObject.GetTicketPrice:integer;
begin
    result := TicketPrice;
end;

function TZhuangObject.isZhuangMaster(aName:String):Boolean;
begin
    result := MasterGuild.IsGuildSysop(aName);
end;

function TZhuangObject.GetZhuangMaster:String;
begin
    result := MasterGuild.GetGuildSysop;
end;

function TZhuangObject.GetZhuangInto(aUser:TUser) : String;
var ItemData:TItemData;
begin
    if MasterGuild <> nil then begin
        if MasterGuild.GuildName = aUser.GuildName then begin
            result := 'ok';
            Exit;
        end;
        if FightState then begin
            if (aUser.GuildName <> MasterGuild.GuildName) and (aUser.GuildName <> SlaveGuild[0].GuildName) then begin
                result := 'fight';
                Exit;
            end else begin
                result := 'ok';
                Exit;
            end;
        end;
    end;
    ItemClass.GetItemData(Conv('聚贤庄进门券'),ItemData);
    ItemData.rCount := 1;
    if Not aUser.DeleteItem(@ItemData) then begin
        result := 'noticket';
        exit;
    end;
    Inc(AmountMoney,TicketPrice);
    result := 'ok';
end;

function TZhuangObject.AskConquer(aGuildName:String):Integer;
var i :integer;
begin
    Result := -2;
    if MasterGuild = nil then begin
        MasterGuild := GuildList.GetGuildObject(aGuildName);
        if MasterGuild.GetGuildEnergyLevel < 10 then begin
            Result := 8;
            MasterGuild := nil;
            Exit;
        end;
        Result := 9;
        Exit;
    end;
    if aGuildName = MasterGuild.GuildName then begin
        Result := 7;
        Exit;
    end;
    for i :=  0 to 3 - 1 do begin
      if SlaveGuild[i] <> nil then begin
        if SlaveGuild[i].GuildName = aGuildName then begin
            Result := 6;
            Break;
        end else begin
          Continue;
        end;
      end;
      SlaveGuild[i] := GuildList.GetGuildObject(aGuildName);
      Result := i;
      Break;
    end;
end;

procedure TZhuangObject.Initial;
var zFlag : Pointer;
    aManager : TManager;
begin
    aManager := ManagerList.GetManagerByIndex(1);
    ZhuangFlag := TDynamicObjectList(aManager.DynamicObjectList).GetDynamicObjectbyName(Conv('聚贤庄大旗'));
    TicketPrice := 50000;
    LastFlagLife := ZhuangFlag.SGetLife;
    AmountMoney := 0;
    FightState := False;
    LoadFromFile ('.\Init\Zhuang.SDB');
end;

procedure TZhuangObject.Update (CurTick: integer);
var i:integer;
    aUser : TUser;
    aItemData :TItemData;
begin
    if (LastCheckMoney > 0) and (LastCheckMoney <> StrToInt(FormatDateTime('H',Now))) then begin
        if MasterGuild <> nil then begin
          Inc(MasterGuild.Bank,Trunc(AmountMoney/10));
          AmountMoney := 0;
        end;
    end;

    if Not FightState then begin
        if (DayOfWeek(Date) = 7) and (Time >= StrToTime('19:00:00')) and (Time <= StrToTime('20:30:00')) then begin
            if (MasterGuild <> nil) and (SlaveGuild[0] <> nil) then begin
                ZhuangFlag.SetLife(5000000);
                ZhuangFlag.SetArmor(1000);
                FightState := True;
                UserList.SendCenterMessage(Conv('聚贤庄门派领土大战开始了！'));
            end;
        end else if (DayOfWeek(Date) = 7) and (Time >= StrToTime('18:50:00')) and (Time < StrToTime('19:00:00')) then begin
            if (MasterGuild <> nil) and (SlaveGuild[0] <> nil) then begin
                UserList.KickMemberFromZhuang;
            end;
        end;
    end else begin
        {if (FormatDateTime('ss',Now)  = '00') and (LastShootFight <> FormatDateTime('mm',Now) ) then begin
            UserList.SendTopMessage(Conv('聚贤庄正在大战中……'));
            LastShootFight := FormatDateTime('mm',Now);
        end;}
        if LastFlagLife <> ZhuangFlag.SGetLife then Begin
            //UserList.SendTopMessage('聚贤庄大旗被攻击');
            LastFlagLife := ZhuangFlag.SGetLife;
        end;
        if LastFlagLife <= 0 then begin
            //激活战争结束事件--攻方胜利;
            ItemClass.GetItemData(Conv('钱币'),aItemData);
            aUser := UserList.GetUserPointer(SlaveGuild[0].GetGuildSysop);
            if aUser <> nil then begin
                aItemData.rCount := 500000;
                aUser.AddItem(aItemData);
                Inc(SlaveGuild[0].Bank,500000);
                Dec(MasterGuild.Bank,1000000);
            end else begin
                Inc(SlaveGuild[0].Bank,1000000);
                Dec(MasterGuild.Bank,1000000);
            end;
            UserList.SendCenterMessage(Conv('聚贤庄领土战中' + SlaveGuild[0].GuildName + '门派战胜' + MasterGuild.GuildName));
            MasterGuild := SlaveGuild[0];
            SlaveGuild[0] := SlaveGuild[1];
            SlaveGuild[1] := SlaveGuild[2];
            SlaveGuild[2] := SlaveGuild[3];
            ZhuangFlag.SetLife(5000000);
            ZhuangFlag.SetArmor(1000);
            FightState := False;
            Exit;
        end;
        if Time > StrToTime('20:30:00') then begin
            //激活战争结束事件--守方胜利;
            ItemClass.GetItemData(Conv('钱币'),aItemData);
            aUser := UserList.GetUserPointer(MasterGuild.GetGuildSysop);
            if aUser <> nil then begin
                aItemData.rCount := 500000;
                aUser.AddItem(aItemData);
                Inc(MasterGuild.Bank,500000);
                Dec(SlaveGuild[0].Bank,1000000);
            end else begin
                Inc(MasterGuild.Bank,1000000);
                Dec(SlaveGuild[0].Bank,1000000);
            end;
            UserList.SendTopMessage(Conv('聚贤庄门派领土大战中' + SlaveGuild[0].GuildName + '门派战胜了' + MasterGuild.GuildName));
            MasterGuild := SlaveGuild[0];
            SlaveGuild[0] := SlaveGuild[1];
            SlaveGuild[1] := SlaveGuild[2];
            SlaveGuild[2] := SlaveGuild[3];
            ZhuangFlag.SetLife(5000000);
            ZhuangFlag.SetArmor(1000);
            FightState := False;
            Exit;
        end;
    end;
end;

procedure TZhuangObject.SaveToFile(aFileName : String);
var
   str: string;
   StringList : TStringList;
   MasterGuildName,SlaveGuild0Name,SlaveGuild1Name,SlaveGuild2Name,SlaveGuild3Name :String;
begin
    if SlaveGuild[0] <> nil then SlaveGuild0Name := SlaveGuild[0].GuildName;
    if SlaveGuild[1] <> nil then SlaveGuild1Name := SlaveGuild[1].GuildName;
    if SlaveGuild[2] <> nil then SlaveGuild2Name := SlaveGuild[2].GuildName;
    if SlaveGuild[3] <> nil then SlaveGuild3Name := SlaveGuild[3].GuildName;
    if MasterGuild <> nil then MasterGuildName := MasterGuild.GuildName;

    StringList := TStringList.Create;
    str := 'MasterGuildName,SlaveGuildName,SlaveGuildName1,SlaveGuildName2,SlaveGuildName3,TicketPrice';
    StringList.add (str);
    str := MasterGuildName + ',' + SlaveGuild0Name + ',' + SlaveGuild1Name+ ',' + SlaveGuild2Name + ',' + SlaveGuild3Name + ',' + IntToStr(TicketPrice);
    StringList.Add (str);
    StringList.SaveToFile (aFileName);
    StringList.Free;
end;
procedure TZhuangObject.LoadFromFile (aFileName : String);
var
   i : Integer;
   iName : String;
   FileName : String;
   DB : TUserStringDB;
   zhuang : TZhuangObject;
   GuildName :String;

begin
    if not FileExists (aFileName) then exit;

    DB := TUserStringDB.Create;
    DB.LoadFromFile (aFileName);
    for i := 0 to DB.Count - 1 do begin
        iName := DB.GetIndexName (i);
        if iName = '' then continue;
        GuildName := DB.GetFieldValueString (iName, 'MasterGuildName');
        if GuildName <> '' then begin
            MasterGuild := GuildList.GetGuildObject(GuildName);
        end;
        GuildName := DB.GetFieldValueString (iName, 'SlaveGuildName');
        if GuildName <> '' then begin
            SlaveGuild[0] := GuildList.GetGuildObject(GuildName);
        end;
        GuildName := DB.GetFieldValueString (iName, 'SlaveGuildName1');
        if GuildName <> '' then begin
            SlaveGuild[1] := GuildList.GetGuildObject(GuildName);
        end;
        GuildName := DB.GetFieldValueString (iName, 'SlaveGuildName2');
        if GuildName <> '' then begin
            SlaveGuild[2] := GuildList.GetGuildObject(GuildName);
        end;
        GuildName := DB.GetFieldValueString (iName, 'SlaveGuildName3');
        if GuildName <> '' then begin
            SlaveGuild[3] := GuildList.GetGuildObject(GuildName);
        end;
    end;
    DB.Free;

end;



end.

