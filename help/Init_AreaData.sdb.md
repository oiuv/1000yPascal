# AreaData.sdb

区域数据。定义游戏中的区域信息，包括区域名称、描述、索引编号和功能标识。

## 文件路径
`bin/Init/AreaData.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 区域名称 |
| Desc | 字符串 | 区域描述 |
| Index | 整数 | 区域索引编号 |
| Func | 字符串 | 功能标识（如为数字则表示特殊功能启用） |

## 数据示例
```
Name,Desc,Index,Func,
树林,树林,0,,
地下采石场,地下采石场,1,,
关帝庙,关帝庙,2,,
高丽剑士宅,高丽剑士宅,3,,
平原,field,4,1,
竹林,竹林,5,,
狐狸洞,狐狸洞,6,,
佣兵仓库,佣兵仓库,7,,
石头山,石头山,8,,
```

## 相关源码
```pascal
// svClass.pas - TAreaClass.LoadFromFile
procedure TAreaClass.LoadFromFile (aFileName : String);
var
   i : Integer;
   iName : String;
   pd : PTAreaClassData;
   AreaDB : TUserStringDb;
begin
   Clear;
   if not FileExists (aFileName) then exit;
   AreaDB := TUserStringDb.Create;
   AreaDB.LoadFromFile (aFileName);
   for i := 0 to AreaDB.Count - 1 do begin
      iName := AreaDB.GetIndexName (i);
      if iName = '' then continue;
      New (pd);
      FillChar (pd^, sizeof(TAreaClassData), 0);
      pd^.Name := AreaDB.GetFieldValueString (iName, 'Name');
      pd^.Desc := AreaDB.GetFieldValueString (iName, 'Desc');
      pd^.Func := AreaDB.GetFieldValueString (iName, 'Func');
      pd^.Index := AreaDB.GetFieldValueInteger (iName, 'Index');
      DataList.Add (pd);
   end;
   AreaDB.Free;
end;
```

加载逻辑：在 `TAreaClass.Create` 构造函数中自动调用 `LoadFromFile`。每条记录存入 `TAreaClassData` 结构体并加入 `DataList`。`CanMakeGuild` 方法会根据 `Func` 字段判断该区域是否允许创建门派。
