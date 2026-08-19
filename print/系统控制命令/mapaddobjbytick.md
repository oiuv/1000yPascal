# mapaddobjbytick

## 功能描述
定时在地图中添加对象。与 `mapaddobjbyname` 类似，但支持延迟执行，在指定的毫秒数后生成对象。

## 语法格式
```pascal
print('mapaddobjbytick <对象类型> <对象名称> <X坐标> <Y坐标> <方向> <地图ID> <是否立即> <延迟毫秒>');
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
| 是否立即 | String | `false` 表示非立即生效 |
| 延迟毫秒 | Integer | 延迟执行的毫秒数 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'mapaddobjbytick' then begin
   TBasicObject (aSelf).PushCommand (CMD_ADDMOP, Params, _StrToInt (Params [7]));
```

通过 `PushCommand` 将命令放入队列，延迟时间由 `Params[7]`（第8个参数）决定。

## 使用示例

### 怪物死亡后延迟重生
```pascal
// 来自 上古雨中客.txt - 怪物死亡后800毫秒在指定位置生成新怪物
procedure OnDie (aStr : String);
begin
   print ('mapaddobjbytick monster 上古雨中客2 178 176 1 97 false 800');
end;
```

## 注意事项

1. **延迟执行**：最后一个参数为延迟毫秒数，对象将在指定时间后生成
2. **与 mapaddobjbyname 的区别**：`mapaddobjbyname` 立即添加，`mapaddobjbytick` 延迟添加
3. **参数数量**：比 `mapaddobjbyname` 多一个延迟参数（共8个参数）

## 相关命令
- `mapaddobjbyname` — 在地图中立即添加对象
- `mapdelobjbyname` — 删除地图中的对象
- `regen` — 刷新指定对象
