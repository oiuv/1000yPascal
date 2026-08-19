# getsenderitemexistence

## 功能描述
检查玩家背包中是否存在指定名称和数量的物品。

## 语法格式
```pascal
Str := callfunc('getsenderitemexistence 物品名称:数量');
```

## 参数说明
- **物品名称:数量**：String - 物品名称和所需数量，用冒号 `:` 分隔。格式为 `物品名称:数量`

## 返回值
- **成功**：'true' - 玩家背包中存在指定数量的物品
- **失败**：'false' - 玩家背包中不存在或数量不足

## 源码实现
```pascal
// uScriptManager.pas 第568行
end else if cmd = 'getsenderitemexistence' then begin
   Result := TBasicObject (FSender).SGetItemExistence (Params [0], _StrToInt (Params [1]));
```

调用 `TBasicObject.SGetItemExistence`，第一个参数为物品名称，第二个参数为数量要求。

## 使用示例

### 基础物品检查
```pascal
// 检查是否有1个神秘箱子
Str := callfunc ('getsenderitemexistence 神秘箱子:1');
if Str = 'false' then begin
    print ('say 没看见我正忙着吗?!');
    exit;
end;
```
> 来源：`quest铁匠.txt`

### 钱币检查
```pascal
// 检查钱币是否足够（门票1000钱币）
Str := callfunc ('getsenderitemexistence 钱币:1000');
if Str = 'false' then begin
    print ('say 钱币不足，入场门票需1000钱币');
    exit;
end;
```
> 来源：`一级比武老人.txt`

### 金元检查
```pascal
// 检查60个金元
Str := callfunc ('getsenderitemexistence 金元:60');
if Str = 'false' then begin
    print ('say 需金元60');
    exit;
end;
```
> 来源：`梅花夫人.txt`

### 血石检查
```pascal
// 检查30个血石
Name := callfunc('getsenderitemexistence 血石:30');
if Name = 'false' then begin
    Str := 'say 这真的是萧郎让你交给我的玛瑙石么？怎么颜色这么暗淡？';
    print (Str);
    exit;
end;
```
> 来源：`素莲.txt`

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'，需要进行字符串比较
2. **参数格式**：物品名称和数量之间用冒号 `:` 分隔
3. **数量检查**：不仅检查物品是否存在，还检查数量是否满足要求
4. **与 getsenderitemcountbyname 的区别**：本函数返回布尔值，`getsenderitemcountbyname` 返回具体数量

## 相关函数
- `getsenderitemcountbyname` - 获取指定名称物品的数量
- `getsenderitemexistencebykind` - 按种类检查物品是否存在
- `checkenoughspace` - 检查背包空间是否足够
