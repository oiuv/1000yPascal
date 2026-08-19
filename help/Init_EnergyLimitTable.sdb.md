# EnergyLimitTable.sdb

元气等级限制表。定义各武功境界（PowerLevel）对应的元气上限值。

> **注意**：源码中该文件的加载代码已被注释掉（`{ ... }`），当前未实际使用。

## 文件路径
`bin/Init/EnergyLimitTable.SDB`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| PowerLevel | 整数 | 武功境界等级（0~8） |
| LimitEnergy | 整数 | 该境界的元气上限值 |
| Desc | 字符串 | 境界名称描述 |

## 数据示例
```
PowerLevel,LimitEnergy,Desc,
0,7999,出入境,
1,11999,造化境,
2,17999,玄妙境,
3,25999,生死境,
4,35999,解脱境,
5,47999,无为境,
6,61999,神话境,
7,77999,无上武念,
8,95999,天人合一,
```

## 相关源码
```pascal
// svClass.pas - TMagicClass.ReLoadFromFile（已注释）
{
if FileExists ('.\Init\EnergyLimitTable.SDB') then begin
   TempDB := TUserStringDB.Create;
   TempDB.LoadFromFile ('.\Init\EnergyLimitTable.SDB');
   FillChar (EnergyLimitArr, SizeOf (EnergyLimitArr), 0);
   for idx := 0 to TempDB.Count - 1 do begin
      iName := TempDB.GetIndexName (idx);
      sn := _StrToInt (iName);
      if (sn < 0) or (sn >= 20) then continue;
      EnergyLimitArr[sn] := TempDB.GetFieldValueInteger (iName, 'PowerLevel');
      EnergyLimitArr[sn] := TempDB.GetFieldValueInteger (iName, 'LimitEnergy');
   end;
   TempDB.Free;
end;
}
```

加载逻辑：该代码段已被注释，当前不生效。原始设计是按境界等级将元气上限值存入 `EnergyLimitArr` 数组。元气上限随境界递增，从出入境的 7999 到天人合一的 95999。
