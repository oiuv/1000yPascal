# setallowhitbyname

## 功能描述
按名称设置指定对象是否允许被攻击。用于控制特定 NPC 或怪物的可攻击状态。

## 语法格式
```pascal
print('setallowhitbyname <对象名称> <对象类型> <允许>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 对象名称 | String | 要设置的对象名称 |
| 对象类型 | String | 对象类型：`monster`（怪物）或 `npc`（NPC） |
| 允许 | String | `true` 表示允许被攻击，`false` 表示不允许 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'setallowhitbyname' then begin
   TBasicObject (aSelf).SSetAllowHitByName (Params [0], Params [1], Params [2]);
```

传入对象名称、类型和允许状态。

## 使用示例

### NPC创建时设置怪物可攻击
```pascal
// 来自 一级捕盗大将.txt - NPC创建时设置考官怪物可被攻击
procedure OnCreate (aStr : String);
begin
   Str := callfunc ('getsenderrace');
   if Str <> '1' then begin
      exit;
   end;

   print ('setallowhitbyname 一级捕盗大将 monster true');

   Str := 'showwindow .\help\一级捕盗大将.txt 1';
   print (Str);
   exit;
end;
```

## 注意事项

1. **对象类型**：支持 `monster` 和 `npc` 两种类型
2. **与 setallowhit 的区别**：`setallowhit` 设置自身，`setallowhitbyname` 可以设置任意指定名称的对象
3. **常配合 commandicebyname**：先冻结对象，再设置可攻击状态

## 相关命令
- `setallowhit` — 设置自身是否允许被攻击
- `setallowhitbytick` — 定时设置允许攻击
- `commandicebyname` — 按名称冻结对象
