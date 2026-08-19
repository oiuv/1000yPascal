# conditionbestattackmagic

## 功能描述
检查玩家是否满足学习绝世武功的条件。

## 语法格式
```pascal
Str := callfunc('conditionbestattackmagic 武功名称');
```

## 参数说明
- **武功名称**：String - 要检查的绝世武功名称

## 返回值
- **成功**：'true' - 玩家满足学习该绝世武功的条件
- **失败**：'false' - 玩家不满足条件

## 源码实现
```pascal
// uScriptManager.pas 第631行
end else if cmd = 'conditionbestattackmagic' then begin
   Result := TBasicObject (FSender).SConditionBestAttackMagic (Params [0]);
```

调用 `TBasicObject.SConditionBestAttackMagic`，检查玩家是否满足学习指定绝世武功的前置条件。

## 使用示例

### 梅花夫人绝世武功学习
```pascal
// 检查背包空间
Str := callfunc ('checkenoughspace');
if Str = 'false' then begin
    print ('say 物品栏已满...');
    exit;
end;

// 检查金元
Str := callfunc ('getsenderitemexistence 金元:60');
if Str = 'false' then begin
    print ('say 需金元60');
    exit;
end;

// 检查绝世武功学习条件
Str := callfunc ('conditionbestattackmagic 凤凰雷电戟');
if Str = 'false' then exit;

// 扣除金元，给予武功
print ('getsenderitem 金元:60');
print ('putsendermagicitem 凤凰雷电戟:1 @梅花夫人 4');
```
> 来源：`梅花夫人.txt`

### 昭巫枪法检查
```pascal
Str := callfunc ('getsenderitemexistence 金元:60');
if Str = 'false' then begin
    print ('say 需金元60');
    exit;
end;
Str := callfunc ('conditionbestattackmagic 昭巫枪法');
if Str = 'false' then exit;

print ('getsenderitem 金元:60');
print ('putsendermagicitem 昭巫枪法:1 @梅花夫人 4');
```
> 来源：`梅花夫人.txt`

### 乌龙索命枪检查
```pascal
Str := callfunc ('conditionbestattackmagic 乌龙索命枪');
if Str = 'false' then exit;
```
> 来源：`梅花夫人.txt`

### 捕盗大将绝世武功
```pascal
Str := callfunc ('conditionbestattackmagic 武功名称');
if Str = 'false' then exit;
```
> 来源：`捕盗大将.txt`、`晋级黑捕校.txt`、`晋级白捕校.txt`、`牛俊.txt`

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'
2. **条件检查**：检查的内容包括前置武功要求、等级要求等综合条件
3. **失败处理**：条件不满足时函数返回 'false'，通常直接 `exit` 退出（内部可能已有提示信息）
4. **配合使用**：通常与 `checkenoughspace`、`getsenderitemexistence` 配合使用

## 相关函数
- `checksendercurusemagic` - 检查当前使用的武功
- `checkusemagicbygrade` - 按等级检查武功
- `checkmagic` - 检查武功修炼条件
