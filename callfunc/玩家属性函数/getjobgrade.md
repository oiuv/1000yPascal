# getjobgrade（未实现）

`getjobgrade` 是旧脚本中出现过的名称，但当前源码未注册此函数。获取当前触发玩家的职业等级应使用 `getsenderjobgrade`。

> **注意**：此函数名在源码 `uScriptManager.pas` 的 `CallFunction` 中**未找到对应实现**。源码中仅有 `getsenderjobgrade`（功能相同）。脚本中出现的 `getjobgrade` 调用可能是历史遗留或外部扩展。建议使用 `getsenderjobgrade` 替代。

## 替代语法
```pascal
Str := callfunc('getsenderjobgrade');
```

## 参数
无参数。

## 返回值
`getsenderjobgrade` 返回职业等级的整数字符串。直接调用 `getjobgrade` 没有对应处理分支，不能依赖其返回值。

## 源码实现
在 `uScriptManager.pas` 的 `CallFunction` 中未找到 `getjobgrade` 的处理分支。功能等价的 `getsenderjobgrade` 实现如下：
```pascal
Result := IntToStr(TBasicObject(FSender).SGetJobGrade);
```

## 示例

### 修正旧脚本中的调用

`龙师父.txt` 中存在历史调用 `callfunc('getjobgrade')`。按当前源码应改用：
```pascal
JobKind := callfunc ('getsenderjobkind');
if JobKind = '0' then begin
    print ('say 일琴_뻘청斡撚켱？');
    exit;
end;

JobGrade := callfunc ('getsenderjobgrade');
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
1. **源码中不存在此函数名**，不要在新脚本中使用
2. 旧脚本应显式替换为 `getsenderjobgrade`

## 相关函数
- `getsenderjobgrade` — 获取玩家职业等级（实际实现）
- `getsenderjobkind` — 获取玩家职业类型
- `getsendertalent` — 获取玩家天赋值
