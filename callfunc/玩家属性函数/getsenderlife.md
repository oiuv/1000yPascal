# getsenderlife

获取当前触发脚本事件的玩家当前活力值（生命值）。

## 语法
```pascal
Str := callfunc('getsenderlife');
```

## 参数
无参数。

## 返回值
返回字符串，为玩家当前活力值的整数形式。

## 源码实现
```pascal
Result := IntToStr(TBasicObject(FSender).SGetLife);
```
基于 `FSender`（触发事件的玩家）调用 `SGetLife` 获取当前活力值。

## 示例
```pascal
// 获取玩家当前活力值
Str := callfunc('getsenderlife');
Life := StrToInt(Str);
if Life < 100 then begin
    print('say 你的活力值很低，请注意休息！');
end;
```

## 相关函数
- `getlife` — 获取对象（自身）生命值
- `getsendermaxlife` — 获取玩家最大活力值
- `getsenderheadlife` — 获取玩家头部活力
- `getsenderarmlife` — 获取玩家手臂活力
- `getsenderleglife` — 获取玩家腿部活力
