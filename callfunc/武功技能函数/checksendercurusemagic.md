# checksendercurusemagic

## 功能描述
检查当前玩家是否正在使用指定类型的武功。

## 语法格式
```pascal
Str := callfunc('checksendercurusemagic aType');
```

## 参数说明
- **aType**：Integer - 武功类型
  - 0：普通武功攻击 - 正在攻击且门派类型=1
  - 1：超级武功攻击 - 正在攻击且门派类型=2
  - 2：护身武功 - 正在使用护身武功
  - 3：攻击武功 - 正在使用攻击武功
  - 4：护身武功(高级) - 高级护身武功
  - 5：护身武功(特殊) - 特殊护身武功
  - 6：攻击武功(绝世) - 绝世攻击武功

## 返回值
- **成功**：'true' - 玩家正在使用指定类型的武功
- **失败**：'false' - 玩家未使用指定类型的武功或条件不满足

## 源码实现
基于 `!UUser.pas` 中的 `SCheckCurUseMagic` 函数：

```pascal
function TUser.SCheckCurUseMagic (aType : Byte) : String;
begin
   Result := 'false';

   case aType of
      0 : begin  // 普通武功攻击
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rGuildMagictype <> 1 then exit;
      end;
      1 : begin  // 超级武功攻击
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rGuildMagictype <> 2 then exit;
      end;
      2 : begin  // 护身武功
         if HaveMagicClass.pCurProtectingMagic = nil then exit;
      end;
      3 : begin  // 攻击武功
         if HaveMagicClass.pCurAttackMagic = nil then exit;
      end;
      4 : begin  // 高级护身武功
         if HaveMagicClass.pCurProtectingMagic = nil then exit;
         if HaveMagicClass.pCurProtectingMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
      end;
      5 : begin  // 特殊护身武功
         if HaveMagicClass.pCurProtectingMagic = nil then exit;
         if HaveMagicClass.pCurProtectingMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
         if HaveMagicClass.pCurProtectingMagic^.rGrade <> aGrade then exit;
         if HaveMagicClass.pCurProtectingMagic^.rcSkillLevel <> 9999 then exit;
      end;
      6 : begin  // 绝世攻击武功
         if HaveMagicClass.pCurAttackMagic = nil then exit;
         if HaveMagicClass.pCurAttackMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
         if HaveMagicClass.pCurAttackMagic^.rGrade <> aGrade then exit;
         if HaveMagicClass.pCurAttackMagic^.rcSkillLevel <> 9999 then exit;
         if (aMagicType <> -1) and (HaveMagicClass.pCurAttackMagic^.rMagicType <> aMagictype) then exit;
      end;
   end;

   Result := 'true';
end;
```

## 使用示例

### 基础武功检查
```pascal
// 检查是否使用普通武功攻击
magic_status := callfunc('checksendercurusemagic 0');
if magic_status = 'true' then
    print('say 你正在使用普通武功攻击');
```

### 绝世武功检查
```pascal
// 检查是否使用绝世武功
magic_status := callfunc('checksendercurusemagic 6');
if magic_status = 'true' then
    print('say 你正在使用绝世武功！');
```

### 护身武功检查
```pascal
// 检查是否使用护身武功
protect_status := callfunc('checksendercurusemagic 2');
if protect_status = 'true' then
    print('say 你正在使用护身武功保护自己');
```

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'，需要进行字符串比较
2. **武功类型**：不同数值对应不同的武功类型，使用时需要准确指定
3. **条件检查**：该函数会同时检查武功是否存在、类型、等级等多个条件
4. **绝世武功特征**：类型5和6专门用于检查绝世武功（技能等级=9999）

## 相关函数
- `checkusemagicbygrade` - 检查特定等级的绝世武功
- `getsenderuseattackmagic` - 获取当前攻击武功名称
- `getsenderuseattackskilllevel` - 获取攻击武功技能等级
- `getsenderuseprotectmagic` - 获取当前护身武功名称