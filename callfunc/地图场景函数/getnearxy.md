# getnearxy

## 功能描述
获取指定坐标附近的一个可移动坐标点。如果给定坐标不可移动，则自动查找附近可移动的位置。

## 语法格式
```pascal
Str := callfunc('getnearxy X坐标 Y坐标');
```

## 参数说明
- **X坐标**：Integer - 基准 X 坐标
- **Y坐标**：Integer - 基准 Y 坐标

## 返回值
- **成功**：返回坐标字符串，格式为 `X_Y`（如 `14_21`）
- **说明**：返回的坐标是给定坐标附近的一个可移动位置

## 源码实现
基于 `BasicObj.pas` 中的 `SGetNearXY` 函数：

```pascal
function TBasicObject.SGetNearXY(aX, aY: Word): string;
var
   xx, yy: Integer;
begin
   xx := aX;
   yy := aY;
   TMaper(Maper).GetNearXY(xx, yy);

   Result := format('%d_%d', [xx, yy]);
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getnearxy' then begin
   Result := TBasicObject(FSelf).SGetNearXY(_StrToInt(Params[0]), _StrToInt(Params[1]));
```

## 使用示例

### 获取自身附近可移动位置（来自密室太极老人脚本）
```pascal
// 获取自身坐标
Str := callfunc('getsenderposition');
Str := GetToken(Str, xStr, '_');
x := StrToInt(xStr);
Str := GetToken(Str, yStr, '_');
y := StrToInt(yStr);

// 获取附近可移动坐标
rdStr := 'getnearxy ' + xStr;
rdStr := rdStr + ' ';
rdStr := rdStr + yStr;
Str := callfunc(rdStr);

// 解析返回的坐标
Str := GetToken(Str, xStr, '_');
xx := StrToInt(xStr);
Str := GetToken(Str, yStr, '_');
yy := StrToInt(yStr);

// 检查是否找到不同位置
if x = xx then begin
   if y = yy then begin
      exit;  // 没找到可移动位置
   end;
end;
```

### 动态构建调用参数
```pascal
// 获取自身坐标
PosStr := callfunc('getposition');
XStr := GetToken(PosStr, xVal, '_');
YStr := GetToken(PosStr, yVal, '_');

// 查找附近可移动点
NearStr := callfunc('getnearxy ' + xVal + ' ' + yVal);
```

## 注意事项

1. **返回值格式**：返回 `X_Y` 格式的字符串，X 和 Y 之间用下划线 `_` 分隔
2. **地图约束**：通过 `TMaper(Maper).GetNearXY` 查找，确保返回的坐标在当前地图上是可移动的
3. **FSelf 上下文**：通过自身对象调用，使用自身的地图数据
4. **坐标修正**：如果给定坐标本身可移动，可能返回原坐标；如果不可移动，返回附近可移动点
5. **解析方法**：使用 `GetToken` 函数和 `_` 分隔符解析返回值

## 相关函数
- `getposition` - 获取自身坐标
- `getsenderposition` - 获取触发者坐标
- `getmoveablexy` - 检查坐标是否可移动
