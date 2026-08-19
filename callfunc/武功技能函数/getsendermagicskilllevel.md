# getsendermagicskilllevel

## 功能描述
获取玩家指定武功的技能等级。

## 语法格式
```pascal
Str := callfunc('getsendermagicskilllevel 武功名称');
```

## 参数说明
- **武功名称**：String - 要查询的武功名称

## 返回值
- **整数（字符串）**：武功的技能等级数值

## 源码实现
```pascal
// uScriptManager.pas 第542行
end else if cmd = 'getsendermagicskilllevel' then begin
   Result := IntToStr (TBasicObject (FSender).SGetMagicSkillLevel (Params [0]));
```

调用 `TBasicObject.SGetMagicSkillLevel`，按武功名称获取技能等级，返回整数转为字符串。

## 使用示例

### 查询武功等级
```pascal
// 获取指定武功的技能等级
Str := callfunc ('getsendermagicskilllevel 太极拳');
nLevel := StrToInt (Str);
if nLevel >= 9999 then begin
    print ('say 你的太极拳已经修炼到大成');
end;
```

## 注意事项

1. **返回值格式**：返回字符串类型的整数，需要 `StrToInt` 转换
2. **脚本中未发现使用**：在现有脚本目录中未找到此函数的实际使用示例
3. **武功名称**：传入武功的完整名称进行查询
4. **特殊等级**：9999 通常代表绝世武功的满级状态

## 相关函数
- `getsendermagiccountbyskill` - 按技能获取武功数量
- `checksendercurusemagic` - 检查当前使用的武功
- `getsenderuseattackskilllevel` - 获取当前攻击武功技能等级
