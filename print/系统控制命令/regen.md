# regen

## 功能描述
刷新指定对象，使其重新生成到初始位置。可以刷新怪物或动态对象。

## 语法格式
```pascal
print('regen <对象名称> <对象类型>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 对象名称 | String | 要刷新的对象名称 |
| 对象类型 | String | 对象类型：`monster`（怪物）或 `dynamicobject`（动态对象） |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'regen' then begin
   TBasicObject (aSelf).SRegen (Params [0], Params [1]);
```

直接调用 `SRegen` 方法，传入对象名称和类型。

## 使用示例

### 刷新怪物和动态对象
```pascal
// 来自 机关区域门.txt - 地图刷新后重新生成所有怪物
procedure OnRegen (aStr : String);
begin
   print ('changedynobjstate 火灯台 false');
   print ('regen 石弓射龙组 monster');
   print ('regen 石弓青龙刺客 monster');
   print ('regen 放火装置1 monster');
   print ('regen 放火装置2 monster');
   print ('regen 放火装置3 monster');
   print ('regen 放火装置4 monster');
   print ('regen 放火装置5 monster');
   print ('regen 放火装置6 monster');
   print ('regen 放火装置7 monster');
   print ('regen 放火装置8 monster');
end;
```

### Boss死亡后刷新相关对象
```pascal
// 来自 石大王.txt - Boss死亡后刷新动态对象和怪物
procedure OnDie (aStr : String);
begin
   print ('regen 霸王石 dynamicobject');
   print ('bopickbymapname 地下采石场2层 false');
   print ('regen 地下石巨人 monster');
end;
```

## 注意事项

1. **对象类型**：支持 `monster`（怪物）和 `dynamicobject`（动态对象）
2. **与 mapregen 的区别**：`mapregen` 刷新整个地图，`regen` 只刷新指定对象
3. **常用场景**：机关区域门刷新后重新生成所有守卫怪物

## 相关命令
- `mapregen` — 刷新整个地图
- `mapaddobjbyname` — 在地图中添加新对象
- `changedynobjstate` — 改变动态对象状态
