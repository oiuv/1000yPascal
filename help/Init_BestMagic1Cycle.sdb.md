# BestMagic1Cycle.sdb

绝世武功第一循环（1Cycle）数据。定义武功在第一重境界时各属性的覆盖值，包括生命数据、攻防属性、元气消耗、音效特效等。

## 文件路径
`bin/Init/BestMagic1Cycle.sdb`

## 格式
CSV格式，第一行为列名。以武功名称为索引（第一列无列名标题，作为行索引名）。

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| （索引名） | 字符串 | 武功名称（如日月神功、寒阴指等） |
| EnergyPoint | 整数 | 元气点数 |
| MoveSpeed | 整数 | 移动速度附加值 |
| AttackSpeed | 整数 | 攻击速度 |
| Recovery | 整数 | 恢复速度 |
| KeepRecovery | 整数 | 持续恢复速度 |
| Avoid | 整数 | 闪避值 |
| Accuracy | 整数 | 命中值 |
| DamageBody | 整数 | 身体攻击力 |
| DamageHead | 整数 | 头部攻击力 |
| DamageArm | 整数 | 手臂攻击力 |
| DamageLeg | 整数 | 腿部攻击力 |
| DamageEnergy | 整数 | 元气攻击力 |
| ArmorBody | 整数 | 身体防御力 |
| ArmorHead | 整数 | 头部防御力 |
| ArmorArm | 整数 | 手臂防御力 |
| ArmorLeg | 整数 | 腿部防御力 |
| ArmorEnergy | 整数 | 元气防御力 |
| NeedMinEnergy | 整数 | 最低需要元气值 |
| SuccessRate | 整数 | 成功率 |
| PassDamagePer | 整数 | 穿透伤害百分比 |
| GetDamagePer | 整数 | 受到伤害百分比 |
| ShotDelay | 整数 | 发射延迟 |
| UseableDelay | 整数 | 可用延迟 |
| LockDown | 整数 | 锁定值 |
| 3Attrib | 整数 | 三属性附加值 |
| LifeSteal | 整数 | 吸血值 |
| AddDamageEnergy | 整数 | 附加元气攻击值 |
| EnergySteal | 整数 | 吸元气值 |
| 1Life | 整数 | 每秒扣血值 |
| Desc | 字符串 | 描述（如 "1Cycle"） |
| SEffectNumber | 整数 | 开始特效编号 |
| SEffectNumber2 | 整数 | 开始特效编号2 |
| CEffectNumber | 整数 | 持续特效编号 |
| EEffectNumber | 整数 | 结束特效编号 |
| SoundStart | 字符串 | 开始音效 |
| SoundEnd | 字符串 | 结束音效 |
| SoundStrike | 字符串 | 打击音效 |
| SoundSwing | 字符串 | 挥动音效 |
| SoundEvent | 字符串 | 事件音效 |

## 数据示例
```
Name,EnergyPoint,MoveSpeed,AttackSpeed,Recovery,KeepRecovery,Avoid,Accuracy,DamageBody,DamageHead,DamageArm,DamageLeg,DamageEnergy,ArmorBody,ArmorHead,ArmorArm,ArmorLeg,ArmorEnergy,NeedMinEnergy,SuccessRate,PassDamagePer,GetDamagePer,ShotDelay,UseableDelay,LockDown,3Attrib,LifeSteal,AddDamageEnergy,EnergySteal,1Life,Desc,SEffectNumber,SEffectNumber2,CEffectNumber,EEffectNumber,SoundStart,SoundEnd,SoundStrike,SoundSwing,SoundEvent,
日月神功,1000,,,,,,,,,,,,140,145,145,145,12,8000,,,,,,,,,,,,1Cycle,,,,,14000,14001,,,,
寒阴指,1073,,106,108,118,8,18,18,112,116,120,122,88,72,52,56,,18000,,,,,,,,,,,,,,,,,,,14100,14101,,
```

## 相关源码
```pascal
// svClass.pas - TMagicCycleClass.ReLoadFromFile
aFile := format ('.\Init\BestMagic%dCycle.sdb',[i + 1]);
if FileExists (aFile) then begin
   MagicCycleDB := TUserStringDB.Create;
   MagicCycleDB.LoadFromFile(aFile);
   for j := 0 to MagicCycleDB.Count - 1 do begin
      mname := MagicCycleDB.GetIndexName(j);
      New (pmd);
      FillChar (pmd^, sizeof(TBestMagicData), 0);
      pmd^.rLifeData.AttackSpeed := MagicCycleDB.GetFieldValueInteger (mname,'AttackSpeed');
      pmd^.rLifeData.recovery := MagicCycleDB.GetFieldValueInteger (mname,'Recovery');
      // ... 其他字段类似
      pmd^.rEnergyPoint := MagicCycleDB.GetFieldValueInteger (mname, 'EnergyPoint');
      pmd^.rSuccessRate := MagicCycleDB.GetFieldValueInteger (mname,'SuccessRate');
      // ... 音效特效等
      DataLists [i].Add (pmd);
      Cycles[i].Insert (mname, pmd);
   end;
   MagicCycleDB.Free;
end;
```

加载逻辑：BestMagic1/2/3Cycle.sdb 三个文件结构完全相同，由 `TMagicCycleClass.ReLoadFromFile` 统一加载，分别对应第1/2/3重境界。通过 `GetData(aMagicName, aGrade, aMagicData)` 方法按武功名和境界等级查询覆盖属性。
