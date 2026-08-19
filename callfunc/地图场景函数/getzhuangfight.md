# getzhuangfight

## 功能描述
获取触发者（玩家）所在门派的山庄领土瓜分战斗状态。仅门派掌门（Sysop）可以使用。

## 语法格式
```pascal
Str := callfunc('getzhuangfight');
```

## 参数说明
无参数。

## 返回值
- **无门派**：返回 '-1'（玩家没有门派）
- **非掌门**：返回 '-1'（玩家不是门派掌门）
- **无资格**：返回 '8'（门派不够资格）
- **已占领**：返回 '7'（该门派已执掌此领地）
- **其他**：返回 `Zhuang.AskConquer` 的结果值

## 源码实现
基于 `UUser.pas` 中的 `SGetAskConquer` 函数：

```pascal
function TUser.SGetAskConquer: String;
var GuildObject: TGuildObject;
begin
    result := '-1';
    if GuildName = '' then exit;
    GuildObject := GuildList.GetGuildObject(GuildName);
    if GuildObject = nil then Exit;
    if Not GuildObject.IsGuildSysop(GuildName) then Exit;
    result := IntToStr(Zhuang.AskConquer(GuildName));
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getzhuangfight' then begin
   Result := TBasicObject(FSender).SGetAskConquer;
```

## 使用示例

### 申请领土瓜分（来自聚贤庄庄主脚本）
```pascal
if aStr = 'fight' then begin
   // 先检查是否有领土瓜分牌
   Name := callfunc('getsenderitemexistence 领土瓜分牌:1');
   if Name = 'false' then begin
      print('say 你没有领土瓜分牌');
      exit;
   end;

   // 检查是否有资格申请
   Name := callfunc('getzhuangfight');
   if Name = '-1' then begin
      print('say 你没有权利申请领土瓜分');
      exit;
   end;
   if Name = '8' then begin
      print('say 虽然聚贤庄无人驻守，但你的门派也不够资格。');
      exit;
   end;
   if Name = '7' then begin
      print('say 贵派已经执掌此领地。');
      exit;
   end;

   // ... 继续领土瓜分逻辑 ...
end;
```

## 注意事项

1. **返回值类型**：返回字符串格式的数字
2. **权限检查**：
   - 玩家必须有门派（`GuildName` 不为空）
   - 玩家必须是门派掌门（`IsGuildSysop` 返回 true）
   - 不满足条件返回 '-1'
3. **无参数**：该函数不需要任何参数
4. **FSender 上下文**：操作的是触发者（玩家）
5. **返回值含义**：具体返回值由 `Zhuang.AskConquer` 决定，不同值代表不同的领土状态

## 相关函数
- `getintozhuang` - 进入山庄
- `getzhuangticketprice` - 获取山庄门票价格
