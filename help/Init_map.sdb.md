# MAP.SDB

> 地图中script为地图OnTimer过程触发的脚本，或者ATTRIBUTE为6可在地图刷新倒计时30秒触发OnEventTimer过程。

提示：在Map.SDB中增加的地图，如果没有增加传送门、NPC等在小地图上可显示的对象，按ALT+M无法调出小地图。

## 相关代码

```pascal
// uManager.pas
function TManagerList.LoadFromFile (aFileName : String) : Boolean;
var
   i, j : Integer;
   Manager : TManager;
   MapDB : TUserStringDB;
   iName : String;
   Str, Dest, StrID, StrX, StrY, DestX, DestY : String;
begin
   Result := false;

   Clear;

   MapDB := TUserStringDB.Create;
   MapDB.LoadFromFile (aFileName);

   for i := 0 to MapDB.Count - 1 do begin
      iName := MapDB.GetIndexName (i);
      if iName <> '' then begin
         Manager := TManager.Create;

         Manager.ServerId := StrToInt (iName);
         Manager.SmpName := MapDB.GetFieldValueString (iName, 'SmpName');
         Manager.MapName := MapDB.GetFieldValueString (iName, 'MapName');
         Manager.ObjName := MapDB.GetFieldValueString (iName, 'ObjName');
         Manager.RofName := MapDB.GetFieldValueString (iName, 'RofName');
         Manager.TilName := MapDB.GetFieldValueString (iName, 'TilName');
         Manager.Title := MapDB.GetFieldValueString (iName, 'MapTitle');
         Manager.SoundBase := MapDB.GetFieldValueString (iName, 'SoundBase');
         Manager.OldSoundBase := Manager.SoundBase;
         Manager.SoundEffect := MapDB.GetFieldValueString (iName, 'SoundEffect');
         Manager.SoundStart := MapDB.GetFieldValueString (iName, 'SoundStart');
         Manager.SoundEnd := MapDB.GetFieldValueString (iName, 'SoundEnd');
         Manager.boUseChemistDrug := MapDB.GetFieldValueBoolean (iName, 'boUseChemistDrug');         
         Manager.boUseDrug := MapDB.GetFieldValueBoolean (iName, 'boUseDrug');
         Manager.boUsePowerItem := MapDB.GetFieldValueBoolean (iName, 'boUsePowerItem');
         Manager.boUseGuildMagic := MapDB.GetFieldValueBoolean (iName, 'boUseGuildMagic');
         Manager.boUseWindMagic := MapDB.GetFieldValueBoolean (iName, 'boUseWindMagic');
         Manager.boUseBestMagic := MapDB.GetFieldValueBoolean (iName, 'boUseBestMagic');
         Manager.boUseBestSpecialMagic := MapDB.GetFieldValueBoolean (iName, 'boUseBestSpecialMagic');
         Manager.boCanChangeMagic := MapDB.GetFieldValueBoolean (iName, 'boCanChangeMagic');
         Manager.boUseMagic := MapDB.GetFieldValueBoolean (iName, 'boUseMagic');
         Manager.boUseRiseMagic := MapDB.GetFieldValueBoolean (iName, 'boUseRiseMagic');
         Manager.boUsePowerLevel := MapDB.GetFieldValueBoolean (iName, 'boUsePowerLevel');
         Manager.boUseEtcMagic := MapDB.GetFieldValueBoolean (iName, 'boUseEtcMagic');
         Manager.boUseBowMagic := MapDB.GetFieldValueBoolean (iName, 'boUseBowMagic');
         Manager.boItemDrop := MapDB.GetFieldValueBoolean (iName, 'boItemDrop');
         Manager.boGetExp := MapDB.GetFieldValueBoolean (iName, 'boGetExp');
         Manager.boBigSay := MapDB.GetFieldValueBoolean (iName, 'boBigSay');
         Manager.boMakeGuild := MapDB.GetFieldValueBoolean (iName, 'boMakeGuild');
         Manager.boPosDie := MapDB.GetFieldValueBoolean (iName, 'boPosDie');
         Manager.boHit := MapDB.GetFieldValueBoolean (iName, 'boHit');
         Manager.boWeather := MapDB.GetFieldValueBoolean (iName, 'boWeather');
         Manager.boPrison := MapDB.GetFieldValueBoolean (iName, 'boPrison');
         Manager.boChangeLife := MapDB.GetFieldValueBoolean (iName, 'boChangeLife');
         Manager.ChangeDelay := MapDB.GetFieldValueInteger (iName, 'ChangeDelay');
         Manager.ChangeSize := MapDB.GetFieldValueInteger (iName, 'ChangeSize');
         Manager.MapAttribute := MapDB.GetFieldValueInteger(iName, 'Attribute');
         Manager.boDark := MapDB.GetFieldValueBoolean (iName, 'boDark');
         Manager.boRain := MapDB.GetFieldValueBoolean (iName, 'boRain');
         Manager.ChangePercentage := MapDB.GetFieldValueInteger (iName, 'ChangePercentage');
         Manager.boPick := MapDb.GetFieldValueBoolean(iName, 'boPick');
         Manager.boNotDeal := MapDB.GetFieldValueBoolean (iName, 'boNotDeal');

         Manager.RegenInterval := MapDB.GetFieldValueInteger (iName, 'RegenInterval');
         Manager.EffectInterval := MapDB.GetFieldValueInteger (iName, 'EffectInterval');

         Manager.TargetServerID := MapDB.GetFieldValueInteger (iName, 'TargetServerID');
         Manager.TargetX := MapDB.GetFieldValueInteger (iName, 'TargetX');
         Manager.TargetY := MapDB.GetFieldValueInteger (iName, 'TargetY');

         Manager.LoginServerID := MapDB.GetFieldValueInteger (iName, 'LoginServerID');
         Manager.LoginX := MapDB.GetFieldValueInteger (iName, 'LoginX');
         Manager.LoginY := MapDB.GetFieldValueInteger (iName, 'LoginY');
         Manager.boSetGroupKey := MapDB.GetFieldValueBoolean (iName, 'boSetGroupKey');
         Manager.GroupKey := MapDB.GetFieldValueInteger (iName, 'GroupKey');
         Manager.boPK := MapDB.GetFieldValueBoolean(iName, 'boPK'); //10-02
         Manager.boEvent := MapDB.GetFieldValueBoolean (iName, 'boEvent'); 
         Manager.EventAge := MapDB.GetFieldValueInteger (iName, 'EventAge');  // 10-12
         Manager.EventID := MapDB.GetFieldValueInteger (iName, 'EventID');
         StrX := MapDB.GetFieldValueString (iName, 'EventX');
         if StrX <> '' then begin
            for j := 0 to 2 - 1 do begin
               if StrX = '' then break;
               StrX := GetValidStr3 (StrX, DestX, ':');
               Manager.EventX [j] := _StrToInt (DestX);
            end;
         end;

         StrY := MapDB.GetFieldValueString (iName, 'EventY');
         if StrY <> '' then begin
            for j := 0 to 2 - 1 do begin
               if StrY = '' then break;
               StrY := GetValidStr3 (StrY, DestY, ':');
               Manager.EventY [j] := _StrToInt (DestY);
            end;
         end;

         //2003-05-13
         Str := MapDB.GetFieldValueString (iName, 'SubMap');
         if Str <> '' then begin
            j := 0;
            while Str <> '' do begin
               Str := GetValidStr3 (Str, StrID, ':');
               Manager.SubMapIDs[j] := _StrToInt (StrID);
               inc(j);
            end;
         end;

         Manager.MotherMapId := MapDB.GetFieldValueInteger (iName, 'MotherMap');
         Manager.boNotAllowPK := MapDB.GetFieldValueBoolean (iName, 'boNotAllowPK');
         Manager.boShop := MapDB.GetFieldValueBoolean (iName, 'boShop'); 
                  
         Manager.CalcTime (Manager.RegenInterval, Manager.TotalHour, Manager.TotalMin, Manager.TotalSec);
         Manager.CalcTime (Manager.RegenInterval, Manager.RemainHour, Manager.RemainMin, Manager.RemainSec);

         Str := MapDB.GetFieldValueString (iName, 'UseDrugName');
         if Str <> '' then begin
            for j := 0 to 5 - 1 do begin
               if Str = '' then break;
               Str := GetValidStr3 (Str, Dest, ':');
               Manager.UseDrugName [j] := Dest;
            end;
         end;
          
         Manager.Maper := TMaper.Create ('.\Smp\' + Manager.SmpName);
         Manager.Phone := TFieldPhone.Create (Manager);

         Manager.MonsterList := TMonsterList.Create (Manager);
         Manager.ItemList := TItemList.Create (Manager);
         Manager.StaticItemList := TStaticItemList.Create (Manager);
         Manager.DynamicObjectList := TDynamicObjectList.Create (Manager);
         Manager.VirtualObjectList := TVirtualObjectList.Create (Manager);
         Manager.MineObjectList := TMineObjectList.Create (Manager);
         Manager.NpcList := TNpcList.Create (Manager);

         Manager.SetScript (MapDB.GetFieldValueInteger (iName, 'Script'));
         Manager.boShowMiniMap := MapDB.GetFieldValueBoolean (iName, 'boShowMiniMap');                  
         Manager.boNotUseHideItem := MapDB.GetFieldValueBoolean (iName, 'boNotUseHideItem');
         DataList.Add (Manager);
      end;
   end;

   MapDB.Free;

   Result := true;
end;

// UUser.pas
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
```

## 文件结构

字段 | 类型 | 描述 | 示例
-|-|-|-
MapID|integer| 地图ID，唯一编号，其中0为不可传纸条的新手村，1为主地图 | 0
SmpName|string| 地图结构文件名，在服务端Smp目录（*.smp） | south.smp
MapName|string| 地图文件名称，在客户端Map文件（*.map）可用工具转为smp文件 | south.map
TilName|string| 地图地面（如地毯）文件名，在客户端Til文件（*til.til） | southtil.til
ObjName|string| 地图物体（如树木）文件名，在客户端Obj文件（*obj.obj） | southobj.obj
RofName|string| 地图顶层（如屋顶）文件名，在客户端Rof文件（*rof.obj） | southrof.obj
SoundBase|int| 背景音乐文件名，不需要扩展名，支持`.wav`和`.mp3`格式，文件在客户端Wav目录 | 1001
SoundEffect|int| 音效文件名，不需要`.wav`扩展名，文件在客户端Wav目录effect.atw中，由EffectInterval控制生效间隔 | 1002
MapTitle|string| 地图标题，需要唯一不重复 | 侠客村
boUseBowMagic|boolean| 是否可使用弓术和投术 | TRUE
boUseChemistDrug|boolean| 是否可使用炼丹药品 | TRUE
boUseDrug|boolean| 是否可使用药品 | TRUE
boGetExp
boBigSay
boUsePowerItem|boolean|是否可用属性装备|TRUE
boUseGuildMagic
boUseMagic|boolean|是否可用一级武功|TRUE
boUseRiseMagic|boolean|是否可用上层武功|TRUE
boUseWindMagic|boolean|是否可用掌法|TRUE
boUseBestMagic|boolean|是否可用绝世武功|TRUE
boUseBestSpecialMagic|boolean|是否可用招式|TRUE
boUsePowerLevel
boUseEtcMagic|boolean|是否可用辅助武功（风灵旋类）|TRUE
boCanChangeMagic
boMakeGuild
boItemDrop
boPosDie| boolean | 死亡时是否异地重生，为TRUE时有PosByDie.sdb控制重生点 | TRUE
boHit
boWeather| boolean | 在TGS菜单上点Rain（需选中Weather）可下雨或雪（1月下雪，2和12月80%几率）| TRUE
boPrison
boChangeLife
ChangePercentage
ChangeDelay
ChangeSize
Attribute|int| 地图特殊属性，见下表 | 1
RegenInterval|int| 地图刷新时间间隔，倒计时为0触发传送（在刷新之前地图Mop不会重生）|180000
EffectInterval|int|地图声音音效播放间隔|3000
TargetServerID|int| 传送服务器ID，在RegenInterval倒计时到0时触发传送，如果有SubMap，还会把所有子地图玩家传送 | 1
TargetX|int| 传送目标X坐标，注意不要设置MotherMap | 10
TargetY|int| 传送目标Y坐标，注意不要设置MotherMap | 10
boDark|boolean|代码中有内容，但无实现，应该无效|
boRain|boolean|代码中有内容，但无实现，应该无效|
boPick
Script
LoginServerID|int| 登录服务器ID，如果有设置，在玩家登录游戏时会触发（GM不会）|1
LoginX|int| 登录服务器X坐标 |10
LoginY|int| 登录服务器Y坐标 |10
boSetGroupKey
GroupKey
boPK
boEvent
EventAge
EventID
EventX
EventY
boNotAllowPK
boShop|boolean|可摆摊，指令@准备摆摊，未开放功能|
SubMap
MotherMap
boNotUseHideItem
boShowMiniMap|boolean|注意这个是对战用，显示团队成员，如果普通地图设置会不显示NPC和跳点|FALSE
boFirstPickUp|boolean| 从源码中看这个是没用的，没找到相关代码 | FALSE
UseDay||从源码看这个是没用的，没找到相关代码|
StartHour||从源码看这个是没用的，没找到相关代码|
EndHour||从源码看这个是没用的，没找到相关代码|
SoundStart
SoundEnd
UseDrugName
boNotDeal


### Attribute

```
   MAP_TYPE_ICE   = 1;   # 地图类型：冰属性（装备火属性物品不掉活力）
   MAP_TYPE_FIRE  = 2;   # 地图类型：火属性（装备冰属性物品不掉活力）
   MAP_TYPE_FILL  = 3;   # 地图类型：新手村（带五色药水增加活力、内力、外力、武功）
   MAP_TYPE_BATTLE      = 4;   # 地图类型：大战场（击败对手比赛）
   MAP_TYPE_DONTTICKET  = 5;   # 地图类型：无法使用传送符的区域
   MAP_TYPE_KILLONLYONE = 6;   # 地图类型：只能击败一个指定的怪物（OnEventTimer事件）
   MAP_TYPE_GUILDBATTLE = 7;   # 地图类型：门派大战 - 只能吃一种药（中国活动）
   MAP_TYPE_POWERLEVEL  = 8;   # 地图类型：境界等级小于2级会消耗活力
   MAP_TYPE_SPORTBATTLE = 9;   # 地图类型：竞技场
```

当 boChangeLife 为 TRUE 时，Attribute 属性相关代码：

```pascal
   if Manager.boChangeLife = true then begin
      case Manager.MapAttribute of
         MAP_TYPE_ICE :
            begin
               if WearItemClass.SpecialItemType <> ITEM_ATTRIBUTE_FIRE then begin
                  if BasicData.Feature.rfeaturestate <> wfs_die then begin
                     if ChangeLifeTick + Manager.ChangeDelay <= CurTick then begin
                        AttribClass.CurLife := AttribClass.CurLife - ((AttribClass.Life div 100) * Manager.ChangePercentage);
                        ChangeLifeTick := CurTick;
                        SendClass.SendSideMessage (Conv('活力减少'));
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
                        SendClass.SendSideMessage (Conv('活力减少'));
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
                        AttribClass.CurLife := AttribClass.CurLife + Manager.ChangeSize; // 提升活力、内功、外功、武功
                        AttribClass.CurInPower := AttribClass.CurInPower + Manager.ChangeSize;
                        AttribClass.CurOutPower := AttribClass.CurOutPower + Manager.ChangeSize;
                        AttribClass.CurMagic := AttribClass.CurMagic + Manager.ChangeSize;
                        SendClass.SendSideMessage (Conv('喝口五色药水恢复活力'));
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
                     SendClass.SendSideMessage (Conv('活力减少'));
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

```

SoundEffect 和 EffectInterval 相关代码：

```pascal
      if SoundEffect <> '' then begin
         if CurTick >= EffectTick + EffectInterval then begin
            UserList.SendSoundMessage (format ('%s.wav', [SoundEffect]), ServerID);
            EffectTick := CurTick;
         end;
      end;
```
