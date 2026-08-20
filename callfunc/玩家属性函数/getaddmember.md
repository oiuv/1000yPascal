# getaddmember

## 功能与语法

为触发脚本的玩家设置竞技场主办者名称，并打开确认参加该主办者比赛的窗口。

```pascal
Str := callfunc('getaddmember <主办者名称>');
```

## 源码依据

`CallFunction` 调用 `TUser.SAddArenaMember(Params[0])`。该方法把参数写入 `aArenaBody` 并调用 `ArenaWindow`；当前实现没有给函数 `Result` 赋业务结果，不能把返回字符串当作成功标志。

真实脚本 `bin/Script/绣球.txt` 使用此函数发起参赛确认。

## 注意事项

- 名称不能含未转义空格，因为脚本参数按空格拆分。
- 这是有界面副作用的历史 `callfunc`，不是纯查询函数。
