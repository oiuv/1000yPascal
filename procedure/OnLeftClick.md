# OnLeftClick

玩家左键点击该对象时触发的事件回调。

## 声明
```pascal
procedure OnLeftClick (aStr : String);
```

## 参数
| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串，无附加信息 |

## 触发条件
当玩家在游戏中用鼠标左键点击 NPC 或其他可交互对象时，引擎向该对象发送 `FM_CLICK` 消息触发。这是 NPC 交互的核心事件，适合用于：
- 弹出对话窗口或商店界面
- 触发任务对话
- 打开功能面板（如晋级、传送等）

**源码位置**: `BasicObj.pas` 第 6423-6426 行

## 适用对象
- NPC
- DynamicObject（可交互的）

## 示例

### 示例 1：点击 NPC 弹出对话窗口
> 来源：`bin/Script/一级僧侣.txt`

```pascal
procedure OnLeftClick (aStr : String);
var
   Str : String;
begin
   Str := 'showwindow .\help\give.txt 1';
   print (Str);
   exit;
end;
```

此示例在玩家左键点击僧侣 NPC 时弹出赠送物品的对话窗口。

### 示例 2：太极老人 — 复杂交互入口
> 来源：`bin/Script/太极老人.txt`

```pascal
procedure OnLeftClick (aStr : String);
begin
   // 通过 showwindow 弹出交互界面
   // 后续交互由 OnGetResult 处理
   print ('showwindow .\help\太极老人.txt 1');
end;
```

太极老人 NPC 点击后弹出界面，玩家选择后通过 `OnGetResult` 事件处理具体操作（如进入密室、检查令牌等）。

### 示例 3：比武老人 — 晋级交互
> 来源：`bin/Script/一级比武老人.txt`

```pascal
procedure OnLeftClick (aStr : String);
begin
   print ('showwindow .\help\比武.txt 1');
end;
```

此示例为比武老人 NPC 的点击入口，弹出比武晋级界面。

## 相关事件
- [OnRightClick](OnRightClick.md) — 右键点击时触发
- [OnDblClick](OnDblClick.md) — 双击时触发（仅限物品）
- [OnGetResult](OnGetResult.md) — 对话窗口返回结果时触发
