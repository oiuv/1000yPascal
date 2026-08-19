# getsendercurpowerlevel

获取当前触发脚本事件的玩家元气等级（数值）。

## 语法
```pascal
Str := callfunc('getsendercurpowerlevel');
```

## 参数
无参数。

## 返回值
返回字符串，为玩家当前元气等级的整数形式。数值越大表示元气等级越高。

## 源码实现
```pascal
Result := IntToStr(TBasicObject(FSender).SGetCurPowerLevel);
```

## 示例

### quest风兄中的元气等级判断
基于 `quest风兄.txt`：
```pascal
Str := callfunc ('getsendercurpowerlevel');
nPower := StrToInt (Str);

if nPower < 1 then begin
    print ('showwindow .\help\quest风兄2.txt 1');
    exit;
end;

if nPower >= 1 then begin
    print ('getsenderitem 神秘箱子:1');
    // 根据元气等级给予奖励
end;
```

### quest铁匠中的元气等级检查
基于 `quest铁匠.txt`：
```pascal
Str := callfunc ('getsendercurpowerlevel');
// 判断元气等级是否满足任务要求
```

## 注意事项
1. 元气等级是玩家修炼实力的体现，用于判断玩家是否满足某些高级任务或区域的准入条件
2. 与 `getsendercurpowerlevelname` 配合使用，后者返回等级名称而非数值
3. 某些 NPC 会检查元气等级，禁止高等级（开镜）玩家进入特定区域

## 相关函数
- `getsendercurpowerlevelname` — 获取玩家元气等级名称
- `getsenderjobkind` — 获取玩家职业类型
- `checksenderpowerwearitem` — 检查玩家是否穿戴属性装备
