# mapaddobjbyname

## 功能描述
在当前地图中动态添加对象（怪物或动态对象）。常用于 Boss 战召唤小怪、触发机关后生成新对象等场景。

## 语法格式
```pascal
print('mapaddobjbyname <对象类型> <对象名称> <X坐标> <Y坐标> <方向> <地图ID> <是否立即>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 对象类型 | String | 对象类型：`monster`（怪物）或 `dynamicobject`（动态对象） |
| 对象名称 | String | 要添加的对象名称 |
| X坐标 | Integer | 生成位置的 X 坐标 |
| Y坐标 | Integer | 生成位置的 Y 坐标 |
| 方向 | Integer | 朝向方向（通常设为 0） |
| 地图ID | Integer | 地图编号 |
| 是否立即 | String | `false` 表示非立即生效，`true` 表示立即生效 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'mapaddobjbyname' then begin
   TBasicObject (aSelf).SMapAddObjByName (Params [0], Params);
```

将对象类型（`Params[0]`）和完整参数数组传递给 `SMapAddObjByName` 方法。

## 使用示例

### 被击中后召唤怪物
```pascal
// 来自 千年巨木.txt - 被击中后在指定位置生成怪物
procedure OnHit (aStr : String);
begin
   Inc (n);
   if n > 1 then begin
      exit;
   end;

   print ('mapaddobjbyname monster 近距离野神族2 81 136 2 0 false');
   print ('mapaddobjbyname monster 近距离野神族2 83 138 2 0 false');
   print ('mapaddobjbyname monster 近距离野神族2 85 140 2 0 false');
   print ('mapaddobjbyname monster 近距离野神族2 87 140 2 0 false');
   exit;
end;
```

### 定时器触发后生成Boss和小怪
```pascal
// 来自 北霸王火炉.txt - 定时器触发后生成怪物
procedure OnTimer (aStr : String);
begin
   Dec(n);
   if n = 0 then begin
      if boCall = 'true' then begin
         print ('mapaddobjbyname monster 北霸王山1 237 37 2 0 false');
         print ('mapaddobjbyname monster 陶약잼柰准3 234 33 2 0 false');
         print ('mapaddobjbyname monster 陶약잼柰准3 241 40 2 0 false');
         print ('mapaddobjbyname monster 陶약잼柰准3 237 44 2 0 false');
         print ('mapaddobjbyname monster 陶약잼柰准3 230 37 2 0 false');
         boCall := 'false';
      end;
   end;
end;
```

### 添加动态对象
```pascal
// 来自 狐狸火.txt - 点亮火把后生成动态对象
if LightCount = 4 then begin
   Str := callfunc ('checkobjectalive 錦조떪 dynamicobject 襤빽');
   if Str = 'false' then begin
      print ('mapaddobjbyname dynamicobject 襤빽 37 50 4 0 false');
   end;
   exit;
end;
```

## 注意事项

1. **对象类型**：支持 `monster`（怪物）和 `dynamicobject`（动态对象）
2. **坐标位置**：指定的坐标必须是地图上可放置的位置
3. **配合检查使用**：通常先用 `checkobjectalive` 检查对象是否已存在，避免重复生成
4. **配合删除使用**：生成的对象可通过 `mapdelobjbyname` 删除，或通过 `setallowdelete` 设置允许删除

## 相关命令
- `mapdelobjbyname` — 删除地图中的对象
- `mapaddobjbytick` — 定时在地图中添加对象
- `mapregen` — 刷新地图
- `setallowdelete` — 设置允许删除
