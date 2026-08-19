# getsendermagiccountbyskill

## 功能描述
按技能类型获取玩家已学会的武功数量。

## 语法格式
```pascal
Str := callfunc('getsendermagiccountbyskill 技能类型 参数2');
```

## 参数说明
- **技能类型**：Integer - 武功的技能类型编号
- **参数2**：Integer - 附加参数

## 返回值
- **整数（字符串）**：对应技能类型的武功数量

## 源码实现
```pascal
// uScriptManager.pas 第611行
end else if cmd = 'getsendermagiccountbyskill' then begin
   Result := TBasicObject (FSender).SGetMagicCountBySkill (_StrToInt (Params [0]), _StrToInt (Params [1]));
```

调用 `TBasicObject.SGetMagicCountBySkill`，按技能类型统计玩家已学会的武功数量。

## 使用示例

### 查询武功数量
```pascal
// 获取指定技能类型的武功数量
Str := callfunc ('getsendermagiccountbyskill 1 0');
nCount := StrToInt (Str);
if nCount > 0 then begin
    print ('say 你已学会了相关武功');
end;
```

## 注意事项

1. **返回值格式**：返回字符串类型的整数，需要 `StrToInt` 转换
2. **脚本中未发现使用**：在现有脚本目录中未找到此函数的实际使用示例
3. **两个参数**：需要传入技能类型和附加参数

## 相关函数
- `getsendermagicskilllevel` - 获取武功技能等级
- `checksendercurusemagic` - 检查当前使用的武功
- `checkmagic` - 检查武功修炼条件
