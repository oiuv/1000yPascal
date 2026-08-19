# setparty

为当前触发脚本事件的玩家设置组队信息。在婚礼系统中用于创建或加入婚礼组队。

## 语法
```pascal
Str := callfunc('setparty');
```

## 参数
无参数。

## 返回值
返回字符串，具体含义取决于操作结果。

## 源码实现
```pascal
Result := TBasicObject(FSender).SSetParty;
```

## 示例

### 婚礼司仪中的组队设置
基于 `婚礼司仪.txt`：
```pascal
// 新郎入场
Name := callfunc ('setparty');
Name := callfunc ('getsendername');
Str := 'movespace ' + Name;
Str := Str + ' user 89 42 59 300';
print (Str);

// 女方入场
Name := callfunc ('setparty');
Name := callfunc ('getsendername');
Str := 'movespace ' + Name;
Str := Str + ' user 89 42 59 300';
print (Str);
```

## 注意事项
1. 主要用于婚礼系统中，将参加婚礼的玩家组建成队伍
2. 通常先用 `getparty` 检查玩家是否已组队，避免重复操作
3. 调用后一般配合 `getsendername` 获取玩家名称，再使用 `movespace` 传送玩家
4. 与 `getmarryclothes` 配合使用，确保只有穿着结婚服装的玩家才能触发组队

## 相关函数
- `getparty` — 获取组队信息
- `getmarryclothes` — 获取结婚服装信息
- `getsendername` — 获取玩家名称
