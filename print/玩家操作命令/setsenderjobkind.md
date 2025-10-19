# setsenderjobkind

## 功能描述
更改玩家的职业类型。

## 语法格式
```pascal
print('setsenderjobkind 职业类型');
```

## 参数说明
- **职业类型**：Integer - 要设置的职业类型
  - 0：无职业
  - 1：铸造师
  - 2：炼丹师
  - 3：裁缝
  - 4：工匠

## 使用示例

### 基础职业设置
```pascal
// 设置为铸造师
print('setsenderjobkind 1');

// 设置为炼丹师
print('setsenderjobkind 2');

// 设置为裁缝
print('setsenderjobkind 3');

// 设置为工匠
print('setsenderjobkind 4');

// 取消职业
print('setsenderjobkind 0');
```

### 真实游戏示例
基于游戏脚本中的使用：

```pascal
// 职业选择系统
print('setsenderjobkind 1');  // 铸造师
print('setsenderjobkind 2');  // 炼丹师
print('setsenderjobkind 3');  // 裁缝
print('setsenderjobkind 4');  // 工匠
```

### 条件职业设置
```pascal
// 根据玩家选择设置职业
player_choice := callfunc('getplayerchoice');

case player_choice of
    '1': print('setsenderjobkind 1');  // 选择铸造师
    '2': print('setsenderjobkind 2');  // 选择炼丹师
    '3': print('setsenderjobkind 3');  // 选择裁缝
    '4': print('setsenderjobkind 4');  // 选择工匠
else
    print('say 无效的职业选择');
end;
```

## 注意事项

1. **职业互斥**：玩家通常只能同时拥有一个职业
2. **技能影响**：更改职业可能会影响相关技能的使用
3. **物品限制**：某些装备或物品可能需要特定职业才能使用
4. **任务影响**：某些任务可能需要特定职业才能接受或完成
5. **取消后果**：设置为无职业可能会失去相关职业技能
6. **重复设置**：重复设置相同职业通常不会有额外效果

## 职业说明

### 铸造师 (职业1)
- **专长**：武器和防具的制作与强化
- **相关技能**：锻造、冶炼、装备修理
- **常用工具**：铁锤、熔炉、砧板

### 炼丹师 (职业2)
- **专长**：丹药和药剂的制作
- **相关技能**：炼丹、草药学、药剂调配
- **常用工具**：丹炉、药杵、炼丹鼎

### 裁缝 (职业3)
- **专长**：服装和布甲的制作
- **相关技能**：裁剪、缝纫、布料加工
- **常用工具**：剪刀、针线、织布机

### 工匠 (职业4)
- **专长**：工艺品和特殊道具的制作
- **相关技能**：工艺制作、材料加工、道具合成
- **常用工具**：工具箱、工作台、各种手工具

## 相关命令
- `getsenderjobkind` - 获取玩家当前职业类型
- `getsenderjobgrade` - 获取玩家职业等级
- `setsendervirtueman` - 设置玩家神工等级