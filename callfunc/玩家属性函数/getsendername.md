# getsendername

## 功能描述
获取当前触发脚本事件的玩家名称。

## 语法格式
```pascal
Str := callfunc('getsendername');
```

## 参数说明
无参数。

## 返回值
- **成功**：返回玩家的角色名称（字符串）
- **失败**：返回空字符串

## 源码实现
基于 `!UUser.pas` 中的 `SGetName` 函数：

```pascal
function TUser.SGetName : String;
begin
   Result := AttribClass.Name;
end;
```

## 使用示例

### 基础示例
```pascal
// 获取玩家名称
player_name := callfunc('getsendername');
```

### 实际游戏示例
基于 `quest神医.txt` 中的使用：

```pascal
procedure OnLeftClick (aStr : String);
var
   Str : String;
   Race : Integer;
begin
   Str := callfunc ('getsenderrace');
   Race := StrToInt (Str);
   if Race = 1 then begin
      // 获取玩家名称并显示欢迎信息
      Str := callfunc ('getsendername');
      Str := 'say 欢迎玩家 ' + Str + ' 来到神医处';
      print (Str);
   end;
end;
```

### 系统脚本示例
基于 `System.txt` 中的使用：

```pascal
procedure OnUserStart (aStr : String);
var
   Str : String;
begin
   Str := callfunc ('getname');
   Str := 'sendsendertopmsg 欢迎新玩家[' + Str;
   Str := Str + '],来到云端千年的武侠世界';
   print (str);
end;
```

## 注意事项

1. **名称编码**：返回的名称使用中文编码（GBK），在脚本中直接使用时需要考虑编码问题
2. **空格处理**：名称中的空格在脚本字符串处理时可能需要特殊处理
3. **权限检查**：该函数只能获取触发脚本的玩家名称，不能获取其他玩家信息
4. **返回值检查**：在使用返回值前应检查是否为空字符串，避免错误

## 相关函数
- `getsenderage` - 获取玩家年龄
- `getsenderrace` - 获取玩家种族
- `getsendersex` - 获取玩家性别