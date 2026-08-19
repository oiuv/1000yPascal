# getsendercurpowerlevelname

获取当前触发脚本事件的玩家元气等级名称。

## 语法
```pascal
Str := callfunc('getsendercurpowerlevelname');
```

## 参数
无参数。

## 返回值
返回字符串，为玩家当前元气等级的名称。若玩家无元气等级，返回空字符串。

## 源码实现
```pascal
Result := TBasicObject(FSender).SGetCurPowerLevelName;
```

## 示例

### 3级黑捕校中的元气等级名称检查
基于 `3级黑捕校.txt`：
```pascal
Str := callfunc ('getsendercurpowerlevelname');
if Str <> '' then begin
    print ('say 禁止开镜进入');
    Name := callfunc ('getsendername');
    Str := 'movespace ' + Name;
    Str := Str + ' user 1 305 371 100';
    print (Str);
    exit;
end;
```

### 3级捕盗大将中的元气等级检查
基于 `3级捕盗大将.txt`：
```pascal
Str := callfunc ('getsendercurpowerlevelname');
if Str <> '' then begin
    // 已有元气等级的玩家不允许进入
    print ('say 禁止开镜进入');
    exit;
end;
```

## 注意事项
1. 返回空字符串表示玩家尚未获得元气等级
2. 常用于限制已开镜（拥有元气等级）的玩家进入特定区域
3. 与 `getsendercurpowerlevel` 的区别：本函数返回名称字符串，后者返回数值

## 相关函数
- `getsendercurpowerlevel` — 获取玩家元气等级数值
- `getsendername` — 获取玩家名称
- `getsenderserverid` — 获取玩家所在服务器ID
