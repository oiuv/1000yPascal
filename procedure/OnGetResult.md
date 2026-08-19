# OnGetResult

## 声明

```pascal
procedure OnGetResult (aStr : String);
```

## 参数

- `aStr`：玩家在选择对话窗口（`showwindow`）中点击的选项标识符。常见的值包括 `'close'`（关闭）、`'sell'`（出售）、`'buy'`（购买）、`'repair'`（修理）、`'quest'`（任务）、`'give_ok'`（确认给予）等，具体取决于 `showwindow` 打开的对话文件中定义了哪些选项。

## 触发条件

玩家在选项对话窗口（通过 `showwindow` 命令弹出的界面）中选择了某个选项后，该选项对应的标识符作为 `aStr` 参数传入此事件过程。通常与 `OnLeftClick` 配合使用：`OnLeftClick` 中调用 `showwindow` 弹出选项窗口，玩家选择后触发 `OnGetResult`。

## 适用对象

NPC 脚本对象。几乎所有与玩家交互的 NPC 脚本都会使用此事件。

## 示例

### 铁匠（铁匠.txt）—— 根据选项执行不同操作

```pascal
procedure OnGetResult (aStr : String);
var
   Str, Name : String;
   nCur, nDura : Integer;
begin
   if aStr = 'close' then begin
      exit;
   end;
   if aStr = 'sell' then begin
      Name := callfunc ('getsendername');
      Str := 'tradewindow ' + Name;
      Str := Str + ' 0';
      print (Str);
      exit;
   end;
   if aStr = 'buy' then begin
      Name := callfunc ('getsendername');
      Str := 'tradewindow ' + Name;
      Str := Str + ' 1';
      print (Str);
      exit;
   end;
   if aStr = 'smelting' then begin
      print ('showwindow .\help\铁匠提炼.txt 0');
      exit;
   end;
   if aStr = 'repair' then begin
      Str := callfunc ('getsenderrepairitem 9 27');
      if Str = '0' then begin
         print ('say 没带要修理的物品');
         exit;
      end;
      if Str = '1' then begin
         print ('say 老兄,_怎么没带锄头就来了!');
         exit;
      end;
      if Str = '2' then begin
         print ('say 老兄,_这不是修修还能用吗!');
         exit;
      end;
      if Str = '3' then begin
         print ('say 修理不了了，还是另买个吧?');
         exit;
      end;
      exit;
   end;
end;
```

### 一级僧侣（一级僧侣.txt）—— 确认给予物品后检查并发放奖励

```pascal
procedure OnGetResult (aStr : String);
var
   Str, Name : String;
   iRandom, iKind : Integer;
begin
   if aStr = 'give_ok' then begin
      Str := callfunc ('getsenderitemexistence 天桃汁儿:1');
      if Str = 'false' then begin
         Str := 'say 没有天桃汁儿还说什么!!';
         print (Str);
         exit;
      end;

      if Str = 'true' then begin
         Str := 'getsenderitem 天桃汁儿:1';
         print (Str);
         Str := 'say 佛祖保佑..._南无阿弥陀佛....';
         print (str);

         iRandom := Random (50);
         if iRandom < 10 then begin
            Str := callfunc ('checkenoughspace');
            if Str = 'false' then begin
               print ('say 物品栏已满~');
               exit;
            end;
            // ...随机发放武功或物品奖励
            Str := 'putsendermagicitem 如来天王拳 @一级僧侣 4';
            print (Str);
            Str := 'say 这不正是昨天在路上捡到的那件东西吗~';
            print (str);
         end;
         exit;
      end;
      exit;
   end;
end;
```

## 源码位置

- `BasicObj.pas` 第 2999-3002 行

## 相关事件

- [`OnLeftClick`](OnLeftClick.md) —— 通常在此事件中调用 `showwindow` 弹出选项窗口，玩家选择后触发 `OnGetResult`
- [`OnGetChangeStep`](OnGetChangeStep.md) —— 选项操作后的动作变化
