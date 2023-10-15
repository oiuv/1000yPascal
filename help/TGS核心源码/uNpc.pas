unit uNpc;

interface

uses
  Windows, Messages, Classes, SysUtils, mmSystem, svClass, subutil, uAnsTick,
  AnsUnit, BasicObj, FieldMsg, MapUnit, DefType, Autil32, uMonster, uUser,
  UserSDB, uManager, uSkills, AnsStringCls, uScriptManager;

const
   BATTLE_MAGIC_SIZE = 5;  

type
   TNpc = class (TLifeObject)
    private
     pSelfData : PTNpcData;
     // boFighterNpc: Boolean;
     DblClick_UserId : integer;

     BuySellSkill : TBuySellSkill;
     SpeechSkill : TSpeechSkill;
     DeallerSkill : TDeallerSkill;
     // AttackSkill : TAttackSkill;

     function  Regen : Boolean;
     function  Start : Boolean;
    protected
     function   FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
     procedure  Initial (aNpcName: string; ax, ay, aw: integer; aBookName : String);
     procedure  StartProcess; override;
     procedure  EndProcess; override;
    public
     NpcName : string;
     CreateIndex : integer;
     SaleSkill : TSaleSkill;
     BattleAttackMagic : array [0..BATTLE_MAGIC_SIZE - 1] of TMagicData;
     CurBattleMagic : TMagicData;

     constructor Create;
     destructor Destroy; override;
     procedure  Update (CurTick: integer); override;

     procedure  SetNpcAttrib;

     procedure CallMe(x, y : Integer);
     function GetAttackSkill : TAttackSkill;
     procedure SetAttackSkill (aAttackSkill : TAttackSkill);
     procedure SetBattleAttackMagic (aMagicStr : String);
     function SelectRandomBattleAttackMagic : TMagicData;
//     procedure First3daysEvent (aStr : String);

     procedure STradeWindow (aName : String; aKind : Byte); override;
   end;

   TNpcList = class (TBasicObjectList)
   private
     function GetAliveCount : Integer;
   public
     constructor Create (aManager: TManager);
     destructor  Destroy; override;

     procedure   ReLoadFromFile;

     function    CallNpc (aNpcName: string; ax, ay, aw: integer; aName : String) : TNpc;
     procedure   AddNpc (aNpcName: string; ax, ay, aw: integer; aNotice : Integer; aBookName : String);

     function    GetNpcByID (aID : Integer) : TNpc;
     function    GetNpcByName (aName : String; aboAllowDie : Boolean) : TNpc;

     function    GetNpcPosStr : String;
     procedure   ReLoadFromNpcSetting (aName : String);

     procedure   RegenByName (aName : String);

     property    AliveCount : Integer read GetAliveCount;
   end;

implementation

uses
   svMain, uWorkBox, FSockets, uLevelExp;

/////////////////////////////////////
//       Npc
////////////////////////////////////
constructor TNpc.Create;
begin
   inherited Create;

   pSelfData := nil;
   DblClick_UserId := 0;
   // boFighterNpc := FALSE;

   BuySellSkill := nil;
   SpeechSkill := nil;
   DeallerSkill := nil;
   AttackSkill := nil;
   SaleSkill := nil;

   FillChar (BattleAttackMagic, SizeOf (BattleAttackMagic), 0);
   FillChar (CurBattleMagic, SizeOf (TMagicData), 0);
end;

destructor TNpc.Destroy;
begin
   pSelfData := nil;
   if BuySellSkill <> nil then BuySellSkill.Free;
   if SpeechSkill <> nil then SpeechSkill.Free;
   if DeallerSkill <> nil then DeallerSkill.Free;
   if (AttackSkill <> nil) and (FboCopy = false) then AttackSkill.Free;
   if SaleSkill <> nil then SaleSkill.Free;

   inherited destroy;
end;

function  TNpc.Regen : Boolean;
var
   i, xx, yy : word;
begin
   Result := true;

   for i := 0 to 10 - 1 do begin
      xx := CreatedX - RegenWidth + Random(RegenWidth * 2);
      yy := CreatedY - RegenWidth + Random(RegenWidth * 2);
      if Maper.isMoveable (xx, yy) then begin
         BasicData.x := xx;
         BasicData.y := yy;
         BasicData.nx := xx;
         BasicData.ny := yy;
         BasicData.dir := DR_4;
         BasicData.Feature.rhitmotion := AM_HIT1;

         CurLife := MaxLife;
         if pSelfData^.rboBattle = true then begin
            CurHeadLife := MaxLife;
            CurArmLife := MaxLife;
            CurLegLife := MaxLife;
         end else begin
            CurHeadLife := 0;
            CurArmLife := 0;
            CurLegLife := 0;
         end;

         StartProcess;
         exit;
      end;
   end;
   Result := false;
end;

function TNpc.Start : Boolean;
var
   i, xx, yy : word;
begin
   Result := true;

   xx := BasicData.X;
   yy := BasicData.Y;
   for i := 0 to 10 - 1 do begin
      if Maper.isMoveable (xx, yy) then begin
         BasicData.x := xx;
         BasicData.y := yy;
         BasicData.nx := xx;
         BasicData.ny := yy;
         BasicData.Feature.rHitMotion := AM_HIT1;

         CurLife := MaxLife;
         if pSelfData^.rboBattle = true then begin
            CurHeadLife := MaxLife;
            CurArmLife := MaxLife;
            CurLegLife := MaxLife;
         end else begin
            CurHeadLife := 0;
            CurArmLife := 0;
            CurLegLife := 0;
         end;

         StartProcess;
         exit;
      end;
      xx := CreatedX - RegenWidth + Random(RegenWidth * 2);
      yy := CreatedY - RegenWidth + Random(RegenWidth * 2);
   end;
   Result := false;
end;

procedure TNpc.SetNpcAttrib;
begin
   if pSelfData = nil then exit;

   if pSelfData^.rboBattle = true then begin
      FillChar (LifeData, SizeOf (TLifeData), 0);
      LifeData.damageBody   := 41;
      LifeData.damageHead   := 41;
      LifeData.damageArm    := 41;
      LifeData.damageLeg    := 41;
      LifeData.armorBody    := 0;
      LifeData.armorHead    := 0;
      LifeData.armorArm     := 0;
      LifeData.armorLeg     := 0;
      LifeData.AttackSpeed  := 70;
      LifeData.avoid        := 25;
      LifeData.recovery     := 50;

      LifeData.DamageBody      := LifeData.DamageBody      + CurBattleMagic.rLifeData.damageBody + CurBattleMagic.rLifeData.damageBody * CurBattleMagic.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
      LifeData.DamageHead      := LifeData.DamageHead      + CurBattleMagic.rLifeData.damageHead + CurBattleMagic.rLifeData.damageHead * CurBattleMagic.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
      LifeData.DamageArm       := LifeData.DamageArm       + CurBattleMagic.rLifeData.damageArm  + CurBattleMagic.rLifeData.damageArm  * CurBattleMagic.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
      LifeData.DamageLeg       := LifeData.DamageLeg       + CurBattleMagic.rLifeData.damageLeg  + CurBattleMagic.rLifeData.damageLeg  * CurBattleMagic.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
      LifeData.AttackSpeed     := LifeData.AttackSpeed     + CurBattleMagic.rLifeData.AttackSpeed - CurBattleMagic.rLifeData.AttackSpeed * CurBattleMagic.rcSkillLevel div INI_SKILL_DIV_ATTACKSPEED;
      LifeData.avoid           := LifeData.avoid           + CurBattleMagic.rLifeData.avoid;
      LifeData.recovery        := LifeData.recovery        + CurBattleMagic.rLifeData.recovery;
      LifeData.Accuracy        := LifeData.Accuracy        + CurBattleMagic.rLifeData.Accuracy;
      LifeData.KeepRecovery    := LifeData.KeepRecovery    + CurBattleMagic.rLifeData.KeepRecovery;
      LifeData.armorbody       := LifeData.armorbody       + pSelfData^.rarmor;
      LifeData.armorhead       := LifeData.armorhead       + pSelfData^.rArmorHead;
      LifeData.armorarm        := LifeData.armorarm        + pSelfData^.rArmorArm;
      LifeData.armorleg        := LifeData.armorleg        + pSelfData^.rArmorLeg;

      AttackSkill.SetAttackMagic (CurBattleMagic);

      LifeData.damageBody := LifeData.damageBody + LifeData.DamageBody * MagicClass.GetSkillDamageBody (CurBattleMagic.rcSkillLevel) div 100;
      LifeData.damageHead := LifeData.damageHead;
      LifeData.damageArm  := LifeData.damageArm;
      LifeData.damageLeg  := LifeData.damageLeg;

      LifeData.damageExp := LifeData.damageBody;
      LifeData.armorExp := LifeData.armorBody;
   end else begin
      LifeData.damagebody   := LifeData.damagebody      + pSelfData^.rDamage;
      LifeData.damagehead   := LifeData.damagehead      + 0;
      LifeData.damagearm    := LifeData.damagearm       + 0;
      LifeData.damageleg    := LifeData.damageleg       + 0;

      LifeData.AttackSpeed     := LifeData.AttackSpeed     + pSelfData^.rAttackSpeed;
      LifeData.avoid           := LifeData.avoid           + pSelfData^.ravoid;
      LifeData.recovery        := LifeData.recovery        + pSelfData^.rrecovery;
      LifeData.Accuracy        := LifeData.Accuracy;
      LifeData.KeepRecovery    := LifeData.KeepRecovery;
      LifeData.armorbody       := LifeData.armorbody       + pSelfData^.rarmor;
      if pSelfData^.rArmorHead = 0 then begin
         LifeData.armorhead       := LifeData.armorhead       + pSelfData^.rarmor;
         LifeData.armorarm        := LifeData.armorarm        + pSelfData^.rarmor;
         LifeData.armorleg        := LifeData.armorleg        + pSelfData^.rarmor;
      end else begin
         LifeData.armorhead       := LifeData.armorhead       + pSelfData^.rArmorHead;
         LifeData.armorarm        := LifeData.armorarm        + pSelfData^.rArmorArm;
         LifeData.armorleg        := LifeData.armorleg        + pSelfData^.rArmorLeg;
      end;
      LifeData.damageExp       := LifeData.damageBody;
      LifeData.armorExp        := LifeData.armorBody;
   end;

   AttackSkill.boAutoAttack := pSelfData^.rboAutoAttack;   

   SoundStart := pSelfData^.rSoundStart;
   SoundNormal := pSelfData^.rSoundNormal;
   SoundAttack := pSelfData^.rSoundAttack;
   SoundDie := pSelfData^.rSoundDie;
   SoundStructed := pSelfData^.rSoundStructed;

   EffectStart := pSelfData^.rEffectStart;
   EffectStructed := pSelfData^.rEffectStructed;
   EffectEnd := pSelfData^.rEffectEnd;
//   EffectNumber := pSelfData^.
end;

procedure  TNpc.Initial (aNpcName: string; ax, ay, aw: integer; aBookName : String);
begin
   NpcClass.GetNpcData (aNpcName, pSelfData);

   inherited Initial (aNpcName, StrPas (@pSelfData^.rViewName));

   {
   if aNpcName = Conv('궐嶠끝') then boFighterNpc := TRUE
   else boFighterNpc := FALSE;
   }

   DblClick_UserId := 0;

   if AttackSkill = nil then begin
      AttackSkill := TAttackSkill.Create (Self);
      AttackSkill.TargetX := ax;
      AttackSkill.TargetY := ay;
      AttackSkill.SetObserver := pSelfData^.rboObserver;
   end;

   if pSelfData^.rboBattle = true then begin
      SetBattleAttackMagic (pSelfData^.rAttackMagic);
      CurBattleMagic := BattleAttackMagic [0];
      AttackSkill.SetAttackMagic (CurBattleMagic);
   end;


   CurHeadLife := MaxLife;
   CurArmLife := MaxLife;
   CurLegLife := MaxLife;
//   CurBattleMagic := SelectRandomBattleAttackMagic;

   SetNpcAttrib;

   NpcName := aNpcName;

   if pSelfData^.rboSeller = true then begin
      if BuySellSkill = nil then BuySellSkill := TBuySellSkill.Create (Self);
      BuySellSkill.LoadFromFile ('.\NpcSetting\' + StrPas (@pSelfData^.rNpcText));
   end;

   if pSelfData^.rboSale = true then begin
      if SaleSkill = nil then SaleSkill := TSaleSkill.Create(Self);
      SaleSkill.LoadFromFile('.\NpcSetting\' + StrPas (@pSelfData^.rNpcText));
   end;

   BasicData.id := GetNewMonsterId;
   BasicData.X := ax;
   BasicData.Y := ay;
   BasicData.ClassKind := CLASS_NPC;
   BasicData.Feature.rrace := RACE_NPC;

   BasicData.Feature.raninumber := pSelfData^.rAnimate;
   BasicData.Feature.rImageNumber := pSelfData^.rShape;

   CreatedX := ax;
   CreatedY := ay;
   RegenWidth := aw;
   ActionWidth := pSelfData^.rActionWidth;
   VirtueValue := pSelfData^.rVirtue;
   VirtueLevel := pSelfData^.rVirtueLevel;
   FboHit := pSelfData^.rboHit;
   FboBattle := pSelfData^.rboBattle;

   MaxLife := pSelfData^.rLife;

   if aBookName <> '' then begin
      if SpeechSkill = nil then begin
         SpeechSkill := TSpeechSkill.Create (Self);
      end;
      SpeechSkill.LoadFromFile ('.\NpcSetting\' + aBookName);
      if DeallerSkill = nil then begin
         DeallerSkill := TDeallerSkill.Create (Self);
      end;
      DeallerSkill.LoadFromFile ('.\NpcSetting\' + aBookName);
   end;
end;

procedure TNpc.StartProcess;
var
   SubData : TSubData;
begin
   inherited StartProcess;

   CurLife := MaxLife;
   if pSelfData^.rboBattle = true then begin
      CurHeadLife := MaxLife;
      CurArmLife := MaxLife;
      CurLegLife := MaxLife;
   end else begin
      CurHeadLife := 0;
      CurArmLife := 0;
      CurLegLife := 0;
   end;

   if AttackSkill = nil then begin
      AttackSkill := TAttackSkill.Create (Self);
      AttackSkill.TargetX := CreateX;
      AttackSkill.TargetY := CreateY;
      AttackSkill.SetObserver := pSelfData^.rboObserver;
      // AttackSkill.TargetX := CreateX - 3 + Random (6);
      // AttackSkill.TargetY := CreateY - 3 + Random (6);
      if pSelfData^.rboBattle = true then begin
         CurBattleMagic := BattleAttackMagic [0];
         AttackSkill.SetAttackMagic (CurBattleMagic);
      end;
      AttackSkill.boAutoAttack := pSelfData^.rboAutoAttack;
   end;

   HaveMagicClass.Init (pSelfData^.rHaveMagic);

   {
   if boFighterNpc then begin
      FighterNpc := Self;
      DontAttacked := TRUE;
   end;
   }

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (0, FM_CREATE, BasicData, SubData);

   if pSelfData^.rEffectStart <> 0 then ShowEffect2 (pSelfData^.rEffectStart, lek_follow, 0);

   if pSelfData^.rSoundStart.rWavNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (pSelfData^.rSoundStart.rWavNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;
end;

procedure TNpc.EndProcess;
var
   SubData : TSubData;
begin
   if FboRegisted = FALSE then exit;

   if pSelfData^.rEffectEnd <> 0 then ShowEffect2 (pSelfData^.rEffectEnd, lek_follow, 0);

   Phone.SendMessage (0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   SetAttackSkill (nil);
   FboCopy := false;

   inherited EndProcess;
end;

procedure TNpc.CallMe(x, y : Integer);
begin
   EndProcess;
   BasicData.x := x;
   BasicData.y := y;
   StartProcess;
end;

function  TNpc.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i : integer;
   RetStr, Str : string;
   Bo : TBasicObject;
   Mon : TMonster;
   SubData: TSubData;
   ItemData : TItemData;
   tmpAttackSkill : TAttackSkill;
begin
   Result := PROC_FALSE;

   if (msg = FM_STRUCTED) and (SenderInfo.Feature.rRace = RACE_HUMAN) and
      (pSelfData^.rboObserver = true) and isUserID (aSubData.Attacker) then begin
   end else begin
      if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
      Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
      if Result = PROC_TRUE then exit;
   end;
   if FboAllowDelete = true then exit;

   if LifeObjectState = los_die then exit;

   try
      case Msg of
         FM_CLICK :
            begin
               if SOnLeftClick <> 0 then begin
                  ScriptManager.CallEvent (Self, SenderInfo.P, SOnLeftClick, 'OnLeftClick', ['']);
               end;
            end;
         FM_SHOW :
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TNpc.FieldProc (%s) failed AttackSkill=nil Msg=%d', [NpcName, Msg]));
                  exit;
               end;
               if SenderInfo.id = BasicData.id then exit;
               if SenderInfo.Feature.rHideState = hs_0 then exit;
               if SenderInfo.Feature.rfeaturestate = wfs_shop then exit;
               if SenderInfo.Feature.rFeatureState = wfs_die then begin
                  if AttackSkill.GetTargetID = SenderInfo.id then begin
                     AttackSkill.SetTargetID (0, true);
                     exit;
                  end;
               end;

               if SOnShow <> 0 then begin
                  ScriptManager.CallEvent (Self, Senderinfo.p, SOnShow, 'OnShow', ['']);
               end;

               if AttackSkill.GetTargetID <> 0 then exit;

               if pSelfData^.rboProtecter = true then begin
                  if SenderInfo.Feature.rrace = RACE_MONSTER then begin
                     Mon := TMonster (GetViewObjectById (SenderInfo.id));
                     if Mon <> nil then begin
                        tmpAttackSkill := Mon.GetAttackSkill;
                        if tmpAttackSkill <> nil then begin
                           if tmpAttackSkill.boGoodHeart = false then begin
                              if Mon.GetVirtueValue < BOSSVIRTUEVALUE then begin
                                 AttackSkill.SetTargetId (SenderInfo.id, true);
                              end;
                           end;
                        end;
                     end;
                  end;
                  exit;
               end;
               if pSelfData^.rboAutoAttack = true then begin
                  if SenderInfo.Feature.rrace = RACE_HUMAN then begin
                     AttackSkill.SetTargetId (SenderInfo.id, true);
                  end;
               end;
            end;
         FM_CHANGESTEP :
            begin
               if SenderInfo.id = BasicData.id then exit;
               if SenderInfo.Feature.rHideState = hs_0 then exit;
               if SenderInfo.Feature.rfeaturestate = wfs_shop then exit;

               if SOnGetChangeStep <> 0 then begin
                  ScriptManager.CallEvent (Self, Senderinfo.p, SOnGetChangeStep, 'OnGetChangeStep', [IntToStr (aSubData.Motion)]);
               end;
            end;
         FM_CHANGEFEATURE:
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TNpc.FieldProc (%s) failed AttackSkill=nil Msg=%d', [NpcName, Msg]));
                  exit;
               end;
               if SenderInfo.id = BasicData.id then exit;
               if SenderInfo.Feature.rHideState = hs_0 then exit;
               if SenderInfo.Feature.rfeaturestate = wfs_shop then exit;

               if SOnChangeState <> 0 then begin
                  Str := 'normal';
                  if SenderInfo.Feature.rFeatureState = wfs_die then Str := 'die';
                  ScriptManager.CallEvent (Self, SenderInfo.P, SOnChangeState, 'OnChangeState', [Str]);
               end;
            
               if (SenderInfo.id = AttackSkill.GetTargetId)
                  and (SenderInfo.Feature.rFeatureState = wfs_die) then begin
                  AttackSkill.SetTargetId (0, true);
                  exit;
               end;

               if AttackSkill.GetTargetID <> 0 then exit;

               if pSelfData^.rboAutoAttack = true then begin
                  if SenderInfo.Feature.rrace = RACE_HUMAN then begin
                     AttackSkill.SetTargetId (SenderInfo.id, true);
                  end;
               end;
            end;
         FM_STRUCTED :
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TNpc.FieldProc (%s) failed AttackSkill=nil Msg=%d', [NpcName, Msg]));
                  exit;
               end;
               if SenderInfo.id = BasicData.id then begin
                  if pSelfData^.rboProtecter then begin
                     AttackSkill.SetTargetId (aSubData.attacker, true);
                  end;
                  if CurLife <= 0 then begin
                     BasicData.nx := BasicData.x;
                     BasicData.ny := BasicData.y;

                     AttackSkill.SetTargetId (0, true);

                     for i := 0 to 5 - 1 do begin
                        if pSelfData^.rHaveItem[i].rName [0] <> 0 then begin
                           if ItemClass.GetCheckItemData (NpcName, pSelfData^.rHaveItem[i], ItemData) = false then continue;
                           ItemData.rOwnerName[0] := 0;
                           SubData.ItemData := ItemData;
                           SubData.ServerId := Manager.ServerId;
                           Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
                        end;
                     end;
                  end;
                  exit;
               end;
               if pSelfData^.rboObserver = true then begin
                  if SenderInfo.Feature.rrace = RACE_HUMAN then begin
                     if isUserID (aSubData.Attacker) then begin
                        Bo := GetViewObjectByID (aSubData.Attacker);
                        if Bo = nil then begin
                           Bo := UserList.GetUserPointerByID (aSubData.Attacker);
                        end;
                        if Bo <> nil then begin
                           if Bo.BasicData.Feature.rRace = RACE_HUMAN then begin
                              AttackSkill.SetDeadAttackName (StrPas (@Bo.BasicData.Name));
                           end;
                        end;
                     end;
                  end;
                  exit;
               end;
            end;
         FM_DEADHIT :
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TNpc.FieldProc (%s) failed AttackSkill=nil Msg=%d', [NpcName, Msg]));
                  exit;
               end;
               if SenderInfo.id = BasicData.id then exit;
               if BasicData.Feature.rfeaturestate = wfs_die then begin Result := PROC_TRUE; exit; end;
               CurLife := 0;

               AttackSkill.SetTargetId (0, true);

               BasicData.nx := BasicData.x;
               BasicData.ny := BasicData.y;
               for i := 0 to 5 - 1 do begin
                  if pSelfData^.rHaveItem[i].rName [0] <> 0 then begin
                     if ItemClass.GetCheckItemData (NpcName, pSelfData^.rHaveItem[i], ItemData) = false then continue;
                     ItemData.rOwnerName[0] := 0;
                     SubData.ItemData := ItemData;
                     SubData.ServerId := Manager.ServerId;
                     Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
                  end;
               end;

               CommandChangeCharState (wfs_die, SenderInfo);
            end;
         FM_SAY:
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TNpc.FieldProc (%s) failed AttackSkill=nil Msg=%d', [NpcName, Msg]));
                  exit;
               end;
               if SenderInfo.Feature.rfeaturestate = wfs_die then exit;
               if SenderInfo.id = BasicData.id then exit;
               if SenderInfo.Feature.rrace <> RACE_HUMAN then exit;

               str := GetWordString (aSubData.SayString);

               {
               if NpcName = Conv('일舅와') then begin      // 1월까지 이벤트로...
                  First3daysEvent (str);
               end;
               } 
               {
               if BuySellSkill <> nil then begin
                  if BuySellSkill.ProcessMessage (str, SenderInfo) = true then exit;
               end;
               if DeallerSkill <> nil then begin
                  if DeallerSkill.ProcessMessage (str, SenderInfo) = true then exit;
               end;
               }
               if SOnHear <> 0 then begin
                  Str := GetValidStr3 (Str, RetStr, ':');
                  Str := GetValidStr3 (Str, RetStr, ' ');
                  ScriptManager.CallEvent (Self, SenderInfo.P, SOnHear, 'OnHear', [Str]);
               end;
            end;
      end;
   except
      frmMain.WriteLogInfo (format ('TNpc.FieldProc (%s) failed except msg=%d', [NpcName, Msg]));
      exit;
   end;
end;

procedure TNpc.Update (CurTick: integer);
var
   ret : Integer;
begin
   inherited UpDate (CurTick);

   if CurTick < UpdateTick + OBJECTUPDATETICK then exit;
   UpdateTick := CurTick;

   if LifeObjectState = los_break then exit;

   if (LifeObjectState <> los_init) and (LifeObjectState <> los_exit) then begin
      if BasicData.Feature.rfeaturestate = wfs_die then begin
         LifeObjectState := los_die;
      end;
   end;

   if (FboIce = true) and
      (LifeObjectState <> los_init) and
      (LifeObjectState <> los_exit) and
      (LifeObjectState <> los_die) then exit;

   try
      case LifeObjectState of
         los_init :
            begin
               if Start = false then begin
                  frmMain.WriteLogInfo (format ('TNpc.Start (%s,%d,%d,%d) failed los_init', [NpcName, ServerID, BasicData.X, BasicData.Y]));
                  FboAllowDelete := true;
               end;
            end;
         los_exit :
            begin
               if pSelfData^.rRegenInterval >= 0 then begin
                  if Regen = false then begin
                     // 구미호주모때문에 다시 주석품;;; 한번 보려고 03.06.02. saset
                     frmMain.WriteLogInfo (format ('TNpc.Regen (%s,%d,%d,%d) failed los_exit', [NpcName, ServerID, BasicData.X, BasicData.Y]));
                  end;
               end;
            end;
         los_die :
            begin
               FWorkBox.WorkState := ws_done;

               if pSelfData^.rboRightRemove = true then begin
                  if FboRegen = false then FboAllowDelete := true;
                  if FboAllowDelete = false then begin
                     EndProcess;
                  end;
                  exit;
               end;

               if CurTick > DiedTick + 1600 then begin
                  if Manager.RegenInterval = 0 then begin
                     if AttackSkill <> nil then begin
                        if AttackSkill.GetObjectBoss <> nil then begin
                           FboAllowDelete := true;
                        end;
                     end;
                     if FboRegen = false then FboAllowDelete := true;
                     if FboAllowDelete = false then begin
                        EndProcess;
                     end;
                     exit;
                  end;
               end;
               if CurTick > DiedTick + 800 then begin
                  if Manager.RegenInterval > 0 then begin
                     FboAllowDelete := true;
                     exit;
                  end;
               end;
            end;
         los_dieandbreak :
            begin
               FWorkBox.WorkState := ws_done;
               EndProcess;
               LifeObjectState := los_break;
            end;
         los_none:
            begin
               if SpeechSkill <> nil then SpeechSkill.ProcessMessage (CurTick);
               if AttackSkill <> nil then begin
                  ret := AttackSkill.ProcessNone (CurTick);
                  if ret = 0 then begin
                     if SOnArrival <> 0 then begin
                        ScriptManager.CallEvent (Self, nil, SOnArrival, 'OnArrival', ['']);
                     end;
                  end;
               end;
            end;
         los_attack:
            begin
               if AttackSkill <> nil then AttackSkill.ProcessAttack (CurTick, Self);
            end;
         los_moveattack :
            begin
               if AttackSkill <> nil then AttackSkill.ProcessMoveAttack (CurTick);
            end;
         los_deadattack :
            begin
               if AttackSkill <> nil then AttackSkill.ProcessDeadAttack (CurTick);
            end;
      end;
   except
      FboAllowDelete := true;
      frmMain.WriteLogInfo (format ('TNpc.Update failed. Name=%s los=%d boReg=%d', [NpcName, Byte (LifeObjectState), Byte (FboRegisted)]));
      frmMain.WriteDumpInfo (@BasicData, SizeOf (TBasicData));
   end;
end;

function TNpc.GetAttackSkill : TAttackSkill;
begin
   if AttackSkill = nil then
      AttackSkill := TAttackSkill.Create (Self);

   Result := AttackSkill;
end;

procedure TNpc.SetAttackSkill (aAttackSkill : TAttackSkill);
begin
   if (AttackSkill <> nil) and (FboCopy = false) then begin
      AttackSkill.Free;
   end;

   AttackSkill := aAttackSkill;
end;

procedure TNpc.SetBattleAttackMagic (aMagicStr : String);
var
   i, Exp : Integer;
   str, mName : String;
begin
   str := aMagicStr;
   for i := 0 to BATTLE_MAGIC_SIZE - 1 do begin
      if str = '' then break;
      str := GetValidStr3 (str, mName, ':');
      Exp := GetLevelExp (pSelfData^.rAttackSkill);
      MagicClass.GetMagicData (mName, BattleAttackMagic [i], Exp);
   end;
end;

function TNpc.SelectRandomBattleAttackMagic : TMagicData;
var
   n : Integer;
begin
   if CurHeadLife <= 10 then begin
      Result := CurBattleMagic;
      exit;
   end;

   n := Random (BATTLE_MAGIC_SIZE);
   Result := BattleAttackMagic [n];
end;

{
procedure TNpc.First3daysEvent (aStr : String);
var
   Dest, str, str1, str2, str3: string;
   TeachStr, StuStr : String;
   TeacherUser, StudentUser : TUser;
   usd : TStringData;
   cnt : Integer;
begin
   str := aStr;
   if not ReverseFormat (Str, '%s: %s', str1, str2, str3, 2) then exit;
   TeachStr := Str1;

   Str := Str2;
   if ReverseFormat (str, Conv('%s님을 제자로 등록시켜주세요'), str1, str2, str3, 1) then begin
      StuStr := Str1;
      TeacherUser := UserList.GetUserPointer(TeachStr);
      if TeacherUser <> nil then begin
         if TeacherUser.GetAge >= 4000 then begin
            if TeacherUser.Student <> '' then begin
               BocSay (Conv('이미 제자가 있지않은가...'));
               exit;
            end;

            StudentUser := UserList.GetUserPointer(StuStr);
            if StudentUser <> nil then begin
               if StudentUser.Teacher <> '' then begin
                  BocSay (format (Conv('%s님은 이미 스승이 있소이다'), [Str1]));
                  exit;
               end;
               if StudentUser.Find3daysChar = true then begin
                  TeacherUser.Student := StrPas (@StudentUser.BasicData.Name);
                  StudentUser.Teacher := StrPas (@TeacherUser.BasicData.Name);

                  usd.rmsg := 1;
                  Dest := format ('%s,%s,%s,%s,', [TeacherUser.GetUserID, StrPas (@TeacherUser.BasicData.Name), StudentUser.GetUserID, StrPas(@StudentUser.BasicData.Name)]);

                  SetWordString (usd.rWordString, Dest);
                  cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);

                  FrmSockets.UdpRelationAddData (cnt, @usd);

                  BocSay (format (Conv('%s님을 제자로 등록시켰소이다. 앞으로 잘 보살펴주길...'), [Str1]));
                  exit;
               end else begin
                  BocSay (format (Conv('%s님은 해당하지않소이다'), [Str1]));
               end;
            end else begin
               BocSay (format (Conv('%s님이 없소!'), [Str1]));
            end;
         end else begin
            BocSay (Conv('나이가 어려서 아직 제자를...'));
         end;
      end;
   end;
end;
}
procedure TNpc.STradeWindow (aName : String; aKind : Byte);
var
   ItemStr : String;
   User : TUser;
begin
   User := UserList.GetUserPointer (aName);
   if User = nil then exit;

   Case aKind of
      0 : begin
         if BuySellSkill = nil then exit;
         With BuySellSkill do begin
            ItemStr := GetSellItemString;
            User.TradeWindow (SellTitle, SellCaption, BasicData.Feature.rImageNumber, SellImage, ItemStr, aKind);
         end;
      end;
      1 : begin
         if BuySellSkill = nil then exit;
         With BuySellSkill do begin
            ItemStr := GetBuyItemString;
            User.TradeWindow (BuyTitle, BuyCaption, BasicData.Feature.rImageNumber, BuyImage, ItemStr, aKind);
         end;
      end;
      3 : begin
         if SaleSkill = nil then exit;
         With SaleSkill do begin
            ItemStr := GetSellItemString;
            User.SaleWindow(Self, SaleTitle, SaleCaption, BasicData.Feature.rImageNumber, SaleImage, ItemStr, aKind);
         end;
      end;
      4 : begin
         if SaleSkill = nil then exit;
         With SaleSkill do begin
            ItemStr := GetBuyItemString;
            User.SaleWindow(Self, SaleTitle, SaleCaption, BasicData.Feature.rImageNumber, SaleImage, ItemStr, aKind);
         end;
      end;
   end;
end;


////////////////////////////////////////////////////
//
//             ===  NpcList  ===
//
////////////////////////////////////////////////////

constructor TNpcList.Create (aManager: TManager);
begin
   inherited Create ('NPC', aManager);
   ReLoadFromFile;
end;

destructor TNpcList.Destroy;
begin
   Clear;
   inherited destroy;
end;

procedure TNpcList.ReLoadFromFile;
var
   i, j : integer;
   FileName : String;
   pd : PTCreateNpcData;
   CreateNpcList : TList;
begin
   Clear;

   FileName := format ('.\Setting\CreateNpc%d.SDB', [Manager.ServerID]);
   if not FileExists (FileName) then exit;

   CreateNpcList := TList.Create;
   LoadCreateNpc (FileName, CreateNpcList);
   for i := 0 to CreateNpcList.Count - 1 do begin
      pd := CreateNpcList.Items [i];
      if pd <> nil then begin
         for j := 0 to pd^.Count - 1 do begin
            AddNpc (pd^.mName, pd^.x, pd^.y, pd^.Width, pd^.Notice, pd^.BookName);
         end;
      end;
   end;
   for i := 0 to CreateNpcList.Count - 1 do begin
      Dispose (CreateNpcList[i]);
   end;
   CreateNpcList.Clear;
   CreateNpcList.Free;
end;

function  TNpcList.GetAliveCount : Integer;
var
   i, iCount : Integer;
   Npc : TNpc;
begin
   iCount := 0;
   for i := 0 to DataList.Count - 1 do begin
      Npc := DataList.Items [i];
      if Npc.FboRegisted = true then begin
         if Npc.BasicData.Feature.rfeaturestate <> wfs_die then begin
            Inc (iCount);
         end;
      end;
   end;
   Result := iCount;
end;

procedure TNpcList.AddNpc (aNpcName: string; ax, ay, aw: integer; aNotice : Integer; aBookName : String);
var
   Npc : TNpc;
begin
   Npc := TNpc.Create;
   if Npc <> nil then begin
      Npc.SetManagerClass (Manager);
      if aNotice > 0 then begin
         Npc.SetScript (aNotice);
      end;
      Npc.Initial (aNpcName, ax, ay, aw, aBookName);
      DataList.Add (Npc);
   end;
end;

function TNpcList.CallNpc (aNpcName: string; ax, ay, aw: integer; aName : String) : TNpc;
var
   Npc : TNpc;
   AttackSkill : TAttackSkill;
begin
   Result := nil;
   
   Npc := TNpc.Create;
   if Npc <> nil then begin
      Npc.SetManagerClass (Manager);
      Npc.Initial (aNpcName, ax, ay, aw, '');
      Npc.Start;
      AttackSkill := Npc.GetAttackSkill;
      if AttackSkill <> nil then begin
         AttackSkill.SetDeadAttackName (aName);
      end;
      DataList.Add (Npc);

      Result := Npc;
   end;
end;

function TNpcList.GetNpcByID (aID : Integer) : TNpc;
var
   i : Integer;
   Npc : TNpc;
begin
   Result := nil;
   for i := 0 to DataList.Count - 1 do begin
      Npc := DataList.Items [i];
      if Npc.BasicData.ID = aID then begin
         Result := Npc;
         exit;
      end;
   end;
end;

function TNpcList.GetNpcByName (aName : String; aboAllowDie : Boolean) : TNpc;
var
   i : Integer;
   Npc : TNpc;
begin
   Result := nil;
   for i := 0 to DataList.Count - 1 do begin
      Npc := DataList.Items [i];
      if Npc <> nil then begin
         if Npc.NpcName = aName then begin
            if aboAllowDie = true then begin
               Result := Npc;
               exit;
            end else begin
               if Npc.BasicData.Feature.rfeaturestate <> wfs_die then begin
                  Result := Npc;
                  exit;
               end;
            end;
         end;
      end;
   end;
end;

function TNpcList.GetNpcPosStr : String;
var
   i : Integer;
   Npc : TNpc;
   Str : String;
begin
   Str := '';
   for i := 0 to DataList.Count - 1 do begin
      Npc := DataList.Items [i];
      if Npc.pSelfData^.rboMinimapShow = true then begin
         if Str <> '' then Str := Str + ',';
         Str := Str + format ('%s:%d:%d:%d', [StrPas (@Npc.BasicData.ViewName), Npc.BasicData.X, Npc.BasicData.Y, 64512]);
      end;
   end;

   Result := Str;
end;

procedure TNpcList.ReLoadFromNpcSetting (aName : String);
var
   i : Integer;
   Npc : TNpc;
begin
   for i := 0 to DataList.Count - 1 do begin
      Npc := DataList.Items [i];
      if Npc.NpcName = aName then begin
         if Npc.BuySellSkill <> nil then
            Npc.BuySellSkill.LoadFromFile ('.\NpcSetting\' + aName + '.txt');
         if Npc.SpeechSkill <> nil then
            Npc.SpeechSkill.LoadFromFile ('.\NpcSetting\' + aName + '.sdb');
         exit; 
      end;
   end;
end;

procedure TNpcList.RegenByName (aName : String);
var
   i : Integer;
   Npc : TNpc;
begin
   for i := 0 to DataList.Count - 1 do begin
      Npc := DataList.Items [i];
      if StrPas (@Npc.BasicData.Name) = aName then begin
         if Npc.FboRegisted = false then begin
            Npc.Regen;
         end;
      end;
   end;
end;

end.
