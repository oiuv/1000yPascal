# getintoarena

## 功能描述
让触发者（玩家）进入指定的竞技场。

## 语法格式
```pascal
Str := callfunc('getintoarena 竞技场编号');
```

## 参数说明
- **竞技场编号**：Integer - 竞技场的 Key 编号（如 0 表示第一个竞技场）

## 返回值
- **成功**：返回 0 或正整数（加入成功）
- **擂台已满**：返回 -1
- **没有招亲活动**：返回 -2
- **正在参加其他擂台**：返回 -3

## 源码实现
基于 `UUser.pas` 中的 `SGetIntoArenaGame` 函数：

```pascal
function TUser.SGetIntoArenaGame(aArenaKey: Word): Integer;
begin
    Result := ArenaObjList.AddMember(aArenaKey, self);
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getintoarena' then begin
   Result := IntToStr(TBasicObject(FSender).SGetIntoArenaGame(_StrToInt(Params[0])));
```

## 使用示例

### 进入竞技场（来自捕盗大将脚本）
```pascal
if aStr = 'intoarena' then begin
   Str := callfunc('getintoarena 0');
   if Str = '-1' then begin
      print('say 擂台激战正酣！');
      exit;
   end;
   if Str = '-2' then begin
      print('say 该擂台没有招亲活动！');
      exit;
   end;
   if Str = '-3' then begin
      print('say 你正在参加其他擂台活动！');
      exit;
   end;
end;
```

## 注意事项

1. **返回值类型**：返回字符串格式的数字
2. **错误码含义**：
   - `-1`：擂台已满，无法加入
   - `-2`：该竞技场没有进行中的招亲活动
   - `-3`：玩家正在参加其他擂台活动
3. **FSender 上下文**：操作的是触发者（玩家）
4. **配合 getstartarena**：通常由 NPC 调用 `getstartarena` 开启擂台，玩家调用 `getintoarena` 加入

## 相关函数
- `getstartarena` - 开始竞技场战斗
- `getaddmember` - 添加竞技场成员
