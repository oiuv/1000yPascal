# AddPalmDamage.sdb

掌法攻击数据。根据武功等级区间（StartSkill ~ EndSkill），为角色各部位增加额外掌法攻击值，并附加远程闪避值。

## 文件路径
`bin/Init/AddPalmDamage.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 索引名（序号标识） |
| StartSkill | 整数 | 武功等级区间起始值 |
| EndSkill | 整数 | 武功等级区间结束值 |
| DamageBody | 整数 | 附加身体掌法攻击力 |
| DamageHead | 整数 | 附加头部掌法攻击力 |
| DamageArm | 整数 | 附加手臂掌法攻击力 |
| DamageLeg | 整数 | 附加腿部掌法攻击力 |
| LongAvoid | 整数 | 远程闪避附加值 |

## 数据示例
```
Name,StartSkill,EndSkill,DamageBody,DamageHead,DamageArm,DamageLeg,LongAvoid
1,0,999,0,0,0,0,
2,1000,1999,2,0,0,0,11
3,2000,2999,6,0,0,0,29
4,3000,3999,12,0,0,0,47
5,4000,4999,20,0,0,0,64
6,5000,5999,30,0,0,0,82
7,6000,6999,42,0,0,0,89
8,7000,7999,56,0,0,0,96
9,8000,8999,72,0,0,0,103
```

## 相关源码
```pascal
// svClass.pas - TMagicClass.ReLoadFromFile
if FileExists ('.\Init\AddPalmDamage.SDB') then begin
   TempDB := TUserStringDB.Create;
   TempDB.LoadFromFile ('.\Init\AddPalmDamage.SDB');
   for idx := 0 to TempDb.Count -1 do begin
      iname := TempDb.GetIndexName (idx);
      sn := TempDb.GetFieldValueInteger (iname,'StartSkill');
      en := TempDb.GetFieldValueInteger (iname,'EndSkill');
      if sn <= 0 then sn := 0;
      if en >= 10000 then en := 10000;
      for i := sn to en do begin
         SkillAddPalmDamageArr[i].rdamagebody   := TempDb.GetFieldValueInteger (iname, 'DamageBody');
         SkillAddPalmDamageArr[i].rdamagehead   := TempDb.GetFieldValueInteger (iname, 'DamageHead');
         SkillAddPalmDamageArr[i].rdamagearm    := TempDb.GetFieldValueInteger (iname, 'DamageArm');
         SkillAddPalmDamageArr[i].rdamageleg    := TempDb.GetFieldValueInteger (iname, 'DamageLeg');
         SkillAddPalmDamageArr[i].rlongavoid    := TempDb.GetFieldValueInteger (iname, 'LongAvoid');
      end;
   end;
   TempDb.Free;
end;
```

加载逻辑：与 AddDamage.sdb 类似，按武功等级区间遍历，将掌法攻击力和远程闪避值填入 `SkillAddPalmDamageArr` 数组。比 AddDamage 多一个 `LongAvoid`（远程闪避）字段。
