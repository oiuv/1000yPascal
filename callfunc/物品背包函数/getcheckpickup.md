# getcheckpickup

## 功能描述
获取玩家的拾取检查状态，用于判断是否可以申请特定技能。

## 语法格式
```pascal
Str := callfunc('getcheckpickup');
```

## 参数说明
- 无参数

## 返回值
- **成功**：'true' - 可以申请该技能
- **失败**：'false' - 已经申请过该技能

## 源码实现
```pascal
// uScriptManager.pas 第639行
end else if cmd = 'getcheckpickup' then begin
   Result := TBasicObject (FSender).SCheckPickup;
```

调用 `TBasicObject.SCheckPickup`，返回玩家的拾取检查状态。

## 使用示例

### 聚贤庄申请技能
```pascal
// 检查钱币是否足够
Str1 := 'getsenderitemexistence 钱币:15000';
Name := callfunc (str1);
if Name = 'false' then begin
    Str := 'say 你没有足够的钱币？';
    print (Str);
    exit;
end;

// 检查是否已申请过该技能
Name := callfunc ('getcheckpickup');
if Name = 'false' then begin
    print ('say 抱歉,你已经申请了该技能');
    exit;
end;

// 扣除钱币并申请技能
print ('getsenderitem 钱币:15000');
print ('say 申请技能成功');
```
> 来源：`聚贤庄庄主.txt`

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'
2. **一次性检查**：用于防止玩家重复申请同一技能
3. **无参数**：不需要传入任何参数
4. **与钱币配合**：通常先检查钱币是否足够，再检查是否已申请

## 相关函数
- `getsenderitemexistence` - 检查物品是否存在
- `getsenderitemcountbyname` - 获取物品数量
