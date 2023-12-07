# Script

游戏脚本核心文件在Script目录，脚本索引文件为Script.SDB。可以在Map.sdb、Item.SDB、createGate.sdb、CreateDynamicObjectN.sdb、CreateMonsterN.sdb、CreateNpcN.sdb和EventParam.sdb中指定脚本索引。

- MAP和GATE中的脚本理论上只支持OnTimer过程
- OnTimer每秒调用一次，参数aStr值为当前服务器时间(时 分 秒，整点数字为0)，如：19 0 0，为19点0分0秒
- Item脚本只支持双击事件，要求Item的Kind为56
- SDB文件中如果为boXXX只有设置值`UpperCase (Params [1]) = 'TRUE'`的才为TRUE，其它的都为FALSE

## GM测试指令

    // 在当前地图增加一个monster，141为脚本编号（无脚本填0），true为可重生
    print mapaddobjbyname monster 年兽 40 55 1 154 true
    print mapaddobjbyname dynamicobject 幸运女神 44 55 1 0 false
    print mapaddobjbyname npc 卒兵 45 50 1 0 false
    print mapregen 115
    // putsendermagicitem 第3个参数是RACE：动态物品为5，NPC为4，怪物为3，物品为2，玩家为1
    print putsendermagicitem 爆竹:1 @礼盒 2

## 重要提示

- 千年脚本并不是原生的Pascal语言，而是由ScriptCls.pas实现，以`unit`的方式调用
- 千年脚本标识符只能用小写
- 流程控制语句只支持if和for，且if不支持else分支
- 不支持连续`+`，不支持字符串和函数相加，也不支持连续运算，如1 + 2 * 3。
- 数据类型只支持Integer、String和Boolean(不支持数组，且Boolean不能赋值)
- `say str delay`指令str字符串有长度限制，超过后代码出错，表现为执行无反应
- Integer类型最大值是2147483647,超过后溢出为-2147483648
- 算术运算符：加法运算符（+）、减法运算符（-）、乘法运算符（*）、除法运算符（/和div）和取余运算符（mod）
- 关系运算符：等于（=）、不等于（<>）、大于（>）、小于（<）、大于或等于（>=）和小于或等于（<=）

### unit

在Pascal语言中，`unit` 是一个模块化编程的概念，用于将代码组织成独立的单元。`unit` 通常包含了一个或多个相关联的过程、函数、类型定义、变量等，它们被设计成一起工作，形成一个功能上独立的单元。Pascal语言中的 `unit` 有以下几个关键点：

1. **定义：** `unit` 用于声明一个模块，通常包含在一个 `.pas` 文件中。一个 `unit` 中可以包含过程、函数、类型定义、变量、常量等。

    ```pascal
    unit MyUnit;

    interface

    // 这里是接口部分，包含了对外可见的声明

    implementation

    // 这里是实现部分，包含了具体的实现代码

    end.
    ```

2. **接口部分：** 在 `unit` 的 `interface` 部分声明对外可见的标识符，例如过程、函数、类型、变量等。这些标识符可以被其他单元引用。

    ```pascal
    unit MyUnit;

    interface

    procedure MyProcedure;

    implementation

    procedure MyProcedure;
    begin
      // 具体实现
    end;

    end.
    ```

3. **实现部分：** 在 `unit` 的 `implementation` 部分提供对接口部分声明的实现。这是实际代码的地方。

    ```pascal
    unit MyUnit;

    interface

    procedure MyProcedure;

    implementation

    procedure MyProcedure;
    begin
      Writeln('Hello from MyProcedure!');
    end;

    end.
    ```

4. **使用：** 其他的Pascal程序可以通过 `uses` 关键字引用 `unit`，这样就可以使用 `unit` 中声明的标识符。

    ```pascal
    program MainProgram;

    uses
      MyUnit;

    begin
      MyProcedure;
    end.
    ```

`unit` 的引入使得Pascal程序更容易维护和理解，因为它允许将代码划分为逻辑上相关的部分，并且可以通过模块化的方式组织和管理代码。

## 千年脚本开发演示

在游戏中增加一个杂货商，需要怎么做？具体需要做的工作如下：

1. 需要增加一个NPC到游戏中
2. 需要实现点击NPC弹出交易界面
3. 需要设置交易界面内容
4. 需要设置NPC买卖内容
5. 需要设置NPC自动说话提醒玩家
6. 需要把这个NPC放到地图指定坐标

相关配置文件列表：

- Init\Npc.sdb            
- Script\杂货商.txt        
- Script\Script.sdb       
- Help\杂货商.txt  
- NpcSetting\杂货商.txt   
- NpcSetting\杂货商.sdb
- Setting\CreateNpc88.sdb

### 初始化NPC设置

在`Init`目录下的`Npc.sdb`中增加杂货商NPC，内容如下：

    杂货商,杂货商,-100,,杂货商.txt,TRUE,,TRUE,,,,TRUE,14,33,131,150,30,,,,3500,0,0,0,0,,4,,,,,,,,,,,,,,,,

这里指定了NPC的名称为`杂货商`，设置了属性、外形等参数，指定了NPC交易脚本为`杂货商.txt`，这个文件应该在`NpcSetting`目录下，由`tradewindow`触发。

### 买卖物品列表

在`NpcSetting`目录下新建`杂货商.txt`，内容如下：
```
SELLTITLE:杂货商
SELLCAPTION:要买什么呢?
SELLIMAGE:131
SELLITEM:牛黄
SELLITEM:木皮
SELLITEM:骨头一
SELLITEM:鹿角一
SELLITEM:鹿茸一
SELLITEM:葛根
SELLITEM:甘草
SELLITEM:沙参
SELLITEM:何首乌
SELLITEM:地种参
SELLITEM:天然参
SELLITEM:生铁
SELLITEM:青铜原石
SELLITEM:黄铜原石
SELLITEM:砂金原石
SELLITEM:黄金原石
SELLITEM:白金原石
SELLITEM:千年纯金原石
SELLITEM:硅石原石
SELLITEM:黑石原石
SELLITEM:月石原石
SELLITEM:玄石原石
SELLITEM:耀阳原石
SELLITEM:千年金刚石原石
SELLITEM:青玉原石
SELLITEM:绿玉原石
SELLITEM:黄玉原石
SELLITEM:白玉原石
SELLITEM:黑珍珠原石
SELLITEM:千年水晶原石
SELLITEM:普通水石
SELLITEM:碳酸水石
SELLITEM:冷却水石
SELLITEM:温泉水石
SELLITEM:矿泉水石
SELLITEM:吸着水石
SELLITEM:爆裂水石
SELLITEM:千年水石
BUYTITLE:杂货商
BUYCAPTION:我只收购异宝！
BUYIMAGE:131
BUYITEM:银月魂
BUYITEM:蓝月魂
BUYITEM:金月魂
BUYITEM:赤月魂
BUYITEM:翠月魂
BUYITEM:珍珠
BUYITEM:翡翠
BUYITEM:水晶
BUYITEM:琥珀
BUYITEM:王妃金冠
BUYITEM:公主戒指
BUYITEM:王子宝剑
BUYITEM:公主项链
```

这是`Npc.sdb`中杂货商参数设置的脚本文件，设定了NPC可交易的列表。

### NPC自动说话内容

在`NpcSetting`目录下新建`杂货商.sdb`，内容如下：

```
Name,boSelfSay,boMain,MainNumber,HearString,SayString,NeedItem,GiveItem,CountLimit,RecoverTime,DelayTime,
1,TRUE,,,,廉价出售各种加工材料,,,,,1500,
2,TRUE,,,,走过路过不要错过啊,,,,,2100,
3,TRUE,,,,收购各种宝物啦,,,,,3000,

```

这个文件指定了NPC自动说话内容，把NPC放到地图上时需要用到。

### 交易界面内容

在`Help`目录中新建`杂商货.txt`，内容如下：
```
<trade>
<head>
<title>杂货商</title>
<image name=z33 value=131>
<text>
材料廉价出售，宝物高价回收，你懂的！
</text>
<command send='close'>关闭</command>
<command send="sell">买 物品</command>
<command send="buy">卖 物品</command>
</trade>
```

这里指定了交易界面的内容，包括说明和菜单，在脚本中调用。

### 交易脚本代码

在`Script`目录下新建`杂货商.txt`，内容如下：

```pascal
unit 杂货商;

interface

function  GetToken (aStr, aToken, aSep : String) : String;
function  CompareStr (aStr1, aStr2 : String) : Boolean;
function  callfunc (aText: string): string;
procedure print (aText: string);
function  Random (aScope: integer): integer;
function  Length (aText: string): integer;
procedure Inc (aInt: integer);
procedure Dec (aInt: integer);
function  StrToInt (astr: string): integer;
function  IntToStr (aInt: integer): string;
procedure exit;

procedure OnHear (aStr : String);
procedure OnGetResult (aStr : String);
procedure OnLeftClick (aStr : String);

var
   iCallCount : Integer = 0;

implementation

procedure OnLeftClick (aStr : String);
var
   Str : String;
   Race : Integer;
begin
   Str := callfunc ('getsenderrace');
   Race := StrToInt (Str);
   if Race = 1 then begin
      Str := 'showwindow .\help\杂货商.txt 1';
      print (Str);
      exit; 
   end;
end;

procedure OnGetResult (aStr : String);
var
   Str, Name : String;
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
end;

procedure OnHear (aStr : String);
var
   Str, Str1, Str2, Str3, num : String;
   Race, n, p : Integer;
begin
   Str := callfunc ('getsenderrace');
   Race := StrToInt (Str);
   if Race <> 1 then exit;
   Str := aStr;
   Str := GetToken (Str, Str1, '_');
   Str := GetToken (Str, Str2, '_');
   Str := GetToken (Str, Str3, '_');
   n := StrToInt (Str3);
   Str3 := IntToStr (n);
   if n = 0 then exit;
   if Str <> '' then exit;
   if Str1 = '买' then begin
      p := 0;
      if Str2 = '葛根' then p := 60;
      if Str2 = '牛黄' then p := 260;
      p := n*p;
      if p = 0 then begin
         print ('say 现在只有以下物品可以快捷交易：');
         print ('say 葛根、牛黄 100');
         exit;
      end;
      num := IntToStr (p);
      Str := 'getsenderitemexistence 钱币:' + num;
      Str := callfunc (Str);
      if Str = 'false' then begin
         Str := 'say 你没有这么多钱币买';
         Str := Str + Str2;
         print (Str);
         exit;
      end;
      Str := callfunc ('checkenoughspace');
      if Str = 'false' then begin
         print ('say 您的物品栏已满~');
         exit;
      end;
      Str := 'getsenderitem 钱币:' + num;
      print (Str);
      Str := 'putsendermagicitem ' + Str2;
      Str := Str + ':';
      Str := Str + Str3;
      Str := Str + ' @杂货商 4';
      print (Str);
      print ('say 交易完毕，请问还要买什么吗？');
      exit;
   end;
end;

end.
```

脚本指定了点击NPC的功能和交易相关功能。

### 脚本索引

在`Script`目录下的`Script.SDB`中增加杂货商脚本的索引，编号请按顺序增加，编号会在配置NPC到地图上时用到。

### 在编号88的地图上生成NPC

在`Setting`目录下的`CreateNpc88.sdb`中增加以下内容，其中`杂货商.sdb`是NPC自动随机说话的内容。

    3,杂货商,62,77,1,2,139,杂货商.sdb,

这里指定了NPC的名称、坐标、互动脚本和自动发言内容文件，名称、脚本和发言都是前面配置好的文件。

-------

以上示例是比较完整的演示，实际开发中可以选择性的配置，比如只增加一个NPC到地图，那就不需要交易和脚本相关的配置。

## ScriptEvent

```pascal
procedure TBasicObject.SetScript(aIndex: Integer);
begin
   SOnHear := ScriptManager.CheckScriptEvent(aIndex, 'OnHear');
   SOnShow := ScriptManager.CheckScriptEvent(aIndex, 'OnShow');

   SOnCreate := ScriptManager.CheckScriptEvent(aIndex, 'OnCreate');
   SOnDestroy := ScriptManager.CheckScriptEvent(aIndex, 'OnDestroy');
   SOnDanger := ScriptManager.CheckScriptEvent(aIndex, 'OnDanger');
   SOnHit := ScriptManager.CheckScriptEvent(aIndex, 'OnHit');
   SOnBow := ScriptManager.CheckScriptEvent(aIndex, 'OnBow');
   SOnStructed := ScriptManager.CheckScriptEvent(aIndex, 'OnStructed');
   SOnHide := ScriptManager.CheckScriptEvent(aIndex, 'OnHide');
   SOnDie := ScriptManager.CheckScriptEvent(aIndex, 'OnDie');
   SOnDieBefore := ScriptManager.CheckScriptEvent(aIndex, 'OnDieBefore');
   SOnLeftClick := ScriptManager.CheckScriptEvent(aIndex, 'OnLeftClick');
   SOnRightClick := ScriptManager.CheckScriptEvent(aIndex, 'OnRightClick');
   SOnDblClick := ScriptManager.CheckScriptEvent(aIndex, 'OnDblClick');
   SOnDropItem := ScriptManager.CheckScriptEvent(aIndex, 'OnDropItem');
   SOnChangeState := ScriptManager.CheckScriptEvent(aIndex, 'OnChangeState');
   SOnMove := ScriptManager.CheckScriptEvent(aIndex, 'OnMove');
   SOnTimer := ScriptManager.CheckScriptEvent(aIndex, 'OnTimer');
   SOnApproach := ScriptManager.CheckScriptEvent(aIndex, 'OnApproach');
   SOnAway := ScriptManager.CheckScriptEvent(aIndex, 'OnAway');
   SOnUserStart := ScriptManager.CheckScriptEvent(aIndex, 'OnUserStart');
   SOnUserEnd := ScriptManager.CheckScriptEvent(aIndex, 'OnUserEnd');
   SOnArrival := ScriptManager.CheckScriptEvent(aIndex, 'OnArrival');
   SOnGetResult := ScriptManager.CheckScriptEvent(aIndex, 'OnGetResult');
   SOnTurnOn := ScriptManager.CheckScriptEvent(aIndex, 'OnTurnOn');
   SOnTurnOff := ScriptManager.CheckScriptEvent(aIndex, 'OnTurnOff');
   SOnRegen := ScriptManager.CheckScriptEvent(aIndex, 'OnRegen');
   SOnGetChangeStep := ScriptManager.CheckScriptEvent(aIndex, 'OnGetChangeStep');
end;
```

## CommandScript(print)

```pascal
procedure TScriptManager.CommandScript (aSelf : Pointer; aSender : Pointer; Cmd : String; Params : array of string);
var
   Str : String;
begin
   if Cmd = 'say' then begin
      Str := ChangeScriptString (Params [0], '_', ' ');
      TBasicObject (aSelf).PushCommand (CMD_SAY, Str, _StrToInt (Params [1]));
   end else if Cmd = 'saybyname' then begin
      Str := ChangeScriptString (Params [2], '_', ' ');
      TBasicObject (aSelf).SSayByName (Params [0], Params[1], Str, _StrToInt (Params [3]));
   end else if Cmd = 'attack' then begin
      TBasicObject (aSelf).PushCommand (CMD_ATTACK, Params, 0);
   end else if Cmd = 'selfkill' then begin
      TBasicObject (aSelf).PushCommand (CMD_SELFKILL, Params, 0);
   end else if Cmd = 'gotoxy' then begin
      TBasicObject (aSelf).PushCommand (CMD_GOTOXY, Params, 0);
   end else if Cmd = 'changestate' then begin
      TBasicObject (aSelf).PushCommand (CMD_CHANGESTATE, Params, 0);
   end else if Cmd = 'sendnoticemsgformapuser' then begin
      Str := ChangeScriptString (Params [1], '_', ' ');   
      TBasicObject (aSelf).SSendNoticeMessageForMapUser (_StrToInt (Params [0]), Str, _StrToInt (Params [2]));
   end else if Cmd = 'sendcentermsg' then begin                        // for test;
      Str := ChangeScriptString (Params [1], '_', ' ');
      Params [1] := Str;
      TBasicObject (aSelf).PushCommand (CMD_SENDCENTERMSG, Params, 0);
   end else if Cmd = 'sendsendertopmsg' then begin                    
      Str := ChangeScriptString (Params [0], '_', ' ');
      Params [0] := Str;
      TBasicObject (aSender).SSendTopMessage (Params [0]);
   end else if cmd = 'showwindow' then begin
      TBasicObject (aSender).SShowWindow (FSelf, Params [0], _StrToInt (Params [1]));
   end else if cmd = 'tradewindow' then begin
      TBasicObject (aSelf).STradeWindow (Params [0], _StrToInt (Params [1]));
   end else if cmd = 'startwindow' then begin
      TBasicObject (aSelf).SShowWindow (FSelf, Params [0], _StrToInt (Params [1]));
   end else if cmd = 'logitemwindow' then begin
      TBasicObject (aSender).SLogItemWindow (FSelf);
   end else if cmd = 'guilditemwindow' then begin
      TBasicObject (aSender).SGuildItemWindow (FSelf);
   end else if cmd = 'setautomode' then begin
      TBasicObject (aSelf).SSetAutoMode;
   end else if cmd = 'putsendermagicitem' then begin
      TBasicObject (aSender).SPutMagicItem (Params [0], Params [1], _StrToInt (Params [2]));
   end else if cmd = 'getsenderitem' then begin
      TBasicObject (aSender).SGetItem (Params [0]);
   end else if cmd = 'getsenderitem2' then begin
      TBasicObject (aSender).SGetItem2 (Params [0]);
   end else if cmd = 'getsenderallitem' then begin
      TBasicObject (aSender).SGetAllItem (Params [0]);
   end else if cmd = 'deletequestitem' then begin
      TBasicObject (aSender).SDeleteQuestItem;
   end else if cmd = 'changecompletequest' then begin
      TBasicObject (aSelf).SChangeCompleteQuest (_StrToInt (Params [0]));
   end else if cmd = 'changecurrentquest' then begin
      TBasicObject (aSelf).SChangeCurrentQuest (_StrToInt (Params [0]));
   end else if cmd = 'changefirstquest' then begin
      TBasicObject (aSelf).SChangeFirstQuest (_StrToInt (Params [0]));
   end else if cmd = 'changesendercompletequest' then begin
      TBasicObject (aSender).SChangeCompleteQuest (_StrToInt (Params [0]));
   end else if cmd = 'changesendercurrentquest' then begin
      TBasicObject (aSender).SChangeCurrentQuest (_StrToInt (Params [0]));
   end else if cmd = 'changesenderqueststr' then begin
      TBasicObject (aSender).SChangeQuestStr (Params [0]);
   end else if cmd = 'changesenderfirstquest' then begin
      TBasicObject (aSender).SChangeFirstQuest (_StrToInt (Params [0]));
   end else if cmd = 'addaddablestatepoint' then begin
      TBasicObject (aSender).SAddAddableStatePoint (_StrToInt (Params [0])); 
   end else if cmd = 'addtotalstatepoint' then begin
      TBasicObject (aSender).STotalAddableStatePoint (_StrToInt (Params [0]));
   end else if cmd = 'changedynobjstate' then begin
      if UpperCase (Params [1]) = 'TRUE' then begin
         TBasicObject (aSelf).SChangeDynobjState (Params[0], true);
      end else begin
         TBasicObject (aSelf).SChangeDynobjState (Params[0], false);
      end;
   end else if cmd = 'changesenderdynobjstate' then begin
      TBasicObject (aSelf).PushCommand (CMD_CHANGESTEP, Params, 0);
   end else if cmd = 'sendzoneeffectmsg' then begin
      TBasicObject (aSelf).SSendZoneEffectMessage (Params [0]);
   end else if cmd = 'sendsenderchatmessage' then begin
      if aSender <> nil then begin
         Str := ChangeScriptString (Params [0], '_', ' ');
         TBasicObject (aSender).SSendChatMessage (Str, _StrToInt (Params[1]));
      end;
   end else if cmd = 'movespace' then begin
      TBasicObject (aSelf).PushCommand (CMD_MOVESPACE, Params, _StrToInt (Params [5]));
   end else if cmd = 'directmovespace' then begin
      TBasicObject (aSelf).SMoveSpace (Params [0], Params [1], _StrToInt (Params[2]), _StrToInt (Params [3]), _StrToInt (Params [4]));
   end else if cmd = 'movespacebyname' then begin
//      TBasicObject (aSelf).SMoveSpaceByName (Params, Params [5], Params [6], _StrToInt (Params [7]));
// add by Orber at 2004-09-29 10:51
      TBasicObject (aSelf).SMoveSpaceByName (Params, Params [0], Params [1], 1);
   end else if cmd = 'setallowhitbyname' then begin
      TBasicObject (aSelf).SSetAllowHitByName (Params [0], Params [1], Params [2]);
   end else if cmd = 'setallowhitbytick' then begin
      TBasicObject (aSelf).PushCommand (CMD_ALLOWHIT, Params, _StrToInt (Params [1])); 
   end else if cmd = 'setallowhit' then begin
      TBasicObject (aSelf).SSetAllowHit (Params [0]);
   end else if cmd = 'setallowdelete' then begin
      TBasicObject (aSelf).SSetAllowDelete (Params [0], Params [1]);
   end else if cmd = 'showeffect' then begin
      TBasicObject (aSelf).SShowEffect (_StrToInt (Params [0]), _StrToInt (Params [1]));
   end else if cmd = 'commandice' then begin
      TBasicObject (aSelf).SCommandIce (_StrToInt (Params [0]));
   end else if cmd = 'commandicebyname' then begin
      TBasicObject (aSelf).SCommandIceByName (Params [0], Params [1], _StrToInt (Params [2]));
   end else if cmd = 'clearworkbox' then begin
      TBasicObject (aSelf).SClearWorkBox;
   end else if cmd = 'regen' then begin
      TBasicObject (aSelf).SRegen (Params [0], Params [1]);
   end else if cmd = 'mapregen' then begin
      TBasicObject (aSelf).SMapRegen (_StrToInt (Params [0]));
   end else if cmd = 'mapregenbyname' then begin
      TBasicObject (aSelf).SMapRegenByName (Params, Params [1], Params [2]);
   //2002-07-23 giltae
   end else if cmd = 'mapdelobjbyname' then begin
      TBasicObject (aSelf).SMapDelObjByName (Params [0], Params [1]);
   //-----------------------
   end else if cmd = 'mapaddobjbyname' then begin
      TBasicObject (aSelf).SMapAddObjByName (Params [0], Params);
   end else if cmd = 'mapaddobjbytick' then begin
      TBasicObject (aSelf).PushCommand (CMD_ADDMOP, Params, _StrToInt (Params [7]));
   end else if cmd = 'sendsound' then begin
      TBasicObject (aSelf).SSendSound (Params [0], _StrToInt (Params [1]));
   // end else if cmd = 'setsenderjobtool' then begin
   //    TBasicObject (aSender).SSetJobTool (Params [0]);
   end else if cmd = 'senditemmoveinfo' then begin
      TBasicObject (aSender).SSendItemMoveInfo (Params [0]);
   end else if cmd = 'setsenderjobkind' then begin
      TBasicObject (aSender).SSetJobKind (_StrToInt (Params [0]));
   end else if cmd = 'setsendervirtueman' then begin
      TBasicObject (aSender).SSetVirtueman;
   // end else if cmd = 'setsenderjobgrade' then begin
   //    TBasicObject (aSender).SSetJobGrade (Params [0]);
   end else if cmd = 'sendersmeltitem' then begin
      TBasicObject (aSender).SSmeltItem (Params [0]);
   end else if cmd = 'sendersmeltitem2' then begin           // 제련한거 교환때문에
      TBasicObject (aSender).SSmeltItem2 (Params [0]);
   {
   end else if cmd = 'senderinitialtalent' then begin
      TBasicObject (aSender).SInitialTalent(_StrToInt (Params [0]));
   }
   end else if cmd = 'boiceallbyname' then begin
      TBasicObject (aSelf).SboIceAllbyName(Params [0], Params [1], Params [2]);
   end else if cmd = 'bohitallbyname' then begin
     TBasicObject (aSelf).SboHitAllbyName(Params [0], Params [1], Params [2]);
   end else if cmd = 'bopickbymapname' then begin
      TBasicObject (aSelf).SboPickbyMapName(Params [0], Params [1]);
   end else if cmd = 'reposition' then begin
      TBasicObject (aSelf).SRePosition(aSender);
   end else if cmd = 'returndamage' then begin
      TBAsicObject (aSelf).SReturnDamage (aSender, _StrToInt (Params [0]), _StrToInt (Params [1]));
   end else if cmd = 'selfchangedynobjstate' then begin           //2002-08-06 giltae
      if Uppercase (Params[0]) = 'TRUE' then begin
         TBasicObject (aSelf).SSelfChangeDynobjState (true);
      end else begin
         TBasicObject (aSelf).SSelfChangeDynobjState (false);
      end;
   end else if cmd = 'questcomplete' then begin
      TBasicObject (aSelf).SQuestComplete(Params[0], Params[1] );
   end else if cmd = 'senderrefill' then begin
      TBasicObject (aSender).SRefill;
   end else if cmd = 'changesendercurdurabyname' then begin   // 아이템 내구성 바꿔주는거... 03.04.03
      TBasicObject (aSender).SChangeCurDuraByName (Params [0], _StrToInt (Params [1]));
   end else if cmd = 'boMapEnter' then begin                  // 맵에 들어갈수 있는지 없는지 03.05.06 saset
      TBasicObject (aSender).SboMapEnter (_StrToInt (Params [0]), Params [1]);
   end else if cmd = 'usemagicgradeup' then begin
      TBasicObject (aSender).SUseMagicGradeup(_StrToInt(Params[0]),_StrToInt(Params[1]));
   end else if cmd = 'decreasePrisonTime' then begin
      TBasicObject (aSender).SDecreasePrisonTime(_StrToInt(Params[0]));
   end else if cmd = 'athleticprocess' then begin
      UserList.AddItemByEventTeam (_StrToInt (Params [0]), Params [1], Params [2]);
      UserList.MoveByServerID (_StrToInt (Params [0]), 1, 554, 119);
    end else if cmd = 'marry' then begin
      TUser(aSender).MarryWindow(Params[0]);
    end else if cmd = 'unmarry' then begin
        TUser(aSender).UnMarryWindow(Params [0]);
    end else if cmd = 'activebank' then begin
        TUser(aSender).GuildActiveBank;
    end else if cmd = 'buymoneychip' then begin
        TUser(aSender).GuildBuyMoneyChip;
    end else if cmd = 'setmarryclothes' then begin
        MarryList.SetClothes(TUser(aSender).Name);
    end else if cmd = 'setoutzhuang' then begin
        TUser(aSender).inZhuang := False;
    end;

end;
```

## CallFunction(callfunc)

```pascal
function TScriptManager.CallFunction (aStr : String) : String;
var
   i, MapID : Integer;
   cmd, str : String;
   Params : array [0..10 - 1] of String;
   Xpos, Ypos, xx1, yy1, xx2, yy2 : Word;
begin
   Result := '';

   if FSelf = nil then exit;
   if ManagerList = nil then exit;
   if GuildList = nil then exit;
   if UserList = nil then exit;

   Str := aStr;
   Str := GetValidStr3 (Str, cmd, ' ');
   for i := 0 to 10 - 1 do begin
      if Str = '' then break;
      Str := GetValidStr3 (Str, Params [i], ' ');
      if Params [i] = '' then break;
   end;

   if cmd = 'getsysteminfo' then begin
      Result := TBasicObject (FSelf).SGetSystemInfo (Params [0]);
   end else if cmd = 'getname' then begin
      Result := TBasicObject (FSelf).SGetName;
   end else if cmd = 'getsendername' then begin
      Result := TBasicObject (FSender).SGetName;
   end else if cmd = 'getage' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetAge);
   end else if cmd = 'getsenderage' then begin
      Result := IntToStr (TBasicObject (FSender).SGetAge);
   end else if cmd = 'getsex' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetSex);
   end else if cmd = 'getsendersex' then begin
      Result := IntToStr (TBasicObject (FSender).SGetSex);
   end else if cmd = 'getid' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetId);
   end else if cmd = 'getsenderid' then begin
      Result := IntToStr (TBasicObject (FSender).SGetId);
   end else if cmd = 'getserverid' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetServerId);
   end else if cmd = 'getsenderserverid' then begin
      Result := IntToStr (TBasicObject (FSender).SGetServerId);
   end else if cmd = 'findobjectbyname' then begin
      Result := IntToStr (TBasicObject (FSelf).SFindObjectByName (Params [0]));
   end else if cmd = 'getposition' then begin
      TBasicObject (FSelf).SGetPosition (MapId, Xpos, Ypos);
      Result := IntToStr (Xpos) + '_' + IntToStr (Ypos);
   end else if cmd = 'getsenderposition' then begin
      if FSender = nil then exit;
      TBasicObject (FSender).SGetPosition (MapId, Xpos, Ypos);
      Result := IntToStr (Xpos) + '_' + IntToStr (Ypos);
   end else if cmd = 'getnearxy' then begin
      Result := TBasicObject (FSelf).SGetNearXY (_StrToInt (Params[0]), _StrToInt (Params [1]));
   end else if cmd = 'getmapname' then begin
      Result := TBasicObject (FSelf).SGetMapName;
   end else if cmd = 'getsendermapname' then begin
      Result := TBasicObject (FSender).SGetMapName;
   end else if cmd = 'getmoveablexy' then begin
      Result := TBasicObject (FSelf).SGetMoveableXY (_StrToInt (Params[0]), _StrToInt (Params [1]));
   end else if cmd = 'getrace' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetRace);
   end else if cmd = 'getsenderrace' then begin
      Result := IntToStr (TBasicObject (FSender).SGetRace);
   end else if cmd = 'getmaxlife' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetMaxLife);
   end else if cmd = 'getsendermaxlife' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMaxLife);
   end else if cmd = 'getmaxinpower' then begin
      Result := IntToStr (TBasicobject (FSelf).SGetMaxInPower);
   end else if cmd = 'getsendermaxinpower' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMaxInPower);
   end else if cmd = 'getmaxoutpower' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetMaxOutPower);
   end else if cmd = 'getsendermaxoutpower' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMaxOutPower);
   end else if cmd = 'getmaxmagic' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetMaxMagic);
   end else if cmd = 'getsendermaxmagic' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMaxMagic);
   end else if cmd = 'getlife' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetLife);
   end else if cmd = 'getsenderlife' then begin
      Result := IntToStr (TBasicObject (FSender).SGetLife);
   end else if cmd = 'getheadlife' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetHeadLife);
   end else if cmd = 'getsenderheadlife' then begin
      Result := IntToStr (TBasicObject (FSender).SGetLife);
   end else if cmd = 'getarmlife' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetArmLife);
   end else if cmd = 'getsenderarmlife' then begin
      Result := IntToStr (TBasicObject (FSender).SGetArmLife);
   end else if cmd = 'getleglife' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetLegLife);
   end else if cmd = 'getsenderleglife' then begin
      Result := IntToStr (TBasicObject (FSender).SGetLegLife);
   end else if cmd = 'getpower' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetPower);
   end else if cmd = 'getsenderpower' then begin
      Result := IntToStr (TBasicObject (FSender).SGetPower);
   end else if cmd = 'getinpower' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetInPower);
   end else if cmd = 'getsenderinpower' then begin
      Result := IntToStr (TBasicObject (FSender).SGetInPower);
   end else if cmd = 'getoutpower' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetOutPower);
   end else if cmd = 'getsenderoutpower' then begin
      Result := IntToStr (TBasicObject (FSender).SGetOutPower);
   end else if cmd = 'getmagic' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetMagic);
   end else if cmd = 'getsendermagic' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMagic);
   end else if cmd = 'getvirtue' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetVirtue); //2002-07-31 giltae
   end else if cmd = 'getsendervirtue' then begin
      Result := IntToStr (TBasicObject (FSender).SGetVirtue);//2002-07-31 giltae
   end else if cmd = 'getsendertalent' then begin
      Result := IntToStr (TBasicObject (FSender).SGetTalent);
   end else if cmd = 'getmovespeed' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetMoveSpeed);
   end else if cmd = 'getsendermovespeed' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMoveSpeed);
   end else if cmd = 'getuseattackmagic' then begin
      Result := TBasicObject (FSelf).SGetUseAttackMagic;
   end else if cmd = 'getsenderuseattackmagic' then begin
      Result := TBasicObject (FSender).SGetUseAttackMagic;
   end else if cmd = 'getuseattackskilllevel' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetUseAttackSkillLevel);
   end else if cmd = 'getsenderuseattackskilllevel' then begin
      Result := IntToStr (TBasicObject (FSender).SGetUseAttackSkillLevel);
   end else if cmd = 'getsendermagicskilllevel' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMagicSkillLevel (Params [0]));
   end else if cmd = 'getuseprotectmagic' then begin
      Result := TBasicObject (FSelf).SGetUseProtectMagic;
   end else if cmd = 'getsenderuseprotectmagic' then begin
      Result := TBasicObject (FSender).SGetUseProtectMagic;
   end else if cmd = 'getcompletequest' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetCompleteQuest);
   end else if cmd = 'getsendercompletequest' then begin
      Result := IntToStr (TBasicObject (FSender).SGetCompleteQuest);
   end else if cmd = 'getcurrentquest' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetCurrentQuest);
   end else if cmd = 'getsendercurrentquest' then begin
      Result := IntToStr (TBasicObject (FSender).SGetCurrentQuest);
   end else if cmd = 'getsenderqueststr' then begin
      Result := TBasicObject (FSender).SGetQuestStr;
   end else if cmd = 'getfirstquest' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetFirstQuest);
   end else if cmd = 'getsenderfirstquest' then begin
      Result := IntToStr (TBasicObject (FSender).SGetFirstQuest);
   end else if cmd = 'getdistance' then begin
      xx1 := TBasicObject (FSender).BasicData.x;
      yy1 := TBasicObject (FSender).BasicData.y;
      xx2 := TBasicObject (FSelf).BasicData.x;
      yy2 := TBasicObject (FSelf).BasicData.y;
      Result := IntToStr (GetLargeLength (xx1, yy1, xx2, yy2));
   end else if cmd = 'getsenderitemexistence' then begin
      Result := TBasicObject (FSender).SGetItemExistence (Params [0], _StrToInt (Params [1]));
   end else if cmd = 'getsenderitemexistencebykind' then begin
      Result := TBasicObject (FSender).SGetItemExistenceByKind (_StrToInt (Params [0]), _StrToInt (Params [1]));
   end else if cmd = 'startmissiontime' then begin
      Result := IntToStr(Trunc(TBasicObject (FSender).SStartMissionTime));
   end else if cmd = 'getpassmissiontime' then begin
      Result := IntToStr(Trunc(TBasicObject (FSender).SGetPassMissionTime));
   end else if cmd = 'getintoarena' then begin
      Result := IntToStr(TBasicObject (FSender).SGetIntoArenaGame (_StrToInt (Params [0])));
   end else if cmd = 'getstartarena' then begin
      Result := IntToStr(TBasicObject (FSender).SStartArenaGame);
   end else if cmd = 'checkenoughspace' then begin
      if Params[0] = '' then begin
         i := 1;
      end else begin
         i := _StrToInt(Params[0]);
      end;
      Result := TBasicObject (FSender).SCheckEnoughSpace (i);
   end else if cmd = 'gethavegradequestitem' then begin
      Result := TBasicObject (FSender).SGetHaveGradeQuestItem;
   end else if cmd = 'getpossiblegrade' then begin
      Result := TBasicObject (FSender).SGetPossibleGrade(_StrToInt(Params[0]),_StrToInt(Params[1]));
   end else if cmd = 'checkalivemopcount' then begin
      Result := IntToStr (TBasicObject (FSelf).SCheckAliveMonsterCount (_StrToInt (Params [0]), Params [1], Params [2]));
   end else if cmd = 'getusercount' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetUserCount (_StrToInt (Params [0])));
   end else if cmd = 'getsenderjobkind' then begin
      Result := IntToStr (TBasicObject (FSender).SGetJobKind);
   end else if cmd = 'getsenderjobgrade' then begin
      Result := IntToStr (TBasicObject (FSender).SGetJobGrade);
   end else if cmd = 'getsenderitemcurdurability' then begin
      Result := IntToStr (TBasicObject (FSender).SGetWearItemCurDurability (_StrToInt (Params [0])));
   end else if cmd = 'getsenderitemmaxdurability' then begin
      Result := IntToStr (TBasicObject (FSender).SGetWearItemMaxDurability (_StrToInt (Params [0])));
   end else if cmd = 'getsenderwearitemname' then begin
      Result := TBasicObject (FSender).SGetWearItemName (_StrToInt (Params [0]));
   end else if cmd = 'checkobjectalive' then begin
      if ManagerList.CheckObjectAlive (Params [0], Params [1], Params [2]) = true then begin
         Result := 'true';
      end else begin
         Result := 'false';
      end;
   end else if cmd = 'getsendermagiccountbyskill' then begin
      Result := TBasicObject (FSender).SGetMagicCountBySkill (_StrToInt (Params [0]), _StrToInt (Params [1]));       
   end else if cmd = 'getsenderrepairitem' then begin
      Result := IntToStr (TBasicObject (FSender).SRepairItem (_StrToInt (Params [0]), _StrToInt (Params [1])));
   end else if cmd = 'getsenderdestroyitem' then begin
      Result := IntToStr (TBasicObject (FSender).SDestroyItembyKind (_StrToInt (Params [0]), _StrToInt (Params [1])));
   end else if cmd = 'getsenderitemcountbyname' then begin
      Result := TBasicObject (FSender).SFindItemCount (Params [0]);
   end else if cmd = 'checksenderpowerwearitem' then begin      // 능력치아이템있는지 검사
      Result := IntToStr (TBasicObject (FSender).SCheckPowerWearItem);
   end else if cmd = 'checksendercurusemagic' then begin
      Result := TBasicObject (FSender).SCheckCurUseMagic (_StrToInt (Params [0]));
   end else if cmd = 'checkusemagicbygrade' then begin
      Result := TBasicObject (FSender).SCheckCurUseMagicByGrade (_StrToInt (Params [0]), _StrToInt(Params[1]), _StrToInt(Params[2]));
   end else if cmd = 'getsendercurpowerlevelname' then begin
      Result := TBasicObject (FSender).SGetCurPowerLevelName;
   end else if cmd = 'getsendercurpowerlevel' then begin
      Result := IntToStr (TBasicObject (FSender).SGetCurPowerLevel);
   end else if cmd = 'getsendercurdurawatercase' then begin    // 죽통들의 내구성이 0인지 아닌지 (물이 남아있는지)
      Result := IntToStr (TBasicObject (FSender).SGetCurDuraWaterCase);
   end else if cmd = 'getremainmaptime' then begin             // 현재 맵시간이 얼마나 남았는지 조사
      Result := TBasicObject (FSender).SGetRemainMapTime (_StrToInt (Params [0]), _StrToInt (Params [1]));
   end else if cmd = 'checkentermap' then begin     // 들어갈 수 있는지 없는지 조사
      Result := TBasicObject (FSender).SCheckEnterMap (_StrToInt (Params [0]));
   end else if cmd = 'getrandomitem' then begin
      Result := RandomEventItemList.GetItemNamebyRandom (_StrToInt (Params [0]));
   end else if cmd = 'getquestitem' then begin
      Result := RandomEventItemList.GetQuestItembyRandom (_StrToInt (Params [0]));
   end else if cmd = 'checkmagic' then begin
      Result := TBasicObject (FSelf).SCheckMagic (_StrToInt (Params [0]), _StrToInt (Params [1]), Params [2]);
   end else if cmd = 'checksenderattribitem' then begin
      Result := TBasicObject (FSender).SCheckAttribItem (_StrToInt (Params [0])); 
   end else if cmd = 'conditionbestattackmagic' then begin
      Result := TBasicObject (FSender).SConditionBestAttackMagic (Params [0]);
   end else if cmd = 'getmarryclothes' then begin
      Result := TBasicObject (FSender).SGetMarryClothes;
   end else if cmd = 'getzhuangticketprice' then begin //获取聚贤庄门票价格
      Result := TBasicObject (FSender).SGetZhuangTicketPrice;
   end else if cmd = 'getintozhuang' then begin //进入聚贤庄
      Result := TBasicObject (FSender).SGetZhuangInto;
   end else if cmd = 'getmarryinfo' then begin
      Result := TBasicObject (FSender).SGetMarryInfo;
   end else if cmd = 'getzhuangfight' then begin //挑战聚贤庄
      Result := TBasicObject (FSender).SGetAskConquer;
   end else if cmd = 'getaddmember' then begin
      Result := TBasicObject (FSender).SAddArenaMember (Params [0]);
   end else if cmd = 'getcheckpickup' then begin
      Result := TBasicObject (FSender).SCheckPickup;
   end else if cmd = 'getevent' then begin
      Result := TBasicObject (FSender).SGetEvent (StrToIntDef(Params [0],0));
   end else if cmd = 'getsetevent' then begin
      Result := TBasicObject (FSender).SGetSetEvent (StrToIntDef(Params [0],0));
   end else if cmd = 'getparty' then begin
      Result := TBasicObject (FSender).SGetParty;
   end else if cmd = 'setparty' then begin
      Result := TBasicObject (FSender).SSetParty;
   end

end;
```