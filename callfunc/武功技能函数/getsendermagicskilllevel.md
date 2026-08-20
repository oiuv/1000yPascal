# getsendermagicskilllevel

## 功能

按完整名称查询触发脚本玩家拥有的武功修炼值。

```pascal
Str := callfunc('getsendermagicskilllevel 武功名称');
```

命令在 `FSender` 上调用 `SGetMagicSkillLevel`，最终执行 `HaveMagicClass.FindMagicByName`：

1. 参数为空时返回 `0`。
2. 先按名称查找 `DefaultMagic`。
3. 再查找普通持有武功。
4. 最后查找上层武功。
5. 找不到时返回 `0`。

命中后返回该记录的 `rcSkillLevel`，并由 `IntToStr` 转为字符串。`9999` 是源码中多处用于判断修炼值已满的明确阈值；它不是本接口单独定义的“武功等级”。

依据：`uScriptManager.pas`、`UUser.pas`、`uUserSub.pas` 的 `THaveMagicClass.FindMagicByName`。
