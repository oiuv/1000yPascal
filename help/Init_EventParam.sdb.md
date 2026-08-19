# EventParam.sdb

事件参数数据。定义事件触发后的具体执行参数，包括名称参数和数值参数，与 Event.sdb 配合使用。当怪物或动态对象死亡时触发事件，通过 Code 字段关联到具体的事件参数。

## 文件路径
`bin/Init/EventParam.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Code | 整数 | 事件参数代码，与 Event.sdb 中的 ParamCode 关联 |
| NameParam1 | 字符串 | 名称参数1（如NPC/怪物名称） |
| NameParam2 | 字符串 | 名称参数2（如变身目标名称） |
| NameParam3 | 字符串 | 名称参数3（如对话内容/文件名） |
| NameParam4 | 字符串 | 名称参数4（待确认） |
| NameParam5 | 字符串 | 名称参数5（待确认） |
| NumberParam1 | 整数 | 数值参数1（如种族类型 Kind1） |
| NumberParam2 | 整数 | 数值参数2（如种族类型 Kind2） |
| NumberParam3 | 整数 | 数值参数3（待确认） |
| NumberParam4 | 整数 | 数值参数4（待确认） |
| NumberParam5 | 整数 | 数值参数5（待确认） |

## 数据示例
```
Code,NameParam1,NameParam2,NameParam3,NameParam4,NameParam5,NumberParam1,NumberParam2,NumberParam3,NumberParam4,NumberParam5
1,九尾狐酒母,九尾狐变身,是谁杀了我的妖华？,8950,,4,3,,,
2,九尾狐变身,九尾狐酒母,九尾狐酒母.sdb,,,3,4,23,,
```

## 相关源码
```pascal
// uEvent.pas - TEventClass.LoadFromFile
fName2 := '.\Init\EventParam.SDB';
// ...
DB := TUserStringDB.Create;
DB.LoadFromFile (fName2);
for i := 0 to DB.Count - 1 do begin
   iName := DB.GetIndexName (i);
   if iName = '' then continue;
   New (ppd);
   ppd^.Code := DB.GetFieldValueInteger (iName, 'Code');
   for j := 0 to 5 - 1 do begin
      ppd^.NameParam [j] := DB.GetFieldValueString (iName, 'NameParam' + InttoStr (j + 1));
   end;
   for j := 0 to 5 - 1 do begin
      ppd^.NumberParam [j] := DB.GetFieldValueInteger (iName, 'NumberParam' + IntToStr (j + 1));
   end;
   ParamList.Add (ppd);
end;
DB.Free;
```

加载逻辑：事件参数通过 `Code` 与 Event.sdb 关联。当动态对象或怪物死亡触发事件时（`RunDynObjDieEvent` / `RunMopDieEvent`），根据 Code 查找对应的参数记录。NameParam 用于指定名称类参数（NPC名、怪物名、对话内容等），NumberParam 用于指定数值类参数（种族类型等）。
