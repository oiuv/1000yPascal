# startwindow

## 功能描述
系统打开窗口。与 `showwindow` 功能类似，用于向玩家显示系统窗口界面。

## 语法格式
```pascal
print('startwindow <窗口路径> <参数>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 窗口路径 | String | 窗口文件路径（如 `.\help\xxx.txt`） |
| 参数 | Integer | 窗口参数 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'startwindow' then begin
   TBasicObject (aSelf).SShowWindow (FSelf, Params [0], _StrToInt (Params [1]));
```

注意：`startwindow` 使用 `FSelf`（脚本对象自身）作为窗口接收者，而 `showwindow` 使用 `aSender`（触发脚本的玩家）。

## 使用示例

目前游戏脚本中暂无直接使用 `startwindow` 的示例。脚本中通常使用 `showwindow` 来向玩家显示窗口。

## 注意事项

1. **与 showwindow 的区别**：`showwindow` 作用于 `aSender`（玩家），`startwindow` 作用于 `FSelf`（脚本对象自身）
2. **窗口路径**：通常指向 `.\help\` 目录下的文本文件

## 相关命令
- `showwindow` — 向玩家显示窗口
- `tradewindow` — 打开交易窗口
