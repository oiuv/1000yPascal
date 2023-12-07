# CreateNpc%d.SDB

## 相关代码

```pascal
procedure LoadCreateNpc (aFileName: string; List : TList);
var
   i : integer;
   iname : string;
   pd : PTCreateNpcData;
   CreateNpc : TUserStringDb;
begin
   if not FileExists (aFileName) then exit;
   
   for i := 0 to List.Count -1 do dispose (List[i]); // 종료를 잘못함...
   List.Clear;

   CreateNpc := TUserStringDb.Create;
   CreateNpc.LoadFromFile (aFileName);

   for i := 0 to CreateNpc.Count -1 do begin
      iname := CreateNpc.GetIndexName (i);
      new (pd);
      FillChar (pd^, sizeof(TCreateNpcData), 0);

      pd^.index := i;
      pd^.mName := CreateNpc.GetFieldValueString (iname, 'NpcName');
      pd^.CurCount := 0;
      pd^.Count := CreateNpc.GetFieldValueInteger (iname, 'Count');
      pd^.x := CreateNpc.GetFieldValueInteger (iname, 'X');
      pd^.y := CreateNpc.GetFieldValueInteger (iname, 'Y');
      pd^.width := CreateNpc.GetFieldValueInteger (iname, 'Width');
      pd^.Notice := CreateNpc.GetFieldValueInteger (iName, 'Notice');
      pd^.BookName := CreateNpc.GetFieldValueString (iname, 'BookName');      
      List.Add (pd);
   end;
   CreateNpc.Free;
end;
```

## 数据结构

字段|类型|说明|示例
---|---|---|---
Name|int|npc序号|1
NpcName|string|npc名字，对应Npc.sdb文件Name|老板娘
Notice|int|NPC脚本，对应Script\Script.sdb中的序号|1
X|int|npc坐标X|10
Y|int|npc坐标Y|10
Count|int|npc数量|1
Width|int|npc生成范围|1
BookName|string|NPC自动对话内容，对应NpcSetting文件夹sdb文件|千年老板娘.sdb