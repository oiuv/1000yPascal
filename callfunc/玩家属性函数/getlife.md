# getlife

获取当前脚本关联对象（自身）的生命值。注意：此函数操作的是 `FSelf`（脚本关联的对象，如怪物、NPC），而非触发事件的玩家。

## 语法
```pascal
Str := callfunc('getlife');
```

## 参数
无参数。

## 返回值
返回字符串，为对象当前生命值的整数形式。

## 源码实现
```pascal
Result := IntToStr(TBasicObject(FSelf).SGetLife);
```
基于 `FSelf`（脚本关联的对象本身）调用 `SGetLife`。

## 示例

### 霸王石中的生命值监控
基于 `霸王石.txt`：
```pascal
var
   Str : String;
   Life : Integer;
begin
   if n = 1 then exit;

   Str := callfunc ('getlife');
   Life := StrToInt (Str);

   if Life <= 50000 then begin
      print ('boiceallbyname 地下石巨人 monster false');
      print ('bohitallbyname 地下石巨人 monster true');
      n := 1;
      exit;
   end;
end;
```

## 注意事项
1. **重要区别**：`getlife` 获取的是脚本关联对象（FSelf）的生命值，通常是怪物或NPC自身；而 `getsenderlife` 获取的是触发事件的玩家的生命值
2. 常用于怪物脚本中监控自身生命值，当生命值低于阈值时触发特殊行为（如召唤援军、进入狂暴状态等）
3. 返回值需要 `StrToInt` 转换后才能进行数值比较

## 相关函数
- `getsenderlife` — 获取玩家当前活力值
- `getmaxlife` — 获取对象最大生命值
- `getsendermaxlife` — 获取玩家最大活力值
