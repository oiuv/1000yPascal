# checksenderpowerwearitem

## 功能描述
检查玩家是否穿戴了带有力量属性的装备（技能装备）。脚本中调用名称为 `checksenderpowerwearitem`。

## 语法格式
```pascal
Str := callfunc('checksenderpowerwearitem');
```

## 参数说明
- 无参数

## 返回值
- **整数（字符串）**：大于 0 表示玩家穿戴了力量属性装备，0 表示没有

## 源码实现
```pascal
// uScriptManager.pas 第619行
end else if cmd = 'checksenderpowerwearitem' then begin
   Result := IntToStr (TBasicObject (FSender).SCheckPowerWearItem);
```

调用 `TBasicObject.SCheckPowerWearItem`，返回整数结果转为字符串。

## 使用示例

### 比武场检查（禁止穿戴技能装备）
```pascal
// 检查是否穿戴力量属性装备
Str := callfunc ('checksenderpowerwearitem');
iCount := StrToInt (Str);
if iCount > 0 then begin
    print ('say 为了公平起见,请脱掉将技能装备');
    exit;
end;
```
> 来源：`一级比武老人.txt`

### 比武NPC通用检查
```pascal
Str := callfunc ('checksenderpowerwearitem');
iCount := StrToInt (Str);
if iCount > 0 then begin
    print ('say 为了公平起见,请脱掉将技能装备');
    exit;
end;
```
> 来源：`捕盗大将.txt`、`梅花夫人.txt`、`牛俊.txt`、`老侠客.txt` 等多个比武NPC

## 注意事项

1. **调用名称**：仅使用源码实际注册的 `checksenderpowerwearitem`
2. **返回值格式**：返回字符串类型的整数，需要 `StrToInt` 转换后判断
3. **比武场使用**：广泛用于比武场景中，确保玩家不穿戴加成装备以保证公平
4. **无参数**：不需要传入任何参数

## 相关函数
- `checksenderattribitem` - 检查属性物品
- `getsenderwearitemname` - 获取装备名称
- `getsendercurpowerlevelname` - 获取当前功力等级名称
