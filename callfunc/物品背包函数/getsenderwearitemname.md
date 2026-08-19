# getsenderwearitemname

## 功能描述
获取玩家指定装备栏位中穿戴物品的名称。

## 语法格式
```pascal
Str := callfunc('getsenderwearitemname 栏位编号');
```

## 参数说明
- **栏位编号**：Integer - 装备栏位索引编号
  - 6：衣服/套装栏位

## 返回值
- **成功**：String - 装备栏位中物品的名称
- **空栏位**：空字符串 ''

## 源码实现
```pascal
// uScriptManager.pas 第603行
end else if cmd = 'getsenderwearitemname' then begin
   Result := TBasicObject (FSender).SGetWearItemName (_StrToInt (Params [0]));
```

调用 `TBasicObject.SGetWearItemName`，按栏位编号获取装备名称。

## 使用示例

### 检查婚礼套装
```pascal
// 检查男性玩家是否穿上新郎套装
Sex := callfunc ('getsendersex');
if Sex = '1' then begin
    Str := callfunc ('getsenderwearitemname 6');
    if Str <> '新郎套装' then begin
        print ('say 唉？你的新郎套装为什么不穿上呢？');
        exit;
    end;
    print ('say 请进...');
end;
```
> 来源：`婚礼司仪.txt`

### 检查新娘套装
```pascal
// 检查女性玩家是否穿上新娘套装
if Sex = '2' then begin
    Str := callfunc ('getsenderwearitemname 6');
    if Str <> '新娘套装' then begin
        print ('say 唉？你的新娘套装为什么不穿上呢？');
        exit;
    end;
    print ('say 请进...');
end;
```
> 来源：`婚礼司仪.txt`

## 注意事项

1. **返回值格式**：返回物品名称字符串，空栏位返回空字符串
2. **栏位编号**：不同编号对应不同装备栏位，6 代表衣服/套装栏位
3. **精确匹配**：返回的是物品的完整名称，可用于精确比较

## 相关函数
- `getsenderitemcurdurability` - 获取装备当前耐久度
- `getsenderitemmaxdurability` - 获取装备最大耐久度
- `getsendersex` - 获取玩家性别
