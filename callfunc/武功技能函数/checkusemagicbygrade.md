# checkusemagicbygrade

## 功能描述
检查玩家是否正在使用指定等级的绝世武功。

## 语法格式
```pascal
Str := callfunc('checkusemagicbygrade 等级');
```

## 参数说明
- **等级**：Integer - 要检查的绝世武功等级

## 返回值
- **成功**：'true' - 玩家正在使用指定等级的绝世武功
- **失败**：'false' - 玩家未使用指定等级的绝世武功

## 源码实现
基于 `!UUser.pas` 中的 `SCheckUseMagicByGrade` 函数：

```pascal
function TUser.SCheckUseMagicByGrade (aGrade : Integer) : String;
begin
   Result := 'false';

   if HaveMagicClass.pCurAttackMagic <> nil then begin
      if HaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
         if HaveMagicClass.pCurAttackMagic^.rGrade = aGrade then begin
            if HaveMagicClass.pCurAttackMagic^.rcSkillLevel = 9999 then begin
               Result := 'true';
            end;
         end;
      end;
   end;
end;
```

## 使用示例

### 基础等级检查
```pascal
// 检查是否使用10级绝世武功
magic_status := callfunc('checkusemagicbygrade 10');
if magic_status = 'true' then
    print('say 你正在使用10级绝世武功！');
```

### 多等级检查
```pascal
// 检查绝世武功等级范围
for i := 1 to 20 do begin
    status := callfunc('checkusemagicbygrade ' + IntToStr(i));
    if status = 'true' then begin
        print('say 你正在使用' + IntToStr(i) + '级绝世武功');
        break;
    end;
end;
```

### 条件判断示例
```pascal
// 根据绝世武功等级给予不同奖励
grade_5_status := callfunc('checkusemagicbygrade 5');
grade_10_status := callfunc('checkusemagicbygrade 10');

if grade_10_status = 'true' then begin
    print('say 10级绝世武功！你已经是武林高手了！');
    // 给予高级奖励
    print('putsendermagicitem 灵丹妙药:1 @quest绝世武功 4');
end else if grade_5_status = 'true' then begin
    print('say 5级绝世武功，不错的基础！');
    // 给予中级奖励
    print('putsendermagicitem 金疮药:5 @quest绝世武功 4');
end;
```

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'，需要进行字符串比较
2. **绝世武功定义**：只有满足魔法类型=MAGICCLASS_BESTMAGIC 且技能等级=9999的武功才被认为是绝世武功
3. **精确等级匹配**：必须完全匹配指定等级才会返回true
4. **仅检查攻击武功**：此函数只检查当前攻击武功，不检查护身武功
5. **等级范围**：绝世武功等级通常在1-20范围内，具体根据游戏设定

## 相关函数
- `checksendercurusemagic` - 检查当前使用武功类型
- `getsendercurpowerlevel` - 获取玩家当前力量等级
- `getsendercurpowerlevelname` - 获取当前力量等级名称