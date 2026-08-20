# getsenderqueststr

返回当前触发者 `FSender` 的任务字符串。

## 语法

```pascal
QuestStr := callfunc('getsenderqueststr');
```

无参数。返回值来自 `TUser.SGetQuestStr`，当前实现最终读取 `UserQuestClass.QuestStr`。基础对象实现返回空字符串；因此该函数应在 `FSender` 确实为玩家的事件中使用。

源码只把它视为不透明字符串，没有定义逗号分隔、`completed` 等通用格式。具体值必须以实际任务脚本写入 `changesenderqueststr` 的内容为准。

## 源码实现

```pascal
Result := TBasicObject(FSender).SGetQuestStr;
```

相关命令：[changesenderqueststr](../../print/任务系统命令/changesenderqueststr.md)。
