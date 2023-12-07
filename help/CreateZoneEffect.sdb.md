# CreateZoneEffect.SDB

在游戏中创建陷阱区，`print ('sendzoneeffectmsg 陷阱名称')`触发对在区域内的玩家造成伤害。

字段 | 类型 | 描述 | 示例
-|-|-|-
Name|String|陷阱名称|陷阱区1
MapID|Integer|所在地图编号|31
X|Integer|陷阱X坐标|
Y|Integer|陷阱Y坐标|
Width|Integer|陷阱大小|5
Kind|Integer|BTEFFECT_KIND_DECLIFE|1
Value|Integer|伤害值（百分比）|25

```pascal
procedure TZoneEffectObject.SendFMMessage;
var
   SubData: TSubData;
begin
   if SelfData.Kind = BTEFFECT_KIND_DECLIFE then
   begin
      SubData.SpellType := BTEFFECT_KIND_DECLIFE; // type
      SubData.ShoutColor := SelfData.Width; // 반경셀
      SubData.SpellDamage := SelfData.Value; // 활력 깎이는양

      Phone.SendMessage(NOTARGETPHONE, FM_ZONEEFFECT, BasicData, SubData);
   end;
end;
```