# buymoneychip

## 功能描述
购买门派银票。打开门派银票购买界面。

## 语法格式
```pascal
print('buymoneychip');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'buymoneychip' then begin
    TUser(aSender).GuildBuyMoneyChip;
```

直接调用玩家的 `GuildBuyMoneyChip` 方法。

## 使用示例

### 捕盗大将NPC提供银票购买
```pascal
// 来自 捕盗大将.txt - 玩家选择购买银票时
if aStr = 'buymoneychip' then begin
   print ('buymoneychip');
   exit;
end;
```

## 注意事项

1. **无参数**：此命令不需要任何参数
2. **作用于玩家**：通过 `aSender`（触发脚本的玩家）执行
3. **门派限制**：只有加入门派的玩家才能购买门派银票
4. **通常与 activebank 配合**：在同一 NPC 处提供银行和银票服务

## 相关命令
- `activebank` — 激活门派银行
- `showwindow` — 显示窗口
