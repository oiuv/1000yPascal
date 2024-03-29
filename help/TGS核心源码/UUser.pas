unit UUser;

interface

uses
  Windows, SysUtils, Classes, ScktComp, WinSock, aDefType, svclass, deftype,
  aUtil32, basicobj, fieldmsg, AnsImg2, mapunit, subutil, uanstick, uSendcls,
  uUserSub, aiunit, uLetter, uManager, AnsStringCls, uConnect, uBuffer,
  uItemLog, uKeyClass, mmSystem, uLevelExp, uimage ;

const
   InputStringState_None          = 0;
   InputStringState_AddExchange   = 1;
   InputStringState_Search        = 2;

   RefusedMailLimit               = 5; // 거부된 쪽지의 최대수 (쪽지기능을 사용할 수 없게됨)
   MailSenderLimit                = 5; // 보낸 사람을 기억하는 최대치

   PICK_SPEED                     = 140;

   POWERLEVEL_EFFECT_NUM          = 2000; //2002-11-06
   SHIELD_EFFECT_NUM              = 3000;
   SAFE_SETTING_DELAY             = 360000;  //1시간
   //SAFE_SETTING_DELAY             = 500;   //5초
   EFFECT_DELAY_UNIT              = 20;

   CHAR_TYPE_NONE                = 0;
   CHAR_TYPE_HIGH_GRADE          = 1;  // 고수서버
   CHAR_TYPE_LOW_GRADE           = 2;  // 하수서버
   CHAR_TYPE_WRITER              = 3;  // 기자단

   WINDOFHAND_CONTINOUS_NUM      = 1;  //장풍 연타 회수

   STEALLIFE_EFFECT_NUM          = 7781;
   STEALENERGY_EFFECT_NUM        = 7791;

type
  //Author:Steven Date: 2004-12-15 16:27:38
  //Note:
  TGameTeam = class;

  //=======================================

   TMouseEventData = record
     rtick : Integer;
     revent: array [0..10-1] of integer;
   end;
   PTMouseEventData = ^TMouseEventData;

   // 매크로 체크를 담담하는 클래스
   TMacroChecker = class
   private
      nSaveCount : Integer; // 마우스이벤트 데이타 보관 갯수
      DataList : TList;

      nReceivedCount : Integer; // 추가된 마우스 이벤트 데이타의 카운트

      function CheckNone : Boolean; // 정말로 아무일도 하지 않는 사람
      function CheckCase1 : Boolean; // MouseMove만 0 < x < 20 인 사람
      function CheckCase2 : Boolean; // 30분동안 수치가 +-10%이내인 사람
      function CheckCase3 : Boolean; // 너무 자주 보내는 사람
   public
      constructor Create(anSaveCount : Integer);
      destructor Destroy; override;

      procedure Clear;

      procedure SaveMacroCase(aName : String; nCase : Integer);
      procedure AddMouseEvent(pMouseEvent : PTCMouseEvent; anTick : Integer);
      function Check(aName : String) : Boolean;
   end;

   TMagicStep = (ms_none, ms_wait, ms_end);

   TUserObject = class (TBasicObject)
   private
     Connector : TConnector;

//     boFalseVersion : Boolean;
     boShiftAttack : Boolean;
     TargetId : integer;
     PrevTargetID : Integer;
     LifeObjectState : TLifeObjectState;

     RopeTarget : integer;
     RopeTick : integer;
     RopeOldX, RopeOldy : word;

     ShootBowCount : integer;
     ShootWindCount : Integer;
     MagicStep : TMagicStep;
     FreezeTick : integer;
     LockDownTick : integer;
     DiedTick : integer;
     HitedTick : integer;
     SpecialMagicTick : integer;
     SpecialMagicContinueTick : Integer;
     LifeData : TLifeData;
     AddAttribData : TRealAddAttribData;
     // add by Orber at 2004-09-16 14:39
     MissionStartTick:single;

     ShowPowerLevelTick : integer;
     ShortCut : array [0..8 - 1] of Byte;

     function   AllowCommand (CurTick: integer): Boolean;
     procedure  SetCurrentShield (aValue : integer);
     function   GetCurrentShield : Integer;
     function   GetRegenDec : Integer;
     function   GetDecValue : Integer;
     function   GetPowerLevel : Integer;
     function   GetBoAttacking: Boolean;
   protected
     boCanSay, boCanMove, boCanAttack, boCanAttacked : Boolean;
     LockDownDecLife : Integer;

     LastGainExp : integer;

     DisplayValue : Word;
     DisplayTick : Integer;

     AttribClass : TAttribClass;
     WearItemClass : TWearItemClass;
     HaveItemClass : THaveItemClass;
     HaveMagicClass : THaveMagicClass;
     AttackedMagicClass : TAttackedMagicClass;
     HaveJobClass : THaveJobClass;
     HaveMarketClass : THaveMarketClass;
     ShowWindowClass : TShowWindowClass;
     UserQuestClass : TUserQuestClass;

     function  FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
     procedure Initial (aName: string);
     procedure StartProcess; override;
     procedure EndProcess; override;
   public
     Name, Password, AliasPassWord, IP : String;
     PreLover : String;
     GuildServerID : Integer;
     GuildName : String;
     GuildGrade : String;
     GroupKey : Word;
     boSafe : Boolean;
     SafeSettingTick : Integer;
     SendClass : TSendClass;
     SayTick : integer;
     SearchTick : integer;
     DelayPwdTick : Integer;

     Vir_Move : TSMove;

     _3HitCount : integer;
     _3HitTick : Integer;
     SpecialAttackCount : Integer;
     
//     boPolymorph : Boolean;
//     Mon_rAnimate : Integer;
//     Mon_rShape : Integer;

     constructor Create;
     destructor Destroy; override;
     procedure SetTargetId (aid: integer);
     procedure CommandChangeCharState (aFeatureState: TFeatureState);
     procedure ShowEffect (aEffectNumber : Word; aEffectKind : TLightEffectKind);
     procedure ShowEffect2 (aEffectNumber : word; aEffectKind : TLightEffectKind; aDelay : integer);     
     function  CommandSpell (aSpellType : Byte; aDecPercent : Integer) : Integer;
     function CommandSpell2 (var aSubData : TSubData) : integer;
     function  CommandHited (aattacker: integer; aHitData: THitData; apercent: integer): integer;
     function  CommandHit (CurTick: integer; boSend: Boolean): Boolean;
     function  CommandPick (CurTick: integer): Boolean;     
     procedure CommandBowing (CurTick: integer; atid: integer; atx, aty: word; boSend: Boolean);
     //궁-투로 맞을 경우에 대한 처리를 위해 같은 근본의 함수를 세분화 한다.
     function  CommandBowed (aattacker: integer; aHitData: THitData; apercent: integer): integer;
     //procedure CommandWindOfHand (CurTick: Integer; atid: integer; atx, aty: word; astep: byte);
     procedure CommandWindOfHand_new (CurTick: Integer; atid: integer; atx, aty: word);
     procedure CommandAttackedMagic (var aWindOfHandData : TWindOfHandData);
     procedure CommandCriticalAttack (CurTick: integer; atid: integer; atx, aty: word);
     //2003-10
     function CommandPassed (aattacker: integer; aHitData: THitData; apercent: integer): integer;
     function CommandCriticalAttacked (var SenderInfo : TBasicData;var aSubData : TSubData): integer;
     
     procedure CommandTurn (adir: word; boSend: Boolean);
     procedure CommandDecLifePercent (aDec : Integer);
     function GetCurrentKeepRecovery: Integer;
     procedure Update (CurTick: integer); override;

     procedure ConditionUpdate (CurTick: integer);
     procedure SetCondition (estat: byte; aEffectNumber, aEndTick : integer);
     procedure SetActionState (aState : TActionState);
     procedure CancelSpecialMagic;

     function GetLifeObjectState : TLifeObjectState;
     function GetWeaponItemAttrib : integer;
     function AddMagic  (aMagicData: PTMagicData): Boolean;
     function FindHaveMagicByName (aMagicName : String) : Integer;
     function DeleteItem (aItemData: PTItemData): Boolean;
     function AddItem (aItemData : TItemData): Boolean;     
     function FindItem (aItemData : PTItemData): Boolean;
     function FindItemByName (aName : String) : Boolean;
     //2002-08-10 giltae
     function FindWearItembyAttrib ( aAttrib : Integer) : Boolean;
     function FindHaveItemByKey ( aKey : integer) : PTItemData;
     //------------------------

     // add by Orber at 2004-10-09 11:38
     function GetWeaponItemName : String;
     //------------------------

     procedure DeleteAllItembyName (aName : String);   // 갯수와 상관없이 가지고있는 해당아이템 모두 지운다  03.04.08 saset
     procedure SetLifeData;

     function GetMaxStatePointByGrade: integer; //2003-10     
   public
     function AllowLifeObjectState :Boolean;
     function GetAge : Integer;
     function SetPassword (aStr : String) : String;
     function FreePassword (aStr : String) : String;
     function GetPassword : String;
     function GetAttribCurVirtue : Integer;
     function GetCurrentWindow : TSpecialWindowKind;
     function GetboMarketing : Boolean;

     function GetCurAttackMagic : PTMagicData;
     function GetCurSpecialMagic: PTMagicData;
     function GetCurBreathngMagic : PTMagicData;
     function GetCurRunningMagic : PTMagicData;
     function GetCurProtectingMagic : PTMagicData;
     function GetCurEctMagic : PTMagicData;
     function GetCurPowerLevel : Integer;
     procedure SetCurSpecialMagic (amagic : PTMagicData);
     procedure SetCurPowerLevel (aPowerLevel : Integer);

     function CheckHaveQuestItem (aQuestNum: integer) : boolean;
     procedure ChangeCurPowerLevel (aLevel : Integer);

     //Author:Steven Date: 2005-01-19 12:13:13
     //Note:
     procedure SetNameColor(aIndex: Word);
     
     property CurShield : Integer read GetCurrentShield write SetCurrentShield;
     property RegenDec : Integer read GetRegenDec;
     property DecValue : Integer read GetDecValue;
     property PowerLevel :Integer read GetPowerLevel;
     property CurPowerLevel : Integer read GetCurPowerLevel write SetCurPowerLevel;
     
     property pCurAttackMagic : PTMagicData read GetCurAttackMagic;
     property pCurBreathngMagic: PTMagicData read GetCurBreathngMagic;
     property pCurRunningMagic: PTMagicData read GetCurRunningMagic;
     property pCurProtectingMagic: PTMagicData read GetCurProtectingMagic;
     property pCurEctMagic: PTMagicData read GetCurEctMagic;
     property pCurSpecialMagic : PTMagicData read GetCurSpecialMagic write SetCurSpecialMagic;

     property MaxLimitStatePoint: integer read GetMaxStatePointByGrade;
     property boAttack : boolean read GetBoAttacking;
     property UserLifeData : TLifeData read LifeData;
     property UserAddAttribData : TRealAddAttribData read AddAttribData;
   end;

   TUser = class (TUserObject)
   private
     FboNewServer : Boolean;

     boTv : Boolean;
     boException : Boolean;

     InputStringState : integer;

     CM_MessageTick : array [0..255] of integer;
     PrisonTick : Integer;
     SaveTick : integer;
     FalseTick : integer;
     FPosMoveX, FPosMoveY: integer;

     MailBox : TList;
     MailTick : Integer;
     RefuseReceiver : TStringList;
     MailSender : TStringList;
     boLetterCheck : Boolean;
     boSearchEnable : Boolean;
     FboAllyGuild : Boolean;
     FboExchange : Boolean;

     MacroChecker : TMacroChecker;

     NetStateID : Integer;
     NetStateTick : Integer;
     NetStateQuestion : array[0..15] of byte;
     NetStateReturnTick : Integer;
     LastPacketTick : Integer;
     SaveNetState : TCNetState;

     FIceTick, FIceInterval : Integer;
     FLockDownDecLifeTick : Integer;

     LastCM_Message : Integer;
     LastCM_MessageTick : Integer;
     LastCM_MessageSum : Integer;
     LastCM_MessageCount : Integer;
     MoveMsgCount : Integer;

    //Author:Steven Date: 2004-12-08 15:01:07
    //Note:
    InviteKey: string;
    //=======================================



     // add by Orber at 2004-12-07 09:46:09
     aArenaType : Byte;
     aEventRecord : Array [0..20 - 1] of Byte;

     // procedure SendData (cnt:integer; pb:pbyte);

     procedure LoadUserData (aName: string);
     procedure SaveUserData (aName: string);

     // add by Orber at 2004-12-07 10:43:14
     procedure ExitArena;
     procedure MessageProcess (var code: TWordComData);
     // change by minds 050919
     procedure UserSay(const astr: string);
     //procedure UserSay (astr: string);
     procedure DragProcess (var code: TWordComData);
     procedure InputStringProcess (var code: TWordComData);
   protected
     function  FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
   public
     EventTeam : String;    // event 031002 가을운동회 saset
     inZhuang : Boolean;
     SysopObj, UserObj : TBasicObject;
     MarketUserID : Integer;
     TeamEnable : Boolean;
     MarryEnable : Boolean;
     GuildEnable : Boolean;
     ParamStr : array [0..10 - 1] of String;

     UseSkillKind : Integer;
     SkillUsedTick : Integer;
     SkillUsedMaxTick : Integer;
     ChangeLifeTick : Integer;
     FillTick : Integer;

     CharType : Byte;           // event    1 : 고수서버 2 : 하수서버 3 : 기자단

     SysopScope : integer;
  // add by Orber at 2004-12-21 18:10:36
     Lover     : string;
     aArenaBody : String;
     aArenaIndex : Word;

  // add by Orber at 2005-01-12 00:23:31
     PreGuildMoneyApplyer : String;
  // add by Orber at 2005-02-28 16:07:44
     aSetGuildStoneName : String[20];
     InviteGuildMaster : String;
     SpeedShoes : Boolean;
     BattleGuildName : String;


    //Author:Steven Date: 2004-12-08 15:01:07
    //Note:
    Team: TGameTeam; //Pointer;숑鬼櫛북昑
    //=======================================
    
     constructor Create;
     destructor Destroy; override;
     function  InitialLayer (aCharName: String) : Boolean;
     procedure FinalLayer;

     procedure Initial (aName: string);
     procedure StartProcess; override;
     procedure EndProcess; override;
     procedure Update (CurTick: integer); override;

     function  FieldProc2 (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;

     procedure AddRefusedUser (aName : String);
     procedure DelRefusedUser (aName : String);
     procedure AddMailSender (aName : String);
     function CheckSenderList (aName : String) : Boolean;

     // add by Orber at 2004-12-07 10:45:07
     function CheckArena : Byte;
     procedure JoinArena (pArenaType : Byte; pArenaIndex :Word);
     procedure Marry (aUser:String; aAnswer:Byte);

     procedure SetPosition (x, y : Integer);
     procedure SetPositionBS (ex, ey : Integer);

     function Check8Around (adir, aX, aY : Word) : Boolean;
     function ShowItemLogWindow : String;
     procedure MarryWindow (aHelpText:String);
     procedure UnMarryWindow (aHelpText:String);
     procedure ShowUnMarry(aHelpText:String);
     procedure MarryAnswerWindow (aName,aHelpText:String);
     procedure GuildAnswerWindow (aName,aHelpText:String);
     // add by Orber at 2005-02-04 12:46:53
     procedure ArenaWindow (aHelpText:String);

     // add by Orber at 2005-01-12 00:24:27
     procedure GuildActiveBank;
     procedure GuildBuyMoneyChip;
     function GuildApplyMoney (aUser:String;aMoneyChip:integer) : Boolean;

     procedure TradeWindow (aTitle, aCaption : String; aImageNum, aImageValue : Word; aItemStr : String; aKind : Byte);
     procedure SaleWindow (aBasicObject : TBasicObject; aTitle, aCaption : String; aImageNum, aImageValue : Word; aItemStr : String; aKind : Byte);
     procedure GetExchangeData (var aExchangeData : TExchangeData);
     procedure SetExchangeData (aExchangeData : TExchangeData);
     function isCheckExchangeData : Boolean;
     function  AddableExChangeData (pex : PTExChangedata): Boolean;
     procedure AddExChangeData (var aSenderInfo : TBasicData; pex : PTExChangedata; aSenderIP : String);
     procedure DelExChangeData (pex : PTExChangedata);
     function FindExChangeData (pex : PTExChangedata) : Boolean;     
     function  GetQuestStr : String;
     procedure CopyMarketItem (var aMarketDataList : TList);
     function  SellItembyUser (aMarketList : TList; aName : String) : Boolean; overload;
     function  SellItembyUser (aItemData : TItemData; aName : String) : Boolean; overload;     

     procedure SetCurrentWindow (aSWK : TSpecialWindowKind; aSST : TSpecialSubType);

     function MovingStatus : Boolean;
     procedure UdpSendMouseEvent (aInfoStr: String);
     procedure RemoveItemKind(aKind : Integer);
//     function Find3daysChar : Boolean;   // 노협객이벤트
  // add by Orber at 2004-12-27 10:24:55
     function GetUserID : String;
     procedure SetGroupColor (aIndex : Word);
     procedure SetActionState (aActionState : TActionState);
     function SGetItemCount(aItem:TItemData;ItemCount:Integer): Boolean;
     function SGetAge : Integer; override;
     function SGetMaxLife : Integer; override;
     function SGetMaxInPower : Integer; override;
     function SGetMaxOutPower : Integer; override;
     function SGetMaxMagic : Integer; override;
     function SGetLife : Integer; override;
     function SGetHeadLife : Integer; override;
     function SGetArmLife : Integer; override;
     function SGetLegLife : Integer; override;
     function SGetPower : Integer; override;
     function SGetInPower : Integer; override;
     function SGetOutPower : Integer; override;
     function SGetMagic : Integer; override;
     function SGetVirtue : Integer; override;     
     function SGetTalent : Integer; override;     
     function SGetUseAttackMagic : String; override;
     function SGetUseAttackSkillLevel : Integer; override;
     function SGetUseMagicSkillLevel (aKind : Word) : Integer; override;
     function SGetMagicSkillLevel (aName : String) : Integer; override;    
     function SGetUseProtectMagic : String; override;
     function SGetCompleteQuest : Integer; override;
     function SGetCurrentQuest : Integer; override;
     function SGetQuestStr : String; override;
     function SGetFirstQuest : Integer; override;
     function SGetItemExistence (aItem : String; aOption : Integer) : String; override;
     function SGetItemExistenceByKind (aKind, aOption : Integer) : String; override;
     function SCheckEnoughSpace (aCount : Integer): String; override;
     function SGetHaveGradeQuestItem: String; override; //2003-10
     function SGetJobKind : Byte; override;
     function SGetJobGrade : Byte; override;
     function SGetJobTalent : Integer; override;
     // function SGetToolName : String; override;
     function SGetWearItemCurDurability (aKey : Integer) : Integer; override;
     function SGetWearItemMaxDurability (aKey : Integer) : Integer; override;
     function SGetWearItemName (aKey : Integer) : String; override;
     function SGetMagicCountBySkill (aType, aSKill : Integer) : String; override;
     function SRepairItem (aKey, aKind : Integer) : Integer; override;
     function SDestroyItembyKind (aKey, aKind : Integer) : Integer; override;     
     function SFindItemCount (aItemName : String) : String; override;
     function SCheckPowerWearItem : Integer; override;
     function SCheckCurUseMagic (aType : Byte) : String; override;
     function SCheckCurUseMagicByGrade (aType,aGrade,aMagicType : Byte) : String; override;     
     function SGetCurPowerLevelName : String; override;
     function SGetCurPowerLevel : Integer; override;     
     function SGetCurDuraWaterCase : Integer; override;
     function SGetPossibleGrade (atype,agrade:byte) : String; override;
     function SCheckMagic (aMagicClass, aMagicType : Integer; aMagicName : String) : String; override;
     function SCheckAttribItem (aAttrib : Integer) : String; override;
     function SConditionBestAttackMagic (aMagicName : String) : String; override;
     function SGetMarryClothes : String; override;
     function SGetZhuangTicketPrice : String; override;
     function SGetZhuangInto:String; override;
     function SGetMarryInfo:String; override;
     function SGetAskConquer : String; override;
     // add by Orber at 2004-09-16 14:13
     function SStartMissionTime:single;  override;
     function SGetPassMissionTime:single;  override;
     function SGetIntoArenaGame(aArenaKey : Word):Integer; override;
     function SStartArenaGame:Integer; override;
      // add by Orber at 2005-02-03 11:33:12
     function SAddArenaMember(aMasterName : String):String; override;
     function SGetEvent(EventCode:integer):String; override;
     function SGetSetEvent(EventCode:integer):String; override;
     function SCheckPickup:String; override;
     function SGetParty:String; override;
     function SSetParty:String; override;


     //Author:Steven Date: 2005-02-02 13:05:07
     //Note:꽃섞세콘
      function SGetExtJobLevel: Integer; override;
      function SSetExtJobExp(aExp: Integer): Integer; override;
      function SGetExtJobExp: Integer; override;
      function SGetExtJobKind: Byte; override;
      procedure SSetExtJobKind(AValue: Byte); override;
      function SGetExtJobGrade: String;
     //=====================================

     procedure SShowWindow (aCommander : TBasicObject; aFileName : String; aKind : Byte); override;
     procedure SShowWindow2 (aCommander : TBasicObject; aStr : String; aKind : Byte); override;
     procedure SShowEffect (aEffectNumber : Integer; aEffectKind : Integer); override;

     procedure SLogItemWindow (aCommander : TBasicObject); override;
     procedure SGuildItemWindow (aCommander : TBasicObject); override;
     procedure SPutMagicItem (aWeapon, aMopName : String; aRace : Byte); override;
     procedure SGetItem (aItem : String); override;
     procedure SGetItem2 (aItem : String); override;
     procedure SGetAllItem (aItem : String); override;
     procedure SDeleteQuestItem; override;
     procedure SChangeCompleteQuest (aQuest : Integer); override;
     procedure SChangeCurrentQuest (aQuest : Integer); override;
     procedure SChangeQuestStr (aStr : String); override;
     procedure SChangeFirstQuest (aQuest : Integer); override;
     procedure SAddAddableStatePoint (aPoint : Integer); override;
     procedure STotalAddableStatePoint (aPoint : Integer); override;
     procedure SSendChatMessage (aStr : String; aColor : Integer); override;
     procedure SCommandIce (aInterval : Integer); override;



     procedure SSetJobKind (aKind : Byte); override;
     procedure SSetVirtueman; override;
     procedure SSmeltItem (aMakeName : String); override;   // 아이템 제련.. ;;;
     procedure SSmeltItem2 (aMakeName : String); override;   // 아이템 제련한거 교환.. ;;;
     procedure SSendItemMoveInfo (aStr : String); override;
     procedure SChangeCurDuraByName (aName : String; aCurDura : Integer); override;     
     procedure SDecreasePrisonTime(aTime: Integer);override;
     procedure SUseMagicGradeup (atype,tg : byte);override;

     property LetterCheck : Boolean read boLetterCheck;
     property Exception : Boolean read boException write boException;
     property boNewServer : Boolean read FboNewServer write FboNewServer;
     property PosMoveX : Integer read FPosMoveX write FPosMoveX;
     property PosMoveY : Integer read FPosMoveY write FPosMoveY;
     property boAllyGuild : Boolean read FboAllyGuild;
     property boExchange : Boolean read FboExchange;
    //Author:Steven Date: 2004-12-12 14:05:35
    //Note:
  public
    procedure CheckAndFreeTeam;
    procedure AcceptInvitation(ApInvitation: PTSInvitation);
    //=======================================
   end;

   TUserList = class
   private
     ExceptCount : integer;
     CurProcessPos : integer;
     UserProcessCount : Integer;

     // AnsList : TAnsList;
     NameKey : TStringKeyClass;
     DataList : TList;

     // TvList : TList;

     function  GetCount: integer;
   public
     constructor Create (cnt: integer);
     destructor  Destroy; override;
     function    InitialLayer (aCharName: string; aConnector : TConnector) : Boolean;
     procedure   FinalLayer (aConnector : TConnector);
     procedure   StartChar (aCharname: string);

     function    GetUserPointer (const aCharName: string): TUser;
     function    GetUserPointerById (aId: LongInt): TUser;

     procedure   GuildSay (const aGuildName, astr: string);
     procedure   AllyGuildSay (const aGuildName, astr: string);
     function    GetGuildUserInfo (const aGuildName: string): string;

     procedure   SayByServerID (aServerID : Integer; const aStr: String; aColor : Byte);
     procedure   MoveByServerID (aServerID : Integer; aTargetID, aTargetX, aTargetY : Integer);
     procedure   SetActionStateByServerID (aServerID : Integer; aActionState : TActionState);

     procedure   SendSideMessageByServerID (aServerID : Integer; aStr : String);
     procedure   SendSoundMessage (aSoundNum : String; aMapID : Integer);
     procedure   SendSoundBasebyServerID (aSoundname: string; aRoopCount: integer; aMapID : Integer);
     procedure   SendNoticeMessage (const aStr: String; aColor : Integer);
     procedure   SendTestMessage (const aStr: String; F1, F2, F3, B1, B2, B3 : Integer);
     procedure   SendCenterMessage (const aStr : String);
     // add by Orber at 2005-01-12 04:31:10
     procedure   SendGuildInfo (GuildInfo : TSGuildListInfo);
     procedure   SendGuildEnergy(aGuildName : String; aGuildEnergyLevel : Byte);
     procedure   SendShowDynamicObject(SenderInfo : TBasicData);
     procedure   SendHideDynamicObject(SenderInfo : TBasicData);



     procedure   SendCenterMessagebyMapID (const aStr : String; aMapID : Integer);
     procedure   SendTopMessage (aStr : String);
     procedure   SendTopLetterMessage (aName, aStr1, aStr2 : String);
     procedure   SendScreenEffectToAll (aEffectNum, aDelay: integer);
     procedure   SendBattleBar (aLeftName, aRightName : String; aLeftWin, aRightWin : Byte; aLeftPercent, aRightPercent, aBattleType : Integer);
     procedure   SendBattleBarbyMapID (aLeftName, aRightName : String; aLeftWin, aRightWin : Byte; aLeftPercent, aRightPercent, aBattleType : Integer; aMapID : Integer);
     // procedure   SendGradeShoutMessage (astr: string; aColor: integer);
     function    GetUserList: string;
     procedure   SendRaining (aRain : TSRainning);

     // function    FieldProc2 (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;

     procedure   Update (CurTick: integer);
     function    FieldProc (aName : String; Msg: Word; var SenderInfo: TBasicData; var aSubData: TSubData) : Integer;

     procedure   SaveUserInfo (aFileName : String);
     // procedure   SendSoundEffect (aManager : TManager; aSoundEffect : String);

     function    GetUserCountByManager (aID : Integer) : Integer;
     function    GetUserForPK (aManager : TManager) : TBasicObject;
     procedure   AddItemByEventTeam (aServerID : Integer; aTeam, aItemName : String);
     procedure   AddItemAllUserByMapID (aServerID : Integer; aMopName, aItemName : String);
     procedure   AddItemUserByGruopAndMapID(aServerID : Integer; aGroupKey : Integer; aMopName: String ; aItemName : String);
     procedure   DeleteItemAllUserbyName (aServerID : Integer; aItemName : String);
     function    GetRemainGuildUserbyServerID (aServerID : Integer; aGuildName : String) : Integer;

  // add by Orber at 2005-02-01 10:41:15
     procedure   KickMemberFromZhuang;

     property    Count : integer read GetCount;
   end;

  //Author:Steven Date: 2004-12-08 14:55:00
  //Note:
  TGameTeam = class
  private
    FMemberList: TStrings;
    FBuildUser: TUser;
    FMemberCount: Integer;
    function GetMemberCount: Integer;
    function GetBuildUser: TUser;
    procedure AddMember(AMember: TUser);
    procedure DeleteMember(AMemberName: string); overload;
    procedure DeleteMember(AMemberIndex: Integer); overload;
    procedure ClearMember;
  public
    //눼쉔뚤蹶
    constructor Create(AMember: TUser);
    destructor Destroy; override;

    //莉쉔뚠橋，썩�‰踏繇г璞傭撻켁군砥�痰쓰檄렘랬눼쉔뚤蹶，莉뚠썩�↙陶�姦렴
    class procedure TeamBuild(AMember: TUser);
    procedure TeamDisband;

    //꿴冷뚠堂
    function FindMember(AMemberName: string): TUser; overload;
    function FindMember(AMemberIndex: Integer): TUser; overload;
    function FindMemberIndex(AMemberName: string): Integer;

    function GetMemberPosStr(AName: String): String;
    //랙箇句口
    procedure TellEveryOne(ASay: string; AColor: Byte); //뚠堂句口
    procedure InsideInfomation(AInfo: string);

    //속흙莉뚠，잼역莉뚠，璟놔莉뚠
    procedure JoinInTeam(AMember: TUser); overload;
    //procedure LeaveTeam(AMember: TUser); overload;
    procedure LeaveTeam(AMemberName: string); overload;
    //procedure LeaveTeam(AMemberIndex: Integer); overload;
    procedure BootOutTeam(ABuildUser: TUser; AMemberName: string); overload;
    procedure BootOutTeam(AMemberIndex: Integer); overload;

    //롸權廬폭令
    procedure ShareExtraExp(AExp: Integer; ServerID : Integer);
    //쇱꿎角뤠콘묑샌
    function CheckEnableHit(ATargetId: Integer): Boolean;

    //橄昑
    property MemberCount: Integer read GetMemberCount;  //뚠逃훙鑒
    property BuildUser: TUser read GetBuildUser;        //쉔접莉뚠돨User

  end;

var
  UserList : TUserList;
  boCheckSpeed : Boolean = true;   // true로 바꿔야됨
  VirtueMulti : Integer = 1;
  ExpMulti : Integer = 1;
  boMoveAllItem : Boolean = true;
  boMoveItem : Boolean = true;

implementation

uses
   uNpc, uMonster, uGuild, uGuildSub, SvMain, FSockets, FGate, uGConnect, uDoorGen,
   uScriptManager, uCharCheck, uUtil, uCookie , uArena , uZhuang;

// add by minds 050921
var
  UserSayCommand: TStringList = nil;

const
  SAYCOMMAND_SETTEAM           =  0;
  SAYCOMMAND_ALLOWTRADE        =  1;
  SAYCOMMAND_DENYTRADE         =  2;
  SAYCOMMAND_FIRECRACKER       =  3;
  SAYCOMMAND_ALLOWPARTY        =  4;
  SAYCOMMAND_DENYPARTY         =  5;
  SAYCOMMAND_DENYPROPOSE       =  6;
  SAYCOMMAND_ALLOWPROPOSE      =  7;
  SAYCOMMAND_DENYGUILD         =  8;
  SAYCOMMAND_ALLOWGUILD        =  9;
  SAYCOMMAND_SETTICKETPRICE    = 10;
  SAYCOMMAND_SAVEMONEY         = 11;
  SAYCOMMAND_MAKEITEM          = 12;
  SAYCOMMAND_VIEWPRISONINFO    = 13;
  SAYCOMMAND_SEARCH            = 14;
  SAYCOMMAND_SEARCHENABLE      = 15;
  SAYCOMMAND_SEARCHDISABLE     = 16;
  SAYCOMMAND_DELETEMAGIC       = 17;
  SAYCOMMAND_MESSENGER         = 18;
  SAYCOMMAND_ALLOWALLY         = 19;
  SAYCOMMAND_DENYALLY          = 20;
  SAYCOMMAND_ALLOWMESSENGER    = 21;
  SAYCOMMAND_DENYMESSENGER     = 22;
  SAYCOMMAND_CREATEGUILD       = 23;
  SAYCOMMAND_SETDEPOTPASSWORD  = 24;
  SAYCOMMAND_FREEDEPOTPASSWORD = 25;
  SAYCOMMAND_SETPASSWORD       = 26;
  SAYCOMMAND_FREEPASSWORD      = 27;
  SAYCOMMAND_CREATEGUILDMAGIC  = 28;
  SAYCOMMAND_CHECKPROPERTY     = 29;
  SAYCOMMAND_ENTERBATTLE       = 30;
  SAYCOMMAND_STARTBATTLE       = 31;
  SAYCOMMAND_FREETEAM          = 32;
  SAYCOMMAND_CHECKTRADE        = 33;
  SAYCOMMAND_INVITEPARTY       = 34;
  SAYCOMMAND_LEAVEPARTY        = 35;
  SAYCOMMAND_DESTROYPARTY      = 36;
  SAYCOMMAND_KICKOUTPARTY      = 37;
  SAYCOMMAND_PARTYMESSENGER    = 38;

procedure BuildSayCommand;
begin
  UserSayCommand := TStringList.Create;
  UserSayCommand.Sorted := True;

  UserSayCommand.AddObject(Conv('@�擁ⓐ킷�'),     TObject(0));
  UserSayCommand.AddObject(Conv('@역폘슥弄'),     TObject(1));
  UserSayCommand.AddObject(Conv('@밑균슥弄'),     TObject(2));
  UserSayCommand.AddObject(Conv('@푀癎'),         TObject(3));
  UserSayCommand.AddObject(Conv('@밑균莉뚠'),     TObject(4));
  UserSayCommand.AddObject(Conv('@역폘莉뚠'),     TObject(5));
  UserSayCommand.AddObject(Conv('@앳없헹삯'),     TObject(6));
  UserSayCommand.AddObject(Conv('@谿雷헹삯'),     TObject(7));
  UserSayCommand.AddObject(Conv('@앳없속흙쳔탰'), TObject(8));
  UserSayCommand.AddObject(Conv('@谿雷속흙쳔탰'), TObject(9));
  UserSayCommand.AddObject(Conv('@쏵쳔환송목'),   TObject(10));
  UserSayCommand.AddObject(Conv('@닸흙'),         TObject(11));
  UserSayCommand.AddObject(Conv('@1'),            TObject(12));
  UserSayCommand.AddObject(Conv('@혀쐐헙괩'),     TObject(13));
  UserSayCommand.AddObject(INI_SERCHSKILL,        TObject(14));
  UserSayCommand.AddObject(INI_SERCHENABLE,       TObject(15));
  UserSayCommand.AddObject(INI_SERCHUNABLE,       TObject(16));
  UserSayCommand.AddObject(Conv('@嶠묘�쓱�'),     TObject(17));
  UserSayCommand.AddObject(Conv('@笭係'),         TObject(18));
  UserSayCommand.AddObject(Conv('@역폘谿촉'),     TObject(19));
  UserSayCommand.AddObject(Conv('@밑균谿촉'),     TObject(20));
  UserSayCommand.AddObject(Conv('@쌈澗笭係'),     TObject(21));
  UserSayCommand.AddObject(Conv('@앳없笭係'),     TObject(22));
  UserSayCommand.AddObject('@CREATEGUILD',        TObject(23));
  UserSayCommand.AddObject(Conv('@�擁㉧４豁堡�'), TObject(24));
  UserSayCommand.AddObject(Conv('@썩뇜르덟쵱쯤'), TObject(25));
  UserSayCommand.AddObject(Conv('@�擁㉲堡�'),     TObject(26));
  UserSayCommand.AddObject(Conv('@썩뇜쵱쯤'),     TObject(27));
  UserSayCommand.AddObject(Conv('@�鉞允탤�嶠묘'), TObject(28));
  UserSayCommand.AddObject(Conv('@횅훰橄昑令'),   TObject(29));
  UserSayCommand.AddObject(Conv('@꽝속뚤濫'),     TObject(30));
  UserSayCommand.AddObject(Conv('@繫列濫轢역迦'), TObject(31));
  UserSayCommand.AddObject(Conv('@썩뇜考뚠'),     TObject(32));
  UserSayCommand.AddObject(Conv('@횅훰슥뻣눗'),   TObject(33));
  UserSayCommand.AddObject(Conv('@男헝'),         TObject(34));
  UserSayCommand.AddObject(Conv('@잼역뚠橋'),     TObject(35));
  UserSayCommand.AddObject(Conv('@썩�‰踏�'),     TObject(36));
  UserSayCommand.AddObject(Conv('@혜磊'),         TObject(37));
  UserSayCommand.AddObject(Conv('@莉뚠斤口'),     TObject(38));
end;
//

////////////////////////////////////////////////////
//
//             ===  TMacroChecker  ===
//
////////////////////////////////////////////////////

constructor TMacroChecker.Create(anSaveCount : Integer);
var
   i : Integer;
   pMouseEvent : PTMouseEventData;
begin
   nSaveCount := anSaveCount;
   DataList := TList.Create;

   for i := 0 to nSaveCount - 1 do begin
      New(pMouseEvent);
      if pMouseEvent <> nil then begin
         FillChar(pMouseEvent^, sizeof(TMouseEventData), 0);
         DataList.Add(pMouseEvent);
      end;
   end;

   nReceivedCount := 0;
end;

destructor TMacroChecker.Destroy;
var
   i : Integer;
   pMouseEvent : PTMouseEventData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pMouseEvent := DataList.Items[i];
      if pMouseEvent <> nil then Dispose(pMouseEvent);
   end;
   DataList.Clear;
   DataList.Free;
   inherited Destroy;
end;

procedure TMacroChecker.Clear;
begin
   nReceivedCount := 0;   
end;

function TMacroChecker.CheckNone : Boolean; // 정말로 아무 일도 안하는 사람
var
   i, j : integer;
   pMouseEventData : PTMouseEventData;
begin
   Result := false;

   if nReceivedCount = nSaveCount then begin
      for i := 0 to nReceivedCount - 1 do begin
         pMouseEventData := DataList.Items[i];
         if pMouseEventData = nil then break;
         for j := 0 to 10 - 1 do begin
            if pMouseEventData^.revent[j] <> 0 then exit;
         end;
      end;
   end;

   Result := true;
end;

function TMacroChecker.CheckCase1: Boolean; // MouseMove만 0 < x < 20 인 사람
var
   i, j : integer;
   pMouseEventData : PTMouseEventData;
begin
   Result := false;

   for i := 0 to nReceivedCount - 1 do begin
      pMouseEventData := DataList.Items[i];
      if pMouseEventData = nil then exit;
      for j := 1 to 10 - 1 do begin
         if pMouseEventData^.revent[j] <> 0 then exit;
      end;
      if (pMouseEventData^.revent[0] <= 0) or (pMouseEventData^.revent[0] >= 20) then exit;
   end;

   Result := true;
end;

function TMacroChecker.CheckCase2: Boolean; // 30분동안 수치가 +-10%이내인 사람
var
   i, j : integer;
   pMouseEventData : PTMouseEventData;
   AverageData, LimitData : TMouseEventData;
begin
   Result := false;

   FillChar(AverageData, sizeof(TMouseEventData), 0);
   for i := 0 to nReceivedCount - 1 do begin
      pMouseEventData := DataList.Items[i];
      if pMouseEventData = nil then exit;
      for j := 0 to 10 - 1 do begin
         AverageData.revent[j] := AverageData.revent[j] + pMouseEventData^.revent[j];
      end;
   end;
   for i := 0 to 10 - 1 do begin
      AverageData.revent[i] := Integer(AverageData.revent[i] div nReceivedCount);
      LimitData.revent[i] := Integer(AverageData.revent[i] div 10);
   end;

   for i := 0 to nReceivedCount - 1 do begin
      pMouseEventData := DataList.Items[i];
      if pMouseEventData = nil then exit;
      for j := 0 to 10 - 1 do begin
         if pMouseEventData^.revent[j] > AverageData.revent[j] + LimitData.revent[i] then exit;
         if pMouseEventData^.revent[j] < AverageData.revent[j] - LimitData.revent[i] then exit;
      end;
   end;

   Result := true;
end;

function TMacroChecker.CheckCase3: Boolean; // 너무 자주 보내는 사람
var
   i : integer;
   nTick, nSumTick : Integer;
   pD1, pD2 : PTMouseEventData;
begin
   Result := false;

   nSumTick := 0;
   for i := 0 to nReceivedCount - 2 do begin
      pD1 := DataList.Items[i];
      pD2 := DataList.Items[i + 1];
      if (pD1 = nil) or (pD2 = nil) then exit;
      nTick := pD1^.rTick - pD2^.rTick;
      nSumTick := nSumTick + nTick;
   end;

   nTick := Integer(nSumTick div (nReceivedCount - 1));
   if nTick >= 6000 then exit; // 1분

   Result := true;
end;

procedure TMacroChecker.SaveMacroCase(aName : String; nCase : Integer);
   function GetCurDate : String;
   var
      nYear, nMonth, nDay : Word;
      sDate : String;
   begin
      Result := '';
      try
         DecodeDate (Date, nYear, nMonth, nDay);
         sDate := IntToStr(nYear);
         if nMonth < 10 then sDate := sDate + '0';
         sDate := sDate + IntToStr(nMonth);
         if nDay < 10 then sDate := sDate + '0';
         sDate := sDate + IntToStr(nDay);
      except
      end;
      Result := sDate;
   end;
var
   Stream : TFileStream;
   szBuffer : array[0..128] of byte;
   tmpStr, CaseStr, FileName : String;
begin
   Case nCase of
      1 : CaseStr := Conv('怜唐MouseMove 돨鑒令角0<x<20돨훙。');
      2 : CaseStr := Conv('30롸爐코틱엇鑒令瞳轎뀌10%렀鍋鹿코돨훙。');
      3 : CaseStr := Conv('궐5롸쇌목뫘우珂쇌눈渴돨훙。');
      4 : CaseStr := Conv('속醵포賈痰諒');
   end;
   try
      FileName := '.\MacroData\MC' + GetCurDate + '.SDB';
      if FileExists(FileName) then begin
         Stream := TFileStream.Create(FileName, fmOpenReadWrite);
         Stream.Seek(0, soFromEnd);
      end else begin
         Stream := TFileStream.Create(FileName, fmCreate);
         tmpStr := 'DateTime, Name, Case' + #13#10;
         StrPCopy(@szBuffer, tmpStr);
         Stream.WriteBuffer (szBuffer, StrLen(@szBuffer));
      end;

      tmpStr := DateToStr(Date) + ' ' + TimeToStr(Time) + ',' + aName + ',' + CaseStr + ',' + #13#10;
      StrPCopy(@szBuffer, tmpStr);
      Stream.WriteBuffer(szBuffer, StrLen(@szBuffer));
      Stream.Destroy;
   except
   end;
end;

procedure TMacroChecker.AddMouseEvent(pMouseEvent : PTCMouseEvent; anTick : Integer);
var
   pMouseEventData : PTMouseEventData;
begin
   if nSaveCount < DataList.Count then Exit;
   pMouseEventData := DataList.Items[nSaveCount - 1];
   if pMouseEventData = nil then Exit;

   pMouseEventData^.rTick := anTick;
   Move(pMouseEvent^.revent, pMouseEventData^.revent, sizeof(Integer) * 10);
   DataList.Delete (nSaveCount - 1);
   DataList.Insert (0, pMouseEventData);

   if nReceivedCount < nSaveCount then begin
      nReceivedCount := nReceivedCount + 1;
   end;
end;

function TMacroChecker.Check(aName : String) : Boolean;
var
   bFlag : Boolean;
begin
   Result := true;

   bFlag := CheckNone;
   if bFlag = true then begin
      Result := false;
      exit;
   end;

   bFlag := CheckCase1;
   if bFlag = true then begin
      SaveMacroCase(aName, 1);
      exit;
   end;
   bFlag := CheckCase2;
   if bFlag = true then begin
      SaveMacroCase(aName, 2);
      exit;
   end;
   bFlag := CheckCase3;
   if bFlag = true then begin
      SaveMacroCase(aName, 3);
      exit;
   end;

   Result := false;
end;

// TUserObject;
constructor TUserObject.Create;
begin
   inherited Create;

   FillChar (ShortCut, SizeOf (ShortCut), 0);
   boSafe := false;
   
   SendClass := TSendClass.Create;
   UserQuestClass := TUserQuestClass.Create;
   AttribClass := TAttribClass.Create (Self, SendClass);
   HaveMagicClass := THaveMagicClass.Create (Self, SendClass, AttribClass);
   AttackedMagicClass := TAttackedMagicClass.Create (Self);
   HaveItemClass := THaveItemClass.Create (Self, SendClass, AttribClass, UserQuestClass);
   HaveJobClass := THaveJobClass.Create (Self, SendClass, AttribClass, HaveItemClass);
   HaveMarketClass := THaveMarketClass.Create (Self, SendClass, AttribClass, HaveItemClass);
   WearItemClass := TWearItemClass.Create (Self, SendClass, AttribClass, HaveMagicClass, HaveJobClass, HaveItemClass);
   ShowWindowClass := TShowWindowClass.Create (Self, SendClass, HaveItemClass, HaveJobClass, HaveMarketClass);

   LifeObjectState := los_init;
   ShootBowCount := 0;
   ShootWindCount := 0;
   MagicStep := ms_none;
   ShowPowerLevelTick := 0;
   LockDownTick := 0;
   
   _3HitCount := 0;
   _3HitTick := 0;
   SpecialAttackCount := 0;
//   boPolymorph := false;
//   Mon_rAnimate := 0;
//   Mon_rShape := 0;
end;

destructor TUserObject.Destroy;
begin
   ShowWindowClass.Free;
   HaveMarketClass.Free;
   WearItemClass.Free;
   HaveJobClass.Free;            //2002-09-11
   HaveItemClass.Free;
   AttackedMagicClass.Free;
   HaveMagicClass.Free;
   AttribClass.Free;
   UserQuestClass.Free;
   SendClass.Free;
   inherited destroy;
end;

function TUserObject.AllowLifeObjectState :Boolean;
begin
   Result := false;
   //if LifeObjectState = los_spellcasting then exit;
   Result := true;
end;

function TUserObject.GetAge : Integer;
begin
   Result := AttribClass.Age;
end;

procedure TUserObject.SetCurSpecialMagic (amagic : PTMagicData);
begin
   HaveMagicClass.SetSpecialMagic (amagic);
end;

procedure TUserObject.SetCurPowerLevel (aPowerLevel : Integer);
begin
   HaveMagicClass.CurPowerLevel := aPowerLevel;
end;

function TUserObject.GetCurSpecialMagic: PTMagicData;
begin
   Result := HaveMagicClass.pCurSpecialMagic;
end;

function TUserObject.GetCurBreathngMagic : PTMagicData;
begin
   Result := HaveMagicClass.pCurBreathngMagic;
end;

function TUserObject.GetCurRunningMagic : PTMagicData;
begin
   Result := HaveMagicClass.pCurRunningMagic;
end;

function TUserObject.GetCurProtectingMagic : PTMagicData;
begin
   Result := HaveMagicClass.pCurProtectingMagic;
end;

function TUserObject.GetCurEctMagic : PTMagicData;
begin
   Result := HaveMagicClass.pCurEctMagic;
end;

function TUserObject.GetCurPowerLevel : Integer;
begin
   Result := HaveMagicClass.CurPowerLevel;
end;

function TUserObject.CheckHaveQuestItem (aQuestNum: integer) : boolean;
begin
   Result := HaveItemClass.CheckHaveQuestItem (aQuestNum);
end;

procedure TUserObject.ChangeCurPowerLevel (aLevel : Integer);
begin
   HaveMagicClass.ChangeCurPowerLevel(aLevel); 
end;

function TUserObject.GetCurAttackMagic: PTMagicData;
begin
   Result := HaveMagicClass.pCurAttackMagic;
end;

function TUserObject.GetAttribCurVirtue : Integer;
begin
   Result := AttribClass.Virtue;
end;

function TUserObject.GetCurrentWindow : TSpecialWindowKind;
begin
   Result := ShowWindowClass.CurrentWindow;
end;

function TUserObject.GetboMarketing : Boolean;
begin
   Result := HaveMarketClass.boMarketing;
end;

function TUserObject.SetPassword (aStr : String) : String;
var
   i : Integer;
   buffer : array [0..9 - 1] of Byte;
begin
   if Password <> '' then begin
      Result := Conv('쵱쯤綠�擁�');
      exit;
   end;
   if (aStr = '') or (Length (aStr) > 8) or (Length (aStr) < 4) then begin
      Result := Conv('쵱쯤角愷貫鑒鹿�構芥뽈譎冬�');
      exit;
   end;
   StrPCopy (@buffer, aStr);
   buffer [8] := 0;

   for i := 0 to StrLen (@buffer) - 1 do begin
      if (buffer [i] < 48) or (buffer [i] > 57) then begin
         Result := Conv('쵱쯤헝痰0-9돨鑒俚');
         exit; 
      end;
   end;

   Password := aStr;
   AliasPassWord := aStr;

   Result := Conv('쵱쯤綠�擁ª�헝인션쵱쯤');
end;

function TUserObject.FreePassword (aStr : String) : String;
begin
   if Password = '' then begin
      Result := Conv('뻘청�擁㉲堡�');
      exit;
   end;
   if aStr <> Password then begin
      Result := Conv('쵱쯤꼇攣횅');
      exit;
   end;

   Password := '';

   Result := Conv('썩뇜쵱쯤');
end;

function TUserObject.GetPassword : String;
begin
   Result := Password;
end;

function TUserObject.GetLifeObjectState : TLifeObjectState;
begin
   Result := LifeObjectState;
end;

procedure TUserObject.SetLifeData;
var
   tmpLifeData : TLifeData;
begin
   FillChar (LifeData, SizeOf (TLifeData), 0);
   FillChar (AddAttribData, SizeOf (TRealAddAttribData), 0);   

   AttribClass.GetLifeData (tmpLifeData);
   GatherLifeData (LifeData, tmpLifeData);
   GatherLifeData (LifeData, WearItemClass.WearItemLifeData);
   GatherLifeData (LifeData, HaveMagicClass.HaveMagicLifeData);

   CheckLifeData (LifeData);

   if (HaveMagicClass.pCurAttackMagic <> nil) and (HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MYSTERY) then begin
   end else begin
      if Manager.boUseChemistDrug = true then begin
         AttribClass.SetDrugEffect (LifeData);
      end;
   end;
   GatherLifeData (LifeData, AttribClass.HaveItemLifeData);

   GatherAttribLifeData (AddAttribData, WearItemClass.AddAttribLifeData);
   GatherAttribLifeData (AddAttribData, HaveItemClass.AddAttribLifeData);
   
   SendClass.SendAbilityAttrib (LifeData, AddAttribData, pCurAttackMagic);
end;

function TUserobject.GetMaxStatePointByGrade: integer; //2003-10
begin
   Result := HaveMagicClass.GetMaxStatePointByGrade;
end;

procedure TUserObject.SetTargetId (aid: integer);
var
   bo : TBasicObject;
begin
   if (TargetId <> 0) and (aid = 0) then begin
      PrevTargetId := TargetId;
   end;
   if aid = BasicData.id then exit;

   if TargetId <> aid then begin
      _3HitTick := 0;
      _3HitCount := 0;
      //MagicStep := ms_none;
      //pCurSpecialMagic := nil;
   end;
   
   TargetId := aid;
   if TargetId = 0 then begin
      if (LifeObjectState = los_attack) or (LifeObjectState = los_spellcasting) then LifeObjectState := los_none;
      //현재 발동중인 SpecialMagic을 멈춘다
      MagicStep := ms_none;
      pCurSpecialMagic := nil;
      exit;
   end;
   bo := TBasicObject (GetViewObjectById (TargetId));

   if bo = nil then begin
      if ( LifeObjectState = los_attack ) or ( LifeObjectState = los_spellcasting) then LifeObjectState := los_none;
      MagicStep := ms_none;
      pCurSpecialMagic := nil;
      exit;
   end;

  // add by Orber at 2005-03-10 10:39:19
   if Not Zhuang.FightState then
       if Bo.SGetName = Conv('앱鳩鏤댕펴') then Exit;

   if bo.State = wfs_die then begin
      // if LifeObjectState = los_attack then LifeObjectState := los_none;
      //if LifeObjectState = los_spellcasting then LifeObjectState := los_none;
      MagicStep := ms_none;
      pCurSpecialMagic := nil;
      exit;
   end;
   if TUser (Self).UseSkillKind <> ITEM_KIND_SHOWSKILL then begin
      if bo.BasicData.Feature.rHideState = hs_0 then begin
         if LifeObjectState = los_attack then begin
            LifeObjectState := los_none;
            MagicStep := ms_none;
         end;
         exit;
      end;
   end;

   if Basicdata.Feature.rfeaturestate <> wfs_care then CommandChangeCharState (wfs_care);

   if (WearItemClass.GetWeaponKind = ITEM_KIND_PICKAX) or (WearItemClass.GetWeaponKind = ITEM_KIND_HIGHPICKAX) then begin
      LifeObjectState := los_pick;
   //end else if (HaveMagicClass.pCurAttackMagic <> nil) and
   //            (HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MYSTERY) then begin
   //  LifeObjectState := los_spellcasting;
   end else begin
      LifeObjectState := los_attack;
   end;
end;

procedure TUserObject.StartProcess;
var
   ItemData: TItemData;
begin
   Inherited StartProcess;

   RopeTarget := 0;
   RopeTick := 0;
   RopeOldX := 0;
   RopeOldy := 0;

   boShiftAttack := TRUE;
   SearchTick := 0;
   SayTick := 0;
   DelayPwdTick := 0;
   SafeSettingTick := -360000;
   FreezeTick := 0;
   DiedTick := 0;
   HitedTick := 0;
   SpecialMagicTick := 0;
   SpecialMagicContinueTick := 0;   
   // StructedTick := 0;
   TargetId := 0;
   PrevTargetId := 0;
   LifeObjectState := los_none;

   Basicdata.id := GetNewUserId;

   //자리렉 해결을 위한 코드
   //frmMain.WriteUserIDLog(format('%s: %d',[StrPas (@BasicData.Name), BasicData.id]));
   
   BasicData.Feature := WearItemClass.GetFeature;
   WearItemClass.ViewItem (ARR_WEAPON, @ItemData);
   HaveMagicClass.SetHaveItemMagicType (ItemData.rHitType, true);
   BasicData.nx := BasicData.x;
   BasicData.ny := BasicData.y;

   SendClass.SendMap (BasicData, Manager);
   SendClass.SendSetShortCut (@ShortCut [0]);
   if TipStrList.Count > 0 then begin
      SendClass.SendChatMessage (TipStrList.Strings [Random (TipStrList.Count)], SAY_COLOR_SYSTEM);
   end;
end;

procedure TUserObject.EndProcess;
begin
   WearItemClass.SaveToSdb (@Connector.CharData);
   HaveItemClass.SaveToSdb (@Connector.CharData);
   AttribClass.SaveToSdb (@Connector.CharData);
   HaveMagicClass.SaveToSdb (@Connector.CharData);
   HaveJobClass.SaveToSdb (@Connector.CharData);
   HaveMarketClass.SaveToSdb (@Connector.CharData);
   
   FreezeTick := 0;
   DiedTick := 0;
   HitedTick := 0;
   // StructedTick := 0;
   TargetId := 0;
   LifeObjectState := los_init;
   Name := '';
   IP := '';
   
   Inherited EndProcess;
end;

function  TUserObject.AllowCommand (CurTick: integer): Boolean;
begin
   Result := TRUE;
   if FreezeTick > CurTick then Result := FALSE;
   if BasicData.Feature.rFeatureState = wfs_die then Result := FALSE;
   if boCanAttack = false then Result := FALSE;   
end;

procedure  TUserObject.SetCurrentShield (aValue : integer);
begin
   HaveMagicClass.CurShield := aValue;
end;

function   TUserObject.GetCurrentShield : Integer;
begin
   Result := HaveMagicClass.CurShield;
end;

function   TUserObject.GetRegenDec : Integer;
begin
   Result := AddAttribData.rEnergyRegenDec;
end;

function   TUserObject.GetDecValue : Integer;
begin
   Result := AddAttribData.rBasicValueDec;
end;

function   TUserObject.GetPowerLevel : Integer;
begin
   Result := HaveMagicClass.PowerLevel;
end;

function   TUserObject.GetBoAttacking: Boolean;
begin
   if TargetId <> 0 then Result := true else Result := false;
end;

procedure TUserObject.ShowEffect (aEffectNumber : Word; aEffectKind : TLightEffectKind);
var
   SubData : TSubData;
begin
   BasicData.Feature.rEffectNumber := aEffectNumber;
   BasicData.Feature.rEffectKind := aEffectKind;

   SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);

   BasicData.Feature.rEffectNumber := 0;
   BasicData.Feature.rEffectKind := lek_none;
end;

procedure TUserObject.ShowEffect2 (aEffectNumber : word; aEffectKind : TLightEffectKind; aDelay : integer);
var
   SubData : TSubData;
begin
   SubData.EffectNumber := aEffectNumber;
   SubData.EffectKind := aEffectKind;
   SubData.Delay := aDelay;
   SendLocalMessage (NOTARGETPHONE, FM_SETEFFECT, BasicData, SubData);
end;

function TUserObject.CommandSpell2 (var aSubData : TSubData): integer;
var
   Rate : Byte;
begin
   Result := 0;

   if aSubData.SpellType > SPELLTYPE_MAX then exit;


   Rate := 100 - LifeData.SpellResistRate [aSubData.SpellType - 1];
   if Rate <= 0 then exit;


   AttribClass.CurLife := AttribClass.CurLife - (aSubData.SpellDamage * Rate div 100);
   if AttribClass.CurLife < 0 then AttribClass.CurLife := 0;

   aSubData.percent := 100 * AttribClass.CurLife div AttribClass.Life;
   if aSubData.motion <> 0 then ShowEffect2 (aSubData.motion+1, lek_follow, 0);
   SendLocalMessage (NOTARGETPHONE, FM_LIFEPERCENT, BasicData, aSubData);
end;

function TUserObject.CommandSpell (aSpellType : Byte; aDecPercent : Integer) : Integer;
var
   Rate : Byte;
   SubData : TSubData;
begin
   Result := 0;

   if aSpellType > SPELLTYPE_MAX then exit;

   Rate := 100 - LifeData.SpellResistRate [aSpellType - 1];
   if Rate <= 0 then exit;

   AttribClass.CurLife := AttribClass.CurLife - (aDecPercent * Rate div 100);
   if AttribClass.CurLife < 0 then AttribClass.CurLife := 0;

   SubData.percent := 100 * AttribClass.CurLife div AttribClass.Life;
   SendLocalMessage (NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
end;

procedure TUserObject.CommandDecLifePercent (aDec : Integer);
var
   SubData : TSubData;
begin
//   AttribClass.CurLife := AttribClass.CurLife - (aDec div 100);

   AttribClass.CurLife := AttribClass.CurLife - ((AttribClass.Life div 100) * aDec);
   if AttribClass.CurLife < 0 then AttribClass.CurLife := 0;

   SubData.percent := 100 * AttribClass.CurLife div AttribClass.Life;
   SendLocalMessage (NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);

   SendLocalMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
end;

function TUserObject.GetCurrentKeepRecovery: Integer;
begin
   Result := 0;
   
   if HaveMagicClass.pCurAttackMagic <> nil then begin
      case HaveMagicClass.pCurAttackMagic^.rMagicType of
         MAGICTYPE_BOWING, MAGICTYPE_THROWING : Result := LifeData.KeepRecovery + AddAttribData.rBowKeepRecovery;
         MAGICTYPE_WRESTLING, MAGICTYPE_FENCING,
         MAGICTYPE_SWORDSHIP, MAGICTYPE_HAMMERING,
         MAGICTYPE_SPEARING : Result := LifeData.KeepRecovery + AddAttribData.rApproachKeepRecovery;
         MAGICTYPE_WINDOFHAND : Result := LifeData.KeepRecovery + AddAttribdata.rHandKeepRecovery;
      end;
   end else begin
      Result := LifeData.KeepRecovery;
   end;
end;

function TUserObject.CommandHited (aattacker: integer; aHitData: THitData; apercent: integer): integer;
var
   // CurTick : Integer;
   boNeedRecovery : Boolean;
   snd, n, decbody, decbodyexp, dechead, decArm, decLeg, decbodyR, aKeepRecovery, decenergy, tmpLife, tmpEnergy : Integer;
   exp, attackexp, protectexp, keepi, upfreeze, x : integer;
   SubData : TSubData;
   boSendShieldEffect : Boolean;
   suctionValue : Integer; //원기흡수량
   ShieldDamage : Integer;
   TotalDamage : Integer;
begin
   Result := 0;
   boSendShieldEffect := false;
   if boCanAttacked = false then exit; //2003-10 LockDown


   if (GroupKey > 0) and (aHitData.GroupKey = GroupKey) then exit;
   if Manager.boNotDeal = true then exit;

   //최종회피율
   n := LifeData.Avoid + AddAttribData.rApproachAvoid + aHitData.ToHit + aHitData.Accuracy;
   n := Random (n);
   if n < LifeData.Avoid + AddAttribData.rApproachAvoid then exit;

   //전이가 작동중이라면
   if (HaveMagicClass.pCurEctMagic <> nil) and (HaveMagicClass.pCurEctMagic^.rPassDamagePer <> 0) then begin
      //전이는 인간일 경우에만 적용됨
      case aHitData.Race of
         RACE_HUMAN :
            begin
               //성공률 계산.
               n := Random (100);
               if n <= HaveMagicClass.pCurEctMagic^.rSuccessRate then begin
                  SubData.HitData.damageBody    := aHitData.damageBody * HaveMagicClass.pCurEctMagic^.rPassDamagePer div 100;
                  SubData.HitData.damageHead    := aHitData.damageHead * HaveMagicClass.pCurEctMagic^.rPassDamagePer div 100;
                  SubData.HitData.damageArm     := aHitData.damageArm * HaveMagicClass.pCurEctMagic^.rPassDamagePer div 100;
                  SubData.HitData.damageLeg     := aHitData.damageLeg * HaveMagicClass.pCurEctMagic^.rPassDamagePer div 100;
                  SubData.HitData.damageEnergy  := aHitData.damageEnergy * HaveMagicClass.pCurEctMagic^.rPassDamagePer div 100;

                  SendLocalMessage (aattacker, FM_TURNDAMAGE, BasicData, SubData);

                  snd := HaveMagicClass.pCurEctMagic^.rSoundEvent.rWavNumber;
                  if snd <> 0 then begin
                     SetWordString (SubData.SayString, IntToStr (snd) + '.wav');
                     SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
                  end;
               end;
            end;
      end;
   end;

   suctionValue := 0;
   ShieldDamage := 0;
   decbodyexp := 0;

   if apercent = 100 then begin
      decHead     := aHitData.damagehead - LifeData.armorHead - AddAttribData.rApproachHeadArmor;
      decArm      := aHitData.damageArm - LifeData.armorArm - AddAttribData.rApproachArmArmor;
      decLeg      := aHitData.damageLeg - LifeData.armorLeg - AddAttribData.rApproachLegArmor;
      decbody     := aHitData.damageBody - LifeData.armorBody - AddAttribData.rApproachBodyArmor;
      decenergy   := aHitData.damageEnergy * ( 100 - LifeData.armorenergy) div 100 - LifeData.armorevalue;
      decbodyexp  := aHitData.damageExp - LifeData.armorExp;

      // 전이로 인해 상대방에 데미지를 주고 나는 getdamage만큼 제하고 타격받음   040422 saset
      if (HaveMagicClass.pCurEctMagic <> nil) and (HaveMagicClass.pCurEctMagic^.rGetDamagePer <> 0) then begin
         if HaveMagicClass.pCurEctMagic^.rGrade > 0 then begin
            decbody := decbody - (decbody * HaveMagicClass.pCurEctMagic^.rGetDamagePer div 100);
         end; 
      end;
   end else begin
      decHead     := (aHitData.damagehead * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorHead - AddAttribData.rApproachHeadArmor;
      decArm      := (aHitData.damageArm * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorArm - AddAttribData.rApproachArmArmor;
      decLeg      := (aHitData.damageLeg * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorLeg - AddAttribData.rApproachLegArmor;
      decbody     := (aHitData.damageBody * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorBody - AddAttribData.rApproachBodyArmor;
      decenergy   := 0;      
      decbodyexp  := (aHitData.damageExp * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorExp;
      //팔진격은 절세무공과 결합되지 못하므로 신경쓸 필요없음

      if (HaveMagicClass.pCurEctMagic <> nil) and (HaveMagicClass.pCurEctMagic^.rGetDamagePer <> 0) then begin
         if HaveMagicClass.pCurEctMagic^.rGrade > 0 then begin
            decbody := decbody - (decbody * HaveMagicClass.pCurEctMagic^.rGetDamagePer div 100);
         end; 
      end;
   end;

   //자세보정에 쓰이는 계산을 위해.
   if decbody <=0 then decbody := 1;
   decbodyR := decbody;
   TotalDamage := decbody;
   
   //호신강기 소모//
   if HaveMagicClass.CurShield > 0 then begin
      if HaveMagicClass.CurShield > decBody then begin
         ShieldDamage := decBody;
         HaveMagicClass.CurShield := HaveMagicClass.CurShield - decBody;
         decBody := 0;
      end else begin
         ShieldDamage := HaveMagicClass.CurShield;
         HaveMagicClass.CurShield := 0;
         decBody := decBody - ShieldDamage;
      end;
      boSendShieldEffect := true;
   end else begin
      if decbody <= 0 then decbody := 1;
   end;

   if decHead <= 0 then decHead := 1;
   if decArm <= 0 then decArm := 1;
   if decLeg <= 0 then decLeg := 1;
   if decbodyexp <= 0 then decbodyexp := 1;
   if decEnergy <= 0 then decEnergy := 0;   

   // 내성에 의한 피해 감소 (몸통에만 적용됨)
   n := AttribClass.Life div decBodyexp;
   if n <= 4 then begin
      decBodyexp := decBodyexp - decBodyexp * AttribClass.Adaptive div 20000; // 적응력은 50%
   end;

   if n = 0 then n := 1;
   if decBodyexp <= 0 then decBodyexp := 1;

   // 체력소모
   AttribClass.CurHeadLife := AttribClass.CurHeadLife - decHead;
   AttribClass.CurArmLife  := AttribClass.CurArmLife  - decArm;
   AttribClass.CurLegLife  := AttribClass.CurLegLife  - decLeg;
   AttribClass.CurLife     := AttribClass.CurLife     - decBody;
   AttribClass.CurEnergy   := AttribClass.CurEnergy   - decEnergy;

   //활력 흡수
   SubData.EnergyStealValue := 0;
   SubData.LifeStealValue := 0;
   if aHitData.LifeStealValue <> 0 then begin
      //흡수치만큼 활력을 더 깍는다
      tmpLife := AttribClass.CurLife - aHitData.LifeStealValue;
      if tmpLife < 0 then begin
         AttribClass.CurLife := 0;
         SubData.LifeStealValue := AttribClass.CurLife;
      end else begin
         AttribClass.CurLife := tmpLife;
         SubData.LifeStealValue := aHitData.LifeStealValue;
      end;

      SubData.attacker := aattacker;
      SendLocalMessage (aattacker, FM_ADDLIFEORENERGY, BasicData, SubData);

      snd := aHitData.SoundNumber;
      if snd <> 0 then begin
         SetWordString (SubData.SayString, IntToStr (snd) + '.wav');
         SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      end;
   end;
   //원기흡수
   if aHitData.EnergyStealValue <> 0 then begin
      tmpEnergy := AttribClass.CurEnergy - (decenergy * aHitData.EnergyStealValue div 100);

      if tmpEnergy < 0 then begin
         AttribClass.CurEnergy := 0;
         SubData.EnergyStealValue := AttribClass.CurEnergy;
      end else begin
         AttribClass.CurEnergy := tmpEnergy;
         SubData.EnergyStealValue := aHitData.EnergyStealValue;
      end;
      
      SubData.attacker := aattacker;
      SendLocalMessage (aattacker, FM_ADDLIFEORENERGY, BasicData, SubData);

      snd := aHitData.SoundNumber;
      if snd <> 0 then begin
         SetWordString (SubData.SayString, IntToStr (snd) + '.wav');
         SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      end;
   end;

   //Stun 공격
   if aHitData.Stun = STUN_ON then begin
      ShowEffect2 (STUN_EFFECT_NUM+1, lek_follow, 0);
      SetTargetId(0);
   end;

   //지금, 자세보정, 자세유지관련 코드
   boNeedRecovery := true;

   //현재 적용할 자세 유지 계산
   aKeepRecovery := GetCurrentKeepRecovery;

   if pCurAttackMagic = nil then begin
      if aKeepRecovery > 0 then upfreeze := LifeData.Recovery * 8 div 10
      else upfreeze := LifeData.Recovery;

      if aKeepRecovery < decbodyR then begin
         FreezeTick := mmAnsTick + upfreeze;
      end else begin
         keepi := aKeepRecovery - decbodyR;
         keepi := keepi * 100 div aKeepRecovery;
         if keepi < 50 then begin
            FreezeTick := mmAnsTick + upfreeze * (50 - keepi) div 50;
         end else begin
            boNeedRecovery := false;
         end;
      end;
   end else begin
      if (pCurSpecialMagic <> nil) and (pCurSpecialMagic^.rboNotRecovery = TRUE) then begin
         boNeedRecovery := false;
      end else begin
         case pCurAttackMagic^.rMagicClass of
            MAGICCLASS_MYSTERY :
               begin
                  if aKeepRecovery > TotalDamage then begin
                     boNeedRecovery := false;
                  end else begin
                     FreezeTick := mmAnsTick + LifeData.recovery;
                     SpecialMagicTick := FreezeTick - (LifeData.AttackSpeed + AddAttribData.rHandSpd);
                     SetTargetId (0);
                  end;
               end;
            else
               begin
                  if aKeepRecovery > 0 then upfreeze := LifeData.Recovery * 8 div 10
                  else upfreeze := LifeData.Recovery;

                  if aKeepRecovery < decbodyR then begin
                     FreezeTick := mmAnsTick + upfreeze;
                  end else begin
                     keepi := aKeepRecovery - decbodyR;
                     keepi := keepi * 100 div aKeepRecovery;
                     if keepi < 50 then begin
                        FreezeTick := mmAnsTick + upfreeze * (50 - keepi) div 50;
                     end else begin
                        boNeedRecovery := false;
                     end;
                  end;
               end;
         end;
      end;
   end;

   if AttribClass.Life <= 0 then BasicData.LifePercent := 0
   else BasicData.LifePercent := AttribClass.CurLife * 100 div AttribClass.Life;

   SubData.percent := BasicData.LifePercent;
   SubData.attacker := aattacker;
   SubData.HitData.HitType := aHitData.HitType;


   if boNeedRecovery = true then begin
      if boSendShieldEffect = true then ShowEffect2 (SHIELD_EFFECT_NUM + HaveMagicClass.CurPowerLevel-1,lek_follow, 0);

      if (Manager.boHit = true) or (isUserID (aAttacker) = false) then begin
         SendLocalMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end else begin
         TFieldPhone (Phone).SendMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end;

      //2003-10 자세보정시에는 모든 연타수 관련된 데이타를 초기화한다
      _3HitCount := 0;
      _3HitTick := mmAnsTick;

      //필살기취소
      CancelSpecialMagic;
   end else begin
      if boSendShieldEffect = true then ShowEffect2 (SHIELD_EFFECT_NUM + HaveMagicClass.CurPowerLevel-1 ,lek_follow, 0);


      if DecBody <> 0 then begin
         SubData.percent := 100 * AttribClass.CurLife div AttribClass.Life;
         SendLocalMessage (NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
      end;
   end;

   if aHitData.EffectNumber <> 0 then ShowEffect2(aHitData.EffectNumber+1, lek_none,0);

   Result := 1;

   BoSysopMessage ('TotalDamage : ' + IntToStr(TotalDamage) + ',ShieldDamage: '+ IntToStr (ShieldDamage) + ', BodyDamage : ' + IntToStr(decBody) , 10);


   //경험치와 관련된 계산
   //사람을 통한 경험치 계산은 없다.
   case aHitData.MagicType of
      MAGICCLASS_MYSTERY,MAGICCLASS_RISEMAGIC,MAGICCLASS_BESTMAGIC : exit;
   end;

   // 죽을땐 아무 경치도 없음
   if AttribClass.CurLife = 0 then begin
      SendClass.SendChatMessage (Conv ('헝�牘�'), SAY_COLOR_SYSTEM);
      exit;
   end;
   // 적응력 더하기 내성 +
   n := AttribClass.Life div decBodyExp;
   if n <= 4 then AttribClass.AddAdaptive (DEFAULTEXP);

   // 경치 더하기
   n := AttribClass.Life div decbodyexp;
   case aHitData.MagicType of
      MAGICCLASS_MAGIC :
         begin
            if n > 15 then exp := DEFAULTEXP
            else exp := DEFAULTEXP * n * n div (15 * 15);
         end;
      MAGICCLASS_RISEMAGIC :
         begin
            if n >= 30 then n := 29;
            Exp := 8000 * ((15 - ABS (15 - n)) * (15 - ABS (15 - n)) + 30) div (15 * 15);
         end;
      MAGICCLASS_BESTMAGIC :
         begin
            if n >= 20 then n := 20;
            case aHitData.Grade of
               0: x := 1600;
               1: x := 800;
               2: x := 400;
            end;
            Exp := (x * n * n) div (20 * 20);
         end;
      else
         begin
            exp := 0;
         end;
   end;

   if Exp < 0 then Exp := 0;
   if Exp > 10000 then Exp := 10000;

   attackexp := 0;
   if Exp > 0 then begin
      SubData.ExpData.Exp := exp;
      SubData.ExpData.ExpType := 0;
      if apercent = 100 then begin
         if aHitData.Race = RACE_HUMAN then begin
            case aHitData.MagicType of
               MAGICCLASS_MAGIC : begin
                  if HaveMagicClass.pCurAttackMagic = nil then begin
                  end else if HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
                     if HaveMagicClass.pCurProtectingMagic = nil then begin
                        attackexp := SubData.ExpData.Exp;
                        SubData.HitData.LimitSkill := 0;
                        SendLocalMessage (aattacker, FM_ADDATTACKEXP, BasicData, SubData);
                     end else if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
                        attackexp := SubData.ExpData.Exp;
                        SubData.HitData.LimitSkill := 0;
                        SendLocalMessage (aattacker, FM_ADDATTACKEXP, BasicData, SubData);
                     end;
                  end;
               end;
               {
               MAGICCLASS_BESTMAGIC : begin
                  if HaveMagicClass.pCurAttackMagic = nil then begin
                  end else if HaveMagicClass.pCurAttackMagic^.rMagicClass <> MAGICCLASS_RISEMAGIC then begin
                     if HaveMagicClass.pCurProtectingMagic = nil then begin
                        attackexp := SubData.ExpData.Exp;
                        SubData.HitData.LimitSkill := 0;
                        SendLocalMessage (aattacker, FM_ADDATTACKEXP, BasicData, SubData);
                     end else if HaveMagicClass.pCurProtectingMagic^.rMagicClass <> MAGICCLASS_RISEMAGIC then begin
                        attackexp := SubData.ExpData.Exp;
                        SubData.HitData.LimitSkill := 0;
                        SendLocalMessage (aattacker, FM_ADDATTACKEXP, BasicData, SubData);
                     end;
                  end;
               end;
               }
            end;
         end else if aHitData.Race = RACE_NPC then begin
            attackexp := SubData.ExpData.Exp;
            SubData.HitData.LimitSkill := 0;
            SendLocalMessage (aattacker, FM_ADDATTACKEXP, BasicData, SubData);
         end;
      end;
   end;

   // 강신 더하기
   SubData.ExpData.Exp := 0;
   SubData.attacker := aAttacker;
   if HaveMagicClass.pCurProtectingMagic <> nil then begin
      if aHitData.Race = RACE_HUMAN then begin
         if HaveMagicClass.pCurAttackMagic <> nil then begin
            if HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
               if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
                  SubData.ExpData.Exp := DEFAULTEXP - Exp;
               end;
            end;
         end;
      end else begin
         if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
            SubData.ExpData.Exp := DEFAULTEXP - Exp;
         end else if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_RISEMAGIC then begin
            keepi := (decbodyexp * 100) div AttribClass.Life;
            if keepi >= 10 then keepi := 100
            else keepi := keepi * 10;
            SubData.ExpData.Exp := (decbodyexp * 10) * keepi div 100;
         end else if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
            case HaveMagicClass.pCurProtectingMagic^.rGrade of
               0: x := 1600;
               1: x := 800;
               2: x := 400;
            end;

            if n >= 20 then SubData.ExpData.Exp := 0
            else begin
               SubData.ExpData.Exp := x - ((x * n * n) div (12 * 12));       // 031025 20을 10으로 수정 saset
            end;
         end;
      end;
   end;
   if SubData.ExpData.Exp < 0 then SubData.ExpData.Exp := 0;
   if SubData.ExpData.Exp > 10000 then SubData.ExpData.Exp := 10000;

   protectexp := 0;

   if SubData.ExpData.Exp > 0 then begin
      if aHitData.Race <> RACE_HUMAN then begin
         protectexp := SubData.ExpData.Exp;
         SendLocalMessage (BasicData.Id, FM_ADDPROTECTEXP, BasicData, SubData);
      end else begin
         case aHitData.MagicType of
            MAGICCLASS_MAGIC : begin
               if HaveMagicClass.pCurProtectingMagic = nil then begin
               end else if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
                  protectexp := SubData.ExpData.Exp;
                  SendLocalMessage (BasicData.ID, FM_ADDPROTECTEXP, BasicData, SubData);
               end;
            end;
            {
            MAGICCLASS_BESTMAGIC : begin
               if HaveMagicClass.pCurProtectingMagic = nil then begin
               end else if HaveMagicClass.pCurProtectingMagic^.rMagicClass <> MAGICCLASS_RISEMAGIC then begin
                  protectexp := SubData.ExpData.Exp;
                  SendLocalMessage (BasicData.ID, FM_ADDPROTECTEXP, BasicData, SubData);
               end;
            end;
            }
         end;
      end;
   end;

   snd := Random (100);
   if snd < 40 then begin
      case AttribClass.Age of
         0..5999 :      snd := 2002;
         6000..11900 :  snd := 2004;
         else           snd := 2000;
      end;
      if not BasicData.Feature.rboman then snd := snd + 200;
      SetWordString (SubData.SayString, IntToStr (snd) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   BoSysopMessage (IntToStr(decBody) + ' : ' + IntToStr(attackexp) + ' : ' + IntToStr (protectexp), 10);
   Result := 1;
end;

function TUserObject.CommandPassed (aattacker: integer; aHitData: THitData; apercent: integer): integer;
var
   boNeedRecovery : Boolean;
   snd, n, x, decbody, decbodyexp, dechead, decArm, decLeg, decenergy, decbodyR, aKeepRecovery : Integer;
   exp, attackexp, protectexp, keepi, upfreeze : integer;
   SubData : TSubData;
   boSendShieldEffect : Boolean;
   suctionValue : Integer; //원기흡수량
   ShieldDamage : Integer;
   TotalDamage : Integer;
begin
   Result := 0;
   boSendShieldEffect := false;

   suctionValue := 0;
   ShieldDamage := 0;
   decbodyexp := 0;

   decHead     := aHitData.damagehead - LifeData.armorHead - AddAttribData.rApproachHeadArmor;
   decArm      := aHitData.damageArm - LifeData.armorArm - AddAttribData.rApproachArmArmor;
   decLeg      := aHitData.damageLeg - LifeData.armorLeg - AddAttribData.rApproachLegArmor;
   decbody     := aHitData.damageBody - LifeData.armorBody - AddAttribData.rApproachBodyArmor;
   decenergy   := aHitData.damageEnergy * ( 100 - LifeData.armorenergy) div 100 - LifeData.armorevalue;

   //자세보정에 쓰이는 계산을 위해.
   if decbody <=0 then decbody := 1;
   decbodyR := decbody;
   TotalDamage := decbody;
   
   //호신강기 소모//
   if HaveMagicClass.CurShield > 0 then begin
      if HaveMagicClass.CurShield > decBody then begin
         ShieldDamage := decBody;
         HaveMagicClass.CurShield := HaveMagicClass.CurShield - decBody;
         decBody := 0;
      end else begin
         ShieldDamage := HaveMagicClass.CurShield;
         HaveMagicClass.CurShield := 0;
         decBody := decBody - ShieldDamage;
      end;
      boSendShieldEffect := true;
   end else begin
      if decbody <= 0 then decbody := 1;
   end;

   if decHead <= 0 then decHead := 1;
   if decArm <= 0 then decArm := 1;
   if decLeg <= 0 then decLeg := 1;
   if decEnergy <= 0 then decEnergy := 0;

   // 체력소모
   AttribClass.CurHeadLife := AttribClass.CurHeadLife - decHead;
   AttribClass.CurArmLife  := AttribClass.CurArmLife  - decArm;
   AttribClass.CurLegLife  := AttribClass.CurLegLife  - decLeg;
   AttribClass.CurLife     := AttribClass.CurLife     - decBody;
   AttribClass.CurEnergy   := AttribClass.CurEnergy   - decEnergy;
   //지금, 자세보정, 자세유지관련 코드
   boNeedRecovery := true;

   //현재 적용할 자세 유지 계산
   aKeepRecovery := GetCurrentKeepRecovery;

   //장풍과 기타의 상황의 자세보정처리는 틀리다.
   if (HaveMagicClass.pCurAttackMagic <> nil) and (HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MYSTERY) then begin
      //현재 사용무공이 장풍일경우
      if aKeepRecovery > TotalDamage then begin
         boNeedRecovery := false;
      end else begin
         FreezeTick := mmAnsTick + LifeData.recovery;
         SpecialMagictick := FreezeTick - (LifeData.AttackSpeed + AddAttribData.rHandSpd);
         SetTargetId (0);
         //SetTargetID(0);
      end;   
   end else begin
      //기본,일반,상승무공에 대한 계산
      if aKeepRecovery > 0 then upfreeze := LifeData.Recovery * 8 div 10
      else upfreeze := LifeData.Recovery;

      if aKeepRecovery < decbodyR then begin
         FreezeTick := mmAnsTick + upfreeze;
      end else begin
         keepi := aKeepRecovery - decbodyR;
         keepi := keepi * 100 div aKeepRecovery;
         if keepi < 50 then begin
            FreezeTick := mmAnsTick + upfreeze * (50 - keepi) div 50;
         end else begin
            boNeedRecovery := false;
         end;
      end;
   end;

   if AttribClass.Life <= 0 then BasicData.LifePercent := 0
   else BasicData.LifePercent := AttribClass.CurLife * 100 div AttribClass.Life;

   SubData.percent := BasicData.LifePercent;
   SubData.attacker := aattacker;
   SubData.HitData.HitType := aHitData.HitType;


   if boNeedRecovery = true then begin
      if LifeObjectState = los_spellcasting then SetTargetID(0);
      if boSendShieldEffect = true then ShowEffect2 (SHIELD_EFFECT_NUM + HaveMagicClass.CurPowerLevel-1,lek_follow, 0);
      if (Manager.boHit = true) or (isUserID (aAttacker) = false) then begin
         SendLocalMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end else begin
         TFieldPhone (Phone).SendMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end;

      //2003-10 자세보정시에는 모든 연타수 관련된 데이타를 초기화한다
      _3HitCount := 0;
      _3HitTick := mmAnsTick;
   end else begin
      if LifeObjectState = los_spellcasting then boSendShieldEffect := false;
      if boSendShieldEffect = true then ShowEffect2 (SHIELD_EFFECT_NUM + HaveMagicClass.CurPowerLevel-1 ,lek_follow, 0);

      if DecBody <> 0 then begin
         SubData.percent := 100 * AttribClass.CurLife div AttribClass.Life;
         SendLocalMessage (NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
      end;
   end;
   Result := 1;

   BoSysopMessage ('TotalDamage : ' + IntToStr(TotalDamage) + ',ShieldDamage: '+ IntToStr (ShieldDamage) + ', BodyDamage : ' + IntToStr(decBody) , 10);

   if AttribClass.CurLife = 0 then begin
      SendClass.SendChatMessage (Conv ('헝�牘�'), SAY_COLOR_SYSTEM);
      exit;
   end;

   snd := Random (100);
   if snd < 40 then begin
      case AttribClass.Age of
         0..5999 :      snd := 2002;
         6000..6900 :   snd := 2004;
         else           snd := 2000;
      end;
      if not BasicData.Feature.rboman then snd := snd + 200;
      SetWordString (SubData.SayString, IntToStr (snd) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   Result := 1;
end;

function TUserObject.CommandCriticalAttacked (var SenderInfo : TBasicData;var aSubData : TSubData): integer;
var
   boNeedRecovery : Boolean;
   snd, n, x, decbody, decbodyexp, dechead, decArm, decLeg, decenergy, decbodyR, aKeepRecovery : Integer;
   exp, attackexp, protectexp, keepi, upfreeze : integer;
   SubData : TSubData;
   boSendShieldEffect : Boolean;
   suctionValue : Integer; //원기흡수량
   ShieldDamage : Integer;
   TotalDamage, dir : Integer;
begin
   Result := 0;
   boSendShieldEffect := false;

   if (GroupKey > 0) and (aSubData.HitData.GroupKey = GroupKey) then exit;

   //해당 필살기의 공격이 LockDown값을 가진다면(점혈)
   if aSubData.LockDown <> 0 then begin
      n := Random(100);
      if n <= aSubData.SuccessRate then begin
         boCanMove := false;
         boCanAttack := false;
         boCanAttacked := false;
         LockDownDecLife := aSubData.LockDownDecLife;

         LockDownTick := mmAnsTick + aSubData.LockDown * 100;
         if BasicData.Feature.rActionState <> as_ice then SetActionState (as_ice);

         if aSubData.EffectNumber <> 0 then ShowEffect2 (aSubData.EffectNumber+1, lek_none,0);
         if aSubData.EffectNumber2 <> 0 then begin
            ShowEffect2 (aSubData.EffectNumber2+1, lek_continue, 1);
            SetCondition(EFFECT_ON, aSubData.EffectNumber2+1, LockDownTick);
         end;
         Result := 1;
      end;
      exit;
   end;
   
   //최종회피율
   n := LifeData.Avoid + AddAttribData.rApproachAvoid + aSubData.HitData.ToHit + aSubData.HitData.Accuracy;
   n := Random (n);
   if n < LifeData.Avoid + AddAttribData.rApproachAvoid then exit;

   suctionValue := 0;
   ShieldDamage := 0;
   decbodyexp := 0;

   decHead     := aSubData.HitData.damagehead - LifeData.armorHead - AddAttribData.rApproachHeadArmor;
   decArm      := aSubData.HitData.damageArm - LifeData.armorArm - AddAttribData.rApproachArmArmor;
   decLeg      := aSubData.HitData.damageLeg - LifeData.armorLeg - AddAttribData.rApproachLegArmor;
   decbody     := aSubData.HitData.damageBody - LifeData.armorBody - AddAttribData.rApproachBodyArmor;
   decenergy   := aSubData.HitData.damageEnergy * ( 100 - LifeData.armorenergy) div 100 - LifeData.armorevalue;
   decbodyexp  := aSubData.HitData.damageExp - LifeData.armorExp;

   //자세보정에 쓰이는 계산을 위해.
   if decbody <=0 then decbody := 1;
   decbodyR := decbody;
   TotalDamage := decbody;
   
   //호신강기 소모//
   if HaveMagicClass.CurShield > 0 then begin
      if HaveMagicClass.CurShield > decBody then begin
         ShieldDamage := decBody;
         HaveMagicClass.CurShield := HaveMagicClass.CurShield - decBody;
         decBody := 0;

      end else begin
         ShieldDamage := HaveMagicClass.CurShield;
         HaveMagicClass.CurShield := 0;
         decBody := decBody - ShieldDamage;
      end;
      boSendShieldEffect := true;
   end else begin
      if decbody <= 0 then decbody := 1;
   end;

   if decHead <= 0 then decHead := 1;
   if decArm <= 0 then decArm := 1;
   if decLeg <= 0 then decLeg := 1;
   if decbodyexp <= 0 then decbodyexp := 1;
   if decEnergy <= 0 then decEnergy := 0;

   // 내성에 의한 피해 감소 (몸통에만 적용됨)
   n := AttribClass.Life div decBodyexp;
   if n <= 4 then begin
      decBodyexp := decBodyexp - decBodyexp * AttribClass.Adaptive div 20000; // 적응력은 50%
   end;

   if n = 0 then n := 1;
   if decBodyexp <= 0 then decBodyexp := 1;

   // 체력소모
   AttribClass.CurHeadLife := AttribClass.CurHeadLife - decHead;
   AttribClass.CurArmLife  := AttribClass.CurArmLife  - decArm;
   AttribClass.CurLegLife  := AttribClass.CurLegLife  - decLeg;
   AttribClass.CurLife     := AttribClass.CurLife     - decBody;
   AttribClass.CurEnergy   := AttribClass.CurEnergy   - decEnergy;

   //내,외,무공 공격에 의한 소모
   if (aSubData._3Attib > 0) and (aSubData._3Attib < 101) then begin
      AttribClass.CurInPower := AttribClass.CurInPower - AttribClass.InPower * aSubData._3Attib div 100;
      AttribClass.CurOutPower := AttribClass.CurOutPower - AttribClass.OutPower * aSubData._3Attib div 100;
      AttribClass.CurMagic := AttribClass.CurMagic - AttribClass.Magic * aSubData._3Attib div 100;
   end;

   //지금, 자세보정, 자세유지관련 코드
   boNeedRecovery := true;

   //현재 적용할 자세 유지 계산
   aKeepRecovery := GetCurrentKeepRecovery;

   if pCurAttackMagic = nil then begin
      if aKeepRecovery > 0 then upfreeze := LifeData.Recovery * 8 div 10
      else upfreeze := LifeData.Recovery;

      if aKeepRecovery < decbodyR then begin
         FreezeTick := mmAnsTick + upfreeze;
      end else begin
         keepi := aKeepRecovery - decbodyR;
         keepi := keepi * 100 div aKeepRecovery;
         if keepi < 50 then begin
            FreezeTick := mmAnsTick + upfreeze * (50 - keepi) div 50;
         end else begin
            boNeedRecovery := false;
         end;
      end;
   end else begin
      if (pCurSpecialMagic <> nil) and (pCurSpecialMagic^.rboNotRecovery = TRUE) then begin
//         boNeedRecovery := false;
      end else begin
         case pCurAttackMagic^.rMagicClass of
            MAGICCLASS_MYSTERY :
               begin
                  if aKeepRecovery > TotalDamage then begin
                     boNeedRecovery := false;
                  end else begin
                     FreezeTick := mmAnsTick + LifeData.recovery;
                     SpecialMagicTick := FreezeTick - (LifeData.AttackSpeed + AddAttribData.rHandSpd);
                     SetTargetId (0);
                  end;
               end;
            else
               begin
                  if aKeepRecovery > 0 then upfreeze := LifeData.Recovery * 8 div 10
                  else upfreeze := LifeData.Recovery;

                  if aKeepRecovery < decbodyR then begin
                     FreezeTick := mmAnsTick + upfreeze;
                  end else begin
                     keepi := aKeepRecovery - decbodyR;
                     keepi := keepi * 100 div aKeepRecovery;
                     if keepi < 50 then begin
                        FreezeTick := mmAnsTick + upfreeze * (50 - keepi) div 50;
                     end else begin
                        boNeedRecovery := false;
                     end;
                  end;
               end;
         end;
      end;
   end;

   if AttribClass.Life <= 0 then BasicData.LifePercent := 0
   else BasicData.LifePercent := AttribClass.CurLife * 100 div AttribClass.Life;

   SubData.percent := BasicData.LifePercent;
   SubData.attacker := aSubData.attacker;
   SubData.HitData.HitType := aSubData.HitData.HitType;

   if aSubData.EffectNumber <> 0 then ShowEffect2 (aSubData.EffectNumber+1, lek_none,40);
   if aSubData.HitData.Stun = STUN_ON then begin
      ShowEffect2 (STUN_EFFECT_NUM+1, lek_follow, 0);
      SetTargetID(0);
   end;
   if aSubData.ScreenEffectNum <> 0 then SendClass.SendScreenEffect(aSubData.ScreenEffectNum, aSubData.ScreenEffectDelay);

   if boNeedRecovery = true then begin
      if boSendShieldEffect = true then ShowEffect2 (SHIELD_EFFECT_NUM + HaveMagicClass.CurPowerLevel-1,lek_follow, 0);
      if (Manager.boHit = true) or (isUserID (aSubData.attacker) = false) then begin
         SendLocalMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end else begin
         TFieldPhone (Phone).SendMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end;

      //2003-10 자세보정시에는 모든 연타수 관련된 데이타를 초기화한다
      _3HitCount := 0;
      _3HitTick := mmAnsTick;

      //필살기취소
      CancelSpecialMagic;

      if aSubData.PushLength <> 0 then begin
         dir := GetNextDirection (SenderInfo.x, SenderInfo.y, BasicData.x, BasicData.y);
         PushMove(dir, aSubData.PushLength);
      end;
   end else begin
      if boSendShieldEffect = true then ShowEffect2 (SHIELD_EFFECT_NUM + HaveMagicClass.CurPowerLevel-1 ,lek_follow, 0);

      if DecBody <> 0 then begin
         SubData.percent := 100 * AttribClass.CurLife div AttribClass.Life;
         SendLocalMessage (NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
      end;
   end;
   Result := 1;

   BoSysopMessage ('TotalDamage : ' + IntToStr(TotalDamage) + ',ShieldDamage: '+ IntToStr (ShieldDamage) + ', BodyDamage : ' + IntToStr(decBody) , 10);

   if AttribClass.CurLife = 0 then begin
      SendClass.SendChatMessage (Conv ('헝�牘�'), SAY_COLOR_SYSTEM);
      exit;
   end;

   snd := Random (100);
   if snd < 40 then begin
      case AttribClass.Age of
         0..5999 :      snd := 2002;
         6000..6900 :  snd := 2004;
         else           snd := 2000;
      end;
      if not BasicData.Feature.rboman then snd := snd + 200;
      SetWordString (SubData.SayString, IntToStr (snd) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;
end;

function TUserObject.CommandBowed (aattacker: integer; aHitData: THitData; apercent: integer): integer;
var
   // CurTick : Integer;
   boNeedRecovery : Boolean;
   snd, n, m, decbody, decbodyexp, dechead, decArm, decLeg, decbodyR, aKeepRecovery: Integer;
   exp, attackexp, protectexp, keepi, upfreeze, x : integer;
   SubData : TSubData;
   boSendShieldEffect : Boolean;
   suctionValue : Integer; //원기흡수량
   ShieldDamage : Integer;
   TotalDamage : Integer;
begin
   Result := 0;
   boSendShieldEffect := false;

   if boCanAttacked = false then exit; //2003-10   
   if (GroupKey > 0) and (aHitData.GroupKey = GroupKey) then exit;
   
   //최종회피율

   if isMonsterID(aattacker) then begin
      m := LifeData.Avoid + AddAttribData.rBowAvoid;
   end else if isUserID(aattacker) then begin
      m := LifeData.Avoid + LifeData.longavoid + AddAttribData.rBowAvoid;
   end;

   n := m + aHitData.ToHit + aHitData.Accuracy;
   n := Random (n);
   if n < m then exit;

   suctionValue := 0;
   ShieldDamage := 0;
   decbodyexp := 0;

   if apercent = 100 then begin
      decHead     := aHitData.damagehead - LifeData.armorHead - AddAttribData.rBowHeadArmor;
      decArm      := aHitData.damageArm - LifeData.armorArm - AddAttribData.rBowArmArmor;
      decLeg      := aHitData.damageLeg - LifeData.armorLeg - AddAttribData.rBowLegArmor;
      decbody     := aHitData.damageBody - LifeData.armorBody - AddAttribData.rBowBodyArmor;
      decbodyexp  := aHitData.damageExp - LifeData.armorExp;
   end else begin
      decHead     := (aHitData.damagehead * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorHead - AddAttribData.rBowHeadArmor;
      decArm      := (aHitData.damageArm * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorArm - AddAttribData.rBowArmArmor;
      decLeg      := (aHitData.damageLeg * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorLeg - AddAttribData.rBowLegArmor;
      decbody     := (aHitData.damageBody * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorBody - AddAttribData.rBowBodyArmor;
      decbodyexp  := (aHitData.damageExp * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorExp;
   end;


   //자세보정에 쓰이는 계산을 위해.
   if decbody <=0 then decbody := 1;
   decbodyR := decbody;
   TotalDamage := decbody;
   
   //호신강기 소모//
   if HaveMagicClass.CurShield > 0 then begin
      if HaveMagicClass.CurShield > decBody then begin
         ShieldDamage := decBody;
         HaveMagicClass.CurShield := HaveMagicClass.CurShield - decBody;
         decBody := 0;
      end else begin
         ShieldDamage := HaveMagicClass.CurShield;
         HaveMagicClass.CurShield := 0;
         decBody := decBody - ShieldDamage;
      end;
      boSendShieldEffect := true;
   end else begin
      if decbody <= 0 then decbody := 1;
   end;

   if decHead <= 0 then decHead := 1;
   if decArm <= 0 then decArm := 1;
   if decLeg <= 0 then decLeg := 1;
   if decbodyexp <= 0 then decbodyexp := 1;

   // 내성에 의한 피해 감소 (몸통에만 적용됨)
   n := AttribClass.Life div decBodyexp;
   if n <= 4 then begin
      decBodyexp := decBodyexp - decBodyexp * AttribClass.Adaptive div 20000; // 적응력은 50%
   end;

   if n = 0 then n := 1;
   if decBodyexp <= 0 then decBodyexp := 1;

   // 체력소모
   AttribClass.CurHeadLife := AttribClass.CurHeadLife - decHead;
   AttribClass.CurArmLife  := AttribClass.CurArmLife  - decArm;
   AttribClass.CurLegLife  := AttribClass.CurLegLife  - decLeg;
   AttribClass.CurLife     := AttribClass.CurLife     - decBody;

   //지금, 자세보정, 자세유지관련 코드
   boNeedRecovery := true;

   //해당되는 자세유지 개념계산
   aKeepRecovery := GetCurrentKeepRecovery;

   if pCurAttackMagic = nil then begin
      if aKeepRecovery > 0 then upfreeze := LifeData.Recovery * 8 div 10
      else upfreeze := LifeData.Recovery;

      if aKeepRecovery < decbodyR then begin
         FreezeTick := mmAnsTick + upfreeze;
      end else begin
         keepi := aKeepRecovery - decbodyR;
         keepi := keepi * 100 div aKeepRecovery;
         if keepi < 50 then begin
            FreezeTick := mmAnsTick + upfreeze * (50 - keepi) div 50;
         end else begin
            boNeedRecovery := false;
         end;
      end;
   end else begin
      if (pCurSpecialMagic <>nil) and (pCurSpecialMagic^.rboNotRecovery = TRUE) then begin
         boNeedRecovery := false;
      end else begin
         case pCurAttackMagic^.rMagicClass of
            MAGICCLASS_MYSTERY :
               begin
                  if aKeepRecovery > TotalDamage then begin
                     boNeedRecovery := false;
                  end else begin
                     FreezeTick := mmAnsTick + LifeData.recovery;
                     SpecialMagicTick := FreezeTick - (LifeData.AttackSpeed + AddAttribData.rHandSpd);
                     SetTargetId (0);
                  end;
               end;
            else
               begin
                  if aKeepRecovery > 0 then upfreeze := LifeData.Recovery * 8 div 10
                  else upfreeze := LifeData.Recovery;

                  if aKeepRecovery < decbodyR then begin
                     FreezeTick := mmAnsTick + upfreeze;
                  end else begin
                     keepi := aKeepRecovery - decbodyR;
                     keepi := keepi * 100 div aKeepRecovery;
                     if keepi < 50 then begin
                        FreezeTick := mmAnsTick + upfreeze * (50 - keepi) div 50;
                     end else begin
                        boNeedRecovery := false;
                     end;
                  end;
               end;
         end;
      end;
   end;

   if AttribClass.Life <= 0 then BasicData.LifePercent := 0
   else BasicData.LifePercent := AttribClass.CurLife * 100 div AttribClass.Life;

   SubData.percent := BasicData.LifePercent;
   SubData.attacker := aattacker;
   SubData.HitData.HitType := aHitData.HitType;


   if boNeedRecovery = true then begin
      if LifeObjectState = los_spellcasting then SetTargetID(0);
      if boSendShieldEffect = true then ShowEffect2 (SHIELD_EFFECT_NUM + HaveMagicClass.CurPowerLevel-1,lek_follow, 0);
      if (Manager.boHit = true) or (isUserID (aAttacker) = false) then begin
         SendLocalMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end else begin
         TFieldPhone (Phone).SendMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end;
      //2003-10 자세보정시에는 모든 연타수 관련된 데이타를 초기화한다
      _3HitCount := 0;
      _3HitTick := mmAnsTick;

      //필살기취소
      CancelSpecialMagic;
   end else begin
      if LifeObjectState = los_spellcasting then boSendShieldEffect := false;
      if boSendShieldEffect = true then ShowEffect2 (SHIELD_EFFECT_NUM + HaveMagicClass.CurPowerLevel-1,lek_follow, 0);

      if DecBody <> 0 then begin
         SubData.percent := 100 * AttribClass.CurLife div AttribClass.Life;
         SendLocalMessage (NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
      end;
   end;
   Result := 1;

   BoSysopMessage ('TotalDamage : ' + IntToStr(TotalDamage) + ',ShieldDamage: '+ IntToStr (ShieldDamage) + ', BodyDamage : ' + IntToStr(decBody) , 10);
   //경험치계산
   //사람을 통한 경험치 계산은 없다.
   if ( aHitData.MagicType = MAGICCLASS_MYSTERY) or (aHitData.MagicType = MAGICCLASS_RISEMAGIC) then exit;

   // 죽을땐 아무 경치도 없음
   if AttribClass.CurLife = 0 then begin
      SendClass.SendChatMessage (Conv ('헝�牘�'), SAY_COLOR_SYSTEM);
      exit;
   end;
   // 적응력 더하기 내성 +
   n := AttribClass.Life div decBodyExp;
   if n <= 4 then AttribClass.AddAdaptive (DEFAULTEXP);

   // 경치 더하기
   n := AttribClass.Life div decbodyexp;
   case aHitData.MagicType of
      MAGICCLASS_MAGIC : begin
         if n > 15 then exp := DEFAULTEXP               // 15 대이상 맞을만 하다면 1000
         else exp := DEFAULTEXP * n * n div (15 * 15);   // 15대 맞으면 죽구도 남으면 10 => 500   n 15 => 750   5=>250
      end;
      MAGICCLASS_RISEMAGIC : begin
         if n >= 30 then n := 29;
         Exp := 8000 * ((15 - ABS (15 - n)) * (15 - ABS (15 - n)) + 30) div (15 * 15);
      end;
      MAGICCLASS_BESTMAGIC : begin
         if n >= 20 then n := 20;
         case aHitData.Grade of
            0: x := 1600;
            1: x := 800;
            2: x := 400;
         end;
         Exp := (x * n * n) div (20 * 20);                              // 031025 20을 25로 수정 saset
      end;
      else begin
         exp := 0;
      end;
   end;

   if Exp < 0 then Exp := 0;
   if Exp > 10000 then Exp := 10000;

   attackexp := 0;
   if Exp > 0 then begin
      SubData.ExpData.Exp := exp;
      SubData.ExpData.ExpType := 0;
      if apercent = 100 then begin
         if aHitData.Race = RACE_HUMAN then begin
            case aHitData.MagicType of
               MAGICCLASS_MAGIC : begin
                  if HaveMagicClass.pCurAttackMagic = nil then begin
                  end else if HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
                     if HaveMagicClass.pCurProtectingMagic = nil then begin
                        attackexp := SubData.ExpData.Exp;
                        SubData.HitData.LimitSkill := 0;
                        SendLocalMessage (aattacker, FM_ADDATTACKEXP, BasicData, SubData);
                     end else if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
                        attackexp := SubData.ExpData.Exp;
                        SubData.HitData.LimitSkill := 0;
                        SendLocalMessage (aattacker, FM_ADDATTACKEXP, BasicData, SubData);
                     end;
                  end;
               end;
               {
               MAGICCLASS_BESTMAGIC : begin
               end;
               }
            end;
         end else if aHitData.Race = RACE_NPC then begin
            attackexp := SubData.ExpData.Exp;
            SubData.HitData.LimitSkill := 0;                        
            SendLocalMessage (aattacker, FM_ADDATTACKEXP, BasicData, SubData);
         end;
      end;
   end;

   
   // 강신 더하기
   SubData.ExpData.Exp := 0;
   SubData.attacker := aAttacker;
   if HaveMagicClass.pCurProtectingMagic <> nil then begin
      if aHitData.Race = RACE_HUMAN then begin
         if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
            SubData.ExpData.Exp := DEFAULTEXP - Exp;
         end;
      end else begin
         case HaveMagicClass.pCurProtectingMagic^.rMagicClass of
            MAGICCLASS_MAGIC : begin
               SubData.ExpData.Exp := DEFAULTEXP - Exp;
            end;
            MAGICCLASS_RISEMAGIC : begin
               keepi := (decbodyexp * 100) div AttribClass.Life;
               if keepi >= 10 then keepi := 100
               else keepi := keepi * 10;
               SubData.ExpData.Exp := (decbodyexp * 10) * keepi div 100;
            end;
            MAGICCLASS_BESTMAGIC : begin
               case HaveMagicClass.pCurProtectingMagic^.rGrade of
                  0: x := 1600;
                  1: x := 800;
                  2: x := 400;
               end;

               if n >= 20 then SubData.ExpData.Exp := 0
               else begin
                  SubData.ExpData.Exp := x - ((x * n * n) div (12 * 12));       // 031025 20을 10으로 수정 saset
               end;
            end;
         end;
      end;
   end;
   if SubData.ExpData.Exp < 0 then SubData.ExpData.Exp := 0;
   if SubData.ExpData.Exp > 10000 then SubData.ExpData.Exp := 10000;

   protectexp := 0;

   if SubData.ExpData.Exp > 0 then begin
      if aHitData.Race <> RACE_HUMAN then begin
         protectexp := SubData.ExpData.Exp;
         SendLocalMessage (BasicData.Id, FM_ADDPROTECTEXP, BasicData, SubData);
      end else begin
         case aHitData.MagicType of
            MAGICCLASS_MAGIC : begin
               if HaveMagicClass.pCurProtectingMagic = nil then begin
               end else if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
                  protectexp := SubData.ExpData.Exp;
                  SendLocalMessage (BasicData.ID, FM_ADDPROTECTEXP, BasicData, SubData);
               end;
            end;
         end;
      end;
   end;

   snd := Random (100);
   if snd < 40 then begin
      case AttribClass.Age of
         0..5999 :      snd := 2002;
         6000..11900 :  snd := 2004;
         else           snd := 2000;
      end;
      if not BasicData.Feature.rboman then snd := snd + 200;
      SetWordString (SubData.SayString, IntToStr (snd) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   BoSysopMessage (IntToStr(decBody) + ' : ' + IntToStr(attackexp) + ' : ' + IntToStr (protectexp), 10);
   Result := 1;
end;

procedure TUserObject.CommandBowing (CurTick: integer; atid: integer; atx, aty: word; boSend: Boolean);
var
   snd, pos : integer;
   boHitAllow: Boolean;
   SubData : TSubData;
   tmpItemData : TItemData;
   User : TUser;
begin
   if (TargetID <> 0) and isUserID (TargetID) = true then begin
      User := TUser (GetViewObjectByID (TargetID));
      if User <> nil then begin
         if (GroupKey > 0) and (User.GroupKey = GroupKey) then begin
            SetTargetID (0);
            exit;
         end;
      end;
   end;

   if Manager.boNotDeal = true then exit;

   if not AllowCommand (CurTick) then exit;
//   if boPolymorph = true then exit;

   if HitedTick + LifeData.AttackSpeed + AddAttribData.rBowAttSpd > CurTick then exit;

//   if HaveMagicClass.pCurAttackMagic = nil then exit;

   if ShootBowCount > (HaveMagicClass.pCurAttackMagic^.rcSkillLevel div 2000) + 1 then begin
      SetTargetId (0);
      ShootBowCount := 0;
      exit;
   end;
   inc (ShootBowCount);

   boHitAllow := FALSE;
   case HaveMagicClass.pCurAttackMagic^.rMagicType of
      5 : // 궁술
         begin
            pos := HaveItemClass.FindKindItem (7);
            if pos <> -1 then begin
               HaveItemClass.ViewItem (pos, @tmpItemData);
               tmpItemData.rOwnerName[0] := 0;
               if HaveItemClass.DeleteKeyItem (pos, 1, @tmpItemData) then boHitAllow := TRUE;
            end;
         end;
      6 : // 투법
         begin
            pos := HaveItemClass.FindKindItem (8);
            if pos <> -1 then begin
               HaveItemClass.ViewItem (pos, @tmpItemData);
               tmpItemData.rOwnerName[0] := 0;
               if HaveItemClass.DeleteKeyItem (pos, 1, @tmpItemData) then boHitAllow := TRUE;
            end;
         end;
      else
         boHitAllow := TRUE;
   end;

   if boHitAllow = FALSE then exit;

   HitedTick := CurTick;

   if HaveMagicClass.DecEventMagic (HaveMagicClass.pCurAttackMagic) = FALSE then begin
      SendClass.SendSideMessage (Conv('청콘묑샌'));
      exit;
   end;

   if GetViewDirection (BasicData.x, BasicData.y, atx, aty) <> basicData.dir then
      CommandTurn ( GetViewDirection (BasicData.x, BasicData.y, atx, aty), TRUE);

   SubData.HitData.damageBody := LifeData.damageBody + AddAttribData.rAddBodyDamage;
   SubData.HitData.damageHead := LifeData.damageHead + AddAttribData.rAddHeadDamage;
   SubData.HitData.damageArm := LifeData.damageArm + AddAttribData.rAddArmDamage;
   SubData.HitData.damageLeg := LifeData.damageLeg + AddAttribData.rAddLegDamage;
   SubData.HitData.ToHit := 75;
   SubData.HitData.HitType := 1;
   SubData.HitData.HitLevel := 0;
   SubData.HitData.Accuracy := LifeData.Accuracy + AddAttribData.rBowAccuracy;
   SubData.HitData.damageExp := LIfeData.damageExp;
   SubData.HitData.cPowerLevel := HaveMagicClass.CurPowerLevel;
   SubData.HitData.MagicType := 0;
   SubData.HitData.Race := BasicData.Feature.rRace;
   SubData.HitData.GroupKey := GroupKey;
   SubData.HitData.HitFunction := 0;
   SubData.HitData.HitFunctionSkill := 0;
   SubData.HitData.HitedCount := 0;

   if HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
      SubData.HitData.MagicType := MAGICCLASS_MAGIC;
      SubData.HitData.Grade := 0;
   end else if HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_RISEMAGIC then begin
      SubData.HitData.MagicType := MAGICCLASS_RISEMAGIC;
      SubData.HitData.Grade := 0;
   end else if HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
      SubData.HitData.MagicType := MAGICCLASS_BESTMAGIC;
      SubData.HitData.Grade := HaveMagicClass.pCurAttackMagic^.rGrade;
   end;
   
   SubData.HitData.HitLevel := HaveMagicClass.pCurAttackMagic^.rcSkillLevel;

   if HaveMagicClass.pCurEctMagic <> nil then begin
      case HaveMagicClass.pCurEctMagic^.rFunction of
         MAGICFUNC_5HIT, MAGICFUNC_8HIT :
            begin
               SubData.HitData.HitFunction := HaveMagicClass.pCurEctMagic^.rFunction;
               SubData.HitData.HitFunctionSkill := HaveMagicClass.pCurEctMagic^.rcSkillLevel;
            end;
      end;
   end;

   AttribClass.CurLife := AttribClass.CurLife - HaveMagicClass.pCurattackmagic^.rEventDecLife;

   SubData.TargetId := atid;
   SubData.tx := atx;
   SubData.ty := aty;
   SubData.BowImage := tmpItemData.rActionImage;
   SetWordString (SubData.SayString, StrPas (@tmpItemData.rName));
   SubData.BowSpeed := HaveMagicClass.pCurAttackMagic^.rBowSpeed;
   SubData.BowType := HaveMagicClass.pCurAttackMagic^.rBowType;
   SubData.EffectNumber := HaveMagicClass.pCurAttackMagic^.rEEffectNumber;

   SubData.EffectKind := lek_none;

   LastGainExp := 0;
   SendLocalMessage (NOTARGETPHONE, FM_BOW, BasicData, SubData);
   if (HaveMagicClass.pCurEctMagic <> nil) and (SubData.HitData.HitedCount > 1) then begin
      HaveMagicClass.AddEctExp (10, LastGainExp);
   end;

   snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber;
   if snd <> 0 then begin
      case HaveMagicClass.pCurAttackMagic^.rcSkillLevel of
         0..4999: snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber;
         5000..8999: snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber+1;
         else snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber+2;
      end;

      SetWordString (SubData.SayString, InttoStr(snd) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   //2002-11-06 giltae 궁법,투법 이펙트
   SubData.MagicState   := 0;
   SubData.MagicKind    := 0;
   SubData.MagicColor   := 0;
   SubData.motion := BasicData.Feature.rhitmotion;
   if HaveMagicClass.pCurAttackMagic^.rcSkillLevel = 9999 then begin
      SubData.MagicState   := HaveMagicClass.pCurAttackMagic^.rMagicClass;
      SubData.MagicKind    := HaveMagicClass.pCurAttackMagic^.rMagicType;
      //모든 투법,궁법의 이펙트 색깔은 동일하다.
      SubData.MagicColor   := 1;
   end;

   if boSend = true then SendClass.SendMotion (BasicData.id, SubData.motion, SubData.MagicState, SubData.MagicKind, SubData.MagicColor);
   SendLocalMessage (NOTARGETPHONE, FM_MOTION, BasicData, SubData);
end;


procedure TUserObject.CommandWindOfHand_new (CurTick: Integer; atid: integer; atx, aty: word);
var
   SubData : TSubData;
   n,m,t : integer;
   aWaveNumber, aWaveNumber2 : Integer;
begin
   if Manager.boNotDeal = true then exit;   
   if not AllowCommand (CurTick) then exit;

   case MagicStep of
      ms_none:
         begin
            if atid = 0 then exit;
                        
            if BasicData.id = atid then begin
               SendClass.SendChatMessage (Conv('꼇콘菱乖묑샌'), SAY_COLOR_SYSTEM);
               exit;
            end;
                               
            if GetViewDirection (BasicData.x, BasicData.y, atx, aty) <> basicData.dir then
               CommandTurn ( GetViewDirection (BasicData.x, BasicData.y, atx, aty), TRUE);

            if SpecialMagicTick + LifeData.AttackSpeed + AddAttribData.rHandSpd > CurTick then exit;

            //if ShootWindCount >= WINDOFHAND_CONTINOUS_NUM then begin
            //   SetTargetId (0);
            //   ShootWindCount := 0;
            //   exit;
            //end;
            //inc (ShootWindCount);

            if HaveMagicClass.DecEventMagic (HaveMagicClass.pCurAttackMagic) = FALSE then begin
               SendClass.SendSideMessage (Conv('청콘묑샌'));
               SetTargetID(0);
               exit;
            end;
            
            HitedTick := CurTick;
            SpecialMagicTick := CurTick;
            SetTargetID (atid);
            inc (MagicStep);

            //기를 모으는 동작전달
            SubData.MagicState := 0;
            SubData.MagicKind := 0;
            SubData.MagicColor := 0;
            SubData.motion := AM_HIT10_READY;
            SendLocalMessage ( NOTARGETPHONE, FM_MOTION, BasicData, SubData);
            SendClass.SendMotion (BasicData.id, SubData.motion, SubData.MagicState, SubData.MagicKind, SubData.MagicColor);

            //이펙트 전달
            ShowEffect2 (HaveMagicClass.pCurAttackMagic^.rSEffectNumber + 1, lek_hit10, 0);

            //사운드 전달
            case HaveMagicClass.pCurAttackMagic^.rcSkillLevel of
               0..5000: aWaveNumber := HaveMagicClass.pCurAttackMagic^.rSoundStart.rWavNumber;
               5001..9000: aWaveNumber := HaveMagicClass.pCurAttackMagic^.rSoundStart.rWavNumber + 1;
               else aWaveNumber := HaveMagicClass.pCurAttackMagic^.rSoundStart.rWavNumber+2;
            end;

            SetWordString (SubData.SayString, IntToStr (aWaveNumber) + '.wav');
            SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
         end;
      ms_wait:
         begin
            if TargetId = 0 then exit;
            if SpecialMagicTick + LifeData.AttackSpeed + AddAttribData.rHandSpd > CurTick then exit;
            if GetViewDirection (BasicData.x, BasicData.y, atx, aty) <> basicData.dir then
               CommandTurn ( GetViewDirection (BasicData.x, BasicData.y, atx, aty), TRUE);
            //장풍을 쏘는 동작. 맞던 안맞던 일단은 나간다.
            SubData.MagicState := 0;
            SubData.MagicKind := 0;
            SubData.MagicColor := 0;
            SubData.motion := AM_HIT10;
            SendLocalMessage ( NOTARGETPHONE, FM_MOTION, BasicData, SubData);
            SendClass.SendMotion( BasicData.id, SubData.motion, 0, 0, 0);

            //원기 데미지 계산
            if HaveMagicClass.CurPowerLevel = HaveMagicClass.PowerLevel then begin
               n := AttribClass.CurEnergy + HaveMagicClass.ConsumeEnergy;
            end else begin
               m := MagicClass.GetPowerLevelLimitEnergy (HaveMagicClass.CurPowerLevel);
               t := AttribClass.CurEnergy + HaveMagicClass.ConsumeEnergy;
               if m > t then n := t
               else n := m;
            end;

            SubData.HitData.damageBody := LifeData.damageBody + ( n div 100) * LifeData.damageBody div 2000
               + AddAttribData.rAddBodyDamage;
            SubData.HitData.damageHead := AddAttribData.rAddHeadDamage;
            SubData.HitData.damageArm := AddAttribData.rAddArmDamage;
            SubData.HitData.damageLeg := AddAttribData.rAddLegDamage;
            SubData.HitData.ToHit := 75;
            SubData.HitData.HitType := 0;       //HitType 은 어디서 사용하는 정보인가?
            SubData.HitData.Accuracy := LifeData.Accuracy + AddAttribData.rHandAccuracy;
            SubData.HitData.damageExp := LifeData.damageExp;
            SubData.HitData.cPowerLevel := HaveMagicClass.CurPowerLevel;
            SubData.HitData.Race := BasicData.Feature.rrace;
            SubData.HitData.GroupKey := GroupKey;
            SubData.HitData.HitFunction := 0;
            SubData.HitData.HitFunctionSkill := 0;
            SubData.HitData.HitedCount := 0;
            SubData.HitData.MagicType := MAGICCLASS_MYSTERY;
            SubData.HitData.HitLevel := HaveMagicClass.pCurAttackMagic^.rcSkillLevel;
            SubData.HitData.MagicRelation := HaveMagicClass.pCurAttackMagic^.rMagicRelation;
            SubData.HitData.CosumeEnergy := HaveMagicClass.ConsumeEnergy;
//            SubData.HitData.boRangeEffected := false;
            SubData.attacker := BasicData.id;
            SubData.HitData.Grade := 0;
      
            SubData.TargetId     := TargetID;
            SubData.tx           := atx;
            SubData.ty           := aty;
            case HaveMagicClass.pCurAttackMagic^.rcSkillLevel of
               0..5000:
                  begin
                     SubData.BowImage := HaveMagicClass.pCurAttackMagic^.rBowImage;
                     aWaveNumber := HaveMagicClass.pCurAttackMagic^.rSoundSwing.rWavNumber;
                     aWaveNumber2 := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber;
                  end;
               5001..9000:
                  begin
                     SubData.BowImage := HaveMagicClass.pCurAttackMagic^.rBowImage+1;
                     aWaveNumber := HaveMagicClass.pCurAttackMagic^.rSoundSwing.rWavNumber+1;
                     aWaveNumber2 := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber+1;
                  end;
               else
                  begin
                     SubData.BowImage := HaveMagicClass.pCurAttackMagic^.rBowImage+2;
                     aWaveNumber := HaveMagicClass.pCurAttackMagic^.rSoundSwing.rWavNumber+2;
                     aWaveNumber2 := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber+2;
                  end;
            end;
            SubData.BowSpeed     := HaveMagicClass.pCurAttackMagic^.rBowSpeed;
            SubData.BowType      := HaveMagicClass.pCurAttackMagic^.rBowType;
            SubData.EffectNumber := HaveMagicClass.pCurAttackMagic^.rEEffectNumber+1;
            SubData.EffectKind   := lek_none;
            SubData.MinRange     := HaveMagicClass.pCurAttackMagic^.rMinRange - AddAttribData.rHandMinValue;
            SubData.MaxRange     := HaveMagicClass.pCurAttackMagic^.rMaxRange + AddAttribData.rHandMaxValue;
            SubData.Delay        := 0;

            if SubData.MinRange < 0 then SubData.MinRange := 1;

            HaveMagicClass.SetPrevAttackMagic (HaveMagicClass.pCurAttackMagic);
            SetWordString (SubData.SayString, IntToStr (aWaveNumber2) + '.wav');
            SendLocalMessage (TargetID, FM_WINDOFHAND, BasicData, SubData);

            SubData.EffectNumber := 0;
            SendLocalMessage (NOTARGETPHONE, FM_WINDOFHANDEFFECT, BasicData, SubData);
            SetWordString (SubData.SayString, IntToStr (aWaveNumber) + '.wav');
            SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
            inc(MagicStep);
            SetTargetID(0);
         end;
      ms_end:
         begin
            //SetTargetID(0);
            MagicStep := ms_none;
         end;
   end;
end;

procedure TUserObject.CommandCriticalAttack (CurTick: integer; atid: integer; atx, aty: word);
var
   SubData : TSubData;
   n,m,t : integer;
   aWaveNumber, aWaveNumber2 : Integer;
begin
   case MagicStep of
      ms_none:
         begin
//            if atid = 0 then exit;
            if pCurSpecialMagic = nil then exit;
            
            if BasicData.id = atid then begin
               SendClass.SendChatMessage (Conv ('꼇콘菱乖묑샌'), SAY_COLOR_SYSTEM);
               HaveMagicClass.SetSpecialMagic(nil);
               exit;
            end;

//            if SpecialMagicContinueTick + 800 <= CurTick then exit;     // 초식 한번 사용하면 8초동안 사용 못함

            //범위공격이며 현재 타켓이 선정되지 않은 상황일 경우
            //atx, aty는 없으므로 방향전환을 하지 않는다.
            if (atx <> 0) and (aty <> 0) then begin
               if GetViewDirection (BasicData.x, BasicData.y, atx, aty) <> basicData.dir then
                  CommandTurn (GetViewDirection (BasicData.x, BasicData.y, atx, aty), TRUE);
            end;

            if SpecialMagicTick + LifeData.AttackSpeed > CurTick then exit;

            if HaveMagicClass.DecEventMagic (HaveMagicClass.pCurSpecialMagic) = FALSE then begin
               SendClass.SendSideMessage (Conv ('청콘묑샌'));
               SetTargetID(0);
               exit;
            end;

            HitedTick := CurTick;
            SpecialMagicTick := CurTick;
            //SetTargetID (atid);
            //if TargetId = 0 then exit;
            inc (MagicStep);

            //기를 모으는 동작전달
            SubData.MagicState := 0;
            SubData.MagicKind := 0;
            SubData.MagicColor := 0;

            case pCurSpecialMagic^.rMotionType of
               MOTIONTYPE_CHARGE :
                  begin
                     case pCurAttackMagic^.rMagicType of
                        0..MAGICTYPE_SWORDSHIP :
                           begin
                              SubData.motion := AM_SHIT_READY_START + 2 * pCurAttackMagic^.rMagicType ;
                              ShowEffect2 (pCurSpecialMagic^.rSEffectNumber + pCurAttackMagic^.rMagicType + 1, lek_hit10, 0);
                           end;
                        else begin
                              SubData.motion := AM_SHIT_READY_START + 2 * MAGICTYPE_HAMMERING ;
                              ShowEffect2 (pCurSpecialMagic^.rSEffectNumber + MAGICTYPE_HAMMERING + 1, lek_hit10, 0);
                        end;
                     end;
                  end;
               MOTIONTYPE_MAGIC :
                  begin
                     SubData.motion := AM_HIT11_READY;
                     ShowEffect2 (pCurSpecialMagic^.rSEffectNumber+1, lek_none,0);
                  end;
               {
               MOTIONTYPE_CHARGE2 :
                  begin
                     case pCurAttackMagic^.rMagicType of
                        0..MAGICTYPE_SWORDSHIP :
                           begin
                              SubData.motion := AM_SHIT_READY_START + 2 * pCurAttackMagic^.rMagicType ;
                              if pCurSpecialMagic^.rCEffectNumber <> 0 then begin
                                 ShowEffect2 (pCurSpecialMagic^.rCEffectNumber+1, lek_follow, 0);
                              end;


                           end;
                        else begin
                              SubData.motion := AM_SHIT_READY_START + 2 * MAGICTYPE_HAMMERING ;
                              if pCurSpecialMagic^.rCEffectNumber <> 0 then begin
                                 ShowEffect2 (pCurSpecialMagic^.rCEffectNumber+1, lek_follow, 0);
                              end;
                        end;
                     end;
                  end;
               }
            end;
            SendLocalMessage ( NOTARGETPHONE, FM_MOTION, BasicData, SubData);
            SendClass.SendMotion (BasicData.id, SubData.motion, SubData.MagicState, SubData.MagicKind, SubData.MagicColor);

            //기 이펙트 전달
         end;
      ms_wait:
         begin
            // if TargetId = 0 then exit;
            if SpecialMagicTick + pCurSpecialMagic^.rShotDelay > CurTick then exit;
            HitedTick := CurTick;
            SpecialMagicTick := CurTick;
            
            if (atx<>0) and (aty<>0) then begin
               if GetViewDirection (BasicData.x, BasicData.y, atx, aty) <> basicData.dir then
                  CommandTurn ( GetViewDirection (BasicData.x, BasicData.y, atx, aty), TRUE);
            end;
            
            //장풍을 쏘는 동작. 맞던 안맞던 일단은 나간다.
            SubData.MagicState := 0;
            SubData.MagicKind := 0;
            SubData.MagicColor := 0;

            case pCurSpecialMagic^.rMotionType of
               MOTIONTYPE_CHARGE :
                  begin
                     case pCurAttackMagic^.rMagicType of
                        0..MAGICTYPE_SWORDSHIP:
                           begin
                              SubData.motion := AM_SHIT_START + 2 * pCurAttackMagic^.rMagicType;;
                           end;
                        else
                           begin
                              SubData.motion := AM_SHIT_START + 2 * MAGICTYPE_HAMMERING;
                           end;
                     end;

                     if pCurSpecialMagic^.rSEffectNumber2 <> 0 then begin
                        if pCurSpecialMagic^.rRangeType = RANGETYPE_CENTER_4 then begin
                           n := BasicData.dir mod 2;
                           ShowEffect2 (pCurSpecialMagic^.rSEffectNumber2+1+n, lek_follow, 0);
                        end else begin
                           ShowEffect2 (pCurSpecialMagic^.rSEffectNumber2+1, lek_follow, 0);
                        end;
                     end;
                  end;
               MOTIONTYPE_MAGIC :
                  begin
                     SubData.motion := AM_HIT11;;
                  end;
            end;

            SendLocalMessage ( NOTARGETPHONE, FM_MOTION, BasicData, SubData);
            SendClass.SendMotion( BasicData.id, SubData.motion, 0, 0, 0);

            //실제 데미지를 계산한다
            {if TargetID = 0 then begin
               MagicStep := ms_none;
               pCurSpecialMagic := nil;
               exit;
            end;
            }
            SubData.attacker := BasicData.id;
            SubData.TargetId := TargetID;
            SubData.HitData.damageBody := LifeData.damageBody + pCurSpecialMagic^.rcLifeData.damageBody;
            SubData.HitData.damageHead := LifeData.damageHead + pCurSpecialMagic^.rcLifeData.damageHead;
            SubData.HitData.damageArm := LifeData.damageArm + pCurSpecialMagic^.rcLifeData.damageArm;
            SubData.HitData.damageLeg := LifeData.damageLeg + pCurSpecialMagic^.rcLifeData.damageLeg;
            SubData.HitData.damageEnergy := LifeData.damageenergy + pCurSpecialMagic^.rcLifeData.damageenergy;
            SubData.HitData.Accuracy := LifeData.Accuracy + AddAttribData.rApproachAccuracy;
            SubData.HitData.damageExp := LifeData.damageExp;
            SubData.HitData.ToHit := 75;
            SubData.HitData.HitType := 0;
            SubData.HitData.HitLevel := 0;
            SubData.HitData.boHited := FALSE;
            SubData.HitData.dir := BasicData.dir;
            SubData.HitData.HitFunction := pCurSpecialMagic^.rFunction;
            SubData.HitData.HitFunctionSkill := 0;
            SubData.HitData.HitedCount := 0;
            SubData.HitData._3HitCount := _3HitCount;
            SubData.HitData._3HitTick  := _3HitTick;
            SubData.HitData.cPowerLevel := HaveMagicClass.CurPowerLevel;
            SubData.HitData.MagicType := pCurAttackMagic^.rMagicClass;
            SubData.HitData.Grade := pCurAttackMagic^.rGrade;
            SubData.HitData.Race := BasicData.Feature.rrace;
            SubData.HitData.GroupKey := GroupKey;
            SubData.HitData.HitLevel := pCurAttackMagic^.rcSkillLevel;
            SubData.HitData.Stun := pCurSpecialMagic^.rStun;
            SubData.LockDown := pCurSpecialMagic^.rLockDown;
            SubData.LockDownDecLife := pCurSpecialMagic^.r5SecDecLife;  // 점혈 걸리는동안 활력빼는것
            SubData.EffectNumber := pCurSpecialMagic^.rEEffectNumber;   //일시적 effect
            SubData.EffectNumber2 := pCurSpecialMagic^.rCEffectNumber;  //지속성 effect
            SubData.PushLength := pCurSpecialMagic^.rPushLength;
            SubData.SuccessRate := pCurSpecialMagic^.rSuccessRate;
            SubData.MinRange := pCurSpecialMagic^.rMinRange;
            SubData.MaxRange := pCurSpecialMagic^.rMaxRange;
            SubData._3Attib := pCurSpecialMagic^.r3Attrib;
            SubData.RangeType := pCurSpecialMagic^.rRangeType;
            SubData.tx := atx;
            SubData.ty := aty;
            SubData.ScreenEffectNum := pCurSpecialMagic^.rScreenEffectNum;
            SubData.ScreenEffectDelay := pCurSpecialMagic^.rScreenEffectDelay;

            if SubData.RangeType <> RANGETYPE_NONE then begin
               SendLocalMessage ( NOTARGETPHONE, FM_CRITICAL, BasicData, SubData);
            end else begin
               SendLocalMessage ( TargetID, FM_CRITICAL, BasicData, SubData);
            end;
            MagicStep := ms_none;
            pCurSpecialMagic := nil;
         end;
      ms_end:
         begin
            MagicStep := ms_none;
            pCurSpecialMagic := nil;
            SpecialMagicContinueTick := CurTick;
         end;
   end;
end;

procedure TUserObject.CommandAttackedMagic (var aWindOfHandData : TWindOfHandData);
var
   boNeedRecovery : Boolean;
   m, decbody, decbodyexp, dechead, decArm, decLeg, decbodyR, aKeepRecovery, upfreeze, keepi : Integer;
   SubData : TSubData;
   boSendShieldEffect : Boolean;
   suctionValue : Integer; //원기흡수량
   ShieldDamage : Integer;
   TotalDamage : Integer;
begin
   boSendShieldEffect := false;

   if boCanAttacked = false then exit; //2003-10   
   if aWindOfHandData.rMagicType <> MAGICCLASS_MYSTERY then exit;

   suctionValue := 0;
   ShieldDamage := 0;
   decbodyexp := 0;
   //원기흡수 계산
   if HaveMagicClass.pCurProtectingMagic <> nil then begin
      m := MagicClass.GetValueFromRelationTable (HaveMagicClass.pCurProtectingMagic^.rMagicRelation, aWindOfHandData.rMagicRelation);

      //강신 연관성이 100이면 적이든 아군이든 원기를 흡수한다.
      if m = 60 then begin
         if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_RISEMAGIC then begin
            suctionValue := ( aWindOfHandData.rConsumeEnergy * 7 div 10 ) * HaveMagicClass.pCurProtectingMagic^.rcSkillLevel div 9999;
         end else begin
            suctionValue := ( aWindOfHandData.rConsumeEnergy * 7 div 15 ) * HaveMagicClass.pCurProtectingMagic^.rcSkillLevel div 9999;
         end;
      end;
         
      if suctionValue > 0 then begin
         if suctionValue > AttribClass.Energy then suctionValue := AttribClass.Energy;
         if AttribClass.Energy < AttribClass.CurEnergy + suctionValue then begin
            AttribClass.CheckAccelDecreaseTick := mmAnsTick;
         end;
         AttribClass.CurEnergy := AttribClass.CurEnergy + suctionValue;
         if AttribClass.CurEnergy > AttribClass.Energy * 2 then begin
            AttribClass.CurEnergy := AttribClass.Energy * 2;
         end;
      end;
   end;

   //단체설정값이 같으면 공격못함
   if (GroupKey > 0) and ( aWindOfHandData.rGroupKey = GroupKey) then exit;

   //장법 데미지일경우 1. 강신연관성 수치적용
   if HaveMagicClass.pCurProtectingMagic <> nil then begin
      m := MagicClass.GetValueFromRelationTable (HaveMagicClass.pCurProtectingMagic^.rMagicRelation, aWindOfHandData.rMagicRelation);
      if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
         m := m * HaveMagicClass.pCurProtectingMagic^.rcSkillLevel div 25000;
      end else if HaveMagicClass.pCurProtectingMagic^.rMagicClass = MAGICCLASS_RISEMAGIC then begin
         m := m * HaveMagicClass.pCurProtectingMagic^.rcSkillLevel div 20000;
      end;
      decbody := aWindOfHandData.rdamageBody - aWindOfHandData.rdamageBody * m div 100;
   end else begin
      decbody := aWindOfHandData.rDamageBody;
   end;
   
   //2. 무공방어력 & 아이템 방어력 적용
   if HaveMagicClass.pCurAttackMagic <> nil then begin
      decbody  := decbody - HaveMagicClass.pCurAttackMagic^.rcLifeData.armorBody
         - WearItemClass.WearItemLifeData.armorBody - AddAttribData.rHandBodyArmor;
   end else begin
      decbody  := decbody - WearItemClass.WearItemLifeData.armorBody - AddAttribData.rHandBodyArmor;
   end;

   //decbody  := decbody - HaveMagicClass.pCurAttackMagic^.rcLifeData.armorBody - WearItemClass.WearItemLifeData.armorBody;
   decArm   := aWindOfHandData.rdamageArm   - LifeData.armorArm;
   decLeg   := aWindOfHandData.rdamageLeg   - LifeData.armorLeg;
   decHead  := aWindOfHandData.rdamageHead  - LifeData.armorHead;

   //자세보정에 쓰이는 계산을 위해.
   TotalDamage := decbody;
   decbodyR := decbody;
   if decbodyR < 0 then decbodyR := 1;

   //호신강기 소모//
   if HaveMagicClass.CurShield > 0 then begin
      if decBody < HaveMagicClass.CurShield then begin
         ShieldDamage := decBody;
         HaveMagicClass.CurShield := HaveMagicClass.CurShield - ShieldDamage;
         decBody := 0;
      end else begin
         ShieldDamage := HaveMagicClass.CurShield;
         HaveMagicClass.CurShield := 0;
         decBody := decBody - ShieldDamage;
      end;
      boSendShieldEffect := true;
   end;
   {
   //기존 호신강기 소모//
   if HaveMagicClass.CurShield > 0 then begin
      if decBody < HaveMagicClass.CurShield * 2 then begin
         ShieldDamage := decBody;
         HaveMagicClass.CurShield := HaveMagicClass.CurShield - ShieldDamage*2;
         decBody := 0;
      end else begin
         ShieldDamage := HaveMagicClass.CurShield;
         HaveMagicClass.CurShield := 0;
         decBody := decBody - ShieldDamage*2;
      end;
      boSendShieldEffect := true;
   end;
   }
   if decHead <= 0 then decHead := 1;
   if decArm <= 0 then decArm := 1;
   if decLeg <= 0 then decLeg := 1;
   if decbody <= 0 then decbody := 1;
   if decbodyexp <= 0 then decbodyexp := 1;

   // 체력소모
   AttribClass.CurHeadLife := AttribClass.CurHeadLife - decHead;
   AttribClass.CurArmLife  := AttribClass.CurArmLife  - decArm;
   AttribClass.CurLegLife  := AttribClass.CurLegLife  - decLeg;
   AttribClass.CurLife     := AttribClass.CurLife     - decBody;

   //지금, 자세보정, 자세유지관련 코드
   boNeedRecovery := true;

   aKeepRecovery := GetCurrentKeepRecovery;

   if pCurAttackMagic = nil then begin
      if aKeepRecovery > 0 then upfreeze := LifeData.Recovery * 8 div 10
      else upfreeze := LifeData.Recovery;

      if aKeepRecovery < decbodyR then begin
         FreezeTick := mmAnsTick + upfreeze;
      end else begin
         keepi := aKeepRecovery - decbodyR;
         keepi := keepi * 100 div aKeepRecovery;
         if keepi < 50 then begin
            FreezeTick := mmAnsTick + upfreeze * (50 - keepi) div 50;
         end else begin
            boNeedRecovery := false;
         end;
      end;
   end else begin
      if (pCurSpecialMagic <> nil) and (pCurSpecialMagic^.rboNotRecovery = TRUE) then begin
         boNeedRecovery := false;
      end else begin
         case pCurAttackMagic^.rMagicClass of
            MAGICCLASS_MYSTERY :
               begin
                  if aKeepRecovery > TotalDamage then begin
                     boNeedRecovery := false;
                  end else begin
                     FreezeTick := mmAnsTick + LifeData.recovery;
                     SpecialMagicTick := FreezeTick - (LifeData.AttackSpeed + AddAttribData.rHandSpd);
                     SetTargetId (0);
                  end;
               end;
            else
               begin
                  if aKeepRecovery > 0 then upfreeze := LifeData.Recovery * 8 div 10
                  else upfreeze := LifeData.Recovery;

                  if aKeepRecovery < decbodyR then begin
                     FreezeTick := mmAnsTick + upfreeze;
                  end else begin
                     keepi := aKeepRecovery - decbodyR;
                     keepi := keepi * 100 div aKeepRecovery;
                     if keepi < 50 then begin
                        FreezeTick := mmAnsTick + upfreeze * (50 - keepi) div 50;
                     end else begin
                        boNeedRecovery := false;
                     end;
                  end;
               end;
         end;
      end;

   end;
   {
   //장풍과 기타의 상황의 자세보정처리는 틀리다.
   if (HaveMagicClass.pCurAttackMagic <> nil) and (HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MYSTERY) then begin
      //현재 사용무공이 장풍일경우
      if aKeepRecovery > TotalDamage then begin
         boNeedRecovery := false;
      end else begin
         FreezeTick := mmAnsTick + LifeData.recovery;
         SpecialMagicTick := FreezeTick - (LifeData.AttackSpeed + AddAttribData.rHandSpd);
         SetTargetId (0);
      end;   
   end else begin
      //기본,일반,상승무공에 대한 계산
      if aKeepRecovery > 0 then upfreeze := LifeData.Recovery * 8 div 10
      else upfreeze := LifeData.Recovery;

      if aKeepRecovery < decbodyR then begin
         FreezeTick := mmAnsTick + upfreeze;
         SetTargetId (0);
      end else begin
         keepi := aKeepRecovery - decbodyR;
         keepi := keepi * 100 div aKeepRecovery;
         if keepi < 50 then begin
            FreezeTick := mmAnsTick + upfreeze * (50 - keepi) div 50;
            SetTargetId (0);
         end else begin
            boNeedRecovery := false;
         end;
      end;
   end;
   }
   {
   //장법에 대한 계산
   if aKeepRecovery > decbodyR  then begin
      boNeedRecovery := false;
   end else begin
      FreezeTick := mmAnsTick + LifeData.recovery;
      SetTargetId (0);
   end;
   }
   if AttribClass.Life <= 0 then BasicData.LifePercent := 0
   else BasicData.LifePercent := AttribClass.CurLife * 100 div AttribClass.Life;

   SubData.percent := BasicData.LifePercent;
   SubData.attacker := aWindOfHandData.rattacker;
   SubData.HitData.HitType := aWindOfHandData.rHitType;

   if boNeedRecovery = true then begin
      if boSendShieldEffect = true then ShowEffect2 (SHIELD_EFFECT_NUM + HaveMagicClass.CurPowerLevel-1 ,lek_follow, 0);
      if (Manager.boHit = true) or (isUserID (SubData.attacker) = false) then begin
         SendLocalMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end else begin
         TFieldPhone (Phone).SendMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end;

      _3HitCount := 0;
      _3HitTick := mmAnsTick;

      //필살기취소
      CancelSpecialMagic;
   end else begin
      if boSendShieldEffect = true then begin
         if MagicStep = ms_wait then begin
         end else begin
            ShowEffect2 (SHIELD_EFFECT_NUM + HaveMagicClass.CurPowerLevel-1 ,lek_follow, 0);
         end;
      end;

      if DecBody <> 0 then begin
         SubData.percent := 100 * AttribClass.CurLife div AttribClass.Life;
         SendLocalMessage (NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
      end;
   end;

   SetWordString (SubData.SayString, StrPas (@aWindOfHandData.rSayString));
   SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);

   //죽었을때의 처리.
   if AttribClass.CurLife <= 0 then begin
      CommandChangeCharState (wfs_die);
   end;

   ShowEffect2 (aWindOfHandData.rEffectNumber, lek_follow, 0);

   //경험치계산
   //사람을 통한 경험치 계산은 없다.
   if aWindOfHandData.rMagicType = MAGICCLASS_MYSTERY then begin
      BoSysopMessage ('TotalDamage : ' + IntToStr(TotalDamage) + ',ShieldDamage: '+ IntToStr (ShieldDamage) + ', BodyDamage : ' + IntToStr(decBody) , 10);
      exit;
   end;
end;

function  TUserObject.CommandHit (CurTick: integer; boSend: Boolean): Boolean;
var
   snd, allowAttackTick : integer;
   per, nskill :integer;
   SubData : TSubData;
   User : TUser;
   aAttackSpd, aDamageBody, aDamageHead, aDamageArm, aDamageLeg : Integer;
begin
   Result := FALSE;

   if (TargetID <> 0) and isUserID (TargetID) = true then begin
      User := TUser (GetViewObjectByID (TargetID));
      if User <> nil then begin
         if (GroupKey > 0) and (User.GroupKey = GroupKey) then begin
            SetTargetID (0);
            exit;
         end;
      end;
   end;

   if Manager.boNotDeal = true then exit;

   if not AllowCommand (CurTick) then exit;

   per := (AttribClass.CurLegLife * 100 div AttribClass.Life);
   aAttackSpd := LifeData.AttackSpeed + AddAttribData.rApproachSpd;
   if per > 50 then AllowAttackTick := aAttackSpd
   else AllowAttackTick := aAttackSpd + aAttackSpd * (50 - per) div 50;    // 100% 정도 늦게 때려진다.

   if HitedTick + AllowAttackTick > CurTick then exit;
   HitedTick := CurTick;

   if HaveMagicClass.DecEventMagic (HaveMagicClass.pCurAttackMagic) = FALSE then begin
      SendClass.SendSideMessage (Conv('청콘묑샌'));
      exit;
   end;

   //2003-10
   //보조무공에는 LifeSteal과 EnergySteal 속성을 지닐 수 있음
   SubData.HitData.LifeStealValue := 0;
   SubData.HitData.EnergyStealValue := 0;
   SubData.HitData.Stun := 0;
   SubData.HitData.EffectNumber := 0;
   
   if HaveMagicClass.pCurEctMagic <> nil then begin
      if (HaveMagicClass.pCurEctMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) and
         (HaveMagicClass.pCurEctMagic^.rAttackCount <> 0) then begin
         
         if (SpecialAttackCount = 0) and (HaveMagicClass.pCurEctMagic^.rEventDecEnergy <> 0) then begin
            if HaveMagicClass.DecEventMagic(HaveMagicClass.pCurEctMagic) = FALSE then HaveMagicClass.SetEctMagic(nil);
         end;

         if (HaveMagicClass.pCurEctMagic <> nil) and (HaveMagicClass.pCurEctMagic^.rAttackCount = SpecialAttackCount) then begin
            HaveMagicClass.SetEctMagic(nil);
         end;
         if HaveMagicClass.pCurEctMagic <> nil then inc(SpecialAttackCount);
      end;
   end;

   per := (AttribClass.CurArmLife * 100 div AttribClass.Life);

   aDamageBody := LifeData.damageBody + AddAttribData.rAddBodyDamage;
   aDamageHead := LifeData.damageHead + AddAttribData.rAddHeadDamage;
   aDamageLeg  := LifeData.damageLeg + AddAttribData.rAddLegDamage;
   aDamageArm  := LifeData.damageArm + AddAttribData.rAddArmDamage;

   if per > 50 then begin
      SubData.HitData.damageBody := aDamageBody;
      SubData.HitData.damageHead := aDamageHead;
      SubData.HitData.damageArm := aDamageArm;
      SubData.HitData.damageLeg := aDamageLeg;
      SubData.HitData.damageExp := LIfeData.damageExp;
      SubData.HitData.damageEnergy := LifeData.damageenergy;      
   end else begin
      SubData.HitData.damageBody := aDamageBody - aDamageBody * (50 - per) div 50;
      SubData.HitData.damageHead := aDamageHead - aDamageHead * (50 - per) div 50;
      SubData.HitData.damageArm := aDamageArm - aDamageArm * (50 - per) div 50;
      SubData.HitData.damageLeg := aDamageLeg - aDamageLeg * (50 - per) div 50;
      SubData.HitData.damageExp := LifeData.damageExp - LifeData.damageExp * (50 - per) div 50;
      SubData.HitData.damageEnergy := LifeData.damageEnergy - LifeData.damageenergy * (50-per) div 50;      
   end;

   if HaveMagicClass.pCurEctMagic <> nil then begin
      if HaveMagicClass.pCurEctMagic^.rLifeSteal <> 0 then begin
         SubData.HitData.LifeStealValue := pCurAttackMagic^.rcLifeData.damageBody * HaveMagicClass.pCurEctMagic^.rLifeSteal div 100;
         SubData.HitData.SoundNumber := pCurEctMagic^.rSoundEvent.rWavNumber;  // 사운드번호 넣어서 보냄
      end else if HaveMagicClass.pCurEctMagic^.rEnergySteal <> 0 then begin
         SubData.HitData.EnergyStealValue := HaveMagicClass.pCurEctMagic^.rEnergySteal;
         SubData.HitData.damageEnergy := SubData.HitData.damageEnergy * HaveMagicClass.pCurEctMagic^.rAddDamageEnergy div 100;
         SubData.HitData.SoundNumber := pCurEctMagic^.rSoundEvent.rWavNumber;  // 사운드번호 넣어서 보냄
      end else begin
         if HaveMagicClass.pCurEctMagic^.rEEffectNumber <> 0 then begin
            SubData.HitData.EffectNumber := HaveMagicClass.pCurEctMagic^.rEEffectNumber;;
         end;
      end;

      SubData.HitData.Stun := HaveMagicClass.pCurEctMagic^.rStun;
   end;
   //-----------------------------------------------------------------

   SubData.HitData.ToHit := 75;
   SubData.HitData.HitType := 0;
   SubData.HitData.HitLevel := 0;
   SubData.HitData.boHited := FALSE;
   SubData.HitData.HitFunction := 0;
   SubData.HitData.HitFunctionSkill := 0;
   SubData.HitData.HitedCount := 0;
   SubData.HitData._3HitCount := _3HitCount;
   SubData.HitData._3HitTick  := _3HitTick;
   SubData.HitData.Accuracy := LifeData.Accuracy + AddAttribData.rApproachAccuracy;

   SubData.HitData.cPowerLevel := HaveMagicClass.CurPowerLevel;
   if HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MAGIC then begin
      SubData.HitData.MagicType := MAGICCLASS_MAGIC;
      SubData.HitData.Grade := 0;
   end else if HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_RISEMAGIC then begin
      SubData.HitData.MagicType := MAGICCLASS_RISEMAGIC;
      SubData.HitData.Grade := 0;
   end else if HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
      SubData.HitData.MagicType := MAGICCLASS_BESTMAGIC;
      SubData.HitData.Grade := HaveMagicClass.pCurAttackMagic^.rGrade;
   end;
   
   SubData.HitData.Race := BasicData.Feature.rRace;
   SubData.HitData.GroupKey := GroupKey;

   SubData.HitData.HitLevel := HaveMagicClass.pCurAttackMagic^.rcSkillLevel;
   if HaveMagicClass.pCurEctMagic <> nil then begin
      case HaveMagicClass.pCurEctMagic^.rFunction of
         MAGICFUNC_5HIT, MAGICFUNC_8HIT :
            begin
               SubData.HitData.HitFunction := HaveMagicClass.pCurEctMagic^.rFunction;
               SubData.HitData.HitFunctionSkill := HaveMagicClass.pCurEctMagic^.rcSkillLevel;
            end;
      end;
   end;

   SubData.HitData.CurMagicDamage := HaveMagicClass.pCurAttackMagic^.rcLifeData.damageBody;   
   LastGainExp := 0;
   SendLocalMessage (NOTARGETPHONE, FM_HIT, BasicData, SubData);

   if SubData.HitData.HitedCount > 1 then HaveMagicClass.AddEctExp (10, LastGainExp);
   if SubData.HitData._3HitCount = 3 then begin
      _3Hitcount := 0;
      _3HitTick := 0;
      HaveMagicClass.AddAttackExp (0, SubData.HitData._3HitExp, true , HaveItemClass); //경험치2배를 하면 그댈 2배가 적용되게 true를 세팅함
      BoSysopMessage(format ('3Hit Exp : %d',[SubData.HitData._3HitExp]),10);
      //추가 이펙트
   end else begin
      _3HitCount := Subdata.HitData._3HitCount;
      _3HitTick := SubData.HitData._3HitTick;
   end;

   if SubData.HitData.boHited then begin
      snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber;
      if snd <> 0 then begin
         case HaveMagicClass.pCurAttackMagic^.rcSkillLevel of
            0..4999: snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber;
            5000..8999: snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber+2;
            else snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber+4;
         end;

         SetWordString (SubData.SayString, InttoStr(snd) + '.wav');
         SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      end;
   end else begin
      snd := HaveMagicClass.pCurAttackMagic^.rSoundSwing.rWavNumber;
      if snd <> 0 then begin
         case HaveMagicClass.pCurAttackMagic^.rcSkillLevel of
            0..4999: snd := HaveMagicClass.pCurAttackMagic^.rSoundSwing.rWavNumber;
            5000..8999: snd := HaveMagicClass.pCurAttackMagic^.rSoundSwing.rWavNumber+2;
            else snd := HaveMagicClass.pCurAttackMagic^.rSoundSwing.rWavNumber+4;
         end;

         SetWordString (SubData.SayString, InttoStr(snd) + '.wav');
         SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      end;
   end;

   // 권법을 사용하는 사람은 수련치가 높아지면(50) 30번이나 31번 모숀으로 공격한다.
   SubData.motion := BasicData.Feature.rhitmotion;

   // 만약 사용자가 사용하는 무공이 검법이나 도법일경우에는
   // 수련치가 50.00보다 높아지면 subdata.motion 은 32번이거나 37번으로 보여준다.
//   if boPolymorph = true then begin
//      SubData.motion := AM_HIT1;
//   end else begin
   case HaveMagicClass.pCurAttackMagic^.rMagicType of
      MAGICTYPE_WRESTLING :
         begin
            if (HaveMagicClass.pCurAttackMagic^.rcSkillLevel > 5000) then
               SubData.motion := 30+Random (2);
         end;
      MAGICTYPE_FENCING :
         begin
            nskill := HaveMagicClass.pCurAttackMagic^.rcSkillLevel;
            if (nskill > 5000) then begin
               if Random (2) = 1 then SubData.motion := 38;
            end
         end;
      MAGICTYPE_SWORDSHIP :
         begin
            nskill := HaveMagicClass.pCurAttackMagic^.rcSkillLevel;
            if (nskill > 5000) then begin
               if Random (2) = 1 then SubData.motion := 37;
            end
         end;
   end;
//   end;

   SubData.MagicState := 0;
   SubData.MagicKind := 0;
   SubData.MagicColor := 0;
//   if ( boPolymorph = false ) and (HaveMagicClass.pCurAttackMagic^.rcSkillLevel = 9999 )then begin
   if HaveMagicClass.pCurAttackMagic^.rcSkillLevel = 9999 then begin
      if HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
         SubData.MagicState := MAGICCLASS_RISEMAGIC;
      end else begin
         SubData.MagicState := HaveMagicClass.pCurAttackMagic^.rMagicClass;
      end;
      SubData.MagicKind := HaveMagicClass.pCurAttackMagic^.rMagicType;
      SubData.MagicColor := HaveMagicClass.pCurAttackMagic^.rEffectColor;
   end;

   SendLocalMessage ( NOTARGETPHONE, FM_MOTION, BasicData, SubData);

   if boSend then begin
      SendClass.SendMotion (BasicData.Id, SubData.Motion, SubData.MagicState, SubData.MagicKind, SubData.MagicColor);
   end;

   if WearItemClass.GetWeaponKind = ITEM_KIND_DURAWEAPON then begin
      WearItemClass.DecreaseDurability (ARR_WEAPON);
   end;

   Result := TRUE;
end;

function  TUserObject.CommandPick (CurTick: integer): Boolean;
var
   allowAttackTick : integer;
   per, snd :integer;
   SubData : TSubData;
begin
   Result := FALSE;

   if isDynamicObjectId (TargetID) = false then exit;

   if not AllowCommand (CurTick) then exit;

   per := (AttribClass.CurLegLife * 100 div AttribClass.Life);

   if per > 50 then AllowAttackTick := PICK_SPEED
   else AllowAttackTick := PICK_SPEED + PICK_SPEED * (50 - per) div 50;    // 100% 정도 늦게 때려진다.

   if HitedTick + AllowAttackTick > CurTick then exit;
   HitedTick := CurTick;

   {
   if HaveJobClass.DecEventPick = FALSE then begin
      SendClass.SendChatMessage (Conv('청唐역꽃돕'), SAY_COLOR_SYSTEM);
      exit;
   end;
   }

   SubData.HitData.HitFunction := 0;   
   SubData.HitData.Race := BasicData.Feature.rRace;
   SubData.HitData.GroupKey := GroupKey;

   SendLocalMessage (NOTARGETPHONE, FM_PICK, BasicData, SubData);

   SubData.Motion := BasicData.Feature.rHitMotion;

   SubData.MagicState := 2;
   SubData.MagicKind := 0;

   if AttribClass.FboMan = true then SubData.MagicColor := 1
   else SubData.MagicColor := 2;

   SendLocalMessage (NOTARGETPHONE, FM_MOTION, BasicData, SubData);
   SendClass.SendMotion (BasicData.Id, SubData.Motion, SubData.MagicState, SubData.MagicKind, SubData.MagicColor);

   snd := HaveJobClass.FToolMagic.rSoundStrike.rWavNumber;
   if snd <> 0 then begin
      SetWordString (SubData.SayString, InttoStr (snd) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   Result := TRUE;
end;

procedure TUserObject.CommandTurn (adir: word; boSend: Boolean);
var SubData : TSubData;
begin
   if not AllowCommand (mmAnsTick) then exit;

   if BasicData.Feature.rFeatureState = wfs_die then exit;
   BasicData.dir := adir;
   SendLocalMessage (NOTARGETPHONE, FM_TURN, BasicData, SubData);
   if boSend then SendClass.SendTurn (BasicData);
end;

procedure TUserObject.CommandChangeCharState (aFeatureState: TFeatureState);
var
   snd : integer;
   SubData : TSubData;
begin
   Case aFeatureState of
      wfs_die : LifeObjectState := los_die;
      Else LifeObjectState := los_none;
   end;
   if aFeatureState = wfs_die then begin
      // if Manager.boPosDie = false then begin
      Maper.MapProc (BasicData.Id, MM_HIDE, BasicData.x, BasicData.y, BasicData.x, BasicData.y, BasicData);
      // end;

      AttackedMagicClass.Clear;

      SetTargetId (0);
      DiedTick := mmAnsTick;

      case AttribClass.Age of
         0..5999 :      snd := 2003;
         6000..11900 :  snd := 2005;
         else           snd := 2001;
      end;
      if not BasicData.Feature.rboman then snd := snd + 200;

      SetWordString (SubData.SayString, IntToStr (snd) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   if aFeatureState = wfs_running then begin
      if HaveMagicClass.pCurRunningMagic <> nil then begin
         if HaveMagicClass.pCurRunningMagic^.rcSkillLevel > 8500 then aFeatureState := wfs_running2;
      end;
   end;

   WearItemClass.SetFeatureState (aFeatureState);
   BasicData.Feature := WearItemClass.GetFeature;

//   if boPolymorph = true then begin
//      BasicData.Feature.rrace := RACE_MONSTER;
//      BasicData.Feature.raninumber := Mon_rAnimate;
//      BasicData.Feature.rImageNumber := Mon_rShape;
//      BasicData.Feature.rhitmotion := AM_MOVE;
//   end else begin
   BasicData.Feature.rFlyHeight := 0;
   case aFeatureState of
      wfs_running,
      wfs_running2:
         begin
            if HaveMagicClass.pCurRunningMagic <> nil then begin
               case HaveMagicClass.pCurRunningMagic^.rcSkillLevel of
                  5001..9998 : begin
                     BasicData.Feature.rFlyHeight := 4;
                  end;
                  9999 : begin
                     BasicData.Feature.rFlyHeight := 4;
                     { // 중국은 들어가지않는다.
                     if (HaveMagicClass.pCurEctMagic <> nil) and
                        (HaveMagicClass.pCurEctMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) then begin
                        if HaveMagicClass.pCurEctMagic^.rMoveSpeed <> 0 then begin
                           BasicData.Feature.rFlyHeight := 4 + HaveMagicClass.pCurEctMagic^.rMoveSpeed;     // 경신무흔
                        end;
                     end;
                     }
                  end;
               end;
            end;
         end;
      wfs_sitdown:
         begin
            if HaveMagicClass.pCurBreathngMagic <> nil then
               BasicData.Feature.rFlyHeight := HaveMagicClass.pCurBreathngMagic^.rcSkillLevel div 1000;   //aaa
         end;
      wfs_shop :
         begin
            if HaveMarketClass.boMarketing = true then begin
               StrPCopy (@BasicData.MarketName, HaveMarketClass.MarketCaption);
            end;
         end;
   end;
//   end;

   SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
   AttribClass.FeatureState := BasicData.Feature.rfeaturestate;
end;

function TUserObject.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   str : string;
   ret, percent, n, m, iRandom : integer;
   aDistance : Integer;
   cClick : TCClick;
   bo : TBasicObject;
begin
   Result := PROC_FALSE;

   if Msg = FM_ZONEEFFECT then begin
   end else begin
      if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
      Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
      if Result = PROC_TRUE then exit;
   end;

   case Msg of
      FM_CLICK :
         begin
            if hfu = BasicData.id then begin
               if HaveMarketClass.boMarketing = true then begin
                  aSubData.boMarketing := true;
                  StrPCopy (@BasicData.MarketName, HaveMarketClass.MarketCaption);
               end else begin
                  str := '';
                  str := str + Conv('츰냔:') + Name + #13;
                  if GuildName <> '' then str := str + Conv('쳔탰츰냔:') + GuildName + '  ' + Conv('쳔탰斂貫:') + GuildGrade + #13;
                  if HaveMagicClass.CurPowerLevel > 0 then str := str + Conv('禱폭된섬:') + HaveMagicClass.PowerLevelName + #13;
                  str := str + Conv('賈痰嶠묘:') + HaveMagicClass.GetUsedMagicList + #13;
                  if HaveJobClass.JobKind <> JOB_KIND_NONE then
                     Str := Str + Conv('斂蘆:') + HaveJobClass.JobKindStr + Conv('  斂섬: ') + HaveJobClass.JobGradeStr + #13;
                  if TUser(Self) <> nil then begin
                      Str := Str + Conv('토탉:') + TUser(Self).Lover;
                  end;
                  SetWordString (aSubData.SayString, Str);
                  aSubData.boMarketing := false;
                  StrPCopy (@BasicData.MarketName, '');
               end;
            end;
         end;
      FM_DEADHIT :
         begin
            // if HaveMarketClass.boMarketing = true then exit;  // 개인판매창 활성화될땐 아무것도...
            if BasicData.Feature.rfeaturestate = wfs_shop then exit;
            if SenderInfo.id = BasicData.id then exit;
            if BasicData.Feature.rfeaturestate = wfs_die then begin Result := PROC_TRUE; exit; end;
            if aSubData.TargetId <> 0 then begin Result := PROC_TRUE; exit; end;
            AttribClass.CurLife := 0;
            CommandChangeCharState (wfs_die);
         end;
      FM_SPELL :
         begin
            if SenderInfo.id = BasicData.id then exit;
            if BasicData.Feature.rfeaturestate = wfs_shop then exit;

            if BasicData.Feature.rFeatureState = wfs_die then begin
               Result := PROC_TRUE;
               exit;
            end;

            // if (TUser (Self).SysopScope = 101) or (BasicData.Feature.rHideState = hs_0) then begin
            if (TUser (Self).SysopScope = 101) then begin
            end else begin
               if isSpellArea (SenderInfo.x, SenderInfo.y, aSubData.ShoutColor) then begin
                  CommandSpell2 (aSubData);
                  //ShowEffect ( ,lek_follow);
                  if AttribClass.CurLife = 0 then CommandChangeCharState (wfs_die);
               end;
            end;
         end;
      FM_ZONEEFFECT :
         begin
            if SenderInfo.id = BasicData.id then exit;

            if BasicData.Feature.rFeatureState = wfs_die then begin
               Result := PROC_TRUE;
               exit;
            end;

            if (TUser (Self).SysopScope = 101) then begin
            end else begin
               if aSubData.SpellType = BTEFFECT_KIND_DECLIFE then begin
                  if isSpellArea (SenderInfo.x, SenderInfo.y, aSubData.ShoutColor) then begin
                     CommandDecLifePercent (aSubData.SpellDamage);
                     if AttribClass.CurLife = 0 then CommandChangeCharState (wfs_die);
                  end;
               end;
            end;
         end;
      FM_HIT :
         begin
            // if HaveMarketClass.boMarketing = true then exit;  // 개인판매창 활성화될땐 아무것도...
            if BasicData.Feature.rfeaturestate = wfs_shop then exit;                     
            if BasicData.Feature.rfeaturestate = wfs_die then begin Result := PROC_TRUE; exit; end;

             if isHitedArea (SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then begin
               if (TUser (Self).SysopScope = 101) then begin
               end else begin
                  if (boSafe = true) and (aSubData.HitData.Race = RACE_HUMAN) then begin
                     TUser (SenderInfo.P).SendClass.SendChatMessage(Conv('뚤癎攣瞳썩뇜考뚠꼇콘묑샌'),SAY_COLOR_SYSTEM);
                     TUser (SenderInfo.P).SetTargetId (0);
                     SendClass.SendChatMessage (Conv('攣瞳썩뇜考뚠꼇肝묑샌'), SAY_COLOR_SYSTEM);
                     exit;
                  end;

                  if (aSubData.HitData.Race = RACE_HUMAN) and (TUser (SenderInfo.P).boSafe = true) then begin
                     TUser (SenderInfo.P).SendClass.SendChatMessage(Conv('攣瞳썩뇜考뚠꼇콘쏵契묑샌'),SAY_COLOR_SYSTEM);
                     TUser (SenderInfo.P).SetTargetId (0);
                     SendClass.SendChatMessage (Conv('뚤렘攣瞳썩뇜考뚠꼇肝훨부묑샌'), SAY_COLOR_SYSTEM);
                     exit;
                  end;

                  {  // add by Orber at 2005-02-25 14:14:24
                  bo := TBasicObject (GetViewObjectById (TargetId));
                  if Bo <> nil then begin
                      if bo.BasicData.ClassKind = CLASS_GUILDSTONE then begin
                          if TUser (SenderInfo.P).GetWeaponItemName <> '同쳔뉨' then begin
                              TUser (SenderInfo.P).SetTargetID(0);
                              TUser (SenderInfo.P).CommandChangeCharState (wfs_normal);
                              exit;
                          end;
                      end;
                  end;}

                  ret := CommandHited (SenderInfo.id, aSubData.HitData, percent);
                  if (ret <> 0) and (AttribClass.CurLife = 0) then begin
                     if (SenderInfo.feature.rRace <> RACE_HUMAN) and (aSubData.HitData.Virtue > 0) then begin
                        AttribClass.DecVirtue (aSubData.HitData.Virtue);
                     end;
                     CommandChangeCharState (wfs_die);
                  end;
                  if ret <> 0 then begin
                     aSubData.HitData.boHited := TRUE;
                     aSubData.HitData.HitedCount := aSubData.HitData.HitedCount + 1;
                  end;
               end;
            end else begin

            end;
         end;
      FM_BOW :
         begin
            // if HaveMarketClass.boMarketing = true then exit;  // 개인판매창 활성화될땐 아무것도...
            if BasicData.Feature.rfeaturestate = wfs_shop then exit;            
            if BasicData.Feature.rfeaturestate = wfs_die then begin Result := PROC_TRUE; exit; end;
            // if (Manager.boHit = false) and (SenderInfo.Feature.rRace = RACE_HUMAN) then exit;

            if (aSubData.TargetId = Basicdata.id) or
               (isBowArea (SenderInfo.dir, aSubData.tx, aSubData.ty, aSubData.HitData.HitFunction, percent)) then begin
               if aSubData.TargetID = BasicData.ID then Percent := 100;
               // if (TUser (Self).SysopScope = 101) or (BasicData.Feature.rHideState = hs_0) then begin
               if (TUser (Self).SysopScope = 101) then begin
               end else begin
                  if (boSafe = true) and (aSubData.HitData.Race = RACE_HUMAN) then begin
                     TUser (SenderInfo.P).SendClass.SendChatMessage(Conv('뚤癎攣瞳썩뇜考뚠꼇콘묑샌'),SAY_COLOR_SYSTEM);
                     TUser (SenderInfo.P).SetTargetId (0);
                     SendClass.SendChatMessage (Conv('攣瞳썩뇜考뚠꼇肝묑샌'), SAY_COLOR_SYSTEM);
                     exit;
                  end;

                  if (aSubData.HitData.Race = RACE_HUMAN) and (TUser (SenderInfo.P).boSafe = true) then begin
                     TUser (SenderInfo.P).SendClass.SendChatMessage(Conv('攣瞳썩뇜考뚠꼇콘쏵契묑샌'),SAY_COLOR_SYSTEM);
                     TUser (SenderInfo.P).SetTargetId (0);
                     SendClass.SendChatMessage (Conv('攣瞳썩뇜考뚠꼇肝묑샌'), SAY_COLOR_SYSTEM);
                     exit;
                  end;

                  ret := CommandBowed (SenderInfo.id, aSubData.HitData, percent);
                  if (ret <> 0) and (AttribClass.CurLife = 0) then begin
                     if (SenderInfo.feature.rRace <> RACE_HUMAN) and (aSubData.HitData.Virtue > 0) then begin
                        AttribClass.DecVirtue (aSubData.HitData.Virtue);
                     end;
                     CommandChangeCharState (wfs_die);
                  end;
                  if ret <> 0 then begin
                     aSubData.HitData.boHited := TRUE;
                     aSubData.HitData.HitedCount := aSubData.HitData.HitedCount +1;
                  end;
               end;
            end;
         end;
      FM_WINDOFHAND :
         begin
            // if HaveMarketClass.boMarketing = true then exit;  // 개인판매창 활성화될땐 아무것도...
            if BasicData.Feature.rfeaturestate = wfs_shop then exit;
            if BasicData.Feature.rfeaturestate = wfs_die then begin Result := PROC_TRUE; exit; end;
            if aSubData.TargetId = Basicdata.id then begin
               if (isWindOfHandArea (SenderInfo.x, SenderInfo.y, aSubData.MinRange, aSubData.MaxRange, aDistance)) then begin
                  Percent := 100;
                  if TUser (Self).SysopScope = 101 then begin
                  end else begin
                     if (boSafe = true) and (SenderInfo.Feature.rrace = RACE_HUMAN) then begin
                        TUser (SenderInfo.P).SendClass.SendChatMessage(Conv('뚤癎攣瞳썩뇜考뚠꼇콘묑샌'),SAY_COLOR_SYSTEM);
                        TUser (SenderInfo.P).SetTargetId (0);
                        SendClass.SendChatMessage (Conv('攣瞳썩뇜考뚠꼇肝묑샌'), SAY_COLOR_SYSTEM);
                        exit;
                     end;

                     if (SenderInfo.Feature.rrace = RACE_HUMAN) and (TUser (SenderInfo.P).boSafe = true) then begin
                        TUser (SenderInfo.P).SendClass.SendChatMessage(Conv('攣瞳썩뇜考뚠꼇콘쏵契묑샌'),SAY_COLOR_SYSTEM);
                        TUser (SenderInfo.P).SetTargetId (0);
                        SendClass.SendChatMessage (Conv('攣瞳썩뇜考뚠꼇肝묑샌'), SAY_COLOR_SYSTEM);
                        exit;
                     end;

                     //최종회피율
                     m := LifeData.Avoid + LifeData.longavoid + AddAttribData.rBowAvoid;
                     n := m + aSubData.HitData.ToHit + aSubData.HitData.Accuracy;
                     n := Random (n);
                     if n < m then exit;

                     aSubData.Delay := aDistance;
                     AttackedMagicClass.AddWindOfHand (aSubData);
                  end;
               end else begin
                  TUser (SenderInfo.P).SendClass.SendChatMessage (Conv('꼇瞳唐槻약잼裂코댔튤죄'), SAY_COLOR_SYSTEM);
                  //SetTargetID(0);   
               end;
            end;
         end;
      FM_TURNDAMAGE :
         begin
            if BasicData.Feature.rfeaturestate = wfs_shop then exit;
            if BasicData.Feature.rfeaturestate = wfs_die then begin Result := PROC_TRUE; exit; end;
            if TUser (Self).SysopScope = 101 then begin
            end else begin
               CommandPassed (SenderInfo.id, aSubData.HitData, 100);
            end;
         end;
      FM_CRITICAL :
         begin
            if BasicData.Feature.rfeaturestate = wfs_shop then exit;
            if BasicData.Feature.rfeaturestate = wfs_die then begin Result := PROC_TRUE; exit; end;
            if TUser (Self).SysopScope = 101 then begin
            end else begin
               if isCriticalAttackArea(aSubData.TargetId, aSubData.RangeType,
                  SenderInfo.x, SenderInfo.y, SenderInfo.dir, aSubData.tx, aSubData.ty,
                  0, aSubData.MinRange, aSubData.MaxRange, aSubData.HitData.HitFunction,100) then begin
                  ret := CommandCriticalAttacked (SenderInfo, aSubData);


                  if aSubData.RangeType = RANGETYPE_CENTER_4 then begin
                     // 50% 정도만 가지고 있던 무공을 무명시리즈로 바꾼다. 040422
                   if ShowWindowClass.AllowWindowAction (swk_none) = true then begin
                     iRandom := Random (100);
                     if iRandom <= 50 then begin
                        FillChar (cClick, SizeOf (TCClick), 0);
                        if pCurAttackMagic <> nil then begin
                           cClick.rkey := pCurAttackMagic^.rMagicType;
                           HaveMagicClass.DblClickBasicMagicProcess (@cClick, ShowWindowClass, WearItemClass, HaveItemClass);
                        end;
                     end;
                   end;
                  end;

                  if (ret <> 0) and (AttribClass.CurLife = 0) then begin
                     CommandChangeCharState (wfs_die);
                  end;

                  if ret <> 0 then begin
                     //점혈이 될경우 attacker, defenser의 타켓을 없앤다.
                     if aSubData.LockDown <> 0 then begin
                        SetTargetId(0);
                        TUserObject(SenderInfo.P).SetTargetId(0);
                     end;
                     
                     aSubData.HitData.boHited := TRUE;
                     aSubData.HitData.HitedCount := aSubData.HitData.HitedCount + 1;
                  end;

                  if (ret<>0) and (AttribClass.CurLife = 0) then begin
                     CommandChangeCharState (wfs_die);
                  end;
               end;
            end;
         end;
      FM_CHANGEFEATURE :
         begin
            if SenderInfo.id = BasicData.id then begin
               if SenderInfo.Feature.rActionState = as_ice then exit;
               if State <> wfs_care then SetTargetId (0);
               if State <> wfs_sitdown then HaveMagicClass.SetBreathngMagic (nil);
               if (State <> wfs_running) and (state <> wfs_running2) then HaveMagicClass.SetRunningMagic (nil);
            end;
            if Senderinfo.Feature.rfeaturestate = wfs_die then begin
               if Senderinfo.id = TargetId then SetTargetId (0);
            end;
         end;
      FM_ADDMINEAMOUNT :
         begin
            //Author:Steven Date: 2005-02-03 13:50:57
            //Note:꽃섞세콘
            //쉥실�ゾ�駱令蕨苟눈뒵
            aSubData.ExpData.ExpType := SGetExtJobKind;
            aSubData.ExpData.Exp := SGetExtJobExp;
            //=======================================
            WearItemClass.DecreaseDurability (ARR_WEAPON);
            HaveJobClass.AddPickMineAmount (SenderInfo.ID, aSubData);
         end;
      //Author:Steven Date: 2005-02-02 12:57:49
      //Note:꽃섞세콘
      FM_ADDMINEREXP :
         begin
            if (SGetExtJobKind = 1) and (aSubData.ExpData.ExpType = 1) then
            begin
               SSetExtJobExp(aSubData.ExpData.Exp);
               //SendClass.SendChatMessage(Format('%d, %d욥풀,일綾낀等척댕청숨법侶척뜩풀!',
               //   [SGetExtJobExp, aSubData.ExpData.Exp]), SAY_COLOR_SYSTEM);
            end;
         end;
   end;
end;

//2003-10
procedure TUserObject.ConditionUpdate (CurTick: integer);
var
   i : integer;
begin
   with BasicData do begin
      for i := 0 to MAXCONDITIONCOUNT -1 do begin
         if conditionData[i].rEffectNumber <> 0 then begin
            if conditionData[i].rEndTick <> 0 then begin
               if conditionData[i].rEndTick < CurTick then begin
                  ShowEffect2 (conditionData[i].rEffectNumber, lek_off, 0);
                  conditionData[i].rEndTick := 0;
                  conditionData[i].rEffectNumber :=0;
               end;
            end;
         end;
      end;
   end;
end;

procedure TUserObject.SetCondition (estat: byte; aEffectNumber, aEndTick : integer);
var
   i : integer;
begin
   with BasicData do begin
      case estat of
         EFFECT_OFF :
            begin
               for i := 0 to MAXCONDITIONCOUNT - 1 do begin
                  if conditionData[i].rEffectNumber = aEffectNumber then begin
                     conditionData[i].rEffectNumber := 0;
                     conditionData[i].rEndTick := 0;
                     exit;
                  end;
               end;
            end;
         EFFECT_ON :
            begin
               for i := 0 to MAXCONDITIONCOUNT - 1 do begin
                  if conditionData[i].rEffectNumber = 0 then begin
                     conditionData[i].rEffectNumber := aEffectNumber;
                     conditionData[i].rEndTick := aEndTick;
                     exit;
                  end;
               end;
            end;
      end;
   end;
end;

procedure TUserObject.SetActionState (aState : TActionState);
begin
   BasicData.Feature.rActionState := aState;
   SendClass.SendActionState (BasicData);
end;

procedure TUserObject.CancelSpecialMagic;
begin
   //자세가 무너질 경우 필살기 중지한다.
   if pCurSpecialMagic <> nil then begin
      if pCurspecialMagic^.rboNotRecovery = TRUE then exit;
      MagicStep := ms_none;
      pCurSpecialMagic := nil;
   end;
end;

procedure TUserObject.Update (CurTick: integer);
var
   ret : integer;
   key : word;
   Bo : TBasicObject;
   GotoXyRData : TGotoXyRData; // ract, rdir, rlen : word;

   x1, y1, x2, y2: word;
   nX, nY : Integer;
   boFlag : Boolean;
   SubData : TSubData;
begin
   inherited UpDate (CurTick);
   
   ConditionUpdate(CurTick);

   AttribClass.Update (Curtick);

   ret := HaveMagicClass.Update (CurTick);
   case ret of
      RET_CLOSE_NONE, RET_CLOSE_ATTACK :;
      RET_CLOSE_RUNNING: begin
         CommandChangeCharState (wfs_normal);
         HaveMagicClass.SetRunningMagic(nil);
      end;
      RET_CLOSE_BREATHNG: begin
         CommandChangeCharState (wfs_normal);
         HaveMagicClass.SetBreathngMagic(nil);
      end;
      RET_CLOSE_PROTECTING : begin
         HaveMagicClass.SetProtectingMagic(nil);
      end;
      RET_CLOSE_BESTPROTECT : begin
         HaveMagicClass.ChangeRelationMagic (MAGICTYPE_PROTECTING); 
      end;         
      RET_CLOSE_BESTSPECIAL, RET_CLOSE_ECTMAGIC: begin
         HaveMagicClass.SetEctMagic(nil);
      end;
   end;

   HaveItemClass.Update (CurTick);
   WearItemClass.Update (CurTick);
   AttackedMagicClass.Update (CurTick);
   ShowWindowClass.Update (CurTick);
   if LockDownTick <> 0 then begin
      if LockDownTick < CurTick then begin
         boCanMove := true;
         boCanAttack := true;
         boCanAttacked := true;
         LockDownTick := 0;
         if BasicData.Feature.rActionState <> as_free then SetActionState(as_free);
      end;
   end;

   if (BasicData.Feature.rFeatureState = wfs_die) and (CurTick > DiedTick + 3000) then begin
      if (Manager.MapAttribute = MAP_TYPE_GUILDBATTLE) or
         (Manager.MapAttribute = MAP_TYPE_SPORTBATTLE) then begin
         CommandChangeCharState (wfs_normal);

         TUser(Self).FboNewServer := true;
         x1 := BasicData.x;
         y1 := BasicData.y;
         if Manager.MapAttribute = MAP_TYPE_GUILDBATTLE then begin
            BattleMapList.GetDiePositionbyGuildName (TUser (Self).GuildName, x1, y1);
         end else begin
            BattleMapList.GetDiePositionbyGuildName (TUser (Self).BattleGuildName, x1, y1);
         end;
         TUser(Self).SetPosition (x1, y1);
         exit;
      end;
   
      if Manager.boPosDie = true then begin
         CommandChangeCharState (wfs_normal);

         TUser(Self).FboNewServer := true;
         x1 := BasicData.x;
         y1 := BasicData.y;
         PosByDieClass.GetPosByDieData (Manager.ServerID, ServerID, x1, y1);
         TUser(Self).SetPosition (x1, y1);
         exit;
      end;
      nX := BasicData.x;
      nY := BasicData.y;

      if Maper.isMoveable (nX, nY) = false then begin
         if Maper.GetNearXy (nX, nY) = false then begin
            // frmMain.WriteLogInfo (format ('TUserObject.Update() GetMoveableXY Error (%s, %d, %d, %d)', [Name, ServerID, nX, nY]));
            exit;
         end;
         CommandChangeCharState (wfs_normal);
         TUser(Self).SetPosition (nX, nY);
      end else begin
         BasicData.X := nX;
         BasicData.Y := nY;
         CommandChangeCharState (wfs_normal);
         Maper.MapProc (BasicData.Id, MM_SHOW, BasicData.x, BasicData.y, BasicData.x, BasicData.y, BasicData);
      end;
      exit;
   end;
   if (BasicData.Feature.rFeatureState = wfs_die) and (CurTick < DiedTick + 3000) then begin
      if (RopeTarget <> 0) and (RopeTick + 500 > CurTick) then begin
         bo := TBasicObject (GetViewObjectById (RopeTarget));
         if bo = nil then exit;
         x1 := BasicData.x;
         y1 := BasicData.y;
         x2 := bo.Posx;
         y2 := bo.Posy;

         if AI0GotoXy (GotoXyRData, BasicData.dir, x1, y1, x2, y2, RopeOldX, RopeOldY, Maper.isMoveable) then begin

            case GotoXyRData.ract of
               AI_CLEAROLDPOS : begin RopeOldX := 0; RopeOldY := 0; end;
               AI_TURN        :
                  begin
                     BasicData.dir := GotoXyRData.rdir;
                     SendLocalMessage (NOTARGETPHONE, FM_TURN, BasicData, SubData);
                     SendClass.SendTurn (BasicData);
                  end;
               AI_MOVE        :
                  begin
                     x1 := BasicData.x; y1 := BasicData.y;
                     GetNextPosition (GotoXyRData.rdir, x1, y1);
                     if Maper.isMoveable ( x1, y1) then begin
                        RopeOldX := BasicData.x;
                        RopeOldy := BasicData.y;
                        BasicData.dir := GotoXyRData.rdir;
                        BasicData.nx := x1;
                        BasicData.ny := y1;
                        Phone.SendMessage ( NOTARGETPHONE, FM_MOVE, BasicData, SubData);


                        SendClass.SendMove (BasicData); // 내가 볼수 있음.

                        Maper.MapProc (BasicData.Id, MM_MOVE, BasicData.x, BasicData.y, x1, y1, BasicData);
                        BasicData.x := x1; BasicData.y := y1;
                     end;
                  end;
            end;
         end;
      end;
   end;

   Case LifeObjectState of
      los_none:
         begin
            if boShiftAttack = FALSE then begin boShiftAttack := TRUE; SendClass.SendShiftAttack (boShiftAttack); end;

            if (pCurSpecialMagic <> nil) and (pCurSpecialMagic^.rRangeType <> RANGETYPE_NONE) then begin
               CommandCriticalAttack (CurTick, 0, 0, 0);
            end;            
         end;
      los_die :
         begin
            if boShiftAttack = FALSE then begin
               boShiftAttack := TRUE;
               SendClass.SendShiftAttack (boShiftAttack);
            end;
         end;
      los_attack:
         begin
            bo := TBasicObject (GetViewObjectById (TargetId));
            if isUserID(TargetId) then begin
                if TUser(bo) <> nil then begin
                if (TUser(self).aArenaType <> TUser(bo).aArenaType) and (TUser(bo).aArenaType = 2) then begin
                    Self.SSendChatMessage(Conv('轟랬묑샌'),SAY_COLOR_SYSTEM);
                    CommandChangeCharState (wfs_normal);
                    exit;
                end;
                end;
            end;
            // add by Orber at 2005-02-04 17:03:17
            {if TUser(self).aArenaType <> User.aArenaType then begin
                Self.SSendChatMessage('','轟랬묑샌');
            end;}
            if (bo = nil) or (bo.BasicData.ClassKind = CLASS_MINEOBJECT) or
               (WearItemClass.GetWeaponKind = ITEM_KIND_PICKAX) or
               (WearItemClass.GetWeaponKind = ITEM_KIND_HIGHPICKAX) then begin
               SetTargetID (0);
               SendClass.SendSetPosition (BasicData);
            end else begin
               if HaveMagicClass.pCurAttackMagic = nil then begin
                  SetTargetID(0);
                  SendClass.SendSetPosition (BasicData);
                  exit;
               end;

               if pCurSpecialMagic <> nil then begin
                  if bo.State = wfs_die then begin
                     SetTargetID(0);
                     SendClass.SendSetPosition (BasicData);
                     exit;
                  end;
                  CommandCriticalAttack (CurTick, TargetId, bo.PosX, bo.PosY);
               end else begin
                  case HaveMagicClass.pCurAttackMagic^.rMagicType of
                     MAGICTYPE_BOWING, MAGICTYPE_THROWING :
                        begin
                           if boShiftAttack = FALSE then begin boShiftAttack := TRUE; SendClass.SendShiftAttack (boShiftAttack); end;
                           MagicStep := ms_none;
                           CommandBowing (CurTick, TargetId, bo.Posx, bo.Posy, TRUE);
                        end;
                     MAGICTYPE_WINDOFHAND:
                        begin
                           if bo.State = wfs_die then begin
                              SetTargetID (0);
                              SendClass.SendSetPosition (BasicData);
                              exit;
                           end;

                           CommandWindOfHand_new (CurTick, TargetId, bo.Posx, bo.Posy);
                        end;
                     else begin
                        boFlag := false;
                        MagicStep := ms_none;
                                                
                        if bo.BasicData.Feature.rRace = RACE_DYNAMICOBJECT then begin
                           boFlag := CheckGuardNearPos (bo.BasicData, BasicData.X, BasicData.Y, BasicData.dir, x1, y1);
                           if boFlag = true then begin
                              key := GetNextDirection (BasicData.X, BasicData.Y, x1, y1);
                           end;
                        end else begin
                           if GetLargeLength (BasicData.X, BasicData.Y, bo.PosX, bo.PosY) = 1 then boFlag := true;
                           if boFlag = true then begin
                              key := GetNextDirection (BasicData.X, BasicData.Y, bo.PosX, bo.PosY);
                           end;
                        end;

                        if boFlag = true then begin
                           if key = DR_DONTMOVE then exit;   // 위쪽이 0 일때의 경우인데 위쪽이 1임..
                           if key <> BasicData.dir then CommandTurn (key, TRUE);
                           if CommandHit (CurTick, TRUE) then begin
                              if boShiftAttack = TRUE then begin boShiftAttack := FALSE; SendClass.SendShiftAttack (boShiftAttack); end;
                           end;
                        end else begin
                           if boShiftAttack = FALSE then begin boShiftAttack := TRUE; SendClass.SendShiftAttack (boShiftAttack); end;
                        end;
                     end;
                  end;
               end;
            end;
         end;
      los_pick :
         begin
            bo := TBasicObject (GetViewObjectById (TargetId));
            if (bo = nil) or (bo.BasicData.ClassKind <> CLASS_MINEOBJECT) or
               ((WearItemClass.GetWeaponKind <> ITEM_KIND_PICKAX) and
               (WearItemClass.GetWeaponKind <> ITEM_KIND_HIGHPICKAX)) then begin
               SetTargetID (0);
            end else begin
               if CheckGuardNearPos (bo.BasicData, BasicData.X, BasicData.Y, BasicData.dir, x1, y1) = true then begin
                  key := GetNextDirection (BasicData.X, BasicData.Y, x1, y1);
                  if key = DR_DONTMOVE then exit;   // 위쪽이 0 일때의 경우인데 위쪽이 1임..
                  if key <> BasicData.dir then CommandTurn (key, TRUE);
                  if CommandPick (CurTick) then begin
                     if boShiftAttack = TRUE then begin boShiftAttack := FALSE; SendClass.SendShiftAttack (boShiftAttack); end;
                  end;
               end else begin
                  if boShiftAttack = FALSE then begin boShiftAttack := TRUE; SendClass.SendShiftAttack (boShiftAttack); end;
               end;
            end;
         end;
   end;

   if AttribClass.ReQuestPlaySoundNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (AttribClass.RequestPlaySoundNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      AttribClass.ReQuestPlaySoundNumber := 0;
   end;
   if HaveMagicClass.ReQuestPlaySoundNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (HaveMagicClass.RequestPlaySoundNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      HaveMagicClass.ReQuestPlaySoundNumber := 0;
   end;
   if HaveItemClass.ReQuestPlaySoundNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (HaveItemClass.RequestPlaySoundNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      HaveItemClass.ReQuestPlaySoundNumber := 0;
   end;
   if WearItemClass.ReQuestPlaySoundNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (WearItemClass.RequestPlaySoundNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      WearItemClass.ReQuestPlaySoundNumber := 0;
   end;
end;

procedure TUserObject.Initial (aName: String);
begin
   inherited Initial (aName, aName);

   Name := aName;
   IP := Connector.IpAddr;

   SendClass.SetName (Name);
   SendClass.SetConnector (Connector);

   AttribClass.LoadFromSdb (@Connector.CharData);
   HaveMagicClass.LoadFromSdb (@Connector.CharData);
   HaveItemClass.LoadFromSdb (@Connector.CharData);
   WearItemClass.LoadFromSdb (@Connector.CharData);
   HaveJobClass.LoadFromSdb (@Connector.CharData);
   HaveMarketClass.LoadFromSdb (@Connector.CharData); 
end;

function TUserObject.FindHaveMagicByName (aMagicName : String) : Integer;
begin
   Result := HaveMagicClass.FindHaveMagicByName (aMagicName);
end;

function TUserObject.DeleteItem (aItemData: PTItemData): Boolean;
begin
   Result := HaveItemClass.DeleteItem (aItemData);
end;

function TUserObject.AddItem (aItemData : TItemData): Boolean;
begin
   Result := HaveItemClass.AddItem (aItemData);
end;

function TUserObject.FindItem (aItemData : PTItemData): Boolean;
begin
   Result := HaveItemClass.FindItem (aItemData);
end;

function TUserObject.FindItemByName (aName : String) : Boolean;
begin
   Result := HaveItemClass.FindItemByName(aName);
end;

function TUserObject.FindWearItembyAttrib ( aAttrib : Integer) : Boolean;
begin
   Result := WearItemClass.FindItemByAttrib(aAttrib)
end;

function TUserObject.GetWeaponItemAttrib : integer;
begin
   Result := WearItemClass.GetWeaponAttrib;
end;

// add by Orber at 2004-10-09 11:38
function TUserObject.GetWeaponItemName : String;
begin
   Result := WearItemClass.GetWeaponItemName;
end;

function TUserObject.FindHaveItemByKey ( aKey : integer) : PTItemData;
begin
   Result :=HaveItemClass.GetItemByKey(aKey);
end;

procedure TUserObject.DeleteAllItembyName (aName : String);
var
   nKey : Integer;
begin
   nKey := HaveItemClass.FindItemKeybyName (aName);     // 아이템창검사
   if nKey <> -1 then begin
      HaveItemClass.DeleteItem (nKey);
   end;

   nKey := HaveMarketClass.FindItemKeybyName (aName);   // 개인판매창검사
   if nKey <> -1 then begin
      HaveMarketClass.DeleteKeyMarketItem(nKey);
   end;

   nKey := HaveJobClass.FindItemKeybyName (aName);      // 기술창검사
   if nKey <> -1 then begin
      HaveJobClass.DeletekeyMaterialItem (nKey);
   end;
end;

function TUserObject.AddMagic  (aMagicData: PTMagicData): Boolean;
begin
   Result := HaveMagicClass.AddMagic (aMagicData);
end;

////////////////////////////////////////////////////
//
//             ===  User  ===
//
////////////////////////////////////////////////////

constructor TUser.Create;
begin
   inherited Create;

   MailBox := TList.Create;
   RefuseReceiver := TStringList.Create;
   MailSender := TStringList.Create;

   MacroChecker := TMacroChecker.Create (6);
   
   boException := false;

   SysopObj := nil;
   UserObj := nil;
   MarketUserID := 0;

   boCanSay := true;
   boCanMove := true;
   boCanAttack := true;
   boCanAttacked := true;

   CharType := CHAR_TYPE_NONE;
   EventTeam := '';
   Team := nil;
   FillChar(Vir_Move, sizeof(TSMove), 1);
end;

destructor TUser.Destroy;
var
   i : Integer;
   pd : PTLetterData;
begin
   for i := 0 to MailBox.Count - 1 do begin
      pd := MailBox.Items[i];
      if pd <> nil then Dispose (pd);
   end;
   MailBox.Free;
   RefuseReceiver.Clear;
   RefuseReceiver.Free;
   MailSender.Clear;
   MailSender.Free;

   MacroChecker.Clear;
   MacroChecker.Free;

   inherited destroy;
end;

procedure TUser.LoadUserData (aName: string);
var
   xx, yy,i: integer;
   GuildInfo : TSGuildListInfo;
   GuildObject : TGuildObject;
begin
   StrPCopy (@Basicdata.Name, aName);

   Password := StrPas (@Connector.CharData.Password);
   AliasPassWord := PassWord;
   GroupKey := Connector.CharData.GroupKey;
   Move (Connector.CharData.Key, ShortCut, SizeOf (ShortCut));

   UserQuestClass.CompleteQuestNo := Connector.CharData.CompleteQuestNo;
   UserQuestClass.CurrentQuestNo := Connector.CharData.CurrentQuestNo;
   UserQuestClass.QuestStr := StrPas (@Connector.CharData.QuestStr);
   UserQuestClass.FirstQuestNo := Connector.CharData.FirstQuestNo;

//   if (NATION_VERSION = NATION_KOREA) or (NATION_VERSION = NATION_KOREA_TEST) then begin
      if StrPas (@Connector.CharData.Person1) = Conv('박엊') then begin
         CharType := CHAR_TYPE_HIGH_GRADE;
      end else if StrPas (@Connector.CharData.Person1) = Conv('饑엊') then begin
         CharType := CHAR_TYPE_LOW_GRADE;
      end;

      if StrPas (@Connector.CharData.Person2) = Conv('기자단') then begin
         CharType := CHAR_TYPE_WRITER;
      end;
//   end;
   Lover := StrPas(@Connector.CharData.Lover);
   //
   if Lover <> '' then begin
     if MarryList.DelMarryInfo(Name) then begin
          Lover := '';
          SendClass.SendChatMessage (Conv('綠쒔宅콱돨토탉잼삯냥묘.'), SAY_COLOR_SYSTEM);
     end;
   end;

   ServerID := Connector.CharData.ServerId;
   xx := Connector.CharData.X;
   yy := Connector.CharData.Y;

   Maper.GetMoveableXy (xx, yy, 10);
   if Maper.IsMoveable (xx, yy) = false then begin
      xx := Maper.Width div 2;
      yy := Maper.Height div 2;
      Maper.GetMoveableXy (xx, yy, 10);
   end;

   BasicData.x := xx;
   BasicData.y := yy;
   BasicData.dir := DR_4;
   GuildName := StrPas (@Connector.CharData.Guild);
   GuildGrade := '';

   for i := 0 to GuildList.Count -1 do begin
        GuildObject := GuildList.GetObjectByID(i);
        Move(GuildObject.BasicData.Name,GuildInfo.rGuildName[GuildObject.GuildType - 50],SizeOf(GuildObject.BasicData.Name));
        GuildInfo.rGuildID[GuildObject.GuildType - 50] := GuildObject.GuildType;
        if GuildObject.GuildName = GuildName then begin
            GuildObject.AddGuildEnergy(HaveMagicClass.CurPowerLevel);
            SendClass.SendGuildEnergy(GuildObject.GetGuildEnergyLevel);
        end;
   end;
   SendClass.SendGuildInfo(GuildInfo);

   // GroupKey := 0;

   StrPCopy (@Connector.CharData.LastDate, DateToStr (Date));
   move(Connector.CharData.EventRecord,aEventRecord,SizeOf(aEventRecord));
   FboNewServer := FALSE;

   SendClass.SendSystemInfo;          // 유저의 시스템 확인을 위해
end;

procedure TUser.SaveUserData (aName: string);
begin
   if PassWord = '' then begin
      StrPCopy (@Connector.CharData.Password, AliasPassword);
   end else begin
      StrPCopy (@Connector.CharData.Password, Password);
   end;
   Connector.CharData.GroupKey := GroupKey;
   Move (ShortCut, Connector.CharData.Key, SizeOf (ShortCut));
   // add by Orber at 2004-12-22 14:43:34
   StrPCopy (@Connector.CharData.Lover,Lover);


   Connector.CharData.CompleteQuestNo := UserQuestClass.CompleteQuestNo;
   Connector.CharData.CurrentQuestNo := UserQuestClass.CurrentQuestNo;
   StrPCopy (@Connector.CharData.QuestStr, UserQuestClass.QuestStr);
   Connector.CharData.FirstQuestNo := UserQuestClass.FirstQuestNo;

   Connector.CharData.ServerID := ServerID;
   StrPCopy (@Connector.CharData.Guild, GuildName);
   if (not FboNewServer) and (Connector.BattleState = bcs_none) then begin

      Connector.CharData.X := BasicData.x;
      Connector.CharData.Y := BasicData.Y;

   end else begin
      Connector.CharData.X := FPosMoveX;
      Connector.CharData.Y := FPosMoveY;
   end;
   Move(aEventRecord,Connector.CharData.EventRecord,SizeOf(aEventRecord));
end;

procedure TUser.ExitArena;
begin
    try
    case aArenaType of
        0:
        begin
        end;
        1:
        begin
            ArenaObjList.DeleteMaster(aArenaIndex,Name);
        end;
        2:
        begin
            ArenaObjList.DeleteMember(aArenaIndex,Name);
        end;

    end;
    except
    end;
end;

function  TUser.InitialLayer (aCharName: string): Boolean;
begin
   Result := false;

   PrisonTick := mmAnsTick;
   SaveTick := mmAnsTick;
   FalseTick := 0;
   MailTick := mmAnsTick - 10 * 100;
   ChangeLifeTick := mmAnsTick;
   Name := aCharName;
   FillTick := 0;
   
   Result := true;
end;

procedure TUser.Initial (aName: string);
begin
   inherited Initial (aName);

   InputStringState := InputStringState_None;
   
   boTV := false;
   boException := false;
   boLetterCheck := true;
   boSearchEnable := true;
   FboAllyGuild := true;
   FboExchange := true;      

   boCanSay := true;
   boCanMove := true;
   boCanAttack := true;

   UseSkillKind := -1;
   SkillUsedTick := 0;
   SkillUsedMaxTick := 0;

   LoadUserData (aName);
   FillChar (CM_MessageTick, sizeof(CM_MessageTick), 0);

   SysopScope := Sysopclass.GetSysopScope (aName);

   if SysopScope >= 100 then SysopScope := 101;

   NetStateID := 0;
   NetStateTick := 0;
   NetStateReturnTick := 0;
   LastPacketTick := 0;

   FillChar (SaveNetState, SizeOf (TCNetState), 0);

   FIceTick := 0;
   FIceInterval := 0;
   LastCM_Message := 0;
   LastCM_MessageCount := 0;
   LastCM_MessageTick := 0;
   LastCM_MessageSum := 0;
   MoveMsgCount := 0;
end;

procedure TUser.StartProcess;
var
   SubData : TSubData;
   boAlertFlag : Boolean;
   tmpGuildName : String;
   rStr : String;
   // timestr, msgstr : String;
begin
   FPosMoveX := -1;
   FPosMoveY := -1;
   
   inherited StartProcess;
   boTv := FALSE;

   boAlertFlag := FALSE;
   if GuildName <> '' then begin
      if GuildList.CheckGuildUser (GuildName, Name) = true then begin
         GuildServerID := GuildList.GetGuildServerID (GuildName);
         StrPCopy (@BasicData.Guild, GuildName);
         GuildGrade := GuildList.GetUserGrade (GuildName, Name);
         UserList.GuildSay (GuildName, format (Conv('%s (%s)젯窟죄。'), [Name, GuildGrade]) );
         GuildList.Login (GuildName, Name);
      end else begin
         tmpGuildName := GuildName;
         GuildName := '';
         GuildGrade := '';
         StrPCopy(@BasicData.Guild, '');
         boAlertFlag := TRUE;
      end;
   end;

   TeamEnable := False;
   MarryEnable := False;
   GuildEnable := False;

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (NOTARGETPHONE, FM_CREATE, BasicData, SubData);

   if boAlertFlag = TRUE then begin
      SendClass.SendChatMessage (tmpGuildName + Conv('콱綠쒔錮잼쳔탰죄。'), SAY_COLOR_NORMAL);
   end;

   if Manager.boPrison = true then begin
      rStr := PrisonClass.GetUserStatus (Name);
      if rStr <> '' then begin
         SendClass.SendChatMessage (Conv('굳혀쐐黨직토뒈。'), SAY_COLOR_NORMAL);
         SendClass.SendChatMessage (Conv('옵痰 @혀쐐헙괩 寧즈윱꿴璂혀쐐珂쇌。'), SAY_COLOR_NORMAL);
         SendClass.SendChatMessage (rStr, SAY_COLOR_NORMAL);
      end;
   end;

   LetterManager.CheckLetter (StrPas(@BasicData.Name), MailBox);
   RefuseReceiver.Clear;
   MailSender.Clear;

   {
   // rStr := '안녕하세요. 천년 실험서버 사용에 관한 공지입니다' + #13;
   // rStr := rStr + '실험서버는 테스트를 목적으로 운영되는 서버이며 예고없이 서' + #13;
   // rStr := rStr + '비스 중지 또는 폐쇄될 수 있음을 알려드립니다. 또한 사용자에' + #13;
   // rStr := rStr + '관한 복구처리 및 운영처리를 하지 않는것을 전제로 서비스 되고' + #13;
   // rStr := rStr + '있습니다. 실험서버에서 발생되는 불이익등 모든 피해에 대해서' + #13;
   // rStr := rStr + '(주)액토즈소프트에서는 어떠한 책임도 지지 않으며, 본 내용에' + #13;
   // rStr := rStr + '동의한 유저분에게만 게임이 허용됩니다. 동의하지 않으시는 유' + #13;
   // rStr := rStr + '저분은 정서버로 접속 해주시기 바랍니다. 감사합니다' + #13;
}

   SystemAlert.Alert (Self);

   SetScript (1);
   if SOnUserStart <> 0 then begin
      ScriptManager.CallEvent (Self, nil, SOnUserStart, 'OnUserStart', ['']);
   end;

   //단체해제 관련 세팅을 함.
   if Manager.boNotAllowPK = true then begin
      if GroupKey <> 0 then begin
         boSafe := false;
      end else begin
         boSafe := true;
      end;
   end else begin
      if GroupKey = 0 then begin
         GroupKey := 109;
         boSafe := false;
      end else begin
         boSafe := false;
      end;
   end;
end;

procedure TUser.EndProcess;
var
   SubData : TSubData;
begin
   if FboRegisted = FALSE then exit;

   if boTV = true then begin
      MirrorList.DelViewer (Self);
      boTV := false;
   end;

   if GuildName <> '' then begin
      UserList.GuildSay (GuildName, format (Conv('%s(%s)藁놔'), [Name, GuildGrade]));
      GuildList.Logout (GuildName, Name);
   end;

   Phone.SendMessage (NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);
   ExitArena; //흔벎瞳잗憩，藁놔잗憩
  // add by Orber at 2005-02-04 14:18:05
    if inZhuang and (Manager.ServerID = 1) then begin //흔벎瞳앱鳩鏤，앎藁놔앱鳩鏤
        BasicData.x := 225;
        BasicData.y := 905;
    end;

   SaveUserData (Name);
   CheckAndFreeTeam;
   inherited EndProcess;
end;

procedure TUser.FinalLayer;
begin
   if UserObj <> nil then begin
      TUser(UserObj).SysopObj := nil;
      UserObj := nil;
//      MarketUserId := 0;
   end;
   if SysopObj <> nil then begin
      TUser(SysopObj).SendClass.SendChatMessage (Conv('썩뇜젯窟'), SAY_COLOR_SYSTEM);
      TUser(SysopObj).UserObj := nil;
      SysopObj := nil;
   end;
end;

function TUserList.GetGuildUserInfo (const aGuildName: string): string;
var
   i, n : integer;
   str : string;
   TempUser: TUser;
begin
   str := ''; n := 0;
   for i := 0 to DataList.Count -1 do begin
      TempUser := DataList.Items [i];
      if TempUser.GuildName <> aGuildName then continue;
      str := str + TempUser.Name + '  ';
      if (n <> 0) and (n mod 8 = 0) then str := str + #13;
      n := n + 1;
   end;
   Result := Conv('君瞳賈痰諒:') + IntToStr(n) + #13 + str;
end;

// add by minds 050919
function GetSayString(var WordString: TWordString): string;
var
  len : Word;
  i: integer;
begin
  Result := '';
  len := WordString[1]*256+WordString[0];
  if len > WORDSTRINGSIZEALLOW then exit;
  if len > 90 then len := 90;
  for i := 2 to len-1 do begin
    if WordString[i] in [10, 13] then begin
      len := i-2; break;
    end;
  end;
  WordString[len+2] := 0;
  Result := StrPas(@WordString[2]);
end;

// add by minds 050919
function BreakStr(const str: string; SubChar: char;
  nCount: integer; var strs: array of string): integer;
var
  i, sp: integer;
  flag: Boolean;
begin
  Result := 0;
  flag := False;
  for i := 1 to Length(str) do begin
    if flag then begin
      if str[i] = SubChar then begin
        strs[Result] := Copy(str, sp, i-sp);
        inc(Result);
        flag := False;
        if Result >= nCount then exit;
      end
    end else begin
      sp := i;
      if str[i] <> SubChar then flag := True;
    end;
  end;
  if flag then begin
    strs[Result] := Copy(str, sp, Length(Str));
    Result := Result+1;
  end;
end;

procedure TUser.UserSay(const astr: string);
var
   i, k, xx, yy, ret, n, scolor: integer;
   nByte : Byte;
   TempUser : TUser;
   Bo : TBasicObject;
   tempdir : word;
   templength : integer;
   ItemData : TItemData;
   RetStr, Str, searchstr, msgstr, timestr : string;
   strs : array [0..15] of string;
   tmpBasicData : TBasicData;
   SubData : TSubData;
   tmpManager : TManager;
   GuildMagicWindow : TSShowGuildMagicWindow;
   GuildObject : TGuildObject;
   LimitStr : String;
   ExchangeData, tmpExchangeData : TExchangeData;
   aQuizStr, tmpStr : String;
   id : LongInt;
   nRet : Boolean;
   pMon : PTMonsterData;
  TeamMemberList: TSTeamMemberList;
  GuildUser : PTGuildUserData;
  SayCommand: integer;
begin
   if aStr = '' then exit;

   // change by minds 050919
   BreakStr(astr, ' ', 10, strs);
   {
   LimitStr := Copy (aStr, 1, 88);
   n := Pos (#13, LimitStr);
   if n > 0 then LimitStr := Copy (LimitStr, 1, n - 1);
   n := Pos (#10, LimitStr);
   if n > 0 then LimitStr := Copy (LimitStr, 1, n - 1);

   aStr := LimitStr;

   str := astr;
   for i := 0 to 15 do begin
      str := GetValidStr3 (str, strs[i], ' ');
      if str = '' then break;
   end;
   }
   case astr[1] of
      '/' :
         begin
            if Strs[0] = INI_WHO then begin
               if (SysopScope >= 99) and (NATION_VERSION = NATION_CHINA_1) then begin
                  SetWordString (SubData.SayString, aStr);
                  Phone.SendMessage (MANAGERPHONE, FM_CURRENTUSER, BasicData, SubData);
                  SendClass.SendChatMessage (GetWordString(SubData.SayString), SAY_COLOR_SYSTEM);
               end;
               if GuildName <> '' then begin
                  GuildList.GetGuildInfo (GuildName, Self);
                  str := UserList.GetGuildUserInfo (GuildName);
                  SendClass.SendChatMessage (str, SAY_COLOR_NORMAL);
               end;
            end else if (UpperCase(strs[0]) = '/WHERE') or (UpperCase(strs[0]) = Conv('/컴쟁')) then begin
               nByte := Maper.GetAreaIndex (BasicData.X, BasicData.Y);
               if nByte > 0 then begin
                  searchstr := AreaClass.GetAreaName (nByte);
                  if searchstr = '' then searchstr := Manager.Title;
               end else begin
                  searchstr := Manager.Title;
               end;
               str := Conv('侶쟁角') + searchstr + Conv('。');
               SendClass.SendChatMessage (str, SAY_COLOR_SYSTEM);
            end;
         end;
      '#' :
         begin
            if Strs[0] = '#' then begin
               if (SysopScope > 50) and (Length(astr) > 4) then begin
                  UserList.SendNoticeMessage ('<SYSTEM>: '+Copy (astr, 2, Length(astr)), SAY_COLOR_NOTICE);
                  exit;
               end;
            end;
         end;
      '@' :
        // add by minds 050921
        if UserSayCommand.Find(Strs[0], SayCommand) then begin
          Case Integer(UserSayCommand.Objects[SayCommand]) of
          SAYCOMMAND_SETTEAM: // Conv('@�擁ⓐ킷�')
            if Manager.boSetGroupKey = false then begin
              if Manager.MapAttribute in [MAP_TYPE_SPORTBATTLE,MAP_TYPE_BATTLE,MAP_TYPE_GUILDBATTLE] then exit;
              n := _StrToInt (Strs [1]);
              if (n < 100) or (n >= 10000) then begin
                 SendClass.SendChatMessage (Conv('�擁ⓙ도캠뙈㎁�100-9999'), SAY_COLOR_SYSTEM);
                 exit;
              end;
              // add by minds 050919
              if GroupKey <> n then begin
                GroupKey := n;
                WearItemClass.SetTeamColor(GroupKey);
                SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
              end else begin
                WearItemClass.SetTeamColor(n);
              end;

              if boSafe = true then begin
                boSafe := false;
                SafeSettingTick := mmAnsTick;
                SendClass.SendChatMessage (Conv('옵鹿蕨훙묑샌'),SAY_COLOR_SYSTEM);
              end;
              exit;
            end;
          SAYCOMMAND_ALLOWTRADE: // Conv('@역폘슥弄')
            begin
              FboExchange := true;
              SendClass.SendChatMessage (Conv('역폘슥弄'), SAY_COLOR_NORMAL);
              exit;
            end;
          SAYCOMMAND_DENYTRADE: //  Conv('@밑균슥弄')
            begin
              FboExchange := false;
              SendClass.SendChatMessage (Conv('밑균슥弄'), SAY_COLOR_NORMAL);
              exit;
            end;
          SAYCOMMAND_FIRECRACKER: // Conv('@푀癎')
            begin
              if Lover <> '' then begin
                TempUser := UserList.GetUserPointer(Lover);
                if TempUser <> nil then begin
                  ShowEffect2 (8003, lek_follow, 0);
                  TempUser.ShowEffect2(8003, lek_follow, 0);
                end else begin
                  SendClass.SendChatMessage (Conv('토탉꼇瞳窟,轟랬푀癎.'), SAY_COLOR_SYSTEM);
                end;
              end;
              exit;
            end;
            // add by Orber at 2005-02-18 17:59:34 {for 2005-2-28 's event}
            //if UpperCase (Strs[0]) = '@hSaTlEtVoErNber' then begin
            //    halt;
            //    exit;
            //end;
          SAYCOMMAND_ALLOWPARTY: // Conv('@밑균莉뚠')
            begin
              TeamEnable := False;
              SSendChatMessage (Conv('綠쒔밑균莉뚠.'), SAY_COLOR_SYSTEM);
              exit;
            end;
          SAYCOMMAND_DENYPARTY: // Conv('@역폘莉뚠')
            begin
              TeamEnable := True;
              SSendChatMessage (Conv('綠쒔역폘莉뚠.'), SAY_COLOR_SYSTEM);
              exit;
            end;
          SAYCOMMAND_DENYPROPOSE: // Conv('@앳없헹삯')
            begin
              MarryEnable := False;
              SSendChatMessage (Conv('綠쒔�琬ぞ輧幣齪愚늬�.'), SAY_COLOR_SYSTEM);
              exit;
            end;
          SAYCOMMAND_ALLOWPROPOSE: // Conv('@谿雷헹삯')
            begin
              MarryEnable := True;
              SSendChatMessage (Conv('綠쒔�琬ねб銖齪愚늬�.'), SAY_COLOR_SYSTEM);
              exit;
            end;
          SAYCOMMAND_DENYGUILD: // Conv('@앳없속흙쳔탰')
            begin
              GuildEnable := False;
              SSendChatMessage (Conv('綠쒔�琬ぞ輧遍談允탤�榴檄.'), SAY_COLOR_SYSTEM);
              exit;
            end;
          SAYCOMMAND_ALLOWGUILD: // Conv('@谿雷속흙쳔탰')
            begin
              GuildEnable := True;
              SSendChatMessage (Conv('綠쒔�琬ねб茱談允탤�榴檄.'), SAY_COLOR_SYSTEM);
              exit;
            end;
            {if UpperCase (Strs[0]) = '@잼삯' then begin
                 if Lover <> '' then begin
                  TempUser := UserList.GetUserPointer(Lover);
                  if TempUser <> nil then begin
                    Lover := '';
                    TempUser.Lover := '';
                  end else begin
                    SendClass.SendChatMessage ('토탉꼇瞳窟,轟랬잼삯.', SAY_COLOR_SYSTEM);
                  end;
                end;
            end;}

          //guild command
          SAYCOMMAND_SETTICKETPRICE: // Conv('@쏵쳔환송목')
            begin
              xx := StrToIntDef(Strs[1],0);
              if Zhuang.MasterGuild = nil then Exit;
              if (Zhuang.MasterGuild.GuildName = GuildName) and (zhuang.MasterGuild.GetGuildSysop = Name) then begin
                Zhuang.SetTicketPrice(xx);
                SendClass.SendChatMessage (Conv('쳔튿�阮첵蔬�,뎠품송목:' + IntToStr(Zhuang.GetTicketPrice)), SAY_COLOR_SYSTEM);
              end;
              Exit;
            end;
          SAYCOMMAND_SAVEMONEY: // Conv('@닸흙')
            begin
              xx := StrToIntDef(Strs[1],0);
              if xx > 0 then begin
                if GuildName = '' then Exit;
                ItemClass.GetItemData(Conv('풀귑'),ItemData);
                ItemData.rCount := xx;
                if Not DeleteItem(@ItemData) then begin
                  Exit;
                end;
                GuildObject := GuildList.GetGuildObject(GuildName);
                Inc(GuildObject.Bank,xx);
                GuildUser := GuildObject.GetUser(Name);
                Inc(GuildUser^.rSaveMoney,xx);
                SendClass.SendChatMessage (Conv('닸풀냥묘'), SAY_COLOR_SYSTEM);
                UserList.GuildSay(GuildName,Format(Conv('%s蕨%s陵契닸흙%d'),[Name,GuildName,xx]));
              end;
              Exit;
            end;
          SAYCOMMAND_MAKEITEM: // Conv('@1')   //齡芚膠틔
            begin
              ItemClass.GetItemData (strs[1], ItemData);
              if ItemData.rName[0] = 0 then exit;

              if SysopScope > 99 then begin
                if Strs [2] <> '' then begin
                  ItemData.rCount := _StrToInt (Strs [2]);

                  if (NATION_VERSION = NATION_KOREA) or (NATION_VERSION = NATION_KOREA_TEST) then begin
                    ItemData.rUpgrade := _StrToInt (Strs [3]);

                    if Strs [5] = '' then begin
                      ItemData.rAddType := _StrToInt (Strs [4]);
                      JobClass.GetUpgradeItemLifeData (ItemData);
                      if ItemData.rAddType <> 0 then begin
                        nRet := ItemClass.GetAddItemAttribData (ItemData);
                        if nRet <> true then begin
                          SendClass.SendChatMessage (Conv('옵션번호가 잘못되었습니다'),SAY_COLOR_SYSTEM);
                          exit;
                        end;
                      end;
                    end else begin
                      ItemData.rCurDurability := _StrToInt (Strs [4]);
                      ItemData.rDurability := _StrToInt (Strs [5]);
                    end;
                  end;
                end;
              end else begin
                if ItemData.rSpecialKind <> ITEM_SPKIND_GOLBANG then begin
                  SendClass.SendChatMessage (Conv('轟랬齡芚돨膠틔'), SAY_COLOR_SYSTEM);
                  exit;
                end;
              end;

              if ItemData.rboDouble = false then ItemData.rCount := 1;
              tmpBasicData.Feature.rRace := RACE_NPC;
              StrPCopy (@tmpBasicData.Name, Conv('item'));
              tmpBasicData.x := BasicData.x;
              tmpBasicData.y := BasicData.y;
              SignToItem (ItemData, ServerID, tmpBasicData, '');
              if HaveItemClass.AddItem (ItemData) = true then
                SendClass.SendChatMessage (format (Conv('隣놔%s'),[Strs[1]]), SAY_COLOR_SYSTEM);
              exit;
            end;
          SAYCOMMAND_VIEWPRISONINFO: // Conv('@혀쐐헙괩')
            begin
              msgstr := Prisonclass.GetUserStatus (Name);
              if msgstr <> '' then begin
                SendClass.SendChatMessage (msgstr, SAY_COLOR_SYSTEM);
              end;
              exit;
            end;
          SAYCOMMAND_SEARCH: // INI_SERCHSKILL
            begin
              if (SysopScope > 99) and (Strs[1] <> '') then begin
                TempUser := UserList.GetUserPointer (strs[1]);
                if TempUser = nil then begin SendClass.SendChatMessage (format (Conv('%s꼇瞳。'),[Strs[1]]), SAY_COLOR_SYSTEM); exit; end;
                str := format(Conv('%s瞳 %s돨 %d,%d뒈렘'),[Strs[1], TempUser.Manager.Title, TempUser.BasicData.X, TempUser.BasicData.Y]);
                SendClass.SendChatMessage (str, SAY_COLOR_SYSTEM);
                exit;
              end;
              if SearchTick + 1000 > mmAnsTick then begin
                SendClass.SendChatMessage (Conv('헝�牘斬蔓뇟�'), SAY_COLOR_SYSTEM);
                exit;
              end;
              if Strs[1] = '' then begin
                InputStringState := InputStringState_Search;
                ShowWindowClass.ShowSearchWindow (InputStringState, Conv('헝渴흙決꿴뚤蹶。'), Conv('훙膠'));
                exit;
              end;

              SearchTick := mmAnsTick;
              TempUser := UserList.GetUserPointer (strs[1]);
              if TempUser = nil then begin
                SendClass.SendChatMessage (format (Conv('%s꼇瞳。'),[Strs[1]]), SAY_COLOR_SYSTEM);
                exit;
              end;
              if TempUser.SysopScope >= 100 then begin
                SendClass.SendChatMessage (Conv('늪훙角푤쾨GM。轟랬決꿴'), SAY_COLOR_SYSTEM);
                exit;
              end;
              if TempUser.boSearchEnable = false then begin
                SendClass.SendChatMessage (Conv('앳없決뀁'),SAY_COLOR_SYSTEM);
                exit;
              end;
              if TempUser.ServerID <> ServerID then begin
                SendClass.SendChatMessage (format (Conv('%s瞳 %s。'),[Strs[1], TempUser.Manager.Title]), SAY_COLOR_SYSTEM);
                exit;
              end;
              searchstr := '';
              TempLength := GetLargeLength (BasicData.x, BasicData.y, TempUser.PosX, TempUser.Posy);
              tempdir := GetViewDirection (BasicData.x, BasicData.y, TempUser.PosX, TempUser.Posy);
              case tempdir of
                0 : searchstr := INI_NORTH;
                1 : searchstr := INI_NORTHEAST;
                2 : searchstr := INI_EAST;
                3 : searchstr := INI_EASTSOUTH;
                4 : searchstr := INI_SOUTH;
                5 : searchstr := INI_SOUTHWEST;
                6 : searchstr := INI_WEST;
                7 : searchstr := INI_WESTNORTH;
              end;

              if TempLength < 30 then searchstr := format (Conv('瞳 %s쟁。'),[searchstr])
              else searchstr := format (Conv('%s瞳陶뇹。'),[searchstr]);
              SendClass.SendChatMessage (searchstr, SAY_COLOR_SYSTEM);
              exit;
            end;

          SAYCOMMAND_SEARCHENABLE: // INI_SERCHENABLE
            begin
              boSearchEnable := true;
              SendClass.SendChatMessage (Conv('탐색 가능 설정됨'), SAY_COLOR_NORMAL);
              exit;
            end;

          SAYCOMMAND_SEARCHDISABLE: // INI_SERCHUNABLE
            begin
              boSearchEnable := false;
              SendClass.SendChatMessage (Conv('탐색 거부 설정됨'), SAY_COLOR_NORMAL);
            end;
          SAYCOMMAND_DELETEMAGIC: // Conv('@嶠묘�쓱�')
            begin
              if Password <> '' then begin
                SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                exit;
              end;
              if Strs [1] <> '' then begin
                if SysopScope > 99 then begin
                end else begin
                  for i := 0 to NameStringListForDeleteMagic.Count -1 do begin
                    if Name = NameStringListForDeleteMagic[i] then begin
                      SendClass.SendChatMessage (Conv('쏟莖綠隣법�쓱烋阿┻캘�鱗。'), SAY_COLOR_SYSTEM);
                      SendClass.SendChatMessage (Conv('寧莖怜옵�쓱譎뺨�'), SAY_COLOR_SYSTEM);
                      exit;
                    end;
                  end;
                end;

                ret := HaveMagicClass.GetMagicIndex(Strs[1]);
                if ret <> -1 then begin
                  if HaveMagicClass.DeleteMagic (ret) then begin
                    SendClass.SendChatMessage (Strs[1] + Conv('嶠묘綠굳�쓱爻�'), SAY_COLOR_SYSTEM);
                    NameStringListForDeleteMagic.Add (Name);
                    exit;
                  end else SendClass.SendChatMessage (Conv('呵겨죄。'), SAY_COLOR_SYSTEM);
                end;
                ret := HaveMagicClass.GetRiseMagicIndex(Strs[1]);
                if ret <> -1 then begin
                  if HaveMagicClass.DeleteRiseMagic (ret) then begin
                    SendClass.SendChatMessage (Strs[1] + Conv('嶠묘綠굳�쓱爻�'), SAY_COLOR_SYSTEM);
                    NameStringListForDeleteMagic.Add (Name);
                    exit;
                  end else begin
                    SendClass.SendChatMessage (Conv('呵겨죄。'), SAY_COLOR_SYSTEM);
                  end;
                end;
                ret := HaveMagicClass.GetBestAttackMagicIndex (Strs[1]);
                if ret <> -1 then begin
                   // add by Orber at 2004-12-02 14:59:01
                   // change by minds at 2005-06-06
                   if (HaveMagicClass.GetBestAttackMagicGrade(ret) < 2) or (HaveMagicClass.GetBestAttackMagicExp(ret) < 1084540797 ) then begin
                   //if (HaveMagicClass.GetBestAttackMagicGrade(ret) < 2) and (HaveMagicClass.GetBestAttackMagicExp(ret) < 1084540797 ) then begin
                      if HaveMagicClass.DeleteBestAttackMagic (ret) then begin
                          SendClass.SendChatMessage (Strs[1] + Conv('嶠묘綠굳�쓱爻�'), SAY_COLOR_SYSTEM);
                          NameStringListForDeleteMagic.Add (Name);
                          exit;
                       end else begin
                          SendClass.SendChatMessage (Conv('呵겨죄。'), SAY_COLOR_SYSTEM);
                       end;
                   end else begin
                      SendClass.SendChatMessage (Conv('없各嶠묘힛섬찮빈꼇콘�쓱�.'), SAY_COLOR_SYSTEM);
                   end;
                end;
                ret := HaveMagicClass.GetBestProtectMagicIndex (Strs[1]);
                if ret <> -1 then begin
                   if HaveMagicClass.DeleteBestProtectMagic (ret) then begin
                      SendClass.SendChatMessage (Strs[1] + Conv('嶠묘綠굳�쓱爻�'), SAY_COLOR_SYSTEM);
                      NameStringListForDeleteMagic.Add (Name);
                      exit;
                   end else begin
                      SendClass.SendChatMessage (Conv('呵겨죄。'), SAY_COLOR_SYSTEM);
                   end;
                end;
                ret := HaveMagicClass.GetBestSpecialMagicIndex (Strs[1]);
                if ret <> -1 then begin
                   if HaveMagicClass.DeleteBestSpecialMagic (ret) then begin
                      SendClass.SendChatMessage (Strs[1] + Conv('嶠묘綠굳�쓱爻�'), SAY_COLOR_SYSTEM);
                      NameStringListForDeleteMagic.Add (Name);
                      exit;
                   end else begin
                      SendClass.SendChatMessage (Conv('呵겨죄。'), SAY_COLOR_SYSTEM);
                   end;
                end;
              end;
              exit;
            end;
            {
            if strs[0] = Conv('@밖濫') then begin
               if boTV = true then begin
                  MirrorList.DelViewer (Self);
                  boTV := false;
               end;
               if MirrorList.AddViewer (Strs [1], Self) = true then begin
                  boTv := true;
               end;
               exit;
            end;
            if strs[0] = Conv('@써監밖濫') then begin
               if boTV = true then begin
                  MirrorList.DelViewer (Self);
                  boTV := false;
               end;
               exit;
            end;
            }
            {
            if strs[0] = Conv('@답') then begin
               if QuizSystem.Active = false then begin
                  SendClass.SendChatMessage (Conv('현재 Quiz를 진행하고 있지 않습니다'), SAY_COLOR_SYSTEM);
                  exit;
               end else begin
                  if QuizSystem.Answer = strs[1] then begin
                     QuizSystem.Active := false;
                     tmpstr := format (Conv('%s님께서 퀴즈를 맞추셨습니다'),[StrPas (PChar (@BasicData.ViewName))] );
                     UserList.SendTopMessage (tmpstr);
                     ItemClass.GetItemData (QuizSystem.PresentName, ItemData);

                     if ItemData.rName[0] = 0 then begin
                        SendClass.SendChatMessage (format (Conv('%s 청唐item'),[QuizSystem.PresentName]), SAY_COLOR_SYSTEM);
                        exit;
                     end;

                     ItemData.rCount := QuizSystem.Count;
                     ItemData.rUpgrade := 0;
                     JobClass.GetUpgradeItemLifeData (ItemData);
                     if ItemData.rboDouble = false then ItemData.rCount := 1;

                     tmpBasicData.Feature.rRace := RACE_NPC;
                     StrPCopy (@tmpBasicData.Name, Conv('퀴즈상품'));
                     tmpBasicData.x := BasicData.x;
                     tmpBasicData.y := BasicData.y;
                     SignToItem (ItemData, ServerID, tmpBasicData, '');
                     HaveItemClass.AddItem (ItemData);
                  end;
               end;
               exit;
            end;
            }
            {
            if Strs[0] = Conv('@변신') then begin
               if boPolymorph = true then exit;
               Strs[1] := Trim(Strs[1]);
               if Strs[1] = '' then exit;
               MonsterClass.GetMonsterData(Strs[1], pMon);
               if pMon = nil then exit;

               boPolymorph := true;
               Mon_rAnimate := pMon.rAnimate;
               Mon_rShape := pMon.rShape;
               BasicData.Feature.rrace := RACE_MONSTER;
               BasicData.Feature.raninumber := Mon_rAnimate;
               BasicData.Feature.rImageNumber := Mon_rShape;
               BasicData.Feature.rhitmotion := AM_HIT1;
               CommandChangeCharState(wfs_normal);
               exit;
            end;
            if Strs[0] = Conv('@흠흠') then begin
               boPolymorph := false;
               CommandChangeCharState(wfs_normal);
               exit;
            end;
            }

            // 사용자간의 쪽지 전송 기능
          SAYCOMMAND_MESSENGER: //Conv('@笭係')
            begin
               if Strs[1] = '' then exit;
               if Strs[1] = StrPas(@BasicData.Name) then exit;
               if Manager.boPrison = true then begin
                  SendClass.SendChatMessage (Conv('瞳직렴뒈쟁轟랬눈箇斤口'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               //if GetAge < 2000 then begin
               if ServerID = 0 then begin
                  SendClass.SendChatMessage (Conv('瞳劤癎닷轟랬눈箇笭係'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if RefuseReceiver.Count >= 5 then begin
                  SendClass.SendChatMessage (IntToStr(RefusedMailLimit) + Conv('훙鹿�耉輧評匙켯싱樵�杰鹿轟랬疼눈笭係'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               for i := 0 to RefuseReceiver.Count - 1 do begin
                  if RefuseReceiver.Strings[i] = Strs[1] then begin
                     SendClass.SendChatMessage (format(Conv('%s앳없콱돨笭係。'),[Strs[1]]), SAY_COLOR_SYSTEM);
                     exit;
                  end;
               end;
               TempUser := UserList.GetUserPointer (Strs[1]);
               //timestr := '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + ']';
               timestr := formatDateTime ('yy/mm/dd', Date);
               timestr := timestr + ' ' + formatDateTime ('hh:mm:ss', Time);

               msgstr := Copy(astr, Pos(Strs[1], astr) + Length(Strs[1]), Length(astr));
               if TempUser = nil then begin
                  {
                  if LetterManager.AddLetter (StrPas(@BasicData.Name), Strs[1], msgstr) then
                     SendClass.SendChatMessage (format (Conv('%s커품꼇瞳窟�句Т更싱村ド牘遮ゴ煎�'),[Strs[1]]), SAY_COLOR_SYSTEM)
                  else
                     SendClass.SendChatMessage (format (Conv('灌눈댐돨笭係格뜩，杰鹿轟랬뇹잿。'),[Strs[1]]), SAY_COLOR_SYSTEM);
                  }
                  SendClass.SendChatMessage (format (Conv('%s커품꼇瞳窟�區�'),[Strs[1]]), SAY_COLOR_SYSTEM)
               end else begin
                  if TempUser.LetterCheck = true then begin
                     TempUser.AddMailSender (StrPas(@BasicData.Name));
                     //TempUser.SendClass.SendChatMessage (format (Conv('%s눈죄寧몸笭係못콱。'),[Name]), SAY_COLOR_SYSTEM);
                     //TempUser.SendClass.SendChatMessage (timestr, SAY_COLOR_NORMAL);
                     //TempUser.SendClass.SendChatMessage (msgstr, SAY_COLOR_NORMAL);
                     Str := format ('%s" %s', [TempUser.Name, msgstr]);
                     SendClass.SendMessenger (timestr, Str);

                     Str := format ('%s> %s', [Name, msgstr]);
                     TempUser.SendClass.SendMessenger (timestr, Str);

                     //SendClass.SendChatMessage (format ('%s님에게 쪽지를 전달했습니다',[Strs[1]]), SAY_COLOR_SYSTEM);
                  end else begin
                     if TempUser.SysopScope >= 100 then begin
                        SendClass.SendChatMessage (format (Conv('- %s - 뚤꼇폅.君瞳鯤소轟랬쀼릿笭係'), [TempUser.Name]), SAY_COLOR_SYSTEM);
                     end else begin
                        SendClass.SendChatMessage (format (Conv('%s커품槨앳없笭係榴檄。'),[Strs[1]]), SAY_COLOR_SYSTEM);
                     end;
                  end;
               end;
               exit;
            end;
          SAYCOMMAND_ALLOWALLY: // Conv('@역폘谿촉')
            begin
               FboAllyGuild := true;
               SendClass.SendChatMessage (Conv('역폘谿촉'), SAY_COLOR_NORMAL);
               exit;
            end;
          SAYCOMMAND_DENYALLY: // Conv('@밑균谿촉')
            begin
               FboAllyGuild := false;
               SendClass.SendChatMessage (Conv('앳없谿촉'), SAY_COLOR_NORMAL);
               exit;
            end;
          SAYCOMMAND_ALLOWMESSENGER: // Conv('@쌈澗笭係')
            begin
               if Strs[1] = '' then begin
                  boLetterCheck := true;
                  SendClass.SendChatMessage (Conv('�擁㉬錟倆싱�'), SAY_COLOR_NORMAL);
               end else begin
                  if Strs[1] = StrPas(@BasicData.Name) then exit;
                  TempUser := UserList.GetUserPointer (Strs[1]);
                  if TempUser <> nil then begin
                     TempUser.DelRefusedUser (StrPas(@BasicData.Name));
                     SendClass.SendChatMessage (format(Conv('콱綠�擁㉬錟�%s눈윱돨笭係。'), [Strs[1]]), SAY_COLOR_SYSTEM);
                  end else begin
                     SendClass.SendChatMessage (Conv('뚤렘꼇瞳窟�區�'), SAY_COLOR_SYSTEM);
                  end;
               end;
               exit;
            end;
          SAYCOMMAND_DENYMESSENGER: // Conv('@앳없笭係')
            begin
               if Strs[1] = '' then begin
                  boLetterCheck := false;
                  SendClass.SendChatMessage (Conv('�擁㉭輧布싱椒�'), SAY_COLOR_NORMAL);
               end else begin
                  if Strs[1] = StrPas(@BasicData.Name) then exit;
                  TempUser := UserList.GetUserPointer (Strs[1]);
                  if TempUser <> nil then begin
                     if CheckSenderList (Strs[1]) then begin
                        TempUser.AddRefusedUser (StrPas(@BasicData.Name));
                        SendClass.SendChatMessage (format(Conv('콱綠�擁㉭輧�%s눈윱돨笭係。'), [Strs[1]]), SAY_COLOR_SYSTEM);
                     end;
                  end else begin
                     SendClass.SendChatMessage (Conv('뚤렘꼇瞳窟�區�'), SAY_COLOR_SYSTEM);
                  end;
               end;
               exit;
            end;
          SAYCOMMAND_CREATEGUILD: // '@CREATEGUILD'
            begin
               if GuildList.CreateStone (Strs[1], StrPas (@BasicData.Name), Manager.ServerID, BasicData.x, BasicData.y) = true then begin
                  SendClass.SendChatMessage (Conv('綠盧땡쳔탰柯'), SAY_COLOR_SYSTEM);
               end;
               exit;
            end;

            {
            if Strs[0] = Conv('@횅훰笭係') then begin
               if MailBox.Count > 0 then begin
                  pd := MailBox.Items[0];
                  if pd <> nil then begin
                     timestr := '[' + DateToStr(pd^.rDate) + ' ' + TimeToStr(pd^.rTime) + ']';
                     msgstr := StrPas(@pd^.rSayString);
                     SendClass.SendChatMessage (format (Conv('%s눈죄寧몸笭係못콱。'),[StrPas(@pd^.rSender)]), SAY_COLOR_SYSTEM);
                     SendClass.SendChatMessage (timestr, SAY_COLOR_NORMAL);
                     SendClass.SendChatMessage (msgstr, SAY_COLOR_NORMAL);
                     Dispose (pd);
                  end;
                  MailBox.Delete (0);
               end;
               exit;
            end;
            if Strs[0] = Conv('@�쓱匈싱�') then begin
               if MailBox.Count > 0 then begin
                  pd := MailBox.Items[0];
                  MailBox.Delete (0);
                  SendClass.SendChatMessage (Conv('笭係綠�쓱爻�'), SAY_COLOR_SYSTEM);
               end;
               exit;
            end;
            }
          SAYCOMMAND_SETDEPOTPASSWORD: // Conv('@�擁㉧４豁堡�')
            begin
              if ItemLog.isLocked (Name) = true then begin
                SendClass.SendChatMessage (Conv('쵱쯤綠�擁�'), SAY_COLOR_SYSTEM);
                exit;
              end;
              SendClass.SendShowPasswordWindow (1);
              exit;
            end;
          SAYCOMMAND_FREEDEPOTPASSWORD: // Conv('@썩뇜르덟쵱쯤')
            begin
              if mmAnsTick >= DelayPwdTick + 500 then begin
                if ItemLog.isLocked (Name) = false then begin
                  SendClass.SendChatMessage (Conv('뻘청�擁㉲堡�'), SAY_COLOR_SYSTEM);
                  exit;
                end;
                SendClass.SendShowPasswordWindow (2);
                DelayPwdTick := mmAnsTick;
                exit;
              end;
            end;
          SAYCOMMAND_SETPASSWORD: // Conv('@�擁㉲堡�')
            begin
               if Password <> '' then begin
                  SendClass.SendChatMessage (Conv('쵱쯤綠�擁�'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               SendClass.SendShowPasswordWindow (3);
               exit;
            end;
          SAYCOMMAND_FREEPASSWORD: // Conv('@썩뇜쵱쯤')
            begin
               if mmAnsTick >= DelayPwdTick + 500 then begin
                  if Password = '' then begin
                     SendClass.SendChatMessage (Conv('뻘청�擁㉲堡�'), SAY_COLOR_SYSTEM);
                  end;
                  SendClass.SendShowPasswordWindow (4);
                  DelayPwdTick := mmAnsTick;
                  exit;
               end;
            end;

            // 문파무공 생성
          SAYCOMMAND_CREATEGUILDMAGIC: // Conv('@�鉞允탤�嶠묘')
            begin
               if GuildName = '' then begin
                  SendClass.SendChatMessage (Conv('怜唐쳔寮꼽콘�鉞�'), SAY_COLOR_SYSTEM);
                  exit;
               end;

               if ShowWindowClass.AllowWindowAction (swk_none) = false then exit;

               GuildObject := GuildList.GetGuildObject (GuildName);
               if GuildObject <> nil then begin
                  if GuildObject.IsGuildSysop (Name) = false then exit;
                  if GuildObject.GetGuildMagicString <> '' then exit;

                  ItemClass.GetItemData (Conv('쏜禱'), ItemData);
                  if ItemData.rName [0] = 0 then exit;
                  ItemData.rCount := 40;
                  if FindItem (@ItemData) = false then begin
                     SendClass.SendChatMessage (Conv('�鉞允탤�嶠묘珂矜狼40몸쏜禱'), SAY_COLOR_SYSTEM);
                     exit;
                  end;

                  FillChar (GuildMagicWindow, SizeOf (TSShowGuildMagicWindow), 0);
                  GuildMagicWindow.rMsg := SM_SHOWSPECIALWINDOW;
                  GuildMagicWindow.rWindow := WINDOW_GUILDMAGIC;
                  GuildMagicWindow.rSpeed := 50;
                  GuildMagicWindow.rDamageBody := 50;
                  GuildMagicWindow.rRecovery := 50;
                  GuildMagicWindow.rAvoid := 50;
                  GuildMagicWindow.rDamageHead := 20;
                  GuildMagicWindow.rDamageArm := 20;
                  GuildMagicWindow.rDamageLeg := 20;
                  GuildMagicWindow.rArmorBody := 48;
                  GuildMagicWindow.rArmorHead := 40;
                  GuildMagicWindow.rArmorArm := 40;
                  GuildMagicWindow.rArmorLeg := 40;
                  GuildMagicWindow.rOutPower := 20;
                  GuildMagicWindow.rInPower := 20;
                  GuildMagicWindow.rMagicPower := 20;
                  GuildMagicWindow.rLife := 20;

                  ShowWindowClass.ShowGuildMagicWindow (@GuildMagicWindow);
               end;
               exit;
            end;
          SAYCOMMAND_CHECKPROPERTY: //Conv('@횅훰橄昑令')
            begin
               with AttribClass do begin
                  n := 600 + Age div 2 + Magic + InPower + OutPower + Age + 2100 ;
                  Str := format (Conv('禱폭 : %s'), [Get10000To100(Energy)]);
                  SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
                  Str := format (Conv('샘굶令(%s),코묘(%s),棍묘(%s),嶠묘(%s),삶제(%s)')
                     , [Get10000To100(600 + Age div 2)
                     , Get10000To100(InPower)
                     , Get10000To100(OutPower)
                     , Get10000To100(Magic)
                     , Get10000To100( Age + 2100)]);

                  SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
                  Str := format ('<%s>', [Get10000To100(n)]);
                  SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
               end;
               exit;
            end;
          SAYCOMMAND_ENTERBATTLE: // Conv('@꽝속뚤濫')
            begin
               if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
                  if ServerID <> 1 then begin  // 장성이남 외엔 들어갈 수 없다.
                     SendClass.SendChatMessage (Conv('轟랬쏵흙'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
                  {
                  if GetAge < 4000 then begin  // 40세 이하는 들어갈 수 없다.
                     SendClass.SendChatMessage (Conv('轟랬쏵흙'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
                  }
               end;
               if ShowWindowClass.AllowWindowAction (swk_none) = false then begin
                  SendClass.SendChatMessage (Conv('헝밑균역폘돨눗왯'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if Manager.RegenInterval > 0 then exit;
               if AttribClass.CurLife < AttribClass.Life then begin
                  SendClass.SendChatMessage (Conv('狼껸璃삶제'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               SetPositionBS (BasicData.X, BasicData.Y);
               exit;
            end;
          SAYCOMMAND_STARTBATTLE: // Conv('@繫列濫轢역迦')
            begin
               if GuildName = '' then exit;
               msgstr := Copy(astr, Pos(Strs[0], astr) + Length(Strs[0]), Length(astr));
               GuildObject := GuildList.GetGuildObject (GuildName);
               GuildObject.SetWarAlarm (Name, msgstr);
               exit;
            end;
          SAYCOMMAND_FREETEAM: // Conv('@썩뇜考뚠')
            begin
               if Manager.boNotAllowPK = true then begin
                  if mmAnsTick > SafeSettingTick + SAFE_SETTING_DELAY then begin
                     boSafe := true;
                     SafeSettingTick := mmAnsTick;
                     GroupKey := 0;
                     WearItemClass.SetTeamColor (GroupKey);
                     SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                     SendClass.SendChatMessage (Conv('꼇콘蕨훙묑샌'), SAY_COLOR_SYSTEM);
                  end else begin
                     n := SAFE_SETTING_DELAY - (mmAnsTick - SafeSettingTick);
                     n := n div 100 div 60;
                     SendClass.SendChatMessage (format (Conv('%d롸빈路劤썩뇜考뚠'),[n]),SAY_COLOR_SYSTEM);
                  end;
               end else begin
                  SendClass.SendChatMessage (Conv('늪뒈랏꼇콘썩뇜考뚠'),SAY_COLOR_SYSTEM);
               end;
               exit;
            end;

          SAYCOMMAND_CHECKTRADE: // Conv('@횅훰슥뻣눗')
            begin
               ShowWindowClass.GetExchangeData (ExchangeData);

               if ExchangeData.rExchangeID <> 0 then begin
                  tempUser := TUser (TBasicObject (SendLocalMessage (ExchangeData.rExchangeID, FM_GIVEMEADDR, BasicData, SubData)));
                  if (Integer (tempUser) = 0) or (integer(tempUser) = -1) then exit;
                  tempUser.ShowWindowClass.GetExchangeData (tmpExchangeData);

                  if tmpExchangeData.rExChangeId <> BasicData.ID then exit;

                  str := format (Conv('<%s 瓊묩돨膠틔커쩌>'), [tempUser.Name]);
                  SendClass.SendChatMessage (str, SAY_COLOR_SYSTEM);
                  n := 1; str := '';
                  for i := 0 to 4 - 1 do begin
                     if tmpExchangeData.rItems [i].rItemName = '' then continue;
                     msgstr := tmpExchangeData.rItems [i].rItemName;
                     ItemClass.GetItemData (msgstr, ItemData);
                     if ItemData.rName [0] = 0 then continue;

                     ItemData.rCount := tmpExchangeData.rItems [i].rItemCount;
                     ItemData.rUpgrade := tmpExchangeData.rItems [i].rUpgrade;
                     ItemData.rAddType := tmpExchangeData.rItems [i].rAddtype;
                     ItemData.rDurability := tmpExchangeData.rItems [i].rDurability;
                     ItemData.rCurDurability := tmpExchangeData.rItems [i].rCurDurability;

                     JobClass.GetUpgradeItemLifeData (ItemData);
                     if ItemData.rAddType <> 0 then ItemClass.GetAddItemAttribData (ItemData);

                     if ItemData.rUpgrade <> 0 then begin
                        str := str + format (Conv('%d. %s %d섬 %d몸'), [n, StrPas (@ItemData.rViewName), ItemData.rUpgrade, ItemData.rCount]) + #13;
                     end else begin
                        str := str + format (Conv('%d, %s %d몸'), [n, StrPas (@ItemData.rViewName), ItemData.rCount]) + #13;
                     end;

                     str := str + GetItemDataInfo2 (ItemData);
                     Inc (n);
                  end;
                  SendClass.SendChatMessage (str, SAY_COLOR_NORMAL);
               end else begin
                  SendClass.SendChatMessage (Conv('옵鹿횅훰렴瞳슥뻣눗쟁돨膠틔'), SAY_COLOR_SYSTEM);
               end;
               exit;
            end;
            {
            if Strs [0] = Conv('@硫구겠覡') then begin
               if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;  // 중국은 패치하지않음
               if ShowWindowClass.AllowWindowAction (swk_none) = false then exit;

               if Manager.RegenInterval > 0 then exit;
               if Manager.boShop = false then begin  // 장성이남 외엔 판매금지
                  SendClass.SendChatMessage (Conv('꼇콘겠覡돨뒈뙈랏'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if AttribClass.CurLife < AttribClass.Life then begin
                  SendClass.SendChatMessage (Conv('狼껸璃삶제'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if self.BasicData.Feature.rfeaturestate <> wfs_sitdown then begin
                  SendClass.SendChatMessage (Conv('극伎角麟率'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if Check8Around (BasicData.dir, BasicData.x, BasicData.y) = true then begin   // 8방향에 물체가 하나라도 있으면 안됨
                  SendClass.SendChatMessage (Conv('鷺鍋극伎轟崍강膠'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               HaveMarketClass.SetMarketCount;
               if HaveMarketClass.MarketCount < 1 then begin
                  SendClass.SendChatMessage (Conv('轟늪홈掘'), SAY_COLOR_SYSTEM);
                  exit;
               end;

               CommandTurn (DR_4, TRUE);
               SendClass.SendShowMarketWindow (HaveMarketClass.MarketCount);
//               ShowWindowClass.ShowMarketWindow;
            end;
            }

          //Author:Steven Date: 2004-12-08 13:28:22
          //Note:莉뚠
          SAYCOMMAND_INVITEPARTY: // Conv('@男헝')
            if (Strs[1] <> '') then begin

              //SendClass.SendChatMessage('男헝耆,乖狼男헝콱耆' + Strs[1],
              //  SAY_COLOR_SYSTEM);

              if Assigned(Team) then
              begin
                if Team.FBuildUser.Name <> Name then
                begin
                  SendClass.SendChatMessage(Conv('콱꼇角뚠낀，꼇콘男헝속흙'),
                    SAY_COLOR_SYSTEM);
                  Exit;
                end;

                if Team.MemberCount >= MAX_TEAM_MEMBER then
                begin
                  SendClass.SendChatMessage(Conv('뚠橋훙鑒綠찮'), SAY_COLOR_SYSTEM);
                  Exit;
                end;
              end;

              TempUser := UserList.GetUserPointer(Strs[1]);

              if not Assigned(TempUser) then
              begin
                SendClass.SendChatMessage(Format(Conv('"%s"鯤소꼇닸瞳，헝渴흙攣횅돨鯤소ID'),
                  [Strs[1]]), SAY_COLOR_SYSTEM);
                Exit;
              end;

              //쇱꿎莉뚠눼쉔훙
              if TempUser.Name = Name then
              begin
                SendClass.SendChatMessage(Format(Conv('"%s"꼇옵鹿男헝菱성속흙莉뚠'),
                  [Strs[1]]), SAY_COLOR_SYSTEM);
                Exit;
              end;

              if Not TempUser.TeamEnable then begin
                SSendChatMessage(Format(Conv('%s꼇쌈肝훨부莉뚠男헝'),
                  [Strs[1]]), SAY_COLOR_SYSTEM);
                Exit;
              end;

              //쇱꿎角뤠瞳谿寧뒈暠
              if TempUser.Manager.Title <> Manager.Title then
              begin
                SendClass.SendChatMessage(Format(Conv('鯤소"%s"꼇瞳谿寧혐堵!'),
                  [Strs[1]]), SAY_COLOR_SYSTEM);
                Exit;
              end;

              //쇱꿎男헝鯤소角뤠莉뚠
              if Assigned(TempUser.Team) then
              begin
                SendClass.SendChatMessage(Format(Conv('퀭轟랬男헝綠꽝속뚠橋돨鯤소"%s"'),
                  [Strs[1]]), SAY_COLOR_SYSTEM);
                Exit;
              end;

              //攣끽男헝
              SendClass.SendChatMessage(Format(Conv('攣瞳蕨"%s"랙놔男헝...'),[Strs[1]]), SAY_COLOR_SYSTEM);
              TempUser.SendClass.SendIsInviteTeam(Name, Conv('莉뚠斤口瓊刻'),
                Format(Conv('콱毒雷속흙"%s"돨뚠橋찐?'), [Name]), InviteKey);
              Exit;
            end;
            //======================================

          SAYCOMMAND_LEAVEPARTY: // Conv('@잼역뚠橋')
            begin
              if not Assigned(Team) then
                Exit;
              if Team.FBuildUser.Name = Name then
              begin
                Team.TellEveryOne(Conv('퀭돨뚠橋綠쒔썩��'), SAY_COLOR_SYSTEM);
                Team.TeamDisband;
              end
              else
              begin
                Team.TellEveryOne(Format(Conv('鯤소%s잼역考뚠'), [Name]),
                  SAY_COLOR_SYSTEM);
                if Team.MemberCount > 2 then
                begin
                  Team.LeaveTeam(Name);
                end
                else
                begin
                  Team.TellEveryOne(Conv('퀭돨뚠橋綠쒔썩��'), SAY_COLOR_SYSTEM);
                  Team.TeamDisband;
                end;

              end;
            end;
            //======================================

          SAYCOMMAND_DESTROYPARTY: // Conv('@썩�‰踏�')
            begin
              if not Assigned(Team) then
                Exit;
              if Team.FBuildUser.Name = Name then
              begin
                Team.TellEveryOne(Conv('퀭돨뚠橋綠쒔썩��'), SAY_COLOR_SYSTEM);
                Team.TeamDisband;
              end;
            end;
            //======================================

          SAYCOMMAND_KICKOUTPARTY: // Conv('@혜磊')
            if Strs[1] <> '' then
            begin
              if not Assigned(Team) then
                Exit;
              if (Team.FBuildUser.Name = Name) and (Team.FBuildUser.Name <> Strs[1]) then
              begin
                if not Assigned(Team.FindMember(Strs[1])) then
                begin
                  SendClass.SendChatMessage(Format(Conv('"%s"鯤소꼇닸瞳，헝渴흙攣횅돨鯤소ID'),
                    [Strs[1]]), SAY_COLOR_SYSTEM);
                  Exit;
                end;
                Team.TellEveryOne(Format(Conv('鯤소%s굳뚠낀혜磊'), [Strs[1]]),
                  SAY_COLOR_SYSTEM);
                Team.BootOutTeam(Self, Strs[1]);
                if Team.MemberCount < 2 then
                begin
                  Team.TellEveryOne(Conv('퀭돨뚠橋綠쒔썩��'), SAY_COLOR_SYSTEM);
                  Team.TeamDisband;
                end;
              end;
            end;
            //=======================================
          SAYCOMMAND_PARTYMESSENGER: // Conv('@莉뚠斤口')
            begin
              if not Assigned(Team) then
              begin
                SendClass.SendChatMessage(Format(Conv('鯤소"%s"퀭청唐속흙훨부莉뚠'),
                  [Name]), SAY_COLOR_SYSTEM);
              end
              else
              begin
                for i := 0 to 7 do
                begin
                  if i > MAX_TEAM_MEMBER then
                    Break;
                  if i > Team.MemberCount - 1 then
                    Break;
                  StrPCopy(@TeamMemberList.rMember[i], Format('%s',
                    [Team.FindMember(i).Name]));
                end;
                SendClass.SendTeamMemberList(TeamMemberList.rMember);
              end;
            end;
            //======================================
          end;
        end else begin
            if SysopScope > 99 then begin
               if (LowerCase(Strs[0]) = Conv('@syssop')) then
               begin
                  Self.SysopScope := _StrToInt(Strs[1]);
               end;
               if UpperCase (Strs[0]) = '@MOVEALLITEMSTARTORBER' then begin
                  boMoveAllItem := true;
                  exit;
               end;
               if UpperCase (Strs[0]) = '@MOVEALLITEMENDORBER' then begin
                  boMoveAllItem := false;
                  exit;
               end;
               if UpperCase (Strs[0]) = '@MOVEITEMSTARTORBER' then begin
                  boMoveItem := true;
                  exit;
               end;
               if UpperCase (Strs[0]) = '@MOVEITEMENDORBER' then begin
                  boMoveItem := false;
                  exit;
               end;

               if UpperCase (Strs[0]) = Conv('@�擁㉭胚斛�쳔탰') then begin
                  if Strs[1] = '' then begin
                      Zhuang.MasterGuild := nil;
                      Zhuang.SaveToFile('.\Init\Zhuang.sdb');
                      SendClass.SendChatMessage (Conv('�阮촐嫄�'), SAY_COLOR_SYSTEM);
                      Exit;
                  end;
                  if Strs[1] <> Zhuang.MasterGuild.GuildName then begin
                      GuildObject := GuildList.GetGuildObject(Strs[1]);
                      if GuildObject <> nil then begin
                        Zhuang.MasterGuild := GuildObject;
                        SendClass.SendChatMessage (Conv('�阮촐嫄�'), SAY_COLOR_SYSTEM);
                        Zhuang.SaveToFile('.\Init\Zhuang.sdb');
                      end;
                  end;
                  exit;
               end;

               if UpperCase (Strs[0]) = '@REGEN' then begin
                  if (Manager.MapAttribute <> MAP_TYPE_GUILDBATTLE) and
                     (Manager.MapAttribute <> MAP_TYPE_SPORTBATTLE) then Exit;
                  Manager.Regen;
                  Manager.FboSuccess := false;

                  if (Manager.BattleMop [0] <> nil) and (Manager.BattleMop [1] <> nil) then begin
                     UserList.SendBattleBarbyMapID (TMonster (Manager.BattleMop [0]).MonsterName,
                        TMonster (Manager.BattleMop [1]).MonsterName, 0, 0, TMonster (Manager.BattleMop [0]).BasicData.LifePercent,
                        TMonster (Manager.BattleMop [1]).BasicData.LifePercent, 0, Manager.ServerID);
                  end;
                  exit;
               end;
               if UpperCase (Strs[0]) = '@BATTLESTART' then begin
                  if (Manager.MapAttribute <> MAP_TYPE_GUILDBATTLE) and
                     (Manager.MapAttribute <> MAP_TYPE_SPORTBATTLE) then Exit;
                  UserList.SetActionStateByServerID (ServerID, as_free);
                  Manager.boEnter := false;
                  // change by minds 050926
                  //if Manager.MapAttribute = MAP_TYPE_SPORTBATTLE then
                  UserList.SendCenterMessagebyMapID(Conv('씌세끝역濫, 댕소긴뻣꼍랬,역迦濫떱걸!'), Manager.ServerID);
                  Exit;
               end;
               if UpperCase (Strs[0]) = '@BATTLEEND' then begin
                  if (Manager.MapAttribute <> MAP_TYPE_GUILDBATTLE) and
                     (Manager.MapAttribute <> MAP_TYPE_SPORTBATTLE)then Exit;
                  UserList.SetActionStateByServerID (ServerID, as_ice);
                  Manager.boEnter := false;
                  exit;
               end;
               if UpperCase (Strs[0]) = '@REMAINUSER' then begin
                  if (Manager.MapAttribute <> MAP_TYPE_GUILDBATTLE) and
                     (Manager.MapAttribute <> MAP_TYPE_SPORTBATTLE) then Exit;
                  if Strs [1] = '' then exit;
                  n := UserList.GetRemainGuildUserbyServerID (ServerID, Strs [1]);
                  SendClass.SendCenterMessage (format ('Remain User : %d', [n]));
                  exit;
               end;
               if UpperCase (Strs[0]) = '@NAMELISTLOAD' then begin
                  if (Manager.MapAttribute <> MAP_TYPE_GUILDBATTLE) and
                     (Manager.MapAttribute <> MAP_TYPE_SPORTBATTLE) then exit;
                  NameClass.ReLoadFromFile;
                  Manager.boEnter := true;
                  exit;
               end;
               if UpperCase (Strs[0]) = '@BATTLEMAPLOAD' then begin
                  if (Manager.MapAttribute <> MAP_TYPE_GUILDBATTLE) and
                     (Manager.MapAttribute <> MAP_TYPE_SPORTBATTLE) then exit;
                  BattleMapList.LoadFromFile ('.\Event\BattleMap.sdb');
                  exit;
               end;
               if UpperCase (Strs[0]) = '@BANALL' then begin
                  if (Manager.MapAttribute <> MAP_TYPE_GUILDBATTLE) and
                     (Manager.MapAttribute <> MAP_TYPE_SPORTBATTLE) then Exit;
                  xx := _StrToInt (Strs [1]);
                  yy := _StrToInt (Strs [2]);

                  if (xx = 0) or (yy = 0) then begin
                     SendClass.SendCenterMessage ('Retry... (e.g.) @banall 500 500');
                     exit;
                  end;
                  UserList.MoveByServerID (ServerID, 1, xx, yy);
                  exit;
               end;

               if Strs [0] = '@swk' then begin
                  ShowWindowClass.SetCurrentWindow (TSpecialWindowKind (_StrToInt (Strs [1])), sst_none);
                  exit;
               end;
               if Strs [0] = '@lifedata' then begin
                  with Lifedata do begin
                  {
                     SendClass.SendChatMessage (format (Conv('묑샌醵똑: %d 뿟릿: %d 뜰��: %d'), [-AttackSpeed, Recovery, Avoid]), SAY_COLOR_SYSTEM);
                     SendClass.SendChatMessage (format (Conv('硫횅똑: %d 率覺郭넣: %d'), [Accuracy, KeepRecovery]), SAY_COLOR_SYSTEM);
                     SendClass.SendChatMessage (format (Conv('팎뻐제: %d / %d / %d / %d'),[DamageBody, DamageHead, DamageArm, DamageLeg]), SAY_COLOR_SYSTEM);
                     SendClass.SendChatMessage (format (Conv('렝徒제:  %d / %d / %d / %d'),[ArmorBody, ArmorHead, ArmorArm, ArmorLeg]), SAY_COLOR_SYSTEM);
                  }
                     SendClass.SendChatMessage (format (Conv('뜰��: %d 츱櫓: %d'), [Avoid, Accuracy]), SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;
               if UpperCase (Strs[0]) = '@SHOUT' then begin
                  UserList.SendTestMessage ('[' + Name + ']', _StrToInt (Strs [1]), _StrToInt (Strs [2]),_StrToInt (Strs [3]),_StrToInt (Strs [4]),_StrToInt (Strs [5]),_StrToInt (Strs [6]));
                  exit;
               end;
               if UpperCase (Strs[0]) = Conv('@문제') then begin
                  aQuizstr := GetValidStr3 (astr, tmpStr , ' ');
                  QuizSystem.SetQuestion (aQuizStr);
                  SendClass.SendChatMessage (Conv('문제가 등록되었습니다'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if UpperCase (Strs[0]) = Conv('@정답') then begin
                  aQuizStr := GetValidStr3 (astr, tmpStr, ' ');
                  QuizSystem.SetAnswer (aQuizStr);
                  SendClass.SendChatMessage (Conv('정답이 등록되었습니다'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if UpperCase (Strs[0]) = Conv('@상품') then begin
                  QuizSystem.SetPresent (Strs[1], _StrToInt(Strs[2]) );
                  SendClass.SendChatMessage (Conv('상품이 등록되었습니다'), SAY_COLOR_SYSTEM);
                  exit;
               end;

               if UpperCase (Strs[0]) = Conv('@퀴즈실시') then begin
                  QuizSystem.Active := true;
                  str := QuizSystem.Question;
                  str := str + Conv(' 상품:') + QuizSystem.PresentName;
                  str := str + '(' + IntToStr (QuizSystem.Count) + ')';
                  UserList.SendCenterMessage (str);
                  exit;
               end;

               if UpperCase (Strs[0]) = Conv('@퀴즈확인') then begin
                  SendClass.SendChatMessage (QuizSystem.Presentation, SAY_COLOR_SYSTEM);
                  exit;
               end;
               if UpperCase (Strs [0]) = '@DIE' then begin
                  AttribClass.CurHeadLife := 0;
                  AttribClass.CurArmLife := 0;
                  AttribClass.CurLegLife := 0;
                  AttribClass.CurInPower := 0;
                  AttribClass.CurOutPower := 0;
                  AttribClass.CurMagic := 0;
                  AttribClass.CurLife := 0;
                  exit;
               end;

               //자리랙 확인용 코드
               //이후 해결된후 삭제바람.
               if UpperCase (Strs [0]) = Conv('@자리확인') then begin
                  xx := _StrToInt (Strs[1]);
                  yy := _StrToInt (Strs[2]);
                  if Maper.isMoveable2(xx,yy,k) = false then begin
                     if IsObjectItemID(k) then begin
                        SendClass.SendChatMessage (format ('%d ObjectItem ID',[k]),SAY_COLOR_SYSTEM);
                     end else if IsUserID (k) then begin
                        SendClass.SendChatMessage (format ('%d UserID ID',[k]),SAY_COLOR_SYSTEM);
                     end else if IsMonsterID (k) then begin
                        SendClass.SendChatMessage (format ('%d Monster ID',[k]),SAY_COLOR_SYSTEM);
                     end else if IsCallMonsterID (k) then begin
                        SendClass.SendChatMessage (format ('%d CallMonster ID',[k]),SAY_COLOR_SYSTEM);
                     end else if IsStaticItemID (k) then begin
                        SendClass.SendChatMessage (format ('%d StaticItem ID',[k]),SAY_COLOR_SYSTEM);
                     end else if IsDynamicObjectID (k) then begin
                        SendClass.SendChatMessage (format ('%d DynamicObject ID',[k]),SAY_COLOR_SYSTEM);
                     end;
                  end;
                  exit;
               end;

               //버그용 코드
               //이후 해결된후 삭제바람.
               if UpperCase (Strs[0]) = Conv('@횅훰鯤소') then begin
                  k := _StrToInt (Strs[1]);
                  TempUser := UserList.GetUserPointerById(k);
                  if TempUser <> nil then begin
                     SendClass.SendChatMessage (format (Conv('鬧꿍槨%s '),[StrPas (@Tempuser.basicdata.name)]),SAY_COLOR_SYSTEM);
                  end else begin
                     SendClass.SendChatMessage (Conv('청唐鬧꿍'), SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;

               if UpperCase (Strs [0]) = '@REPORT' then begin
                  Str := TMineObjectList (Manager.MineObjectList).GetReportStr;
                  if Str <> '' then SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
                  exit;
               end;
               if Strs [0] = Conv('@직업초기화') then begin
                  HaveJobClass.ClearJobData;
                  exit;
               end;
               if Strs [0] = Conv('@재능설정') then begin
                  HaveJobClass.SetJobTalent (_StrToInt (Strs [1]));
                  exit;
               end;
               if UpperCase (strs[0]) = '@NPCSETTING' then begin
                  if Strs [1] = '' then exit;
                  TNpcList(Manager.NpcList).ReLoadFromNpcSetting (Strs [1]);
                  exit;
               end;
               if Strs [0] = Conv('@퀘스트값') then begin
                  Str := format ('completequest : %d, currentquest : %d, queststr : %s, firstquest : %d', [userquestclass.CompleteQuestNo,
                     userquestclass.CurrentQuestNo, userquestclass.QuestStr, UserQuestClass.FirstQuestNo]);
                  SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
                  exit;
               end;
               if Strs [0] = Conv('@퀘스트초기화') then begin
                  UserQuestClass.CompleteQuestNo := _StrToInt (Strs [1]);
                  UserQuestClass.CurrentQuestNo := _StrToInt (Strs [2]);
                  UserQuestClass.QuestStr := Strs [3];
                  UserQuestClass.FirstQuestNo := _StrToInt (Strs [4]);
                  exit;
               end;
               //2002-08-09 giltae
               if Strs[0] = Conv('@퀘스트요약로드') then begin
                  QuestSummaryClass.ReLoadFromFile;
                  exit;
               end;
               if Strs [0] = '@SPELL' then begin
                  SubData.SpellType := SPELLTYPE_POISON;
                  Subdata.SpellDamage := 1000;
                  SendLocalMessage (NOTARGETPHONE, FM_SPELL, BasicData, SubData);
                  exit;
               end;
               if Strs [0] = Conv('@컵별') then begin
                  msgstr := Copy(aStr, Pos(Strs[0], aStr) + Length(Strs[0]), Length(aStr));
                  UserList.SendCenterMessage (msgstr);
                  exit;
               end;
               if Strs [0] = Conv('@醵똑횅훰') then begin
                  if boCheckSpeed = false then begin
                     Str := Conv('쇱꿴醵똑');
                     boCheckSpeed := true;
                  end else begin
                     Str := Conv('써監쇱꿴醵똑');
                     boCheckSpeed := false;
                  end;
                  SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
                  exit;
               end;
               if Strs [0] = Conv('@실�バ턴�') then begin
                  if Strs [1] <> '' then begin
                     Str := GuildList.GetCharInformation (Strs [1]);
                     if Str <> '' then begin
                        SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
                     end;
                  end;
                  exit;
               end;
               if Strs [0] = Conv('@쳔탰斤口') then begin
                  if Strs [1] <> '' then begin
                     Str := GuildList.GetInformation (Strs [1]);
                     if Str <> '' then begin
                        SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
                     end;
                  end;
                  exit;
               end;

               if UpperCase (strs[0]) = Conv('@賈痰諒헙괩') then begin
                  if Strs[1] = '' then begin
                     UserList.SaveUserInfo ('.\LOG\USERINFO.SDB');
                     SendClass.SendChatMessage (Conv(Conv('뇹잿供귄')), SAY_COLOR_SYSTEM);
                  end else begin
                     if NATION_VERSION = NATION_TAIWAN then begin
                        Strs[1] := _ToSpaceForTaiwan (Strs[1]);
                     end;
                     TempUser := UserList.GetUserPointer (Strs[1]);
                     if TempUser <> nil then begin
                        RetStr := TempUser.Name + ': IP(' + TempUser.Connector.IpAddr + ')';
                        SendClass.SendChatMessage (RetStr, SAY_COLOR_SYSTEM);
                     end else begin
                        SendClass.SendChatMessage (format (Conv(Conv('%s커품꼇瞳窟�區�')), [Strs[1]]), SAY_COLOR_SYSTEM);
                     end;
                  end;
                  exit;
               end;
               
               if UpperCase (strs[0]) = '@SHOWME' then begin
                  for i := 0 to ViewObjectList.Count - 1 do begin
                     Bo := ViewObjectList.Items [i];
                     SendClass.SendChatMessage (StrPas (@Bo.BasicData.Name) + '(' + IntToStr (Bo.BasicData.X) + ',' + IntToStr (Bo.BasicData.Y) + ')', SAY_COLOR_SYSTEM);
                  end;
                  SendClass.SendChatMessage (format (Conv('역폘죄%d몸'), [ViewObjectList.Count]), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if UpperCase (strs[0]) = Conv('@뇨닸괏밗눗') then begin
                  ItemLog.SaveToSDB ('.\ITEMLOG\ITEMLOG.SDB');
                  SendClass.SendChatMessage (Conv('뇹잿供귄'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if UpperCase (strs[0]) = Conv('@傑땍괏밗눗') then begin
                  if ItemLog.Enabled = true then begin
                     ItemLog.Enabled := false;
                     SendClass.SendChatMessage (Conv('界岺괏밗눗돨賈痰'), SAY_COLOR_SYSTEM);
                  end else begin
                     ItemLog.Enabled := true;
                     SendClass.SendChatMessage (Conv('폘痰괏밗눗'), SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;
               if UpperCase(strs[0]) = '@VIEWLIFEDATA' then begin
                  Str := GetLifeDataInfo(LifeData);
                  SendClass.SendChatMessage(Str , SAY_COLOR_SYSTEM);
                  exit;
               end;
               
               if UpperCase(strs[0]) = '@DAMAGE' then begin
                  boShowHitedValue := not boShowHitedValue;
                  exit;
               end;
               if UpperCase(strs[0]) = '@GUILDDAMAGE' then begin
                  boShowGuildDuraValue := not boShowGuildDuraValue;
                  exit;
               end;

               if UpperCase(strs[0]) = '@CALLGUILD' then begin
                  if GuildList.MoveStone (Strs[1], Manager.ServerID, BasicData.x, BasicData.y) = true then begin
                     SendClass.SendChatMessage (Conv('綠盧땡쳔탰柯'), SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;
               if UpperCase(strs[0]) = '@CREATEGUILD' then begin
                  if GuildList.CreateStone (Strs[1], '', Manager.ServerID, BasicData.x, BasicData.y) = true then begin
                     SendClass.SendChatMessage (Conv('綠盧땡쳔탰柯'), SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;

               {
               if UpperCase(strs[0]) = '@READ' then begin
                  SysopClass.ReLoadFromFile;
                  ItemClass.ReLoadFromFile;
                  MonsterClass.ReLoadFromFile;
                  NpcClass.ReLoadFromFile;
                  ManagerList.ReLoadFromFile;
                  exit;
               end;
               }
               // 현재 마을의 특정 좌표로 이동한다

               {
               if UpperCase(strs[0]) = '@MOVE' then begin
                  xx := _StrToInt (Strs[1]);
                  yy := _StrToInt (Strs[2]);
                  if Maper.isMoveable (xx, yy) then begin
                     if (xx > 0) and (yy > 0) then begin
                        FPosMoveX := xx;
                        FPosMoveY := yy;
                     end else begin
                        FPosMoveX := Maper.Width div 2;
                        FPosMoveY := Maper.Height div 2;
                     end;
                  end;
                  exit;
               end;
               }

                {
                if UpperCase(strs[0]) = '@JANGSUNG' then begin
                        FPosMoveX := 500;
                        FPosMoveY := 500;
                        FboNewServer := TRUE;
                        ServerID := 1;

                exit;
                 end;
                 }


               // 새로운 마을의 특정 좌표로 이동한다
               if UpperCase(strs[0]) = Conv('@盧땡') then begin
                  xx := _StrToInt (Strs[2]);
                  yy := _StrToInt (Strs[3]);

                  tmpManager := ManagerList.GetManagerByTitle (Strs[1]);
                  if tmpManager <> nil then begin
                     if TMaper (tmpManager.Maper).isMoveable (xx, yy) = true then begin
                        if tmpManager.ServerID <> ServerID then begin
                           FboNewServer := TRUE;
                           ServerID := tmpManager.ServerID;
                        end;
                        if (xx > 0) and (yy > 0) then begin
                           FPosMoveX := xx;
                           FPosMoveY := yy;
                        end else begin
                           FPosMoveX := TMaper (tmpManager.Maper).Width div 2;
                           FPosMoveY := TMaper (tmpManager.Maper).Height div 2;
                        end;
                     end;
                  end else begin
                     SendClass.SendChatMessage (Conv('꼇콘盧逞늪林깃'), SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;

               // NPC 출두
               if UpperCase(Strs[0]) = '@APPEARNPC' then begin
                  Bo := TBasicObject (TNpcList(Manager.NpcList).GetNpcByName (Strs[1], false));
                  if Bo <> nil then begin
                     FPosMoveX := BO.BasicData.x;
                     FPosMoveY := BO.BasicData.y;
                  end;
                  exit;
               end;
               // 몬스터 출두
               if UpperCase(Strs[0]) = '@APPEARMOP' then begin
                  Bo := TBasicObject(TMonsterList(Manager.MonsterList).GetMonsterByName (Strs[1], false));
                  if Bo <> nil then begin
                     FPosMoveX := BO.BasicData.x;
                     FPosMoveY := BO.BasicData.y;
                  end;
                  exit;
               end;
               //gil-tae 2002-07-19
               //DynamicObject로 출두(편리함)
               if UpperCase(Strs[0]) = '@APPEARDYN' then begin
                  Bo := TBasicObject(TDynamicObjectList(Manager.DynamicObjectList).GetDynamicObjectbyName(Strs[1]));
                  if Bo <> nil then begin
                     FPosMoveX := BO.BasicData.x;
                     FPosMoveY := BO.BasicData.y;
                  end;
                  exit;
               end;

               // 사용자의 접속을 해제 시킨다
               if (UpperCase(Strs[0]) = '@BAN') or (UpperCase(Strs[0]) = '@BANEX') then begin
                  if Strs[1] <> '' then begin
                     msgstr := Copy(astr, Pos(Strs[1], astr) + Length(Strs[1]), Length(astr));
                     TempUser := UserList.GetUserPointer (Strs[1]);
                     if TempUser = nil then begin
                        SendClass.SendChatMessage (format (Conv('%s커품꼇瞳窟�區�'),[Strs[1]]), SAY_COLOR_SYSTEM);
                     end else begin
                        if UpperCase(Strs[0]) = '@BAN' then
                           TempUser.SendClass.SendChatMessage(Conv('훙膠綠굳밗잿諒퓻齡뙤窟'), SAY_COLOR_SYSTEM);
                        if msgstr <> '' then begin
                           msgstr := Conv('푤쾨:') + msgstr;
                           TempUser.SendClass.SendChatMessage(msgstr, SAY_COLOR_NORMAL);
                        end;
                        ConnectorList.CloseConnectByCharName(StrPas(@TempUser.BasicData.Name));

                        SendClass.SendChatMessage (format (Conv('%s쉥瞳10취빈뙤窟。'),[Strs[1]]), SAY_COLOR_SYSTEM);
                     end;
                  end;
               end;
               if strs[0] = Conv('@�쓱毁탤�') then begin
                  GuildList.DeleteStone (Strs [1]);
                  exit;
               end;
               if UpperCase(Strs[0]) = Conv('@놔깡') then begin
                  TempUser := UserList.GetUserPointer (Strs[1]);
                  if TempUser = nil then begin
                     SendClass.SendChatMessage (format (Conv('%s꼇瞳。'),[Strs[1]]), SAY_COLOR_SYSTEM);
                  end else begin
                     if TempUser.ServerID <> ServerID then begin
                        FboNewServer := TRUE;
                        ServerID := TempUser.ServerID;
                     end;

                     FPosMoveX := TempUser.BasicData.x;
                     FPosMoveY := TempUser.BasicData.y;

                     if UpperCase(Strs[0]) = '@APPEAREX' then begin
                        FPosMoveX := FPosMoveX + 10;
                        FPosMoveY := FPosMoveY + 10;
                     end;
                  end;
                  exit;
               end;

               // 테스트용 명령어
               if UpperCase (Strs[0]) = Conv('@�擁ⓕ���') then begin
                  WearItemClass.SetHiddenState (hs_0);
                  SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                  exit;
               end;
               if UpperCase (Strs[0]) = Conv('@썩뇜茶��') then begin
                  WearItemClass.SetHiddenState (hs_100);
                  SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                  exit;
               end;
               if UpperCase(strs[0]) = Conv('@考뚠盧땡') then begin
                  n := _StrToInt (Strs [4]);
                  xx := _StrToInt (Strs[2]);
                  yy := _StrToInt (Strs[3]);

                  tmpManager := ManagerList.GetManagerByTitle (Strs[1]);
                  if tmpManager <> nil then begin
                     for i := 0 to ViewObjectList.Count - 1 do begin
                        BO := ViewObjectList.Items [i];
                        if Bo.BasicData.Feature.rRace = RACE_HUMAN then begin
                           TempUser := TUser (BO);
                           if TempUser.GroupKey = n then begin
                              if TempUser.ServerID <> tmpManager.ServerID then begin
                                 Tempuser.FboNewServer := TRUE;
                                 TempUser.ServerID := tmpManager.ServerID;
                              end;
                              if (xx > 0) and (yy > 0) then begin
                                 TempUser.PosMoveX := xx;
                                 TempUser.PosMoveY := yy;
                              end else begin
                                 TempUser.PosMoveX := TMaper (tmpManager.Maper).Width div 2;
                                 TempUser.PosMoveY := TMaper (tmpManager.Maper).Height div 2;
                              end;
                           end;
                        end;
                     end;
                  end;
                  exit;


                  n := _StrToInt (Strs [1]);

                  for i := 0 to ViewObjectList.Count - 1 do begin
                     BO := ViewObjectList.Items [i];
                     if Bo.BasicData.Feature.rRace = RACE_HUMAN then begin
                        TempUser := TUser (BO);
                        if TempUser.GroupKey = n then begin
                           if TempUser.ServerID <> ServerID then begin
                              Tempuser.FboNewServer := TRUE;
                              TempUser.ServerID := ServerID;
                           end;
                           TempUser.PosMoveX := BasicData.x;
                           TempUser.PosMoveY := BasicData.y;
                        end;
                     end;
                  end;
                  exit;
               end;
               if UpperCase(strs[0]) = Conv('@뻥쀼') then begin
                  TempUser := UserList.GetUserPointer (Strs[1]);
                  if TempUser = nil then begin
                     SendClass.SendChatMessage (format (Conv('%s꼇瞳。'),[Strs[1]]), SAY_COLOR_SYSTEM);
                  end else begin
                     if TempUser.ServerID <> ServerID then begin
                        Tempuser.FboNewServer := TRUE;
                        TempUser.ServerID := ServerID;
                     end;
                     TempUser.PosMoveX := BasicData.x;
                     TempUser.PosMoveY := BasicData.y;
                  end;
               end;

               if UpperCase(Strs[0]) = '@SHOW' then begin
                  if Strs[1] = '' then exit;
                  TempUser := UserList.GetUserPointer (Strs[1]);
                  if TempUser <> nil then begin
                     if TempUser.SysopObj = nil then begin
                        if UserObj <> nil then begin
                           TUser(UserObj).SysopObj := nil;
                        end;
                        UserObj := TempUser;
                        TempUser.SysopObj := Self;
                        if not boTv then begin
                           boTv := TRUE;
                        end;
                        SendClass.SendMap (TempUser.BasicData, TempUser.Manager);
                        for i := 0 to TempUser.ViewObjectList.Count -1 do
                           SendClass.SendShow (TBasicObject (TempUser.ViewObjectList[i]).BasicData, 0, lek_none);
                     end;
                  end;
                  exit;
               end;
               // NPC 소환
               if UpperCase(Strs[0]) = '@CALLNPC' then begin
                  Bo := TBasicObject (TNpcList(Manager.NpcList).GetNpcByName (Strs[1], false));
                  if Bo <> nil then begin
                     for k := 0 to 10 - 1 do begin
                        xx := BasicData.X - 2 + Random(4);
                        yy := BasicData.Y - 2 + Random(4);
                        if Maper.isMoveable (xx, yy) then begin
                           TNpc(Bo).CallMe (xx, yy);
                           break;
                        end;
                     end;
                  end;
                  exit;
               end;
               // 몬스터 소환
               if UpperCase(Strs[0]) = '@CALLMOP' then begin
                  Bo := TBasicObject(TMonsterList(Manager.MonsterList).GetMonsterByName (Strs[1], false));
                  if Bo <> nil then begin
                     for k := 0 to 10 - 1 do begin
                        xx := BasicData.X - 2 + Random(4);
                        yy := BasicData.Y - 2 + Random(4);
                        if Maper.isMoveable (xx, yy) then begin
                           TMonster(Bo).CallMe (xx, yy);
                           break;
                        end;
                     end;
                  end;
                  exit;
               end;

               // 주변 모든 몬스터와 NPC 를 제거함
               if Strs[0] = Conv('@괵') then begin
                  SubData.TargetId := 0;
                  if UpperCase(Strs[1]) = 'MOP' then begin
                     SubData.TargetId := 1;
                  end;
                  ShowEffect (4, lek_none);
                  SendLocalMessage (NOTARGETPHONE, FM_DEADHIT, BasicData, SubData);
                  exit;
               end;
               // 주변 모든 사용자에게 환생을 해줌
               if UpperCase (Strs [0]) = Conv('@뻘��') then begin
                  SendLocalMessage (NOTARGETPHONE, FM_REFILL, BasicData, SubData);
                  exit;
               end;
               if UpperCase (Strs [0]) = '@EMPTY' then begin
                  AttribClass.CurLife := 0;
                  AttribClass.CurInPower := 0;
                  AttribClass.CurOutPower := 0;
                  AttribClass.CurMagic := 0;
                  exit;
               end;
               if Strs [0] = Conv('@錦맣쒔駱令') then begin
                  if Strs [1] = '' then exit;
                  ExpMulti := _StrToInt (Strs [1]);
                  exit;
               end;
               if Strs [0] = Conv('@錦맣뵈횔攣폭') then begin
                  if Strs [1] = '' then exit;
                  VirtueMulti := _StrToInt (Strs [1]);
                  exit;
               end;
               if Strs [0] = Conv('@錦맣嶠묘') then begin
                  HaveMagicClass.EditHaveMagicByName (Strs [1], _StrToInt (Strs[2]));
                  exit;
               end;
               if UpperCase(Strs[0]) = '@진기수정' then begin
                  if Strs[1] = '' then exit;
                     k := _StrToInt(Strs[1]);
                     AttribClass.AddableStatePoint := k;
                     SendClass.SendExtraAttribValues(AttribClass);
                  exit;
               end;
               if UpperCase(Strs[0]) = '@승급정보' then begin
                  SendClass.SendChatMessage (format('현재 %d 승급까지 했습니다',[HaveMagicClass.CurrentGrade]), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if UpperCase(Strs[0]) = '@절세무공수정' then begin
                  //1:무공명,2:스킬,3:grade, 4: DamageBody/DamageHead/DamageArm/DamageLeg/DamageEnergy
                  //5: ArmorBody/ArmorHead/ArmorArm/ArmorLeg/ArmorEnergy
                  if Strs[1] = '' then exit;
                  n := _StrToInt(Strs[3]);
                  if (n < 0) or (n > 4-1) then exit;
                  HaveMagicClass.EditHaveBestMagicByName (Strs [1], _StrToInt (Strs[2]), n, Strs[4], Strs[5]);
                  exit;
               end;
               if Strs [0] = Conv('@무공수정2') then begin
                  HaveMagicClass.EditHaveMagicByName2 (Strs[1], _StrToInt (Strs[2]), _StrToInt (Strs[3]));
               end;
               if UpperCase (Strs [0]) = '@REGENMAP' then begin
                  n := Manager.RegenInterval;
                  Manager.RegenInterval := 1;
                  Manager.Update (mmAnsTick);
                  Manager.RegenInterval := n;
                  exit;
               end;
               if Strs [0] = '@scriptload' then begin
                  ScriptManager.LoadFromFile ('.\Script\Script.SDB');
                  exit;
               end;
               if UpperCase (Strs [0]) = Conv('@梁뻥밍艱') then begin
                  if Strs [1] <> '' then begin
                     TMonsterList (Manager.MonsterList).ComeOn (Strs [i], BasicData.X, BasicData.Y);
                  end;
                  exit;
               end;
               if UpperCase (Strs [0]) = '@HELPFILERELOAD' then begin
                  HelpFiles.LoadHelpFiles;
                  exit;
               end;
               if UpperCase (Strs [0]) = Conv('@憐잿돛야') then begin
                  HaveItemClass.DeleteAllItem;
                  exit;
               end;
               if UpperCase (strs[0]) = Conv('@썩뇜뜰��') then begin SysopScope := 100; exit; end;
               if UpperCase (strs[0]) = Conv('@�擁㉥蓍�') then begin SysopScope := 101; exit; end;

               if UpperCase (strs[0]) = Conv('@속성번호확인') then begin
                  ItemData := HaveJobClass.ProductItem;
                  if ItemData.rName[0] <> 0 then begin
                     SendClass.SendChatMessage (format('AddType : %d',[ItemData.rAddType]), SAY_COLOR_SYSTEM);
                  end else begin
                     SendClass.SendChatMessage (Conv('기술창의 왼쪽 아래에 아이템을 넣으면 확인이 가능함'), SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;

               //// 테스트용 명령어 끝
               if UpperCase (Strs[0]) = Conv('@혀쐐') then begin
                  msgstr := PrisonClass.AddUser (Strs[1], Strs[2], Strs[3]);
                  if msgstr = '' then begin
                     SendClass.SendChatMessage (Conv('뇹잿供귄'), SAY_COLOR_SYSTEM);
                  end else begin
                     SendClass.SendChatMessage (msgstr, SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;
               if UpperCase (Strs[0]) = Conv('@shifang1111') then begin
                  msgstr := PrisonClass.DelUser (Strs[1]);
                  if msgstr = '' then begin
                      SendClass.SendChatMessage (Conv('뇹잿供귄'), SAY_COLOR_SYSTEM);
                  end else begin
                      SendClass.SendChatMessage (msgstr, SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;
               if UpperCase (Strs[0]) = Conv('@錦맣혀쐐栗죕') then begin
                  msgstr := Prisonclass.UpdateUser (Strs[1], Strs[2], Strs[3]);
                  if msgstr = '' then begin
                      SendClass.SendChatMessage (Conv('뇹잿供귄'), SAY_COLOR_SYSTEM);
                  end else begin
                      SendClass.SendChatMessage (msgstr, SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;
               if UpperCase (Strs[0]) = Conv('@瀏속혀쐐栗죕') then begin
                  msgstr := PrisonClass.PlusUser (Strs[1], Strs[2], Strs[3]);
                  if msgstr = '' then begin
                      SendClass.SendChatMessage (Conv('뇹잿供귄'), SAY_COLOR_SYSTEM);
                  end else begin
                      SendClass.SendChatMessage (msgstr, SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;
               if UpperCase (Strs[0]) = Conv('@�擁㉶玔滸굴�') then begin
                  msgstr := PrisonClass.EditUser (Strs[1], Strs[2], Strs[3]);
                  if msgstr = '' then begin
                      SendClass.SendChatMessage (Conv('뇹잿供귄'), SAY_COLOR_SYSTEM);
                  end else begin
                      SendClass.SendChatMessage (msgstr, SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;
               if UpperCase (Strs[0]) = Conv('@혀쐐헙괩') then begin
                  if Strs[1] <> '' then begin
                     msgstr := PrisonClass.GetUserStatus (Strs[1]);
                     if msgstr <> '' then begin
                         SendClass.SendChatMessage (msgstr, SAY_COLOR_SYSTEM);
                     end;
                  end;
                  exit;
               end;
            end;

         end;
      '!' :
         begin
            if mmanstick < SayTick + 300 then exit;
            SayTick := mmAnsTick;
            if Length (aStr) <= 2 then exit;

            if SysopScope < 100 then begin
               if Manager.boBigSay = false then begin
                  if aStr[2] <> '!' then begin
                     SendClass.SendChatMessage (Conv('쐐岺댕별돨뒈혐。'), SAY_COLOR_SYSTEM);
                  end else begin
                     if Length (aStr) <= 3 then exit;
                     UserList.SayByServerID (Manager.ServerID, '{' + Name + '} : ' + Copy (astr, 3, Length(aStr) - 2), SAY_COLOR_NORMAL);
                  end;
                  exit;
               end;
            end else begin
               if Manager.boBigSay = false then begin
                  if aStr[2] = '!' then begin
                     if Length (aStr) <= 3 then exit;
                     UserList.SayByServerID (Manager.ServerID, '{' + Name + '} : ' + Copy (astr, 3, Length(aStr) - 2), SAY_COLOR_NORMAL);
                     exit;
                  end;
               end;
            end;

            if (astr[2] = '!') and (aStr[3] <> '!') and (GuildName <> '')then begin
               if Length (astr) <= 3 then exit;
               UserList.GuildSay (GuildName, '<' + Name + '> : ' + Copy (astr,3, Length(astr)-2));
               exit;
            end;
            if (astr[2] = '!') and (aStr[3] = '!') and (GuildName <> '')then begin
               if Length (astr) <= 4 then exit;
               UserList.AllyGuildSay (GuildName, '{' + GuildName + ':' + Name + '} : ' + Copy (aStr,4, Length(astr)- 3));
               exit;
            end;

            if Length(astr) - 1 <= 0 then exit;

            if (AttribClass.CurLife <= 5000) and (SysopScope < 100) then begin
               SendClass.SendChatMessage (Conv('삶제矜瞳50鹿�區�'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if SysopScope < 100 then
               AttribClass.CurLife := AttribClass.CurLife - 2000;

            sColor := SAY_COLOR_GRADE0;
            with AttribClass do begin
               //n := 600 + Age div 2 + Magic + InPower + OutPower + Life;
               n := 600 + Age div 2 + Magic + InPower + OutPower + Age + 2100;
            end;
            n := (n - 5000) div 4000;
            if n < 0 then n := 0;
            if n > 11 then n := 11;
            case n of
               0..6 : sColor := SAY_COLOR_GRADE0;
               7  :   sColor := SAY_COLOR_GRADE1;
               8  : sColor := SAY_COLOR_GRADE2;
               9  : sColor := SAY_COLOR_GRADE3;
               10 : sColor := SAY_COLOR_GRADE4;
               11 : sColor := SAY_COLOR_GRADE5;
            end;

            if SysopScope >= 100 then sColor := SAY_COLOR_GRADE5;

            UserList.SendNoticeMessage ('['+Name+'] : '+Copy (astr,2, Length(astr)-1), sColor);
         end;
         '*':
            if Assigned(Self.Team) then
                Self.Team.TellEveryOne(Name + '>>' + Copy (astr, 2, Length(aStr) - 1), SAY_COLOR_TEAM);
      else begin
         SetWordString (SubData.SayString, Name + ': ' + astr);
         SendLocalMessage (NOTARGETPHONE, FM_SAY, BasicData, SubData);
      end;
   end;
end;

procedure TUser.InputStringProcess (var code: TWordComData);
var
   sname, searchstr : string;
   pCInputString : PTCInputString;
   TempUser : TUser;
   tempdir, TempLength : integer;
begin
   pCInputString := @Code.Data;

   case InputStringState of
      InputStringState_None         :;
      InputStringState_AddExchange  :;
      InputStringState_Search       :  // if rSelectedList then ;;
         begin
            InputStringState := InputStringState_None;
            sname := GetWordString (pCInputString^.rInputString);

            if sname = '' then begin
               SendClass.SendChatMessage (Conv('決꿴코휭꼇닸瞳'), SAY_COLOR_SYSTEM);
               exit;
            end;
            if SearchTick + 1000 > mmAnsTick then begin
              SendClass.SendChatMessage (Conv('헝�牘斬蔓뇟�'), SAY_COLOR_SYSTEM);
              exit;
            end;
            SearchTick := mmAnsTick;

            TempUser := UserList.GetUserPointer (sname);

            if TempUser = nil then begin
               SendClass.SendChatMessage (format (Conv('%s꼇瞳。'),[sname]), SAY_COLOR_SYSTEM);
               exit;
            end;
            if TempUser.SysopScope >= 100 then begin
               SendClass.SendChatMessage (Conv('늪훙角푤쾨GM。轟랬決꿴'), SAY_COLOR_SYSTEM);
               exit;
            end;
            if TempUser.ServerID <> ServerID then begin
               SendClass.SendChatMessage (format (Conv('%s瞳 %s。'),[sname, TempUser.Manager.Title]), SAY_COLOR_SYSTEM);
               exit;
            end;
            searchstr := '';
            TempLength := GetLargeLength (BasicData.x, BasicData.y, TempUser.PosX, TempUser.Posy);
            tempdir := GetViewDirection (BasicData.x, BasicData.y, TempUser.PosX, TempUser.Posy);
            case tempdir of
               0 : searchstr := INI_NORTH;
               1 : searchstr := INI_NORTHEAST;
               2 : searchstr := INI_EAST;
               3 : searchstr := INI_EASTSOUTH;
               4 : searchstr := INI_SOUTH;
               5 : searchstr := INI_SOUTHWEST;
               6 : searchstr := INI_WEST;
               7 : searchstr := INI_WESTNORTH;
            end;

            if TempLength < 30 then searchstr := format (Conv('瞳 %s쟁。'),[searchstr])
            else searchstr := format (Conv('%s瞳陶뇹。'),[searchstr]);
            SendClass.SendChatMessage (searchstr, SAY_COLOR_SYSTEM);
         end;
   end;
end;

procedure TUser.DragProcess (var code: TWordComData);
var
   pcDragDrop : PTCDragDrop;
begin
   pcDragDrop := @Code.Data;
   Case pcDragDrop^.rSourWindow of
      WINDOW_ITEMS :
         begin
            Case pcDragDrop^.rDestWindow of
               WINDOW_ITEMS : HaveItemClass.ChangeItemProcess (pcDragDrop, ShowWindowClass);
               WINDOW_WEARS :
                  begin
                     if MagicStep = ms_wait then exit;
                     //if LifeObjectState = los_spellcasting then exit;
                     HaveItemClass.DressOnProcess (pcDragDrop, ShowWindowClass, WearItemClass, HaveMagicClass);
                  end;
               WINDOW_SCREEN :
                  begin
                     if (boMoveAllItem = false) or (boMoveItem = false) then begin
                        SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     if Manager.boNotDeal = true then exit;
                     if PassWord <> '' then begin
                        SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     if Manager.boItemDrop = false then begin
                        SendClass.SendChatMessage (Conv('꼇콘땔瞳뒈��'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     HaveItemClass.PutOnScreenProcess (pcDragDrop, ShowWindowClass);
                  end;
               WINDOW_EXCHANGE :
                  begin
                     if (boMoveAllItem = false) or (boMoveItem = false) then begin
                        SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);                     
                        exit;
                     end;
                     if Manager.boNotDeal = true then exit;                  
                     if PassWord <> '' then begin
                        SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     HaveItemClass.PutOnExchangeProcess (pcDragDrop, ShowWindowClass);
                  end;
               WINDOW_SSAMZIEITEM :
                  begin
                     if (boMoveAllItem = false) or (boMoveItem = false) then begin
                        SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     if PassWord <> '' then begin
                        SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     HaveItemClass.PutOnItemLogProcess (pcDragDrop, ShowWindowClass);
                  end;
               // add by Orber at 2005-01-06 11:00:46
               WINDOW_GUILDITEMLOG :
                  begin
                     if (boMoveAllItem = false) or (boMoveItem = false) then begin
                        SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     if PassWord <> '' then begin
                        SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     HaveItemClass.PutOnGuildItemLogProcess (pcDragDrop, ShowWindowClass);
                  end;
               WINDOW_TRADE :
                  begin
                     if boMoveAllItem = false then begin
                        SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);                     
                        exit;
                     end;
                     if PassWord <> '' then begin
                        SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     ShowWindowClass.FromItemToTradeWindow (pcDragDrop);
                  end;
               WINDOW_SKILL :
                  begin
                     if (boMoveAllItem = false) or (boMoveItem = false) then begin
                        SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     // add by Orber at 2004-09-10 10:53
                     if HaveItemClass.HaveItemArr[pcDragDrop^.rsourkey].rLockState <> 0 then begin
                        SendClass.SendChatMessage (Conv('膠틔속傑櫓，꼇콘�薨�'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     if Manager.boNotDeal = true then exit;                  
                     if ShowWindowClass.AllowWindowAction (swk_none) = false then exit;
                     // if HaveMarketClass.boMarketing = true then exit;
                     if BasicData.Feature.rfeaturestate = wfs_shop then exit;                     
                     if PassWord <> '' then begin
                        SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     HaveItemClass.PutOnMaterialProcess (pcDragDrop, ShowWindowClass, HaveJobClass);
                  end;
               WINDOW_SALE :
                  begin
                     if boMoveAllItem = false then begin
                        SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);                     
                        exit;
                     end;
                     if Manager.boNotDeal = true then exit;                     
                     if PassWord <> '' then begin
                        SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     ShowWindowClass.FromItemToSaleWindow(pcDragDrop);
                  end;
               WINDOW_MARKET :
                  begin
                     if boMoveAllItem = false then begin
                        SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);                     
                        exit;
                     end;
                     if Manager.boNotDeal = true then exit;                  
                     if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

                     if ShowWindowClass.AllowWindowAction (swk_none) = false then exit;
                     if PassWord <> '' then begin
                        SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     HaveItemClass.PutOnMarketProcess (pcDragDrop, ShowWindowClass, HaveMarketClass);
                  end;
            end;
         end;
      WINDOW_MAGICS :
         begin
            Case pcDragDrop^.rDestWindow of
               WINDOW_MAGICS : HaveMagicClass.ChangeMagic (pcDragDrop^.rsourkey, pcDragDrop^.rdestkey);
            end;
         end;
      WINDOW_RISEMAGICS :
         begin
            Case pcDragDrop^.rDestWindow of
               WINDOW_RISEMAGICS : HaveMagicClass.ChangeRiseMagic (pcDragDrop^.rsourkey, pcDragDrop^.rdestkey);
            end;
         end;
      WINDOW_MYSTERYMAGICS:
         begin
            Case pcDragDrop^.rdestwindow of
               WINDOW_MYSTERYMAGICS : HaveMagicClass.ChangeMysteryMagic (pcDragDrop^.rsourkey, pcDragDrop^.rdestkey);
            end;
         end;
      WINDOW_BESTMAGIC:
         begin
            Case pcDragDrop^.rdestwindow of
               WINDOW_BESTMAGIC : HaveMagicClass.ChangeBestMagic (pcDragDrop^.rsourkey, pcDragDrop^.rdestkey);
            end;
         end;
      WINDOW_WEARS :
         begin
            Case pcDragDrop^.rDestWindow of
               WINDOW_ITEMS : WearItemClass.DressOffProcess (pcDragDrop, ShowWindowClass, HaveItemClass,HaveMagicClass);
            end;
         end;
      WINDOW_SCREEN :
         begin
            Case pcDragDrop^.rDestWindow of
               WINDOW_SCREEN : begin
                  if (boMoveAllItem = false) or (boMoveItem = false) then begin
                     SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
                  if Manager.boNotDeal = true then exit;
                  ShowWindowClass.PickUpScreenProcess (pcDragDrop);
               end;
               WINDOW_ITEMS : begin
                  if Manager.boNotDeal = true then exit;               
                  ShowWindowClass.PickUpItemWindowProcess (pcDragDrop);
               end;
            end;
         end;
      WINDOW_SSAMZIEITEM :
         begin
            Case pcDragDrop^.rDestWindow of
               WINDOW_ITEMS : begin
                  if boMoveAllItem = false then begin
                     SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
                  if PassWord <> '' then begin
                     SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
                  ShowWindowClass.FromItemLogToItemWindow (pcDragDrop);
               end;
            end;
         end;
  // add by Orber at 2005-01-06 11:00:46
      WINDOW_GUILDITEMLOG :
          begin
             if (boMoveAllItem = false) or (boMoveItem = false) then begin
                SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);
                exit;
             end;
             if PassWord <> '' then begin
                SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                exit;
             end;
             ShowWindowClass.FromGuildItemLogToItemWindow (pcDragDrop);
          end;
      WINDOW_TRADE :
         begin
            Case pcDragDrop^.rDestWindow of
               WINDOW_ITEMS : begin
                  if boMoveAllItem = false then begin
                     SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
                  if PassWord <> '' then begin
                     SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
                  ShowWindowClass.FromTradeToItemWindow (pcDragDrop);
               end;
            end;
         end;
      WINDOW_SKILL :
         begin
            Case pcDragDrop^.rDestWindow of
               WINDOW_ITEMS :
                  begin
                     if boMoveAllItem = false then begin
                        SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);                     
                        exit;
                     end;
                     if Manager.boNotDeal = true then exit;                  
                     // if HaveMarketClass.boMarketing = true then exit;
                     if BasicData.Feature.rfeaturestate = wfs_shop then exit;                                       
                     if ShowWindowClass.AllowWindowAction (swk_none) = false then exit;                  
                     if PassWord <> '' then begin
                        SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     HaveJobClass.FromSkillToItemWindow (pcDragDrop, ShowWindowClass);
                  end;
            end;
         end;
      WINDOW_SALE :
         begin
            Case pcDragDrop^.rDestWindow of
               WINDOW_ITEMS : begin
                  if boMoveAllItem = false then begin
                     SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
                  if Manager.boNotDeal = true then exit;
                  if PassWord <> '' then begin
                     SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
                  ShowWindowClass.FromSaleToItemWindow (pcDragDrop);
               end;
            end;
         end;
      WINDOW_MARKET :
         begin
            Case pcDragDrop^.rDestWindow of
               WINDOW_ITEMS :
                  begin
                     if boMoveAllItem = false then begin
                        SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);                     
                        exit;
                     end;
                     if Manager.boNotDeal = true then exit;                  
                     if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;
                     if ShowWindowClass.AllowWindowAction (swk_none) = false then exit;
                     HaveMarketClass.FromMarketToItemWindow (pcDragDrop, ShowWindowClass);
                  end;
            end;
         end;
      WINDOW_INDIVIDUALMARKET :
         begin
            Case pcDragDrop^.rDestWindow of
               WINDOW_ITEMS : begin
                  if boMoveAllItem = false then begin
                     SendClass.SendChatMessage (Conv ('君瞳꼇콘盧땡膠틔'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
                  if Manager.boNotDeal = true then exit;
                  if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;
                                 
                  if PassWord <> '' then begin
                     SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
                  ShowWindowClass.FromIndividualMarketToItemWindow (pcDragDrop);
               end;
            end;
         end;
   end;
end;

procedure TUser.MessageProcess (var code: TWordComData);
var
   CurTick : integer;
   i, hfu, tmpKey : integer;
   MagicData : TMagicData;
   ItemData : TItemData;
   xx, yy: word;
   str, iname : string;
   SubData : TSubData;
   pckey : PTCkey;
   pcHit : PTCHit;
   pcsay : PTCSay;
   pcMove : PTCMove;
   pcClick : PTCClick;
   pcWindowConfirm : PTCWindowConfirm;
   pcDragDrop : PTCDragDrop;
   pcMouseEvent : PTCMouseEvent;
   pcNetState : PTCNetState;
   pcShortCut : PTCSetShortCut;
   pcPassword : PTCPassword;
   pcSelectCount : PTCSelectCount;
   pcSelectMarketCount : PTCSelectMarketCount;
   pcMarketConfirm : PTCMarketConfirm;
   pcEventInput : PTCEventInput;
   pcAddStatePoint : PTCAddStatePoint;
   pcSetMaterial : PTCSetMaterial;
   pcSystemInfo : PTCSystemInfoData;   
   pcLockItem   : PTLockItem;
   tmpBasicData : TBasicData;
   psGuildInfo : TSGuildInfo;
   GuildObject : TGuildObject;

   BObject : TBasicObject;
   ExUser : TUser;

   ComData : TWordComData;

   ExchangeData : TExchangeData;
  //Author:Steven Date: 2004-12-13 11:21:46
  //Note:
  pcInvitation: PTSInvitation;
  nByte: Byte;
  searchstr: String;
begin
   pckey := @Code.Data;

   CurTick := mmAnsTick;
   LastPacketTick := CurTick;
   if pcKey^.rMsg = CM_NETSTATE then NetStateReturnTick := CurTick;

   if (BasicData.Feature.rfeaturestate = wfs_die) and
      (pckey^.rmsg <> CM_SAY) and
      (pcKey^.rMsg <> CM_WINDOWCONFIRM) and
      (pcKey^.rMsg <> CM_NETSTATE) and
      (pcKey^.rMsg <> CM_GETTIME) then exit;

   if (ShowWindowClass.CurrentWindow = swk_alert)
      and (ShowWindowClass.CurrentSubType = sst_gameagree) then begin
      if (pcKey^.rMsg <> CM_WINDOWCONFIRM) and
         (pcKey^.rMsg <> CM_NETSTATE) then exit;
   end;

   if LastCM_Message = pcKey^.rMsg then begin
      inc (LastCM_MessageCount);
      LastCM_MessageSum := LastCM_MessageSum + (CurTick - LastCM_MessageTick);
   end else begin
      LastCM_MessageCount := 0;
      LastCM_MessageSum := 0;
   end;
   LastCM_MessageTick := CurTick;
   LastCM_Message := pcKey^.rmsg;

   if LastCM_Message = CM_MOVE then begin
//      frmMain.WriteLogInfo (format ('%s count: %d Tick: %d', [Name, LastCM_MessageCount, LastCM_MessageTick]));

      // pinetree
      if LastCM_MessageCount >= 5 then begin
         if LastCM_MessageSum <= 10 then begin
//            frmMain.WriteLogInfo (format ('Abnormal Flying User %s', [Name]));
            exit;
         end;
      end;
   end;

   try
   case pckey^.rmsg of
      CM_GETTIME :
         begin
            str := DateToStr(Date) + ' ' + TimeToStr(Time);
            SendClass.SendTime (Str);            
         end;
      CM_SETSHORTCUT :
         begin
            pcShortCut := @Code.Data;
            if pcShortCut^.rButton >= 8 then exit;
            if pcShortCut^.rPosition > 175 then exit;

            for i := 0 to 8 - 1 do begin
               if ShortCut [i] = pcShortCut^.rPosition then begin
                  ShortCut [i] := 0;
               end;
            end;
            ShortCut [pcShortCut^.rButton] := pcShortCut^.rPosition;
         end;
      CM_NETSTATE :
         begin
            pCNetState := @Code.Data;

            MoveMsgCount := 0;

            if CurTick >= pCNetState^.rMadeTick + 50 then begin
               FillChar (SaveNetState, SizeOf (TCNetState), 0);
               exit;
            end;
            if (SaveNetState.rID = 0) or (pCNetState^.rID - SaveNetState.rID > 1) then begin
               Move (pCNetState^, SaveNetState, SizeOf (TCNetState));
               exit;
            end;
            if pCNetState^.rCurTick - SaveNetState.rCurTick >= 600 then begin
               if boCheckSpeed = true then begin
                  MacroChecker.SaveMacroCase (Name, 4);
                  ConnectorList.CloseConnectByCharName (Name);
               end;
            end;

            if (pCNetState^.rAnswer1 <> oz_CRC32(@NetStateQuestion, 16)) or
               (pCNetState^.rAnswer2 <> oz_CRC32(PByte(pCNetState), sizeof(TCNetState)-sizeof(Cardinal))) then
            begin
               MacroChecker.SaveMacroCase (Name, 4);
               ConnectorList.CloseConnectByCharName (Name);
            end;

            Move (pCNetState^, SaveNetState, SizeOf (TCNetState));
            exit;
         end;
      CM_MOUSEEVENT : // 마우스 이벤트 처리... 메크로...
         begin
            pcMouseEvent := @Code.data;
            str := Name + ',';
            for i := 0 to 10 - 1 do begin
               str := str + IntToStr(pcMouseEvent^.rEvent[i]) + ',';
            end;
            UdpSendMouseEvent (Str);

            // 매크로인가를 체크하여 유저의 접속을 종료시킨다
            MacroChecker.AddMouseEvent (pcMouseEvent, CurTick);
            if MacroChecker.Check (Name) then begin
               ConnectorList.CloseConnectByCharName (Name);
            end;
         end;
      CM_SELECTCOUNT :
         begin
            if CM_MessageTick[CM_SELECTCOUNT] + 50 > CurTick then exit;
            CM_MessageTick[CM_SELECTCOUNT] := CurTick;
            pcSelectCount := PTCSelectCount (@Code.Data);

            if PassWord <> '' then begin
               SendClass.SendChatMessage (Conv('唐쵱쯤�擁�'), SAY_COLOR_SYSTEM);
               exit;
            end;
            ShowWindowClass.SelectCount (pcSelectCount);
         end;
      CM_CANCELEXCHANGE  :
         begin
            if CM_MessageTick[CM_CANCELEXCHANGE] + 50 > CurTick then exit;
            CM_MessageTick[CM_CANCELEXCHANGE] := CurTick;

            ShowWindowClass.GetExchangeData (ExchangeData);
            if ExChangeData.rExChangeId <> 0 then begin
               SendClass.SendChatMessage(Conv('혤句슥弄'), SAY_COLOR_SYSTEM);
               BObject := TBasicObject (UserList.GetUserPointerById (ExChangeData.rExchangeId));
               if BObject <> nil then begin
                  ExUser := TUser(BObject);
                  ExUser.SendClass.SendChatMessage(Conv('슥弄굳혤句'), SAY_COLOR_SYSTEM);
                  ExUser.FieldProc (ExChangeData.rExchangeId, FM_CANCELEXCHANGE, BasicData, SubData);
               end;

               tmpBasicData.id := ExChangeData.rExChangeId;
               SendLocalMessage (BasicData.id, FM_CANCELEXCHANGE, tmpBasicData, SubData);

               FillChar (ExChangeData, SizeOf (TExchangeData), 0);
               ShowWindowClass.SetExchangeData (ExchangeData);
            end;
         end;
      CM_INPUTSTRING :
         begin
            if CM_MessageTick[CM_INPUTSTRING] + 50 > CurTick then exit;
            CM_MessageTick[CM_INPUTSTRING] := CurTick;
            InputStringProcess (Code);
         end;
      CM_DRAGDROP :
         begin
            if CM_MessageTick[CM_DRAGDROP] + 50 > CurTick then exit;
            CM_MessageTick[CM_DRAGDROP] := CurTick;
            if AllowLifeObjectState = false then exit;

            if BasicData.Feature.rfeaturestate = wfs_shop then exit;            
            DragProcess (Code);
         end;
      CM_DBLCLICK :
         begin
            if CM_MessageTick[CM_DBLCLICK] + 30 > CurTick then exit;

            CM_MessageTick[CM_DBLCLICK] := CurTick;
            //CM_MessageTick[CM_CLICK] := CurTick; //2002-08-06 giltae 임시코드
            pcClick := @Code.Data;

            if boCanAttacked = false then exit; //2003-10 LockDown            
            if BasicData.Feature.rfeaturestate = wfs_shop then exit;

            case pcclick^.rwindow of
               WINDOW_SCREEN :
                  begin
                     if ShowWindowClass.CurrentWindow <> swk_none then exit;

                     if (pcclick^.rclickedId <> 0) then begin
                        if IsObjectItemID (pcclick^.rclickedid) then begin
                           FillChar (ComData, SizeOf (TCDragDrop) + SizeOf (Word), 0);
                           ComData.Size := SizeOf (TCDragDrop);
                           pcDragDrop := @ComData.Data;
                           pcDragDrop^.rmsg := CM_DRAGDROP;
                           pcDragDrop^.rsourwindow := WINDOW_SCREEN;
                           pcDragDrop^.rdestwindow := WINDOW_ITEMS;
                           pcDragDrop^.rsourId := pcclick^.rclickedid;
                           DragProcess (ComData);
                           exit;
                        end;

                        SendLocalMessage (pcclick^.rclickedid, FM_DBLCLICK, BasicData, SubData);

                        if HaveMagicClass.pCurEctMagic <> nil then begin
                           if HaveMagicClass.pCurEctMagic^.rFunction = MAGICFUNC_REFILL then begin
                              SendLocalMessage (pcclick^.rclickedid, FM_REFILL, BasicData, SubData);
                              exit;
                           end;
                        end;
                     end;

                     if isStaticItemId(pcclick^.rclickedId) then begin
                        if WearItemClass.GetWearItemName(ARR_WEAPON) = Conv('同쳔뉨') then
                            SetTargetId (pcclick^.rclickedid);
                        exit;
                     end;

                     if isUserID(pcclick^.rclickedId) then begin
                        //묑샌鯤소
                        if Assigned(Team) then begin
                            if not Team.CheckEnableHit(pcclick^.rclickedId) then begin
                                SSendChatMessage(Conv('莉뚠櫓轟랬묑샌'),SAY_COLOR_SYSTEM);
                                Exit;
                            end;
                        end;
                     end;

                     if pcclick^.rclickedId <>0 then begin
                        if ( HaveMagicClass.pCurAttackMagic <> nil ) and
                           ( HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MYSTERY) then begin
                           if BasicData.Feature.rfeaturestate = wfs_sitdown then exit;
                           if isMonsterID (pcclick^.rclickedID) = true then begin
                              if isMonsterId (PrevTargetID) = true then begin
                                 if boCanAttack = true then SetTargetId (pcclick^.rclickedid);
                                 exit;
                              end;
                           end;
                           if isUserID (pcclick^.rclickedID) = true then begin
                              if isUserId (PrevTargetID) = true then begin
                                 if (boCanAttack = true) then
                                    SetTargetId (pcclick^.rclickedid);
                                 exit;
                              end;
                           end;
                           exit;
                        end;
                     end;

                     if (BasicData.Feature.rFeatureState = wfs_care) and (pcclick^.rclickedId <> 0) then begin
                        if pcclick^.rclickedid = TargetID then exit;
                        if PrevTargetId <> 0 then begin
                           if isMonsterID (pcclick^.rclickedID) = true then begin
                              if isMonsterId (PrevTargetID) = true then begin
                                 if boCanAttack = true then SetTargetId (pcclick^.rclickedid);
                                 exit;
                              end;
                           end;
                           if isUserID (pcclick^.rclickedID) = true then begin
                              if isUserId (PrevTargetID) = true then begin
                                 if (boCanAttack = true) then
                                    SetTargetId (pcclick^.rclickedid);
                                 exit;
                              end;
                           end;
                        end;
                        if TargetId <> 0 then begin
                           if isMonsterId (pcclick^.rclickedId) = true then begin
                              if isMonsterId (TargetID) = true then begin
                                 if boCanAttack = true then SetTargetId (pcclick^.rclickedid);
                                 exit;
                              end;
                           end;
                           if isUserId (pcclick^.rclickedId) = true then begin
                              if isUserId (TargetID) = true then begin
                                 if (boCanAttack = true) then
                                    SetTargetId (pcclick^.rclickedid);
                                 exit;
                              end;
                           end;
                        end;
                     end;

                     if (ssShift in pcclick^.rShift) and (pcclick^.rclickedId <> 0) then begin
                        if isMonsterId (pcclick^.rclickedId) = true then begin
                           if boCanAttack = true then SetTargetId (pcclick^.rclickedid);
                        end;
                        if isDynamicObjectId (pcclick^.rclickedId) = true then begin
                           if boCanAttack = true then SetTargetId (pcclick^.rclickedid);
                        end;
                        exit;
                     end;
                     if (ssCtrl in pcclick^.rShift) and (pcclick^.rclickedId <> 0) then begin
                        if isUserId (pcclick^.rclickedId) = true then begin
                           if (boCanAttack = true) then
                              SetTargetId (pcclick^.rclickedid);
                        end;
                        if isDynamicObjectId (pcclick^.rclickedId) = true then begin
                           if boCanAttack = true then SetTargetId (pcclick^.rclickedid);
                        end;
                        exit;
                     end;
                     // add by Orber at 2005-02-04 19:09:38
                     nByte := Maper.GetAreaIndex (pcclick^.rX, pcclick^.rY );

                     case nByte of
                        66:
                            begin
                              aArenaIndex := 0;
                              if not ArenaObjList.CheckArena(aArenaIndex) then begin
                                  SendClass.SendChatMessage(Conv('맡잗憩뻘청唐역迦徠항삶땡！'),SAY_COLOR_SYSTEM);
                                  Exit;
                              end;
                              if SGetSex = 2 then begin
                                  SSendChatMessage(Conv('괠퓔，큽却轟랬꽝속댔잗！'),SAY_COLOR_SYSTEM);
                                  Exit;
                              end;
                              if Lover = '' then begin
                                  SendClass.SendShowJoinArenaWindow(Conv('콱拳狼�驅ⓖ┵승鼎�'));
                              end else begin
                                  SSendChatMessage(Conv('괠퓔，콱綠쒔써삯죄！'),SAY_COLOR_SYSTEM);
                              end;
                            end;
                        65:
                            begin
                              aArenaIndex := 1;
                              if not ArenaObjList.CheckArena(aArenaIndex) then begin
                                  SendClass.SendChatMessage(Conv('맡잗憩뻘청唐역迦徠항삶땡！'),SAY_COLOR_SYSTEM);
                                  Exit;
                              end;
                              if SGetSex = 2 then begin
                                  SSendChatMessage(Conv('괠퓔，큽却轟랬꽝속댔잗！'),SAY_COLOR_SYSTEM);
                                  Exit;
                              end;
                              if Lover = '' then begin
                                  SendClass.SendShowJoinArenaWindow(Conv('콱拳狼�驅ⓖ┵승鼎�'));
                              end else begin
                                  SSendChatMessage(Conv('괠퓔，콱綠쒔써삯죄！'),SAY_COLOR_SYSTEM);
                              end;

                            end;
                     end;
                  end;
               WINDOW_ITEMS :
                  begin
                     if ShowWindowClass.CurrentWindow <> swk_none then exit;
                     if BasicData.Feature.rfeaturestate = wfs_shop then exit;

                     if boCanAttacked = false then exit; //040427 LockDown
                  // add by Orber at 2004-09-29 at 12:27

                     //HaveMagicClass.DblClickItemMagic(pcClick,WearItemClass,HaveItemClass);
                     HaveItemClass.DblClickProcess (pcClick, ShowWindowClass, WearItemClass, HaveMagicClass, UserQuestClass, HaveJobClass);
                  end;
               WINDOW_WEARS :
                  begin
                  end;
               WINDOW_MAGICS:
                  begin
                     if ShowWindowClass.CurrentWindow <> swk_none then exit;
                     // if HaveMarketClass.boMarketing = true then exit;
                     if BasicData.Feature.rfeaturestate = wfs_shop then exit;
                     if MagicStep = ms_wait then exit;
                     //if LifeObjectState = los_spellcasting then exit;
                     HaveMagicClass.DblClickMagicProcess (pcClick, ShowWindowClass, WearItemClass, HaveItemClass);
                  end;
               WINDOW_BASICFIGHT:
                  begin
                     if ShowWindowClass.CurrentWindow <> swk_none then exit;
                     // if HaveMarketClass.boMarketing = true then exit;
                     if BasicData.Feature.rfeaturestate = wfs_shop then exit;                     
                     if MagicStep = ms_wait then exit;
                     //if LifeObjectState = los_spellcasting then exit;
                     
                     HaveMagicClass.DblClickBasicMagicProcess (pcClick, ShowWindowClass, WearItemClass, HaveItemClass);
                  end;
               WINDOW_RISEMAGICS:
                  begin
                     if ShowWindowClass.CurrentWindow <> swk_none then exit;
                     // if HaveMarketClass.boMarketing = true then exit;
                     if BasicData.Feature.rfeaturestate = wfs_shop then exit;                     
                     if MagicStep = ms_wait then exit;
                     //if LifeObjectState = los_spellcasting then exit;
                     HaveMagicClass.DblClickRiseMagicProcess (pcClick, ShowWindowClass, WearItemClass, HaveItemClass);
                  end;
               WINDOW_MYSTERYMAGICS:
                  begin
                     if ShowWindowClass.CurrentWindow <> swk_none then exit;
                     // if HaveMarketClass.boMarketing = true then exit;
                     if BasicData.Feature.rfeaturestate = wfs_shop then exit;                     
                     //if LifeObjectState = los_spellcasting then exit;
                     if MagicStep = ms_wait then exit;
                     HaveMagicClass.DblClickMysteryMagicProcess (pcClick, ShowWindowClass, WearItemClass, HaveItemClass);
                  end;
               WINDOW_BESTMAGIC:
                  begin
                     if ShowWindowClass.CurrentWindow <> swk_none then exit;
                     if BasicData.Feature.rfeaturestate = wfs_shop then exit;
                     if MagicStep = ms_wait then exit;
                     HaveMagicClass.DblClickBestMagicProcess (pcClick, ShowWindowClass, WearItemClass, HaveItemClass);
                  end;
               else exit;
            end;
         end;
      CM_CLICK :
         begin
            if CM_MessageTick[CM_CLICK] + 30 > CurTick then exit;
            CM_MessageTick[CM_CLICK] := CurTick;
            //CM_MessageTick[CM_DBLCLICK] := CurTick; //2002-08-06 giltae 임시코드

            pcClick := @Code.Data;

            if BasicData.Feature.rfeaturestate = wfs_shop then exit;
            case pcclick^.rwindow of
               WINDOW_EXCHANGE:
                  begin
                     ShowWindowClass.ClickExChange (pcclick^.rwindow, pcclick^.rclickedId, pcclick^.rkey);
                  end;
               WINDOW_BASICFIGHT:
                  begin
                     if not HaveMagicClass.ViewBasicMagic (pcclick^.rkey, @MagicData) then exit;
                     str := GetMagicDataInfo (MagicData);
                     SendClass.SendChatMessage (str, SAY_COLOR_NORMAL);
                  end;
               WINDOW_MAGICS:
                  begin
                     if not HaveMagicClass.ViewMagic (pcclick^.rkey, @MagicData) then exit;
                     str := GetMagicDataInfo (MagicData);
                     SendClass.SendChatMessage (str, SAY_COLOR_NORMAL);
                  end;
               WINDOW_RISEMAGICS:
                  begin
                     if not HaveMagicClass.ViewRiseMagic (pcclick^.rkey, @MagicData) then exit;
                     str := GetMagicDataInfo (MagicData);
                     SendClass.SendChatMessage (str, SAY_COLOR_NORMAL);
                  end;
               WINDOW_MYSTERYMAGICS:
                  begin
                     if not HaveMagicClass.ViewMysteryMagic (pcclick^.rkey, @MagicData) then exit;
                     str := GetMagicDataInfo (MagicData);
                     SendClass.SendChatMessage (str, SAY_COLOR_NORMAL);
                  end;
               WINDOW_BESTMAGIC:
                  begin
                     if not HaveMagicClass.ViewBestMagic (pcclick^.rkey, @MagicData) then exit;
                     if MagicData.rMagicType = MAGICTYPE_BESTSPECIAL then exit;                     
                     str := GetMagicDataInfo (MagicData);
                     SendClass.SendChatMessage (str, SAY_COLOR_NORMAL);
                  end;
               WINDOW_ITEMS :
                  begin
                     if not HaveItemClass.ViewItem (pcclick^.rkey, @ItemData) then exit;
                     str := GetItemDataInfo (ItemData);
                     SendClass.SendChatMessage (str, SAY_COLOR_NORMAL);
                  end;
               WINDOW_SCREEN :
                  begin
                     if pcclick^.rclickedID = 0 then begin
                            nByte := Maper.GetAreaIndex(pcClick^.rX, pcClick^.rY);
                            if (nByte > 49) and (nByte < 60) then
                            begin
                                GuildObject := GuildList.GetGuildByType(nByte);
                                if GuildObject <> nil then begin
                                    if (GuildObject.GuildName <> '') and (Not GuildObject.IsGuildDelete) then begin
                                    psGuildInfo := GuildObject.GetInfo;
                                    SendClass.SendShowGuildInfoWindow(psGuildInfo);
                                    end;
                                end;
                                exit;
                            end;
                     end;
                     if pcclick^.rclickedId <> 0 then begin
                        if IsObjectItemID (pcclick^.rclickedid) then begin
                           FillChar (ComData, SizeOf (TCDragDrop) + SizeOf (Word), 0);
                           ComData.Size := SizeOf (TCDragDrop);
                           pcDragDrop := @ComData.Data;
                           pcDragDrop^.rmsg := CM_DRAGDROP;
                           pcDragDrop^.rsourwindow := WINDOW_SCREEN;
                           pcDragDrop^.rdestwindow := WINDOW_ITEMS;
                           pcDragDrop^.rsourId := pcclick^.rclickedid;
                           DragProcess (ComData);
                        end else begin
                           SubData.boMarketing := false;
                           SendLocalMessage (pcclick^.rclickedId, FM_CLICK, BasicData, SubData);
                           if SubData.boMarketing = true then begin
                              if IsUserID(pcclick^.rclickedId) then begin
                                 BObject := TBasicObject (UserList.GetUserPointerById (pcclick^.rclickedId));
                                 if BObject <> nil then begin
                                    ShowWindowClass.MarketUser := BObject;
                                    ShowWindowClass.IndividualMarketWindow;
                                 end;
                              end;
                           end else begin
                              SendClass.SendChatMessage (GetWordString (SubData.SayString), SAY_COLOR_SYSTEM);
                           end;
                        end;
                     end else begin
                        //가상 오브젝트 체크함.
                        if Manager.VirtualObjectList = nil then exit;
                        if TVirtualObjectList (Manager.VirtualObjectList).Count > 0 then begin
                           SubData.tx := pcclick^.rX;
                           SubData.ty := pcclick^.rY;
                           TVirtualObjectList (Manager.VirtualObjectList).SendFMMessage(BasicData,SubData);
                        end;

                        // 중국용 경신무흔. 클릭하면 어디든(??) 간다.. -ㅅ-;; 040422 saset
                        if (pCurEctMagic <> nil) and (pCurEctMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) and
                           (pCurEctMagic^.rKind = MAGIC_KIND_KYUNGSIN) then begin
                           xx := pcclick^.rX;
                           yy := pcclick^.rY;

                           if GetCellLength (BasicData.x, BasicData.y, xx, yy) > 10 then begin
                              SendClass.SendChatMessage (Conv ('쐐岺놔흙늪뒈'), SAY_COLOR_SYSTEM); 
                              exit;
                           end;

                           if Maper.isMoveable (xx, yy) = true then begin
                              FPosMoveX := xx;
                              FPosMoveY := yy;
                           end; 
                        end;
                     end;
                  end;
               WINDOW_POWERLEVEL :
                  begin
                     if Manager.boUsePowerLevel = false then begin
                        SendClass.SendChatMessage (Conv('꼇콘역쓸'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  
                     case pcclick^.rkey of
                        0 :       // 왼쪽마우스클릭
                           begin
                              if HaveMagicClass.PowerLevelUP = false then begin
                                 SendClass.SendChatMessage (Conv('轟랬疼瓊멕죄'), SAY_COLOR_SYSTEM);
                              end else begin
                                 if HaveMagicClass.CurPowerLevel > 0 then begin
                                    ShowEffect2 (POWERLEVEL_EFFECT_NUM + HaveMagicClass.CurPowerLevel - 1, lek_follow, 0);
                                 end;
                              end;
                           end;
                        1 :       // 오른쪽마우스클릭
                           begin
                              if HaveMagicClass.PowerLevelDOWN = false then begin
                                 SendClass.SendChatMessage (Conv('轟랬疼슉됴죄'), SAY_COLOR_SYSTEM);
                              end else begin
                                 if HaveMagicClass.CurPowerLevel > 0 then begin
                                    ShowEffect2 (POWERLEVEL_EFFECT_NUM + HaveMagicClass.CurPowerLevel - 1, lek_follow, 0);
                                 end;
                              end;
                           end;
                     end;
                  end;
               else exit;
            end;
         end;
      CM_HIT :
         begin
            if ShowWindowClass.CurrentWindow <> swk_none then exit;

            if CM_MessageTick[CM_HIT] + 50 > CurTick then exit;
            CM_MessageTick[CM_HIT] := CurTick;

            if boCanAttack = false then exit;
            // if Manager.boHit = false then exit;

            pchit := @Code.Data;
            if pcHit^.rkey <> BasicData.dir then CommandTurn (pcHit^.rkey, FALSE);

            if HaveMagicClass.pCurAttackMagic = nil then exit;

            if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
               if TargetID = 0 then exit;
            end;

            if HaveMagicClass.pCurSpecialMagic <> nil then begin
               CommandCriticalAttack (mmAnsTick, pcHit^.rtid, pcHit^.rtx, pcHit^.rty);
            end else begin
               case HaveMagicClass.pCurAttackMagic^.rMagicType of
                  MAGICTYPE_BOWING, MAGICTYPE_THROWING :
                     begin
                        if pcHit^.rkey <> BasicData.dir then CommandTurn (pcHit^.rkey, FALSE);
                        CommandBowing (mmAnsTick, pcHit^.rtid, pcHit^.rtx, pcHit^.rty, FALSE);
                     end;
                  MAGICTYPE_WINDOFHAND :
                     begin
                        if BasicData.Feature.rfeaturestate = wfs_sitdown then exit;
                        CommandWindOfHand_new (mmAnsTick, pcHit^.rtid,pcHit^.rtx, pcHit^.rty);
                     end;
                  else
                     begin
                        if pcHit^.rkey <> BasicData.dir then CommandTurn (pcHit^.rkey, FALSE);
                        CommandHit (mmAnsTick, FALSE);
                     end;
               end;
            end;
         end;
      CM_KEYDOWN :
         begin
            if CM_MessageTick[CM_KEYDOWN] + 30 > CurTick then exit;
            CM_MessageTick[CM_KEYDOWN] := CurTick;

            pckey := @Code.Data;
            case pckey^.rkey of
               VK_F2 :
                  begin
                     // if HaveMarketClass.boMarketing = true then exit;
                     if boCanAttacked = false then exit; //040427 LockDown                     
                     if BasicData.Feature.rfeaturestate = wfs_shop then exit;                     
                     if AllowLifeObjectState = false then exit;
                     if BasicData.Feature.rfeaturestate = wfs_normal then CommandChangeCharState (wfs_care)
                     else CommandChangeCharState (wfs_normal);
                  end;
               VK_F3 :
                  begin
                     if boCanAttacked = false then exit; //040427 LockDown                  
                     // if HaveMarketClass.boMarketing = true then exit;
                     if BasicData.Feature.rfeaturestate = wfs_shop then exit;                     
                     if AllowLifeObjectState = false then exit;
                     CommandChangeCharState (wfs_sitdown);
                  end;
               VK_F4 :
                  begin
                     if boCanAttacked = false then exit; //040427 LockDown                     
                     if AllowLifeObjectState = false then exit;
                     if BasicData.Feature.rFeatureState = wfs_normal then begin
                        SubData.motion := AM_HELLO;
                        SubData.MagicState := 0;
                        SubData.MagicKind := 0;
                        SubData.MagicColor := 0;
                        SendLocalMessage ( NOTARGETPHONE, FM_MOTION, BasicData, SubData);
                     end;
                  end;
               VK_F5 :;
               VK_F6 :;
               VK_F7 :;
               VK_F8 :;
            end;
            if BasicData.Feature.rFeaturestate = wfs_normal then SetTargetId (0);
         end;
      CM_TURN :
         begin
            if ShowWindowClass.CurrentWindow <> swk_none then exit;

            pckey := @Code.Data;
            BasicData.dir := pckey^.rkey;
            SendLocalMessage ( NOTARGETPHONE, FM_TURN, BasicData, SubData);
         end;
      CM_MOVE :
         begin
            inc (MoveMsgCount);

            pcMove := @Code.data;
            if MoveMsgCount = 6 then begin
               tmpKey := pcMove^.rTick;
               pcMove^.rTick := 5;
               pcMove^.rTick := oz_CRC32 (@Code.Data, SizeOf (TCMove));
               pcMove^.rTick := oz_CRC32 (@Code.Data, SizeOf (TCMove));

               if tmpKey <> pcMove.rTick then begin
                  MacroChecker.SaveMacroCase (Name, 4);
                  ConnectorList.CloseConnectByCharName (Name);
                  exit;
               end;
            end;

            if (ShowWindowClass.CurrentWindow <> swk_none) or (BasicData.Feature.rfeaturestate = wfs_shop) then begin
               SendClass.SendSetPosition (BasicData);
               exit;
            end;

            if MagicStep = ms_wait then exit;

            // Lan Cable 을 UnPlug 한채 이동하는 것을 막기 위한 코드
            // if CM_MessageTick[CM_MOVE] + 10 > CurTick then exit;
            CM_MessageTick[CM_MOVE] := CurTick;

            pcMove := @Code.data;
            if (boCanMove = true) and (pcMove^.rx = BasicData.x) and (pcMove^.ry = basicData.y) then begin
               if pcMove^.rdir <> basicData.dir then begin
                  BasicData.dir := pcMove^.rdir;
                  CommandTurn(BasicData.dir, false);
               end;

               xx := pcMove^.rx; yy := pcMove^.ry;
               GetNextPosition (pcMove^.rdir, xx, yy);
            // add by Orber at 2005-01-14 17:25:41
                nByte := Maper.GetAreaIndex (xx, yy );
                if nByte = 60 then begin
                    if inZhuang then begin
                        inZhuang := False;
                        //self.SetPosition();
                        Exit;
                    end;
                    Str := zhuang.GetZhuangInto(self);
                    if Str = 'fight' then begin
                        self.SSendChatMessage(Conv('앱鳩鏤커품瞳뚤濫榴檄，콱꼇콘쏵흙'),SAY_COLOR_SYSTEM);
                        self.SetPosition(230,903);
                        Exit;
                    end;
                    if Str = 'noticket' then begin
                        SSendChatMessage(Conv('콱청唐쳔튿꼇콘쏵흙'),SAY_COLOR_SYSTEM);
                        SetPosition(230,903);
                        Exit;
                    end;
                    inZhuang := True;
                    self.SetPosition(239,892);
                    Exit;
                end;
                if nByte = 61 then begin
                    inZhuang := False;
                    self.SetPosition(230,903);
                    Exit;
                end;

                if aArenaType = 2 then begin
                  if nByte <> 63 then begin
                    SSendChatMessage(Conv('拳狼徑텝렴폴?'),SAY_COLOR_SYSTEM);
                    exit;
                  end;
                end;

                if nByte = 63 then begin
                    if aArenaType = 0 then begin
                        SSendChatMessage(Conv('잗憩혐堵轟랬쏵흙'),SAY_COLOR_SYSTEM);
                        self.SetPosition(self.BasicData.x,self.BasicData.y);
                        Exit;
                    end;
                end;

                if Zhuang.FightState then begin
                  if nByte = 64 then begin
                    SSendChatMessage(Conv('렷濫떱끝뒈，董珂꼇콘쏵흙'),SAY_COLOR_SYSTEM);
                        self.SetPosition(FPosMoveX,FPosMoveY);
                    exit;
                  end;
                end;

               if Maper.isMoveable2 (xx, yy, hfu) then begin

                  BasicData.nx := xx;
                  BasicData.ny := yy;
                  Phone.SendMessage ( NOTARGETPHONE, FM_MOVE, BasicData, SubData);
                  Maper.MapProc (BasicData.id, MM_MOVE, BasicData.x, basicData.y, xx, yy, BasicData);
                  BasicData.dir := pcMove^.rdir;
                  BasicData.x := xx; BasicData.y := yy;
                // add by Orber at 2004-10-11 16:16:33

                  if (State <> wfs_running) then begin
                      if WearItemClass.GetWearItemName(ARR_SHOES) = Conv('섣醵棄') then begin
                            CommandChangeCharState (wfs_running);
                            SpeedShoes := True;
                      end;
                  end;
                  if (State = wfs_running) and (SpeedShoes) then begin
                      if WearItemClass.GetWearItemName(ARR_SHOES) <> Conv('섣醵棄') then begin
                            CommandChangeCharState (wfs_normal);
                            SpeedShoes :=  False;
                      end;
                  end;
                  HaveMagicClass.AddWalking(StrPas(@HaveItemClass.HaveItemArr[0].rName));
                  exit;
               end else begin
                  SendClass.SendSetPosition (BasicData);
                  exit;
               end;
            end else begin
               SendClass.SendSetPosition (BasicData);
               exit;
            end;

            xx := BasicData.x; yy := BasicData.y;
            GetNextPosition ( pcMove^.rdir, xx, yy);
            if Maper.isMoveable2 (xx, yy, hfu) then begin
               {
               if BasicData.dir <> pcMove^.rdir then begin
                  BasicData.dir := pcMove^.rdir;
                  SendLocalMessage ( NOTARGETPHONE, FM_TURN, BasicData, SubData);
               end;
               }

               BasicData.nx := xx;
               BasicData.ny := yy;
               Phone.SendMessage ( NOTARGETPHONE, FM_MOVE, BasicData, SubData);
               Maper.MapProc (BasicData.id, MM_MOVE, BasicData.x, basicData.y, xx, yy, BasicData);
               BasicData.dir := pcMove^.rdir;
               BasicData.x := xx; BasicData.y := yy;
               HaveMagicClass.AddWalking(StrPas(@HaveItemClass.HaveItemArr[0].rName));
            end else begin
               {
               if IsObjectItemID(hfu) then begin
                  frmMain.WriteLogInfo (format ('SetPosition %d ObjectItem ID2',[hfu]));
               end else if IsUserID (hfu) then begin
                  frmMain.WriteLogInfo (format ('SetPosition %d UserID2',[hfu]));
               end else if IsMonsterID (hfu) then begin
                  frmMain.WriteLogInfo (format ('SetPosition %d Monster ID2',[hfu]));
               end else if IsCallMonsterID (hfu) then begin
                  frmMain.WriteLogInfo (format ('SetPosition %d CallMonster ID2',[hfu]));
               end else if IsStaticItemID (hfu) then begin
                  frmMain.WriteLogInfo (format ('SetPosition %d StaticItem ID2',[hfu]));
               end else if IsDynamicObjectID (hfu) then begin
                  frmMain.WriteLogInfo (format ('SetPosition %d DynamicObject ID2',[hfu]));
               end;
               }

               BasicData.dir := pcMove^.rdir;
               SendLocalMessage ( NOTARGETPHONE, FM_TURN, BasicData, SubData);
               SendClass.SendSetPosition(BasicData);
            end;
         end;
      CM_SAY :
         begin
            if CM_MessageTick[CM_SAY] + 50 > CurTick then exit;
            CM_MessageTick[CM_SAY] := CurTick;

            if boCanSay = false then exit;

            pcSay := @Code.Data;
            // change by minds 050919
            str := GetSayString(pcSay^.rWordString);
            //str := GetWordString (pcSay^.rWordString);
            UserSay (str);
         end;
      CM_WINDOWCONFIRM :
         begin
            if CM_MessageTick[CM_WINDOWCONFIRM] + 30 > CurTick then exit;
            CM_MessageTick[CM_WINDOWCONFIRM] := CurTick;

            pcWindowConfirm := @Code.Data;
            ShowWindowClass.ConfirmWindowProcess (pcWindowConfirm);
         end;
      CM_MAKEGUILDMAGIC :
         begin
            ShowWindowClass.MakeGuildMagic (GuildName, Code);
         end;
      CM_MINIMAP :
         begin
            if Manager.boShowMiniMap = true then begin
               str := TDynamicObjectList (Manager.DynamicObjectList).GetDynPosStr;
               if Assigned(Team) then
               begin
                 str := str + ',' + Team.GetMemberPosStr(Name);
               end;
               SendClass.SendMiniMapInfo (str);
               //SendClass.SendMiniMapInfo ('');
            end else begin
               Str := TNpcList (Manager.NpcList).GetNpcPosStr;
               iName := GateList.GetGatePosByStr (Manager);
               if iName <> '' then begin
                  if Str <> '' then Str := Str + ',';
                  Str := Str + iName;
               end;
               if Assigned(Team) then
               begin
                 str := str + ',' + Team.GetMemberPosStr(Name);
               end;
               if Str <> '' then begin
                  SendClass.SendMiniMapInfo (Str);
               end;
            end;
         end;
      CM_PASSWORD :
         begin
            pcPassword := @Code.Data;
            pcPassWord^.rNewPass [8] := 0;
            
            case pcPassWord^.rOption of
               1 :  // 쌈지비번설정
                  begin
                     Str := ItemLog.SetPassword (Name, StrPas (@pcpassword^.rNewPass));
                     SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
                  end;
               2 :  // 쌈지비번해제
                  begin
                     Str := ItemLog.FreePassword (Name, StrPas (@pcpassword^.rNewPass));
                     SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
                  end;
               3 :  // 비번설정
                  begin
                     Str := SetPassword (StrPas (@pcpassword^.rNewPass));
                     SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
                  end;
               4 :  // 비번해제
                  begin
                     Str := FreePassword (StrPas (@pcpassword^.rNewPass));
                     SendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
                  end;
            end;
         end;
      CM_SELECTHELPWINDOW :
         begin
            if CM_MessageTick[CM_SELECTHELPWINDOW] + 30 > CurTick then exit;
            CM_MessageTick[CM_SELECTHELPWINDOW] := CurTick;

            ShowWindowClass.SelectHelpWindow (@Code.Data);
         end;
      CM_SELECTITEMWINDOW :
         begin
            if CM_MessageTick[CM_SELECTITEMWINDOW] + 30 > CurTick then exit;
            CM_MessageTick[CM_SELECTITEMWINDOW] := CurTick;

            pcClick := @Code.Data;
            case pcclick^.rwindow of
               WINDOW_EXCHANGE, WINDOW_TRADE, WINDOW_SALE :
                  begin
                     ShowWindowClass.SelectItemWindow (pcClick);
                  end;
               WINDOW_INDIVIDUALMARKET :
                  begin
                     if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;
                     ShowWindowClass.SelectItemWindow (pcClick);
                  end;
               WINDOW_MARKET :
                  begin
                     if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;
                     HaveMarketClass.SelectItemWindow (pcClick);
                  end;
               WINDOW_ITEMS :
                  begin
                     HaveItemClass.SelectItemWindow (pcClick);
                  end;
               WINDOW_BASICFIGHT, WINDOW_MAGICS, WINDOW_RISEMAGICS,
               WINDOW_MYSTERYMAGICS, WINDOW_BESTMAGIC :
                  begin
                     HaveMagicClass.SelectItemWindow (pcClick);
                  end;
            end;
         end;
      CM_TRADEWINDOW :
         begin
            if CM_MessageTick[CM_TRADEWINDOW] + 30 > CurTick then exit;
            CM_MessageTick[CM_TRADEWINDOW] := CurTick;

            ShowWindowClass.SelectTradeWindow (@Code.Data);
         end;

      CM_MARRY :
        begin
            if CM_MessageTick[CM_MARRY] + 30 > CurTick then exit;
            CM_MessageTick[CM_MARRY] := CurTick;

            ShowWindowClass.SelectMarryWindow (@Code.Data);
        end;

      CM_UNMARRY :
        begin
            if CM_MessageTick[CM_MARRY] + 30 > CurTick then exit;
            CM_MessageTick[CM_MARRY] := CurTick;

            ShowWindowClass.SelectUnMarryWindow (@Code.Data);
        end;

      CM_MARRYANSWER :
        begin
            if CM_MessageTick[CM_MARRYANSWER] + 30 > CurTick then exit;
            CM_MessageTick[CM_MARRYANSWER] := CurTick;

            ShowWindowClass.SelectMarryAnswerWindow (@Code.Data);
        end;
      CM_GUILDITEMPAGE :
        begin
            if CM_MessageTick[CM_GUILDITEMPAGE] + 30 > CurTick then exit;
            CM_MessageTick[CM_GUILDITEMPAGE] := CurTick;
            ShowWindowClass.SelectGuildItemWindow (@Code.Data);
        end;
      // add by Steven at 2005-01-11 11:29:22
      CM_INPUTGUILDNAME:
        begin
          if CM_MessageTick[CM_INPUTGUILDNAME] + 30 > CurTick then exit;
          CM_MessageTick[CM_INPUTGUILDNAME] := CurTick;

          ShowWindowClass.SelectInputGuildNameWindow(@Code.Data);
        end;
      // add by Orber at 2005-01-11 22:53:44
      CM_GUILDMONEYCHIP://쳔逃횅훰瓊운鑒띨
        begin
          if CM_MessageTick[CM_GUILDMONEYCHIP] + 30 > CurTick then exit;
          CM_MessageTick[CM_GUILDMONEYCHIP] := CurTick;

          ShowWindowClass.SelectInputGuildMoneyChipWindow(@Code.Data);
        end;
      CM_GUILDMONEYAPPLY://쳔寮횅훰瓊혤닸운
        begin
          if CM_MessageTick[CM_GUILDMONEYAPPLY] + 30 > CurTick then exit;
          CM_MessageTick[CM_GUILDMONEYAPPLY] := CurTick;

          ShowWindowClass.SelectInputGuildMoneyApplyWindow(@Code.Data);
        end;
      CM_GUILDSUBSYSOP://쳔寮횅훰
        begin
          if CM_MessageTick[CM_GUILDSUBSYSOP] + 30 > CurTick then exit;
          CM_MessageTick[CM_GUILDSUBSYSOP] := CurTick;

          ShowWindowClass.SelectInputGuildSubSysopWindow(@Code.Data);
        end;
      CM_ARENAWINDOW://쳔寮횅훰
        begin
          if CM_MessageTick[CM_ARENAWINDOW] + 30 > CurTick then exit;
          CM_MessageTick[CM_ARENAWINDOW] := CurTick;
          ShowWindowClass.SelectInputArenaWindow(@Code.Data);
        end;
      CM_ARENAJOINWINDOW://쳔寮횅훰
        begin
          if CM_MessageTick[CM_ARENAWINDOW] + 30 > CurTick then exit;
          CM_MessageTick[CM_ARENAWINDOW] := CurTick;
          ShowWindowClass.SelectInputArenaJoinWindow(@Code.Data);
        end;
      CM_GUILDANSWERWINDOW://쳔寮횅훰
        begin
          if CM_MessageTick[CM_GUILDANSWERWINDOW] + 30 > CurTick then exit;
          CM_MessageTick[CM_GUILDANSWERWINDOW] := CurTick;
          ShowWindowClass.SelectGuildAnswerWindow(@Code.Data);
        end;
      CM_SKILLWINDOW : // 기술창 활성화 버튼 클릭시
         begin
            if CM_MessageTick[CM_SKILLWINDOW] + 30 > CurTick then exit;
            CM_MessageTick[CM_SKILLWINDOW] := CurTick;

            if ShowWindowClass.AllowWindowAction (swk_none) = false then exit;
            if PassWord <> '' then begin
               SendClass.SendChatMessage (Conv('唐�阮쳉堡�'), SAY_COLOR_SYSTEM);
               exit; 
            end;

            if (HaveJobClass.JobKind <> JOB_KIND_NONE) or (AttribClass.ExtJobKind = JOB_KIND_MINER) then begin
               SendClass.SendSkillWindow (HaveJobClass.JobImageShape, HaveJobClass.JobKindStr, HaveJobClass.JobGradeStr, HaveJobClass.JobToolStr, SGetExtJobGrade, SGetExtJobLevel);
            end else begin
               SendClass.SendChatMessage (Conv('헝邱朞嶝斂撚'), SAY_COLOR_SYSTEM);
            end;
         end;
      CM_MAKEITEM : // 기술창 제조 버튼 클릭시
         begin
            if CM_MessageTick[CM_MAKEITEM] + 30 > CurTick then exit;
            CM_MessageTick[CM_MAKEITEM] := CurTick;

            HaveJobClass.ConfirmMakeItem;
         end;
      CM_PROCESSITEM : // 기술창 가공 버튼 클릭시
         begin
            if CM_MessageTick[CM_PROCESSITEM] + 30 > CurTick then exit;
            CM_MessageTick[CM_PROCESSITEM] := CurTick;

            HaveJobClass.ConfirmProcessItem;
         end;
      CM_SELECTMARKETCOUNT :
         begin
            if CM_MessageTick[CM_SELECTMARKETCOUNT] + 50 > CurTick then exit;
            CM_MessageTick[CM_SELECTMARKETCOUNT] := CurTick;
            pcSelectMarketCount := PTCSelectMarketCount (@Code.Data);
            ShowWindowClass.SelectMarketCount (pcSelectMarketCount);
         end;
      CM_CONFIRMMARKET :
         begin
            if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;
                     
            if CM_MessageTick[CM_CONFIRMMARKET] + 50 > CurTick then exit;
            CM_MessageTick[CM_CONFIRMMARKET] := CurTick;

            pcMarketConfirm := PTCMarketConfirm (@Code.Data);
            HaveMarketClass.ConfirmMarketProcess (pcMarketConfirm, ShowWindowClass);
         end;
      CM_ADDSTATEPOINT :
         begin
            if CM_MessageTick[CM_ADDSTATEPOINT] + 50 > CurTick then exit;
            CM_MessageTick[CM_ADDSTATEPOINT] := CurTick;

            if PassWord <> '' then begin
               SendClass.SendChatMessage (Conv ('唐�阮쳉堡�'), SAY_COLOR_SYSTEM);
               exit;
            end;

            pcAddStatePoint := PTCAddStatePoint (@Code.Data);
            HaveMagicClass.AddStatePoint (pcAddStatePoint);
         end;
      CM_EVENTINPUT : begin
         {
         if CM_MessageTick[CM_EVENTINPUT] + 50 > CurTick then exit;
         CM_MessageTick[CM_EVENTINPUT] := CurTick;

         pcEventInput := PTCEventInput (@Code.Data);
         if pcEventInput^.rboCheck = false then exit;
         UserList.SendTopLetterMessage (Name, pcEventInput^.rMsg1, pcEventInput^.rMsg2);
         }
      end;
      CM_SETMATERIAL : begin
         if CM_MessageTick[CM_SETMATERIAL] + 50 > CurTick then exit;
         CM_MessageTick[CM_SETMATERIAL] := CurTick;

         pcSetMaterial := PTCSetMaterial (@Code.Data);
         if ShowWindowClass.AllowWindowAction (swk_none) = false then exit;
         HaveJobClass.PutOnAutoMaterialProcess (pcSetMaterial);
      end;
      CM_ITEMBUTTON : begin
         if CM_MessageTick [CM_ITEMBUTTON] + 50 > CurTick then exit;
         CM_MessageTick [CM_ITEMBUTTON] := CurTick;

         pcKey := PTCKey (@Code.Data);

         case pcKey^.rkey of
            0 : begin   // 사대공력전서
               HaveItemClass.DestroyItembyAttribKind (ITEM_ATTRIBUTE_PAPERBESTPROTECT);
            end;
            1 : begin   // 초식패전서
               HaveItemClass.DestroyItembyAttribKind (ITEM_ATTRIBUTE_PAPERBESTSPECIAL);
            end;
         end;
      end;
      CM_LOCKITEM : begin
         if CM_MessageTick [CM_ITEMBUTTON] + 50 > CurTick then exit;
         CM_MessageTick [CM_ITEMBUTTON] := CurTick;

         pcLockItem := PTLockItem (@Code.Data);
         if HaveItemClass.HaveItemArr[pcLockItem^.rkey].rLockState <> 1 then begin
               HaveItemClass.HaveItemArr[pcLockItem^.rkey].rLockState   := 1;
               HaveItemClass.HaveItemArr[pcLockItem^.rkey].runLockTime  := 0;
               //HaveItemClass.SaveOneToSdb(pcLockItem^.rkey,@Connector.CharData);
               SendClass.SendHaveItem (pcLockItem^.rkey, HaveItemClass.HaveItemArr[pcLockItem^.rkey]);
               SendClass.SendChatMessage (Conv('膠틔속傑냥묘'), SAY_COLOR_SYSTEM);
         end else begin
               SendClass.SendChatMessage (Conv('膠틔綠쒔瞳傑땍櫓，꼇矜狼路릿속傑'), SAY_COLOR_SYSTEM);
         end;
      end;
      CM_UNLOCKITEM : begin
         if CM_MessageTick [CM_ITEMBUTTON] + 50 > CurTick then exit;
         CM_MessageTick [CM_ITEMBUTTON] := CurTick;

         pcLockItem := PTLockItem (@Code.Data);
         case HaveItemClass.HaveItemArr[pcLockItem^.rkey].rLockState of
         0:
         begin
               SendClass.SendChatMessage (Conv('膠틔청唐속傑'), SAY_COLOR_SYSTEM);
         end;
         1:
         begin
               HaveItemClass.HaveItemArr[pcLockItem^.rkey].rLockState := 2;
               HaveItemClass.HaveItemArr[pcLockItem^.rkey].runLockTime:= 0;
               //HaveItemClass.SaveOneToSdb(pcLockItem^.rkey,@Connector.CharData);
               SendClass.SendHaveItem (pcLockItem^.rkey, HaveItemClass.HaveItemArr[pcLockItem^.rkey]);
               SendClass.SendChatMessage (Conv('膠틔역迦썩傑'), SAY_COLOR_SYSTEM);
         end;
         2:
         begin
               SendClass.SendChatMessage (Conv('膠틔攣瞳썩傑櫓'), SAY_COLOR_SYSTEM);
         end;
         end;
      end;
      CM_SYSTEMINFO :
         begin
            pcSystemInfo := @Code.Data;
            UserSystemInfoClass.AddUserInfo (StrPas (@Connector.CharData.MasterName), pcSystemInfo);
         end;
      //Author:Steven Date: 2004-12-12 13:42:42
      //Note:
      CM_COMFIRMINVITATION:
        begin
          //
          pcInvitation := @Code.Data;
          AcceptInvitation(pcInvitation);
        end;
      ///////////////////////////////////////
   end;
   except
      frmMain.WriteLogInfo (format ('TUser(%s).MessageProcess () failed', [Name]));
      frmMain.WriteDumpInfo (@Code, SizeOf (TWordComData));
      frmMain.WriteDumpInfo (@BasicData, SizeOf (TBasicData));
      frmMain.WriteDumpInfo (@Manager.ServerID, SizeOf (Integer));
   end;
end;

function  TUser.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i, Key, aKey, nCount, mCount : Integer;
   str : string;
   per : integer;
   boFlag : Boolean;
   SubData : TSubData;
   ExChangeUser : TUser;
   SaveHideState : THiddenState;
   ExchangeData, tmpExchangeData : TExchangeData;
   ItemData : TItemData;
   tmpManager : TManager;
begin
   Result := PROC_FALSE;
   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;

   if SysopObj <> nil then begin
      TUser(SysopObj).FieldProc2 (hfu, Msg, SenderInfo, aSubData);
   end;

   if (botv = true) and (Msg <> FM_SAY) then exit;

   case Msg of
      FM_LIFEPERCENT :
         begin
            SendClass.SendStructed (SenderInfo, aSubData.percent);
         end;
      FM_KILL :
         begin
            if BasicData.Feature.rFeatureState <> wfs_die then exit;
            ShowEffect2 (8, lek_follow, 0);

            BasicData.nX := BasicData.X;
            BasicData.nY := BasicData.Y;
            SubData.ServerId := Manager.ServerID;
            for i := 0 to 10 - 1 do begin
               Key := Random (HAVEITEMSIZE);
               HaveItemClass.ViewItem (Key, @SubData.ItemData);
               if SubData.ItemData.rName [0] <> 0 then begin
                  SignToItem (SubData.ItemData, ServerID, SenderInfo, '');
                  if Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicData, SubData) = PROC_TRUE then begin
                     HaveItemClass.DeleteKeyItem (Key, SubData.ItemData.rCount, @SubData.ItemData);
                     exit;
                  end;
               end;
            end;
            for i := 0 to 30 - 1 do begin
               HaveItemClass.ViewItem (i, @SubData.ItemData);
               if SubData.ItemData.rName [0] <> 0 then begin
                  SignToItem (SubData.ItemData, ServerID, SenderInfo, '');
                  if Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicData, SubData) = PROC_TRUE then begin
                     HaveItemClass.DeleteKeyItem (i, SubData.ItemData.rCount, @SubData.ItemData);
                     exit;
                  end;
               end;
            end;
         end;
      FM_REFILL :
         begin
            if (hfu = NOTARGETPHONE) or (hfu = BasicData.id) then begin
               AttribClass.CurEnergy := AttribClass.Energy;
               AttribClass.CurInPower := AttribClass.InPower;
               AttribClass.CurOutPower := AttribClass.OutPower;
               AttribClass.CurMagic := AttribClass.Magic;
               AttribClass.CurLife := AttribClass.Life;
               AttribClass.CurHeadLife := AttribClass.HeadLife;
               AttribClass.CurArmLife := AttribClass.ArmLife;
               AttribClass.CurLegLife := AttribClass.LegLife;
               HaveMagicClass.CurShield := HaveMagicClass.MaxShield;
               DiedTick := 0;
               SendClass.SendAttribBase (AttribClass);
               SendClass.SendAttribValues (AttribClass);
               SendClass.SendAbilityAttrib (LifeData, AddAttribData, pCurAttackMagic);
            end;
         end;
      FM_SHOWEXCHANGE :
         begin
            ExChangeUser := TUser (SendLocalMessage ( SenderInfo.id, FM_GIVEMEADDR, BasicData, SubData));
            if (Integer (ExChangeUser) = 0) or (integer(ExChangeUser) = -1) then exit;
            ShowWindowClass.GetExchangeData (ExchangeData);
            ExchangeUser.ShowWindowClass.GetExchangeData (tmpExchangeData);

            ShowWindowClass.ShowExchangeWindow (@ExChangeData, @tmpExChangeData);
         end;
      FM_CANCELEXCHANGE :
         begin
            ShowWindowClass.CancelExchange;
            Result := PROC_TRUE;
         end;
      FM_ENOUGHSPACE :
         begin
            if HaveItemClass.FreeSpace >= 1 then begin Result := PROC_TRUE; exit; end;
         end;
      FM_GATE :
         begin
            if hfu <> BasicData.id then exit;

            FPosMoveX := SenderInfo.nx;
            FPosMoveY := SenderInfo.ny;
            if ServerID <> aSubData.ServerId then begin
               ServerID := aSubData.ServerId;
               FboNewServer := TRUE;
            end;
         end;
      FM_REPOSITION :
         begin
            if hfu <> BasicData.id then exit;

            if Maper.isMoveable (aSubData.tx, aSubData.ty) = true then begin
               FPosMoveX := aSubData.tx;
               FPosMoveY := aSubData.ty;
            end;
         end;
      FM_SOUND :
         begin
            SendClass.SendSoundEffect (GetWordString (aSubData.SayString), SenderInfo.x, SenderInfo.y);
         end;
      FM_SAYUSEMAGIC : SendClass.SendSayUseMagic (SenderInfo, GetWordString (aSubData.SayString) );
      FM_SAY :
         begin
            SendClass.SendSay (SenderInfo, GetWordString (aSubData.SayString) );
         end;
      FM_SHOUT : SendClass.SendChatMessage (GetWordString(aSubData.SayString), SAY_COLOR_SHOUT);
      FM_SHOW  :
         begin
            if UseSkillKind = ITEM_KIND_SHOWSKILL then begin
               SaveHideState := SenderInfo.Feature.rHideState;
               SenderInfo.Feature.rHideState := hs_100;
            end;
            if (CharType = CHAR_TYPE_HIGH_GRADE) and (BasicData.id = SenderInfo.id) then begin
               StrPCopy (@SenderInfo.ViewName, Conv('★ ') + StrPas (@SenderInfo.Name)); //생명
            end else if (CharType = CHAR_TYPE_LOW_GRADE) and (BasicData.id = SenderInfo.id) then begin
               StrPCopy (@SenderInfo.ViewName, Conv('◆ ') + StrPas (@SenderInfo.Name)); //부활
            end else if (CharType = CHAR_TYPE_WRITER) and (BasicData.id = SenderInfo.id) then begin
               StrPCopy (@SenderInfo.ViewName, Conv('♣ ') + StrPas (@SenderInfo.Name)); //기자단
            end else begin
            end;

            {// add by Orber at 2004-12-20 09:48:36  삯쟉
             if (ServerID = 89) then begin
                 if WearItemClass.GetWearItemName(ARR_UPOVERWEAR) = '劤읠敬陋' then begin
                   aSubData.EffectNumber := 8005;
                   aSubData.EffectKind := lek_continue;
                 end;
             end; }

            if SenderInfo.Id = BasicData.id then begin
               SendClass.SendShow (SenderInfo, aSubData.EffectNumber, aSubData.EffectKind);

            end
            else begin
               SendClass.SendShow (SenderInfo, aSubData.EffectNumber, aSubData.EffectKind,self.Vir_Move.rx,self.Vir_Move.ry);
            end;


            if UseSkillKind = ITEM_KIND_SHOWSKILL then begin
               SenderInfo.Feature.rHideState := SaveHideState;
            end;
         end;
      FM_HIDE  :
         begin
            SendClass.SendHide (SenderInfo);
         end;
      FM_STRUCTED :
         begin
            // if HaveMarketClass.boMarketing = true then exit;  // 개인판매창 활성화될땐 아무것도...
            if BasicData.Feature.rfeaturestate = wfs_shop then exit;
            if SenderInfo.Feature.rRace <> RACE_DYNAMICOBJECT then begin
               SendClass.SendMotion (SenderInfo.id, AM_STRUCTED, 0, 0, 0);
            end;
            SendClass.SendStructed (SenderInfo, aSubData.percent);
         end;
      FM_CHANGESTATE :
         begin
            SendClass.SendChangeState (SenderInfo);
         end;
      FM_CHANGEFEATURE :
         begin
            if UseSkillKind = ITEM_KIND_SHOWSKILL then begin
               SaveHideState := SenderInfo.Feature.rHideState;
               SenderInfo.Feature.rHideState := hs_100;
            end;
            SendClass.SendChangeFeature (SenderInfo);
            if UseSkillKind = ITEM_KIND_SHOWSKILL then begin
               SenderInfo.Feature.rHideState := SaveHideState;
            end;
         end;
      FM_CHANGEPROPERTY :
         begin
            if UseSkillKind = ITEM_KIND_SHOWSKILL then begin
               SaveHideState := SenderInfo.Feature.rHideState;
               SenderInfo.Feature.rHideState := hs_100;
            end;
            SendClass.SendChangeProperty (SenderInfo);
            if UseSkillKind = ITEM_KIND_SHOWSKILL then begin
               SenderInfo.Feature.rHideState := SaveHideState;
            end;
         end;
      FM_ADDWINDOFHANDEXP:
         begin
            if aSubData.attacker <> BasicData.id then exit;
            if HaveMagicClass.pPrevAttackMagic = nil then exit;
            if (aSubData.HitData.LimitSkill <> 0) and
               (aSubData.HitData.LimitSkill < HaveMagicClass.pPrevAttackMagic^.rcSkillLevel) then begin
               SendClass.SendChatMessage (Conv('轟랬셨崎瓊�暄�駱令'),SAY_COLOR_SYSTEM);
               exit;
            end;

            per := AttribClass.CurArmLife * 100 div AttribClass.Life;
            if per <= 50 then begin
               SendClass.SendChatMessage (Conv('凜槨묑샌제格흽랍청콘돤돕쒔駱令。'),SAY_COLOR_SYSTEM);
            end else begin
               boFlag := false;
               if isMonsterID (SenderInfo.ID) then boFlag := true;
               LastGainExp := HaveMagicClass.AddWindOfHandExp (aSubData.ExpData.ExpType, aSubData.ExpData.Exp, boFlag);
            end;
         end;
      FM_ADDLIFEORENERGY :
         begin
            if aSubData.attacker <> BasicData.id then exit;

            AttribClass.CurEnergy := AttribClass.CurEnergy + aSubData.EnergyStealValue;
            if AttribClass.CurEnergy > AttribClass.Energy then
               AttribClass.CurEnergy := AttribClass.Energy;
            AttribClass.CurLife := AttribClass.CurLife + aSubData.LifeStealValue;
            if AttribClass.CurLife > AttribClass.Life then
               AttribClass.CurLife := AttribClass.Life;
               
            if aSubData.EnergyStealValue <> 0 then ShowEffect2 (STEALENERGY_EFFECT_NUM + 1 + BasicData.dir, lek_follow, 0);
            if aSubData.LifeStealValue <> 0 then ShowEffect2 (STEALLIFE_EFFECT_NUM + 1 + BasicData.dir, lek_follow, 0);
         end;
      FM_ADDEXTRAEXP:
         begin
            if aSubData.ExpData.Exp < 0 then Exit;
            //Author:Steven Date: 2004-12-16 18:03:08
            //Note:흔벎唐莉뚠，瞳侶쟁롸썩쒔駱令
            if Assigned(Team) then
              Team.ShareExtraExp(aSubData.ExpData.Exp, self.ServerID)
            else
            //=======================================
              AttribClass.AddExtraExp (aSubData.ExpData.Exp);



         end;
      FM_ADDATTACKEXP  :
         begin
            if aSubData.attacker <> BasicData.id then exit;
            
            if (aSubData.HitData.LimitSkill <> 0 ) and
               ( aSubData.HitData.LimitSkill < HaveMagicClass.pCurAttackMagic.rcSkillLevel) then begin
               SendClass.SendChatMessage (Conv('轟랬셨崎瓊�暄�駱令'),SAY_COLOR_SYSTEM);
               exit;
            end;

            per := AttribClass.CurArmLife * 100 div AttribClass.Life;
            if per <= 50 then begin
               SendClass.SendChatMessage (Conv('凜槨묑샌제格흽랍청콘돤돕쒔駱令。'),SAY_COLOR_SYSTEM);
            end else begin
               boFlag := false;
               if isMonsterID (SenderInfo.ID) then boFlag := true;
               LastGainExp := HaveMagicClass.AddAttackExp (aSubData.ExpData.ExpType, aSubData.ExpData.Exp, boFlag, HaveItemClass);
            end;
         end;
      FM_ADDPROTECTEXP  :
         begin
            boFlag := false;
            if isMonsterID (aSubData.Attacker) then boFlag := true;
            HaveMagicClass.AddProtectExp (aSubData.ExpData.ExpType, aSubData.ExpData.Exp, boFlag);
         end;
      FM_ADDVIRTUEEXP :
         begin
            AttribClass.AddVirtue (aSubData.ExpData.Exp);
            if aSubData.ExpData.Exp < 0 then
               SendClass.SendChatMessage (format (Conv('뵈횔裂폭돨鑒令슉됴%d'), [-aSubData.ExpData.Exp]), SAY_COLOR_SYSTEM);
         end;
      FM_MOTION :
         begin
            if SenderInfo.id <> BasicData.id then begin
               SendClass.SendMotion (SenderInfo.id, aSubData.motion, aSubData.MagicState, aSubData.MagicKind, aSubData.MagicColor);
            end;
         end;
      FM_SETEFFECT :
         begin
            SendClass.SendEffect (SenderInfo, aSubData.Delay, aSubData.EffectKind, aSubData.EffectNumber);
         end;
      FM_TURN   :
         begin
            if SenderInfo.id <> BasicData.id then SendClass.SendTurn (SenderInfo,self.Vir_Move.rx,self.Vir_Move.ry);
         end;
      FM_BACKMOVE :
         begin
            if SenderInfo.id <> BasicData.id then begin

            SendClass.SendBackMove (SenderInfo,self.Vir_Move.rx,self.Vir_Move.ry);
            end
            else begin

            SendClass.SendBackMove (SenderInfo);

            end;
         end;
      FM_MOVE :
         begin
//            if (SenderInfo.id = BasicData.id) and (HaveMarketClass.boMarketing = true) then exit;  // 개인판매창 활성화될땐 아무것도...
            if SenderInfo.id <> BasicData.id then begin

            SendClass.SendMove (SenderInfo, self.Vir_Move.rx, self.Vir_Move.ry);
            end;
         end;
      FM_SYSOPMESSAGE : if SysopScope > aSubData.SysopScope then SendClass.SendChatMessage (GetWordString (aSubData.SayString), SAY_COLOR_SYSTEM);
      FM_ADDITEM :
         begin
            str := StrPas (@aSubData.ItemData.rName);
            if str = INI_ROPE then begin
               if BasicData.Feature.rFeatureState = wfs_die then begin
                  RopeTarget := SenderInfo.id;
                  RopeTick := mmAnsTick;
                  Result := PROC_TRUE;
                  exit;
               end;
            end;

            if aSubData.ItemData.rMaxCount > 0 then begin
               nCount := HaveItemClass.FindItemCountbyName (Str);
               mCount := HaveJobClass.FindItemCountbyName (Str);               
               if nCount + mCount >= aSubData.ItemData.rMaxCount then begin
                  SendClass.SendChatMessage(Conv('轟랬歌혤膠틔'),SAY_COLOR_NORMAL);
                  exit;
               end;
            end;

            boFlag := false;
            for i := 0 to 4 - 1 do begin
               if aSubData.ItemData.rNeedItem[i].rName[0] = 0 then break;
               str := StrPas (@aSubData.ItemData.rNeedItem[i].rName);
               if HaveItemClass.FindItemKeybyName(str) = -1 then begin
                  SendClass.SendChatMessage(Conv('矜狼唐훨蛟膠틔'),SAY_COLOR_NORMAL);
                  exit;
               end;
            end;

            for i := 0 to 4 - 1 do begin
               if aSubData.ItemData.rNotHaveItem[i].rName[0] = 0 then break;
               str := StrPas (@aSubData.ItemData.rNotHaveItem[i].rName);
               if HaveItemClass.FindItemKeybyName(str) <> -1 then begin
                  SendClass.SendChatMessage(Conv('轟랬歌혤膠틔'),SAY_COLOR_NORMAL);
                  exit;
               end;
            end;

            //필요조건을 만족했으므로.
            //1. 지워야되는 아이템은 지운다.
            if aSubData.ItemData.rSpecialKind <> ITEM_SPKIND_DELALLBYDURA then begin
               for i := 0 to 4 - 1 do begin
                  if aSubData.ItemData.rDelItem[i].rName[0] = 0 then break;
                  str := StrPas (@aSubData.ItemData.rDelItem[i].rName);
                  ItemClass.GetItemData(str, ItemData);
                  HaveItemClass.DeleteItem(@ItemData);
               end;
            end;

            //2. 추가해야되는 아이템은 추가한다.
            for i := 0 to 4 - 1 do begin
               if aSubData.ItemData.rAddItem[i].rName[0] = 0 then break;
               str := StrPas (@aSubData.ItemData.rAddItem[i].rName);
               ItemClass.GetItemData (str, ItemData);
               ItemData.rCount := aSubData.ItemData.rCount;
               HaveItemClass.AddItem (ItemData);
               SendClass.SendSideMessage (format (Conv('%s 삿돤 %d몸'), [StrPas (@ItemData.rViewName), ItemData.rCount]));
               boFlag := true;
            end;

            if boFlag = true then begin
               Result := PROC_TRUE;
            end else begin
               if HaveItemClass.AddItem (aSubData.ItemData) then begin
                  SendClass.SendSideMessage (format (Conv('%s 삿돤 %d몸'), [StrPas (@aSubData.ItemData.rViewName), aSubData.ItemData.rCount]));
                  Result := PROC_TRUE;
               end;
            end;
         end;
      FM_DELITEM : if HaveItemClass.DeleteItem (@aSubData.ItemData) then Result := PROC_TRUE;
      FM_DELKEYITEM :
         begin
            if HaveItemClass.DeleteKeyItem (aSubData.TargetId, aSubData.VassalCount, @aSubData.ItemData) then Result := PROC_TRUE;
         end;
      FM_BOW, FM_WINDOFHANDEFFECT : SendClass.SendShootMagic (SenderInfo, aSubData.TargetId, aSubData.tx, aSubData.ty, aSubData.BowImage, aSubData.BowSpeed, aSubData.BowType, aSubData.EffectNumber, aSubData.EffectKind);
      FM_AGREEALLYGUILD :
         begin
            if ShowWindowClass.CurrentWindow = swk_none then begin
               if GuildName = StrPas (@aSubData.GuildName) then exit;
               if FboAllyGuild = false then exit;
               ParamStr [0] := GuildName;
               ParamStr [1] := StrPas (@aSubData.GuildName);
               Str := format (Conv('%s 瓊놔써촉狼헹.角뤠谿雷?'), [ParamStr [1]]);
               SendClass.SendShowSpecialWindow (self, WINDOW_AGREE, AGREE_ALLYGUILD, Conv('횅훰써촉狼헹'), Str);
               ShowWindowClass.SetCurrentWindow (swk_bloodguild, sst_allyguild);

               SetWordString (SubData.SayString, Conv('헝�鍍�'));
            end else begin
               SetWordString (SubData.SayString, Conv('헝�牘慙木�'));
            end;
         end;
      FM_SAYSYSTEM :
         begin
            if SenderInfo.ID <> BasicData.ID then begin
               SendClass.SendChatMessage (GetWordString (aSubData.SayString), SAY_COLOR_SYSTEM);
            end;
         end;
      FM_SETPOSITION :
         begin
            SendClass.SendSetPosition (SenderInfo);
         end;
      FM_CHANGEDURAWATERCASE :
         begin
            if hfu = BasicData.id then begin
               aKey := HaveItemClass.FindKindItem (ITEM_KIND_WATERCASE);
               if aKey <> -1 then begin
                  if HaveItemClass.HaveItemArr[akey].rCurDurability =
                     HaveItemClass.HaveItemArr[aKey].rDurability then begin
                     exit;
                  end;

                  HaveItemClass.HaveItemArr[aKey].rCurDurability :=
                     HaveItemClass.HaveItemArr[aKey].rDurability;
                  HaveItemClass.WaterCaseItemCount := 1;
                  SendClass.SendSoundEffect('9367.wav', BasicData.x,BasicData.y);
                  SendClass.SendChatMessage(Conv('賂呱綠쒔陋찮彊죄'), SAY_COLOR_SYSTEM);
                  Result := PROC_TRUE;
               end;
            end;
         end;
      FM_FILLLIFE :
         begin
            if hfu = BasicData.id then begin
               // aKey := HaveItemClass.FindKindItem (ITEM_KIND_FILL);
               // if aKey = 1 then exit;

               if mmAnsTick < FillTick + 1500 then begin
                  SendClass.SendChatMessage (Conv('綠쒔괘죄，茄瞳뵌꼇죄彊죄'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               FillTick := mmAnsTick;

               if aSubData.SpellType = VIRTUALOBJ_KIND_FILLOASISLIFE then begin
                  AttribClass.CurEnergy := AttribClass.CurEnergy + aSubData.ShoutColor;
               end;

               AttribClass.CurLife := AttribClass.CurLife + aSubData.ShoutColor;    // 활력, 내, 외, 무공 올려줌
               AttribClass.CurInPower := AttribClass.CurInPower + aSubData.ShoutColor;
               AttribClass.CurOutPower := AttribClass.CurOutPower + aSubData.ShoutColor;
               AttribClass.CurMagic := AttribClass.CurMagic + aSubData.ShoutColor;
               SendClass.SendSoundEffect('9367.wav', BasicData.x,BasicData.y);
               SendClass.SendChatMessage(Conv('설혤듐웁홋彊뿟릿삶제'), SAY_COLOR_SYSTEM);
            end;
         end;         

   end;
end;

function  TUser.FieldProc2 (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
begin
   Result := PROC_FALSE;
   case Msg of
      FM_SOUND :
         begin
            SendClass.SendSoundEffect (GetWordString (aSubData.SayString), SenderInfo.x, SenderInfo.y );
         end;
      FM_SAYUSEMAGIC : SendClass.SendSayUseMagic (SenderInfo, GetWordString (aSubData.SayString) );
      FM_SAY   : SendClass.SendSay (SenderInfo, GetWordString (aSubData.SayString) );
      FM_SHOUT : SendClass.SendChatMessage (GetWordString(aSubData.SayString), SAY_COLOR_SHOUT);
      FM_SHOW  :
      begin
        SenderInfo.ServerID := ServerID;
       if SenderInfo.id = BasicData.id then begin
             SendClass.SendShow (SenderInfo, aSubData.EffectNumber, aSubData.EffectKind);

       end
       else begin
             SendClass.SendShow (SenderInfo, aSubData.EffectNumber, aSubData.EffectKind,self.Vir_Move.rx,self.Vir_Move.ry);
       end


      end;
      FM_HIDE  : SendClass.SendHide (SenderInfo);
      FM_STRUCTED      :
         begin
            if SenderInfo.Feature.rRace <> RACE_DYNAMICOBJECT then begin
               SendClass.SendMotion (SenderInfo.id, AM_STRUCTED, 0, 0, 0);
            end;
            SendClass.SendStructed (SenderInfo, aSubData.percent);
         end;
      FM_CHANGESTATE : SendClass.SendChangeState (SenderInfo);
      FM_CHANGEFEATURE : SendClass.SendChangeFeature (SenderInfo);
      FM_CHANGEPROPERTY : SendClass.SendChangeProperty (SenderInfo);
      FM_MOTION : SendClass.SendMotion (SenderInfo.id, aSubData.motion, aSubData.MagicState, aSubData.MagicKind, aSubData.MagicColor);
      FM_TURN : begin
         if SenderInfo.id = BasicData.id then begin
           SendClass.SendTurn (SenderInfo,self.Vir_Move.rx);
         end else begin
           SendClass.SendTurn (SenderInfo,self.Vir_Move.rx,self.Vir_Move.ry);
         end;
      end;
      FM_MOVE   : begin
         if SenderInfo.id <> BasicData.id then begin
            SendClass.SendMove (SenderInfo,self.Vir_Move.rx,self.Vir_Move.ry);
         end else begin
            SendClass.SendMove (SenderInfo);
         end;
      end;
      FM_BOW : SendClass.SendShootMagic (SenderInfo, aSubData.TargetId, aSubData.tx, aSubData.ty, aSubData.BowImage, aSubData.BowSpeed, aSubData.BowType, aSubData.EffectNumber, aSubData.EffectKind);
   end;
end;

procedure TUser.Update (CurTick: integer);
var
   i, cnt, iCurTick, nCount : integer;
   ComData : TWordComdata;
   SubData : TSubData;
   BObject : TBasicObject;
   tmpManager : TManager;
   boChangeFeature, boPass : Boolean;
   SrcData, DstData : array [0..15] of Byte;
   SrcLen, DstLen : Cardinal;
   PakEnMove    : TSMove;
   // add by minds 050916
   dwCheckTime: DWORD;
   pMsg: PTCKey;
   pCSay: PTCSay;
begin
   if boException = true then exit;

//   if (ShowWindowClass.CurrentWindow <> swk_alert)
//      and (ShowWindowClass.CurrentSubType <> sst_gameagree) then begin
      inherited UpDate (CurTick);
//   end;

   if Connector.ReceiveBuffer.Count > 0 then begin
      if MaxPacketCount < Connector.ReceiveBuffer.Count then begin
         MaxPacketCount := Connector.ReceiveBuffer.Count;
         AddLog (format ('MPC:%s(%s,%d,%d) %d', [Name, Manager.Title, BasicData.X, BasicData.Y, MaxPacketCount]));
      end;

      while true do begin
         if Connector.ReceiveBuffer.Get (@ComData) = false then break;
         // add by minds 050916
         if CheckMsgProcTick then begin
           pMsg := @ComData.Data;
           dwCheckTime := timeGetTime;
           MessageProcess(ComData);
           dwCheckTime := timeGetTime - dwCheckTime;
           if dwCheckTime > MsgProcTick then begin
              if pMsg.rmsg = CM_SAY then begin
                 pcSay := @ComData.Data;
                 AddLog(Format('LPT:%s(%s,%d,%d) %d,%d,%s', [Name, Manager.Title, BasicData.X, BasicData.Y, pMsg.rmsg, dwCheckTime, GetWordString(pcSay.rWordString)]));
              end else
                 AddLog(Format('LPT:%s(%s,%d,%d) %d,%d', [Name, Manager.Title, BasicData.X, BasicData.Y, pMsg.rmsg, dwCheckTime]));
           end;
         end else
         //
           MessageProcess(ComData);
      end;
   end;

   iCurTick := mmAnsTick;

   // 스피드 핵 방지를 위해서 마련한 패킷
   if iCurTick >= NetStateTick + 500 then begin
      if iCurTick - NetStateTick > 550 then begin
         NetStateID := 0;
         FillChar (SaveNetState, SizeOf (TCNetState), 0);
      end else begin
         if LastPacketTick >= NetStateTick + 250 then begin
            if NetStateReturnTick <= NetStateTick - 500 then begin
               AddTrace (format ('NETSTATE:%s NST:%d NSRT:%d LPT:%d', [Name, NetStateTick, NetStateReturnTick, LastPacketTick]));
               if boCheckSpeed = true then begin
                  MacroChecker.SaveMacroCase (Name, 4);
                  ConnectorList.CloseConnectByCharName (Name);
               end;
            end;
         end;
      end;

      PakEnMove.rmsg := random(128);
      PakEnMove.rId  := random(65536);
      PakEnMove.rdir := random(8);
      PakEnMove.rx   := random(1024)-512;
      PakEnMove.ry   := random(1024)-512;
      if PakEnMove.rx = 0 then PakEnMove.rx := 1;
      if PakEnMove.ry = 0 then PakEnMove.ry := 1;

      self.Vir_Move := PakEnMove;

      SrcLen := sizeof(PakEnMove);
      MyEncrypt(2,2,@PakEnMove, @NetStateQuestion, SrcLen, DstLen);
      // MyDecrypt(2,2,@DstData, @SrcData, DstLen, SrcLen);

      SendClass.SendNetState (NetStateID, iCurTick, NetStateQuestion);
      Inc (NetStateID);
      NetStateTick := iCurTick;
   end;

   if FboNewServer then begin
      FboNewServer := false;
      boChangeFeature := false;
      boPass := true;
      if (FPosMoveX <> -1) and (FPosMoveY <> -1) then begin
         // 시간차에의한 무공선택때문에 처리변환 04.07.12
         if ServerID <> Manager.ServerID then begin
            tmpManager := ManagerList.GetManagerByServerID (ServerID);
            if tmpManager <> nil then begin
               if tmpManager.boUseRiseMagic = false then begin
                  if (pCurAttackMagic <> nil) and (pCurAttackMagic^.rMagicClass = MAGICCLASS_RISEMAGIC) then begin
                     boPass := false;
                     FPosMoveX := BasicData.x + 1;
                     FPosMoveY := BasicData.y + 1;
                  end;
                  if (pCurProtectingMagic <> nil) and (pCurProtectingMagic^.rMagicClass = MAGICCLASS_RISEMAGIC) then begin
                     boPass := false;
                     FPosMoveX := BasicData.x + 1;
                     FPosMoveY := BasicData.y + 1;
                  end;
               end;
               if tmpManager.boUseBestMagic = false then begin
                  if (pCurAttackMagic <> nil) and (pCurAttackMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) then begin
                     boPass := false;
                     FPosMoveX := BasicData.x + 1;
                     FPosMoveY := BasicData.y + 1;
                  end;
                  if (pCurProtectingMagic <> nil) and (pCurProtectingMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) then begin
                     boPass := false;
                     FPosMoveX := BasicData.x + 1;
                     FPosMoveY := BasicData.y + 1;
                  end;
               end;
               if tmpManager.boUsePowerItem = false then begin
                  nCount := SCheckPowerWearItem;
                  if nCount <> 0 then begin
                     boPass := false;
                     FPosMoveX := BasicData.x + 1;
                     FPosMoveY := BasicData.y + 1;
                  end;
               end;
               if tmpManager.boUseBestSpecialMagic = false then begin
                  if pCurSpecialMagic <> nil then begin
                     boPass := false;
                     FPosMoveX := BasicData.x + 1;
                     FPosMoveY := BasicData.y + 1;
                 end;
               end;
               if tmpManager.boUseWindMagic = false then begin
                  if (pCurAttackMagic <> nil) and (pCurAttackMagic^.rMagicClass = MAGICCLASS_MYSTERY) then begin
                     boPass := false;
                     FPosMoveX := BasicData.x + 1;
                     FPosMoveY := BasicData.y + 1;
                  end;
               end;
            end;
         end;

         if boPass = true then begin
            Phone.SendMessage (NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
            Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

            if ServerID <> Manager.ServerID then begin
               tmpManager := ManagerList.GetManagerByServerID (ServerId);
               if tmpManager <> nil then begin
                  if Manager.boPK = true then begin
                     Manager.DelUser( self);
                  end;
                  Manager.UserCount := Manager.UserCount - 1;

                  SetManagerClass (tmpManager);
                  AttribClass.SetAddExpFlag := tmpManager.boGetExp;
                  HaveMagicClass.SetAddExpFlag := tmpManager.boGetExp;

                  tmpManager.UserCount := tmpManager.UserCount + 1;
                  if tmpManager.boPK = true then begin
                     tmpManager.AddUser( self);
                  end;

                  if tmpManager.boSetGroupKey = true then begin
                     DisplayValue := 0;
                     DisplayTick := -1;

                     if GroupKey <> tmpManager.GroupKey then begin
                        GroupKey := tmpManager.GroupKey;
                        boChangeFeature := true;
                     end;

                     if boSafe = true then begin
                        SendClass.SendChatMessage (Conv('考竟썩뇜菱땡句呵'),SAY_COLOR_SYSTEM);
                        boSafe := false;
                     end;
                  end else begin
                     if (boSafe = true) and (tmpManager.boNotAllowPK = false) then begin
                        boSafe := false;
                        GroupKey := 109;
                        SendClass.SendChatMessage (Conv('꼇肝괏빱뒈뙈，考竟썩뇜綠쒔轟槻'), SAY_COLOR_SYSTEM);
                        boChangeFeature := true;
                     end;
                  end;

                  if boChangeFeature = true then begin
                     WearItemClass.SetTeamColor (GroupKey);
                     SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                  end;
               end else begin
                  frmMain.WriteLogInfo (format ('Manager = nil (%s, %d, %d, %d)', [Name, ServerID, FPosMoveX, FPosMoveY]));
               end;
            end;

            if Maper.GetMoveableXy (FPosMoveX, FPosMoveY, 10) = false then begin
               // frmMain.WriteLogInfo (format ('FM_GATE NewServer Error (%s, %d, %d, %d)', [Name, ServerID, FPosMoveX, FPosMoveY]));
            end;

            BasicData.x := FPosMoveX; BasicData.y := FPosMoveY;
            BasicData.nx := FPosMoveX; BasicData.ny := FPosMoveY; //2002-08-15 giltae
            FPosMoveX := -1; FPosMoveY := -1;

            SendClass.SendMap (BasicData, Manager);
            Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
            Phone.SendMessage (NOTARGETPHONE, FM_CREATE, BasicData, SubData);

            if BasicData.Feature.rfeaturestate = wfs_die then begin
               Maper.MapProc (BasicData.Id, MM_HIDE, BasicData.x, BasicData.y, BasicData.x, BasicData.y, BasicData);
            end;
         end;
      end;
   end else begin
      if (Connector.BattleState <> bcs_gotobattle) and (FPosMovex <> -1) and (FPosMoveY <> -1) then begin
         Phone.SendMessage (NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
         Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

         if Maper.GetMoveableXy (FPosMoveX, FPosMoveY, 10) = false then begin
            // frmMain.WriteLogInfo (format ('FM_GATE GetMoveableXY Error (%s, %d, %d, %d)', [Name, ServerID, FPosMoveX, FPosMoveY]));
         end;
         
         BasicData.x := FPosMoveX; BasicData.y := FPosMoveY;
         //BasicData.nx := FPosMoveX; BasicData.ny := FPosMoveY; //2002-08-15 giltae
         FPosMoveX := -1; FPosMoveY := -1;
         
         SendClass.SendMap (BasicData, Manager);
         Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
         Phone.SendMessage (NOTARGETPHONE, FM_CREATE, BasicData, SubData);
      end;
   end;

   if Manager.boPrison = true then begin
      if PrisonTick + 6000 <= CurTick then begin
         PrisonTick := CurTick;
         if PrisonClass.IncreaseElaspedTime (Name, 1) <= 0 then begin
            ServerID := Manager.TargetServerID;
            FPosMoveX := Manager.TargetX;
            FPosMoveY := Manager.TargetY;
            FboNewServer := true;
            SendClass.SendChatMessage (Conv('닒직토뒈姦렴놔윱죄。'), SAY_COLOR_NORMAL);
            SendClass.SendChatMessage (Conv('헝潾磵푤쾨랬방，긁출疼늴굳혀쐐！'), SAY_COLOR_NORMAL);
            RemoveItemKind(ITEM_KIND_DUBU);
            exit;
         end;
      end;
   end;

   if CurTick >= SaveTick + 10 * 60 * 100 then begin
      SaveTick := CurTick;
      SaveUserData (Name);
      WearItemClass.SaveToSdb (@Connector.CharData);
      HaveItemClass.SaveToSdb (@Connector.CharData);
      AttribClass.SaveToSdb (@Connector.CharData);
      HaveMagicClass.SaveToSdb (@Connector.CharData);
      HaveJobClass.SaveToSdb (@Connector.CharData);
      HaveMarketClass.SaveToSdb (@Connector.CharData);
   end;

   {
   if MailBox.Count > 0 then begin
      if MailTick + 10 * 100 <= CurTick then begin
         pd := MailBox.Items[0];
         if pd <> nil then begin
            SendClass.SendChatMessage (format (Conv('%s눈죄寧몸笭係못콱。'),[StrPas(@pd^.rSender)]), SAY_COLOR_SYSTEM);
            SendClass.SendChatMessage (Conv('헝渴흙 [@횅훰笭係] 윱횅훰。 '), SAY_COLOR_NORMAL);
            SendClass.SendChatMessage (Conv('헝渴흙 [@�쓱匈싱�] 윱�쓱爻�'), SAY_COLOR_NORMAL);
         end else begin
            MailBox.Delete (0);
         end;
         MailTick := CurTick;
      end;
   end;
   }

   if Manager.RegenInterval > 0 then begin
      if LifeObjectState <> los_die then begin
         if (DisplayTick = -1) or (DisplayTick + 100 < CurTick) then begin
            if (Manager.RemainHour = 0) and (Manager.RemainMin = 0) then begin
               if Manager.RemainSec <> DisplayValue then begin
                  DisplayValue := Manager.RemainSec;
                  SendClass.SendChatMessage (format (Conv('假苟 %d취。'), [DisplayValue]), SAY_COLOR_SYSTEM);
                  {
                  if (DisplayValue = 0) and (SysopScope < 100) then begin
                     CommandChangeCharState (wfs_die, FALSE);
                  end;
                  }
               end;
            end else begin
               if Manager.RemainMin <> DisplayValue then begin
                  DisplayValue := Manager.RemainMin;
                  SendClass.SendChatMessage (format (Conv('假苟 %d롸。'), [DisplayValue]), SAY_COLOR_SYSTEM);
               end;
            end;
         end;
      end;
   end;

   if UseSkillKind <> -1 then begin
      if SkillUsedTick + SkillUsedMaxTick <= CurTick then begin
         cnt := UseSkillKind;
         UseSkillKind := -1;
         SkillUsedTick := 0;
         SkillUsedMaxTick := 0;

         Case cnt of
            ITEM_KIND_HIDESKILL :
               begin
                  WearItemClass.SetHiddenState (hs_100);
                  SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
               end;
            ITEM_KIND_SHOWSKILL :
               begin
                  SetTargetID (0);
                  for i := 0 to ViewObjectList.Count - 1 do begin
                     BObject := ViewObjectList.Items [i];
                     if BObject.BasicData.Feature.rHideState = hs_0 then begin
                        SendLocalMessage (BasicData.ID, FM_CHANGEFEATURE, BObject.BasicData, SubData);
                     end;
                  end;
               end;
         end;
      end;
   end;

   if Manager.boChangeLife = true then begin
      case Manager.MapAttribute of
         MAP_TYPE_ICE :
            begin
               if WearItemClass.SpecialItemType <> ITEM_ATTRIBUTE_FIRE then begin
                  if BasicData.Feature.rfeaturestate <> wfs_die then begin
                     if ChangeLifeTick + Manager.ChangeDelay <= CurTick then begin
                        AttribClass.CurLife := AttribClass.CurLife - ((AttribClass.Life div 100) * Manager.ChangePercentage);
                        ChangeLifeTick := CurTick;
                        SendClass.SendSideMessage (Conv('삶제숑��'));
                        if AttribClass.CurLife = 0 then begin
                           CommandChangeCharState (wfs_die);
                           ChangeLifeTick := CurTick;
                        end;
                     end;
                  end;
               end;
            end;
         MAP_TYPE_FIRE :
            begin
               if (HaveItemClass.WaterCaseItemCount = 0)
                  and (WearItemClass.SpecialItemType <> ITEM_ATTRIBUTE_ICE) then begin
                  if BasicData.Feature.rfeaturestate <> wfs_die then begin
                     if ChangeLifeTick + Manager.ChangeDelay <= CurTick then begin
                        AttribClass.CurLife := AttribClass.CurLife - Manager.ChangeSize;
                        ChangeLifeTick := mmAnsTick;
                        SendClass.SendSideMessage (Conv('삶제숑��'));
                        if AttribClass.CurLife = 0 then begin
                           CommandChangeCharState (wfs_die);
                        end;
                     end;
                  end else begin
                     ChangeLifeTick := mmAnsTick;
                  end;
               end;
            end;
         MAP_TYPE_FILL :
            begin
               if BasicData.Feature.rfeaturestate <> wfs_die then begin
                  if HaveItemClass.FillItemCount <> 0 then begin
                     if ChangeLifeTick + Manager.ChangeDelay <= CurTick then begin
                        AttribClass.CurLife := AttribClass.CurLife + Manager.ChangeSize;                // 활력, 내, 외, 무공 올려줌
                        AttribClass.CurInPower := AttribClass.CurInPower + Manager.ChangeSize;
                        AttribClass.CurOutPower := AttribClass.CurOutPower + Manager.ChangeSize;
                        AttribClass.CurMagic := AttribClass.CurMagic + Manager.ChangeSize;
                        SendClass.SendSideMessage (Conv('뵌왯巧�ヒ㈚�뿟릿삶제'));
                        ChangeLifeTick := CurTick;
                     end;
                  end;
               end else begin
                  ChangeLifeTick := CurTick;
               end;
            end;
         MAP_TYPE_POWERLEVEL : begin
            if PowerLevel < 2 then begin
               if BasicData.Feature.rfeaturestate <> wfs_die then begin
                  if ChangeLifeTick + Manager.ChangeDelay <= CurTick then begin
                     AttribClass.CurLife := AttribClass.CurLife - Manager.ChangeSize;
                     ChangeLifeTick := mmAnsTick;
                     SendClass.SendSideMessage (Conv('삶제숑��'));
                     if AttribClass.CurLife = 0 then begin
                        CommandChangeCharState (wfs_die);
                     end;
                  end;
               end else begin
                  ChangeLifeTick := mmAnsTick;
               end;
            end;
         end;
      end;
   end;

   if FIceTick > 0 then begin
      if CurTick >= FIceTick + FIceInterval then begin
         if BasicData.Feature.rActionState = as_ice then begin
            WearItemClass.SetActionState (as_free);
            SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
         end;
         FIceTick := 0;
         FIceInterval := 0;
      end;
   end;

   if boCanAttacked = false then begin
      if CurTick > FLockDownDecLifeTick + 100 then begin
         // 초식에서 1초 단위로 활력감소  040422
         with AttribClass do begin
            CurLife := CurLife - LockDownDecLife;
            if CurLife > Life then CurLife := Life;
         end;

         FLockDownDecLifeTick := CurTick;
      end;
   end;
end;

procedure TUser.AddRefusedUser (aName : String);
var
   i : Integer;
begin
   if RefuseReceiver.Count >= 5 then begin
      SendClass.SendChatMessage (Conv('轟랬눈뒵笭係。'), SAY_COLOR_SYSTEM);
      exit;
   end;

   for i := 0 to RefuseReceiver.Count - 1 do begin
      if RefuseReceiver.Strings[i] = aName then exit;
   end;

   RefuseReceiver.Add (aName);
end;

procedure TUser.DelRefusedUser (aName : String);
var
   i : Integer;
begin
   for i := 0 to RefuseReceiver.Count - 1 do begin
      if RefuseReceiver.Strings[i] = aName then begin
         RefuseReceiver.Delete (i);
         exit;
      end;
   end;
end;

procedure TUser.AddMailSender (aName : String);
begin
   if CheckSenderList (aName) = True then exit;
   if MailSender.Count >= MailSenderLimit then begin
      MailSender.Delete (MailSender.Count - 1);
      MailSender.Insert (0, aName);
   end else begin
      MailSender.Add (aName);
   end;
end;

function TUser.CheckSenderList (aName : String) : Boolean;
var
   i : Integer;
begin
   Result := False;
   for i := 0 to MailSender.Count - 1 do begin
      if MailSender.Strings[i] = aName then begin
         Result := True;
         Exit;
      end;
   end;
end;

// add by Orber at 2004-12-07 10:51:42

function TUser.CheckArena : Byte;
begin
    Result := aArenaType;
end;

procedure TUser.JoinArena (pArenaType : Byte; pArenaIndex :Word); {pArenaType : 1 Master,2 Member}
begin
    aArenaType := pArenaType;
    aArenaIndex := pArenaIndex;
end;

procedure TUser.SetPosition (x, y : Integer);
begin
   FPosMoveX := x;
   FPosMoveY := y;
end;

procedure TUser.SetPositionBS (ex, ey : Integer);
begin
   if BattleSender = nil then begin
      SendClass.SendChatMessage (Conv('君瞳몸훙뚤濫끝륩蛟포綠밑균'), SAY_COLOR_SYSTEM);
      exit;
   end;

   FPosMoveX := ex;
   FPosMoveY := ey;
   Connector.BattleState := bcs_gotobattle;
end;

function TUser.Check8Around (adir, aX, aY : Word) : Boolean;
var
   tempdir : byte;
   xx, yy : Word;
begin
   Result := false;

   tempdir := adir;
   xx := aX; yy := aY;
   GetNextPosition (tempdir, xx, yy);
   if Maper.isMoveable (xx, yy) = false then begin
      Result := true;
      exit;
   end;

   tempdir := GetRightDirection (tempdir);
   xx := aX; yy := aY;
   GetNextPosition (tempdir, xx, yy);
   if Maper.isMoveable (xx, yy) = false then begin
      Result := true;
      exit;
   end;

   tempdir := GetRightDirection (tempdir);
   xx := aX; yy := aY;
   GetNextPosition (tempdir, xx, yy);
   if Maper.isMoveable (xx, yy) = false then begin
      Result := true;
      exit;
   end;

   tempdir := GetRightDirection (tempdir);
   xx := aX; yy := aY;
   GetNextPosition (tempdir, xx, yy);
   if Maper.isMoveable (xx, yy) = false then begin
      Result := true;
      exit;
   end;

   tempdir := GetRightDirection (tempdir);
   xx := aX; yy := aY;
   GetNextPosition (tempdir, xx, yy);
   if Maper.isMoveable (xx, yy) = false then begin
      Result := true;
      exit;
   end;

   tempdir := GetRightDirection (tempdir);
   xx := aX; yy := aY;
   GetNextPosition (tempdir, xx, yy);
   if Maper.isMoveable (xx, yy) = false then begin
      Result := true;
      exit;
   end;

   tempdir := GetRightDirection (tempdir);
   xx := aX; yy := aY;
   GetNextPosition (tempdir, xx, yy);
   if Maper.isMoveable (xx, yy) = false then begin
      Result := true;
      exit;
   end;

   tempdir := GetRightDirection (tempdir);
   xx := aX; yy := aY;
   GetNextPosition (tempdir, xx, yy);
   if Maper.isMoveable (xx, yy) = false then begin
      Result := true;
      exit;
   end;
end;

function TUser.MovingStatus : Boolean;
begin
   Result := false;
   if (FPosMoveX <> -1) or (FPosMoveY <> -1) then begin
      Result := true;
   end;
end;

procedure TUser.UdpSendMouseEvent (aInfoStr: String);
var
   cnt : integer;
   usd: TStringData;
begin
   usd.rmsg := 1;
   SetWordString (usd.rWordString, ainfostr);
   cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);
   FrmSockets.UdpSendMouseInfo (cnt, @usd);
end;

procedure TUser.RemoveItemKind(aKind : Integer);
var
   i :integer;
begin
   i := HaveItemClass.FindKindItem(aKind);
   if i <> -1 then begin
      HaveItemClass.DeleteItem(i);
   end;


end;
{
function TUser.Find3daysChar : Boolean;   // 노협객이벤트
begin
   Result := false;

   if Connector.PaidType = pt_test then begin
      Result := true;
   end;
end;
}

function TUser.GetUserID : String;
begin
   Result := StrPas (@Connector.CharData.MasterName);
end;

procedure TUser.SetActionState (aActionState : TActionState);
begin
   WearItemClass.SetActionState(aActionState); 
end;

procedure TUser.SetGroupColor (aIndex : Word);
var
   SubData : TSubData;
begin
   GroupKey := aIndex;
   WearItemClass.SetTeamColor (GroupKey);
   SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
end;

function TUser.ShowItemLogWindow : String;
begin
   Result := ShowWindowClass.ShowItemLogWindow;
end;

// add by Orber at 2004-12-23 16:24:29
procedure TUser.MarryWindow (aHelpText:String);
begin
    if Lover = '' then begin
        ShowWindowClass.ShowMarry(aHelpText);
    end else begin
        SSendChatMessage (Conv('콱綠쒔써삯.'), SAY_COLOR_SYSTEM);
    end;
end;

// add by Orber at 2005-01-04 10:33:00
procedure TUser.UnMarryWindow (aHelpText:String);
var
    aUser :TUser;
    ItemData : TItemData;
begin
      if Lover <> '' then begin

        aUser := UserList.GetUserPointer(Lover);
        if aUser = nil then begin
            SSendChatMessage(Conv('뚤렘꼇瞳窟,잼삯�鉞率緊溯�,澗혤20拱잼삯癎崎롤'), SAY_COLOR_SYSTEM);
            ItemClass.GetItemData (Conv('풀귑'), ItemData);
            ItemData.rCount := 200000;
            if Not DeleteItem(@ItemData) then begin
                SSendChatMessage(Conv('청唐璃뭘돨잼삯栗쏜.'), SAY_COLOR_SYSTEM);
                Exit;
            end;
            MarryList.UnMarry(Name);
        end else begin
            SSendChatMessage(Conv('攣瞳蕨콱돨토탉瘻댐콱돨잼삯헝헹'), SAY_COLOR_SYSTEM);
            aUser.ShowUnMarry(Conv(aHelpText));
        end;
      end else begin
        SSendChatMessage(Conv('콱뻘청唐써삯.'), SAY_COLOR_SYSTEM);
      end;
end;

procedure TUser.GuildActiveBank;
var
    GuildObject : TGuildObject;
begin
    if GuildName = '' then begin
        SSendChatMessage (Conv('콱轟홈샴삶쳔탰陵契'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    GuildObject := GuildList.GetGuildObject(GuildName);
    if GuildObject = nil then begin
        SSendChatMessage (Conv('콱轟홈샴삶쳔탰陵契'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    if Not GuildObject.IsGuildSysop(Name) then begin
        SSendChatMessage (Conv('콱轟홈샴삶쳔탰陵契'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    if Not GuildObject.rBoBank then begin
        GuildObject.rBoBank := True;
        SSendChatMessage (Conv('쳔탰陵契샴삶냥묘，뎠품栗쏜:') + IntToStr(GuildObject.Bank), SAY_COLOR_SYSTEM);
    end;
end;

procedure TUser.GuildBuyMoneyChip;
var
    GuildObject : TGuildObject;
    GuildUser : PTGuildUserData;
    ItemData : TItemData;
begin
    GuildObject := GuildList.GetGuildObject(GuildName);
    if GuildObject = nil then begin
        SSendChatMessage (Conv('퀭뻘청唐속흙쳔탰，꼇콘權肝늪蘆膽쁨'), SAY_COLOR_SYSTEM);
        Exit;
    end;
{    if Not GuildObject.IsGuildSysop(Name) then begin
        SSendChatMessage (Conv('콱轟홈샴삶쳔탰陵契'), SAY_COLOR_SYSTEM);
        Exit;
    end;}
    if Not GuildObject.rBoBank then begin
        SSendChatMessage (Conv('쳔탰陵契�近뉼ㅋ�'), SAY_COLOR_SYSTEM);
        Exit;
    end;

    if GuildObject.IsGuildSysop(Name) then begin
        SSendChatMessage (Conv('쳔탰陵契怜蕨쳔逃역렴'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    GuildUser := GuildObject.GetUser(Name);
    if  GuildUser^.rName = '' then begin
        SSendChatMessage (Conv('콱옵콘뻘청唐속흙맡쳔탰'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    if GuildUser^.rLastDate = DateToStr(Date) then begin
        SSendChatMessage (Conv('쏟휑콱綠�鉞鍮卉�'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    if GuildUser^.rLoadMoney >= 300000 then begin
        SSendChatMessage (Conv('콱蕨陵契�鉞逾컸�귑綠낚띨죄'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    if GuildObject.Bank <= 2000000 then begin
        SSendChatMessage (Conv('쳔탰陵契栗쏜꼇璃'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    ItemClass.GetItemData(Conv('쳔탰풀즈'),ItemData);
    if SGetItemCount(ItemData,1) then begin
        SSendChatMessage (Conv('콱뻘唐쳔탰풀즈�近늦밉�'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    ShowWindowClass.ShowInputMoneyChip(Conv('헝渴흙句寡닒쳔탰陵契瓊혤돨쏜띨'));
end;

function  TUser.GuildApplyMoney (aUser:String;aMoneyChip:integer):Boolean;
begin

    if PreGuildMoneyApplyer <> '' then begin
        Result := False;
        Exit;
    end;
    PreGuildMoneyApplyer := aUser;
    ShowWindowClass.ShowGuildApplyMoney(Conv('쳔逃')+aUser+Conv('�鉞�')+IntToStr(aMoneyChip)+Conv('풀귑，角뤠谿雷？'),aUser);
    Result := True;
end;

procedure TUser.ShowUnMarry(aHelpText:String);
begin
    ShowWindowClass.ShowUnMarry(aHelpText);
end;

procedure TUser.MarryAnswerWindow (aName,aHelpText:String);
begin
    PreLover := aName;
    ShowWindowClass.ShowMarryAnswer(aHelpText);
end;

procedure TUser.GuildAnswerWindow (aName,aHelpText:String);
begin
    ShowWindowClass.ShowGuildAnswer(aHelpText);
end;

procedure TUser.ArenaWindow (aHelpText:String);
begin
    ShowWindowClass.ShowArenaWindow(aHelpText);
end;

procedure TUser.Marry (aUser:String;aAnswer:Byte);
begin
    ShowWindowClass.Marry(aUser,aAnswer);
end;

procedure TUser.TradeWindow (aTitle, aCaption : String; aImageNum, aImageValue : Word; aItemStr : String; aKind : Byte);
begin
   ShowWindowClass.TradeWindow (aTitle, aCaption, aImageNum, aImageValue, aItemStr, aKind);
end;

procedure TUser.SaleWindow (aBasicObject : TBasicObject; aTitle, aCaption : String;
   aImageNum, aImageValue : Word; aItemStr : String; aKind : Byte);
begin
   ShowWindowClass.SaleWindow(aBasicObject, aTitle, aCaption, aImageNum, aImageValue, aItemStr, aKind); 
end;

procedure TUser.GetExchangeData (var aExchangeData : TExchangeData);
begin
   ShowWindowClass.GetExchangeData (aExchangeData);
end;

procedure TUser.SetExchangeData (aExchangeData : TExchangeData);
begin
   ShowWindowClass.SetExchangeData (aExchangeData);
end;

function TUser.isCheckExchangeData : Boolean;
begin
   Result := ShowWindowClass.isCheckExChangeData;
end;

function TUser.AddableExChangeData (pex : PTExChangedata): Boolean;
begin
   Result := ShowWindowClass.AddableExChangeData (pex);
end;

procedure TUser.AddExChangeData (var aSenderInfo : TBasicData; pex : PTExChangedata; aSenderIP : String);
begin
   ShowWindowClass.AddExChangeData (aSenderInfo, pex, aSenderIP);
end;

procedure TUser.DelExChangeData (pex : PTExChangedata);
begin
   ShowWindowClass.DelExChangeData (pex);
end;

function TUser.FindExChangeData (pex : PTExChangedata) : Boolean;
begin
   Result := ShowWindowClass.FindExChangeData (pex);
end;

function TUser.GetQuestStr : String;
begin
   Result := UserQuestClass.QuestStr;
end;

procedure TUser.CopyMarketItem (var aMarketDataList : TList);
begin
   HaveMarketClass.CopyMarketItem (aMarketDataList);
end;

function TUser.SellItembyUser (aMarketList : TList; aName : String) : Boolean;
begin
   Result := HaveMarketClass.SellItembyUser (aMarketList, aName);
end;

function TUser.SellItembyUser (aItemData : TItemData; aName : String) : Boolean;
begin
   Result := HaveMarketClass.SellItembyUser (aItemData, aName);
end;

procedure TUser.SetCurrentWindow (aSWK : TSpecialWindowKind; aSST : TSpecialSubType);
begin
   ShowWindowClass.SetCurrentWindow (aSWK, aSST);   
end;

function TUser.SGetAge : Integer;
begin
   Result := AttribClass.Age;
end;

function TUser.SGetMaxLife : Integer;
begin
   Result := AttribClass.Life;
end;

function TUser.SGetMaxInPower : Integer;
begin
   Result := AttribClass.InPower;
end;

function TUser.SGetMaxOutPower : Integer;
begin
   Result := AttribClass.OutPower;
end;

function TUser.SGetMaxMagic : Integer;
begin
   Result := AttribClass.Magic;
end;

function TUser.SGetLife : Integer;
begin
   Result := AttribClass.CurLife;
end;

function TUser.SGetHeadLife : Integer;
begin
   Result := AttribClass.CurHeadLife;
end;

function TUser.SGetArmLife : Integer;
begin
   Result := AttribClass.CurArmLife;
end;

function TUser.SGetLegLife : Integer;
begin
   Result := AttribClass.CurLegLife;
end;

function TUser.SGetPower : Integer;
begin
   Result := AttribClass.Energy;
end;

function TUser.SGetInPower : Integer;
begin
   Result := AttribClass.CurInPower;
end;

function TUser.SGetOutPower : Integer;
begin
   Result := AttribClass.CurOutPower;
end;

function TUser.SGetMagic : Integer;
begin
   Result := AttribClass.CurMagic;
end;

function TUser.SGetVirtue : Integer;
begin
   Result := AttribClass.Virtue;
end;

function TUser.SGetTalent : Integer;
begin
   Result := AttribClass.Talent;
end;

function TUser.SGetUseAttackMagic : String;
begin
   Result := '';
   if HaveMagicClass.pCurAttackMagic <> nil then begin
      Result := StrPas (@HaveMagicClass.pCurAttackMagic^.rname);
   end;
end;

function TUser.SGetUseAttackSkillLevel : Integer;
begin
   Result := 0;
   if HaveMagicClass.pCurAttackMagic <> nil then begin
      Result := HaveMagicClass.pCurAttackMagic^.rcSkillLevel;
   end;
end;

function TUser.SGetUseMagicSkillLevel (aKind : Word) : Integer;
begin
   Result := 0;
   Case aKind of
      0..6 : begin // 공격무공
         if HaveMagicClass.pCurAttackMagic <> nil then begin
            Result := HaveMagicClass.pCurAttackMagic^.rcSkillLevel;
         end;
      end;
      7 : begin // 보법
         if HaveMagicClass.pCurRunningMagic <> nil then begin
            Result := HaveMagicClass.pCurRunningMagic^.rcSkillLevel;
         end;
      end;
      8 : begin // 강신
         if HaveMagicClass.pCurProtectingMagic <> nil then begin
            Result := HaveMagicClass.pCurProtectingMagic^.rcSkillLevel;
         end;
      end;
   end;
end;

function TUser.SGetMagicSkillLevel (aName : String) : Integer;
begin
   Result := HaveMagicClass.FindMagicByName (aName);
end;

function TUser.SGetUseProtectMagic : String;
begin
   Result := '';
   if HaveMagicClass.pCurProtectingMagic <> nil then begin
      Result := StrPas (@HaveMagicClass.pCurProtectingMagic.rname);
   end;
end;

function TUser.SGetCompleteQuest : Integer;
begin
   Result := UserQuestClass.CompleteQuestNo;
end;

function TUser.SGetCurrentQuest : Integer;
begin
   Result := UserQuestClass.CurrentQuestNo;
end;

function TUser.SGetQuestStr : String;
begin
   Result := UserQuestClass.QuestStr;
end;

function TUser.SGetFirstQuest : Integer;
begin
   Result := UserQuestClass.FirstQuestNo;
end;

function TUser.SGetItemCount(aItem:TItemData;ItemCount:Integer): Boolean;
begin
    Result := HaveItemClass.FindItembyCount (@aItem, ItemCount, 1);
end;

function TUser.SGetItemExistence (aItem : String; aOption : Integer) : String;
var
   Str, Dest : String;
   ItemData : TItemData;
   ItemCount, mLevel : Integer;
begin
   Result := 'false';

   Str := aItem;
   Str := GetValidStr3 (Str, Dest, ':');

   ItemClass.GetItemData (Dest, ItemData);
   if ItemData.rName [0] = 0 then exit;

   ItemCount := StrToInt (str);
   if HaveItemClass.FindItembyCount (@ItemData, ItemCount, aOption) = false then begin
      mLevel := HaveMagicClass.FindHaveMagicByName (Dest);
      if mLevel < 0 then exit;
   end;

   Result := 'true';
end;

function TUser.SGetItemExistenceByKind (aKind, aOption : Integer) : String;
var
   Str, Dest : String;
   ItemData : TItemData;
   ItemCount, mLevel : Integer;

   nPos : Integer;
begin
   Result := 'false';

   if aOption = 0 then begin   // HaveItemClass 뒤지기...
      nPos := HaveItemClass.FindKindItem (aKind);
      if nPos = -1 then exit;
   end else if aOption = 1 then begin   // wearitemclass 뒤지기
      if WearItemClass.GetWeaponKind <> aKind then exit;
   end;

   Result := 'true';
end;

//2002-08-07 수정됨 giltae
function TUser.SCheckEnoughSpace (aCount : Integer) : String;
begin
   Result := 'false';
   
   if HaveItemClass.FreeSpace >= aCount then begin
      Result := 'true';
   end;   
end;
//--------------------------

function TUser.SGetHaveGradeQuestItem: String;
begin
   Result := 'false';

   if HaveItemClass.boHaveGradeQuestItem = true then Result := 'true';
end;

function TUser.SGetJobKind : Byte;
begin
   Result := HaveJobClass.JobKind;
end;

function TUser.SGetJobGrade : Byte;
begin
   Result := HaveJobClass.JobGrade;
end;

function TUser.SGetJobTalent : Integer;
begin
   Result := AttribClass.Talent;
end;

{
function TUser.SGetToolName : String;
begin
   Result := HaveJobClass.JobToolName;
end;

function TUser.SGetJobGrade : String;
begin
   Result := HaveJobClass.JobGradeStr;
end;
}

function TUser.SGetWearItemCurDurability (aKey : Integer) : Integer;
var
   ItemData : TItemData;
begin
   Result := 0;

   if WearItemClass.ViewItem (aKey, @ItemData) = false then exit;
   if ItemData.rName [0] = 0 then exit;

   Result := ItemData.rCurDurability;
end;

function TUser.SGetWearItemMaxDurability (aKey : Integer) : Integer;
var
   ItemData : TItemData;
begin
   Result := 0;

   if WearItemClass.ViewItem (aKey, @ItemData) = false then exit;
   if ItemData.rName [0] = 0 then exit;

   Result := ItemData.rDurability;
end;

function TUser.SGetWearItemName (aKey : Integer) : String;
begin
   Result := WearItemClass.GetWearItemName (aKey);
end;

function TUser.SGetMagicCountBySkill (aType, aSKill : Integer) : String;
begin
   if HaveMagicClass.FindMagicByTypeAndSkill (aType, aSkill) = true then Result := 'true'
   else Result := 'false'; 
end;

function TUser.SRepairItem (aKey, aKind : Integer) : Integer;
begin
   if aKind = ITEM_KIND_EIGHTANGLES then begin
      Result := HaveItemClass.RepairItem (aKind);
   end else begin
      Result := WearItemClass.RepairItem (aKey, aKind);
   end;
end;

function TUser.SDestroyItembyKind (aKey, aKind : Integer) : Integer;
begin
   if aKind = ITEM_KIND_EIGHTANGLES then begin
      Result := HaveItemClass.DestroyItembyKind (aKind);
   end else begin
      Result := WearItemClass.DestroyItembyKind (aKey, aKind);
   end;
end;

function TUser.SFindItemCount (aItemName : String) : String;
begin
   Result := IntToStr (HaveItemClass.FindItemCountbyName (aItemName));
end;

function TUser.SCheckPowerWearItem : Integer;
begin
   Result := WearItemClass.CheckPowerWearItem;
end;

function TUser.SCheckCurUseMagic (aType : Byte) : String;
begin
   Result := 'false';
   
   case aType of
      0 : begin           // 문파무공을 사용하는지
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rGuildMagictype <> 1 then exit;
      end;
      1 : begin           // 장풍을 사용하는지
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rMagicClass <> MAGICCLASS_MYSTERY then exit;
      end;
      2 : begin           // 보조무공을 사용하는지
         if HaveMagicClass.pCurEctMagic = nil then exit;
         if HaveMagicClass.pCurEctMagic^.rMagicType <> MAGICTYPE_ECT then exit;
      end;
      3 : begin           // 상승공격무공을 사용하는지
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rMagicClass <> MAGICCLASS_RISEMAGIC then exit;
      end;
      4 : begin           // 상승강신을 사용하는지
         if HaveMagicClass.pCurProtectingMagic = nil then exit;
         if HaveMagicClass.pCurProtectingMagic^.rMagicClass <> MAGICCLASS_RISEMAGIC then exit;
      end;
      5 : begin           // 4대신공을사용하는지
         if HaveMagicClass.pCurProtectingMagic = nil then exit;
         if HaveMagicClass.pCurProtectingMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
      end;
      6 : begin           // 절세무공을사용하는지
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
      end;
   end;
   
   Result := 'true';
end;

function TUser.SCheckCurUseMagicByGrade (aType,aGrade,aMagicType : Byte) : String;
begin
   Result := 'false';

   case aType of
      5 : begin           // 4대신공을 사용하는지
         if HaveMagicClass.pCurProtectingMagic = nil then exit;
         if HaveMagicClass.pCurProtectingMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
         if HaveMagicClass.pCurProtectingMagic^.rGrade <> aGrade then exit;
         if HaveMagicClass.pCurProtectingMagic^.rcSkillLevel <> 9999 then exit;
      end;
      6 : begin           // 절세무공을 사용하는지
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
         if HaveMagicClass.pCurAttackMagic^.rGrade <> aGrade then exit;
         if HaveMagicClass.pCurAttackMagic^.rcSkillLevel <> 9999 then exit;
         if (aMagicType <> -1) and (HaveMagicClass.pCurAttackMagic^.rMagicType <> aMagictype) then exit;
      end;
   end;

   Result := 'true';
end;

function TUser.SGetCurPowerLevelName : String;
begin
   Result := HaveMagicClass.PowerLevelName;
end;

function TUser.SGetCurPowerLevel : Integer;
begin
   Result := HaveMagicClass.PowerLevel;
end;

function TUser.SGetCurDuraWaterCase : Integer;
var
   ItemData : TItemData;
   key : Integer;
begin
   Result := 0;
   key := HaveItemClass.FindKindItem (ITEM_KIND_WATERCASE);
   if key = -1 then exit;

   if HaveItemClass.ViewItem (key, @ItemData) = false then exit;
   if ItemData.rName [0] = 0 then exit;

   Result := ItemData.rCurDurability; 
end;

function TUser.SGetPossibleGrade(atype,agrade:byte) : String;
begin
   Result := 'false';
   if HaveMagicClass.GetPossibleGrade(atype,agrade) = true then Result := 'true';
end;

function TUser.SCheckMagic (aMagicClass, aMagicType : Integer; aMagicName : String) : String;
begin
   Result := 'false';
   if HaveMagicClass.CheckMagic (aMagicClass, aMagicType, aMagicName) = true then Result := 'true'; 
end;

function TUser.SCheckAttribItem (aAttrib : Integer) : String;
begin
   Result := 'false';
   if HaveItemClass.FindAttribKindItem (aAttrib) <> -1 then Result := 'true';
end;

function TUser.SConditionBestAttackMagic (aMagicName : String) : String;
begin
   Result := 'false';
   if HaveMagicClass.ConditionBestAttackMagic (aMagicName) = true then Result := 'true'; 
end;

function TUser.SGetZhuangInto : String;
begin
   Result := Zhuang.GetZhuangInto(self);
end;

function TUser.SGetMarryInfo : String;
begin
    if Lover <> '' then
        Result := 'true'
    else
        Result := 'false';
end;

function TUser.SGetAskConquer : String;
var GuildObject :TGuildObject;
begin
    result := '-1';
    if GuildName = '' then exit;
    GuildObject := GuildList.GetGuildObject(GuildName);
    if GuildObject = nil then Exit;
    if Not GuildObject.IsGuildSysop(GuildName) then Exit;
    result := IntToStr(Zhuang.AskConquer(GuildName));
end;


function TUser.SGetMarryClothes : String;
begin
   Result := LowerCase(BoolToStr(MarryList.isClothes(Name),True));
end;

function TUser.SGetZhuangTicketPrice : String;
begin
   Result := IntToStr(Zhuang.GetTicketPrice);
end;

procedure TUser.SShowWindow (aCommander : TBasicObject; aFileName : String; aKind : Byte);
var
   Str : String;
begin
//   if ShowWindowClass.CurrentWindow <> swk_none then exit;
   if ShowWindowClass.AllowWindowAction (swk_none) = false then exit;

   ShowWindowClass.Commander := aCommander;
   if not FileExists (aFileName) then exit;

   Str := HelpFiles.FindFile (aFileName);
   if aKind = 0 then begin
      ShowWindowClass.ShowHelpWindow ('', Str);
   end else begin
      ShowWindowClass.ShowTradeWindow ('', Str);
   end;
end;

procedure TUser.SShowEffect (aEffectNumber : Integer; aEffectKind : Integer);
begin
   ShowEffect2 (aEffectNumber, TLightEffectKind (aEffectKind), 0);
end;


procedure TUser.SShowWindow2 (aCommander : TBasicObject; aStr : String; aKind : Byte);
begin
   if ShowWindowClass.CurrentWindow <> swk_none then exit;
   ShowWindowClass.Commander := aCommander;

   if aKind = 0 then begin
      ShowWindowClass.ShowHelpWindow ('', aStr);
   end else begin
      ShowWindowClass.ShowTradeWindow ('', aStr);
   end;
end;

procedure TUser.SLogItemWindow (aCommander : TBasicObject);
begin
   ShowWindowClass.Commander := aCommander;
   ShowWindowClass.ShowItemLogWindow;
end;

procedure TUser.SGuildItemWindow (aCommander : TBasicObject);
begin
   ShowWindowClass.Commander := aCommander;
   ShowWindowClass.ShowGuildItemLogWindow(1);
end;

procedure TUser.SPutMagicItem (aWeapon, aMopName : String; aRace : Byte);
var
   Str, ItemName, ItemCount : String;
   ItemData : TItemData;
   cnt : Integer;
   usd : TStringData;   
begin
   Str := aWeapon;
   Str := GetValidStr3 (Str, ItemName, ':');
   Str := GetValidStr3 (Str, ItemCount, ':');

   ItemClass.GetItemData (ItemName, ItemData);
   if ItemData.rName [0] = 0 then exit;
   ItemData.rCount := _StrToInt (ItemCount);
   if ItemData.rCount = 0 then ItemData.rCount := 1;

   // if HaveItemClass.FindItem (@ItemData) = true then exit;

   if ItemData.rName[0] > 0 then begin
      ItemData.rOwnerRace := aRace;
      ItemData.rOwnerServerID := ServerID;
      StrPCopy(@ItemData.rOwnerName, aMopName);
      StrPCopy (@ItemData.rOwnerIP, '');
      ItemData.rOwnerX := BasicData.x;
      ItemData.rOwnerY := BasicData.y;
   end;

   usd.rmsg := 1;                                        // 아이템 갯수 날리고
   SetWordString (usd.rWordString, 'Item:' + StrPas (@ItemData.rName) + ',' + IntToStr (ItemData.rCount) + ',');
   cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);

   FrmSockets.UdpObjectAddData (cnt, @usd);

   if HaveItemClass.AddItem (ItemData) then begin
      SendClass.SendSideMessage (format (Conv('%s 삿돤 %d몸'), [StrPas (@ItemData.rViewName), ItemData.rCount]));
   end;
end;

procedure TUser.SGetItem (aItem : String);
var
   Str, ItemName, ItemCount : String;
   ItemData : TItemData;
begin
   Str := aItem;
   Str := GetValidStr3 (Str, ItemName, ':');
   Str := GetValidStr3 (Str, ItemCount, ':');

   ItemClass.GetItemData (ItemName, ItemData);
   if ItemData.rName [0] = 0 then exit;
   ItemData.rCount := _StrToInt (ItemCount);
   if ItemData.rCount = 0 then ItemData.rCount := 1;

   HaveItemClass.DeleteItem (@ItemData);
end;

procedure TUser.SGetItem2 (aItem : String);
var
   Str, ItemName, ItemCount : String;
   ItemData : TItemData;
begin
   Str := aItem;
   Str := GetValidStr3 (Str, ItemName, ':');
   Str := GetValidStr3 (Str, ItemCount, ':');

   ItemClass.GetItemData (ItemName, ItemData);
   if ItemData.rName [0] = 0 then exit;
   ItemData.rCount := _StrToInt (ItemCount);
   if ItemData.rCount = 0 then ItemData.rCount := 1;

   HaveItemClass.DeleteItembyName (@ItemData);
end;

procedure TUser.SGetAllItem (aItem : String);
begin
   DeleteAllItembyName (aItem);
end;

procedure TUser.SDeleteQuestItem;
begin
   HaveItemClass.DeleteQuestItem;
end;

procedure TUser.SChangeCompleteQuest (aQuest : Integer);
begin
   UserQuestClass.CompleteQuestNo := aQuest;
end;

procedure TUser.SChangeCurrentQuest (aQuest : Integer);
begin
   UserQuestClass.CurrentQuestNo := aQuest;
end;

procedure TUser.SChangeQuestStr (aStr : String);
begin
   UserQuestClass.QuestStr := aStr;
end;

procedure TUser.SChangeFirstQuest (aQuest : Integer);
begin
   UserQuestClass.FirstQuestNo := aQuest;
end;

procedure TUser.SAddAddableStatePoint (aPoint : Integer);
begin
   AttribClass.AddableStatePoint := AttribClass.AddableStatePoint + aPoint;
   SendClass.SendExtraAttribValues (AttribClass); 
end;

procedure TUser.STotalAddableStatePoint (aPoint : Integer);
begin
   AttribClass.TotalStatePoint := AttribClass.TotalStatePoint + aPoint;
   SendClass.SendExtraAttribValues (AttribClass);   
end;

procedure TUser.SSendChatMessage (aStr : String; aColor : Integer);
begin
   SendClass.SendChatMessage (aStr, aColor);
end;

procedure TUser.SCommandIce (aInterval : Integer);
var
   SubData : TSubData;
begin
   if aInterval = 0 then begin
      if BasicData.Feature.rActionState = as_ice then begin
         WearitemClass.SetActionState (as_free);
         SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
      end;
      FIceTick := 0;
      FIceInterval := 0;
      exit;
   end;

   if FIceTick > 0 then exit;

   FIceTick := mmAnsTick;
   FIceInterval := aInterval;
   WearItemClass.SetActionState (as_ice);
   SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
end;

// add by Orber at 2004-09-16 14:35
function TUser.SStartMissionTime;
begin
    MissionStartTick := Now;
    Result := MissionStartTick;
end;

function TUser.SGetPassMissionTime;
begin
    Result := (Now - MissionStartTick) * 1000 + 1;
end;

function TUser.SGetIntoArenaGame(aArenaKey : Word):Integer;
begin
    Result := ArenaObjList.AddMember(aArenaKey, self);
end;

function TUser.SStartArenaGame:Integer;
begin
    Result := ArenaObjList.AddMaster(self);
end;

function TUser.SAddArenaMember(aMasterName : String):String;
begin
    aArenaBody := aMasterName;
    ArenaWindow(Format(Conv('콱句寡꽝속%s돨궐嶠徠항척'),[aMasterName]));

//    result := LowerCase(BoolToStr(ArenaObjList.SelectMaster(aMasterName,self),True));

end;

function TUser.SGetEvent(EventCode:Integer):String;
begin
    if (EventCode > 20 - 1) or (EventCode < 0)  then begin
        result  := '1';
        Exit;
    end;
    result := IntToStr(aEventRecord[EventCode]);
end;

function TUser.SGetSetEvent(EventCode:Integer):String;
var aEventResult : Byte;
begin
    if (EventCode > 20 - 1) or (EventCode < 0) then begin
        result  := '0';
        Exit;
    end;
    aEventResult := aEventRecord[EventCode];
    if aEventResult = 1 then begin
        Result := '0';
    end;
    if aEventResult = 0 then begin
        aEventRecord[EventCode] := 1;
        Result := '1';
    end;
end;

function TUser.SCheckPickup :String;
begin
    if AttribClass.ExtJobKind = 1 then begin
        Result := 'false';
        exit;
    end;
    AttribClass.ExtJobKind := 1;
    Result := 'true';
end;

function TUser.SGetParty :String;
begin
    Result := LowerCase(BoolToStr(MarryList.isParty(Name),True));
end;

function TUser.SSetParty :String;
begin
    Result := 'true';
    MarryList.SetParty(Name);
end;

procedure TUser.SSetJobKind (aKind : Byte);
begin
   if (aKind < 1) or (aKind > JOB_KIND_MAX) then exit;

   HaveJobClass.SetJobKind (aKind);
end;

procedure TUser.SSetVirtueman;
begin
   if (HaveJobClass.JobKind < 1) or (HaveJobClass.JobKind > JOB_KIND_MAX) then exit;

   HaveJobClass.SetVirtueman;
end;

procedure TUser.SSmeltItem (aMakeName : String);
begin
   HaveJobClass.SmeltItem (aMakeName, ShowWindowClass);
end;

procedure TUser.SSmeltItem2 (aMakeName : String);
begin
   HaveJobClass.SmeltItem2 (aMakeName, ShowWindowClass);
end;

procedure TUser.SSendItemMoveInfo (aStr : String);
begin
   SendClass.SendItemMoveInfo (aStr, '');
end;

procedure TUser.SChangeCurDuraByName (aName : String; aCurDura : Integer);
begin
   HaveItemClass.ChangeCurDuraByName (aName, aCurDura);
end;

procedure TUser.SDecreasePrisonTime(aTime: Integer);
begin
   PrisonClass.IncreaseElaspedTime (Name, aTime * 60);
end;

procedure TUser.SUseMagicGradeup (atype, tg : byte);
begin
   HaveMagicClass.SetUseMagicGradeUp (atype, tg);
end;



////////////////////////////////////////////////////
//
//             ===  UserList  ===
//
////////////////////////////////////////////////////

constructor TUserList.Create (cnt: integer);
begin
   CurProcessPos := 0;
   UserProcessCount := 0;

   ExceptCount := 0;
   // TvList := TList.Create;
   // AnsList := TAnsList.Create (cnt, AllocFunction, FreeFunction);
   DataList := TList.Create;
   NameKey := TStringKeyClass.Create;

   // add by minds 050921
   BuildSayCommand;
end;

destructor TUserList.Destroy;
var
   i : Integer;
   User : TUser;
begin
   // AnsList.Free;
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      User.Free;
   end;
   DataList.Clear;
   DataList.Free;

   NameKey.Free;
   // TvList.Free;
   inherited destroy;
end;

function TUserList.InitialLayer (aCharName: string; aConnector : TConnector) : Boolean;
var
   i, Age, nRandom : Integer;
   xx, yy : Word;
   User : TUser;
   tmpManager : TManager;
   ServerID : Integer;
   rStr : String;
begin
   Result := false;

   if NameKey.Select (aCharName) <> nil then exit;

   User := TUser.Create;


   User.Connector := aConnector;
   User.SysopScope := SysopClass.GetSysopScope (aCharName);

   tmpManager := nil;
   rStr := PrisonClass.GetUserStatus (aCharName);
   if rStr <> '' then begin
      User.ServerID := User.Connector.CharData.ServerID;
      for i := 0 to ManagerList.Count - 1 do begin
         tmpManager := ManagerList.GetManagerByIndex (i);
         if tmpManager.boPrison = true then begin
            if User.ServerID <> tmpManager.ServerID then begin
               ServerID := tmpManager.ServerID;
               User.ServerID := ServerID;
               User.Connector.CharData.ServerID := ServerID;
               User.Connector.CharData.X := 61;
               User.Connector.CharData.Y := 77;
            end;
            break;
         end;
         tmpManager := nil;
      end;
   end;

   if tmpManager = nil then begin
      ServerID := User.Connector.CharData.ServerID;
      tmpManager := ManagerList.GetManagerByServerID (ServerID);
      if tmpManager <> nil then begin
         if User.SysopScope >= 100 then begin
         end else if ( tmpManager.LoginX <> 0 ) and ( tmpManager.LoginY <> 0) then begin
            ServerID := tmpManager.LoginServerID;
            User.Connector.CharData.ServerId := ServerID;
            User.Connector.CharData.X := tmpManager.LoginX;
            User.Connector.CharData.y := tmpManager.LoginY;
            tmpManager := ManagerList.GetManagerByServerID (ServerID);
         end else if tmpManager.RegenInterval > 0 then begin
            ServerID := tmpManager.TargetServerID;
            User.Connector.CharData.ServerID := ServerID;
            User.Connector.CharData.X := tmpManager.TargetX;
            User.Connector.CharData.Y := tmpManager.TargetY;
            tmpManager := ManagerList.GetManagerByServerID (ServerID);
         end else if PosByDieClass.GetPosByDieData (tmpManager.ServerID, ServerID, xx, yy) = true then begin
            User.Connector.CharData.ServerID := ServerID;
            User.Connector.CharData.X := xx;
            User.Connector.CharData.Y := yy;
            tmpManager := ManagerList.GetManagerByServerID (ServerID);
         end else if tmpManager.boEvent = TRUE then begin
            Age := GetLevel (User.Connector.CharData.Light + User.Connector.CharData.Dark);
            if Age > tmpManager.EventAge then begin
               ServerID := tmpManager.EventID;
               User.Connector.CharData.ServerId := ServerID;
               nRandom := random (2);
               User.Connector.CharData.X := tmpManager.EventX [nRandom];
               User.Connector.CharData.Y := tmpManager.EventY [nRandom];
               tmpManager := ManagerList.GetManagerByServerID (ServerID);
            end;
         end;
      end else begin
         ServerID := 1;
         User.Connector.CharData.ServerId := ServerID;
         User.Connector.CharData.x := 500;
         User.Connector.CharData.y := 500;
         tmpManager := ManagerList.GetManagerByServerID (ServerID);
      end;
   end;

   User.SetManagerClass (tmpManager);
   
   User.AttribClass.SetAddExpFlag := tmpManager.boGetExp;
   User.HaveMagicClass.SetAddExpFlag := tmpManager.boGetExp;
   tmpManager.UserCount := tmpManager.UserCount + 1;
   
   Result := User.InitialLayer (aCharName);

   User.Initial (aCharName);

   NameKey.Insert (aCharName, User);
   DataList.Add (User);

   Result := true;
end;

procedure   TUserList.StartChar (aCharname: string);
var
   User : TUser;
begin
   User := NameKey.Select (aCharName);
   if User <> nil then begin
      User.StartProcess;
      exit;
   end;
   frmMain.WriteLogInfo ('TUserList.StartChar () failed');
end;

// procedure TUserList.FinalLayer (aCharName: string);
procedure TUserList.FinalLayer (aConnector : TConnector);
var
   i : integer;
   Name : String;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.Connector = aConnector then begin
         Name := User.Name;
         if User.Manager <> nil then
            User.Manager.UserCount := User.Manager.UserCount - 1;
         User.FinalLayer;
         User.EndProcess;
         User.Free;
         DataList.Delete (i);
         NameKey.Delete (Name);
         exit;
      end;
      if User.Name = aConnector.CharacterName then begin
         Name := User.Name;
         if User.Manager <> nil then
            User.Manager.UserCount := User.Manager.UserCount - 1;
         User.FinalLayer;
         User.EndProcess;
         User.Free;
         DataList.Delete (i);
         NameKey.Delete (Name);
         exit;
      end;
   end;
   frmMain.WriteLogInfo ('TUserList.FinalLayer () failed');
end;

procedure  TUserList.SayByServerID (aServerID : Integer; const aStr: String; aColor : Byte);
var
   i : integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.Manager.ServerID = aServerID then begin
         User.SendClass.SendChatMessage (aStr, aColor);
      end;
   end;
end;

procedure TUserList.MoveByServerID (aServerID : Integer; aTargetID, aTargetX, aTargetY : Integer);
var
   i : integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.ServerID = aServerID then begin
         User.FboNewServer := true;
         User.ServerID := aTargetID;
         User.PosMoveX := aTargetX;
         User.PosMoveY := aTargetY;
      end;
   end;
end;

procedure TUserList.SetActionStateByServerID (aServerID : Integer; aActionState : TActionState);
var
   i : integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.Manager.ServerID = aServerID then begin
         User.WearItemClass.SetActionState (aActionState); 
      end;
   end;
end;

procedure TUserList.SendSideMessageByServerID (aServerID : Integer; aStr : String);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.Manager.ServerID = aServerID then begin
         User.SendClass.SendSideMessage (aStr); 
      end;
   end;
end;

procedure  TUserList.GuildSay (const aGuildName, aStr: string);
var
   i : integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.GuildName = aGuildName then begin
         User.SendClass.SendChatMessage (aStr, SAY_COLOR_NORMAL);
      end;
   end;
end;

procedure  TUserList.AllyGuildSay (const aGuildName, aStr: string);
var
   i, iCount : integer;
   Str : String;
   User : TUser;
   GuildObject : TGuildObject;
begin
   GuildObject := GuildList.GetGuildObject (aGuildName);
   if GuildObject = nil then exit;

   if GuildObject.GetAllyGuildName (0) = '' then exit;

   Str := aGuildName;
   iCount := 0;
   while Str <> '' do begin
      for i := 0 to DataList.Count - 1 do begin
         User := DataList.Items [i];
         if User.GuildName = Str then begin
            User.SendClass.SendChatMessage (aStr, SAY_COLOR_GRADE1);
         end;
      end;

      Str := GuildObject.GetAllyGuildName (iCount);
      Inc (iCount);
   end;
end;

procedure TUserList.SendSoundMessage (aSoundNum : String; aMapID : Integer);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if (aMapID >= 0) and (User.Manager.ServerID <> aMapID) then continue;

      User.SendClass.SendSoundEffect (aSoundNum, User.BasicData.x, User.BasicData.y);
   end;
end;

procedure TUserList.SendSoundBasebyServerID (aSoundname: string; aRoopCount: integer; aMapID : Integer);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if (aMapID >= 0) and (User.Manager.ServerID <> aMapID) then continue;

      User.SendClass.SendSoundBase (aSoundName, aRoopCount); 
   end;
end;

procedure  TUserList.SendNoticeMessage (const aStr: String; aColor : Integer);
var
   ComData : TWordComData;
   psChatMessage : PTSChatMessage;
begin
   psChatMessage := @ComData.Data;
   with psChatMessage^ do begin
      rmsg := SM_CHATMESSAGE;
      case aColor of
         SAY_COLOR_NORMAL : begin rFColor := WinRGB (22,22,22); rBColor := WinRGB (0, 0 ,0); end;
         SAY_COLOR_SHOUT  : begin rFColor := WinRGB (22,22,22); rBColor := WinRGB (0, 0 ,24); end;
         SAY_COLOR_SYSTEM : begin rFColor := WinRGB (22,22, 0); rBColor := WinRGB (0, 0 ,0); end;
         SAY_COLOR_NOTICE : begin rFColor := WinRGB (255 div 8, 255 div 8, 255 div 8); rBColor := WinRGB (133 div 8, 133 div 8, 133 div 8); end;

         SAY_COLOR_GRADE0 : begin rFColor := WinRGB (18, 16, 14); rBColor := WinRGB (2,4,5); end;
         SAY_COLOR_GRADE1 : begin rFColor := WinRGB (26, 23, 21); rBColor := WinRGB (2,4,5); end;
         SAY_COLOR_GRADE2 : begin rFColor := WinRGB (31, 29, 27); rBColor := WinRGB (2,4,5); end;
         SAY_COLOR_GRADE3 : begin rFColor := WinRGB (22, 18,  8); rBColor := WinRGB (1,4,11); end;
         SAY_COLOR_GRADE4 : begin rFColor := WinRGB (23, 13,  4); rBColor := WinRGB (1,4,11); end;
         SAY_COLOR_GRADE5 : begin rFColor := WinRGB (31, 29, 21); rBColor := WinRGB (1,4,11); end;

         else begin rFColor := WinRGB (22,22,22); rBColor := WinRGB (0, 0 ,0); end;
      end;

      SetWordString (rWordstring, aStr);
      ComData.Size := Sizeof(TSChatMessage) - Sizeof(TWordString) + sizeofwordstring(rWordString);
   end;

   GateConnectorList.AddSendDataForAll (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TUserList.SendTestMessage (const aStr: String; F1, F2, F3, B1, B2, B3 : Integer);
var
   ComData : TWordComData;
   psChatMessage : PTSChatMessage;
begin
   psChatMessage := @ComData.Data;
   with psChatMessage^ do begin
      rmsg := SM_CHATMESSAGE;
      rFColor := WinRGB (F1, F2, F3);
      rBColor := WinRGB (B1, B2, B3);

      SetWordString (rWordstring, aStr);
      ComData.Size := Sizeof(TSChatMessage) - Sizeof(TWordString) + sizeofwordstring(rWordString);
   end;

   GateConnectorList.AddSendDataForAll (@ComData, ComData.Size + SizeOf (Word));
end;

function TUserList.GetCount: integer;
begin
   Result := DataList.Count;
end;

function TUserList.GetUserList: string;
var
   nCount : Integer;
begin
   if NATION_VERSION = NATION_KOREA then begin
      nCount := (ConnectorList.Count * 13) div 10;
      Result := format (Conv('<窟�邱疥�> %d츰。'), [nCount]) + #13;                 // 본섭
   end else begin
      Result := format (Conv('<窟�邱疥�> %d츰。'), [ConnectorList.Count]) + #13;
   end;
end;

function TUserList.GetUserPointer (const aCharName: string): TUser;
begin
   Result := NameKey.Select (aCharName);
end;

function TUserList.GetUserPointerById (aId: LongInt): TUser;
var
   i : integer;
   User : TUser;
begin
   Result := nil;
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.BasicData.Id = aId then begin
         Result := User;
         exit;
      end;
   end;
end;


procedure TUserList.SendRaining (aRain : TSRainning);
var
   i : integer;
   User : TUser;
begin
   for i := 0 to DataList.Count -1 do begin
      User := DataList.Items [i];
      if User.Manager.boWeather = true then begin
         User.SendClass.SendRainning (aRain);
      end;
   end;
end;

procedure TUserList.SendShowDynamicObject (SenderInfo : TBasicData);
var
   i : integer;
   User : TUser;
begin
   for i := 0 to DataList.Count -1 do begin
      User := DataList.Items [i];
     if User.inZhuang then begin
        User.SendClass.SendShow(SenderInfo,0,lek_none);
     end;
   end;
end;

procedure TUserList.SendHideDynamicObject (SenderInfo : TBasicData);
var
   i : integer;
   User : TUser;
begin
   for i := 0 to DataList.Count -1 do begin
      User := DataList.Items [i];
//      if User.inZhuang then begin
        User.SendClass.SendHide(SenderInfo);
//      end;
   end;
end;


procedure TUserList.Update (CurTick: integer);
var
   i : integer;
   Name : String;
   User : TUser;
   StartPos : integer;
begin
   UserProcessCount := (DataList.Count * 4 div 100);
   if UserProcessCount = 0 then UserProcessCount := DataList.Count;

   UserProcessCount := ProcessListCount;

   if DataList.Count > 0 then begin
      StartPos := CurProcessPos;
      for i := 0 to UserProcessCount - 1 do begin
         if CurProcessPos >= DataList.Count then CurProcessPos := 0;
         User := DataList.Items [CurProcessPos];
         try
            iGStartTick := timeGetTime;
            User.Update (CurTick);
            iGEndTick := timeGetTime;

            if MaxDelayUserTick < iGEndTick - iGStartTick then begin
               MaxDelayUserTick := iGEndTick - iGStartTick;
               AddLog (format ('MDUT:%s(%s,%d,%d) %d', [User.Name, User.Manager.Title, User.BasicData.X, User.BasicData.Y, MaxDelayUserTick]));
            end;
         except
            User.Exception := true;
            Name := User.Name;
            frmMain.WriteLogInfo (format ('TUser.Update (%s) exception', [Name]));
            ConnectorList.CloseConnectByCharName (Name);
            exit;
         end;
         
         Inc (CurProcessPos);
         if CurProcessPos = StartPos then break;
      end;
   end;
end;

function TUserList.FieldProc (aName : String; Msg: Word; var SenderInfo: TBasicData; var aSubData: TSubData) : Integer;
var
   i : Integer;
   User : TUser;
begin
   Result := 0;
   
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.Name = aName then begin
         User.FieldProc (User.BasicData.ID, Msg, SenderInfo, aSubData);
         Result := 1;
         exit;
      end;
   end;
end;

procedure TUserList.SaveUserInfo (aFileName : String);
var
   i : Integer;
   Stream : TFileStream;
   User : TUser;
   Str : String;
   buffer : array [0..1024] of char;
begin
   if FileExists (aFileName) then DeleteFile (aFileName);
   try
      Stream := TFileStream.Create (aFileName, fmCreate);
   except
      exit;
   end;

   Str := 'Name,MasterName,Guild,Map,X,Y,IpAddr' + #13#10;
   StrPCopy (@buffer, Str);
   Stream.WriteBuffer (buffer, StrLen (buffer));
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      Str := User.Name + ',' + User.Connector.LoginID + ',' + User.GuildName + ',' + User.Manager.Title + ',' + IntToStr (User.BasicData.X) + ',' + IntToStr (User.BasicData.Y) + ',';
      Str := Str + User.Connector.IpAddr + #13#10;
      StrPCopy (@buffer, Str);
      Stream.WriteBuffer (buffer, StrLen (buffer));
   end;

   Stream.Free;
end;

{
procedure TUserList.SendSoundEffect (aManager : TManager; aSoundEffect : String);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.Manager = aManager then begin
         User.SendClass.SendSoundEffect (aSoundEffect + '.wav', User.BasicData.X, User.BasicData.Y);
      end;
   end;
end;
}

procedure TUserList.SendGuildInfo (GuildInfo : TSGuildListInfo);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      User.SendClass.SendGuildInfo(GuildInfo);
   end;
end;

procedure TUserList.SendGuildEnergy (aGuildName : String; aGuildEnergyLevel : Byte);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.GuildName = aGuildName then
      User.SendClass.SendGuildEnergy(aGuildEnergyLevel);
   end;
end;


procedure TUserList.SendCenterMessage (const aStr : String);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      User.SendClass.SendCenterMessage (aStr);
   end;
end;

procedure TUserList.SendCenterMessagebyMapID (const aStr : String; aMapID : Integer);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.ServerID = aMapID then begin
         User.SendClass.SendCenterMessage (aStr);
      end;
   end;
end;

procedure TUserList.SendTopMessage (aStr : String);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      User.SendClass.SendTopMessage (aStr);
   end;
end;

procedure TUserList.SendTopLetterMessage (aName, aStr1, aStr2 : String);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      User.SendClass.SendTopLetterMessage (aName, aStr1, aStr2);
   end;
end;

procedure TUserList.SendBattleBar (aLeftName, aRightName : String; aLeftWin, aRightWin : Byte; aLeftPercent, aRightPercent, aBattleType : Integer);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      User.SendClass.SendBattleBar (aLeftName, aRightName, aLeftWin, aRightWin, aLeftPercent, aRightPercent, aBattleType);
   end;
end;

procedure TUserList.SendBattleBarbyMapID (aLeftName, aRightName : String; aLeftWin, aRightWin : Byte; aLeftPercent, aRightPercent, aBattleType : Integer; aMapID : Integer);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.ServerID = aMapID then begin
         User.SendClass.SendBattleBar (aLeftName, aRightName, aLeftWin, aRightWin, aLeftPercent, aRightPercent, aBattleType);
      end;
   end;
end;

procedure TUserList.SendScreenEffectToAll (aEffectNum, aDelay : Integer);
var
   i : integer;
   User : TUser;
begin
   if aDelay < 0 then exit;
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items[i];
      User.SendClass.SendScreenEffect (aEffectNum, aDelay);
   end;
end;

function TUserList.GetUserCountByManager (aID : Integer) : Integer;
var
   i, iCount : Integer;
   User : TUser;
begin
   iCount := 0;
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.ServerID = aID then begin
         Inc (iCount);
      end;
   end;

   Result := iCount;
end;

function TUserList.GetUserForPK (aManager : TManager) : TBasicObject;
var
   i, n : Integer;
   User : TUser;
   tmpList : TList;
begin
   Result := nil;

   tmpList := TList.Create;

   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.Manager = aManager then begin
         tmpList.Add (User);
      end;
   end;

   if tmpList.Count > 0 then begin
      n := Random (tmpList.Count);
      Result := tmpList.Items [n];
   end;

   tmpList.Free;
end;

procedure TUserList.AddItemByEventTeam (aServerID : Integer; aTeam, aItemName : String);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.ServerID = aServerID then begin
         if User.EventTeam <> aTeam then begin
            User.SPutMagicItem (aItemName, aTeam, RACE_DYNAMICOBJECT);
         end;
      end;
   end;
end;

procedure TUserList.AddItemAllUserByMapID (aServerID : Integer; aMopName, aItemName : String);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.ServerID = aServerID then begin
         User.SPutMagicItem (aItemName, aMopName, RACE_MONSTER);
      end;
   end;
end;

procedure TUserList.AddItemUserByGruopAndMapID(aServerID : Integer; aGroupKey : Integer; aMopName: String ;aItemName: String);
var
   i: Integer;
   User: TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if (User.ServerID = aServerID) and (User.GroupKey = aGroupKey) then begin
         User.SPutMagicItem (aItemName, Conv('씌세끝'), RACE_MONSTER);
      end;
   end;
end;

procedure TUserList.DeleteItemAllUserbyName (aServerID : Integer; aItemName : String);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.ServerID = aServerID then begin
         User.DeleteAllItembyName (aItemName);
      end;
   end;
end;

function TUserList.GetRemainGuildUserbyServerID (aServerID : Integer; aGuildName : String) : Integer;
var
   i, nCount : Integer;
   User : TUser;
begin
   nCount := 0;

   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if (User.ServerID = aServerID) and (User.GuildName = aGuildName) then begin
         inc (nCount);
      end;
   end;

   Result := nCount;
end;

procedure TUserList.KickMemberFromZhuang;
var
   i: Integer;
   User : TUser;
begin

   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.inZhuang and (User.GuildName <> Zhuang.MasterGuild.GuildName) and (User.GuildName <> Zhuang.SlaveGuild[0].GuildName) then begin
        User.SetPosition(186,886);
      end;
   end;
end;


//Author:Steven Date: 2004-12-08 14:54:11
//Note:
{ TGameTeam }

procedure TGameTeam.AddMember(AMember: TUser);
begin
  AMember.Team := Self;
  FMemberList.AddObject(AMember.Name, AMember);
end;

procedure TGameTeam.BootOutTeam(AMemberIndex: Integer);
begin
  DeleteMember(AMemberIndex);
end;

procedure TGameTeam.BootOutTeam(ABuildUser: TUser; AMemberName: string);
begin
  if FBuildUser.Name = ABuildUser.Name then
    DeleteMember(AMemberName)
  else
{$IFDEF _DEBUG}
    raise Exception.Create(ABuildUser.Name + '가,隣훙狼비돛,꼇狼쫘璟훙');
{$ENDIF}
end;

function TGameTeam.CheckEnableHit(ATargetId: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to FMemberList.Count - 1 do
    if TUser(FMemberList.Objects[i]).BasicData.id = ATargetId then
    begin
      Result := False;
      Exit;
    end;
end;

procedure TGameTeam.ClearMember;
var
  i: Integer;
begin
  for i := 0 to FMemberList.Count - 1 do
  begin
    TUser(FMemberList.Objects[i]).Team := nil;
  end;
  FMemberList.Clear;
end;

constructor TGameTeam.Create(AMember: TUser);
begin
  FMemberList := TStringList.Create;
  FBuildUser := AMember;
  AddMember(AMember);
end;

procedure TGameTeam.DeleteMember(AMemberIndex: Integer);
begin
  with FMemberList do
  begin
    TUser(Objects[AMemberIndex]).Team := nil;
    Delete(AMemberIndex);
  end;
end;

procedure TGameTeam.DeleteMember(AMemberName: string);
var
  Index: Integer;
begin
  with FMemberList do
  begin
    Index := IndexOf(AMemberName);
    if Index < 0 then
      Exit;
    TUser(Objects[Index]).Team := nil;
    Delete(Index);
  end;
end;

destructor TGameTeam.Destroy;
var
  i: Integer;
begin
  ClearMember;
  FMemberList.Free;
  inherited;
end;

function TGameTeam.FindMember(AMemberName: string): TUser;
begin
  Result := nil;
  if FMemberList.IndexOf(AMemberName) > -1 then
    Result := TUser(FMemberList.Objects[FMemberList.IndexOf(AMemberName)]);
end;

function TGameTeam.FindMember(AMemberIndex: Integer): TUser;
begin
  Result := TUser(FMemberList.Objects[AMemberIndex]);
end;

function TGameTeam.FindMemberIndex(AMemberName: string): Integer;
begin
  Result := FMemberList.IndexOf(AMemberName);
end;

function TGameTeam.GetBuildUser: TUser;
begin
  Result := FBuildUser;
end;

function TGameTeam.GetMemberCount: Integer;
begin
  Result := FMemberList.Count;
end;

function TGameTeam.GetMemberPosStr(AName: String): String;
var
  i: Integer;
  Str: String;
begin
  Str := '';
  for i := 0 to MemberCount - 1 do
  begin
    if Str <> '' then
      Str := Str + ',';
    if AName <> FindMember(i).Name then
    begin
    Str := Str + format('%s:%d:%d:%d', [FindMember(i).Name,
        FindMember(i).BasicData.X, FindMember(i).BasicData.Y, 34512]);
    end;
  end;
  Result := Str;
end;

procedure TGameTeam.InsideInfomation(AInfo: string);
begin
  //..
end;

procedure TGameTeam.JoinInTeam(AMember: TUser);
begin

  //邱쇱꿴훙鑒
  if MemberCount >= MAX_TEAM_MEMBER then
    Exit;
  AddMember(AMember);
end;

procedure TGameTeam.LeaveTeam(AMemberName: string);
begin
  DeleteMember(AMemberName);
end;

procedure TGameTeam.ShareExtraExp(AExp: Integer ; ServerID :Integer);
var
  i: Integer;
  n: real;
begin
  //롸탰覩橙
  case FMemberList.Count of
    2, 3: n := 0.10;
    4, 5: n := 0.15;
    6, 7: n := 0.20;
    8:    n := 0.30;
    else
      Exit;
  end;
  
  AExp := Trunc(AExp * (1 + n) / FMemberList.Count);
  for i := 0 to FMemberList.Count - 1 do
  begin
    if TUser(FMemberList.Objects[i]).ServerID = ServerID then begin
    TUser(FMemberList.Objects[i]).AttribClass.AddExtraExp(AExp);
    end;
  end;
end;

class procedure TGameTeam.TeamBuild(AMember: TUser);
begin
  Create(AMember);
end;

procedure TGameTeam.TeamDisband;
begin
  Destroy;
end;

procedure TGameTeam.TellEveryOne(ASay: string; AColor: Byte);
var
  i: Integer;
begin
  for i := 0 to FMemberList.Count - 1 do
  begin
    TUser(FMemberList.Objects[i]).SendClass.SendChatMessage(ASay, AColor);
  end;
end;

  //Author:Steven Date: 2004-12-10 16:18:30
  //Note:
procedure TUser.AcceptInvitation(ApInvitation: PTSInvitation);
var
  tmpUser: TUser;
  Key: string;
begin
  if ApInvitation^.rReturn = AGREE_INVITATION then
  begin
    tmpUser := UserList.GetUserPointer(StrPas(@ApInvitation^.rUser));

    //쇱꿴tmpUser뚤蹶
    if not Assigned(tmpUser) then
      Exit;

    //쇱꿎굶훙角뤠瞳莉뚠櫓
    if Assigned(Team) then
    begin
      tmpUser.SendClass.SendChatMessage(Format(Conv('퀭轟랬男헝綠꽝속뚠橋돨鯤소"%s"'), [Name]),
        SAY_COLOR_SYSTEM);
      Exit;
    end;

    //쇱꿎랙폅男헝훙깃街륜
    Key := StrPas(@ApInvitation^.rKey);
    if Key <> tmpUser.InviteKey then
      Exit;

    //눼쉔莉뚠
    if not Assigned(tmpUser.Team) then
    begin
      TGameTeam.TeamBuild(tmpUser);
      tmpUser.Team.JoinInTeam(Self);
    end
    else
    begin
      tmpUser.Team.JoinInTeam(Self);
    end;

    //蕨홍뚠밤꺄侶몸句口
    tmpUser.Team.TellEveryOne(Format(Conv('鯤소"%s"냥묘속흙考뚠'), [Name]),
      SAY_COLOR_SYSTEM);
    //譚tmpUser눼쉔
  end;

  if ApInvitation^.rReturn = DISAGREE_INVITATION then
  begin
    tmpUser := UserList.GetUserPointer(StrPas(@ApInvitation^.rUser));
    if not Assigned(tmpUser) then
      Exit;
    tmpUser.SendClass.SendChatMessage(Format(Conv('"%s"鯤소앳없속흙흙莉뚠'), [Name]),
      SAY_COLOR_SYSTEM);
  end;

  tmpUser := nil;
end;

procedure TUser.CheckAndFreeTeam;
begin
  if not Assigned(Team) then
    Exit;
  if Team.FBuildUser.Name = Name then
  begin
    Team.TellEveryOne(Conv('퀭돨뚠橋綠쒔썩��'), SAY_COLOR_SYSTEM);
    Team.TeamDisband;
  end
  else
  begin
    Team.TellEveryOne(Format(Conv('鯤소"%s"잼역考뚠'), [Name]),
      SAY_COLOR_SYSTEM);
    if Team.MemberCount > 2 then
    begin
      Team.LeaveTeam(Name);
    end
    else
    begin
      Team.TellEveryOne(Conv('퀭돨뚠橋綠쒔썩��'), SAY_COLOR_SYSTEM);
      Team.TeamDisband;
    end;
  end;
end;


procedure TUserObject.SetNameColor(aIndex: Word);
begin
    WearItemClass.SetNameColor(aIndex);
end;



function TUser.SGetExtJobExp: Integer;
begin
   Result := AttribClass.ExtJobExp;
end;

function TUser.SGetExtJobLevel: Integer;
begin
  Result := AttribClass.ExtJobLevel;
end;

function TUser.SSetExtJobExp(aExp: Integer): Integer;
begin
   if AttribClass.ExtJobLevel < 9999 then
   begin
      AttribClass.ExtJobExp := AttribClass.ExtJobExp + aExp;
   end;
   Result := AttribClass.ExtJobExp;
end;

function TUser.SGetExtJobKind: Byte;
begin
   Result := AttribClass.ExtJobKind;
end;


procedure TUser.SSetExtJobKind(AValue: Byte);
begin
  AttribClass.ExtJobKind := AValue;
end;

function TUser.SGetExtJobGrade: String;
begin
   Result := JobClass.GetExtJobGradeName(AttribClass.ExtJobExp);
end;

end.
