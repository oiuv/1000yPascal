# getsenderrepairitem

## 功能描述
修理玩家背包或装备栏中的物品，恢复其耐久度。

## 语法格式
```pascal
Str := callfunc('getsenderrepairitem 物品类型 物品ID');
```

## 参数说明
- **物品类型**：Integer - 物品所在区域的类型
  - 0：背包物品栏
  - 9：装备栏（武器栏）
- **物品ID**：Integer - 要修理的物品ID

## 返回值
- **'0'**：物品栏里没有对应物品
- **'1'**：修理成功（已扣费/执行完毕）
- **'2'**：物品还很结实（耐久度已满，无需修理）
- **'3'**：其他状态（如费用不足等）

## 源码实现
```pascal
// uScriptManager.pas 第613行
end else if cmd = 'getsenderrepairitem' then begin
   Result := IntToStr (TBasicObject (FSender).SRepairItem (_StrToInt (Params [0]), _StrToInt (Params [1])));
```

调用 `TBasicObject.SRepairItem`，返回整数结果转为字符串。

## 使用示例

### 修理背包中的八卦牌
```pascal
// 修理背包(类型0)中的八卦牌(ID 59)
Str := callfunc ('getsenderrepairitem 0 59');
if Str = '0' then begin
    print ('say 物品栏里没有八卦牌.');
    exit;
end;
if Str = '1' then begin
    exit;  // 修理成功
end;
if Str = '2' then begin
    print ('say 这位侠士,八卦牌还很结实啊');
    exit;
end;
if Str = '3' then begin
    exit;
end;
```
> 来源：`quest铁匠.txt`

### 修理装备栏中的武器
```pascal
// 修理装备栏(类型9)中的武器(ID 60)
Str := callfunc ('getsenderrepairitem 9 60');
if Str = '0' then begin
    print ('say 手里怎么什么也没有啊');
    exit;
end;
if Str = '1' then begin
    print ('say 不是告诉你要带上不羁浪人武器了吗!');
end;
if Str = '2' then begin
    print ('say 你看,这还能用呢!');
end;
```
> 来源：`quest铁匠.txt`

### 铁匠修理武器
```pascal
Str := callfunc ('getsenderrepairitem 9 27');
```
> 来源：`铁匠.txt`

## 注意事项

1. **返回值格式**：返回字符串类型的数字代码，需要逐值判断
2. **物品类型**：0 代表背包物品栏，9 代表装备栏
3. **修理条件**：物品耐久度不满时才能修理，已满返回 '2'
4. **费用扣除**：修理可能需要消耗钱币，具体由服务端逻辑控制

## 相关函数
- `getsenderdestroyitem` - 销毁物品
- `getsenderitemcurdurability` - 获取装备当前耐久度
- `getsenderitemmaxdurability` - 获取装备最大耐久度
