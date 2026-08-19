# getpossiblegrade

## 功能描述
检查玩家是否满足武功升级的条件（是否有满级的指定等级武功）。

## 语法格式
```pascal
Str := callfunc('getpossiblegrade 参数1 参数2');
```

## 参数说明
- **参数1**：Integer - 武功类型/分组
  - 0：普通武功类型
- **参数2**：Integer - 目标等级
  - 0：检查是否有满1级的神功（2级任务）
  - 1：检查是否有满2级的神功（3级任务）

## 返回值
- **成功**：'true' - 玩家满足升级条件
- **失败**：'false' - 玩家不满足升级条件

## 源码实现
```pascal
// uScriptManager.pas 第589行
end else if cmd = 'getpossiblegrade' then begin
   Result := TBasicObject (FSender).SGetPossibleGrade(_StrToInt(Params[0]),_StrToInt(Params[1]));
```

调用 `TBasicObject.SGetPossibleGrade`，检查玩家是否有满足条件的满级武功。

## 使用示例

### 2级任务条件检查（需要满1级神功）
```pascal
// 检查是否有满1级的神功
Str := callfunc ('getpossiblegrade 0 0');
if Str = 'false' then begin
    print ('say 要有一个满1级的神功 50');
    exit;
end;
```
> 来源：`老侠客.txt`

### 3级任务条件检查（需要满2级神功）
```pascal
// 检查是否有满2级的神功
Str := callfunc ('getpossiblegrade 0 1');
if Str = 'false' then begin
    print ('say 要有满2级神功 50');
    exit;
end;
```
> 来源：`老侠客.txt`

### 完整的升级任务接取流程
```pascal
// 1. 检查是否已在做升级任务
Str := callfunc ('gethavegradequestitem');
if Str = 'true' then begin
    print ('say 你已经在做升级任务 50');
    exit;
end;

// 2. 检查武功等级条件
Str := callfunc ('getpossiblegrade 0 0');
if Str = 'false' then begin
    print ('say 要有一个满1级的神功 50');
    exit;
end;

// 3. 检查背包空间
Str := callfunc ('checkenoughspace 1');
if Str = 'false' then begin
    print ('say 要空出一个物品栏栏位');
    exit;
end;

// 4. 检查金元
Str := callfunc ('getsenderitemexistence 金元:60');
if Str = 'false' then begin
    print ('say 要接2级任务,需支付60个金元 50');
    exit;
end;

// 5. 扣除金元，给予任务卷轴
print ('getsenderitem 金元:60');
print ('putsendermagicitem 侠客任务卷轴:1 @老侠客 4');
```
> 来源：`老侠客.txt`

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'
2. **参数含义**：第一个参数为武功类型，第二个参数为目标等级
3. **任务前置条件**：用于检查玩家是否满足升级任务的前置武功等级要求
4. **配合使用**：通常与 `gethavegradequestitem`、`checkenoughspace`、`getsenderitemexistence` 配合使用

## 相关函数
- `gethavegradequestitem` - 获取等级任务物品状态
- `checksendercurusemagic` - 检查当前使用的武功
- `getsendermagicskilllevel` - 获取武功技能等级
