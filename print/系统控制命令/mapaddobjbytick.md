# mapaddobjbytick

## 功能描述
把“生成怪物”加入 `Self` 的命令队列，达到指定 tick 后执行。它与 `mapaddobjbyname` 的对象分支并不相同。

## 语法格式
```pascal
print('mapaddobjbytick monster <怪物名称> <X> <Y> <方向> <脚本编号> <是否重生> <延迟tick>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 对象类型 | String | 现有脚本写 `monster`；当前队列实际不保存此项，并固定调用 `MakeMonster` |
| 对象名称 | String | 要添加的对象名称 |
| X坐标 | Integer | 生成位置的 X 坐标 |
| Y坐标 | Integer | 生成位置的 Y 坐标 |
| 方向 | Integer | 朝向方向（通常设为 0） |
| 脚本编号 | Integer | 新怪物的脚本编号，0 表示不另行指定 |
| 是否重生 | String | 只接受小写 `true` 或 `false`；传给 `MakeMonster` |
| 延迟 tick | Integer | 相对 `mmAnsTick` 的队列间隔；正常倍率下 1 tick 约 10 ms |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'mapaddobjbytick' then begin
   TBasicObject (aSelf).PushCommand (CMD_ADDMOP, Params, _StrToInt (Params [7]));
```

`PushCommand` 会丢弃 `Params[0]` 的对象类型，只保存名称至重生标志。到期后只有 `TLifeObject.WorkBoxCommand` 的 `CMD_ADDMOP` 分支会固定调用当前地图的 `MonsterList.MakeMonster`；动态对象的 WorkBox 没有该分支。

## 使用示例

### 怪物死亡后延迟重生
```pascal
// 来自 上古雨中客.txt - 正常 tick 倍率下约 8 秒后生成新怪物
procedure OnDie (aStr : String);
begin
   print ('mapaddobjbytick monster 上古雨中客2 178 176 1 97 false 800');
end;
```

## 注意事项

1. **单位不是毫秒**：`uAnsTick.pas` 默认每 10 ms 加 1；测试加速倍率会改变墙钟时间。
2. **只确认怪物分支**：不要用它延迟创建 NPC 或 DynamicObject。
3. **当前地图**：命令使用 `Self.Manager`，参数中没有地图 ID。

## 相关命令
- `mapaddobjbyname` — 在地图中立即添加对象
- `mapdelobjbyname` — 删除地图中的对象
- `regen` — 刷新指定对象
