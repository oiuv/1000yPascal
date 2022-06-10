
## Script

千年脚本在Script目录中，其中`Script.SDB`是脚本索引，为每个脚本指定唯一编号`Name`，方便调用。

脚本应用范围很广，在Item.sdb、Map.sdb、EventParam.sdb、CreateNpc.sdb、CreateGate.sdb、CreateDynamicObject.sdb、CreateMonster.sdb都能调用。

千年游戏中所有脚本都是pascal单元`unit`，具体说明见[help/Pascal.md](help/Pascal.md)中的单元介绍，以下是一个标准系统脚本`System.txt`：

```pascal
unit System;

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

procedure OnUserStart (aStr : String);
procedure OnUserEnd (aStr : String);

implementation

procedure OnUserStart (aStr : String);
var
   Str : String;
   CompleteQuest, CurrentQuest : Integer;
begin
   Str := callfunc ('getcompletequest');
   CompleteQuest := StrToInt (Str);
   Str := callfunc ('getcurrentquest');
   CurrentQuest := StrToInt (Str);

   if CompleteQuest < 1 then begin
      if CurrentQuest < 1 then begin
         Str := callfunc ('getname');
         Str := 'sendsendertopmsg 欢迎新玩家[' + Str;
         Str := Str + '],来到云端千年的武侠世界';
         print (str);
         Str := 'changecompletequest 1';
         print (str);
         Str := 'changecurrentquest 1';
         print (str);
         exit;
      end;
   end;
end;

procedure OnUserEnd (aStr : String);
begin

end;

end.
```

## function

### callfunc

调用指定callfunc返回函数结果，具体可调用函数见callfunc目录。

### CompareStr

比较字符串并返回Boolean。

```pascal
bool := CompareStr (aStr1, aStr2)
```

### GetToken

根据指定分割符分割字符串并返回结果。

```pascal
bStr := GetToken(aStr, aToken, aSep);
```

以上示例中变量aStr（参数1）为要分割的字符串;变量aSep(参数3)为分割符，下划线“_”表示根据空格分割;变量aToken（参数2）为字符串aStr中分割符第一次出现位置左边的结果，返回值bStr为aStr分割后剩余部分的结果。


### IntToStr

整型转字符串

```pascal
aStr := IntToStr (aInt);
```

### Length

返回给定字符串的长度

```pascal
iLen := Length (aText);
```

### Random

返回不大于给定值的Integer随机数

```pascal
iRandom := Random (4);
```

### StrToInt

字符串转整型

```pascal
aInt := StrToInt (astr);
```

### OnXXX

在`function`目录中的`OnXXX`是特定条件下自动调用的函数，目前只有二个`OnMove`和`OnDanger`，判断结果，具体功能需自己实现。

## procedure

过程是没有返回值的方法，以下是固定功能过程，在脚本中调用。

### Dec

自减过程

### exit

终止(退出)过程或函数执行

### Inc

自增过程

```pascal
Inc (aInt);
```

### print

执行指定过程，具体可执行过程见print目录。

### OnXXX

在`procedure`目录中的`OnXXX`是在特定条件下自动调用的过程，具体功能需要自己实现。