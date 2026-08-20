# questcomplete

## 功能与语法

拼接两个参数和程序内置的本地化文字，并向所有在线玩家发送顶部消息。

```pascal
print('questcomplete <名称或前缀> <任务名称>');
```

## 源码依据

```pascal
TBasicObject(aSelf).SQuestComplete(Params[0], Params[1]);
```

`SQuestComplete` 只调用 `UserList.SendTopMessage`；它不修改 `CompleteQuestNo`、`CurrentQuestNo` 或其他任务字段。需要更新玩家任务进度时，应另外调用 `changesendercompletequest` 等命令。

真实脚本见 `bin/Script/东海沼泽抽屉.txt`、`bin/Script/南帝王.txt`。
