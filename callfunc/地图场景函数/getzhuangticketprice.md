# getzhuangticketprice

## 功能描述
获取进入山庄（聚贤庄）所需的门票价格（钱币数量）。

## 语法格式
```pascal
Str := callfunc('getzhuangticketprice');
```

## 参数说明
无参数。

## 返回值
- **成功**：返回门票价格（字符串格式的数字），默认值为 '50000'

## 源码实现
基于 `UUser.pas` 中的 `SGetZhuangTicketPrice` 函数：

```pascal
function TUser.SGetZhuangTicketPrice: String;
begin
   Result := IntToStr(Zhuang.GetTicketPrice);
end;
```

在 `BasicObj.pas` 中的基础实现（默认值）：
```pascal
function TBasicObject.SGetZhuangTicketPrice: string;
begin
   Result := '50000';
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getzhuangticketprice' then begin
   Result := TBasicObject(FSender).SGetZhuangTicketPrice;
```

## 使用示例

### 购买山庄进门券（来自聚贤庄庄主脚本）
```pascal
if aStr = 'salesell' then begin
   // 获取门票价格
   Str2 := callfunc('getzhuangticketprice');

   // 检查玩家是否有足够钱币
   Str1 := 'getsenderitemexistence 钱币:' + Str2;
   Name := callfunc(Str1);
   if Name = 'false' then begin
      Str := 'say 你没有足够的钱币？';
      print(Str);
      exit;
   end;

   // 检查物品栏空间
   Name := callfunc('checkenoughspace');
   if Name = 'false' then begin
      print('say 物品栏已满');
      exit;
   end;

   // 扣除钱币，给予进门券
   Str1 := 'getsenderitem 钱币:' + Str2;
   print(Str1);
   print('putsendermagicitem 聚贤庄进门券:1 @聚贤庄庄主 4');

   Str := 'say 花费了' + Str2;
   Str := Str + '钱币';
   print(Str);
   exit;
end;
```

## 注意事项

1. **返回值类型**：返回字符串格式的数字，可直接拼接到其他命令中
2. **无参数**：该函数不需要任何参数
3. **默认价格**：基础实现返回 50000 钱币，实际价格由 `Zhuang.GetTicketPrice` 动态决定
4. **FSender 上下文**：通过触发者（玩家）对象调用
5. **动态拼接**：返回值通常用于动态构建 `getsenderitemexistence` 和 `getsenderitem` 命令

## 相关函数
- `getintozhuang` - 进入山庄
- `getzhuangfight` - 获取山庄战斗状态
- `getsenderitemexistence` - 检查玩家是否拥有物品
