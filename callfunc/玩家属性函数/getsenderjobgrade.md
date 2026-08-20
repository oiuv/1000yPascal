# getsenderjobgrade

获取当前触发脚本事件的玩家职业等级。

## 语法
```pascal
Str := callfunc('getsenderjobgrade');
```

## 参数
无参数。

## 返回值
返回字符串，为玩家职业等级的整数形式。

## 源码实现
```pascal
Result := IntToStr(TBasicObject(FSender).SGetJobGrade);
```

## 示例

### 一级风兄中的职业等级检查
基于 `一级风兄.txt`：
```pascal
Name := callfunc ('getsenderjobgrade');
// 判断职业等级是否满足条件
```

### 技术梅花夫人中的职业等级检查
基于 `技术梅花夫人.txt`：
```pascal
Name := callfunc ('getsenderjobgrade');
// 配合职业类型和天赋值进行综合判断
```

### 神医中的职业等级检查
基于 `神医.txt`：
```pascal
Name := callfunc ('getsenderjobgrade');
// 检查玩家职业等级
```

## 注意事项
1. 职业等级与职业类型（`getsenderjobkind`）配合使用
2. 通常用于判断玩家是否达到某个职业阶段

## 相关函数
- `getsenderjobkind` — 获取玩家职业类型
- `getsendertalent` — 获取玩家天赋值
- `getjobgrade` — 未实现的历史名称，不应使用
