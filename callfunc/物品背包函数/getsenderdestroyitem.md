# getsenderdestroyitem

## 功能描述
按种类销毁玩家背包或装备栏中的物品。

## 语法格式
```pascal
Str := callfunc('getsenderdestroyitem 物品类型 物品ID');
```

## 参数说明
- **物品类型**：Integer - 物品所在区域的类型
  - 0：背包物品栏
  - 9：装备栏（武器栏）
- **物品ID**：Integer - 要销毁的物品ID

## 返回值
- **'0'**：物品栏里没有对应物品
- **'1'**：销毁成功

## 源码实现
```pascal
// uScriptManager.pas 第615行
end else if cmd = 'getsenderdestroyitem' then begin
   Result := IntToStr (TBasicObject (FSender).SDestroyItembyKind (_StrToInt (Params [0]), _StrToInt (Params [1])));
```

调用 `TBasicObject.SDestroyItembyKind`，按种类销毁物品，返回整数结果转为字符串。

## 使用示例

### 销毁背包中的物品
```pascal
// 销毁背包(类型0)中的物品(ID 59)
Str := callfunc ('getsenderdestroyitem 0 59');
if Str = '0' then begin
    print ('say 物品栏里没有对应物品.');
    exit;
end;
if Str = '1' then begin
    print ('say 物品已销毁');
end;
```
> 来源：`quest老侠客.txt`

### 销毁装备栏中的武器
```pascal
// 销毁装备栏(类型9)中的武器(ID 60)
Str := callfunc ('getsenderdestroyitem 9 60');
if Str = '0' then begin
    print ('say 没有可销毁的装备');
    exit;
end;
if Str = '1' then begin
    print ('getsenderitem 钱币:5000');  // 返还钱币
end;
```
> 来源：`quest老侠客.txt`

## 注意事项

1. **返回值格式**：返回字符串类型的数字代码 '0' 或 '1'
2. **不可逆操作**：销毁后物品永久消失，无法恢复
3. **物品类型**：0 代表背包物品栏，9 代表装备栏
4. **按种类销毁**：函数名为 `SDestroyItembyKind`，按种类匹配销毁

## 相关函数
- `getsenderrepairitem` - 修理物品
- `getsenderitemexistence` - 检查物品是否存在
- `getsenderitem` - 给予玩家物品
