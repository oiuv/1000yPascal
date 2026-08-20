# senditemmoveinfo

## 功能与语法

向触发脚本的玩家发送物品移动信息。

```pascal
print('senditemmoveinfo <逗号分隔的物品移动信息>');
```

`CommandScript` 将第一个参数传给 `TUser.SSendItemMoveInfo`，后者执行 `SendClass.SendItemMoveInfo(aStr, '')`。脚本解析器按空格拆分参数；需要空格的文本必须按现有脚本约定编码。

`bin/Script/一级风兄.txt` 的实际拼接结果形如：

```pascal
print('senditemmoveinfo 玩家名,选择职业,工匠,0,0,0,0,');
```

整个逗号分隔串作为 `Params[0]` 传入；命令入口不解析其中各列。
