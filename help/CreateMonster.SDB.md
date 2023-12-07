# CreateMonster%d.SDB

## 相关代码

```pascal
procedure LoadCreateMonster (aFileName: string; List : TList);
var
   i : integer;
   iname : string;
   pd : PTCreateMonsterData;
   CreateMonster : TUserStringDb;
begin
   if not FileExists (aFileName) then exit;

   for i := 0 to List.Count -1 do dispose (List[i]);   // 종료를 잘못함...
   List.Clear;

   CreateMonster := TUserStringDb.Create;
   CreateMonster.LoadFromFile (aFileName);

   for i := 0 to CreateMonster.Count -1 do begin
      iname := CreateMonster.GetIndexName (i);
      new (pd);
      FillChar (pd^, sizeof(TCreateMonsterData), 0);

      pd^.index := i;
      pd^.mName := CreateMonster.GetFieldValueString (iname, 'MonsterName');
      pd^.CurCount := 0;
      pd^.Count := CreateMonster.GetFieldValueInteger (iname, 'Count');
      pd^.x := CreateMonster.GetFieldValueInteger (iname, 'X');
      pd^.y := CreateMonster.GetFieldValueInteger (iname, 'Y');
      pd^.width := CreateMonster.GetFieldValueInteger (iname, 'Width');
      pd^.Member := CreateMonster.GetFieldValueString (iName, 'Member');
      pd^.Script := CreateMonster.GetFieldValueInteger (iName, 'Script');
      List.Add (pd);
   end;
   CreateMonster.Free;
end;
```

## 数据结构

字段|类型|说明|示例
---|---|---|---
Name|int|索引|1
MonsterName|string|怪物名称，对应Monster.sdb文件Name|猫
Count|int|数量|10
X|int|X坐标|10
Y|int|Y坐标|10
Width|int|生成范围|10
Member|string|成员|迷宫隐忍者:1:迷宫桂林忍者:1
Script|int|脚本，对应Script\Script.sdb文件Name|1