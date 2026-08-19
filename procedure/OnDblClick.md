# OnDblClick

玩家在背包中双击带有 `ITEM_KIND_USESCRIPT`(kind=56) 标记的物品时触发的事件回调。

## 声明
```pascal
procedure OnDblClick (aStr : String);
```

## 参数
| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串，无附加信息 |

## 触发条件
当玩家在背包中双击一个物品时触发，**但前提是该物品在 `item.sdb` 中的 `kind` 字段值为 56（`ITEM_KIND_USESCRIPT`）**。只有标记为此类型的物品才会执行关联的脚本。适合用于：
- 使用消耗品（如药品、卷轴）
- 打开物品关联的界面（如书籍、容器）
- 触发物品特殊效果

**源码位置**: `uUserSub.pas` 第 4650 行

## 适用对象
- Item（仅限 `item.sdb` 中 kind=56 的物品）

## 示例

### 示例 1：双击打开神功界面
> 来源：`bin/Script/四大神功全集.txt`

```pascal
procedure OnDblClick(aStr : String);
begin
   print ('showwindow .\help\四大神功.txt 0');
end;
```

此示例在玩家双击"四大神功全集"物品时弹出神功查阅界面。后续交互由 `OnGetResult` 处理，根据玩家选择检查并修炼对应神功。

### 示例 2：双击打开储物袋
> 来源：`bin/Script/储物袋.txt`

```pascal
procedure OnDblClick(aStr : String);
var
   Str : String;
   Race : Integer;
begin
   Str := callfunc ('getsenderrace');
   Race := StrToInt (Str);
   if Race = 1 then begin
      Str := 'logitemwindow';
      print (Str);
      exit;
   end;
end;
```

此示例在玩家双击"储物袋"物品时，检查操作者为玩家（Race=1）后打开物品日志窗口（储物界面）。

## 相关事件
- [OnLeftClick](OnLeftClick.md) — 左键点击 NPC/对象时触发
- [OnGetResult](OnGetResult.md) — 对话窗口返回结果时触发
- [OnRightClick](OnRightClick.md) — 右键点击时触发
