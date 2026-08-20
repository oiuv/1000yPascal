# setsendervirtueman

## 功能描述
给予玩家神工等级。调用玩家职业类的 SetVirtueman 方法，将玩家当前职业提升至神工级别。

## 语法格式
```pascal
print('setsendervirtueman');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'setsendervirtueman' then begin
   TBasicObject (aSender).SSetVirtueman;
```

`TUser.SSetVirtueman` 实现在 `UUser.pas` 中：

```pascal
procedure TUser.SSetVirtueman;
begin
   if (HaveJobClass.JobKind < 1) or (HaveJobClass.JobKind > JOB_KIND_MAX) then exit;
   HaveJobClass.SetVirtueman;
end;
```

## 使用示例

### 龙师父脚本（真实示例）
来自神武线上与炎黄随包的 `龙师父.txt`：

```pascal
print ('getsenderitem 技术密笈:1');
print ('setsendervirtueman');
print ('showwindow .\help\龙师父4.txt 1');
exit;
```

玩家完成龙师父的任务后，获得神工等级提升。

## 注意事项

1. **需要职业**：玩家必须拥有有效职业（JobKind 在 1 到 JOB_KIND_MAX 之间），否则命令不执行
2. **无参数**：命令不接受参数，直接调用职业类的 SetVirtueman 方法
3. **前置条件**：通常需要配合任务系统使用，在玩家完成特定任务后才给予神工等级
4. **职业限制**：只对已有职业的玩家生效，无职业玩家调用无效

## 相关命令
- `setsenderjobkind` - 设置玩家职业类型
- `getsenderjobkind` - 获取玩家当前职业类型
