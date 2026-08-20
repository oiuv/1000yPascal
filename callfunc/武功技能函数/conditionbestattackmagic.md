# conditionbestattackmagic

检查当前触发玩家是否满足学习指定绝世攻击武功的源码条件。

## 语法

```pascal
Result := callfunc('conditionbestattackmagic <武功名>');
```

返回小写 `true` 或 `false`。`THaveMagicClass.ConditionBestAttackMagic` 依次检查：

1. `Virtue >= 6501`。
2. `Age >= 4001`。
3. 目标武功 `RelationProtect` 等于当前使用护体武功名称。
4. 目标攻击类型对应的三个上乘攻击武功均满足内部满级条件。
5. 玩家尚未拥有同名绝世攻击武功。

失败分支会在函数内部发送相应聊天提示。实现直接解引用 `pCurProtectingMagic`，没有空指针保护；脚本应只在玩家已选择护体武功的上下文调用。
