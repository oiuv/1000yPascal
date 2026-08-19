# getsendervirtue

获取当前触发脚本事件的玩家品德值。

## 语法
```pascal
Str := callfunc('getsendervirtue');
```

## 参数
无参数。

## 返回值
返回字符串，为玩家品德值的整数形式。品德值反映玩家的善恶程度。

## 源码实现
```pascal
Result := IntToStr(TBasicObject(FSender).SGetVirtue);
```

## 示例

### 帝王石谷药材商中的品德检查
基于 `帝王石谷药材商.txt`：
```pascal
Str := callfunc ('getsendervirtue');
nVirtue := StrToInt (Str);
if nVirtue < 2000 then begin
    print ('say 炬죄 乖였콱菱嚼畸.');
    exit;
end;
```

### 西域魔人虚像中的品德检查
基于 `西域魔人虚像.txt`：
```pascal
Str := callfunc ('getsendervirtue');
// 根据品德值判断是否允许执行某些操作
```

## 注意事项
1. 品德值影响玩家能否与某些 NPC 交互或进入特定区域
2. 常见阈值为 2000，低于此值可能被 NPC 拒绝服务
3. 品德值可通过游戏内行为（如击杀怪物、完成任务）改变

## 相关函数
- `getsendertalent` — 获取玩家天赋值
- `getsenderage` — 获取玩家年龄
- `getsendercompletequest` — 获取玩家已完成任务数
