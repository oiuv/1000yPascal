# getrace

## 功能

读取当前脚本关联对象 `FSelf` 的 `BasicData.Feature.rRace`，并以十进制字符串返回。

## 语法

```pascal
Str := callfunc('getrace');
```

无参数。`uScriptManager.pas` 的调用为：

```pascal
Result := IntToStr(TBasicObject(FSelf).SGetRace);
```

## 已定义种族值

`deftype.pas` 定义了以下常量：

| 返回值 | 常量 | 含义 |
| --- | --- | --- |
| `0` | `RACE_NONE` | 未指定 |
| `1` | `RACE_HUMAN` | 人类/玩家 |
| `2` | `RACE_ITEM` | 物品 |
| `3` | `RACE_MONSTER` | 怪物 |
| `4` | `RACE_NPC` | NPC |
| `5` | `RACE_DYNAMICOBJECT` | 动态对象 |
| `6` | `RACE_STATICITEM` | 静态物品 |

返回的是对象种族，不是性别。`getsenderrace` 读取事件发送者 `FSender` 的同一字段。
