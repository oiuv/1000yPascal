# getsenderage

## 功能描述
获取当前触发脚本事件的玩家年龄。

## 语法格式
```pascal
Str := callfunc('getsenderage');
```

## 参数说明
无参数。

## 返回值
- **成功**：返回玩家的年龄（字符串格式的数字）
- **失败**：返回空字符串

## 源码实现
基于 `!UUser.pas` 中的 `SGetAge` 函数：

```pascal
function TUser.SGetAge : String;
begin
   Result := IntToStr (AttribClass.Age);
end;
```

## 使用示例

### 基础示例
```pascal
// 获取玩家年龄并转换为整数
age_str := callfunc('getsenderage');
age := StrToInt(age_str);
```

### 等级检查示例
```pascal
// 检查玩家修炼等级是否满足要求
age_str := callfunc('getsenderage');
age := StrToInt(age_str);

if age < 1000 then
begin
    print('say 你的修炼等级不足，需要1000级以上才能接受此任务');
    exit;
end;
```

### 修炼等级范围判断
```pascal
age_str := callfunc('getsenderage');
age := StrToInt(age_str);

if age >= 1 and age <= 1000 then
    print('say 你是初级修炼者')
else if age >= 1001 and age <= 5000 then
    print('say 你是中级修炼者')
else if age > 5000 then
    print('say 你是高级修炼者');
```

### 真实游戏示例
基于 `一级比武老人.txt` 中的使用：

```pascal
// 检查玩家修炼等级是否过高
Str := callfunc ('getsenderage');
iCount := StrToInt (Str);
if iCount > 5000 then begin
   print ('say 太强大了...是不是太勉强了呢？');
   exit;
end;
```

基于 `一级老板娘.txt` 中的使用：

```pascal
// 检查玩家修炼等级并给予相应对话
Str := callfunc ('getsenderage');
FirstQuest := StrToInt(Str);
if FirstQuest > 4000 then begin
   Str := 'say 你看起来能力不错，谢谢你的好意...';
   print (Str);
   exit;
end;
```

## 注意事项

1. **返回值类型**：返回的是字符串格式，需要使用 `StrToInt()` 转换为整数进行数值比较
2. **年龄含义**：这里的"年龄"实际上是游戏中的等级或修炼等级，不是真实年龄
3. **数值范围**：年龄值通常在1-100之间，具体范围由游戏规则决定
4. **错误处理**：如果获取失败会返回空字符串，直接使用 `StrToInt()` 会导致异常

## 相关函数
- `getsendername` - 获取玩家名称
- `getsendersex` - 获取玩家性别
- `getsenderrace` - 获取玩家种族
- `getsenderlife` - 获取玩家生命值