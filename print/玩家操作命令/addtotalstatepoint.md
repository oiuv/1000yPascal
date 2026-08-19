# addtotalstatepoint

## 功能描述
增加玩家的总状态点数。与 `addaddablestatepoint` 不同，此命令增加的是总状态点记录值。

## 语法格式
```pascal
print('addtotalstatepoint 点数');
```

## 参数说明
- **点数**：Integer - 要增加的总状态点数量

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'addtotalstatepoint' then begin
   TBasicObject (aSender).STotalAddableStatePoint (_StrToInt (Params [0]));
```

`TUser.STotalAddableStatePoint` 实现在 `UUser.pas` 中：

```pascal
procedure TUser.STotalAddableStatePoint (aPoint : Integer);
begin
   AttribClass.TotalStatePoint := AttribClass.TotalStatePoint + aPoint;
   SendClass.SendExtraAttribValues (AttribClass);
end;
```

## 使用示例

### 奖励总状态点
```pascal
// 完成任务奖励总状态点
print ('addtotalstatepoint 10');
print ('say 恭喜你，总状态点增加10');
```

### 配合可分配状态点使用
```pascal
// 同时增加可分配点和总状态点
print ('addaddablestatepoint 5');
print ('addtotalstatepoint 5');
print ('say 获得5个状态点');
```

## 注意事项

1. **累加计算**：新点数在现有总状态点基础上累加
2. **即时同步**：加点后会立即发送 `SendExtraAttribValues` 更新客户端显示
3. **与 addaddablestatepoint 区别**：本命令修改 `TotalStatePoint`（总状态点记录），`addaddablestatepoint` 修改 `AddableStatePoint`（可自由分配的点数）
4. **无脚本实例**：当前 bin/Script/ 目录下未找到此命令的实际使用脚本

## 相关命令
- `addaddablestatepoint` - 增加可分配状态点
