# bopickbymapname

## 功能描述
按地图名称设置是否允许挖掘。用于控制特定地图中的挖掘/采集功能。

## 语法格式
```pascal
print('bopickbymapname <地图名称> <允许>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 地图名称 | String | 要控制的地图名称 |
| 允许 | String | `true` 表示允许挖掘，`false` 表示禁止 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'bopickbymapname' then begin
   TBasicObject (aSelf).SboPickbyMapName(Params [0], Params [1]);
```

传入地图名称和允许状态。

## 使用示例

### Boss死亡后开放地图挖掘
```pascal
// 来自 石大王.txt - Boss死亡后开放地下采石场的挖掘
procedure OnDie (aStr : String);
begin
   print ('regen 霸王石 dynamicobject');
   print ('bopickbymapname 地下采石场2层 false');
   print ('regen 地下石巨人 monster');
end;
```

## 注意事项

1. **按名称控制**：使用地图名称而非ID来控制
2. **使用场景**：主要用于控制特定区域的采集/挖掘权限
3. **示例中的用法**：在石大王脚本中，Boss死亡后设为 `false`（禁止挖掘），可能是防止重复采集

## 相关命令
- `boMapEnter` — 地图进入检查
- `mapregen` — 刷新地图
