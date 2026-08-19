# boiceallbyname

## 功能描述
按名称设置指定类型的所有对象是否被冻结。用于批量控制一组怪物的冻结状态。

## 语法格式
```pascal
print('boiceallbyname <对象名称> <对象类型> <冻结>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 对象名称 | String | 对象名称（通常是怪物组名称） |
| 对象类型 | String | 对象类型：`monster`（怪物） |
| 冻结 | String | `true` 表示冻结，`false` 表示解冻 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'boiceallbyname' then begin
   TBasicObject (aSelf).SboIceAllbyName(Params [0], Params [1], Params [2]);
```

传入名称、类型和冻结状态。

## 使用示例

### 地图刷新时冻结守卫
```pascal
// 来自 室7盒子.txt - 地图刷新时冻结所有守卫
procedure OnRegen (aStr : String);
begin
   print ('boiceallbyname 室7四臂金刚 monster true');
   print ('boiceallbyname 室7护卫武士 monster true');
   print ('bohitallbyname 室7四臂金刚 monster false');
   print ('bohitallbyname 室7护卫武士 monster false');
end;
```

### 触发条件后解冻守卫
```pascal
// 来自 室7盒子.txt - 盒子被打死后解冻守卫
procedure OnDie (aStr : String);
begin
   print ('boiceallbyname 室7四臂金刚 monster false');
   print ('boiceallbyname 室7护卫武士 monster false');
   print ('bohitallbyname 室7四臂金刚 monster true');
   print ('bohitallbyname 室7护卫武士 monster true');
end;
```

## 注意事项

1. **批量操作**：影响同名所有对象
2. **配合 bohitallbyname**：通常与攻击状态命令配合使用
3. **常见模式**：刷新时冻结+不可攻击 → 触发后解冻+可攻击

## 相关命令
- `bohitallbyname` — 设置所有目标是否可攻击
- `commandicebyname` — 按名称冻结单个对象
- `commandice` — 冻结自身
