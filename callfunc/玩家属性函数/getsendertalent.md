# getsendertalent

获取当前触发脚本事件的玩家天赋值。

## 语法
```pascal
Str := callfunc('getsendertalent');
```

## 参数
无参数。

## 返回值
返回字符串，为玩家天赋值的整数形式。天赋值越高表示玩家天赋越好。

## 源码实现
```pascal
Result := IntToStr(TBasicObject(FSender).SGetTalent);
```

## 示例

### 龙师父中的天赋检查
基于 `龙师父.txt`：
```pascal
Str := callfunc ('getsendertalent');
if Str < '9998' then begin
    print ('showwindow .\help\龙师父2.txt 1');
    exit;
end;
```

### 一级风兄中的天赋检查
基于 `一级风兄.txt`：
```pascal
Name := callfunc ('getsendertalent');
// 配合职业类型和职业等级一起判断玩家是否满足条件
```

### 神医中的天赋检查
基于 `神医.txt`：
```pascal
Name := callfunc ('getsendertalent');
if Str < '9998' then begin
    // 天赋不足，提示玩家
    exit;
end;
```

## 注意事项
1. 天赋值是玩家的固有属性，通常在创建角色时确定
2. 常见的使用场景是检查天赋值是否达到某个阈值（如 9998）
3. 通常与 `getsenderjobkind`、`getsenderjobgrade` 配合使用进行职业判定

## 相关函数
- `getsenderjobkind` — 获取玩家职业类型
- `getsenderjobgrade` — 获取玩家职业等级
- `getsendervirtue` — 获取玩家品德值
