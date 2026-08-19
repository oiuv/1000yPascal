# getpassmissiontime

## 功能描述
获取玩家当前任务已经过的时间（分钟数）。

## 语法格式
```pascal
Str := callfunc('getpassmissiontime');
```

## 参数说明
- 无参数

## 返回值
- **整数（字符串）**：任务已经过的时间（分钟），取整后的值

## 源码实现
```pascal
// uScriptManager.pas 第574行
end else if cmd = 'getpassmissiontime' then begin
   Result := IntToStr(Trunc(TBasicObject (FSender).SGetPassMissionTime));
```

调用 `TBasicObject.SGetPassMissionTime`，返回浮点数经过 `Trunc` 取整后转为字符串。

## 使用示例

### 萧郎任务 - 检查任务超时
```pascal
// 检查玩家是否还持有任务物品
Name := callfunc ('getsenderitemexistence 血红色的玛瑙石:1');
if Name <> 'false' then begin
    Str1 := callfunc ('getpassmissiontime');
    print ('say 你怎么还没把玛瑙石送过去啊？要抓紧时间啊！ 100');
    Str1 := 'say 已经过去' + Str1;
    Str1 := Str1 + '分钟了！ 200';
    print (Str1);
    exit;
end;
```
> 来源：`萧郎.txt`

### 素莲任务 - 判断是否超时
```pascal
// 检查血石数量
Name := callfunc('getsenderitemexistence 血石:30');
if Name = 'false' then begin
    Str := 'say 这真的是萧郎让你交给我的玛瑙石么？怎么颜色这么暗淡？';
    print (Str);
    exit;
end;

// 检查任务用时
Str := callfunc ('getpassmissiontime');
nValue := StrToInt (Str);
if nValue > 30 then begin
    print ('getsenderitem 血红色的玛瑙石:1');
    Str := 'say 这真的是萧郎让你交给我的玛瑙石么？你不是骗子吧？';
    print (Str);
    exit;
end;
```
> 来源：`素莲.txt`

## 注意事项

1. **返回值格式**：返回字符串类型的整数（分钟数），需要 `StrToInt` 转换
2. **配合 startmissiontime 使用**：先通过 `startmissiontime` 开始计时，再用 `getpassmissiontime` 查询已过时间
3. **超时判断**：常用于限时任务中判断玩家是否在规定时间内完成
4. **取整处理**：源码中使用 `Trunc` 对浮点数取整
5. **无参数**：不需要传入任何参数

## 相关函数
- `startmissiontime` - 开始任务计时
- `getsenderitemexistence` - 检查物品是否存在
