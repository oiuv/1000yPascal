# AM&WHRelation.sdb

拳法与武器关系表（Attack Method & Weapon Hand Relation）。定义不同武功（拳法/心法）与6种武器类型之间的相性关系值。

## 文件路径
`bin/Init/AM&WHRelation.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 索引名（如 Armor1、Armor2 等，标识武功/心法类型） |
| WindOfHand1 | 整数 | 与武器类型1的相性值 |
| WindOfHand2 | 整数 | 与武器类型2的相性值 |
| WindOfHand3 | 整数 | 与武器类型3的相性值 |
| WindOfHand4 | 整数 | 与武器类型4的相性值 |
| WindOfHand5 | 整数 | 与武器类型5的相性值 |
| WindOfHand6 | 整数 | 与武器类型6的相性值 |
| Desc | 字符串 | 描述（武功/心法名称） |

## 数据示例
```
Name,WindOfHand1,WindOfHand2,WindOfHand3,WindOfHand4,WindOfHand5,WindOfHand6,Desc
Armor1,0,20,10,50,40,60,僵尸功
Armor2,10,0,20,40,60,50,气甲体
Armor3,20,10,0,60,50,40,金结
Armor4,30,30,30,30,30,30,不羁浪人心法
Armor5,40,50,60,0,10,20,黄土大力体
Armor6,50,60,40,20,0,10,回转圆型障
Armor7,60,40,50,10,20,0,不灭体
```

## 相关源码
```pascal
// svClass.pas - TMagicClass.ReLoadFromFile
if FileExists ('.\Init\AM&WHRelation.SDB') then begin
   TempDB := TUserStringDB.Create;
   TempDB.LoadFromFile ('.\Init\AM&WHRelation.SDB');
   for idx := 0 to TempDb.Count -1 do begin
      iname := TempDb.GetIndexName (idx);
      AM_WHRelationTable[idx][0] := TempDb.GetFieldValueInteger (iname,'WindOfHand1');
      AM_WHRelationTable[idx][1] := TempDb.GetFieldValueInteger (iname,'WindOfHand2');
      AM_WHRelationTable[idx][2] := TempDb.GetFieldValueInteger (iname,'WindOfHand3');
      AM_WHRelationTable[idx][3] := TempDb.GetFieldValueInteger (iname,'WindOfHand4');
      AM_WHRelationTable[idx][4] := TempDb.GetFieldValueInteger (iname,'WindOfHand5');
      AM_WHRelationTable[idx][5] := TempDb.GetFieldValueInteger (iname,'WindOfHand6');
   end;
   TempDb.Free;
end;
```

加载逻辑：将每种武功/心法与6种武器类型的相性值读入二维数组 `AM_WHRelationTable`。行索引为武功序号，列索引为武器类型（0~5）。值越大表示该武功与该武器类型的配合越好。
