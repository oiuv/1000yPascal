# usemagicgradeup

## 功能描述
升级当前玩家的神功或绝世武功。

## 语法格式
```pascal
print('usemagicgradeup 武功类别 升级等级');
```

## 参数说明
- **武功类别**：Integer - 武功类型
  - 0：神功
  - 1：绝世武功
- **升级等级**：Integer - 升级目标等级
  - 1：升到2级
  - 2：升到3级

## 使用示例

### 基础升级示例
```pascal
// 升级绝世武功到3级
print('usemagicgradeup 1 2');

// 升级神功到2级
print('usemagicgradeup 0 1');
```

### 真实游戏示例
基于游戏脚本中的使用：

```pascal
// 绝世武功升级路径
print('usemagicgradeup 0 1');  // 神功升到2级
print('usemagicgradeup 0 2');  // 神功升到3级
print('usemagicgradeup 1 1');  // 绝世武功升到2级
print('usemagicgradeup 1 2');  // 绝世武功升到3级
```

## 注意事项

1. **武功类型**：必须正确指定0（神功）或1（绝世武功）
2. **升级等级**：参数2表示升级到的等级，1=2级，2=3级
3. **前置条件**：玩家必须已经拥有相应的基础武功才能升级
4. **等级限制**：可能需要满足特定的等级或属性要求
5. **消耗检查**：升级可能需要消耗特定的物品或游戏币

## 相关命令
- `checksendercurusemagic` - 检查当前使用的武功
- `checkusemagicbygrade` - 检查特定等级的武功使用
- `setsendervirtueman` - 设置玩家神工等级