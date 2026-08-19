# AddArmor.sdb

附加防御力数据。根据武功等级区间（StartSkill ~ EndSkill），为角色各部位增加额外防御值。

## 文件路径
`bin/Init/AddArmor.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 索引名（序号标识） |
| StartSkill | 整数 | 武功等级区间起始值 |
| EndSkill | 整数 | 武功等级区间结束值 |
| ArmorBody | 整数 | 附加身体防御力 |
| ArmorHead | 整数 | 附加头部防御力 |
| ArmorArm | 整数 | 附加手臂防御力 |
| ArmorLeg | 整数 | 附加腿部防御力 |

## 数据示例
```
Name,StartSkill,EndSkill,ArmorBody,ArmorHead,ArmorArm,ArmorLeg
1,0,999,0,0,0,0
2,1000,1999,0,0,0,0
3,2000,2999,0,0,0,0
4,3000,3999,0,0,0,0
5,4000,4999,0,0,0,0
6,5000,5999,5,5,5,5
7,6000,6999,5,5,5,5
8,7000,7999,6,6,6,6
9,8000,8999,8,8,8,8
```

## 相关源码
```pascal
// svClass.pas - TMagicClass.ReLoadFromFile
if FileExists ('.\Init\AddArmor.SDB') then begin
   // 2000.10.05 추가방어력 AddArmor.sdb 파일의 로드
   TempDb := TUserStringDb.Create;
   TempDb.LoadFromFile ('.\Init\AddArmor.SDB');
   for idx := 0 to TempDb.Count -1 do begin
      iname := TempDb.GetIndexName (idx);
      sn := TempDb.GetFieldValueInteger (iname,'StartSkill');
      en := TempDb.GetFieldValueInteger (iname,'EndSkill');
      if sn <= 0 then sn := 0;
      if en >= 10000 then en := 10000;
      for i := sn to en do begin
         SkillAddArmorArr[i].rarmorbody := TempDb.GetFieldValueInteger (iname,'ArmorBody');
         SkillAddArmorArr[i].rarmorhead := TempDb.GetFieldValueInteger (iname,'ArmorHead');
         SkillAddArmorArr[i].rarmorarm := TempDb.GetFieldValueInteger (iname,'ArmorArm');
         SkillAddArmorArr[i].rarmorleg := TempDb.GetFieldValueInteger (iname,'ArmorLeg');
      end;
   end;
   TempDb.Free;
end;
```

加载逻辑：按武功等级区间遍历，将每个等级对应的各部位附加防御力填入 `SkillAddArmorArr` 数组。等级范围外的值被限制在 0~10000 之间。
