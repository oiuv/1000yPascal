# sendsenderchatmessage

## 功能描述
向玩家发送聊天消息，显示在聊天窗口中。

## 语法格式
```pascal
print('sendsenderchatmessage 消息内容 颜色值');
```

## 参数说明
- **消息内容**：String - 要发送的消息文本，文本中的空格需要用下划线 `_` 代替
- **颜色值**：Integer（可选）- 消息的颜色代码，如果不指定则使用默认颜色

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'sendsenderchatmessage' then begin
   TBasicObject (aSender).SSendChatMessage (Params [0], _StrToInt (Params[1]));
```

## 使用示例

### 基础消息发送
```pascal
// 发送简单消息
print('sendsenderchatmessage 操作成功！ 1');

// 发送错误消息
print('sendsenderchatmessage 操作失败，请重试 3');
```

### 带颜色的消息
```pascal
// 不同颜色的系统消息
print('sendsenderchatmessage 系统通知：服务器将在5分钟后维护 0');
print('sendsenderchatmessage 恭喜！你获得了经验奖励 2');
print('sendsenderchatmessage 警告：该区域有危险怪物 3');
```

### 任务消息
```pascal
// 任务进度消息
print('sendsenderchatmessage 任务完成：你已成功消灭所有怪物 2');

// 任务奖励消息
print('sendsenderchatmessage 获得奖励：经验+1000，金币+500 1');

// 任务提示消息
print('sendsenderchatmessage 新任务已接受，请查看任务详情 4');
```

### 交易消息
```pascal
// 购买成功
print('sendsenderchatmessage 购买成功：获得物品xxx 1');

// 出售成功
print('sendsenderchatmessage 出售成功：获得金币1000 1');

// 背包不足
print('sendsenderchatmessage 背包空间不足，无法购买 3');
```

### 复杂消息（空格处理）
```pascal
// 长消息中的空格用下划线代替
print('sendsenderchatmessage 恭喜玩家_XXX_完成了_主线任务_第一章 2');

// 带格式化的消息
player_name := callfunc('getsendername');
message := '欢迎_' + player_name + '_来到_武侠世界';
print('sendsenderchatmessage ' + message + ' 1');
```

### 系统公告
```pascal
// 系统维护通知
print('sendsenderchatmessage [系统]服务器将于今晚23:00进行例行维护 0');

// 活动通知
print('sendsenderchatmessage [活动]双倍经验活动已经开始，快来参与吧！ 5');

// 重要通知
print('sendsenderchatmessage [重要]请勿使用外挂程序，违者将被封号 3');
```

## 注意事项

1. **空格处理**：消息内容中的空格必须用下划线 `_` 代替，系统会自动转换
2. **颜色代码**：颜色代码的具体含义由游戏客户端定义，常见的有：
   - 0：系统消息（通常是白色或灰色）
   - 1：普通消息（通常是绿色）
   - 2：成功消息（通常是蓝色）
   - 3：警告消息（通常是黄色或橙色）
   - 4：提示消息（通常是青色）
   - 5：特殊消息（通常是紫色或红色）
3. **消息长度**：消息可能有长度限制，过长的消息可能被截断
4. **发送频率**：避免过于频繁地发送消息，可能影响游戏体验
5. **编码问题**：确保消息使用正确的编码格式
6. **HTML标签**：不支持HTML标签或其他格式化语法

## 与其他消息命令的区别

- **say**: 让NPC说话，显示在对话窗口中
- **sendsenderchatmessage**: 直接发送到玩家聊天窗口
- **sendsendertopmsg**: 显示在屏幕顶部的滚动公告

## 相关命令
- `say` - NPC对话
- `sendsendertopmsg` - 顶部公告
- `sendmessage` - 发送消息（可能已废弃）