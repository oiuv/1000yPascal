# BestMagic3Cycle.sdb

绝世武功第三循环（3Cycle）数据。定义武功在第三重境界时各属性的覆盖值。文件结构与 BestMagic1Cycle.sdb 完全相同。

## 文件路径
`bin/Init/BestMagic3Cycle.sdb`

## 格式
CSV格式，第一行为列名。以武功名称为索引。

## 字段说明
与 BestMagic1Cycle.sdb 完全一致，参见 [Init_BestMagic1Cycle.sdb.md](Init_BestMagic1Cycle.sdb.md)。

## 数据示例
```
Name,EnergyPoint,MoveSpeed,AttackSpeed,Recovery,KeepRecovery,Avoid,Accuracy,DamageBody,DamageHead,DamageArm,DamageLeg,DamageEnergy,ArmorBody,ArmorHead,ArmorArm,ArmorLeg,ArmorEnergy,NeedMinEnergy,SuccessRate,PassDamagePer,GetDamagePer,ShotDelay,UseableDelay,LockDown,3Attrib,LifeSteal,AddDamageEnergy,EnergySteal,1Life,Desc,SEffectNumber,SEffectNumber2,CEffectNumber,EEffectNumber,SoundStart,SoundEnd,SoundStrike,SoundSwing,SoundEvent,
日月神功,1700,,,,,,,,,,,,150,185,185,185,22,4000,,,,,,,,,,,,3Cycle,,,,,14002,14003,,,,
寒阴指,1932,,118,118,134,16,22,22,172,176,180,272,88,90,70,74,,12000,,,,,,,,,,,,,,,,,,,14120,14121,,
```

## 相关源码
与 BestMagic1Cycle.sdb 共用同一加载逻辑，参见 [Init_BestMagic1Cycle.sdb.md](Init_BestMagic1Cycle.sdb.md)。

加载时 `i=2`，对应 `BestMagic3Cycle.sdb`，存入 `DataLists[2]` 和 `Cycles[2]`。第三重境界的元气需求最低（如 4000），属性值最高，为最高境界。
