# showeffect

## 功能描述
在当前对象位置显示特效。用于播放视觉特效，如陷阱触发、技能效果等。

## 语法格式
```pascal
print('showeffect <特效ID> <参数>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 特效ID | Integer | 要播放的特效编号 |
| 参数 | Integer | 特效的附加参数（如特效等级或变体） |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'showeffect' then begin
   TBasicObject (aSelf).SShowEffect (_StrToInt (Params [0]), _StrToInt (Params [1]));
```

传入特效ID和附加参数。

## 使用示例

### 陷阱触发时显示特效
```pascal
// 来自 电酒坛.txt - 被击中时显示陷阱特效
procedure OnHit (aStr : String);
begin
   print ('sendzoneeffectmsg 陷阱区1');
   print ('sendzoneeffectmsg 陷阱区2');
   print ('sendzoneeffectmsg 陷阱区3');
   print ('sendzoneeffectmsg 陷阱区4');
   print ('showeffect 22 1');
   exit;
end;
```

## 注意事项

1. **特效ID**：具体可用的特效ID取决于客户端资源
2. **配合区域消息**：通常与 `sendzoneeffectmsg` 配合使用，同时触发区域效果
3. **视觉效果**：仅影响客户端显示，不改变游戏逻辑

## 相关命令
- `sendzoneeffectmsg` — 发送区域效果消息
- `sendsound` — 播放音效
