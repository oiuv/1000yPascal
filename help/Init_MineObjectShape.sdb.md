# MineObjectShape.sdb

采矿对象外观数据文件，定义采矿对象的外观形状及周围守卫位置（禁止其他对象占据的位置）。

## 文件路径

```
.\Init\MineObjectShape.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 记录编号 | 行索引 |
| Shape | Integer | 外观形状编号 | `psd^.rShape := DB.GetFieldValueInteger(iName, 'Shape')` |
| SStep | Integer | 起始帧（动画起始步骤） | `psd^.rSStep := DB.GetFieldValueInteger(iName, 'SStep')` |
| EStep | Integer | 结束帧（动画结束步骤） | `psd^.rEStep := DB.GetFieldValueInteger(iName, 'EStep')` |
| GuardPos | String | 守卫位置列表，冒号分隔的坐标对（X1:Y1:X2:Y2:...），最多10组 | `psd^.rGuardX[j]` 和 `psd^.rGuardY[j]` |

### 守卫位置说明

GuardPos 定义了采矿对象周围的禁止位置，用于防止其他对象（如怪物、NPC）占据采矿点附近的位置。坐标为相对于采矿对象中心的偏移量。

## 数据示例

| Shape | SStep | EStep | 守卫位置数 |
|-------|-------|-------|-----------|
| 39 | 0 | 9 | 4个位置 |
| 59 | 0 | 10 | 9个位置 |
| 62 | 0 | 7 | 6个位置 |

## 相关源码

- `svClass.pas` — `TMineObjectClass.LoadFromFile`（第 6354 行）
- `svClass.pas` — `TMineObjectClass.GetMineObjectShapeData`（第 6460 行）
- `1000ydef\deftype.pas` — `TMineObjectShapeData` 记录定义（第 1592 行）
- `BasicObj.pas` — `TMineObject.Initial` 使用形状数据（第 8097 行）
