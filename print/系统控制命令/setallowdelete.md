# setallowdelete

## 功能描述
把指定对象的 `FboAllowDelete` 标志设为 `true`。对象后续不再处理普通逻辑，并由所属列表的生命周期流程清理。

## 语法格式
```pascal
print('setallowdelete <对象类型> <对象名称>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 对象类型 | String | `monster`、`npc` 或 `dynamicobject`，不区分大小写 |
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
      print ('setallowdelete dynamicobject 妖华');
      exit;
   end;
   if LightCount = 1 then begin
      print ('setallowdelete monster 死狼女实像');
      exit;
   end;
end;
```

## 注意事项

1. **不是授权开关**：本命令本身就是标记删除；不需要再调用 `mapdelobjbyname`。
2. **匹配范围**：源码先按类型和名称取得一个对象，因此同名对象较多时不要假定会全部标记。
3. **不可恢复**：标志只会被设为 `true`，命令没有撤销参数；测试前应确认名称和类型。

## 相关命令
- `mapdelobjbyname` — 删除地图中的对象
- `mapaddobjbyname` — 在地图中添加对象
