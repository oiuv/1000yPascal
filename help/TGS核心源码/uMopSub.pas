unit uMopSub;

interface

uses
   Classes, SysUtils, BasicObj, svClass, uAnsTick, AUtil32, DefType;

const
   //MOP_DROPITEM_MAX      = 5;
   MOP_DROPITEM_MAX      = 10;
   MOP_HAVEITEM_MAX      = 10;
   MOP_WANTITEM_MAX      = 5;
   MOP_FALLITEM_MAX      = 5;
   MOP_QUESTITEM_MAX     = 3;   

   MOP_HAVEMAGIC_MAX     = 5;

type
   TMopHaveItemClass = class
   private
      BasicObject : TBasicObject;

      DropItemArr : array [0..MOP_DROPITEM_MAX - 1] of TCheckItem;
      HaveItemArr : array [0..MOP_HAVEITEM_MAX - 1] of TAtomItem;
      FallItemArr : array [0..MOP_FALLITEM_MAX - 1] of TAtomItem;
      WantItemArr : array [0..MOP_WANTITEM_MAX - 1] of String;
      QuestItemArr : array [0..MOP_QUESTITEM_MAX - 1] of TAtomItem; //2003-10      
   public
      FallItemRandomCount : Integer;
      constructor Create (aBasicObject : TBasicObject);
      destructor Destroy; override;

      procedure Clear;
      procedure DropItemClear;
      procedure HaveItemClear;
      procedure FallItemClear;
      procedure WantItemClear;
      procedure QuestItemClear;  //2003-10

      function DropItemCount : Integer;
      function HaveItemCount : Integer;
      function FallItemCount : Integer;
      function WantItemCount : Integer;
      function QuestItemCount : integer;//2003-10

      function DropItemFreeCount : Integer;
      function HaveItemFreeCount : Integer;
      function FallItemFreeCount : Integer;
      function WantItemFreeCount : Integer;
      function QuestItemFreeCount : integer; //2003-10

      function FindDropItem (aName : String) : Integer;
      function AddDropItem (aName : String; aCount : Integer) : Boolean;
      function DelDropItem (aName : String) : Boolean;

      function FindFallItem (aName : String) : Integer;
      function AddFallItem (aName : String; aCount : Integer; aFallCount : Integer) : Boolean;
      function DelFallItem (aName : String) : Boolean;

      function FindHaveItem (aName : String) : Integer;
      function AddHaveItem (aName : String; aCount, aColor : Integer) : Boolean;
      function DelHaveItem (aName : String; aColor, aCount : Integer) : Boolean;

      function FindWantItem (aName : String) : Integer;
      function AddWantItem (aName : String) : Boolean;
      function DelWantItem (aName : String) : Boolean;

      function FindQuestItem (aName : String) : Integer;
      function AddQuestItem (aName : String; aCount : Integer; aColor : Integer) : Boolean;
      function DelQuestItem (aName : String) : Boolean;

//      function DropItemGround : Boolean;
      function DropItemGround (aPickupID : Integer) : Boolean;
      function DropQuestItemGround (aPickupID : integer) : Boolean;      
   end;

   TMopHaveMagicClass = class
   private
      BasicObject : TBasicObject;

      UsedTickArr : array [0..MAGICSPECIAL_LAST - 1] of Integer;
      HaveMagicPos : array [0..MAGICSPECIAL_LAST - 1] of Byte;
      HaveMagicArr : array [0..MOP_HAVEMAGIC_MAX - 1] of TMagicParamData;
      HaveMagicData : array [0..MOP_HAVEMAGIC_MAX - 1] of TMagicData;
   public
      constructor Create (aBasicObject : TBasicObject);
      destructor Destroy; override;

      procedure Clear;
      procedure Init (aMagicStr : String);

      function isHaveShowMagic : Boolean;
      function isHaveHideMagic : Boolean;
      function isHaveSameMagic : Boolean;
      function isHaveHealMagic : Boolean;
      function isHaveSwapMagic : Boolean;
      function isHaveEatMagic : Boolean;
      function isHaveKillMagic : Boolean;
      function isHavePickMagic : Boolean;
      function isHaveBloodMagic : Boolean;
      function isHaveCallMagic : Boolean;
      function isHaveDeadBlowMagic : Boolean;

      function RunHaveSameMagic (aPercent : Integer; var aSubData : TSubData) : Boolean;
      function RunHaveHealMagic (aName : String; aPercent : Integer; var aSubData : TSubData) : Boolean;
      function RunHaveSwapMagic (aPercent : Integer; var aSubData : TSubData) : Boolean;
      function RunHaveEatMagic (aPercent : Integer; aHaveItemClass : TMopHaveItemClass; var aSubData : TSubData) : Boolean;
      function RunHavePickMagic (aPercent : Integer; aName : String) : Boolean;
      function RunHaveHideMagic (aPercent : Integer) : Boolean;
      function RunHaveShowMagic : Boolean;
      function RunHaveBloodMagic (var aSubData : TSubData) : Boolean;
      function RunHaveCallMagic (var aName : array of String; var aCount : array of Integer; var aWidth : Word): Boolean;
      function RunHaveDeadBlowMagic (var aFuncKind : Byte; var aSkillLevel : Integer) : Boolean;
   end;



implementation

uses
   uMonster, FSockets;

// TMopHaveItemClass
constructor TMopHaveItemClass.Create (aBasicObject : TBasicObject);
begin
   BasicObject := aBasicObject;
   Clear;
end;

destructor TMopHaveItemClass.Destroy;
begin
   inherited Destroy;
end;

procedure TMopHaveItemClass.Clear;
begin
   DropItemClear;
   HaveItemClear;
   WantItemClear;
   FallItemClear;
   QuestItemClear;   
end;

procedure TMopHaveItemClass.DropItemClear;
var
   i : Integer;
begin
   for i := 0 to MOP_DROPITEM_MAX - 1 do begin
      FillChar (DropItemArr [i], SizeOf (TCheckItem), 0);
   end;
end;

procedure TMopHaveItemClass.HaveItemClear;
var
   i : Integer;
begin
   for i := 0 to MOP_HAVEITEM_MAX - 1 do begin
      FillChar (HaveItemArr [i], SizeOf (TAtomItem), 0);
   end;
end;

procedure TMopHaveItemClass.WantItemClear;
var
   i : Integer;
begin
   for i := 0 to MOP_WANTITEM_MAX - 1 do begin
      WantItemArr [i] := '';
   end;
end;

procedure TMopHaveItemClass.FallItemClear;
var
   i : Integer;
begin
   for i := 0 to MOP_FALLITEM_MAX - 1 do begin
      FillChar (FallItemArr [i], SizeOf (TAtomItem), 0);
   end;
end;

procedure TMopHaveItemClass.QuestItemClear;
var
   i : integer;
begin
   for i := 0 to MOP_QUESTITEM_MAX - 1 do begin
      FillChar (QuestItemArr[i], SizeOf(TAtomItem), 0);
   end;
end;

function TMopHaveItemClass.DropItemCount : Integer;
var
   i, iCount : Integer;
begin
   iCount := 0;
   for i := 0 to MOP_DROPITEM_MAX - 1 do begin
      if DropItemArr[i].rName [0] <> 0 then begin
         Inc (iCount);
      end;
   end;

   Result := iCount;
end;

function TMopHaveItemClass.HaveItemCount : Integer;
var
   i, iCount : Integer;
begin
   iCount := 0;
   for i := 0 to MOP_HAVEITEM_MAX - 1 do begin
      if HaveItemArr [i].rName [0] <> 0 then begin
         Inc (iCount);
      end;
   end;

   Result := iCount;
end;

function TMopHaveItemClass.FallItemCount : Integer;
var
   i, iCount : Integer;
begin
   iCount := 0;
   for i := 0 to MOP_FALLITEM_MAX - 1 do begin
      if FallItemArr [i].rName [0] <> 0 then begin
         Inc (iCount);
      end;
   end;

   Result := iCount;
end;

function TMopHaveItemClass.WantItemCount : Integer;
var
   i, iCount : Integer;
begin
   iCount := 0;
   for i := 0 to MOP_WANTITEM_MAX - 1 do begin
      if WantItemArr [i] <> '' then begin
         Inc (iCount);
      end;
   end;

   Result := iCount;
end;

function TMopHaveItemClass.QuestItemCount : integer;
var
   i, iCount : integer;
begin
   iCount := 0;
   for i := 0 to MOP_QUESTITEM_MAX -1 do begin
      if QuestItemArr[i].rName[0] <> 0 then begin
         inc(iCount);
      end;
   end;
   Result := iCount;
end;

function TMopHaveItemClass.DropItemFreeCount : Integer;
begin
   Result := MOP_DROPITEM_MAX - DropItemCount;
end;

function TMopHaveItemClass.HaveItemFreeCount : Integer;
begin
   Result := MOP_HAVEITEM_MAX - HaveItemCount;
end;

function TMopHaveItemClass.FallItemFreeCount : Integer;
begin
   Result := MOP_FALLITEM_MAX - FallItemCount;
end;

function TMopHaveItemClass.WantItemFreeCount : Integer;
begin
   Result := MOP_WANTITEM_MAX - WantItemCount;
end;

function TMopHaveItemClass.QuestItemFreeCount : integer; //2003-10
begin
   Result := MOP_QUESTITEM_MAX - QuestItemCount;
end;

function TMopHaveItemClass.FindDropItem (aName : String) : Integer;
var
   i, iCount : Integer;
begin
   iCount := 0;
   for i := 0 to MOP_DROPITEM_MAX - 1 do begin
      if StrPas (@DropItemArr[i].rName) = aName then begin
         Inc (iCount);
      end;
   end;

   Result := iCount;
end;

function TMopHaveItemClass.AddDropItem (aName : String; aCount : Integer) : Boolean;
var
   i : Integer;
begin
   Result := false;

   for i := 0 to MOP_DROPITEM_MAX - 1 do begin
      if DropItemArr [i].rName [0] = 0 then begin
         StrPCopy (@DropItemArr [i].rName, aName);
         DropItemArr [i].rCount := aCount;
         Result := true;
         exit;
      end;
   end;
end;

function TMopHaveItemClass.DelDropItem (aName : String) : Boolean;
var
   i : Integer;
begin
   Result := false;

   for i := 0 to MOP_DROPITEM_MAX - 1 do begin
      if StrPas (@DropItemArr [i].rName) = aName then begin
         DropItemArr [i].rName [0] := 0;
         DropItemArr [i].rCount := 0;
         Result := true;
         exit;
      end;
   end;
end;

function TMopHaveItemClass.FindHaveItem (aName : String) : Integer;
var
   i, iCount : Integer;
begin
   iCount := 0;
   for i := 0 to MOP_HAVEITEM_MAX - 1 do begin
      if StrPas (@HaveItemArr [i].rName) = aName then begin
         Inc (iCount);
      end;
   end;

   Result := iCount;
end;

function TMopHaveItemClass.AddHaveItem (aName : String; aCount, aColor : Integer) : Boolean;
var
   i : Integer;
begin
   Result := false;

   for i := 0 to MOP_HAVEITEM_MAX - 1 do begin
      if HaveItemArr [i].rName [0] = 0 then begin
         StrPCopy (@HaveItemArr [i].rName, aName);
         HaveItemArr [i].rCount := aCount;
         HaveItemArr [i].rColor := aColor;
         Result := true;
         exit;
      end;
   end;
end;

function TMopHaveItemClass.DelHaveItem (aName : String; aColor, aCount : Integer) : Boolean;
var
   i : Integer;
begin
   Result := false;

   for i := 0 to MOP_HAVEITEM_MAX - 1 do begin
      if StrPas (@HaveItemArr [i].rName) = aName then begin
         if HaveItemArr [i].rCount > 0 then begin
            if (aColor < 0) or (HaveItemArr [i].rColor = aColor) then begin
               HaveItemArr [i].rCount := HaveItemArr [i].rCount - aCount;
               if HaveItemArr [i].rCount <= 0 then begin
                  HaveItemArr [i].rName [0] := 0;
                  HaveItemArr [i].rCount := 0;
                  HaveItemArr [i].rColor := 0;
               end;
               Result := true;
               exit;
            end;
         end;
      end;
   end;
end;

function TMopHaveItemClass.FindFallItem (aName : String) : Integer;
var
   i, iCount : Integer;
begin
   iCount := 0;
   for i := 0 to MOP_FALLITEM_MAX - 1 do begin
      if StrPas (@FallItemArr [i].rName) = aName then begin
         Inc (iCount);
      end;
   end;

   Result := iCount;
end;

function TMopHaveItemClass.AddFallItem (aName : String; aCount : Integer; aFallCount : Integer) : Boolean;
var
   i : Integer;
begin
   Result := false;

   for i := 0 to MOP_FALLITEM_MAX - 1 do begin
      if FallItemArr [i].rName [0] = 0 then begin
         StrPCopy (@FallItemArr [i].rName, aName);
         FallItemArr [i].rCount := aCount;
         FallItemArr [i].rColor := aFallCount;
         Result := true;
         exit;
      end;
   end;
end;

function TMopHaveItemClass.DelFallItem (aName : String) : Boolean;
var
   i : Integer;
begin
   Result := false;

   for i := 0 to MOP_FALLITEM_MAX - 1 do begin
      if StrPas (@FallItemArr [i].rName) = aName then begin
         FallItemArr [i].rName [0] := 0;
         FallItemArr [i].rCount := 0;
         FallItemArr [i].rColor := 0;
         Result := true;
         exit;
      end;
   end;
end;

function TMopHaveItemClass.FindWantItem (aName : String) : Integer;
var
   i, iCount : Integer;
begin
   iCount := 0;
   for i := 0 to MOP_WANTITEM_MAX - 1 do begin
      if WantItemArr [i] = aName then begin
         Inc (iCount);
      end;
   end;

   Result := iCount;
end;

function TMopHaveItemClass.AddWantItem (aName : String) : Boolean;
var
   i : Integer;
begin
   Result := false;
   for i := 0 to MOP_WANTITEM_MAX - 1 do begin
      if WantItemArr [i] = '' then begin
         WantItemArr [i] := aName;
         Result := true;
         exit;
      end;
   end;
end;

function TMopHaveItemClass.DelWantItem (aName : String) : Boolean;
var
   i : Integer;
begin
   Result := false;
   for i := 0 to MOP_WANTITEM_MAX - 1 do begin
      if WantItemArr [i] = aName then begin
         WantItemArr [i] := '';
         Result := true;
         exit;
      end;
   end;
end;

function TMopHaveItemClass.FindQuestItem (aName : String) : Integer;
var
   i, iCount : Integer;
begin
   iCount := 0;
   for i := 0 to MOP_QUESTITEM_MAX - 1 do begin
      if StrPas (@QuestItemArr [i].rName) = aName then begin
         Inc (iCount);
      end;
   end;

   Result := iCount;
end;

function TMopHaveItemClass.AddQuestItem (aName : String; aCount : Integer; aColor : Integer) : Boolean;
var
   i : Integer;
begin
   Result := false;

   for i := 0 to MOP_QUESTITEM_MAX - 1 do begin
      if QuestItemArr [i].rName [0] = 0 then begin
         StrPCopy (@QuestItemArr [i].rName, aName);
         QuestItemArr [i].rCount := aCount;
         QuestItemArr [i].rColor := aColor;
         Result := true;
         exit;
      end;
   end;
end;

function TMopHaveItemClass.DelQuestItem (aName : String) : Boolean;
var
   i : Integer;
begin
   Result := false;

   for i := 0 to MOP_QUESTITEM_MAX - 1 do begin
      if StrPas (@QuestItemArr [i].rName) = aName then begin
         QuestItemArr [i].rName [0] := 0;
         QuestItemArr [i].rCount := 0;
         QuestItemArr [i].rColor := 0;
         Result := true;
         exit;
      end;
   end;
end;

//function TMopHaveItemClass.DropItemGround: Boolean;
function TMopHaveItemClass.DropItemGround (aPickupID : Integer) : Boolean;
var
   i, j, cnt : Integer;
   xx, yy, sx, sy : Word;
   MopName : String;
   ItemData : TItemData;
   SubData : TSubData;
   CheckItem : TCheckItem;
   usd : TStringData;
   Count : integer;
   n : integer;
   boDropFallItem : Boolean;
begin
   Result := false;
   boDropFallItem := false;
   Count := 0;
   MopName := StrPas (@BasicObject.BasicData.Name);
   BasicObject.BasicData.nx := BasicObject.BasicData.x;
   BasicObject.BasicData.ny := BasicObject.BasicData.y;

   usd.rmsg := 1;                                             // 몬스터갯수날리고
   SetWordString (usd.rWordString, 'Monster:' + MopName + ',1,');
   cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);

   FrmSockets.UdpObjectAddData (cnt, @usd);

   for i := 0 to MOP_DROPITEM_MAX - 1 do begin
      if DropItemArr[i].rName [0] <> 0 then begin
         if ItemClass.GetCheckItemData (MopName, DropItemArr [i], ItemData) = false then continue;
         ItemData.rOwnerName[0] := 0;
         SubData.ItemData := ItemData;
         SubData.ServerId := BasicObject.Manager.ServerId;
         SubData.TargetID := aPickupID;         

         SignToItem (SubData.ItemData, SubData.ServerID, BasicObject.BasicData, '');

         if ItemData.rAttribute = ITEM_ATTRIBUTE_DIRECT then begin
            BasicObject.Phone.SendMessage (aPickUpID, FM_ADDITEM, BasicObject.BasicData, SubData);
         end else begin
            BasicObject.Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicObject.BasicData, SubData);
         end;

         Inc (Count);
         usd.rmsg := 1;                                        // 아이템 갯수 날리고
         SetWordString (usd.rWordString, 'Item:' + StrPas (@ItemData.rName) + ',' + IntToStr (ItemData.rCount) + ',');
         cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);

         FrmSockets.UdpObjectAddData (cnt, @usd);
      end;
   end;

   for i := 0 to MOP_HAVEITEM_MAX - 1 do begin
      if HaveItemArr[i].rName [0] <> 0 then begin
         if Random (2) = 1 then begin
            StrCopy (@CheckItem.rName, @HaveItemArr[i].rName);
            if ItemClass.GetCheckItemData (MopName, CheckItem, ItemData) = false then continue;
            ItemData.rCount := HaveItemArr[i].rCount;
            ItemData.rColor := HaveItemArr[i].rColor;
            ItemData.rOwnerName[0] := 0;
            SubData.ItemData := ItemData;
            SubData.ServerId := BasicObject.Manager.ServerId;
            SignToItem (SubData.ItemData, SubData.ServerID, BasicObject.BasicData, '');

            if ItemData.rAttribute = ITEM_ATTRIBUTE_DIRECT then begin
               BasicObject.Phone.SendMessage (aPickUpID, FM_ADDITEM, BasicObject.BasicData, SubData);
            end else begin
               BasicObject.Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicObject.BasicData, SubData);
            end;
            Inc(Count);
         end;
      end;
   end;
   
   if FallItemRandomCount = 1 then boDropFallItem := true
   else if FallItemRandomCount = 0 then boDropFallItem := false
   else begin
      n := random (FallItemRandomCount);
      if n = 1 then boDropFallItem := true;
   end;

   if boDropFallItem = true then begin
      for i := 0 to MOP_FALLITEM_MAX - 1 do begin
         if FallItemArr[i].rName [0] <> 0 then begin
            if ItemClass.GetItemData (StrPas (@FallItemArr[i].rName), ItemData) = false then continue;
            ItemData.rCount := FallItemArr[i].rCount;
            ItemData.rOwnerName[0] := 0;
            SubData.ItemData := ItemData;
            SubData.EffectNumber := 1;
            SubData.EffectKind := lek_none;
            SubData.ServerId := BasicObject.Manager.ServerId;
            SubData.TargetID := aPickupID;            
            SignToItem (SubData.ItemData, SubData.ServerID, BasicObject.BasicData, '');

            sx := BasicObject.BasicData.nx;
            sy := BasicObject.BasicData.ny;

            for j := 0 to FallItemArr [i].rColor - 1 do begin
               xx := random (8) + (sx - 4);
               yy := random (8) + (sy - 4);
               BasicObject.BasicData.nx := xx;
               BasicObject.BasicData.ny := yy;

               if ItemData.rAttribute = ITEM_ATTRIBUTE_DIRECT then begin
                  BasicObject.Phone.SendMessage (aPickUpID, FM_ADDITEM, BasicObject.BasicData, SubData);
               end else begin
                  BasicObject.Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicObject.BasicData, SubData);
               end;

               Inc (Count);
               usd.rmsg := 1;                                        // 아이템 갯수 날리고
               SetWordString (usd.rWordString, 'Item:' + StrPas (@ItemData.rName) + ',' + IntToStr (ItemData.rCount) + ',');
               cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);

               FrmSockets.UdpObjectAddData (cnt, @usd);
            end;
            Inc(Count);
         end;
      end;
   end;

   HaveItemClear;
   if Count <> 0 then Result := true;
end;

function TMopHaveItemClass.DropQuestItemGround (aPickupID : integer) : Boolean;
var
   i, cnt, Count: integer;
   ItemData : TItemData;
   SubData : TSubData;
   MopName : String;
   usd : TStringData;
begin
   Result := false;
   Count := 0;
   MopName := StrPas (@BasicObject.BasicData.Name);
  // add by Orber at 2005-06-13 15:04:29
//   for i := 0 to MOP_FALLITEM_MAX - 1 do begin
   for i := 0 to MOP_QUESTITEM_MAX - 1 do begin
      if QuestItemArr[i].rName [0] <> 0 then begin
         if ItemClass.GetItemData (StrPas (@QuestItemArr[i].rName), ItemData) = false then continue;
         ItemData.rOwnerName[0] := 0;
         ItemData.rCount := QuestItemArr[i].rCount;
         ItemData.rcolor := QuestItemArr[i].rColor;

         SubData.ItemData := ItemData;
         SubData.ServerId := BasicObject.Manager.ServerId;
         SubData.TargetID := aPickupID;

         SignToItem (SubData.ItemData, SubData.ServerID, BasicObject.BasicData, '');

         if ItemData.rAttribute = ITEM_ATTRIBUTE_DIRECT then begin
            BasicObject.Phone.SendMessage (aPickUpID, FM_ADDITEM, BasicObject.BasicData, SubData);
         end else begin
            BasicObject.Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicObject.BasicData, SubData);
         end;

         usd.rmsg := 1;                                        // 아이템 갯수 날리고
         SetWordString (usd.rWordString, 'Item:' + StrPas (@ItemData.rName) + ',' + IntToStr (ItemData.rCount) + ',');
         cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);

         FrmSockets.UdpObjectAddData (cnt, @usd);
         Inc(Count);
      end;
   end;
  // add by Orber at 2005-06-13 16:44:25
  //? why Clear QuestItemList...
   //QuestItemClear;
   if Count <> 0 then Result := true;
end;



// TMopHaveMagicClass
constructor TMopHaveMagicClass.Create (aBasicObject : TBasicObject);
begin
   BasicObject := aBasicObject;

   FillChar (UsedTickArr, SizeOf (UsedTickArr), 0);
   FillChar (HaveMagicPos, SizeOf (HaveMagicPos), 0);
   FillChar (HaveMagicArr, SizeOf (HaveMagicArr), 0);
   FillChar (HaveMagicData, SizeOf (HaveMagicData), 0);
end;

destructor TMopHaveMagicClass.Destroy;
begin
   inherited Destroy;
end;

procedure TMopHaveMagicClass.Clear;
begin
end;

procedure TMopHaveMagicClass.Init (aMagicStr : String);
var
   i : Integer;
   iName : String;
   Str, rdStr : String;
begin
   iName := StrPas (@BasicObject.BasicData.Name);

   FillChar (UsedTickArr, SizeOf (UsedTickArr), 0);
   FillChar (HaveMagicPos, SizeOf (HaveMagicPos), 0);
   FillChar (HaveMagicArr, SizeOf (HaveMagicArr), 0);
   FillChar (HaveMagicData, SizeOf (HaveMagicData), 0);

   Str := aMagicStr;
   for i := 0 to MOP_HAVEMAGIC_MAX - 1 do begin
      Str := GetValidStr3 (Str, rdStr, ':');
      if rdStr = '' then break;
      if MagicParamClass.GetMagicParamData (iName, rdStr, HaveMagicArr [i]) = true then begin
         MagicClass.GetMagicData (HaveMagicArr [i].MagicName, HaveMagicData [i], 9999);
         if HaveMagicData [i].rMagicType = MAGICTYPE_SPECIAL then begin
            HaveMagicPos [HaveMagicData [i].rFunction] := i + 1;
         end;
      end;
   end;
end;

function TMopHaveMagicClass.isHaveShowMagic : Boolean;
begin
   Result := false;
   if HaveMagicPos [MAGICSPECIAL_SHOW] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveHideMagic : Boolean;
begin
   Result := false;
   if HaveMagicPos [MAGICSPECIAL_HIDE] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveSameMagic : Boolean;
begin
   Result := false;
   if HaveMagicPos [MAGICSPECIAL_SAME] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveHealMagic : Boolean;
begin
   Result := false;
   if HaveMagicPos [MAGICSPECIAL_HEAL] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveSwapMagic : Boolean;
begin
   Result := false;
   if HaveMagicPos [MAGICSPECIAL_SWAP] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveEatMagic : Boolean;
begin
   Result := false;
   if HaveMagicPos [MAGICSPECIAL_EAT] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveKillMagic : Boolean;
begin
   Result := false;
   if HaveMagicPos [MAGICSPECIAL_KILL] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHavePickMagic : Boolean;
begin
   Result := false;
   if HaveMagicPos [MAGICSPECIAL_PICK] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveBloodMagic : Boolean;
begin
   Result := false;
   if HaveMagicPos [MAGICSPECIAL_BLOOD] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveCallMagic : Boolean;
begin
   Result := false;
   if HaveMagicPos [MAGICSPECIAL_CALL] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveDeadBlowMagic : Boolean;
begin
   Result := false;
   if HaveMagicPos [MAGICSPECIAL_DEADBLOW] > 0 then Result := true;
end;

function TMopHaveMagicClass.RunHaveSameMagic (aPercent : Integer; var aSubData : TSubData) : Boolean;
var
   ArrPos : Integer;
begin
   Result := false;

   ArrPos := HaveMagicPos [MAGICSPECIAL_SAME] - 1;
   if ArrPos < 0 then exit;
   if UsedTickArr [MAGICSPECIAL_SAME] <> 0 then exit;

   if aPercent <= HaveMagicArr[ArrPos].NumberParam[0] then begin
      UsedTickArr [MAGICSPECIAL_SAME] := mmAnsTick;
      aSubData.HitData.ToHit := HaveMagicArr [ArrPos].NumberParam[1];
      Result := true;
   end;
end;

function TMopHaveMagicClass.RunHaveHealMagic (aName : String; aPercent : Integer; var aSubData : TSubData) : Boolean;
var
   i, ArrPos : Integer;
   boFlag : Boolean;
begin
   Result := false;

   ArrPos := HaveMagicPos [MAGICSPECIAL_HEAL] - 1;
   if ArrPos < 0 then exit;
   if mmAnsTick < UsedTickArr [MAGICSPECIAL_HEAL] + HaveMagicArr[ArrPos].NumberParam [2] then exit;

   boFlag := false;
   for i := 0 to 5 - 1 do begin
      if aName = HaveMagicArr [ArrPos].NameParam [i] then begin
         boFlag := true;
         break;
      end;
   end;
   if boFlag = false then exit;

   if aPercent <= HaveMagicArr [ArrPos].NumberParam [0] then begin
      UsedTickArr [MAGICSPECIAL_HEAL] := mmAnsTick;
      aSubData.HitData.ToHit := HaveMagicArr [ArrPos].NumberParam [1];
      Result := true;
   end;
end;

function TMopHaveMagicClass.RunHaveSwapMagic (aPercent : Integer; var aSubData : TSubData) : Boolean;
var
   ArrPos : Integer;
begin
   Result := false;

   ArrPos := HaveMagicPos [MAGICSPECIAL_SWAP] - 1;
   if ArrPos < 0 then exit;

   if aPercent <= HaveMagicArr[ArrPos].NumberParam[0] then begin
      UsedTickArr [MAGICSPECIAL_SWAP] := mmAnsTick;
      StrPCopy (@aSubData.SubName, HaveMagicArr[ArrPos].NameParam [0]);
      asubdata.Percent := HaveMagicArr [ArrPos].NumberParam[1];           // 아이템 떨어뜨리는가 안떨어뜨리는가...
      Result := true;
   end;
end;

function TMopHaveMagicClass.RunHaveEatMagic (aPercent : Integer; aHaveItemClass : TMopHaveItemClass; var aSubData : TSubData) : Boolean;
var
   ArrPos : Integer;
begin
   Result := false;

   ArrPos := HaveMagicPos [MAGICSPECIAL_EAT] - 1;
   if ArrPos < 0 then exit;

   if mmAnsTick < UsedTickArr [MAGICSPECIAL_EAT] + HaveMagicArr [ArrPos].NumberParam [2] then exit;

   if aPercent > HaveMagicArr[ArrPos].NumberParam [0] then exit;
   if aHaveItemClass.FindHaveItem (HaveMagicArr[ArrPos].NameParam [0]) > 0 then begin
      aHaveItemClass.DelHaveItem (HaveMagicArr [ArrPos].NameParam [0], -1, 1);
      StrPCopy (@aSubData.ItemData.rName, HaveMagicArr[ArrPos].NameParam [0]);
      aSubData.HitData.ToHit := HaveMagicArr[ArrPos].NumberParam [1];
      UsedTickArr [MAGICSPECIAL_EAT] := mmAnsTick;
      Result := true;
      exit;
   end;
end;

function TMopHaveMagicClass.RunHavePickMagic (aPercent : Integer; aName : String) : Boolean;
var
   i : Integer;
   ArrPos : Integer;
   boFlag : Boolean;
begin
   Result := false;

   ArrPos := HaveMagicPos [MAGICSPECIAL_PICK] - 1;
   if ArrPos < 0 then exit;

   if aPercent > HaveMagicArr [ArrPos].NumberParam [0] then exit;

   boFlag := false;
   if HaveMagicArr [ArrPos].NameParam [0] <> '' then begin
      for i := 0 to 5 - 1 do begin
         if aName = HaveMagicArr [ArrPos].NameParam [i] then begin
            boFlag := true;
            break;
         end;
      end;
   end else begin
      boFlag := true;
   end;

   if boflag = true then begin
      UsedTickArr [MAGICSPECIAL_PICK] := mmAnsTick;
      Result := true;
   end;
end;

function TMopHaveMagicClass.RunHaveShowMagic : Boolean;
var
   ArrPos : Integer;
begin
   Result := false;

   ArrPos := HaveMagicPos [MAGICSPECIAL_SHOW] - 1;
   if ArrPos < 0 then exit;

   UsedTickArr [MAGICSPECIAL_SHOW] := mmAnsTick;

   Result := true;
end;

function TMopHaveMagicClass.RunHaveHideMagic (aPercent : Integer) : Boolean;
var
   ArrPos : Integer;
begin
   Result := false;

   ArrPos := HaveMagicPos [MAGICSPECIAL_HIDE] - 1;
   if ArrPos < 0 then exit;

   if HaveMagicArr [ArrPos].NumberParam [2] > 0 then begin
      if mmAnsTick < UsedTickArr [MAGICSPECIAL_HIDE] + HaveMagicArr [ArrPos].NumberParam [1] then exit;
   end;

   if aPercent < HaveMagicArr [ArrPos].NumberParam [0] then exit;
   if aPercent > HaveMagicArr [ArrPos].NumberParam [1] then exit;

   UsedTickArr [MAGICSPECIAL_HIDE] := mmAnsTick;
   
   Result := true;
end;

function TMopHaveMagicClass.RunHaveBloodMagic (var aSubData : TSubData): Boolean;
var
   ArrPos : Integer;
begin
   Result := false;

   ArrPos := HaveMagicPos [MAGICSPECIAL_BLOOD] - 1;
   if ArrPos < 0 then exit;

   if HaveMagicArr [ArrPos].NumberParam [0] > 0 then begin
      if mmAnsTick < UsedTickArr [MAGICSPECIAL_BLOOD] + HaveMagicArr [ArrPos].NumberParam [0] then exit;
   end;

   aSubData.SpellType := SPELLTYPE_POISON;
   aSubData.SpellDamage := HaveMagicArr [ArrPos].NumberParam [1];
   aSubData.ShoutColor := HaveMagicArr [ArrPos].NumberParam [2];   // 반경셀
   aSubData.motion := HaveMagicArr [ArrPos].NumberParam [3];       // 흡혈술 상대방이 받는 이펙트
   aSubData.EffectNumber := HaveMagicArr [ArrPos].NumberParam [4]; // 흡혈술시 자신의 이펙트
   UsedTickArr [MAGICSPECIAL_BLOOD] := mmAnsTick;

   Result := true;
end;

function TMopHaveMagicClass.RunHaveCallMagic (var aName : array of String; var aCount : array of Integer; var aWidth : Word): Boolean;
var
   ArrPos, i : Integer;
   str : String;
begin
   Result := false;

   ArrPos := HaveMagicPos [MAGICSPECIAL_CALL] - 1;
   if ArrPos < 0 then exit;

   if HaveMagicArr [ArrPos].NumberParam [1] = 0 then begin
      if UsedTickArr [MAGICSPECIAL_CALL] > 0 then begin
         exit;
      end;
   end;

   for i := 0 to 5 - 1 do begin
      if HaveMagicArr [ArrPos].NameParam [i] = '' then break;
      str := HaveMagicArr [ArrPos].NameParam [i];
      str := GetValidStr3 (str, aName [i], ':');            // 누구를 소환하나
      aCount [i] := _StrToInt (str);                         // 몇마리를
   end;
   aWidth := HaveMagicArr [ArrPos].NumberParam [0];     // 몇셀범위안에 들어왔을때

   UsedTickArr [MAGICSPECIAL_CALL] := mmAnsTick;

   Result := true;
end;

function TMopHaveMagicClass.RunHaveDeadBlowMagic (var aFuncKind : Byte; var aSkillLevel : Integer): Boolean;
var
   ArrPos : Integer;
begin
   Result := false;

   ArrPos := HaveMagicPos [MAGICSPECIAL_DEADBLOW] - 1;
   if ArrPos < 0 then exit;

   aFuncKind := HaveMagicArr [ArrPos].NumberParam [0];      // 필살기종류   3: 오선방 2: 팔진격
   aSkillLevel := HaveMagicArr [ArrPos].NumberParam [1];    // 수련치

   UsedTickArr [MAGICSPECIAL_DEADBLOW] := mmAnsTick;

   Result := true;
end;


end.
