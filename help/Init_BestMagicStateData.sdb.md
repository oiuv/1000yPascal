# BestMagicStateData.sdb

绝世武功状态数据。定义各绝世武功的额外攻防属性加成，用于在武功状态激活时叠加到角色属性上。

## 文件路径
`bin/Init/BestMagicStateData.sdb`

## 格式
CSV格式，第一行为列名。以武功名称为索引。

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| （索引名） | 字符串 | 武功名称（如日月神功、寒阴指等） |
| DamageBody | 整数 | 身体攻击力加成 |
| DamageHead | 整数 | 头部攻击力加成 |
| DamageArm | 整数 | 手臂攻击力加成 |
| DamageLeg | 整数 | 腿部攻击力加成 |
| DamageEnergy | 整数 | 元气攻击力加成 |
| ArmorBody | 整数 | 身体防御力加成 |
| ArmorHead | 整数 | 头部防御力加成 |
| ArmorArm | 整数 | 手臂防御力加成 |
| ArmorLeg | 整数 | 腿部防御力加成 |
| ArmorEnergy | 整数 | 元气防御力加成 |
| Desc | 字符串 | 描述 |

## 数据示例
```
Name,DamageBody,DamageHead,DamageArm,DamageLeg,DamageEnergy,ArmorBody,ArmorHead,ArmorArm,ArmorLeg,ArmorEnergy,Desc
日月神功,,,,,,45,150,150,150,900,
北冥神功,,,,,,45,150,150,150,1050,
紫霞神功,,,,,,45,150,150,150,1250,
血天魔功,,,,,,45,150,150,150,1400,
寒阴指,88,200,200,200,940,,,,,,
金刚指,116,200,200,200,940,,,,,,
```

## 相关源码
```pascal
// svClass.pas - TMagicCycleClass.ReLoadFromFile
if FileExists ('.\Init\BestMagicStateData.sdb') then begin
   MagicStateDB := TUserStringDB.Create;
   MagicStateDB.LoadFromFile('.\Init\BestMagicStateData.sdb');
   for i := 0 to MagicStateDB.Count - 1 do begin
      mname := MagicStateDB.GetIndexName(i);
      new (psd);
      FillChar (psd^, sizeof(TStateData),0);
      psd^.ArmorBody := MagicStateDB.GetFieldValueInteger (mname,'ArmorBody');
      psd^.armorHead := MagicStateDB.GetFieldValueInteger (mname,'ArmorHead');
      psd^.armorArm := MagicStateDB.GetFieldValueInteger (mname,'ArmorArm');
      psd^.armorLeg := MagicStateDB.GetFieldValueInteger (mname,'ArmorLeg');
      psd^.armorenergy := MagicStateDB.GetFieldValueInteger (mname,'ArmorEnergy');
      psd^.damageBody := MagicStateDB.GetFieldValueInteger (mname,'DamageBody');
      psd^.DamageHead := MagicStateDB.GetFieldValueInteger (mname,'DamageHead');
      psd^.DamageArm := MagicStateDB.GetFieldValueInteger (mname,'DamageArm');
      psd^.DamageLeg := MagicStateDB.GetFieldValueInteger (mname,'DamageLeg');
      psd^.damageenergy := MagicStateDB.GetFieldValueInteger (mname,'DamageEnergy');
      StateDataList.Add(psd);
      StateKeyClass.Insert(mname, psd);
   end;
   MagicStateDB.Free;
end;
```

加载逻辑：以武功名称为键存入 `StateKeyClass` 哈希表。通过 `GetStateDataofBestMagic` 方法在武功状态激活时查询并叠加属性。部分武功侧重攻击（如寒阴指有攻击力但无防御力），部分侧重防御（如日月神功只有防御力）。
