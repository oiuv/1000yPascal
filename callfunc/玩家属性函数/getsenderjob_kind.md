# getsenderjobkind

获取当前触发脚本事件的玩家职业类型。

## 语法
```pascal
Str := callfunc('getsenderjobkind');
```

## 参数
无参数。

## 返回值
返回字符串，为职业类型编号：
- `'0'` — 无职业（平民）
- `'4'` — 工匠
- 其他值对应不同职业类型

## 源码实现
```pascal
Result := IntToStr(TBasicObject(FSender).SGetJobKind);
```

## 示例

### 一级风兄中的职业判断
基于 `一级风兄.txt`：
```pascal
Name := callfunc ('getsenderjobkind');
if Name = '4' then begin
    print ('say 您已经是工匠了');
    exit;
end;
if Name <> '0' then begin
    print ('say 不能学习其他技能');
    exit;
end;
```

### 龙师父中的职业检查
基于 `龙师父.txt`：
```pascal
JobKind := callfunc ('getsenderjobkind');
if JobKind = '0' then begin
    print ('say 일琴_뻘청斡撚켱？');
    exit;
end;
```

### 神医中的职业检查
基于 `神医.txt`：
```pascal
JobKind := callfunc ('getsenderjobkind');
if JobKind = '0' then begin
    // 无职业玩家，拒绝服务
    exit;
end;
```

## 注意事项
1. 每个玩家只能拥有一种职业，已有职业后不能学习其他职业
2. 职业类型为 `'0'` 表示尚未选择职业的平民玩家
3. 通常与 `getsenderjobgrade`、`getsendertalent` 配合使用

## 相关函数
- `getsenderjobgrade` — 获取玩家职业等级
- `getsendertalent` — 获取玩家天赋值
- `setsenderjobkind` — 设置玩家职业类型
