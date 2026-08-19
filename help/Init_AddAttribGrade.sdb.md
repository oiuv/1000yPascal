# AddAttribGrade.sdb

附加属性品级数据。定义每个品级对应的最大范围和可附加属性条目数量，用于附加属性系统的品级判定。

## 文件路径
`bin/Init/AddAttribGrade.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 索引名（品级编号，从1开始） |
| MaxRange | 整数 | 该品级的最大范围值 |
| AttribItemCount | 整数 | 该品级可附加的属性条目数量 |

## 数据示例
```
Name,MaxRange,AttribItemCount
1,20,8
2,18,6
3,16,4
4,14,2
5,12,2
6,10,1
7,8,1
8,6,1
9,4,1
```

## 相关源码
```pascal
// svClass.pas - TAddAttribClass.LoadFromFile
if FileExists ('.\Init\AddAttribGrade.SDB') then begin
   DB := TUserStringDB.Create;
   DB.LoadFromFile ('.\Init\AddAttribGrade.SDB');
   for i := 1 to Db.Count do begin
      iName := DB.GetIndexName (i-1);
      if iName = '' then continue;
      GradeData[i].rMaxRange := DB.GetFieldValueInteger (iName, 'MaxRange');
      GradeData[i].rAttribItemCount := DB.GetFieldValueInteger (iName, 'AttribItemCount');
   end;
   DB.Free;
end;
```

加载逻辑：将每个品级的 `MaxRange` 和 `AttribItemCount` 存入 `GradeData` 数组。通过 `GetRange(iGrade)` 和 `GetNeedItemCount(iGrade)` 方法对外提供查询，品级有效范围为 1~10。
