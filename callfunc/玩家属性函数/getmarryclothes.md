# getmarryclothes

获取当前触发脚本事件的玩家的结婚服装信息，判断玩家是否穿着结婚服装。

## 语法
```pascal
Str := callfunc('getmarryclothes');
```

## 参数
无参数。

## 返回值
返回字符串：
- `'true'` — 玩家穿着结婚服装
- `'false'` — 玩家未穿着结婚服装

## 源码实现
```pascal
Result := TBasicObject(FSender).SGetMarryClothes;
```

## 示例

### 婚礼司仪中的结婚服装检查
基于 `婚礼司仪.txt`：
```pascal
xStr := callfunc ('getmarryclothes');
if xStr = 'true' then begin
    if Str = 'false' then begin
        Sex := callfunc ('getsendersex');
        if Sex = '1' then begin
            Str := callfunc ('getsenderwearitemname 6');
            if Str <> '新郎套装' then begin
                print ('say 唉？你的新郎套装为什么不穿上呢？');
                exit;
            end;
            print ('say 请进...');
            Name := callfunc ('setparty');
            // 传送进入婚礼场地
        end;
        if Sex = '2' then begin
            Str := callfunc ('getsenderwearitemname 6');
            if Str <> '新娘套装' then begin
                print ('say 唉？你的新娘套装为什么不穿上呢？');
                exit;
            end;
            print ('say 请进...');
            Name := callfunc ('setparty');
            // 传送进入婚礼场地
        end;
    end;
end;
```

### 婚礼司仪中的另一处检查
基于 `婚礼司仪.txt`：
```pascal
Str := callfunc ('getmarryclothes');
// 判断玩家是否穿着结婚服装
```

## 注意事项
1. 用于婚礼 NPC 脚本中，检查玩家是否穿着新郎/新娘套装
2. 穿着结婚服装的玩家可以通过特殊通道进入婚礼场地
3. 通常与 `getsenderwearitemname` 配合，进一步确认具体穿着的服装名称
4. 与 `getparty`/`setparty` 配合使用管理婚礼组队状态

## 相关函数
- `getmarryinfo` — 获取结婚信息
- `getsenderwearitemname` — 获取玩家穿戴物品名称
- `getparty` — 获取组队信息
- `setparty` — 设置组队信息
