# BestMagic2Cycle.sdb

绝世武功第二循环（2Cycle）数据。定义武功在第二重境界时各属性的覆盖值。文件结构与 BestMagic1Cycle.sdb 完全相同。

## 文件路径
`bin/Init/BestMagic2Cycle.sdb`

## 格式
CSV格式，第一行为列名。以武功名称为索引。

## 字段说明
与 BestMagic1Cycle.sdb 完全一致，参见 [Init_BestMagic1Cycle.sdb.md](Init_BestMagic1Cycle.sdb.md)。

## 数据示例
```
Name,EnergyPoint,MoveSpeed,AttackSpeed,Recovery,KeepRecovery,Avoid,Accuracy,DamageBody,DamageHead,DamageArm,DamageLeg,DamageEnergy,ArmorBody,ArmorHead,ArmorArm,ArmorLeg,ArmorEnergy,NeedMinEnergy,SuccessRate,PassDamagePer,GetDamagePer,ShotDelay,UseableDelay,LockDown,3Attrib,LifeSteal,AddDamageEnergy,EnergySteal,1Life,Desc,SEffectNumber,SEffectNumber2,CEffectNumber,EEffectNumber,SoundStart,SoundEnd,SoundStrike,SoundSwing,SoundEvent,
日月神功,1300,,,,,,,,,,,,144,160,160,160,16,6000,,,,,,,,,,,,2Cycle,,,,,14000,14001,,,,
寒阴指,1285,,110,112,124,11,19,19,132,136,140,172,88,78,58,62,,16000,,,,,,,,,,,,,,,,,,,14100,14101,,
```

## 相关源码
与 BestMagic1Cycle.sdb 共用同一加载逻辑，参见 [Init_BestMagic1Cycle.sdb.md](Init_BestMagic1Cycle.sdb.md)。

加载时 `i=1`，对应 `BestMagic2Cycle.sdb`，存入 `DataLists[1]` 和 `Cycles[1]`。各字段数值以当前部署表为准；加载器不根据循环编号自动增减属性。
