unit uGuildSub;

interface

uses
   Windows, Sysutils, Classes, aDefType, Deftype, BasicObj, SvClass,
   SubUtil, uSkills, uLevelExp, uUser, aUtil32, AnsUnit,
   FieldMsg, MapUnit, AnsStringCls;


type
   TGuildUserData = record
     rName: string[32];
     rGradeName : string[32];
     rLastDay : integer;
     rSaveMoney : Integer;
     rLoadMoney : Integer;
     rMoneyChip : Integer;
     rTodayMoney : Integer;
     rLastDate : String[10]
   end;
   PTGuildUserData = ^TGuildUserData;

   TGuildUserList = Class
    private
     boChanged : boolean;
     IndexClass: TAnsIndexClass;
     DataList : TList;
    public
     constructor Create;
     destructor  Destroy; override;
     procedure   LoadFromFile (aFileName: string);
     procedure   SaveToFile (aFileName: string);
     procedure   Clear;
     procedure   AddUser (aUserName: string);
     procedure   DoChange;
     function    DelUser (aUserName: string): Boolean;
     function    GetGradeName (aUserName: string): string;
     function    GetUser (aUserName: string): PTGuildUserData;
     procedure   SetGradeName (aUserName, aGradeName: string);
     function    IsGuildUser (aUserName: string): Boolean;
     function    GetGuildCount : integer;

     property    Changed : boolean read boChanged;
   end;

   TGuildNpc = class (TLifeObject)
   private
      pGuildNpcData : PTNpcData;
      TargetPosTick : integer;
      TargetX, TargetY : integer;
      TargetId : integer;
      ParentGuildObject : TBasicObject;
      
      function IsSysopName (aname: string) : boolean;
      procedure  SetTargetId (aid: integer);
   protected
      procedure  SetNpcAttrib;
   public
      GuildNpcName : String;
      Sex : Byte;
      boMagicNpc : Boolean;
      StartX, StartY: integer;
      RestX, RestY: integer;
      GuildMagicData : TMagicData;

      constructor Create;
      destructor Destroy; override;
      procedure  StartProcess; override;
      procedure  EndProcess; override;
      function   FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
      procedure  Initial (go : TBasicObject; aNpcName: string; ax, ay: integer; aSex : Byte);
      // procedure  SetSysop (aSysop, aSubSysop0, aSubSysop1, aSubSysop2: string);
      procedure  Update (CurTick: integer); override;

      procedure  MoveGuildNpc (aServerID, ax, ay: integer);
      procedure  MoveDieGuildNpc (aServerID, ax, ay: integer);
   end;

implementation

uses
   uGuild, uManager, uCharCheck;

/////////////////////////////////
//      Guild User List
/////////////////////////////////
constructor TGuildUserList.Create;
begin
   boChanged := false;
   IndexClass := TAnsIndexClass.Create ('user', 20, TRUE);
   DataList := TList.Create;
end;

destructor  TGuildUserList.Destroy;
begin
   Clear;
   DataList.Free;
   IndexClass.Free;
   inherited destroy;
end;

procedure   TGuildUserList.Clear;
var i: integer;
begin
   for i := 0 to DataList.Count -1 do dispose (DataList[i]);
   DataList.Clear;
   IndexClass.Clear;
end;

procedure   TGuildUserList.LoadFromFile (aFileName: string);
var
   i: integer;
   str, rdstr: string;
   StringList : TStringList;
   p : PTGuildUserData;
begin
   Clear;
   if not FileExists (aFileName) then exit;

   StringList := TStringList.Create;
   StringList.LoadFromFile (aFileName);

   for i := 1 to StringList.Count -1 do begin    // 1∫Œ≈Õ¥¬ √π¡Ÿ¿Ã « µÂ¿Ã±‚∂ßπÆø°..
      str := StringList[i];
      new (p);
      str := GetValidStr3 (str, rdstr, ',');
      p^.rName := rdstr;
      str := GetValidStr3 (str, rdstr, ',');
      p^.rGradeName := rdstr;
      str := GetValidStr3 (str, rdstr, ',');
      p^.rLastDay := _StrToInt (rdstr);
      if p^.rLastDay = 0 then p^.rLastDay := GameCurrentDate;
      str := GetValidStr3 (str, rdstr, ',');
      p^.rSaveMoney := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ',');
      p^.rLoadMoney := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ',');
      p^.rMoneyChip := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ',');
      p^.rTodayMoney := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ',');
      p^.rLastDate := rdstr;

      IndexClass.Insert (Integer(p), p^.rName);
      DataList.Add (p);
   end;
   StringList.Free;
end;

procedure   TGuildUserList.SaveToFile (aFileName: string);
var
   i: integer;
   str: string;
   StringList : TStringList;
   p : PTGuildUserData;
begin
   if boChanged = true then begin
      StringList := TStringList.Create;
      str := 'Name,GradeName,LastDay,SaveMoney,LoadMoney,MoneyChip,TodayMoney,LastDate';
      StringList.add (str);
      for i := 0 to DataList.Count -1 do begin
         p := DataList[i];
         str := p^.rName + ',' + p^.rGradeName + ',' + IntToStr (p^.rLastDay)+ ',' + IntToStr (p^.rSaveMoney)+ ',' + IntToStr (p^.rLoadMoney) + ',' + IntToStr (p^.rMoneyChip)+ ',' + IntToStr (p^.rTodayMoney)+ ',' + p^.rLastDate;
         StringList.Add (str);
      end;
      StringList.SaveToFile (aFileName);
      StringList.Free;
      boChanged := false;
   end;
end;

function TGuildUserList.GetGradeName (aUserName: string): string;
var
   n : integer;
begin
   Result := '';
   n := IndexClass.Select (aUserName);
   if (n <> 0) and (n <> -1) then begin
      PTGuildUserData(n)^.rLastDay := GameCurrentDate;
      Result := PTGuildUserData (n)^.rGradeName;
   end;
end;

function TGuildUserList.GetUser (aUserName: string): PTGuildUserData;
var
   n : integer;
begin
   n := IndexClass.Select (aUserName);
   if (n <> 0) and (n <> -1) then begin
        Result := PTGuildUserData(n);
   end;
end;


procedure   TGuildUserList.SetGradeName (aUserName, aGradeName: string);
var
   n : integer;
begin
   n := IndexClass.Select (aUserName);
   if (n <> 0) and (n <> -1) then begin
      PTGuildUserData (n)^.rGradeName := aGradeName;
      boChanged := true;
   end;
end;

  // add by Orber at 2005-01-12 02:42:20
procedure TGuildUserList.DoChange;
begin
    boChanged := True;
end;

procedure   TGuildUserList.AddUser (aUserName: string);
var
   n : integer;
   p : PTGuildUserData;
begin
   n := IndexClass.Select (aUserName);
   if (n <> 0) and (n <> -1) then exit
   else begin
      new (p);
      p^.rName := aUserName;
      p^.rGradeName := '';
      p^.rLastDay := GameCurrentDate;
      p^.rSaveMoney := 0;
      p^.rLoadMoney := 0;
      p^.rMoneyChip := 0;
      p^.rTodayMoney := 0 ;
      p^.rLastDate := '1980-10-29';

      DataList.Add (p);
      IndexClass.Insert (Integer(p), aUserName);

      boChanged := true;
   end;
end;

function    TGuildUserList.IsGuildUser (aUserName: string): Boolean;
var
   n : integer;
begin
   n := IndexClass.Select (aUserName);
   if (n <> 0) and (n <> -1) then Result := TRUE
   else Result := FALSE;
end;

function TGuildUserList.GetGuildCount : integer;
begin
    result := DataList.Count;
end;

function    TGuildUserList.DelUser (aUserName: string): Boolean;
var i, n : integer;
begin
   n := IndexClass.Select (aUserName);
   if (n <> 0) and (n <> -1) then begin
      for i := 0 to DataList.Count -1 do begin
         if aUserName = PTGuildUserData (DataList[i])^.rname then begin
            dispose (DataList[i]);
            DataList.Delete (i);
            IndexClass.Delete (aUserName);
            boChanged := true;
            break;
         end;
      end;
      Result := TRUE;
   end else Result := FALSE;
end;

///////////////////////////////////////////


/////////////////////////////////////
//       Npc
////////////////////////////////////
constructor TGuildNpc.Create;
begin
   inherited Create;
   pGuildNpcData := nil;
   Sex := 1;
end;

destructor TGuildNpc.Destroy;
begin
   pGuildNpcData := nil;
   inherited destroy;
end;

procedure TGuildNpc.SetTargetId (aid: integer);
begin
   if aid = BasicData.id then exit;
   TargetId := aid;

   if TargetID <> 0 then LifeObjectState := los_attack
   else LifeObjectState := los_none;
end;

procedure TGuildNpc.SetNpcAttrib;
begin
   if pGuildNpcData = nil then exit;

   LifeData.damagebody      := LifeData.damagebody      + pGuildNpcData^.rDamage;
   LifeData.damagehead      := LifeData.damagehead      + 0;
   LifeData.damagearm       := LifeData.damagearm       + 0;
   LifeData.damageleg       := LifeData.damageleg       + 0;
   LifeData.AttackSpeed     := LifeData.AttackSpeed     + pGuildNpcData^.rAttackSpeed;
   LifeData.avoid           := LifeData.avoid           + pGuildNpcData^.ravoid;
   LifeData.recovery        := LifeData.recovery        + pGuildNpcData^.rrecovery;
   LifeData.Accuracy        := LifeData.Accuracy;
   LifeData.KeepRecovery    := LifeData.KeepRecovery;
   LifeData.armorbody       := LifeData.armorbody       + pGuildNpcData^.rarmor;
   LifeData.armorhead       := LifeData.armorhead       + pGuildNpcData^.rarmor;
   LifeData.armorarm        := LifeData.armorarm        + pGuildNpcData^.rarmor;
   LifeData.armorleg        := LifeData.armorleg        + pGuildNpcData^.rarmor;

   BasicData.Feature.raninumber := pGuildNpcData^.rAnimate;
   BasicData.Feature.rImageNumber := pGuildNpcData^.rShape;

   MaxLife := pGuildNpcData^.rLife;
   ActionWidth := pGuildNpcData^.rActionWidth;

   SoundNormal := pGuildNpcData^.rSoundNormal;
   SoundAttack := pGuildNpcData^.rSoundAttack;
   SoundDie := pGuildNpcData^.rSoundDie;
   SoundStructed := pGuildNpcData^.rSoundStructed;
end;

{
procedure  TGuildNpc.SetSysop (aSysop, aSubSysop0, aSubSysop1, aSubSysop2: string);
begin
   SysopName := aSysop;
   SubSysopName0 := aSubSysop0;
   SubSysopName1 := aSubSysop1;
   SubSysopName2 := aSubSysop2;
end;
}
function TGuildNpc.IsSysopName (aname : String) : boolean;
var
   i : Integer;
   pd : PTCreateGuildData;
begin
   Result := TRUE;
   if ParentGuildObject <> nil then begin
      pd := TGuildObject (ParentGuildObject).GetSelfData;
      if pd^.Sysop = aname then exit;
      for i := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
         if pd^.SubSysop[i] = aname then exit;
      end;
   end;

   Result := FALSE;
end;

procedure  TGuildNpc.Initial (go : TBasicObject; aNpcName: string; ax, ay: integer; aSex : Byte);
begin
   inherited Initial (aNpcName, aNpcName);

   GuildNpcName := aNpcName;
   Sex := aSex;

   boMagicNpc := FALSE;
   FillChar (GuildMagicData, sizeof(TMagicData), 0);

   ParentGuildObject := go;

   Case Sex of
      1 : NpcClass.GetNpcData (INI_GUILD_NPCMAN_NAME, pGuildNpcData);
      2 : NpcClass.GetNpcData (INI_GUILD_NPCWOMAN_NAME, pGuildNpcData);
      3 : NpcClass.GetNpcData (INI_GUILD_NPCWHITE_NAME, pGuildNpcData);
      4 : NpcClass.GetNpcData (INI_GUILD_NPCBLACK_NAME, pGuildNpcData);
      Else NpcClass.GetNpcData (INI_GUILD_NPCMAN_NAME, pGuildNpcData);
   end;

   Basicdata.id := GetNewMonsterId;
   BasicData.x := ax;
   BasicData.y := ay;
   BasicData.dir := DR_4;
   BasicData.ClassKind := CLASS_GUILDNPC;
   BasicData.Feature.rrace := RACE_NPC;
   StrPCopy (@BasicData.Name, aNpcName);
   StrPCopy (@BasicData.ViewName, aNpcName);

   SetNpcAttrib;

   TargetId := 0;
   TargetPosTick := 0;

   // 2000.09.16 TargetX, TargetY ∞° ¡ˆ¡§µ«¡ˆ æ æ∆ º≠πˆ∞° Ω√¿€µ» »ƒ NPCµÈ¿«
   // µø¿€¿Ã »π¿œ¿˚¿∏∑Œ ∫œº≠¬ ¿ª «‚«—¥Ÿ. √ ±‚ ¿ßƒ°∏¶ ≥÷æÓ¡ÿ¥Ÿ by Lee.S.G
   TargetX := aX; TargetY := aY;
   RestX := aX; RestY := aY;
   StartX := aX; StartY := aY;

   boHit := true;
end;

procedure TGuildNpc.StartProcess;
var
   SubData : TSubData;
begin
   inherited StartProcess;

   CurLife := MaxLife;

   BasicData.Feature.rhitmotion := AM_HIT1;
   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   TFieldPhone(Manager.Phone).RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   TFieldPhone(Manager.Phone).SendMessage (0, FM_CREATE, BasicData, SubData);
end;

procedure TGuildNpc.EndProcess;
var SubData : TSubData;
begin
   if FboRegisted = FALSE then exit;
   
   TFieldPhone (Manager.Phone).SendMessage (0, FM_DESTROY, BasicData, SubData);
   TFieldPhone (Manager.Phone).UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);
   inherited EndProcess;
end;

procedure TGuildNpc.MoveGuildNpc (aServerID, ax, ay: integer);
var
   tmpManager : TManager;
   SubData : TSubData;
   nX, nY : Integer;
begin
   tmpManager := ManagerList.GetManagerByServerID (aServerID);

   TFieldPhone (Manager.Phone).SendMessage (NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
   TFieldPhone (Manager.Phone).UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   nX := aX; nY := aY;
   TMaper(tmpManager.Maper).GetNearXY (nX, nY);
   StartX := nX; StartY := nY;
   TargetX := nX; TargetY := nY;
   RestX := nX; RestY := nY;
   BasicData.x := nX; BasicData.y := nY;

   SetManagerClass (tmpManager);

   TFieldPhone (Manager.Phone).RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   TFieldPhone (Manager.Phone).SendMessage (NOTARGETPHONE, FM_CREATE, BasicData, SubData);
end;

procedure TGuildNpc.MoveDieGuildNpc (aServerID, ax, ay: integer);
var
   tmpManager : TManager;
   nX, nY : Integer;
begin
   tmpManager := ManagerList.GetManagerByServerID (aServerID);

   nX := aX; nY := aY;
   TMaper(tmpManager.Maper).GetNearXY (nX, nY);
   StartX := nX; StartY := nY;
   TargetX := nX; TargetY := nY;
   RestX := nX; RestY := nY;
   BasicData.x := nX; BasicData.y := nY;

   SetManagerClass (tmpManager);
end;

function  AddPermitExp (var aLevel, aExp: integer; addvalue: integer): integer;
var n : integer;
begin
   n := GetLevelMaxExp (aLevel) * 3;
   if n > addvalue then n := addvalue;
   inc (aExp, n);
   aLevel := GetLevel (aExp);
   Result := n;
end;

function  TGuildNpc.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i: integer;
   str, boname : String;
   sayer, objectname, gradename : String;
   Bo: TBasicObject;
   MagicData : TMagicData;
   OldSkillLevel : Integer;
begin
   Result := PROC_FALSE;
   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;
   case Msg of
      FM_ADDITEM :
         begin
            exit;
            {
            Bo := GetViewObjectByid (SenderInfo.id);
            if Bo = nil then exit;
            if not (Bo is TUSER) then exit;
            boname := TUser (Bo).Name;
            IsSysopName(boname);
            }
         end;
      FM_ADDATTACKEXP  :
         begin
            if boMagicNpc then begin
               OldSkillLevel := GuildMagicData.rcSkillLevel;
               AddPermitExp (GuildMagicData.rcSkillLevel, GuildMagicData.rSkillExp, aSubData.ExpData.Exp);
               if OldSkillLevel <> GuildMagicData.rcSkillLevel then begin
                  if (GuildMagicData.rcSkillLevel mod 10) = 0 then begin
                     {
                     if GuildMagicData.rcSkillLevel >= 5000 then begin
                        BocSay ( Get10000To100 (GuildMagicData.rcSkillLevel) );
                     end else begin
                        BocSay ( Get10000To100 (GuildMagicData.rcSkillLevel) );
                     end;
                     }
                     BocSay ( Get10000To100 (GuildMagicData.rcSkillLevel) );
                  end;
               end;
            end;
         end;
      FM_SHOW :
         begin
         end;
      FM_CHANGEFEATURE:
         begin
            if (SenderInfo.id = TargetId) and (SenderInfo.Feature.rFeatureState = wfs_die) then SetTargetId (0);
         end;
      FM_GUILDATTACK : //√≈≈…’Ω
         begin
            if CurLife <= 0 then exit;

            if aSubData.TargetID = 0 then begin
               SetTargetID (aSubData.TargetID);
               exit;
            end;
            
            if LifeObjectState = los_attack then exit;

            Result := PROC_FALSE;
            if aSubData.TargetId <> 0 then begin
               // 2000.10.04 πÆ¡÷≥™ ∫ŒπÆ¡÷¥¬ ∞¯∞›«œ¡ˆ æ µµ∑œ ºˆ¡§ by Lee.S.G
               Bo := GetViewObjectByID (aSubData.TargetId);
               if Bo = nil then exit;
               if Bo is TGuildNpc then begin
                  if TGuildObject(ParentGuildObject).GuildName <> TGuildObject(TGuildNpc(Bo).ParentGuildObject).GuildName then begin
                     SetTargetId(aSubData.TargetId);
                  end;
               end
               else begin
                  if Bo is TUser then begin
                     boname := TUser (Bo).Name;
                     if IsSysopName(boname) = FALSE then begin
                        SetTargetId (aSubData.TargetId);
                     end;
                  end else begin
                     SetTargetId (aSubData.TargetId);
                  end;
               end;
               Result := PROC_TRUE;
            end;
         end;
      FM_SPELL :
         begin
            if SenderInfo.id = BasicData.id then exit;
            if BasicData.Feature.rFeatureState = wfs_die then begin
               Result := PROC_TRUE;
               exit;
            end;
            if isSpellArea (SenderInfo.x, SenderInfo.y, aSubData.ShoutColor) then begin
               CommandSpell (SenderInfo.id, aSubData.SpellType, aSubData.SpellDamage);
               if CurLife = 0 then CommandChangeCharState (wfs_die, SenderInfo);
            end;
         end;
      FM_STRUCTED :
         begin
            if (SenderInfo.id = BasicData.id) then begin
               if CurLife <= 0 then begin
                  SetTargetId (0);
                  // CommandChangeCharState (wfs_die);  // ∆˜¡π¿Ã ¿ÃªÛ«œ∞‘ ¡◊¿Ω ^^;;;
                  exit;
               end;
               if pGuildNpcData^.rboProtecter then begin
                  // 2000.10.04 πÆ¡÷≥™ ∫ŒπÆ¡÷¥¬ ∞¯∞›«œ¡ˆ æ µµ∑œ ºˆ¡§ by Lee.S.G
                  Bo := GetViewObjectByID (aSubData.Attacker);
                  if Bo = nil then exit;
                  if Bo is TGuildNpc then begin
                     if TGuildObject(ParentGuildObject).GuildName <> TGuildObject(TGuildNpc(Bo).ParentGuildObject).GuildName then begin
                        SetTargetId(aSubData.attacker);
                     end;
                  end
                  else begin
                     if Bo is TUser then begin
                        {
                        boname := TUser (Bo).Name;
                        if IsSysopName(boname) = TRUE then begin
                           // πÆ∆ƒ∞¸∏Æ¿⁄ø°∞‘ ∏¬æ“¿ª∂ßø°¥¬ ¿·Ω√ πÆ¡÷¿« π›¥ÎπÊ«‚¿∏∑Œ »∏««
                           if (BasicData.X < TUser(Bo).BasicData.X) and (BasicData.Y < TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X - 6; TargetY := BasicData.Y - 6;
                           end else if (BasicData.X = TUser(Bo).BasicData.X) and (BasicData.Y < TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X + 0; TargetY := BasicData.Y - 6;
                           end else if (BasicData.X > TUser(Bo).BasicData.X) and (BasicData.Y < TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X + 6; TargetY := BasicData.Y - 6;
                           end else if (BasicData.X > TUser(Bo).BasicData.X) and (BasicData.Y = TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X + 6; TargetY := BasicData.Y + 0;
                           end else if (BasicData.X > TUser(Bo).BasicData.X) and (BasicData.Y > TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X + 6; TargetY := BasicData.Y + 6;
                           end else if (BasicData.X = TUser(Bo).BasicData.X) and (BasicData.Y > TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X + 0; TargetY := BasicData.Y + 6;
                           end else if (BasicData.X < TUser(Bo).BasicData.X) and (BasicData.Y > TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X - 6; TargetY := BasicData.Y + 6;
                           end else if (BasicData.X < TUser(Bo).BasicData.X) and (BasicData.Y = TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X - 6; TargetY := BasicData.Y + 0;
                           end;
                           LifeObjectState := los_rest;
                        end else begin
                           SetTargetId (aSubData.attacker);
                        end;
                        }
                        SetTargetId (aSubData.attacker);
                     end else begin
                        SetTargetId (aSubData.attacker);
                     end;
                  end;
               end;
            end;
         end;
      FM_DEADHIT :
         begin
            CurLife := 0;
            CommandChangeCharState (wfs_die, SenderInfo);
         end;
      FM_SAY:
         begin
            if FboAllowDelete then exit;
            if SenderInfo.id = BasicData.id then exit;
            if TargetId <> 0 then begin
               if (TargetID <> TGuildObject(ParentGuildObject).BasicData.ID) and
                  (LifeObjectState = los_attack) then exit;
            end;

            if LifeObjectState = los_escape then exit;

            str := GetWordString (aSubData.SayString);
            if ReverseFormat (str, '%s: ', sayer, objectname, gradename, 1) then begin
               if (IsSysopName(sayer) = FALSE) and (SysopClass.GetSysopScope (sayer) < 100) then begin
                  exit;
               end;
            end;

            if ReverseFormat (str, Conv('%s: Ω´√≈≈…Œ‰π¶¥´ ⁄∏¯%s'), sayer, objectname, gradename, 2) then begin
               if boMagicNpc then begin
                  // 2000.09.18 NPC¿« ¿Ã∏ß∞˙ User¿« ¿Ã∏ß¿Ã ∞∞¿ª∂ß ∞Àªˆø¿∑˘πˆ±◊ ºˆ¡§ by Lee.S.G
                  // πÆ∆ƒπ´∞¯ ¿¸ºˆ¥¬ RACE_HUMANø°º≠∏∏ ¿Ø»ø«œ¥Ÿ
                  Bo := GetViewObjectByName (objectname, RACE_HUMAN);
                  if Bo = nil then begin BocSay (format (Conv('%s≤ª‘⁄°£'),[objectname])); exit; end;
                  if not (Bo is TUser) then begin BocSay (format (Conv('%s≤ª « π”√’ﬂ°£'),[objectname])); exit; end;
                  if TUser(Bo).GuildName = '' then begin BocSay (Conv('≤ª «√≈≈…≥…‘±')); exit; end;
                  if TUser(Bo).GuildName <> TGuildObject(ParentGuildObject).GuildName then begin
                     BocSay (format (Conv('%s «±µƒ√≈≈…°£'),[objectname]));
                     exit;
                  end;
                  if StrPas (@GuildMagicData.rName) = '' then begin BocSay (Conv('√ª”–√≈≈…Œ‰π¶°£')); exit; end;
                  if GuildMagicData.rcSkillLevel < 5000 then begin BocSay (Conv('√≈≈…Œ‰π¶–ﬁ¡∑∂»≤ª◊„°£')); exit; end;
                  MagicClass.GetMagicData (StrPas (@GuildMagicData.rName), MagicData, 0);
                  if TUser(Bo).AddMagic (@MagicData) then begin
                     BocSay (Conv('Ω´√≈≈…Œ‰π¶¥´ ⁄¡À°£'));
                     GuildMagicData.rSkillExp := 0;
                     GuildMagicData.rcSkillLevel := GetLevel(GuildMagicData.rSkillExp);
                  end else BocSay (Conv('√≈≈…Œ‰π¶¥´ ⁄ ß∞‹°£'));
               end;
               exit;
            end;

            if ReverseFormat (str, Conv('%s: %sµƒ√˚◊÷ «%s'), sayer, objectname, gradename, 3) then begin
               // objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  for i := 0 to MAX_GUILDNPC_COUNT - 1 do begin
                     if TGuildObject (ParentGuildObject).IsGuildNpc (gradename) then begin
                        BocSay (Conv('Õ¨—˘µƒ√˚◊÷“—¥Ê‘⁄°£'));
                        exit;
                     end;
                  end;

                  {
                  if (not isFullHangul (gradename)) or (not isGrammarID(gradename)) then begin
                     BocSay (Conv('√˚◊÷¥ÌŒÛ°£'));
                     exit;
                  end;
                  }
                  if (CheckPascalString (gradename) = 0) then begin
                     BocSay (Conv('√˚◊÷¥ÌŒÛ°£'));
                     exit;
                  end;
                  if (Length (gradename) <= 1) or (Length(gradename) > 10) then begin
                     BocSay (Conv('√˚◊÷¥ÌŒÛ°£'));
                     exit;
                  end;

                  TGuildObject (ParentGuildObject).ChangeGuildNpcName (GuildNpcName, GradeName);
                  
                  StrPCopy (@BasicData.Name, gradename);
                  StrPCopy (@BasicData.ViewName, gradename);
                  GuildNpcName := GradeName;
                  BocChangeProperty;
                  BocSay (format (Conv('Œ“µƒ√˚◊÷≥…¡À %s°£'),[GuildNpcName]));
                  exit;
               end;
               exit;
            end;

            if ReverseFormat (str, Conv('%s: %sµƒŒª÷√ «’‚¿Ô'), sayer, objectname, gradename, 2) then begin
               // objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  if not TMaper(Manager.Maper).isObjectArea (BasicData.x, BasicData.y) then begin
                     StartX := BasicData.x; StartY := BasicData.y;
                     BocSay (Conv('Œ“¥”’‚¿Ôø™ º°£'));
                  end else begin
                     BocSay (Conv('Œﬁ∑®Ω´Œª÷√÷∏∂®”⁄¥À'));
                  end;
               end;
               exit;
            end;
            if ReverseFormat (str, Conv('%s: %s∏˙◊≈¿¥'), sayer, objectname, gradename, 2) or
               ReverseFormat (str, Conv('%s: %s∏˙◊≈¿¥'), sayer, objectname, gradename, 2) then begin
               // objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  if BasicData.Feature.rfeaturestate = wfs_sitdown then begin
                     BasicData.Feature.rfeaturestate := wfs_normal;
                     BocChangeFeature;
                  end;

                  TargetId := SenderInfo.id;
                  LifeObjectState := los_follow;
               end;
               exit;
            end;
            if ReverseFormat (str, Conv('%s: %sÕ£÷π¡À'), sayer, objectname, gradename, 2) or
               ReverseFormat (str, Conv('%s: %sÕ£÷π¡À'), sayer, objectname, gradename, 2) then begin
               // objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then LifeObjectState := los_stop;
               exit;
            end;
            // 2000.09.16 πÆ∆ƒ∆˜¡πø° ¥Î«— ¿œæÓº±¥Ÿ,æ…¥¬¥Ÿ¿« µø¿€ ªË¡¶ by Lee.S.G
            {
            // if ReverseFormat (str, '%s: %s ¿œæÓº±¥Ÿ', sayer, objectname, gradename, 2) then begin
               objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  if BasicData.Feature.rfeaturestate = wfs_sitdown then begin
                     BasicData.Feature.rfeaturestate := wfs_normal;
                     BocChangeFeature;
                  end;
               end;
            end;
            // if ReverseFormat (str, '%s: %s æ…¥¬¥Ÿ', sayer, objectname, gradename, 2) then begin
               objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  if BasicData.Feature.rfeaturestate = wfs_normal then begin
                     BasicData.Feature.rfeaturestate := wfs_sitdown;
                     BocChangeFeature;
                     LifeObjectState := los_stop;
                  end;
               end;
            end;
            }
            if ReverseFormat (str, Conv('%s: %s–›œ¢'), sayer, objectname, gradename, 2) or
               ReverseFormat (str, Conv('%s: %s–›œ¢'), sayer, objectname, gradename, 2) then begin
               // objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  if BasicData.Feature.rfeaturestate = wfs_sitdown then begin
                     BasicData.Feature.rfeaturestate := wfs_normal;
                     BocChangeFeature;
                  end;

                  RestX := BasicData.x;
                  RestY := BasicData.y;
                  LifeObjectState := los_rest;
                  BocSay (Conv('Œ“‘⁄’‚¿Ô–›œ¢°£'));
               end;
               exit;
            end;
         end;
   end;
end;

procedure TGuildNpc.Update (CurTick: integer);
var
   key : word;
   Bo : TBasicObject;
begin
   inherited UpDate (CurTick);

   if CurTick < UpdateTick + OBJECTUPDATETICK then exit;
   UpdateTick := CurTick;

   if (BasicData.Feature.rFeatureState = wfs_die) and (CurTick > DiedTick + 1600) then begin
      FboAllowDelete := TRUE;
      exit;
   end;

   case LifeObjectState of
      los_none:
         begin
            if TargetPosTick + 3000 < CurTick then begin
               TargetPosTick := Curtick;
               TargetX := RestX - pGuildNpcData^.rActionWidth div 2 + Random (pGuildNpcData^.rActionWidth);
               TargetY := RestY - pGuildNpcData^.rActionWidth div 2 + Random (pGuildNpcData^.rActionWidth);
               exit;
            end;

            if WalkTick + 200 < CurTick then begin
               Walktick := CurTick;
               GotoXyStand (TargetX, TargetY);
            end;
         end;
      los_die :;
      los_follow:
         begin
            bo := TBasicObject (GetViewObjectById (TargetId));
            if bo = nil then LifeObjectState := los_none
            else begin
               if GetLargeLength (BasicData.X, BasicData.Y, bo.PosX, bo.PosY) <= 2 then exit; 

               if WalkTick + 60 < CurTick then begin
                  Walktick := CurTick;
                  GotoXyStand (bo.Posx, bo.Posy);
               end;
            end;
         end;
      los_stop:
         begin
         end;
      los_rest:
         begin
            if TargetPosTick + 3000 < CurTick then begin
               TargetPosTick := Curtick;
               TargetX := RestX - pGuildNpcData^.rActionWidth div 2 + Random (pGuildNpcData^.rActionWidth);
               TargetY := RestY - pGuildNpcData^.rActionWidth div 2 + Random (pGuildNpcData^.rActionWidth);
               exit;
            end;

            if WalkTick + 200 < CurTick then begin
               Walktick := CurTick;
               GotoXyStand (TargetX, TargetY);
            end;
         end;
      los_attack:
         begin
            bo := TBasicObject (GetViewObjectById (TargetId));
            if bo = nil then LifeObjectState := los_none
            else begin
               if GetLargeLength (BasicData.X, BasicData.Y, bo.PosX, bo.PosY) = 1 then begin
                  key := GetNextDirection (BasicData.X, BasicData.Y, bo.PosX, bo.PosY);
                  if key = DR_DONTMOVE then exit;   // ¿ß¬ ¿Ã 0 ¿œ∂ß¿« ∞ÊøÏ¿Œµ• ¿ß¬ ¿Ã 1¿”..
                  if key <> BasicData.dir then CommandTurn (key);
                  CommandHit (CurTick);
               end else begin
                  if WalkTick + 35 < CurTick then begin
                     Walktick := CurTick;

                     GotoXyStand (bo.Posx, bo.Posy);
                  end;
               end;
            end;
         end;
   end;
end;

end.
