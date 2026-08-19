# setmarryclothes

## 功能描述
设置玩家的结婚服装已领取标记。在结婚系统中记录玩家（新郎/新娘）已领取婚礼套装，防止重复领取。

## 语法格式
```pascal
print('setmarryclothes');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'setmarryclothes' then begin
   MarryList.SetClothes(TUser(aSender).Name);
```

`TMarryClass.SetClothes` 实现在 `svClass.pas` 中：

```pascal
procedure TMarryClass.SetClothes(aName: String);
var
   pMarry: PTMarry;
   i: integer;
begin
   for i := 0 to FMarryList.Count - 1 do begin
      pMarry := FMarryList.Items[i];
      if pMarry^.Girl = aName then begin
         pMarry^.GirlClothes := True;
         Exit;
      end;
      if pMarry^.Boy = aName then begin
         pMarry^.BoyClothes := True;
         Exit;
      end;
   end;
end;
```

## 使用示例

### 婚礼司仪脚本（真实示例）
来自 `bin/Script/婚礼司仪.txt`：

```pascal
// 新郎领取婚礼套装
if Sex = '1' then begin
   Str := callfunc ('getsenderitemexistence 新郎戒指:1');
   if Str = 'false' then begin
      print ('say 唉？你的新郎戒指为什么不穿上呢？');
      exit;
   end;
   Str := callfunc ('getmarryinfo');
   if Str = 'false' then begin
      print ('say 你还没有结婚，不能领取新婚套装');
      exit;
   end;
   print ('getsenderitem 新郎戒指:1');
   print ('putsendermagicitem 新郎套装:1 @婚礼司仪 4');
   print ('setmarryclothes');
end;

// 新娘领取婚礼套装
if Sex = '2' then begin
   Str := callfunc ('getsenderitemexistence 新娘戒指:1');
   if Str = 'false' then begin
      print ('say 唉？你的新娘戒指为什么不穿上呢？');
      exit;
   end;
   Str := callfunc ('getmarryinfo');
   if Str = 'false' then begin
      print ('say 你还没有结婚，不能领取新婚套装');
      exit;
   end;
   print ('getsenderitem 新娘戒指:1');
   print ('putsendermagicitem 新娘套装:1 @婚礼司仪 4');
   print ('setmarryclothes');
end;
```

## 注意事项

1. **标记不可逆**：一旦设置，结婚服装领取标记为 True，不可重置
2. **防止重复领取**：配合 `getmarryclothes` 函数使用，在发放前检查是否已领取
3. **需要已婚状态**：玩家必须在结婚列表中才能生效，否则遍历无结果
4. **自动识别性别**：系统自动根据玩家名字匹配新郎或新娘记录

## 相关命令
- `marry` - 结婚
- `unmarry` - 离婚
- `getmarryclothes` - 查询是否已领取结婚服装（callfunc 函数）
- `getmarryinfo` - 查询结婚信息（callfunc 函数）
