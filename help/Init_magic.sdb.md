# Magic.SDB

```pascal
procedure THaveMagicClass.LoadFromSdb (aCharData : PTDBRecord);
var
   i, n, PowerValue : integer;
   str : String;
   tmpMagicData : TMagicData;
   boRet : Boolean;
begin
   ReQuestPlaySoundNumber := 0;

   MagicClass.GetMagicData (INI_DEF_WRESTLING, DefaultMagic[default_wrestling], aCharData^.BasicMagicArr[0].Skill);
   MagicClass.GetMagicData (INI_DEF_FENCING, DefaultMagic[default_fencing], aCharData^.BasicMagicArr[1].Skill);
   MagicClass.GetMagicData (INI_DEF_SWORDSHIP, DefaultMagic[default_swordship], aCharData^.BasicMagicArr[2].Skill);
   MagicClass.GetMagicData (INI_DEF_HAMMERING, DefaultMagic[default_hammering], aCharData^.BasicMagicArr[3].Skill);
   MagicClass.GetMagicData (INI_DEF_SPEARING, DefaultMagic[default_spearing], aCharData^.BasicMagicArr[4].Skill);
   MagicClass.GetMagicData (INI_DEF_BOWING, DefaultMagic[default_bowing], aCharData^.BasicMagicArr[5].Skill);
   MagicClass.GetMagicData (INI_DEF_THROWING, DefaultMagic[default_throwing], aCharData^.BasicMagicArr[6].Skill);
   MagicClass.GetMagicData (INI_DEF_RUNNING, DefaultMagic[default_running], aCharData^.BasicMagicArr[8].Skill);
   MagicClass.GetMagicData (INI_DEF_BREATHNG, DefaultMagic[default_breathng], aCharData^.BasicMagicArr[7].Skill);
   MagicClass.GetMagicData (INI_DEF_PROTECTING, DefaultMagic[default_Protecting], aCharData^.BasicMagicArr[9].Skill);

   for i := 0 to 10 - 1 do begin
      MagicClass.Calculate_cLifeData (@DefaultMagic[i]);
      FSendClass.SendBasicMagic (i, DefaultMagic[i]);
   end;

   for i := 10 to 20 - 1 do begin
      str := StrPas (@aCharData^.BasicRiseMagicArr[i - 10].Name) + ':' + IntToStr (aCharData^.BasicRiseMagicArr[i - 10].Skill);
      MagicClass.GetHaveMagicData (str, DefaultMagic [i]);
      MagicClass.Calculate_cLifeData (@DefaultMagic [i]);
      FSendClass.SendBasicMagic (i, DefaultMagic [i]);
   end;

   for i := 0 to 10 - 1 do begin
      if (FAttribClass.Virtue > 6000) and (FAttribClass.Energy > 8000) then begin
         if DefaultMagic [i].rcSkillLevel = 9999 then begin
            if DefaultMagic [10 + i].rname [0] = 0 then begin
               Case DefaultMagic [i].rMagicType of
                  MAGICTYPE_WRESTLING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_WRESTLING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_FENCING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_FENCING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_SWORDSHIP :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_SWORDSHIP2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_HAMMERING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_HAMMERING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_SPEARING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_SPEARING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_BOWING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_BOWING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_THROWING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_THROWING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_RUNNING :
                     begin
                        {
                        if MagicClass.GetMagicData (INI_DEF_RUNNING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                        }
                     end;
                  MAGICTYPE_BREATHNG :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_BREATHNG2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_PROTECTING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_PROTECTING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
               end;
            end;
         end;
      end;
   end;

   PowerValue := FAttribClass.Age div 2;
   for i := 0 to 20 - 1 do begin
      if DefaultMagic[i].rname[0] = 0 then continue;
      if DefaultMagic[i].rMagicClass = 0 then begin
         SetMagicIndex (false, DefaultMagic[i].rMagicType, MAGICRELATION_3, i);
      end else begin
         SetMagicIndex (true, DefaultMagic[i].rMagicType, MAGICRELATION_3, i);
      end;

      if DefaultMagic[i].rMagicClass = MAGICCLASS_MAGIC then begin
         //원기계산. 기본무공부분 원기적용
         case DefaultMagic[i].rcSkillLevel of
            5000..5999 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint div 10;
            end;
            6000..6999 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint * 2 div 10;
            end;
            7000..7999 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint * 3 div 10;
            end;
            8000..8999 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint * 4 div 10;
            end;
            9000..9998 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint * 5 div 10;
            end;
            9999 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint;
            end;
         end;
      end else begin
         if DefaultMagic [i].rcSkillLevel = 9999 then begin
            PowerValue := PowerValue + DefaultMagic [i].rEnergyPoint;
          end;
      end;
   end;

   for i := 0 to HAVEMAGICSIZE-1 do begin
      str := StrPas (@aCharData^.HaveMagicArr[i].Name) + ':' + IntToStr (aCharData^.HaveMagicArr[i].Skill);
      MagicClass.GetHaveMagicData (str, HaveMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveMagicArr[i]);
      FSendClass.SendHaveMagic (i, HaveMagicArr[i]);

      if HaveMagicArr[i].rname[0] = 0 then continue;
      if HaveMagicArr[i].rGuildMagictype = 0  then
         SetMagicIndex(false, HaveMagicArr[i].rMagicType, HaveMagicArr[i].rMagicRelation, i);
      //원기계산. 장법 부분 원기적용
         case HaveMagicArr[i].rcSkillLevel of
            5000..5999 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint div 10;
            end;
            6000..6999 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint * 2 div 10;
            end;
            7000..7999 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint * 3 div 10;
            end;
            8000..8999 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint * 4 div 10;
            end;
            9000..9998 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint * 5 div 10;
            end;
            9999 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint;
            end;
         end;
   end;

   for i := 0 to HAVERISEMAGICSIZE-1 do begin
       str := StrPas (@aCharData^.HaveRiseMagicArr[i].Name) + ':' + IntToStr (aCharData^.HaveRiseMagicArr[i].Skill);
      MagicClass.GetHaveMagicData (str, HaveRiseMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveRiseMagicArr[i]);
      FSendClass.SendHaveRiseMagic (i, HaveRiseMagicArr[i]);
      if HaveRiseMagicArr[i].rname[0] = 0 then continue;
      SetMagicIndex (true, HaveRiseMagicArr[i].rMagicType, HaveRiseMagicArr[i].rMagicRelation, i);
      if HaveRiseMagicArr [i].rcSkillLevel = 9999 then begin
         PowerValue := PowerValue + HaveRiseMagicArr [i].rEnergyPoint;
      end;
   end;

   //2002-11-06 giltae
   for i := 0 to HAVEMYSTERYMAGICSIZE-1 do begin
      str := StrPas (@aCharData^.HaveMysteryArr[i].Name) + ':' + IntToStr (aCharData^.HaveMysteryArr[i].Skill);
      MagicClass.GetHaveMagicData (str, HaveMysteryMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveMysteryMagicArr[i]);
      FSendClass.SendHaveMystery (i, HaveMysteryMagicArr[i]);
      if HaveMysteryMagicArr[i].rname[0] = 0 then continue;
      SetMysteryMagicIndex (HaveMysteryMagicArr[i].rMagicRelation, i);

      //원기계산. 장법 부분 원기적용
      case HaveMysteryMagicArr[i].rcSkillLevel of
         5000..5999 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint div 10;
         end;
         6000..6999 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint * 2 div 10;
         end;
         7000..7999 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint * 3 div 10;
         end;
         8000..8999 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint * 4 div 10;
         end;
         9000..9998 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint * 5 div 10;
         end;
         9999 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint;
         end;
      end;
   end;

   //2003-09-19 초수는 총 15개까지, 공력은 5개, 절세무공은 5개까지 되어 있음
   //클라이언트상에서 보이는 위치가 제한적이라 25개를 같이 뭉치지 않음
   for i := 0 to HAVEBESTSPECIALMAGICSIZE-1 do begin
      str := GetBestMagicString(aCharData^.HaveBestSpecialMagicArr[i]);
      MagicClass.GetHaveBestMagicData (str, HaveBestSpecialMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveBestSpecialMagicArr[i]);
      FSendClass.SendHaveBestSpecialMagic (i, HaveBestSpecialMagicArr[i]);
      if HaveBestSpecialMagicArr[i].rname[0] = 0 then continue;
      {
      if HaveBestSpecialMagicArr [i].rcSkillLevel = 9999 then begin
         PowerValue := PowerValue + HaveBestSpecialMagicArr [i].rEnergyPoint;
      end;
      }
   end;
   for i := 0 to HAVEBESTPROTECTMAGICSIZE-1 do begin
      str := GetBestMagicString(aCharData^.HaveBestProtectMagicArr[i]);
      MagicClass.GetHaveBestMagicData (str, HaveBestProtectMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveBestProtectMagicArr[i]);
      FSendClass.SendHaveBestProtectMagic (i, HaveBestProtectMagicArr[i]);
      if HaveBestProtectMagicArr[i].rname[0] = 0 then continue;
      MagicCycleClass.GetEnergyPointData (@HaveBestProtectMagicArr[i]);

      PowerValue := PowerValue + HaveBestProtectMagicArr [i].rEnergyPoint;
   end;
   for i := 0 to HAVEBESTATTACKMAGICSIZE-1 do begin
      str := GetBestMagicString(aCharData^.HaveBestAttackMagicArr[i]);
      MagicClass.GetHaveBestMagicData (str, HaveBestAttackMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveBestAttackMagicArr[i]);
      FSendClass.SendHaveBestAttackMagic (i, HaveBestAttackMagicArr[i]);
      if HaveBestAttackMagicArr[i].rname[0] = 0 then continue;
      MagicCycleClass.GetEnergyPointData (@HaveBestAttackMagicArr[i]);

      PowerValue := PowerValue + HaveBestAttackMagicArr [i].rEnergyPoint;
   end;

   //개별적인 원기를 더했다.
   //원기보너스를 적용한다.
   //가로빙고
   for i := MAGICTYPE_WRESTLING to MAGICTYPE_SPEARING do begin
      boRet := boBingGoColumn(false, i, 0);
      if boRet = true then PowerValue := PowerValue + 700;
      //상승가로빙고
      boRet := boBingGoColumn(true, i, 0);
      if boRet = true then PowerValue := PowerValue + 1050;
   end;
   //새로빙고
   for i := MAGICRELATION_0 to MAGICRELATION_6 do begin
      boRet := boBingGoRow (false, 0, i);
      if boRet = true then PowerValue := PowerValue + 500;
      //상승세로빙고
      boRet := boBingGoRow (true, 0, i);
      if boRet = true then PowerValue := PowerValue + 750;
   end;
   //강신빙고
   boRet := boBingGoColumn (false, MAGICTYPE_PROTECTING, 0);
   if boRet = true then PowerValue := PowerValue + 700;
   //상승강신빙고
   boRet := boBingGoColumn (true, MAGICTYPE_PROTECTING, 0);
   if boRet = true then PowerValue := PowerValue + 1050;

   //장법빙고
   boRet := boBingGoMystery;
   if boRet = true then PowerValue := PowerValue + 1500;

   FAttribClass.SetEnergyValue (PowerValue);

   FPowerLevel := MagicClass.CalcPowerLevel (PowerValue);
   FCurPowerLevel := FPowerLevel;

   MaxShieldCalculate;
   FCurrentShield := FMaxShield;

   FPowerLevelName := MagicClass.GetPowerLevelName (FPowerLevel);
   FSendClass.SendShowPowerLevel (FPowerLevelName, FCurPowerLevel);

   WalkingCount := 0;
   FpCurAttackMagic     := nil;
   FpCurBreathngMagic   := nil;
   FpCurRunningMagic    := nil;
   FpCurProtectingMagic := nil;
   FpCurEctMagic        := nil;
   FCurrentGrade := aCharData^.CurrentGrade;   

   SetLifeData;
end;
```

### Kind（类型）

```
MAGIC_KIND_NONE      = 0;               // 无
MAGIC_KIND_KYUNGSIN  = 1;               // (凌波微步)
MAGIC_KIND_SAPA1     = 2;               // (血天魔功)
MAGIC_KIND_SAPA2     = 3;               // (日月神功)
MAGIC_KIND_JUNGPA1   = 4;               // (紫霞神功)
MAGIC_KIND_JUNGPA2   = 5;               // (北冥神功)

激活段（magic.sdb）
RelationProtect、SameSection

对应派系（同种）：RelationProtect=增加武功属性
相同派系（同类）：SameSection=无附加属性
异类派系：没有填写=降低武功属性
```

### MagicType

0=拳 1=剑 2=刀 3=槌 4=枪 5=弓 6=投 7=步 8=心 9=护 10=辅助 11=百鬼夜行术 12=NPC武功 13=掌风 14=招式

213=掌法

314=招式

（0=1层拳 100=2层拳 300=3层拳）

```
// 类型
MAGICTYPE_WRESTLING  = 0;              // 拳法
MAGICTYPE_FENCING    = 1;              // 剑法
MAGICTYPE_SWORDSHIP  = 2;              // 刀法
MAGICTYPE_HAMMERING  = 3;              // 槌法
MAGICTYPE_SPEARING   = 4;              // 枪法
MAGICTYPE_BOWING     = 5;              // 弓术
MAGICTYPE_THROWING   = 6;              // 投掷
MAGICTYPE_RUNNING    = 7;              // 步法
MAGICTYPE_BREATHNG   = 8;              // 心法
MAGICTYPE_PROTECTING = 9;              // 护体
MAGICTYPE_ECT        = 10;             // 辅助(灵动八方等)
MAGICTYPE_ONLYBOWING = 11;             // 仅弓术
MAGICTYPE_SPECIAL    = 12;             // 特殊技能(NPC)
MAGICTYPE_WINDOFHAND = 13;             // 掌风
MAGICTYPE_BESTSPECIAL = 14;            // 招式

MAGIC_BOOK_ICON      = 53;

```

普通武功和上层武功的对应关系是由`RelationMagic`确定，同一个数值的是上下层对应关系，可以多对1，比如心法，理论上也可以1对多（没测试）。

### Function

需在`MagicParam.SDB`中配置

```
MAGICSPECIAL_HIDE = 0;                // 隐身术
MAGICSPECIAL_SAME = 1;                // 分身术
MAGICSPECIAL_HEAL = 2;                // 再生术
MAGICSPECIAL_SWAP = 3;                // 变身术
MAGICSPECIAL_EAT  = 4;                // 吞噬(医病术)
MAGICSPECIAL_KILL = 5;                // 杀戮(千斤锥)
MAGICSPECIAL_PICK = 6;                // 采摘(搜集术)
MAGICSPECIAL_BLOOD = 7;               // 流血(吸血术)
MAGICSPECIAL_CALL = 8;                // 召唤术
MAGICSPECIAL_DEADBLOW = 9;            // 致命打击(必杀技)
MAGICSPECIAL_SHOW = 10;               // 透视
MAGICSPECIAL_LAST = 11;               // ???
```

# callfunc

武功相关的函数有有以下

函数|说明
-|-
getsendermagicskilllevel|获取玩家指定武功的等级，参数为武功名称
getsenderuseprotectmagic|获取玩家当前使用的护体名称，无参数
getsenderuseattackmagic|获取玩家当前使用的武功名称，无参数
getsenderuseattackskilllevel|获取玩家当前使用的武功等级，无参数
checkusemagicbygrade|判断玩家是否使用某级别的神功或绝世武功，参数为aType,aGrade,aMagicType，具体见下代码
checksendercurusemagic|判断玩家使用的武功类型，参数0~6，具体见以下代码或比武老人的代码

```pascal
function TUser.SCheckCurUseMagic (aType : Byte) : String;
begin
   Result := 'false';

   case aType of
      0 : begin           // 문파무공을 사용하는지 门派武功
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rGuildMagictype <> 1 then exit;
      end;
      1 : begin           // 장풍을 사용하는지 掌法
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rMagicClass <> MAGICCLASS_MYSTERY then exit;
      end;
      2 : begin           // 보조무공을 사용하는지 辅助武功
         if HaveMagicClass.pCurEctMagic = nil then exit;
         if HaveMagicClass.pCurEctMagic^.rMagicType <> MAGICTYPE_ECT then exit;
      end;
      3 : begin           // 상승공격무공을 사용하는지 上层武功
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rMagicClass <> MAGICCLASS_RISEMAGIC then exit;
      end;
      4 : begin           // 상승강신을 사용하는지 上层护体
         if HaveMagicClass.pCurProtectingMagic = nil then exit;
         if HaveMagicClass.pCurProtectingMagic^.rMagicClass <> MAGICCLASS_RISEMAGIC then exit;
      end;
      5 : begin           // 4대신공을사용하는지 四大神功
         if HaveMagicClass.pCurProtectingMagic = nil then exit;
         if HaveMagicClass.pCurProtectingMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
      end;
      6 : begin           // 절세무공을사용하는지 绝世武功
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
      5 : begin           // 4대신공을 사용하는지 四大神功
         if HaveMagicClass.pCurProtectingMagic = nil then exit;
         if HaveMagicClass.pCurProtectingMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
         if HaveMagicClass.pCurProtectingMagic^.rGrade <> aGrade then exit;
         if HaveMagicClass.pCurProtectingMagic^.rcSkillLevel <> 9999 then exit;
      end;
      6 : begin           // 절세무공을 사용하는지 绝世武功
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
         if HaveMagicClass.pCurAttackMagic^.rGrade <> aGrade then exit;
         if HaveMagicClass.pCurAttackMagic^.rcSkillLevel <> 9999 then exit;
         if (aMagicType <> -1) and (HaveMagicClass.pCurAttackMagic^.rMagicType <> aMagictype) then exit;
      end;
   end;

   Result := 'true';
end;

```