# AddDamage.sdb

附加攻击数据。根据武功等级区间（StartSkill ~ EndSkill），为角色各部位增加额外攻击值。

## 文件路径
`bin/Init/AddDamage.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 索引名（序号标识） |
| StartSkill | 整数 | 武功等级区间起始值 |
| EndSkill | 整数 | 武功等级区间结束值 |
| DamageBody | 整数 | 附加身体攻击力 |
| DamageHead | 整数 | 附加头部攻击力 |
| DamageArm | 整数 | 附加手臂攻击力 |
| DamageLeg | 整数 | 附加腿部攻击力 |

## 数据示例
```
Name,StartSkill,EndSkill,DamageBody,DamageHead,DamageArm,DamageLeg
1,0,999,0,0,0,0
2,1000,1999,0,0,0,0
3,2000,2999,0,0,0,0
4,3000,3999,0,0,0,0
5,4000,4999,0,0,0,0
6,5000,5999,2,0,0,0
7,6000,6999,6,0,0,0
8,7000,7999,10,0,0,0
9,8000,8999,15,0,0,0
```

## 相关源码
```pascal
// svClass.pas - TMagicClass.ReLoadFromFile
if FileExists ('.\Init\AddDamage.SDB') then begin
   Clear;
   TempDb := TUserStringDb.Create;
   TempDb.LoadFromFile ('.\Init\AddDamage.SDB');
   for idx := 0 to TempDb.Count - 1 do begin
      iname := TempDb.GetIndexName (idx);
      sn := TempDb.GetFieldValueInteger (iname,'StartSkill');
      en := TempDb.GetFieldValueInteger (iname,'EndSkill');
      if sn <= 0 then sn := 0;
      if en >= 10000 then en := 10000;
      for i := sn to en do begin
         SkillAddDamageArr[i].rdamagebody := TempDb.GetFieldValueInteger (iname,'DamageBody');
         SkillAddDamageArr[i].rdamagehead := TempDb.GetFieldValueInteger (iname,'DamageHead');
         SkillAddDamageArr[i].rdamagearm := TempDb.GetFieldValueInteger (iname,'DamageArm');
         SkillAddDamageArr[i].rdamageleg := TempDb.GetFieldValueInteger (iname,'DamageLeg');
      end;
   end;
   TempDb.Free;
end;
```

加载逻辑：按武功等级区间遍历，将每个等级对应的各部位附加攻击力填入 `SkillAddDamageArr` 数组。等级范围外的值被限制在 0~10000 之间。
