# directmovespace

## 功能描述
直接改变对象（NPC或怪物）在地图上的位置，立即执行，无延迟。通常用于将 NPC 或怪物移动到指定位置。

## 语法格式
```pascal
print('directmovespace <名称> <类型> <地图ID> <X坐标> <Y坐标>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 名称 | String | 对象名称（NPC名或怪物名） |
| 类型 | String | 对象类型：`npc`（NPC）或 `monster`（怪物） |
| 地图ID | Integer | 目标地图编号 |
| X坐标 | Integer | 目标 X 坐标 |
| Y坐标 | Integer | 目标 Y 坐标 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'directmovespace' then begin
   TBasicObject (aSelf).SMoveSpace (Params [0], Params [1], _StrToInt (Params[2]), _StrToInt (Params [3]), _StrToInt (Params [4]));
```

直接调用 `SMoveSpace` 方法，传入名称、类型和坐标，立即执行。

## 使用示例

### 考试开始前将考官移到考场
```pascal
// 来自 2级牛俊.txt - 将NPC考官移到考试地图
print ('directmovespace 晋级2牛俊 npc 86 20 21');
```

### 将Boss移到指定位置
```pascal
// 来自 一级捕盗大将.txt
print ('directmovespace 一级捕盗大将 npc 50 20 18 0');
```

### 将怪物移到特定位置
```pascal
// 来自 密室太极老人.txt - 将太极公子移到密室
print ('directmovespace 太极公子 monster 32 17 18 0');
```

## 注意事项

1. **立即执行**：与 `movespace` 不同，`directmovespace` 没有延迟参数，立即生效
2. **对象类型**：支持 `npc` 和 `monster` 两种类型
3. **坐标为0**：最后一个参数为方向值，通常设为 0
4. **配合冻结使用**：移动后通常配合 `commandicebyname` 冻结对象

## 相关命令
- `movespace` — 传送玩家到指定地图坐标
- `movespacebyname` — 按名称传送对象
- `commandicebyname` — 按名称冻结对象
