# OnMove

## 声明

```pascal
function OnMove (aStr : String) : String;
```

当玩家移动经过绑定对象时触发，`aStr` 当前为空字符串。事件中 `Self` 是绑定脚本的对象，`Sender` 是移动玩家。

## 返回值

源码存在两条调用路径：

- 普通对象收到 `FM_MOVE` 时会调用事件，但不读取返回值。
- 动态门/入口检查路径会读取返回值；仅精确返回小写字符串 `false` 才会阻止进入、把玩家移到该对象配置的弹出坐标，并提示“无法进入”。

因此，门禁脚本应先把 `Result` 设为 `false`，通过所有条件后再设为 `true`。不要依赖此返回值阻止普通移动事件。

## 示例

以下结构来自云端神武版与炎黄随包均存在的 `gateB_C.txt`，省略了重复的怪物检查。当前炎黄 `gateB_C.txt` **没有进入 `Script.SDB` 索引**，所以这是备用门脚本的语法示例，不代表当前随包已经启用该入口：

```pascal
function OnMove (aStr : String) : String;
var
   Str : String;
begin
   Result := 'false';

   Str := callfunc ('checkalivemopcount 94 monster 近距离野神族B');
   if Str <> '0' then exit;

   Result := 'true';
end;
```

源码依据：`BasicObj.pas` 的 `TBasicObject.FieldProc` 与动态门移动检查路径。
