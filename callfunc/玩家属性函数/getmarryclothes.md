# getmarryclothes

## 功能与语法

查询当前事件发送者在婚姻记录中的“婚礼服装已领取”标志。

```pascal
Result := callfunc('getmarryclothes');
```

无参数。返回小写字符串 `true` 或 `false`。`TUser.SGetMarryClothes` 调用 `MarryList.isClothes(Name)`，按玩家是 `Girl` 还是 `Boy` 分别读取 `GirlClothes`、`BoyClothes`；没有匹配婚姻记录时返回 `false`。

这个标志不检查玩家当前是否穿着新郎/新娘套装。炎黄 `婚礼司仪.txt` 会另行调用 `getsenderwearitemname 6` 核对实际装备，二者不能混为一项判断。

对应写入命令是 `setmarryclothes`。婚姻数据的保存风险见 [Event 运行数据](../../help/Event.md)。

源码依据：`uScriptManager.pas`、`UUser.pas` 的 `SGetMarryClothes` 和 `svClass.pas` 的 `TMarryClass.isClothes`。
