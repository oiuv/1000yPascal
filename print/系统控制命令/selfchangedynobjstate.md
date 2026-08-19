# selfchangedynobjstate

## 功能描述
改变自身（当前脚本对象）的动态对象状态。用于对象在特定事件触发时改变自身的可见/可用状态。

## 语法格式
```pascal
print('selfchangedynobjstate <状态>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 状态 | String | `TRUE` 表示激活，`FALSE` 表示停用（不区分大小写） |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'selfchangedynobjstate' then begin           //2002-08-06 giltae
   if Uppercase (Params[0]) = 'TRUE' then begin
      TBasicObject (aSelf).SSelfChangeDynobjState (true);
   end else begin
      TBasicObject (aSelf).SSelfChangeDynobjState (false);
   end;
```

通过比较 `Params[0]` 是否为 `TRUE`（不区分大小写）来决定激活还是停用。

## 使用示例

### 掉落物品时激活自身
```pascal
// 来自 雪上天蚕.txt - 掉落物品时改变自身状态
procedure OnDropItem (aStr : String);
var
   Str : String;
begin
   Str := 'selfchangedynobjstate TRUE';
   print (Str);
   exit;
end;
```

## 注意事项

1. **作用于自身**：与 `changedynobjstate`（指定名称）不同，此命令只改变脚本对象自身
2. **状态值不区分大小写**：`TRUE`/`true`/`True` 均可
3. **常见用途**：用于可采集/可掉落物品在被采集后改变状态（如消失或变为不可交互）

## 相关命令
- `changedynobjstate` — 改变指定动态对象状态
- `changesenderdynobjstate` — 改变玩家相关动态对象状态
