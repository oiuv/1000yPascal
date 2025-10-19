# showwindow

## 功能描述
显示窗口界面给玩家，通常用于显示任务对话、商店界面、帮助信息等。

## 语法格式
```pascal
print('showwindow 文件路径 显示模式');
```

## 参数说明
- **文件路径**：String - 要显示的窗口文件路径，相对于游戏根目录
- **显示模式**：Integer - 窗口显示模式
  - 0：多项列表对话框
  - 1：四项列表对话框

## 使用示例

### 基础窗口显示
```pascal
// 显示四项列表对话框
print('showwindow .\help\一级老人.txt 1');

// 显示多项列表对话框
print('showwindow .\help\help.txt 0');
```

### 真实游戏示例
基于游戏脚本中的使用：

```pascal
// 显示NPC对话窗口
print('showwindow .\help\event龙师父.txt 1');
print('showwindow .\help\quest捕盗大将1.txt 0');

// 显示帮助文件
print('showwindow .\help\一级老人.txt 1');
```

### 条件窗口显示
```pascal
// 根据玩家状态显示不同窗口
race_str := callfunc('getsenderrace');
race := StrToInt(race_str);

if race = 1 then begin
    print('showwindow .\help\male_npc.txt 1');
end else begin
    print('showwindow .\help\famale_npc.txt 1');
end;
```

## 注意事项

1. **文件路径**：文件路径必须是相对于游戏根目录的有效路径
2. **文件存在性**：指定的文件必须存在，否则窗口显示会失败
3. **模式选择**：不同模式对应不同的窗口样式和按钮数量
4. **路径分隔符**：使用反斜杠 `\` 作为路径分隔符
5. **文件编码**：窗口文件通常使用GBK编码
6. **同时显示**：通常一次只能显示一个窗口，新窗口会替换旧窗口
7. **玩家交互**：显示窗口后需要玩家交互才能继续

## 常见显示模式
- **模式0**：多项选择对话框，适用于有多个选项的情况
- **模式1**：四项选择对话框，适用于标准NPC对话

## 相关命令
- `say` - 显示简单对话
- `sendsenderchatmessage` - 发送聊天消息
- `sendsendertopmsg` - 发送顶部公告