# activebank

## 功能描述
激活门派银行。打开当前玩家所属门派的银行界面。

## 语法格式
```pascal
print('activebank');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'activebank' then begin
    TUser(aSender).GuildActiveBank;
```

直接调用玩家的 `GuildActiveBank` 方法。

## 使用示例

### 捕盗大将NPC提供银行服务
```pascal
// 来自 捕盗大将.txt - 玩家选择银行功能时激活门派银行
if aStr = 'activebank' then begin
   print ('activebank');
   exit;
end;
```

## 注意事项

1. **无参数**：此命令不需要任何参数
2. **作用于玩家**：通过 `aSender`（触发脚本的玩家）执行
3. **门派限制**：只有加入门派的玩家才能使用门派银行

## 相关命令
- `buymoneychip` — 购买门派银票
- `showwindow` — 显示窗口
