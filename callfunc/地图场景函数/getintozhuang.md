# getintozhuang

## 功能描述
检查触发者（玩家）是否可以进入山庄（聚贤庄），并返回检查结果。

## 语法格式
```pascal
Str := callfunc('getintozhuang');
```

## 参数说明
无参数。

## 返回值
- **可以进入**：返回 'ok'
- **没有进门券**：返回 'noticket'（或 'NoTicket'）

## 源码实现
基于 `UUser.pas` 中的 `SGetZhuangInto` 函数：

```pascal
function TUser.SGetZhuangInto: String;
begin
   Result := Zhuang.GetZhuangInto(self);
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getintozhuang' then begin
   Result := TBasicObject(FSender).SGetZhuangInto;
```

## 使用示例

### 进入山庄（来自聚贤庄庄主脚本）
```pascal
if aStr = 'into' then begin
   Name := callfunc('getintozhuang');
   if Name = 'noticket' then begin
      print('say 你没有进门券,不能进入');
      exit;
   end;
   if Name = 'ok' then begin
      print('say 请进');
      Name := callfunc('getsendername');
      Str := 'movespace ' + Name;
      Str := Str + ' user 1 232 898 80';
      print(Str);
      exit;
   end;
   exit;
end;
```

## 注意事项

1. **返回值类型**：返回字符串，可能的值为 'ok' 或 'noticket'
2. **无参数**：该函数不需要任何参数
3. **FSender 上下文**：操作的是触发者（玩家）
4. **进门券**：玩家需要先购买"聚贤庄进门券"才能进入，可通过 `getzhuangticketprice` 获取门票价格
5. **配合 movespace**：检查通过后通常配合 `movespace` 将玩家传送到山庄地图

## 相关函数
- `getzhuangticketprice` - 获取山庄门票价格
- `getzhuangfight` - 获取山庄战斗（领土瓜分）状态
