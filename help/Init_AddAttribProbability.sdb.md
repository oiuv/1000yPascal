# AddAttribProbability.sdb

附加属性概率数据。定义不同品级下各属性品质（最低/较低/普通/较高/最高）出现的概率权重，用于附加属性系统的随机属性生成。

## 文件路径
`bin/Init/AddAttribProbability.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 索引名（品级编号） |
| Lowest | 整数 | 最低品质属性出现概率权重 |
| Lower | 整数 | 较低品质属性出现概率权重 |
| Normal | 整数 | 普通品质属性出现概率权重 |
| Higher | 整数 | 较高品质属性出现概率权重 |
| Highest | 整数 | 最高品质属性出现概率权重 |

## 数据示例
```
Name,Lowest,Lower,Normal,Higher,Highest
1,60,20,10,5,1
2,50,30,10,5,1
3,40,40,10,5,1
4,30,50,10,5,1
5,10,60,20,10,5
6,10,50,30,10,5
7,10,40,40,10,5
8,10,30,50,10,5
9,5,10,60,20,10
```

## 相关源码
```pascal
// svClass.pas - TAddAttribClass.LoadFromFile
if FileExists ('.\Init\AddAttribProbability.SDB') then begin
   DB := TUserStringDB.Create;
   DB.LoadFromFile ('.\Init\AddAttribProbability.SDB');
   for i := 0 to Db.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;
      New (pp);
      FillChar (pp^, sizeof (TProbabilityData), 0);
      pp^.rLowestValue := DB.GetFieldValueInteger (iName, 'Lowest');
      pp^.rLowerValue := DB.GetFieldValueInteger (iName, 'Lower');
      pp^.rNormalValue := DB.GetFieldValueInteger (iName, 'Normal');
      pp^.rHigherValue := DB.GetFieldValueInteger (iName, 'Higher');
      pp^.rHighestValue := DB.GetFieldValueInteger (iName, 'Highest');
      FDataList.Add (pp);
   end;
   DB.Free;
end;

// 加载后计算累积概率表
for i := 1 to FDataList.Count - 1 do begin
   pp := FDataList.Items[i];
   pBefore := FDataList.Items[i-1];
   pp^.rLowestValue := pp^.rLowestValue + pBefore^.rLowestValue;
   pp^.rLowerValue := pp^.rLowerValue + pBefore^.rLowerValue;
   pp^.rNormalValue := pp^.rNormalValue + pBefore^.rNormalValue;
   pp^.rHigherValue := pp^.rHigherValue + pBefore^.rHigherValue;
   pp^.rHighestValue := pp^.rHighestValue + pBefore^.rHighestValue;
end;
```

加载逻辑：读取各品级的概率权重后，会计算累积概率表（前缀和），用于 `GetAddTypeNum` 方法中根据随机值确定属性品质等级。品质常量对应：`ITEM_ATTRIBUTE_LOWEST`、`ITEM_ATTRIBUTE_LOWEER`、`ITEM_ATTRIBUTE_NORMAL`、`ITEM_ATTRIBUTE_HIGHER`、`ITEM_ATTRIBUTE_HIGHEST`。
