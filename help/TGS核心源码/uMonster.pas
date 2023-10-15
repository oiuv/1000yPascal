unit uMonster;

interface

uses
  Windows, Classes, SysUtils, mmSystem, svClass, subutil, uAnsTick, AnsUnit,
  BasicObj, FieldMsg, MapUnit, DefType, Autil32, aiunit, uUser,
  uAIPath, uManager, uSkills, uMopSub, uWorkBox;

type
   TMonster = class (TLifeObject)
   private
      pSelfData : PTMonsterData;

      // AttackSkill : TAttackSkill;
      BuySellSkill : TBuySellSkill;

      procedure  SetAttackSkillData;
   protected
      procedure  SetMonsterData;
      function   FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;

      function   Regen : Boolean;
      function   Start : Boolean;
   public
      MonsterName : String;
      MonsterViewName : String;

      constructor Create;
      destructor  Destroy; override;

      procedure   InitialEx (aMonsterName: String);
      procedure   Initial (aMonsterName: string; ax, ay, aw: integer);
      procedure   StartProcess; override;
      procedure   EndProcess; override;

      procedure   Update (CurTick: integer); override;

      procedure   CallMe(x, y : Integer);
      procedure   KillSomeone (aX, aY : Word);
      procedure   CopyMonster (aCopyCount : Integer);      

      function    SGetMoveSpeed : Integer; override;

      function    GetAttackSkill : TAttackSkill;
      procedure   SetAttackSkill (aAttackSkill : TAttackSkill);
   end;

   TMonsterList = class (TBasicObjectList)
   private
      function  GetAliveCount : Integer;
   public
      constructor Create (aManager : TManager);
      destructor  Destroy; override;

      function    AddMonster (aMonsterName : string; ax, ay, aw, aScript : integer; aMemberStr : String) : TMonster;
      function    CallMonster (aMonsterName: string; ax, ay, aw: integer; aName : String) : TMonster; overload;
      function    CallMonster (aMonsterName: string; ax, ay, aw, aScript: integer; aboRegen : Boolean) : TMonster; overload;
      function    CopyMonster (aBasicData : TBasicData; aAttackSkill : TAttackSkill) : TMonster;
      procedure   ComeOn (aName : String; X, Y : Word);
      function    MakeMonster (aMonsterName : String; ax, ay, aw, aScript : Integer; aboRegen : Boolean) : TMonster;

      procedure   MakeCopyMonster (aMonsterName : String; aX, aY, aW, aScript, aCopyCount : Integer; aboRegen : Boolean);

      function    FindMonster (aMonsterName : String) : Integer;
      function    DeleteMonster (aMonsterName : String) : Boolean;

      procedure   ReLoadFromFile;

      function    GetMonsterByName(aName : String; aboAllowDie : Boolean) : TMonster;
      function    GetMonsterByID(aID : Integer) : TMonster;
      procedure   boIceAllMonsterByName (aName : String; aboIce : Boolean);
      procedure   boHitAllMonsterByName (aName : String; aboHit : Boolean);

      function    GetAliveCountbyMonsterName (aName : String) : Integer;

      procedure   RegenByName (aName : String);

      property    AliveCount : Integer read GetAliveCount;
   end;

implementation

uses
   SvMain, uEvent, uScriptManager, uNpc;

/////////////////////////////////////
//       Monster
////////////////////////////////////
constructor TMonster.Create;
begin
   inherited Create;

   pSelfData := nil;
   AttackSkill := nil;
   BuySellSkill := nil;
end;

destructor TMonster.Destroy;
begin
   pSelfData := nil;
   if (AttackSkill <> nil) and (FboCopy = false) then begin
      AttackSkill.Free;
   end;
   if BuySellSkill <> nil then BuySellSkill.Free;
   inherited Destroy;
end;

function TMonster.Regen : Boolean;
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
         if BasicData.MonType <> 0 then begin
         end else begin
            BasicData.Feature.rHitMotion := AM_HIT1;
         end;

         CurLife := MaxLife;

         StartProcess;
         exit;
      end else begin
         if RegenWidth = 0 then begin
            KillSomeone (xx, yy);
         end;
      end;
   end;
   Result := false;
end;

function TMonster.Start : Boolean;
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
         if BasicData.MonType <> 0 then begin
         end else begin
            BasicData.Feature.rHitMotion := AM_HIT1;
         end;

         CurLife := MaxLife;

         StartProcess;
         exit;
      end;
      xx := CreatedX - RegenWidth + Random( RegenWidth * 2 );
      yy := CreatedY - RegenWidth + Random( RegenWidth * 2 );
   end;
   Result := false;
end;

procedure TMonster.SetAttackSkillData;
begin
   if pSelfData = nil then exit;
   if AttackSkill = nil then exit;

   AttackSkill.boViewHuman := pSelfData^.rboViewHuman;
   AttackSkill.boAutoAttack := pSelfData^.rboAutoAttack;
   AttackSkill.boGoodHeart := pSelfData^.rboGoodHeart;
   AttackSkill.boAttack := pSelfData^.rboAttack;
   AttackSkill.EscapeLife := pSelfData^.rEscapeLife;
   AttackSkill.ViewWidth := pSelfData^.rViewWidth;
   AttackSkill.boChangeTarget := pSelfData^.rboChangeTarget;
   AttackSkill.boBoss := pSelfData^.rboBoss;
   AttackSkill.boVassal := pSelfData^.rboVassal;
   AttackSkill.VassalCount := pSelfData^.rVassalCount;
   AttackSkill.AttackType := pSelfData^.rAttackType;

   AttackSkill.SetAttackMagic (pSelfData^.rAttackMagic);
end;

procedure TMonster.SetMonsterData;
var
   i : Integer;
begin
   if pSelfData = nil then exit;

   LifeData.damageBody      := LifeData.damageBody      + pSelfData^.rDamage;
   LifeData.damageHead      := LifeData.damageHead      + pSelfData^.rDamageHead;
   LifeData.damageArm       := LifeData.damageArm       + pSelfData^.rDamageArm;
   LifeData.damageLeg       := LifeData.damageLeg       + pSelfData^.rDamageLeg;
   LifeData.AttackSpeed     := LifeData.AttackSpeed     + pSelfData^.rAttackSpeed;
   LifeData.avoid           := LifeData.avoid           + pSelfData^.ravoid;
   LifeData.recovery        := LifeData.recovery        + pSelfData^.rrecovery;
   LifeData.Accuracy        := LifeData.Accuracy        + pSelfData^.raccuracy;
   LifeData.KeepRecovery    := LifeData.Recovery;
   LifeData.armorBody       := LifeData.armorBody       + pSelfData^.rarmor;
   LifeData.armorHead       := LifeData.armorHead       + pSelfData^.rarmor;
   LifeData.armorArm        := LifeData.armorArm        + pSelfData^.rarmor;
   LifeData.armorLeg        := LifeData.armorLeg        + pSelfData^.rarmor;
   LifeData.HitArmor        := pSelfData^.rHitArmor;
   LifeData.damageExp       := LifeData.damageBody;
   LifeData.armorExp       := LifeData.armorBody;

   LifeData.SpellResistRate [SPELLTYPE_POISON - 1] := LifeData.SpellResistRate [SPELLTYPE_POISON - 1] + pSelfData^.rSpellResistRate;

   BasicData.Feature.raninumber := pSelfData^.rAnimate;
   BasicData.Feature.rImageNumber := pSelfData^.rShape;

   for i := 0 to MOP_DROPITEM_MAX - 1 do begin
      HaveItemClass.AddDropItem (StrPas (@pSelfData^.rHaveItem[i].rName), pSelfData^.rHaveItem[i].rCount);
   end;
   for i := 0 to MOP_FALLITEM_MAX - 1 do begin
      HaveItemClass.AddFallItem (StrPas (@pSelfData^.rFallItem[i].rName), pSelfData^.rFallItem[i].rCount, pSelfData^.rFallItem[i].rColor);
   end;
   for i := 0 to MOP_QUESTITEM_MAX - 1 do begin
      HaveItemClass.AddQuestItem (StrPas (@pSelfData^.rQuestHaveItem[i].rName),pSelfData^.rQuestHaveItem[i].rCount, pSelfData^.rQuestHaveItem[i].rColor);
   end;

   HaveItemClass.FallItemRandomCount := pSelfData^.rFallItemRandCount;

   QuestNum := pSelfData^.rQuestNum;
   MaxLife := pSelfData^.rLife;
   CurLife := MaxLife;

   SetAttackSkillData;

   WalkSpeed := pSelfData^.rWalkSpeed;
   
   SoundStart := pSelfData^.rSoundStart;
   SoundNormal := pSelfData^.rSoundNormal;
   SoundAttack := pSelfData^.rSoundAttack;
   SoundDie := pSelfData^.rSoundDie;
   SoundStructed := pSelfData^.rSoundStructed;

   EffectStart := pSelfData^.rEffectStart;
   EffectStructed := pSelfData^.rEffectStructed;
   EffectEnd := pSelfData^.rEffectEnd;
end;

procedure  TMonster.Initial (aMonsterName: string; ax, ay, aw: Integer);
begin
   MonsterClass.GetMonsterData (aMonsterName, pSelfData);

   inherited Initial (aMonsterName, StrPas (@pSelfData^.rViewName));

   if AttackSkill = nil then begin
      AttackSkill := TAttackSkill.Create (Self);
      AttackSkill.TargetX := ax;
      AttackSkill.TargetY := ay;
   end;

   HaveItemClass.Clear;
   
   SetMonsterData;

   MonsterName := aMonsterName;
   MonsterViewName := StrPas (@pSelfData^.rViewName);

   Basicdata.id := GetNewMonsterId;
   if pSelfData^.rboRandom = true then begin
      BasicData.X := ax - aw + Random(aw * 2);
      BasicData.Y := ay - aw + Random(aw * 2);
   end else begin
      BasicData.X := ax;
      BasicData.Y := ay;
   end;
   BasicData.ClassKind := CLASS_MONSTER;
   BasicData.Feature.rrace := RACE_MONSTER;
   if pSelfData^.rMonType <> 0 then begin
      BasicData.MonType := pSelfData^.rMonType;
      BasicData.Feature := pSelfData^.rFeature;
      strcopy (@BasicData.Guild,@pSelfData^.rGuild);
   end;
   
   CreatedX := ax;
   CreatedY := ay;

   RegenWidth := aw;
   ActionWidth := pSelfData^.rActionWidth;

   VirtueValue := pSelfData^.rVirtue;
   VirtueLevel := pSelfData^.rVirtueLevel;

   FboHit := pSelfData^.rboHit;
   FboNotBowHit := pSelfData^.rboNotBowHit;
//   FboSpecialExp := pSelfData^.rboSpecialExp;
   FShortExp := pselfData^.rShortExp;
   FRiseShortExp := pselfData^.rRiseShortExp;
   FLongExp := pselfData^.rLongExp;
   FRiseLongExp := pselfData^.rRiseLongExp;
   FHandExp := pSelfData^.rHandExp;
   FBestShortExp  := pselfData^.rBestShortExp;   //2003-09-29 giltae
   FBestShortExp2 := pselfData^.rBestShortExp2; //2003-09-29 giltae
   FBestShortExp3 := pselfData^.rBestShortExp3; //2003-09-29 giltae

   FExtraExp := pselfData^.rExtraExp; //2003-10
   F3HitExp := pselfData^.r3HitExp; //2003-10
   FLimitSkill := pSelfData^.rLimitSkill;
   FKind := pSelfData^.rKind;

   ArmorWindOfHandPercent := pSelfData^.rArmorWHPercent;   
   
   FboIce := pSelfData^.rboIce;
   GroupKey := pSelfData^.rGroupKey;

   if BuySellSkill = nil then
      BuySellSkill := TBuySellSkill.Create (Self);
end;

procedure  TMonster.InitialEx (aMonsterName: String);
begin
   MonsterClass.GetMonsterData (aMonsterName, pSelfData);

   StrPCopy (@BasicData.Name, StrPas (@pSelfData^.rName));
   StrPCopy (@BasicData.ViewName, StrPas (@pSelfData^.rViewName));

   inherited InitialEx;

   if AttackSkill = nil then begin
      AttackSkill := TAttackSkill.Create (Self);
      AttackSkill.TargetX := BasicData.X;
      AttackSkill.TargetY := BasicData.Y;
   end;

   HaveItemClass.DropItemClear;
   HaveItemClass.FallItemClear;

   HaveMagicClass.Init (pSelfData^.rHaveMagic);

   SetMonsterData;

   MonsterName := aMonsterName;
   MonsterViewName := StrPas (@pSelfData^.rViewName);   
end;

procedure TMonster.StartProcess;
var
   SubData : TSubData;
begin
   inherited StartProcess;

   if pSelfData^.rFirstDir <> 0 then begin
      BasicData.dir := pSelfData^.rFirstDir;
   end;
   
   if AttackSkill = nil then begin
      AttackSkill := TAttackSkill.Create (Self);

      AttackSkill.TargetX := CreateX;
      AttackSkill.TargetY := CreateY;
      // AttackSkill.TargetX := CreateX - 3 + Random (6);
      // AttackSkill.TargetY := CreateY - 3 + Random (6);

      SetAttackSkillData;
   end;

   HaveMagicClass.Init (pSelfData^.rHaveMagic);
   BuySellSkill.LoadFromFile ('.\NpcSetting\' + StrPas (@BasicData.Name) + '.txt');

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (0, FM_CREATE, BasicData, SubData);

   if FboCopy = true then begin
      ShowEffect2 (1, lek_none, 0);
   end;

   // Àº½Å¼ú
   if HaveMagicClass.isHaveHideMagic then begin
      if HaveMagicClass.RunHaveHideMagic (BasicData.LifePercent) then begin
         SetHideState (hs_0);
      end;
   end;

   if pSelfData^.rboControl = true then begin
      LifeObjectState := los_control;
   end;

   if pSelfData^.rEffectStart <> 0 then ShowEffect2 (pSelfData^.rEffectStart, lek_follow, 0);

   if pSelfData^.rSoundStart.rWavNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (pSelfData^.rSoundStart.rWavNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   if SOnRegen <> 0 then begin
       ScriptManager.CallEvent (Self, nil, SOnRegen, 'OnRegen', ['']);
   end;
end;

procedure TMonster.EndProcess;
var
   SubData : TSubData;
begin
   if FboRegisted = FALSE then exit;

   if pSelfData^.rEffectEnd <> 0 then ShowEffect2 (pSelfData^.rEffectEnd, lek_follow, 0);
   AttackedMagicClass.Clear;
   Phone.SendMessage (0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   SetAttackSkill (nil);
   FboCopy := false;
   RemovedTick := mmAnsTick;

   inherited EndProcess;
end;

procedure TMonster.CallMe(x, y : Integer);
begin
   EndProcess;
   BasicData.x := x;
   BasicData.y := y;
   StartProcess;
end;

procedure TMonster.KillSomeone (aX, aY : Word);
var
   ObjectID : Integer;
   Npc : TNpc;
   Monster : TMonster;
   User : TUser;
begin
   ObjectID := Maper.GetObjectID (ax, ay);
   if ObjectID > 0 then begin
      if isUserID (ObjectID) = true then begin
         User := UserList.GetUserPointerById (ObjectID);
         if User <> nil then begin
            User.CommandChangeCharState (wfs_die);
         end;
      end else if isMonsterID (ObjectID) = true then begin
         Monster := TMonsterList(Manager.MonsterList).GetMonsterByID (ObjectID);
         if Monster <> nil then begin
            Monster.CommandChangeCharState (wfs_die, BasicData);
         end else begin
            Npc := TNpcList(Manager.NpcList).GetNpcByID (ObjectID);
            if Npc <> nil then begin
               Npc.CommandChangeCharState (wfs_die, BasicData);
            end;
         end;
      end;
   end;
end;

function  TMonster.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i, j, percent, n : Integer;
   len, len2, key: word;
   Str : String;
   bo : TBasicObject;
   SubData : TSubData;
   Monster : TMonster;
   MopName : array [0..5-1] of String;
   MopCount : array [0..5-1] of Integer;
   CellWidth : Word;
   Code : Byte;
label abcde;

begin
   Result := PROC_FALSE;

   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;
   if FboAllowDelete = true then exit;

   if LifeObjectState = los_die then exit;

   try
      case Msg of
         FM_IAMHERE, FM_HIT, FM_STRUCTED, FM_CHANGEFEATURE, FM_MOVE, FM_SHOW:
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TMonster.FieldProc (%s) failed AttackSkill=nil Msg=%d', [MonsterName, Msg]));
                  exit;
               end;
               if SenderInfo.id = BasicData.id then goto abcde;
               if (pSelfData^.rboPK = true) and (SenderInfo.Feature.rrace = RACE_MONSTER) then begin
                  if StrPas (@BasicData.Name) = StrPas (@SenderInfo.Name) then exit;
                  if AttackSkill.GetTargetID = 0 then begin
                     AttackSkill.SetTargetID (SenderInfo.ID, false);
                     exit;
                  end;
                  if isUserID (AttackSkill.GetTargetID) = true then begin
                     AttackSkill.SetTargetID (SenderInfo.ID, false);
                     exit;
                  end;
                  exit;
               end;
               if SenderInfo.Feature.rrace <> RACE_HUMAN then goto abcde; // ÁÖ¼®ÀÌ¸é ¸ó½ºÅÍµµ °ø°Ý
               if (SenderInfo.Feature.rHideState = hs_0) or (SenderInfo.Feature.rfeaturestate = wfs_shop) then begin
                  if HaveMagicClass.isHaveShowMagic = false then begin
                     if HaveMagicClass.RunHaveShowMagic = false then begin
                        goto abcde;
                     end;
                  end else begin
                     if TUser (SenderInfo.P).SysopScope = 101 then goto abcde;  // Åõ½ÃÇÑ ¸ó½ºÅÍ¶óµµ ¿î¿µÀÚ¸é Áö³ªÄ¡°Ô   03-09-23 saset
                  end;
               end;

               if (SenderInfo.Feature.rFeatureState = wfs_die) then begin
                  if SenderInfo.id = AttackSkill.CurNearViewHumanId then AttackSkill.CurNearViewHumanId := 0;
                  if SenderInfo.id = AttackSkill.HateHumanId then AttackSkill.HateHumanId := 0;
                  goto abcde;
               end;
               len := GetLargeLength (BasicData.x, BasicData.y, SenderInfo.x, SenderInfo.y);
               if AttackSkill.ViewWidth < len then exit;
               if AttackSkill.boViewHuman = FALSE then exit;
               bo := nil;
               if AttackSkill.CurNearViewHumanID <> 0 then
                  bo := TBasicObject (GetViewObjectById (AttackSkill.CurNearViewHumanId));
               if bo <> nil then begin
                  len2 := GetLargeLength (BasicData.x, BasicData.y, bo.Posx, bo.Posy);
                  if len2 > len then AttackSkill.CurNearViewHumanId := SenderInfo.id;
               end else AttackSkill.CurNearViewHumanId := SenderInfo.id;
            end;
         FM_HIDE :
            begin
               if AttackSkill = nil then begin
                  // frmMain.WriteLogInfo (format ('TMonster.FieldProc (%s) failed AttackSkill=nil Msg=%d', [MonsterName, Msg]));
                  exit;
               end;
               if SenderInfo.id = BasicData.id then goto abcde;
               if SenderInfo.id = AttackSkill.CurNearViewHumanId then AttackSkill.CurNearViewHumanId := 0;
               if SenderInfo.id = AttackSkill.HateHumanId then AttackSkill.HateHumanId := 0;
            end;
         FM_CLICK :
            begin
               if SOnLeftClick <> 0 then begin
                  ScriptManager.CallEvent (Self, SenderInfo.P, SOnLeftClick, 'OnLeftClick', ['']);
                  exit;
               end;
            end;
      end;
   abcde:

      case Msg of
         FM_IAMHERE :
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TMonster.FieldProc (%s) failed AttackSkill=nil Msg=%d', [MonsterName, Msg]));
                  exit;
               end;
               if SenderInfo.ID = BasicData.ID then exit;
               if SenderInfo.Feature.rRace = RACE_ITEM then begin
                  if (LifeObjectState <> los_none) and (LifeObjectState <> los_attack) then exit;

                  // ¼öÁý¼ú
                  if not HaveMagicClass.isHavePickMagic then exit;
                  if not HaveMagicClass.RunHavePickMagic (BasicData.LifePercent, StrPas (@SenderInfo.Name)) then exit;
                  if HaveItemClass.HaveItemFreeCount > 0 then begin
                     AttackSkill.SetSaveIDandPos (SenderInfo.ID, SenderInfo.X, SenderInfo.Y, los_eat);
                     LifeObjectState := los_movework;
                     exit;
                  end;
               end;
            end;
         FM_SHOW :
            begin
            end;
         FM_ADDITEM :
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TMonster.FieldProc (%s) failed AttackSkill=nil Msg=%d', [MonsterName, Msg]));
                  exit;
               end;
               if pSelfData^.rboControl = true then exit;

               if LifeObjectState = los_die then exit;
               if SenderInfo.Feature.rrace = RACE_ITEM then begin
                  Str := StrPas (@aSubData.ItemData.rName);
                  if HaveItemClass.AddHaveItem (Str, aSubData.ItemData.rCount, aSubData.ItemData.rColor) = true then begin
                     SetWordString (SubData.SayString, IntToStr (aSubData.ItemData.rSoundDrop.rWavNumber));
                     SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
                     Result := PROC_TRUE;
                  end;
               end;
            end;
         FM_CHANGEFEATURE:
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TMonster.FieldProc (%s) failed AttackSkill=nil Msg=%d', [MonsterName, Msg]));
                  exit;
               end;
               if pSelfData^.rboControl = true then exit;
               if SenderInfo.ID = BasicData.ID then exit;

               if SOnChangeState <> 0 then begin
                  Str := 'normal';
                  if SenderInfo.Feature.rFeatureState = wfs_die then Str := 'die';
                  ScriptManager.CallEvent (Self, SenderInfo.P, SOnChangeState, 'OnChangeState', [Str]);
               end;

               // if LifeObjectState = los_attack then exit;
               if SenderInfo.Feature.rRace <> RACE_HUMAN then exit;
               if SenderInfo.Feature.rfeaturestate <> wfs_die then exit;
               if HaveMagicClass.isHaveKillMagic then begin
                  AttackSkill.SetSaveIDandPos (SenderInfo.ID, SenderInfo.X, SenderInfo.Y, los_kill);
                  LifeObjectState := los_movework;
                  exit;
               end;
            end;
         FM_GATHERVASSAL :
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TMonster.FieldProc (%s) failed AttackSkill=nil Msg=%d', [MonsterName, Msg]));
                  exit;
               end;
               if pSelfData^.rboControl = true then exit;

               if SenderInfo.id = BasicData.id then exit;
               if AttackSkill.boVassal and (LifeObjectState = los_none) and (aSubData.VassalCount > 0) then begin
                  aSubData.VassalCount := aSubData.VassalCount - 1;
                  AttackSkill.SetTargetId (aSubData.TargetId, false);
               end;
            end;
         FM_BOW, FM_WINDOFHAND :
            begin
               if pSelfData^.rboControl = true then exit;

               if SenderInfo.ID = BasicData.ID then exit;
               if BasicData.Feature.rfeaturestate = wfs_die then begin Result := PROC_TRUE; exit; end;

               if aSubData.TargetId = Basicdata.id then begin
                  // ¼ÒÈ¯¼ú
                  if HaveMagicClass.isHaveCallMagic = true then begin
                     for i := 0 to 5 - 1 do begin
                        MopName [i] := '';
                        MopCount [i] := 0;
                     end;
                     if HaveMagicClass.RunHaveCallMagic (MopName, MopCount, CellWidth) = true then begin
                        for i := 0 to 5 - 1 do begin
                           if MopCount [i] > 0 then begin
                              MopCount [i] := MopCount [i] - GetViewObjectCountByName (MopName [i]);
                              if MopCount [i] < 0 then MopCount [i] := 0;
                              for j := 0 to MopCount [i] - 1 do begin
                                 Monster := TMonsterList (Manager.MonsterList).CallMonster (MopName [i], BasicData.X, BasicData.Y, CellWidth, '');
                                 if Monster <> nil then
                                    Monster.boRegen := false;
                              end;
                           end;
                        end;
                     end;
                  end;
               end;

            end;
         FM_HIT,
         FM_MOVE :
            begin
               if pSelfData^.rboControl = true then exit;

               if SenderInfo.ID = BasicData.ID then exit;

               if Msg = FM_HIT then begin
                  if BasicData.Feature.rfeaturestate <> wfs_die then begin
                     if isHitedArea (SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then begin
                        // ¼ÒÈ¯¼ú
                        if HaveMagicClass.isHaveCallMagic = true then begin
                           for i := 0 to 5 - 1 do begin
                              MopName [i] := '';
                              MopCount [i] := 0;
                           end;
                           if HaveMagicClass.RunHaveCallMagic (MopName, MopCount, CellWidth) = true then begin
                              for i := 0 to 5 - 1 do begin
                                 if MopCount [i] > 0 then begin
                                    MopCount [i] := MopCount [i] - GetViewObjectCountByName (MopName [i]);
                                    if MopCount [i] < 0 then MopCount [i] := 0;
                                    for j := 0 to MopCount [i] - 1 do begin
                                       Monster := TMonsterList (Manager.MonsterList).CallMonster (MopName [i], BasicData.X, BasicData.Y, CellWidth, '');
                                       if Monster <> nil then
                                          Monster.boRegen := false;
                                    end;
                                 end;
                              end;
                           end;
                        end;
                     end;
                  end;
               end;

               // Àç»ý¼ú
               if HaveMagicClass.isHaveHealMagic then begin
                  if HaveMagicClass.RunHaveHealMagic (StrPas (@SenderInfo.Name), SenderInfo.LifePercent, SubData) then begin
                     key := GetNextDirection (BasicData.X, BasicData.Y, SenderInfo.X, SenderInfo.Y);
                     if (key <> DR_DONTMOVE) and (key <> BasicData.dir) then begin
                        CommandTurn (key);
                     end;

                     SubData.MagicState := 0;
                     SubData.MagicKind := 0;
                     SubData.MagicColor := 0;
                     SubData.Motion := BasicData.Feature.rHitMotion;
                     SendLocalMessage (NOTARGETPHONE, FM_MOTION, BasicData, SubData);
                     ShowEffect2 (6, lek_follow, 0);
                     SendLocalMessage (SenderInfo.ID, FM_HEAL, BasicData, SubData);
                  end;
               end;
            end;
         FM_HEAL :
            begin
               if pSelfData^.rboControl = true then exit;

               ShowEffect2 (6, lek_follow, 0);
               CurLife := CurLife + aSubData.HitData.ToHit;
               if CurLife > MaxLife then CurLife := MaxLife;

               if MaxLife <= 0 then BasicData.LifePercent := 0
               else BasicData.LifePercent := CurLife * 100 div MaxLife;
               SubData.Percent := BasicData.LifePercent;
               SendLocalMessage (NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
            end;
         FM_STRUCTED :
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TMonster.FieldProc (%s) failed AttackSkill=nil Msg=%d', [MonsterName, Msg]));
                  exit;
               end;
               if pSelfData^.rboControl = true then exit;

               if SenderInfo.id = BasicData.id then begin
                  if CurLife <= 0 then CurLife := 0;
                  // Àº½Å¼ú
                  if HaveMagicClass.isHaveHideMagic then begin
                     if BasicData.Feature.rHideState = hs_100 then begin
                        if HaveMagicClass.RunHaveHideMagic (BasicData.LifePercent) then begin
                           SetHideState (hs_0);
                        end;
                     end;
                  end;
                  // ºÐ½Å¼ú
                  if HaveMagicClass.isHaveSameMagic then begin
                     if (FboCopy = false) and (LifeObjectState = los_attack) then begin
                        if HaveMagicClass.RunHaveSameMagic (BasicData.LifePercent, SubData) = true then begin
                           if CopiedList = nil then begin
                              CopiedList := TList.Create;
                           end;
                           CopiedList.Clear;
                           if BasicData.Feature.rrace = RACE_MONSTER then begin
                              for j := 0 to SubData.HitData.ToHit - 1 do begin
                                 Monster := TMonsterList (Manager.MonsterList).CopyMonster (BasicData, AttackSkill);
                                 if Monster <> nil then begin
                                    Monster.CopyBoss := Self;
                                    Monster.LifeObjectState := LifeObjectState;
                                    CopiedList.Add (Monster);
                                    Monster.boRegen := false;
                                 end;
                              end;
                           end;
                        end;
                     end;
                  end;

                  // ½Ã¾à¼ú
                  if HaveMagicClass.isHaveEatMagic then begin
                     if HaveMagicClass.RunHaveEatMagic (BasicData.LifePercent, HaveItemClass, SubData) then begin
                        CurLife := CurLife + SubData.HitData.ToHit;
                        if CurLife > MaxLife then CurLife := MaxLife;

                        if MaxLife <= 0 then BasicData.LifePercent := 0
                        else BasicData.LifePercent := CurLife * 100 div MaxLife;
                        SubData.Percent := BasicData.LifePercent;
                        SendLocalMessage (NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
                     end;
                  end;

                  //Á×¾úÀ»¶§ÀÇ Ã³¸®.
                  if CurLife <= 0 then begin
                     AttackSkill.SetTargetId (0, true);
                     if HaveMagicClass.isHaveSwapMagic = false then begin
                        SubData.percent := 1;
                     end else begin
                        HaveMagicClass.RunHaveSwapMagic (0, SubData);
                     end;
                     if SubData.percent = 1 then begin
                        n := FindBestExpLink;
                        HaveItemClass.DropItemGround (n);
                     end;

                     Code := EventClass.isMopDieEvent (StrPas (@BasicData.Name));
                     if Code > 0 then begin
                        EventClass.RunMopDieEvent (Code);
                     end;
                     exit;
                  end;
                  if AttackSkill.boAttack = false then exit;

                  if AttackSkill.boChangeTarget then begin
                     Bo := GetViewObjectByID (AttackSkill.GetTargetID);
                     if Bo <> nil then begin
                        len := GetLargeLength (BasicData.x, BasicData.y, Bo.Posx, Bo.Posy);
                        if len > 1 then begin
                           AttackSkill.SetTargetId (aSubData.attacker, true);
                        end;
                     end;
                  end;
                  if isUserId (aSubData.attacker) then AttackSkill.HateHumanId := aSubData.attacker;
               end;
            end;
         FM_DEADHIT :
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TMonster.FieldProc (%s) failed AttackSkill=nil Msg=%d', [MonsterName, Msg]));
                  exit;
               end;
               if pSelfData^.rboControl = true then exit;

               if SenderInfo.id = BasicData.id then exit;
               if BasicData.Feature.rfeaturestate = wfs_die then begin Result := PROC_TRUE; exit; end;
               
               CurLife := 0;
               BasicData.LifePercent := 0;

               AttackSkill.SetTargetId (0, true);
               if HaveMagicClass.isHaveSwapMagic = false then begin
                  HaveItemClass.DropItemGround (0);
               end;

               Code := EventClass.isMopDieEvent (StrPas (@BasicData.Name));
               if Code > 0 then begin
                  EventClass.RunMopDieEvent (Code);
               end;

               CommandChangeCharState (wfs_die, SenderInfo);
            end;
         FM_SAY :
            begin
               if AttackSkill = nil then begin
                  frmMain.WriteLogInfo (format ('TMonster.FieldProc (%s) failed AttackSkill=nil Msg=%d', [MonsterName, Msg]));
                  exit;
               end;
               if pSelfData^.rboControl = true then exit;

               if SenderInfo.Feature.rfeaturestate = wfs_die then exit;
               if SenderInfo.id = BasicData.id then exit;
               if SenderInfo.Feature.rrace <> RACE_HUMAN then exit;
               str := GetWordString (aSubData.SayString);

               if pSelfData^.rboSeller = true then  begin
                  if BuySellSkill <> nil then begin
                     if BuySellSkill.ProcessMessage (str, SenderInfo) = true then exit;
                  end;
               end;
            end;
      end;
   except
      frmMain.WriteLogInfo (format ('TMonster.FieldProc (%s) failed except msg=%d', [MonsterName, Msg]));
      exit;
   end;
end;

procedure TMonster.Update (CurTick: integer);
var
   i, ret : Integer;
   key : Word;
   boFlag : Boolean;
   SubData : TSubData;
   BO : TLifeObject;
   BasicObject : TBasicObject;
   Params : array [0..5 - 1] of String;
begin
   inherited UpDate (CurTick);
   if FboAllowDelete = true then exit;
   if CurTick < UpdateTick + OBJECTUPDATETICK then exit;
   UpdateTick := CurTick;

   if (LifeObjectState <> los_init) and (LifeObjectState <> los_exit) then begin
      if BasicData.Feature.rfeaturestate = wfs_die then begin
         LifeObjectState := los_die;
      end;
      // ÈíÇ÷¼ú
      if LifeObjectState <> los_die then begin
         if HaveMagicClass.isHaveBloodMagic = true then begin
            if HaveMagicClass.RunHaveBloodMagic (SubData) = true then begin
               if SubData.EffectNumber <> 0 then begin
                  BasicData.Feature.rEffectNumber := SubData.EffectNumber+1;
                  BasicData.Feature.rEffectKind := lek_follow;
                  SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                  BasicData.Feature.rEffectNumber := 0;
                  BasicData.Feature.rEffectKind := lek_none;
               end;
               SendLocalMessage (NOTARGETPHONE, FM_SPELL, BasicData, SubData);
            end;
         end;
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
                  frmMain.WriteLogInfo (format ('TMonster.Start (%s,%d,%d,%d) failed los_init', [MonsterName, ServerID, BasicData.X, BasicData.Y]));
                  FboAllowDelete := true;
               end;
               exit;
            end;
         los_exit :
            begin
               if pSelfData^.rRegenInterval > 0 then begin
                  if CurTick >= RemovedTick + pSelfData^.rRegenInterval then begin
                     if pSelfData^.rActionWidth = 0 then begin
                        if Start = false then begin
                           // frmMain.WriteLogInfo (format ('TMonster.Start (%s,%d,%d,%d) failed los_exit', [MonsterName, ServerID, BasicData.X, BasicData.Y]));
                        end;
                     end else begin
                        if Regen = false then begin
                           // frmMain.WriteLogInfo (format ('TMonster.Regen (%s,%d,%d,%d) failed los_exit', [MonsterName, ServerID, BasicData.X, BasicData.Y]));
                        end;
                     end;
                  end;
               end else if pSelfData^.rRegenInterval = 0 then begin
                  if Regen = false then begin
                     // frmMain.WriteLogInfo (format ('TMonster.Regen (%s,%d,%d,%d) failed los_exit', [MonsterName, ServerID, BasicData.X, BasicData.Y]));
                  end;
               end;
            end;
         los_die :
            begin
               // º¯½Å¼ú
               if CurTick > DiedTick + 400 then begin
                  if HaveMagicClass.isHaveSwapMagic then begin
                     if HaveMagicClass.RunHaveSwapMagic (BasicData.LifePercent, SubData) = true then begin
                        InitialEx (StrPas (@SubData.SubName));
                        if pSelfData^.rRegenInterval > 0 then begin
                           EndProcess;
                        end else begin
                           SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                        end;
                     end;
                     exit;
                  end;
               end;

               if (pSelfData^.rboControl = true) or (pSelfData^.rboRightRemove = true) then begin
                  if FboRegen = false then FboAllowDelete := true;
                  if FboAllowDelete = false then begin
                     EndProcess;
                  end;
                  exit;
               end;

               if Manager.RegenInterval = 0 then begin
                  if CurTick > DiedTick + 1600 then begin
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
               end else begin
                  if CurTick > DiedTick + 800 then begin
                     FboAllowDelete := true;
                     exit;
                  end;
               end;
            end;
         los_none:
            begin
               try
                 if pSelfData^.rboPK = true then begin
                    if FWorkBox.WorkSet = nil then begin
                       BasicObject := UserList.GetUserForPK (Manager);
                       if BasicObject <> nil then begin
                          Params [0] := IntToStr (BasicObject.BasicData.X);
                          Params [1] := IntToStr (BasicObject.BasicData.Y);
                          PushCommand (CMD_GOTOXY, Params, 0);
                          Params [0] := IntToStr (BasicObject.BasicData.ID);
                          PushCommand (CMD_MOVEATTACK, Params, 0);
                       end;
                    end;
                 end;
               except
                  FboAllowDelete := true;
                  frmMain.WriteLogInfo (format ('TMonster.Update2 failed. Name=%s los=%d boReg=%d', [MonsterName, Byte (LifeObjectState), Byte (FboRegisted)]));
                  frmMain.WriteDumpInfo (@BasicData, SizeOf (TBasicData));
                  exit;
               end;

               //ÀÌ ºÎºÐ¿¡¼­ Update failµÇ°í ÀÖÀ½. try except¸¦ ¼¼ºÎÈ­ÇÑ´Ù.
               try
                  if AttackSkill <> nil then begin
                     ret := AttackSkill.ProcessNone (CurTick);
                     if ret = 0 then begin
                        if SOnArrival <> 0 then begin
                           ScriptManager.CallEvent (Self, nil, SOnArrival, 'OnArrival', ['']);
                        end;
                     end;
                  end;
               except
                  FboAllowDelete := true;
                  frmMain.WriteLogInfo (format ('TMonster.Update3 failed. Name=%s los=%d boReg=%d', [MonsterName, Byte (LifeObjectState), Byte (FboRegisted)]));
                  frmMain.WriteDumpInfo (@BasicData, SizeOf (TBasicData));
                  exit;
               end;
            end;
         los_escape:
            begin
               if AttackSkill <> nil then AttackSkill.ProcessEscape (CurTick);
            end;
         los_attack:
            begin
               if AttackSkill <> nil then begin
                  boFlag := AttackSkill.ProcessAttack (CurTick, Self);
                  if (boFlag = false) and (FboCopy = false) then begin
                     if CopiedList <> nil then begin
                        for i := 0 to CopiedList.Count - 1 do begin
                           BO := TLifeObject (CopiedList[i]);
                           BO.boAllowDelete := true;
                        end;
                     end;
                  end;
               end;
            end;
         los_moveattack :
            begin
               if AttackSkill <> nil then AttackSkill.ProcessMoveAttack (CurTick);
            end;
         los_deadattack :
            begin
               if AttackSkill <> nil then AttackSkill.ProcessDeadAttack (CurTick);
            end;
         los_movework :
            begin
               if AttackSkill <> nil then AttackSkill.ProcessMoveWork (CurTick);
            end;
         los_eat :
            begin
               if AttackSkill = nil then begin
                  LifeObjectState := los_none;
                  exit;
               end;
               if CurTick < AttackSkill.ArrivalTick + 100 then exit;

               BasicObject := TBasicObject (GetViewObjectByID (AttackSkill.GetSaveID));
               if BasicObject <> nil then begin
                  if BasicObject.BasicData.Feature.rRace = RACE_ITEM then begin
                     Phone.SendMessage (BasicObject.BasicData.ID, FM_PICKUP, BasicData, SubData);
                  end;
               end;
               LifeObjectState := los_none;
               if AttackSkill.GetTargetID <> 0 then LifeObjectState := los_attack;
            end;
         los_kill :
            begin
               if AttackSkill = nil then begin
                  LifeObjectState := los_none;
                  exit;
               end;
               if CurTick < AttackSkill.ArrivalTick + 100 then exit;

               BasicObject := TBasicObject (GetViewObjectByID (AttackSkill.GetSaveID));
               if BasicObject <> nil then begin
                  if BasicObject.BasicData.Feature.rRace = RACE_HUMAN then begin
                     if BasicObject.BasicData.Feature.rFeatureState = wfs_die then begin
                        key := GetNextDirection (BasicData.X, BasicData.Y, AttackSkill.TargetX, AttackSkill.TargetY);
                        if (key <> DR_DONTMOVE) and (key <> BasicData.dir) then begin
                           CommandTurn (key);
                        end;
                        Phone.SendMessage (BasicObject.BasicData.ID, FM_KILL, BasicData, SubData);
                     end;
                  end;
               end;
               LifeObjectState := los_none;
               if AttackSkill.GetTargetID <> 0 then LifeObjectState := los_attack;
            end;
         los_move :
            begin
               if AttackSkill <> nil then begin
                  if AttackSkill.ProcessMove (CurTick) = false then exit;
               end;

               LifeObjectState := los_none;
            end;
         los_control :
            begin
               if AttackSkill <> nil then begin
                  if AttackSkill.ProcessControl (CurTick, pSelfData^.rXControl, pSelfData^.rYControl) = true then begin
                     CommandChangeCharState (wfs_die, BasicData);
                     exit;
                  end;
               end;
            end;
      end;
   except
      FboAllowDelete := true;
      frmMain.WriteLogInfo (format ('TMonster.Update failed. Name=%s los=%d boReg=%d', [MonsterName, Byte (LifeObjectState), Byte (FboRegisted)]));
      frmMain.WriteDumpInfo (@BasicData, SizeOf (TBasicData));
   end;
end;

function TMonster.GetAttackSkill : TAttackSkill;
begin
   if AttackSkill = nil then
      AttackSkill := TAttackSkill.Create (Self);

   Result := AttackSkill;
end;

procedure TMonster.SetAttackSkill (aAttackSkill : TAttackSkill);
begin
   if AttackSkill <> nil then begin
      if FboCopy = false then begin
         AttackSkill.Free;
      end;
   end;

   AttackSkill := aAttackSkill;
end;

procedure TMonster.CopyMonster (aCopyCount : Integer);
var
   i : Integer;
   Monster : TMonster;
begin
   if FboCopy = true then exit;

   if CopiedList = nil then begin
      CopiedList := TList.Create;
   end;
   CopiedList.Clear;

   for i := 0 to aCopyCount - 1 do begin
      Monster := TMonsterList (Manager.MonsterList).CopyMonster (BasicData, AttackSkill);
      if Monster <> nil then begin
         Monster.CopyBoss := Self;
         Monster.LifeObjectState := LifeObjectState;
         CopiedList.Add (Monster);
         Monster.boRegen := false;
      end;
   end;
end;

function TMonster.SGetMoveSpeed : Integer;
begin
   Result := pSelfData.rWalkSpeed;
end;


////////////////////////////////////////////////////
//
//             ===  MonsterList  ===
//
////////////////////////////////////////////////////

constructor TMonsterList.Create (aManager: TManager);
begin
   inherited Create ('MONSTER', aManager);

   ReLoadFromFile;
end;

destructor TMonsterList.Destroy;
begin
   Clear;
   
   inherited destroy;
end;

procedure TMonsterList.ReLoadFromFile;
var
   i, j : integer;
   pd : PTCreateMonsterData;
   FileName : String;
   CreateMonsterList : TList;
   tmpMonster : TMonster;
begin
   Clear;

   FileName := format ('.\Setting\CreateMonster%d.SDB', [Manager.ServerID]);
   if not FileExists (FileName) then exit;

   CreateMonsterList := TList.Create;
   LoadCreateMonster (FileName, CreateMonsterList);
   for i := 0 to CreateMonsterList.Count - 1 do begin
      pd := CreateMonsterList.Items [i];
      if pd <> nil then begin
         for j := 0 to pd^.Count - 1 do begin
            tmpMonster := AddMonster (pd^.mName, pd^.x, pd^.y, pd^.Width, pd^.Script, pd^.Member);

            if (Manager.MapAttribute = MAP_TYPE_GUILDBATTLE) or
              (Manager.MapAttribute = MAP_TYPE_SPORTBATTLE) then begin
            //Author:Steven Date: 2005-01-19 11:22:52
            //Note:
               if i < 2 then
                  Manager.BattleMop [i] := tmpMonster;           //jÖ¸µÄÊÇÔÚ±¾µØÍ¼ÉÏ£¬²úÉúµÄMonterÊýÁ¿
               //Manager.BattleMop [j] := tmpMonster;
            //=======================================
            end;
         end;
      end;
   end;
   for i := 0 to CreateMonsterList.Count - 1 do begin
      Dispose (CreateMonsterList[i]);
   end;
   CreateMonsterList.Clear;
   CreateMonsterList.Free;
end;

function  TMonsterList.GetAliveCount : Integer;
var
   i, iCount : Integer;
   Monster : TMonster;
begin
   iCount := 0;
   for i := 0 to DataList.Count - 1 do begin
      Monster := DataList.Items [i];
      if Monster.FboRegisted = true then begin
         if Monster.BasicData.Feature.rfeaturestate <> wfs_die then begin
            Inc (iCount);
         end;
      end;
   end;
   Result := iCount;
end;

function  TMonsterList.GetAliveCountbyMonsterName (aName : String) : Integer;
var
   i, iCount : Integer;
   Monster : TMonster;
begin
   iCount := 0;
   for i := 0 to DataList.Count - 1 do begin
      Monster := DataList.Items [i];
      if StrPas (@Monster.BasicData.Name) = aName then begin
         if Monster.FboRegisted = true then begin
            if Monster.BasicData.Feature.rfeaturestate <> wfs_die then begin
               Inc (iCount);
            end;
         end;
      end;                                                                                                                                                  
   end;
   Result := iCount;
end;

procedure TMonsterList.RegenByName (aName : String);
var
   i : Integer;
   Monster : TMonster;
begin
   for i := 0 to DataList.Count - 1 do begin
      Monster := DataList.Items [i];
      if StrPas (@Monster.BasicData.Name) = aName then begin
         if Monster.FboRegisted = false then begin
            Monster.Regen;
         end;
      end;
   end;
end;

function TMonsterList.AddMonster (aMonsterName : string; ax, ay, aw, aScript : integer; aMemberStr : String) : TMonster;
var
   Monster, Member : TMonster;
   str, MemberName, MemberCount : String;
   i, Count : Integer;
   AttackSkill, tmpAttackSkill : TAttackSkill;
begin
   Result := nil;

   Monster := TMonster.Create;
   if Monster <> nil then begin
      Monster.SetManagerClass (Manager);
      Monster.SetScript (aScript);
      Monster.Initial (aMonsterName, ax, ay, aw);
      try
         DataList.Add (Monster);
      except
      end;
      if aMemberStr <> '' then begin
         AttackSkill := Monster.GetAttackSkill;
         AttackSkill.SetGroupSkill;
         str := aMemberStr;
         while str <> '' do begin
            str := GetValidStr3 (str, MemberName, ':');
            if MemberName = '' then break;
            str := GetValidStr3 (str, MemberCount, ':');
            if MemberCount = '' then break;
            Count := _StrToInt (MemberCount);

            for i := 0 to Count - 1 do begin
               Member := TMonster.Create;
               if Member <> nil then begin
                  Member.SetManagerClass (Manager);
                  Member.SetScript (aScript);
                  Member.Initial (MemberName, ax, ay, aw);
                  DataList.Add (Member);
                  AttackSkill.AddGroup (Member);
                  tmpAttackSkill := Member.GetAttackSkill;
                  if tmpAttackSkill <> nil then
                     tmpAttackSkill.SetBoss (Monster);
               end;
            end;
         end;
      end;
      Result := Monster;
   end;
end;

function TMonsterList.CopyMonster (aBasicData : TBasicData; aAttackSkill : TAttackSkill) : TMonster;
var
   Monster : TMonster;
begin
   Result := nil;
   
   Monster := TMonster.Create;
   if Monster <> nil then begin
      Monster.SetManagerClass (Manager);
      Monster.SetAttackSkill (aAttackSkill);
      Monster.FboCopy := true;
      Monster.Initial (StrPas (@aBasicData.Name), aBasicData.x, aBasicData.y, 4);
      if Monster.Start = false then begin
         Monster.Free;
         exit;
      end;
      DataList.Add (Monster);

      Result := Monster;
   end;
end;

function TMonsterList.FindMonster (aMonsterName : String) : Integer;
var
   i, iCount : Integer;
   Monster : TMonster;
begin
   iCount := 0;
   for i := 0 to DataList.Count - 1 do begin
      Monster := DataList.Items [i];
      if Monster.MonsterName = aMonsterName then begin
         Inc (iCount);
      end;
   end;

   Result := iCount;
end;

function TMonsterList.DeleteMonster (aMonsterName : String) : Boolean;
var
   i, iCount : Integer;
   Monster : TMonster;
begin
   Result := false;

   iCount := 0;
   for i := 0 to DataList.Count - 1 do begin
      Monster := DataList.Items [i];
      if Monster.MonsterName = aMonsterName then begin
         Monster.FboAllowDelete := true;
         Inc (iCount);
      end;
   end;
   if iCount > 0 then Result := true;
end;

function TMonsterList.CallMonster (aMonsterName: string; ax, ay, aw: integer; aName : String) : TMonster;
var
   Monster : TMonster;
   AttackSkill : TAttackSkill;
begin
   Result := nil;

   Monster := TMonster.Create;
   if Monster <> nil then begin
      Monster.SetManagerClass (Manager);
      Monster.Initial (aMonsterName, ax, ay, aw);
      if Monster.Start = false then begin
         Monster.Free;
         exit;
      end;
      AttackSkill := Monster.GetAttackSkill;
      if AttackSkill <> nil then begin
         if aName <> '' then begin
            AttackSkill.SetDeadAttackName (aName);
         end;
      end;
      DataList.Add (Monster);

      Result := Monster;
   end;
end;

function TMonsterList.CallMonster (aMonsterName: string; ax, ay, aw, aScript: integer; aboRegen : Boolean) : TMonster;
var
   Monster : TMonster;
   AttackSkill : TAttackSkill;
begin
   Result := nil;

   Monster := TMonster.Create;
   if Monster <> nil then begin
      Monster.SetManagerClass (Manager);
      Monster.SetScript(aScript);
      Monster.boRegen := aboRegen; 
      Monster.Initial (aMonsterName, ax, ay, aw);
      if Monster.Start = false then begin
         Monster.Free;
         exit;
      end;
      AttackSkill := Monster.GetAttackSkill;
      DataList.Add (Monster);

      Result := Monster;
   end;
end;

function TMonsterList.GetMonsterByID(aID : Integer) : TMonster;
var
   i : Integer;
   Monster : TMonster;
begin
   Result := nil;
   for i := 0 to DataList.Count - 1 do begin
      Monster := DataList.Items [i];
      if Monster.BasicData.ID = aID then begin
         Result := Monster;
         exit;
      end;
   end;
end;

function TMonsterList.GetMonsterByName(aName : String; aboAllowDie : Boolean) : TMonster;
var
   i : Integer;
   Monster : TMonster;
begin
   Result := nil;
   for i := 0 to DataList.Count - 1 do begin
      Monster := DataList.Items [i];
      if Monster.MonsterName = aName then begin
         if aboAllowDie = true then begin
            Result := Monster;
            exit;
         end else begin
            if Monster.BasicData.Feature.rfeaturestate = wfs_normal then begin
               Result := Monster;
               exit;
            end;
         end;
      end;
   end;
end;

procedure TMonsterList.boIceAllMonsterByName (aName : String; aboIce : Boolean);
var
   i : Integer;
   Monster : TMonster;
begin
   for i := 0 to DataList.Count - 1 do begin
      Monster := DataList.Items [i];
      if Monster.MonsterName = aName then begin
         Monster.FboIce := aboIce;
      end;
   end;
end;

procedure TMonsterList.boHitAllMonsterByName (aName : String; aboHit : Boolean);
var
   i : Integer;
   Monster : TMonster;
begin
   for i := 0 to DataList.Count - 1 do begin
      Monster := DataList.Items [i];
      if Monster.MonsterName = aName then begin
         Monster.FboHit := aboHit;
      end;
   end;
end;

procedure TMonsterList.ComeOn (aName : String; X, Y : Word);
var
   i : Integer;
   Monster : TMonster;
begin
   for i := 0 to DataList.Count - 1 do begin
      Monster := DataList.Items [i];
      if StrPas (@Monster.BasicData.Name) = aName then begin
         if Monster.FboAllowDelete = true then continue;
         if Monster.AttackSkill = nil then continue;
         Monster.AttackSkill.SetSaveIDandPos (0, X, Y, los_none);
         Monster.LifeObjectState := los_move;
      end;
   end;
end;

function TMonsterList.MakeMonster (aMonsterName : String; ax, ay, aw, aScript : Integer; aboRegen : Boolean) : TMonster;
var
   Monster : TMonster;
begin
   Result := nil;

   Monster := TMonster.Create;
   if Monster <> nil then begin
      Monster.SetManagerClass (Manager);
      Monster.SetScript (aScript);
      Monster.Initial (aMonsterName, ax, ay, aw);
      Monster.boRegen := aboRegen;
      DataList.Add (Monster);

      Result := Monster;
   end;
end;

procedure TMonsterList.MakeCopyMonster (aMonsterName : String; aX, aY, aW, aScript, aCopyCount : Integer; aboRegen : Boolean);
var
   Monster : TMonster;
begin
   Monster := TMonster.Create;
   if Monster <> nil then begin
      Monster.SetManagerClass (Manager);
      Monster.boRegen := aboRegen;
      Monster.SetScript (aScript);
      Monster.Initial (aMonsterName, ax, ay, aw);
      DataList.Add (Monster);

      Monster.CopyMonster (aCopyCount); 
   end;
end;

end.
