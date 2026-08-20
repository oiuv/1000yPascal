# getsendervirtue

返回当前触发玩家的 `AttribClass.Virtue` 整数字符串。

## 语法

```pascal
Virtue := callfunc('getsendervirtue');
```

源码实现：

```pascal
Result := IntToStr(TBasicObject(FSender).SGetVirtue);
```

本函数只读取数值，不定义统一门槛，也不修改品德。具体比较值必须来自实际任务脚本或对应系统源码，不能把某个 NPC 脚本中的阈值推广为全局规则。
