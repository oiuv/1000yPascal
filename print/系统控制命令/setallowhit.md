# setallowhit

## 功能描述
设置当前对象是否允许被攻击。

## 语法格式
```pascal
print('setallowhit <允许>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 允许 | String | `true` 表示允许被攻击，`false` 表示不允许 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'setallowhit' then begin
   TBasicObject (aSelf).SSetAllowHit (Params [0]);
```

直接调用 `SSetAllowHit` 方法，传入允许/禁止参数。

## 使用示例

目前游戏脚本中暂无直接使用 `setallowhit` 的示例，通常使用其变体 `setallowhitbyname` 或 `setallowhitbytick`。

## 注意事项

1. **作用于自身**：设置的是当前脚本对象自身的可攻击状态
2. **变体命令**：实际脚本中更常用 `setallowhitbyname`（按名称设置）和 `setallowhitbytick`（定时设置）

## 相关命令
- `setallowhitbyname` — 按名称设置允许攻击
- `setallowhitbytick` — 定时设置允许攻击
- `bohitallbyname` — 设置所有目标是否可攻击
