# getsenderserverid

获取当前触发脚本事件的玩家所在服务器ID。

## 语法
```pascal
Str := callfunc('getsenderserverid');
```

## 参数
无参数。

## 返回值
返回字符串，为玩家所在服务器的ID编号（整数形式）。

## 源码实现
```pascal
Result := IntToStr(TBasicObject(FSender).SGetServerId);
```

## 示例

### 3级黑捕校中的服务器ID检查
基于 `3级黑捕校.txt`：
```pascal
Str := callfunc ('getsenderserverid');
if Str <> '81' then exit;

Str := callfunc ('getsenderrace');
if Str <> '1' then exit;
```

### 2级牛俊中的服务器判断
基于 `2级牛俊.txt`：
```pascal
Str := callfunc ('getsenderserverid');
if Str <> '81' then exit;
// 仅在特定服务器上执行后续逻辑
```

## 注意事项
1. 服务器ID用于区分不同的游戏服务器实例
2. 常用于仅在特定服务器上执行的NPC逻辑
3. 通常与 `getsenderrace` 配合使用，先检查服务器再检查玩家种族

## 相关函数
- `getsenderrace` — 获取玩家种族
- `getsendercurpowerlevelname` — 获取玩家元气等级名称
- `getsendermapname` — 获取玩家所在地图名称
