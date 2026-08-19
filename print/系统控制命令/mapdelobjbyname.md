# mapdelobjbyname

## 功能描述
删除地图中指定名称的对象（怪物或动态对象）。常用于清除由 `mapaddobjbyname` 动态生成的对象。

## 语法格式
```pascal
print('mapdelobjbyname <对象类型> <对象名称>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 对象类型 | String | 对象类型：`monster`（怪物）或 `dynamicobject`（动态对象） |
| 对象名称 | String | 要删除的对象名称 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
//-----------------------
end else if cmd = 'mapdelobjbyname' then begin
   TBasicObject (aSelf).SMapDelObjByName (Params [0], Params [1]);
```

直接调用 `SMapDelObjByName`，传入对象类型和名称。

## 使用示例

### 关闭机关后清除怪物
```pascal
// 来自 北霸王火炉.txt - 关闭时清除生成的怪物
procedure OnTurnOff (aStr : String);
var
   Str : String;
begin
   Str := callfunc ('checkobjectalive 굇베汽覩 monster 굇게珙산1');
   if Str = 'true' then begin
      print ('mapdelobjbyname monster 굇게珙산1');
   end;

   Str := callfunc ('checkobjectalive 굇베汽覩 monster 陶약잼柰准3');
   if Str = 'true' then begin
      print ('mapdelobjbyname monster 陶약잼柰准3');
   end;
   exit;
end;
```

## 注意事项

1. **先检查后删除**：建议先用 `checkobjectalive` 确认对象存在再删除
2. **对象类型匹配**：类型必须与创建时一致（`monster` 或 `dynamicobject`）
3. **配合 setallowdelete**：某些对象需要先通过 `setallowdelete` 设置允许删除后才能被删除

## 相关命令
- `mapaddobjbyname` — 在地图中添加对象
- `setallowdelete` — 设置允许删除
- `regen` — 刷新指定对象
