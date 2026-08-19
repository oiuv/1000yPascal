# getrace

获取当前脚本关联对象（自身）的种族。注意：此函数操作的是 `FSelf`（脚本关联的对象），而非触发事件的玩家。

## 语法
```pascal
Str := callfunc('getrace');
```

## 参数
无参数。

## 返回值
返回字符串，为种族编号：
- `'1'` — 人类（玩家）
- `'3'` — 怪物
- 其他值对应不同种族

## 源码实现
```pascal
Result := IntToStr(TBasicObject(FSelf).SGetRace);
```

## 示例

### 蜡台中的种族判断
基于 `蜡台.txt`：
```pascal
function OnDanger (aStr : String) : String;
var
   Str : String;
begin
   Str := callfunc ('getrace');
   if Str = '3' then begin
      Result := true;
      exit;
   end;

   if aStr = '火箭' then begin
      Result := 'true';
      exit;
   end;
end;
```

## 注意事项
1. **重要区别**：`getrace` 获取的是脚本关联对象（FSelf）的种族；`getsenderrace` 获取的是触发事件的玩家的种族
2. 常用于怪物/NPC 脚本中判断对象类型
3. 种族 `'3'` 通常表示怪物，`'1'` 表示人类玩家

## 相关函数
- `getsenderrace` — 获取触发事件的玩家种族
- `getname` — 获取对象名称
- `getlife` — 获取对象生命值
