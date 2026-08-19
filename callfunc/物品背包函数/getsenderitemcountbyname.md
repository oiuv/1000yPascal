# getsenderitemcountbyname

## 功能描述
按名称获取玩家背包中指定物品的数量。

## 语法格式
```pascal
Str := callfunc('getsenderitemcountbyname 物品名称');
```

## 参数说明
- **物品名称**：String - 要查询的物品名称

## 返回值
- **物品数量**：String - 背包中该物品的总数量，以字符串形式返回（如 '0'、'5'、'100'）

## 源码实现
```pascal
// uScriptManager.pas 第617行
end else if cmd = 'getsenderitemcountbyname' then begin
   Result := TBasicObject (FSender).SFindItemCount (Params [0]);
```

调用 `TBasicObject.SFindItemCount`，按物品名称在背包中搜索并返回数量。

## 使用示例

### 检查是否持有特定物品
```pascal
// 检查背包中是否有侠客指环
Str := callfunc ('getsenderitemcountbyname 侠客指环');
if Str <> '0' then begin
    print ('say 拿着侠客指环不能进入...');
    exit;
end;
```
> 来源：`一级比武老人.txt`

### 结合数量判断
```pascal
// 检查金元数量是否足够
Str := callfunc ('getsenderitemcountbyname 金元');
nCount := StrToInt (Str);
if nCount < 60 then begin
    print ('say 金元不足，需要60个金元');
    exit;
end;
```

## 注意事项

1. **返回值格式**：返回字符串类型的数字，需要 `StrToInt` 转换后才能做数值比较
2. **精确匹配**：按物品名称精确匹配，不是模糊搜索
3. **统计总量**：统计背包中所有栏位该物品的总数量
4. **与 getsenderitemexistence 的区别**：本函数返回具体数量，`getsenderitemexistence` 返回 'true'/'false'

## 相关函数
- `getsenderitemexistence` - 检查指定物品是否存在
- `getsenderitemexistencebykind` - 按种类检查物品是否存在
- `checkenoughspace` - 检查背包空间是否足够
