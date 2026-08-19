# getremainmaptime

## 功能描述
检查指定地图的剩余时间是否已超过给定阈值。用于判断地图重置前的剩余时间是否充足。

## 语法格式
```pascal
Str := callfunc('getremainmaptime 剩余分钟 剩余秒');
```

## 参数说明
- **剩余分钟**：Integer - 分钟阈值，当实际剩余分钟小于此值时返回 'false'
- **剩余秒**：Integer - 秒阈值，当剩余小时和分钟都为 0 时，用此值与剩余秒比较

## 返回值
- **时间充足**：返回 'true'（剩余时间大于等于阈值）
- **时间不足**：返回 'false'（剩余时间小于阈值）

## 源码实现
基于 `BasicObj.pas` 中的 `SGetRemainMapTime` 函数：

```pascal
function TBasicObject.SGetRemainMapTime(aRemainMin, aRemainSec: Integer): string;
begin
   Result := 'false';

   if Manager.RegenInterval > 0 then
   begin
      if (Manager.RemainHour = 0) and (Manager.RemainMin = 0) then
      begin
         if aRemainSec > 0 then
         begin
            if aRemainSec < Manager.RemainSec then
            begin
               exit;
            end;
         end;
      end
      else
      begin
         if aRemainMin > 0 then
         begin
            if aRemainMin < Manager.RemainMin then
            begin
               exit;
            end;
         end;
      end;
   end;

   Result := 'true';
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getremainmaptime' then begin
   Result := TBasicObject(FSender).SGetRemainMapTime(
      _StrToInt(Params[0]), _StrToInt(Params[1]));
```

## 使用示例

### 进入特殊区域前检查时间（来自上古雨中客脚本）
```pascal
// 检查地图剩余时间是否大于5分钟0秒
Str := callfunc('getremainmaptime 5 0');
if Str = 'true' then begin
   // 时间不足，拒绝进入
   print('say 再会...');
   exit;
end;

// 继续检查其他条件
Str := callfunc('getsenderitemexistence 王陵守护印:1');
if Str = 'false' then begin
   print('say 手上没有王陵守护印吧...');
   exit;
end;
```

## 注意事项

1. **返回值类型**：返回字符串 'true' 或 'false'
2. **判断逻辑**：
   - 当 `Manager.RegenInterval > 0` 时进行时间检查
   - 如果剩余时间为 0 小时 0 分钟，则比较秒数
   - 否则比较分钟数
3. **FSender 上下文**：通过触发者（玩家）对象调用
4. **典型用途**：在地图即将重置前阻止玩家进入，避免进入后地图被重置
5. **参数含义**：参数是阈值，不是查询具体剩余时间

## 相关函数
- `checkentermap` - 检查是否可进入指定地图
- `getusercount` - 获取地图内用户数量
- `checkalivemopcount` - 检查地图中存活怪物数量
