# mapaddobjbyname

## 功能描述
在 `Self` 所属地图中动态添加怪物、NPC 或动态对象。常用于 Boss 战召唤、机关触发和临时对象生成。

## 语法格式
```pascal
print('mapaddobjbyname <对象类型> <对象名称> <X> <Y> <方向或脚本> <脚本或保留值> <重生或NPC配置>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 对象类型 | String | `monster`、`npc` 或 `dynamicobject`，分支判断不区分大小写 |
| 对象名称 | String | 要添加的对象名称 |
| X坐标 | Integer | 生成位置的 X 坐标 |
| Y坐标 | Integer | 生成位置的 Y 坐标 |
| 第 5 项 | Integer | Monster/NPC 为方向；DynamicObject 为脚本编号 |
| 第 6 项 | Integer | Monster/NPC 为脚本编号；DynamicObject 忽略 |
| 第 7 项 | String | Monster 为是否允许重生；NPC 为 `BookName`；DynamicObject 忽略 |

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
         print ('mapaddobjbyname monster 北霸王魂1 237 37 2 0 false');
         print ('mapaddobjbyname monster 远距离野神族3 234 33 2 0 false');
         print ('mapaddobjbyname monster 远距离野神族3 241 40 2 0 false');
         print ('mapaddobjbyname monster 远距离野神族3 237 44 2 0 false');
         print ('mapaddobjbyname monster 远距离野神族3 230 37 2 0 false');
         boCall := 'false';
      end;
   end;
end;
```

### 添加动态对象
```pascal
// 来自 狐狸火.txt - 点亮火把后生成动态对象
if LightCount = 4 then begin
   Str := callfunc ('checkobjectalive 修炼洞 dynamicobject 妖华');
   if Str = 'false' then begin
      print ('mapaddobjbyname dynamicobject 妖华 37 50 4 0 false');
   end;
   exit;
end;
```

## 注意事项

1. **参数不是“地图 ID”**：源码始终使用当前 `Manager`，没有从命令参数选择地图。
2. **分支参数不同**：DynamicObject 只读取名称、X、Y、脚本编号；尾部两个值只是现有脚本为保持统一格式而保留。
3. **引用必须存在**：Monster/NPC/DynamicObject 名称分别要能在对应初始化数据中找到；坐标也必须对当前地图有效。
4. **避免重复生成**：通常先用 `checkobjectalive` 检查同名对象。

## 相关命令
- `mapdelobjbyname` — 删除地图中的对象
- `mapaddobjbytick` — 定时在地图中添加对象
- `mapregen` — 刷新地图
- `setallowdelete` — 设置允许删除
