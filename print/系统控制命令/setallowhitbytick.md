# setallowhitbytick

## 功能描述
定时设置当前对象是否允许被攻击。通过命令队列延迟指定毫秒数后执行。常用于考试/比武场景中延迟开放攻击。

## 语法格式
```pascal
print('setallowhitbytick <允许> <延迟毫秒>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 允许 | String | `true` 表示允许被攻击，`false` 表示不允许 |
| 延迟毫秒 | Integer | 延迟执行的毫秒数 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'setallowhitbytick' then begin
   TBasicObject (aSelf).PushCommand (CMD_ALLOWHIT, Params, _StrToInt (Params [1]));
```

通过 `PushCommand` 将命令放入队列，延迟时间由 `Params[1]`（第2个参数）决定。

## 使用示例

### 考试开始后延迟开放攻击
```pascal
// 来自 2级牛俊.txt - 设置考官500毫秒后可被攻击
print ('directmovespace 晋级2牛俊 npc 86 20 21');
print ('commandicebyname 晋级2牛俊 npc 500');
print ('setallowhitbytick true 500');
```

### 一级考试场景
```pascal
// 来自 一级捕盗大将.txt
print ('directmovespace 一级捕盗大将 npc 50 20 18 0');
print ('commandicebyname 一级捕盗大将 npc 1000');
print ('setallowhitbytick true 1000');
```

## 注意事项

1. **延迟执行**：通过命令队列延迟执行，确保在对话/动画播放完成后才开放攻击
2. **配合冻结使用**：通常与 `commandicebyname` 配合，先冻结对象，延迟后同时解冻和开放攻击
3. **时间同步**：延迟毫秒数通常与 `commandicebyname` 的冻结时间一致

## 相关命令
- `setallowhit` — 立即设置是否允许被攻击
- `setallowhitbyname` — 按名称设置允许攻击
- `commandicebyname` — 按名称冻结对象
