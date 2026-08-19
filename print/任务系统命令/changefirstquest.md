# changefirstquest

## 功能描述
改变自身的首要任务编号。用于系统级脚本（如 System.txt）中设置全局任务状态。

## 语法格式
```pascal
print('changefirstquest <任务编号>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 任务编号 | Integer | 要设置的首要任务编号 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'changefirstquest' then begin
   TBasicObject (aSelf).SChangeFirstQuest (_StrToInt (Params [0]));
```

作用于 `aSelf`（脚本对象自身），传入任务编号。

## 使用示例

### 新玩家首次登录时设置首要任务
```pascal
// 来自 System.txt - 新玩家首次登录时设置首要任务为1
procedure OnUserStart (aStr : String);
var
   Str : String;
   FirstQuest : Integer;
begin
   Str := callfunc ('getfirstquest');
   FirstQuest := StrToInt (Str);
   if FirstQuest < 1 then begin
      Str := callfunc ('getname');
      Str := 'sendsendertopmsg 欢迎新玩家[' + Str;
      Str := Str + '],来到云端千年的武侠世界';
      print (str);
      Str := 'changefirstquest 1';
      print (str);
      exit;
   end;
end;
```

## 注意事项

1. **作用于自身**：通过 `aSelf` 执行，在 System.txt 中代表系统对象
2. **与 changesenderfirstquest 的区别**：`changesenderfirstquest` 修改玩家的任务，`changefirstquest` 修改自身的任务
3. **系统级使用**：主要在 System.txt 等系统脚本中使用，用于初始化新玩家的全局状态

## 相关命令
- `changesenderfirstquest` — 修改玩家首要任务
- `changecompletequest` — 改变自身已完成任务
- `changecurrentquest` — 改变自身当前任务
