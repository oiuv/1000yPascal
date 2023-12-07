# CreateDynamicObject%d.SDB

## 数据结构

字段|类型|说明|示例
---|---|---|---
No,
Name|String|名称|桂林箱子
Script|Integer|脚本编号|23
NeedAge|Integer|需要年龄X岁以上方可开启
NeedSkill|String|需要的武功和等级|伏式气功:5000
NeedItem|String|开启需要的物品，最多设置5种(会删除需要的物品)|
GiveItem|String|给玩家物品，最多设置5种|
DropItem|String|掉落物品|新罗宝剑:1:30:王陵瓷器:1:1
DropMop|String|召唤魔物|老鼠:1
CallNpc|String|召唤NPC|老侠客:1:玉仙:1
X|Integer|动态对象坐标
Y|Integer|动态对象坐标
DropX|Integer|魔物和NPC召唤在此X坐标，否则在X，Y附近|
DropY|Integer|魔物和NPC召唤在此Y坐标，否则在X，Y附近|
Width,
boDelay,

如果在动态物品的EventDropItem中设置了内容，必须设置DropItem指定几率，否则日志会报`Random Chance Not Found`

```pascal
procedure TDynamicObject.CommandAttackedMagic(var aWindOfHandData:
   TWindOfHandData);
var
   BO, BO2: TBasicObject;
   i, j: integer;
   xx, yy: Integer;
   Monster: TMonster;
   AttackSkill: TAttackSkill;
   Npc: TNpc;
   decLife: Integer;
   SubData: TSubData;
   Code: Integer;
   SkillLevel: Integer;
   ItemData: TItemData;
   boFlag: Boolean;
begin
   if ObjectStatus <> dos_Closed then
      exit;
   if (SelfData.rBasicData.rKind and DYNOBJ_EVENT_HIT) = DYNOBJ_EVENT_HIT then
   begin
      BO := GetViewObjectByID(aWindOfHandData.rAttacker);
      if BO = nil then
         exit;
      if BO.BasicData.Feature.rRace <> RACE_HUMAN then
         exit;

      if SelfData.rBasicData.rLife = CurLife then
      begin
         for i := 0 to 5 - 1 do
         begin
            if SelfData.rDropMop[i].rName[0] = 0 then
               continue;
            for j := 0 to SelfData.rDropMop[i].rCount - 1 do
            begin
               xx := BasicData.x;
               yy := BasicData.y;
               if (SelfData.rDropX <> 0) and (SelfData.rDropY <> 0) then
               begin
                  xx := SelfData.rDropX;
                  yy := SelfData.rDropY;
               end
               else
               begin
                  Maper.GetMoveableXY(xx, yy, 10);
               end;
               if Maper.isMoveable(xx, yy) then
               begin
                  Monster :=
                     TMonsterList(Manager.MonsterList).CallMonster(Strpas(@SelfData.rDropMop[i].rName), xx, yy, 4, StrPas(@Bo.BasicData.Name));
                  if Monster <> nil then
                  begin
                     AttackSkill := Monster.GetAttackSkill;
                     if AttackSkill <> nil then
                     begin
                        AttackSkill.SetObjectBoss(Self);
                     end;
                     if MemberList = nil then
                     begin
                        MemberList := TList.Create;
                     end;
                     MemberList.Add(Monster);
                  end;
               end;
            end;
         end;
         for i := 0 to 5 - 1 do
         begin
            if SelfData.rCallNpc[i].rName[0] = 0 then
               continue;
            for j := 0 to SelfData.rCallNpc[i].rCount - 1 do
            begin
               xx := BasicData.x;
               yy := BasicData.y;
               if (SelfData.rDropX <> 0) and (SelfData.rDropY <> 0) then
               begin
                  xx := SelfData.rDropX;
                  yy := SelfData.rDropY;
               end
               else
               begin
                  Maper.GetMoveableXY(xx, yy, 10);
               end;
               if Maper.isMoveable(xx, yy) then
               begin
                  Npc :=
                     TNpcList(Manager.NpcList).CallNpc(StrPas(@SelfData.rCallNpc[i].rName), xx, yy, 4, StrPas(@Bo.BasicData.Name));
                  if Npc <> nil then
                  begin
                     AttackSkill := Npc.GetAttackSkill;
                     if AttackSkill <> nil then
                     begin
                        AttackSkill.SetObjectBoss(Self);
                     end;
                     if MemberList = nil then
                     begin
                        MemberList := TList.Create;
                     end;
                     MemberList.Add(Npc);
                  end;
               end;
            end;
         end;
      end
      else
      begin
         if MemberList <> nil then
         begin
            for i := 0 to MemberList.Count - 1 do
            begin
               BO2 := MemberList[i];
               if BO2 <> nil then
               begin
                  if BO2.BasicData.Feature.rRace = RACE_NPC then
                  begin
                     AttackSkill := TNpc(BO2).GetAttackSkill;
                  end
                  else
                  begin
                     AttackSkill := TMonster(BO2).GetAttackSkill;
                  end;
                  AttackSkill.SetDeadAttackName(StrPas(@Bo.BasicData.Name));
               end;
            end;
         end;
      end;

      decLife := aWindOfHandData.rDamageBody - Armor;
      if decLife < 0 then
      begin
         decLife := 1;
      end;

      AddExpLink(aWindOfHandData.rAttacker, declife);
      // 제일 많이 때린사람 찾는거...
      CurLife := CurLife - decLife;
      FillChar(SubData.SayString, sizeof(TWordString), 0);
      Move(aWindOfHandData.rSayString, SubData.SayString, sizeof(TNameString));
      SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);

      if CurLife < 0 then
      begin
         CurLife := 0;
         if SOnDieBefore <> 0 then
         begin
            ScriptManager.CallEvent(Self, nil, SOnDieBefore, 'OnDieBefore',
               ['']);
         end;
      end;

      if CurLife > 0 then
      begin
         SubData.Percent := CurLife * 100 div SelfData.rBasicData.rLife;
         SendLocalMessage(NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end;

      if SelfData.rBasicData.rSoundSpecial.rWavNumber > 0 then
      begin
         SetWordString(SubData.SayString,
            IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) + '.wav');
         SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      end;

      if CurLife > 0 then
         exit;

      Code := EventClass.isDynObjDieEvent(StrPas(@BasicData.Name));
      if Code > 0 then
      begin
         EventClass.RunDynObjDieEvent(Code);
      end;

      if SelfData.rNeedAge <> 0 then
      begin
         if TUser(BO).GetAge < SelfData.rNeedAge then
         begin
            TUser(BO).SendClass.SendChatMessage(format(Conv('%d岁以上方可开启'), [SelfData.rNeedAge]), SAY_COLOR_SYSTEM);
            exit;
         end;
      end;
      for i := 0 to 5 - 1 do
      begin
         if SelfData.rNeedSkill[i].rName[0] = 0 then
            break;
         SkillLevel :=
            TUser(BO).FindHaveMagicByName(StrPas(@SelfData.rNeedSkill[i].rName));
         if SelfData.rNeedSkill[i].rLevel > SkillLevel then
         begin
            TUser(BO).SendClass.SendChatMessage(format(Conv('%s修练值 %s 以上的人方可开启'), [StrPas(@SelfData.rNeedSkill[i].rName),
               Get10000To100(SelfData.rNeedSkill[i].rLevel)]), SAY_COLOR_SYSTEM);
            exit;
         end;
      end;

      for i := 0 to 5 - 1 do
      begin
         if SelfData.rNeedItem[i].rName[0] = 0 then
            break;
         ItemClass.GetItemData(StrPas(@SelfData.rNeedItem[i].rName), ItemData);
         if ItemData.rName[0] <> 0 then
         begin
            ItemData.rCount := SelfData.rNeedItem[i].rCount;
            boFlag := TUser(BO).FindItem(@ItemData);
            if boFlag = false then
            begin
               TUser(BO).SendClass.SendChatMessage(format(Conv('%s 物品需要 %d个'), [StrPas(@ItemData.rName), ItemData.rCount]), SAY_COLOR_SYSTEM);
               exit;
            end;
         end;
      end;

      for i := 0 to 5 - 1 do
      begin
         if SelfData.rNeedItem[i].rName[0] = 0 then
            break;
         ItemClass.GetItemData(StrPas(@SelfData.rNeedItem[i].rName), ItemData);
         if ItemData.rName[0] <> 0 then
         begin
            ItemData.rCount := SelfData.rNeedItem[i].rCount;
            TUser(BO).DeleteItem(@ItemData);
         end;
      end;

      IncStep;

      OpenedPosX := Bo.BasicData.X;
      OpenedPosY := Bo.BasicData.Y;

      xx := BasicData.nx;
      yy := BasicData.ny;
      BasicData.nx := Bo.BasicData.x;
      BasicData.ny := Bo.BasicData.y;
      for i := 0 to 5 - 1 do
      begin
         if SelfData.rGiveItem[i].rName[0] = 0 then
            break;
         ItemClass.GetChanceItemData(StrPas(@BasicData.Name),
            StrPas(@SelfData.rGiveItem[i].rName), ItemData);
         ItemData.rCount := SelfData.rGiveItem[i].rCount;
         ItemData.rOwnerName[0] := 0;

         SubData.ItemData := ItemData;
         SubData.ServerId := ServerId;
         if TFieldPhone(Manager.Phone).SendMessage(Bo.BasicData.id,
            FM_ENOUGHSPACE, BasicData, SubData) = PROC_FALSE then
         begin
            Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
         end
         else
         begin
            TFieldPhone(Manager.Phone).SendMessage(Bo.BasicData.id, FM_ADDITEM,
               BasicData, SubData);
         end;
      end;
      BasicData.nx := xx;
      BasicData.ny := yy;
   end;
end;

```