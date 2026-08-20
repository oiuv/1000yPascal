# getsenderrace

返回当前触发对象的 `BasicData.Feature.rRace`，并转成整数字符串。

## 语法

```pascal
Race := callfunc('getsenderrace');
```

实现为：

```pascal
Result := IntToStr(TBasicObject(FSender).SGetRace);
```

`SGetRace` 返回对象种族字段，不是玩家性别。`deftype.pas` 定义的完整范围是 `RACE_NONE=0`、`RACE_HUMAN=1`、`RACE_ITEM=2`、`RACE_MONSTER=3`、`RACE_NPC=4`、`RACE_DYNAMICOBJECT=5`、`RACE_STATICITEM=6`。正常玩家作为 `FSender` 时返回 `RACE_HUMAN`；性别应使用 [getsendersex](getsendersex.md)。
