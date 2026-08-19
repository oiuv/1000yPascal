# bohitallbyname

## 功能描述
按名称设置指定类型的所有对象是否可以被攻击。用于批量控制一组怪物的可攻击状态。

## 语法格式
```pascal
print('bohitallbyname <对象名称> <对象类型> <允许>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 对象名称 | String | 对象名称（通常是怪物组名称） |
| 对象类型 | String | 对象类型：`monster`（怪物） |
| 允许 | String | `true` 表示允许被攻击，`false` 表示不允许 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'bohitallbyname' then begin
   TBasicObject (aSelf).SboHitAllbyName(Params [0], Params [1], Params [2]);
```

传入名称、类型和允许状态。

## 使用示例

### 怪物死亡后开放Boss攻击
```pascal
// 来自 室7盒子.txt - 盒子被打死后，守卫怪物变为可攻击
procedure OnDie (aStr : String);
begin
   print ('boiceallbyname 室7四臂金刚 monster false');
   print ('boiceallbyname 室7护卫武士 monster false');
   print ('bohitallbyname 室7四臂金刚 monster true');
   print ('bohitallbyname 室7护卫武士 monster true');
end;
```

### 所有小怪清除后开放Boss
```pascal
// 来自 event西域魔人虚像1.txt - 所有小怪被清除后开放Boss攻击
procedure OnDie (aStr : String);
begin
   if n > 1 then exit;

   Str := callfunc ('checkalivemopcount 93 monster 魔道士A');
   if Str <> '0' then exit;
   // ... 检查所有小怪是否已清除 ...

   inc (n);
   print ('bohitallbyname 西域魔人虚像A monster true');
end;
```

### 地图刷新时恢复不可攻击状态
```pascal
// 来自 室7盒子.txt - 地图刷新时恢复守卫为不可攻击
procedure OnRegen (aStr : String);
begin
   print ('boiceallbyname 室7四臂金刚 monster true');
   print ('boiceallbyname 室7护卫武士 monster true');
   print ('bohitallbyname 室7四臂金刚 monster false');
   print ('bohitallbyname 室7护卫武士 monster false');
end;
```

## 注意事项

1. **批量操作**：与 `setallowhitbyname` 不同，此命令影响同名所有对象
2. **配合 boiceallbyname**：通常与冻结命令配合使用，先冻结再设置攻击状态
3. **常见模式**：怪物刷新时设为不可攻击+冻结，触发条件后设为可攻击+解冻

## 相关命令
- `setallowhitbyname` — 设置单个对象是否允许攻击
- `boiceallbyname` — 设置所有目标是否冻结
- `commandicebyname` — 按名称冻结对象
