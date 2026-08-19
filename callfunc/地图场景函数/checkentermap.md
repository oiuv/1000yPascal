# checkentermap

## 功能描述
检查指定地图是否允许进入。通过查询地图管理器的 `boEnter` 标志判断。

## 语法格式
```pascal
Str := callfunc('checkentermap 地图编号');
```

## 参数说明
- **地图编号**：Integer - 要检查的地图 ServerID

## 返回值
- **可以进入**：返回 'true'
- **不可进入**：返回 'false'（地图不存在或 `boEnter` 为 false）

## 源码实现
基于 `BasicObj.pas` 中的 `SCheckEnterMap` 函数：

```pascal
function TBasicObject.SCheckEnterMap(aServerID: Integer): string;
var
   tmpManager: TManager;
begin
   Result := 'false';

   tmpManager := ManagerList.GetManagerByServerID(aServerID);
   if tmpManager = nil then
      exit;
   if tmpManager.boEnter = false then
      exit;

   Result := 'true';
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'checkentermap' then begin
   Result := TBasicObject(FSender).SCheckEnterMap(_StrToInt(Params[0]));
```

## 使用示例

### 进入比武场前检查（来自一级比武老人脚本）
```pascal
// 检查地图50是否可进入
Str := callfunc('checkentermap 50');
if Str = 'false' then begin
   print('say 请稍后...');
   exit;
end;

// 通过检查后执行地图重置
print('mapregen 50');
```

### 进入禁区前检查（来自上古雨中客脚本）
```pascal
// 完整进入流程
Str := callfunc('getusercount 76');
iCount := StrToInt(Str);
if iCount > 0 then begin
   print('say 稍等._禁区好像有人');
   exit;
end;

Str := callfunc('checkalivemopcount 76 monster 禁地护卫武士');
iCount := StrToInt(Str);
if iCount = 0 then begin
   print('say 稍等...');
   exit;
end;

Str := callfunc('checkentermap 76');
if Str = 'false' then begin
   print('say 稍等片刻...');
   exit;
end;

print('say 小子_明年的今天就是你的忌日');
print('mapregen 76');
```

### 多个副本入口检查（来自捕盗大将脚本）
```pascal
// 检查地图78
Str := callfunc('checkentermap 78');
if Str = 'false' then begin
   print('say 请稍后...');
   exit;
end;

// 检查地图79
Str := callfunc('checkentermap 79');
if Str = 'false' then begin
   print('say 请稍后...');
   exit;
end;
```

## 注意事项

1. **返回值类型**：返回字符串 'true' 或 'false'
2. **判断条件**：
   - 地图管理器必须存在（`GetManagerByServerID` 返回非 nil）
   - 地图的 `boEnter` 标志必须为 true
3. **FSender 上下文**：通过触发者（玩家）对象调用
4. **典型用途**：在进入特殊地图（比武场、副本等）前检查地图状态
5. **配合使用**：通常与 `getusercount`、`checkalivemopcount`、`mapregen` 配合使用

## 相关函数
- `getusercount` - 获取地图内用户数量
- `getremainmaptime` - 获取地图剩余时间
- `checkalivemopcount` - 检查地图中存活怪物数量
