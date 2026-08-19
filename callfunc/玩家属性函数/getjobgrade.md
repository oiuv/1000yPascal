# getjobgrade

获取当前触发脚本事件的玩家的职业等级。

> **注意**：此函数名在源码 `uScriptManager.pas` 的 `CallFunction` 中**未找到对应实现**。源码中仅有 `getsenderjobgrade`（功能相同）。脚本中出现的 `getjobgrade` 调用可能是历史遗留或外部扩展。建议使用 `getsenderjobgrade` 替代。

## 语法
```pascal
Str := callfunc('getjobgrade');
```

## 参数
无参数。

## 返回值
返回字符串，为玩家职业等级的整数形式。

## 源码实现
在 `uScriptManager.pas` 的 `CallFunction` 中未找到 `getjobgrade` 的处理分支。功能等价的 `getsenderjobgrade` 实现如下：
```pascal
Result := IntToStr(TBasicObject(FSender).SGetJobGrade);
```

## 示例

### 龙师父中的职业等级检查
基于 `龙师父.txt`：
```pascal
JobKind := callfunc ('getsenderjobkind');
if JobKind = '0' then begin
    print ('say 일琴_뻘청斡撚켱？');
    exit;
end;

JobGrade := callfunc ('getjobgrade');
if JobGrade = '6' then begin
    print ('showwindow .\help\질可만3.txt 1');
    exit;
end;

Str := callfunc ('getsendertalent');
if Str < '9998' then begin
    print ('showwindow .\help\질可만2.txt 1');
    exit;
end;
```

## 注意事项
1. **源码中不存在此函数名**，仅在 `龙师父.txt` 脚本中使用。实际运行时可能返回空字符串
2. 建议使用 `getsenderjobgrade` 替代，两者功能完全相同
3. 职业等级 `'6'` 通常为最高等级

## 相关函数
- `getsenderjobgrade` — 获取玩家职业等级（推荐使用）
- `getsenderjobkind` — 获取玩家职业类型
- `getsendertalent` — 获取玩家天赋值
