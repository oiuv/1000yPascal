# changedynobjstate

## 功能描述
改变指定动态对象的状态（激活/停用）。用于控制地图中的动态对象（如机关、传送门等）的开关状态。

## 语法格式
```pascal
print('changedynobjstate <对象名称> <状态>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 对象名称 | String | 动态对象的名称 |
| 状态 | String | `true` 表示激活，`false` 表示停用 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'changedynobjstate' then begin
   if UpperCase (Params [1]) = 'TRUE' then begin
      TBasicObject (aSelf).SChangeDynobjState (Params[0], true);
   end else begin
      TBasicObject (aSelf).SChangeDynobjState (Params[0], false);
   end;
```

通过比较 `Params[1]` 是否为 `TRUE`（不区分大小写）来决定激活还是停用。

## 使用示例

### 激活动态对象
```pascal
// 来自 火炉.txt - 开启火炉时激活入口
procedure OnTurnOn (aStr : String);
begin
   inc (n);
   print ('changedynobjstate 石弓洞入口 true');
end;
```

### 停用动态对象
```pascal
// 来自 火炉.txt - 关闭火炉时停用入口
procedure OnTurnOff (aStr : String);
begin
   dec (n);
   print ('changedynobjstate 石弓洞入口 false');
end;
```

### 机关触发时改变状态
```pascal
// 来自 北霸王火炉.txt - 开启时激活动态对象
procedure OnTurnOn (aStr : String);
begin
   boCall := 'true';
   n := 2;
   print ('changedynobjstate 굇게珙 true');
end;
```

## 注意事项

1. **状态值**：`true`/`false` 不区分大小写，源码中使用 `UpperCase` 进行比较
2. **对象类型**：仅适用于动态对象（`dynamicobject`），不适用于怪物
3. **配合使用**：通常与 `boiceallbyname`、`bohitallbyname` 等命令配合控制机关逻辑

## 相关命令
- `changesenderdynobjstate` — 改变玩家相关动态对象状态
- `selfchangedynobjstate` — 改变自身动态对象状态
- `regen` — 刷新指定对象
