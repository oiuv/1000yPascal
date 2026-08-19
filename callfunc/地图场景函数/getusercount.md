# getusercount

## 功能描述
获取指定地图内的玩家数量。

## 语法格式
```pascal
Str := callfunc('getusercount 地图编号');
```

## 参数说明
- **地图编号**：Integer - 要查询的地图 ServerID

## 返回值
- **成功**：返回地图内玩家数量（字符串格式的数字）
- **失败**：返回 '0'

## 源码实现
基于 `BasicObj.pas` 中的 `SGetUserCount` 函数：

```pascal
function TBasicObject.SGetUserCount(aID: Integer): Integer;
begin
   Result := 0;
   if UserList <> nil then
   begin
      Result := UserList.GetUserCountByManager(aID);
   end;
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getusercount' then begin
   Result := IntToStr(TBasicObject(FSelf).SGetUserCount(_StrToInt(Params[0])));
```

## 使用示例

### 检查地图是否有人（来自一级比武老人脚本）
```pascal
// 检查地图50内是否有玩家
Str := callfunc('getusercount 50');
iCount := StrToInt(Str);
if iCount > 0 then begin
   print('say 捕盗大将现在很忙');
   exit;
end;

// 检查地图51内是否有玩家
Str := callfunc('getusercount 51');
iCount := StrToInt(Str);
if iCount > 0 then begin
   print('say 捕盗大将现在很忙');
   exit;
end;
```

### 进入特殊地图前检查（来自上古雨中客脚本）
```pascal
// 检查禁区是否有人
Str := callfunc('getusercount 76');
iCount := StrToInt(Str);
if iCount > 0 then begin
   print('say 稍等._禁区好像有人');
   exit;
end;
```

### 多个地图检查（来自梅花夫人脚本）
```pascal
// 检查地图84和85的玩家数量
Str := callfunc('getusercount 84');
iCount := StrToInt(Str);
if iCount > 0 then begin
   print('say 里面有人，请稍等');
   exit;
end;

Str := callfunc('getusercount 85');
iCount := StrToInt(Str);
if iCount > 0 then begin
   print('say 里面有人，请稍等');
   exit;
end;
```

## 注意事项

1. **返回值类型**：返回字符串格式的数字，需要使用 `StrToInt()` 转换
2. **地图编号**：必须是有效的地图 ServerID，否则返回 0
3. **FSelf 上下文**：通过自身对象调用，但查询的是指定地图的玩家数量
4. **常见用途**：通常用于进入特殊地图（比武场、副本等）前检查是否已有玩家在内
5. **配合使用**：常与 `checkentermap`、`checkalivemopcount` 配合使用，确保地图状态正确

## 相关函数
- `checkentermap` - 检查是否可进入指定地图
- `checkalivemopcount` - 检查地图中存活怪物数量
- `getremainmaptime` - 获取地图剩余时间
