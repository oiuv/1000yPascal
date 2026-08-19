# ConsumeEnergy.sdb

元气消耗表。根据武功等级区间定义元气消耗百分比，武功等级越高消耗的元气比例越大。

## 文件路径
`bin/Init/ConsumeEnergy.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 索引名（序号标识） |
| StartSkill | 整数 | 武功等级区间起始值 |
| EndSkill | 整数 | 武功等级区间结束值 |
| ConsumePercent | 整数 | 元气消耗百分比 |

## 数据示例
```
Name,StartSkill,EndSkill,ConsumePercent
1,0,9999,0
2,10000,19999,10
3,20000,29999,20
4,30000,39999,30
5,40000,49999,40
6,50000,59999,50
7,60000,69999,60
8,70000,79999,70
9,80000,89999,80
```

## 相关源码
```pascal
// svClass.pas - TMagicClass.ReLoadFromFile
if FileExists ('.\Init\ConsumeEnergy.SDB') then begin
   TempDB := TUserStringDB.Create;
   TempDB.LoadFromFile ('.\Init\ConsumeEnergy.SDB');
   for idx := 0 to TempDb.Count -1 do begin
      iname := TempDb.GetIndexName (idx);
      sn := TempDb.GetFieldValueInteger (iname,'StartSkill');
      en := TempDb.GetFieldValueInteger (iname,'EndSkill');
      if sn <= 0 then sn := 0;
      if en >= 999999 then en := 999999;
      SkillConsumeEnergyArr[idx].rStartSkill    := sn;
      SkillConsumeEnergyArr[idx].rEndSkill      := en;
      SkillConsumeEnergyArr[idx].rCosumeValue   := TempDb.GetFieldValueInteger (iname, 'ConsumePercent');
   end;
   TempDb.Free;
end;
```

加载逻辑：将每个等级区间的元气消耗百分比存入 `SkillConsumeEnergyArr` 数组。通过 `TMagicClass.GetSkillConsumeEnergy` 方法查询指定武功等级对应的元气消耗百分比。等级越高，消耗比例越大（0%~80%）。
