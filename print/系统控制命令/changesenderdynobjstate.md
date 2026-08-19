# changesenderdynobjstate

## 功能描述
改变与玩家相关的动态对象状态。通过命令队列延迟执行，通常用于根据玩家位置或行为触发动态对象的状态变化。

## 语法格式
```pascal
print('changesenderdynobjstate <玩家名> <状态>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 玩家名 | String | 触发状态变化的玩家名称 |
| 状态 | String | `true` 表示激活，`false` 表示停用 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'changesenderdynobjstate' then begin
   TBasicObject (aSelf).PushCommand (CMD_CHANGESTEP, Params, 0);
```

通过 `PushCommand` 将命令放入队列（延迟为0，即尽快执行），使用 `CMD_CHANGESTEP` 命令类型。

## 使用示例

### 玩家移动时改变动态对象状态
```pascal
// 来自 密室太极老人.txt - 玩家移动到正确位置后改变状态
procedure OnGetChangeStep (aSTr : String);
var
   Str, rdStr, xStr, yStr : String;
   x, y, xx, yy : Integer;
begin
   if aStr <> '1' then begin
      exit;
   end;

   // ... 获取玩家位置并计算附近坐标 ...

   Str := 'gotoxy ' + xStr;
   Str := Str + ' ';
   Str := Str + yStr;
   print (Str);

   rdStr := callfunc ('getsendername');
   Str := 'changesenderdynobjstate ' + rdStr;
   Str := Str + ' false';
   print (Str);
end;
```

## 注意事项

1. **与 changedynobjstate 的区别**：`changedynobjstate` 直接按名称改变对象状态，`changesenderdynobjstate` 通过玩家关联来改变状态
2. **延迟执行**：使用 `PushCommand` 放入命令队列，不是立即执行
3. **命令类型**：使用 `CMD_CHANGESTEP`，与步阶变化相关

## 相关命令
- `changedynobjstate` — 改变动态对象状态
- `selfchangedynobjstate` — 改变自身动态对象状态
