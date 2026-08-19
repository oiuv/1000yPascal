# setallowdelete

## 功能描述
设置指定对象允许被删除。用于标记由 `mapaddobjbyname` 动态生成的对象可以被 `mapdelobjbyname` 删除。

## 语法格式
```pascal
print('setallowdelete <对象类型> <对象名称>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 对象类型 | String | 对象类型：`monster`（怪物）或 `dynamicobject`（动态对象） |
| 对象名称 | String | 要设置允许删除的对象名称 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'setallowdelete' then begin
   TBasicObject (aSelf).SSetAllowDelete (Params [0], Params [1]);
```

传入对象类型和名称。

## 使用示例

### 关闭机关后允许删除动态生成的对象
```pascal
// 来自 狐狸火.txt - 关闭火把时设置允许删除
procedure OnTurnOff (aStr : String);
begin
   Dec (LightCount);

   if LightCount = 3 then begin
      print ('setallowdelete dynamicobject 襤빽');
      exit;
   end;
   if LightCount = 1 then begin
      print ('setallowdelete monster 价의큽茄獗');
      exit;
   end;
end;
```

## 注意事项

1. **先设置后删除**：必须先调用 `setallowdelete` 设置允许删除，然后才能用 `mapdelobjbyname` 删除
2. **安全机制**：这是一种安全机制，防止误删重要的地图对象
3. **对象类型**：支持 `monster` 和 `dynamicobject`

## 相关命令
- `mapdelobjbyname` — 删除地图中的对象
- `mapaddobjbyname` — 在地图中添加对象
