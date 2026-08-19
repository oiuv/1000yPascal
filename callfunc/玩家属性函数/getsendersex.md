# getsendersex

获取当前触发脚本事件的玩家性别。

## 语法
```pascal
Str := callfunc('getsendersex');
```

## 参数
无参数。

## 返回值
返回字符串，性别编号：
- `'1'` — 男
- `'2'` — 女

## 源码实现
```pascal
Result := IntToStr(TBasicObject(FSender).SGetSex);
```

## 示例

### 婚礼司仪中的性别判断
基于 `婚礼司仪.txt`：
```pascal
Sex := callfunc ('getsendersex');
if Sex = '1' then begin
    print ('say 抱歉，只女孩子才能申请擂台征婚哦');
    exit;
end;
```

### 绣球中的性别限制
基于 `绣球.txt`：
```pascal
Str := callfunc ('getsendersex');
if Str = '2' then begin
    print('抱歉,女士无法参加征婚打擂.');
    exit;
end;
```

### 婚礼入场男女分支
基于 `婚礼司仪.txt`：
```pascal
Sex := callfunc ('getsendersex');
if Sex = '1' then begin
    // 男方逻辑：检查新郎套装
    Str := callfunc ('getsenderwearitemname 6');
    if Str <> '新郎套装' then begin
        print ('say 唉？你的新郎套装为什么不穿上呢？');
        exit;
    end;
end;
if Sex = '2' then begin
    // 女方逻辑：检查新娘套装
    Str := callfunc ('getsenderwearitemname 6');
    if Str <> '新娘套装' then begin
        print ('say 唉？你的新娘套装为什么不穿上呢？');
        exit;
    end;
end;
```

## 相关函数
- `getsenderrace` — 获取玩家种族
- `getsendername` — 获取玩家名称
- `getsenderage` — 获取玩家年龄
