# gethavegradequestitem

## 功能描述
检查玩家是否已持有等级任务物品（即是否已在进行升级任务）。

## 语法格式
```pascal
Str := callfunc('gethavegradequestitem');
```

## 参数说明
- 无参数

## 返回值
- **成功**：'true' - 玩家已持有等级任务物品（正在做升级任务）
- **失败**：'false' - 玩家没有等级任务物品（未在做升级任务）

## 源码实现
```pascal
// uScriptManager.pas 第587行
end else if cmd = 'gethavegradequestitem' then begin
   Result := TBasicObject (FSender).SGetHaveGradeQuestItem;
```

调用 `TBasicObject.SGetHaveGradeQuestItem`，检查玩家背包中是否有等级升级任务物品。

## 使用示例

### 2级任务接取检查
```pascal
// 检查是否已在做升级任务
Str := callfunc ('gethavegradequestitem');
if Str = 'true' then begin
    print ('say 你已经在做升级任务 50');
    exit;
end;

// 检查是否有满1级的神功
Str := callfunc ('getpossiblegrade 0 0');
if Str = 'false' then begin
    print ('say 要有一个满1级的神功 50');
    exit;
end;

// 检查背包空间
Str := callfunc ('checkenoughspace 1');
if Str = 'false' then begin
    print ('say 要空出一个物品栏栏位');
    exit;
end;

// 检查金元
Str := callfunc ('getsenderitemexistence 金元:60');
if Str = 'false' then begin
    print ('say 要接2级任务,需支付60个金元 50');
    exit;
end;

print ('getsenderitem 金元:60');
print ('putsendermagicitem 侠客任务卷轴:1 @老侠客 4');
print ('say 等你的好消息 0');
```
> 来源：`老侠客.txt`

### 3级任务接取检查
```pascal
Str := callfunc ('gethavegradequestitem');
if Str = 'true' then begin
    print ('say 你已经在做升级任务 50');
    exit;
end;

Str := callfunc ('getpossiblegrade 0 1');
if Str = 'false' then begin
    print ('say 要有满2级神功 50');
    exit;
end;
```
> 来源：`老侠客.txt`

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'
2. **任务互斥**：用于防止玩家同时接取多个升级任务
3. **无参数**：不需要传入任何参数
4. **配合使用**：通常与 `getpossiblegrade`、`checkenoughspace`、`getsenderitemexistence` 配合使用

## 相关函数
- `getpossiblegrade` - 获取可能等级
- `getquestitem` - 获取任务物品
- `checkenoughspace` - 检查背包空间
