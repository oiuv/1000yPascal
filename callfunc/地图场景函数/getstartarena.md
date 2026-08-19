# getstartarena

## 功能描述
让触发者（玩家）开始一场竞技场战斗（成为擂主）。

## 语法格式
```pascal
Str := callfunc('getstartarena');
```

## 参数说明
无参数。

## 返回值
- **成功**：返回 0 或正整数
- **擂台已满**：返回 -1

## 源码实现
基于 `UUser.pas` 中的 `SStartArenaGame` 函数：

```pascal
function TUser.SStartArenaGame: Integer;
begin
    Result := ArenaObjList.AddMaster(self);
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getstartarena' then begin
   Result := IntToStr(TBasicObject(FSender).SStartArenaGame);
```

## 使用示例

### 开始擂台（来自捕盗大将脚本）
```pascal
if aStr = 'startarena' then begin
   Str := callfunc('getstartarena');
   if Str = '-1' then begin
      print('say 擂台已满.');
   end;
   exit;
end;
```

### 婚礼抛绣球（来自婚礼司仪脚本）
```pascal
Str := callfunc('getstartarena');
if Str = '-1' then begin
   print('say 擂台已满.');
   exit;
end;
print('say 你的绣球已经抛出，正在等待应擂者');
```

## 注意事项

1. **返回值类型**：返回字符串格式的数字
2. **无参数**：该函数不需要参数
3. **擂主身份**：调用此函数的玩家将成为擂主（Master）
4. **FSender 上下文**：操作的是触发者（玩家）
5. **配合 getintoarena**：擂主通过 `getstartarena` 开启擂台，其他玩家通过 `getintoarena` 加入

## 相关函数
- `getintoarena` - 进入竞技场（作为挑战者）
- `getaddmember` - 添加竞技场成员
