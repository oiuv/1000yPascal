# clearworkbox

## 功能描述
清空工作箱。用于清除当前对象的工作箱内容，通常在对象死亡或重置时调用。

## 语法格式
```pascal
print('clearworkbox');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'clearworkbox' then begin
   TBasicObject (aSelf).SClearWorkBox;
```

直接调用 `SClearWorkBox` 方法，无参数。

## 使用示例

### 太极老人死亡后清空工作箱
```pascal
// 来自 密室太极老人.txt - 死亡后清空工作箱并重置位置
procedure OnDie (aStr : String);
begin
   print ('clearworkbox');
   print ('gotoxy 20 16');
end;
```

## 注意事项

1. **无参数**：此命令不需要任何参数
2. **作用于自身**：清空的是当前脚本对象的工作箱
3. **常见场景**：NPC/怪物死亡后清空工作箱，为下次重生做准备

## 相关命令
- `gotoxy` — 移动到指定坐标
- `regen` — 刷新对象
