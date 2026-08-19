# getparty

获取当前触发脚本事件的玩家的组队信息，判断玩家是否处于组队状态。

## 语法
```pascal
Str := callfunc('getparty');
```

## 参数
无参数。

## 返回值
返回字符串：
- `'true'` — 玩家正在组队中
- `'false'` — 玩家未组队

## 源码实现
```pascal
Result := TBasicObject(FSender).SGetParty;
```

## 示例

### 婚礼司仪中的组队状态检查
基于 `婚礼司仪.txt`：
```pascal
Str := callfunc ('getparty');
xStr := callfunc ('getmarryclothes');
if xStr = 'true' then begin
    if Str = 'false' then begin
        // 玩家穿着结婚服装但未组队，允许进入婚礼场地
        Sex := callfunc ('getsendersex');
        if Sex = '1' then begin
            // 新郎入场逻辑
        end;
    end;
end;
```

## 注意事项
1. 在婚礼系统中用于检查玩家是否已组队，避免重复组队
2. 与 `setparty` 配合使用：先用 `getparty` 检查状态，再用 `setparty` 创建/加入组队
3. 返回值为字符串 `'true'`/`'false'`

## 相关函数
- `setparty` — 设置组队信息
- `getmarryinfo` — 获取结婚信息
- `getmarryclothes` — 获取结婚服装信息
