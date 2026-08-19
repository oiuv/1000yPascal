# getmarryinfo

获取当前触发脚本事件的玩家的结婚信息，判断玩家是否已结婚。

## 语法
```pascal
Str := callfunc('getmarryinfo');
```

## 参数
无参数。

## 返回值
返回字符串：
- `'true'` — 玩家已结婚
- `'false'` — 玩家未结婚

## 源码实现
```pascal
Result := TBasicObject(FSender).SGetMarryInfo;
```

## 示例

### 婚礼司仪中的结婚状态检查
基于 `婚礼司仪.txt`：
```pascal
Str := callfunc ('getmarryinfo');
if Str = 'false' then begin
    print ('say 你没有喜帖,不能参加婚礼？');
    exit;
end;
```

### 婚礼司仪中的擂台征婚检查
基于 `婚礼司仪.txt`：
```pascal
Sex := callfunc ('getmarryinfo');
if Sex = 'true' then begin
    print ('say 抱歉，你已经有伴侣了，祝你们幸福');
    exit;
end;
```

### 绣球中的结婚状态检查
基于 `绣球.txt`：
```pascal
Str := callfunc ('getmarryinfo');
if Str = 'true' then begin
    print ('say 抱歉，你已结婚，无法打擂。');
    exit;
end;
```

## 注意事项
1. 常用于婚礼相关 NPC 脚本中，判断玩家是否有资格参加婚礼或征婚活动
2. 返回值为字符串 `'true'`/`'false'`，不是布尔类型
3. 与 `getmarryclothes` 配合使用，分别检查结婚状态和结婚服装

## 相关函数
- `getmarryclothes` — 获取结婚服装信息
- `getsendersex` — 获取玩家性别
- `getparty` — 获取组队信息
