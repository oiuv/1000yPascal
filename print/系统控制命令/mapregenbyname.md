# mapregenbyname

## 功能描述
按名称刷新指定地图。与 `mapregen` 使用地图ID不同，此命令通过地图名称来定位并刷新地图。

## 语法格式
```pascal
print('mapregenbyname <地图名称> <刷新目标>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 地图名称 | String | 要刷新的地图名称 |
| 刷新目标 | String | 刷新的目标对象或类型 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'mapregenbyname' then begin
   TBasicObject (aSelf).SMapRegenByName (Params, Params [1], Params [2]);
```

将整个参数数组以及 `Params[1]`（地图名称）和 `Params[2]`（刷新目标）传递给 `SMapRegenByName` 方法。

## 使用示例

目前游戏脚本中暂无使用此命令的示例。

## 注意事项

1. **与 mapregen 的区别**：`mapregen` 使用地图ID（数字），`mapregenbyname` 使用地图名称（字符串）
2. **参数传递**：源码中传递了完整参数数组和两个关键参数，具体行为取决于 `SMapRegenByName` 的实现

## 相关命令
- `mapregen` — 按ID刷新地图
- `mapaddobjbyname` — 在地图中添加对象
- `mapdelobjbyname` — 删除地图中的对象
