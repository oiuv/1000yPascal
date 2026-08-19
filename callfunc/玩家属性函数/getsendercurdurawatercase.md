# getsendercurdurawatercase

获取当前触发脚本事件的玩家水桶（竹筒）的耐久状态，判断是否还有水。

## 语法
```pascal
Str := callfunc('getsendercurdurawatercase');
```

## 参数
无参数。

## 返回值
返回字符串，整数形式：
- `'0'` — 水桶耐久为0，没有水
- 其他值 — 水桶有水

## 源码实现
```pascal
// 죽통들의 내구성이 0인지 아닌지 (물이 남아있는지)
Result := IntToStr(TBasicObject(FSender).SGetCurDuraWaterCase);
```
源码注释说明：检查竹筒（水桶）的耐久度是否为0，即是否还有水剩余。

## 示例

### 迷宫玉仙中的水桶检查
基于 `迷宫玉仙.txt`：
```pascal
if aStr = 'givewater' then begin
    Str := callfunc ('getsendercurdurawatercase');

    if Str = '0' then begin
        print ('sendsenderchatmessage 没有竹筒_竹筒无水_都拿不到2');
        exit;
    end;

    print ('changesendercurdurabyname 大型竹筒 0');
    print ('changesendercurdurabyname 竹筒 0');

    print ('showwindow .\help\迷宫玉仙1.txt 1');
    exit;
end;
```

## 注意事项
1. 主要用于迷宫等需要用水的场景，检查玩家是否携带有水的水桶/竹筒
2. 返回 `'0'` 表示竹筒无水或没有竹筒
3. 通常配合 `changesendercurdurabyname` 命令消耗竹筒耐久

## 相关函数
- `getsenderitemcurdurability` — 获取玩家穿戴物品当前耐久度
- `getsenderitemmaxdurability` — 获取玩家穿戴物品最大耐久度
- `getsenderitemexistence` — 检查玩家是否拥有指定物品
