# getsenderrace

## 功能描述
获取当前触发脚本事件的玩家种族。

## 语法格式
```pascal
Str := callfunc('getsenderrace');
```

## 参数说明
无参数。

## 返回值
- **成功**：返回玩家的种族值（字符串格式的数字）
- **失败**：返回空字符串

## 种族值含义
根据源码分析，返回值应该是整数转换为的字符串：
- 通常：0 = 男性，1 = 女性（具体数值需要根据实际游戏设定确认）

## 源码实现
基于 `!UUser.pas` 中的 `SGetRace` 函数：

```pascal
function TUser.SGetRace : String;
begin
   Result := IntToStr (AttribClass.Sex);
end;
```

**注意**：源码中使用的是 `AttribClass.Sex`，但函数名为 `SGetRace`，这可能表示种族和性别在游戏中的定义是相关的。

## 使用示例

### 基础示例
```pascal
// 获取玩家种族并转换为整数
race_str := callfunc('getsenderrace');
race := StrToInt(race_str);
```

### 真实游戏示例
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
      Str := 'showwindow .\help\quest神医.txt 1';
      print (Str);
      exit;
   end;
end;
```

## 注意事项

1. **返回值类型**：返回的是字符串格式，需要使用 `StrToInt()` 转换为整数进行数值比较
2. **种族定义**：具体的种族值定义需要根据游戏设定确认
3. **错误处理**：如果获取失败会返回空字符串，直接使用 `StrToInt()` 会导致异常
4. **源码一致性**：注意源码中函数名为 `getsenderrace`，但内部实现使用 `Sex` 属性

## 相关函数
- `getsendername` - 获取玩家名称
- `getsenderage` - 获取玩家年龄
- `getsendersex` - 获取玩家性别