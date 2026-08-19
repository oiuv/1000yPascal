# checkmagic

## 功能描述
检查玩家是否满足指定武功的修炼条件（是否已修炼该武功）。

## 语法格式
```pascal
Str := callfunc('checkmagic 武功类型 武功等级 武功名称');
```

## 参数说明
- **武功类型**：Integer - 武功的分类类型
  - 3：护身武功
- **武功等级**：Integer - 武功的等级要求
  - 9：最高等级
- **武功名称**：String - 要检查的武功名称

## 返回值
- **成功**：'true' - 玩家已修炼了该武功
- **失败**：'false' - 玩家未修炼该武功

## 源码实现
```pascal
// uScriptManager.pas 第629行
end else if cmd = 'checkmagic' then begin
   Result := TBasicObject (FSelf).SCheckMagic (_StrToInt (Params [0]), _StrToInt (Params [1]), Params [2]);
```

调用 `TBasicObject.SCheckMagic`，注意此处使用 `FSelf` 而非 `FSender`。

## 使用示例

### 检查四大神功修炼状态
```pascal
// 检查是否已修炼血天魔功
Str := callfunc ('checkmagic 3 9 血天魔功');
if Str = 'true' then begin
    print ('sendsenderchatmessage 已修炼了此武功 2');
    exit;
end;

print ('showwindow .\help\四大神功1.txt 0');
```
> 来源：`四大神功全集.txt`

### 检查日月神功
```pascal
Str := callfunc ('checkmagic 3 9 日月神功');
if Str = 'true' then begin
    print ('sendsenderchatmessage 已修炼了此武功 2');
    exit;
end;
```
> 来源：`四大神功全集.txt`

### 检查北冥神功
```pascal
Str := callfunc ('checkmagic 3 9 北冥神功');
if Str = 'true' then begin
    print ('sendsenderchatmessage 已修炼了此武功 2');
    exit;
end;
```
> 来源：`四大神功全集.txt`

### 检查紫霞神功
```pascal
Str := callfunc ('checkmagic 3 9 紫霞神功');
if Str = 'true' then begin
    print ('sendsenderchatmessage 已修炼了此武功 2');
    exit;
end;
```
> 来源：`四大神功全集.txt`

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'
2. **FSelf 而非 FSender**：此函数使用 `FSelf` 对象，与其他 `getsender*` 函数不同
3. **三个参数**：需要同时指定武功类型、等级和名称
4. **修炼检查**：主要用于检查玩家是否已经修炼了某个武功，避免重复修炼

## 相关函数
- `checksendercurusemagic` - 检查当前使用的武功
- `checkusemagicbygrade` - 按等级检查武功
- `getsendermagicskilllevel` - 获取武功技能等级
- `getsendermagiccountbyskill` - 获取武功数量
