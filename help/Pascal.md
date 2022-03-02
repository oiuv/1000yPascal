## Pascal语言基础

Pascal程序基本上由以下部分组成:

1. 程序名称
2. 使用命令
3. 类型声明
4. 常量声明
5. 变量声明
6. 函数声明
7. 程序声明
8. 主程序块
9. 每个块中的语句和表达式
10. 注释

每个pascal程序通常严格按照该顺序具有标题语句，声明和执行部分。以下格式显示了Pascal程序的基本语法：

```pascal
program {name of the program}
uses {comma delimited names of libraries you use}
const {global constant declaration block}
var {global variable declaration block}

function {function declarations, if any}
{ local variables }
begin
...
end;

procedure { procedure declarations, if any}
{ local variables }
begin
...
end;

begin { main program block starts}
...
end. { the end of main program block }
```

### 注释

多行注释以括号（* ... *）括在括号和星号中。Pascal允许在大括号{...}中包含单行注释。

```pascal
(* 这是多行注释
   它将跨越多行。 *)

{ 这是Pascal中的单行注释 }
```

### 不区分大小写

Pascal是一种不区分大小写的语言，这意味着您可以在两种情况下都编写变量，函数和过程。与变量A_Variable，a_variable和A_VARIABLE在Pascal中的含义相同。

### 变量与数据类型

变量定义放在以var关键字开头的块中，然后是变量的定义，如下所示：

```
var
A_Variable, B_Variable ... : Variable_Type;
```

Variable_Type为变量数据类型，在千年中主要用到三种：

- String
- Integer
- Boolean

如：
```pascal
var
   Str, Name : String;
   iCount : Integer;
```

### 运算符

Pascal语言的运算符多数和其它高级语言一至，以下二个不同：

- := 为赋值运算符
- =  为逻辑等运算符

### 流程控制

千年中最常用的流程控制为`if - then 语句`，示例：

```pascal
   if Str <> '1' then begin
      exit;
   end;
```

### 函数/程序

在Pascal中，procedure是一组要执行的指令，没有返回值，而function是具有返回值的过程。函数/程序的定义如下: 

```
Function Func_Name(params...) : Return_Value;
Procedure Proc_Name(params...);
```

函数调用如下：

```pascal
function name(argument(s): type1; argument(s): type2; ...): function_type;
local declarations;

begin
   ...
   < statements >
   ...
   name:= expression;
end;
```

过程调用如下：
```pascal
procedure name(argument(s): type1, argument(s): type 2, ... );
   < local declarations >
begin
   < procedure body >
end;
```

千年中主要是使用各种procedure实现游戏逻辑。示例：

```pascal
procedure OnDieBefore (aStr : String);
begin
   print ('sendsound 9422.wav 45');
   exit;
end;
```

### 单元

Pascal 程序可以包含称为单元的模块。一个单元可能由一些代码块组成，这些代码块又由变量和类型声明，语句，过程等组成。Pascal中有许多内置单元，并且 Pascal 允许程序员定义和编写自己的单元以供使用。后来在各种程序中。

要创建一个单元，您需要编写要存储在其中的模块或子程序，并将其保存在扩展名为.pas的文件中。该文件的第一行应以关键字unit开头，后跟该单元的名称。

以下是创建Pascal单位的三个重要步骤：
1. 文件名和单元名应该完全相同。因此，我们的单元calculateArea将保存在名为calculateArea.pas的文件中。
2. 下一行应包含一个interface关键字。在此行之后，您将编写本单元中所有功能和过程的声明。
3. 在函数声明之后，紧接着写单词Implementation，这也是一个关键字。在包含关键字实现的行之后，提供所有子程序的定义。

在pascal语言中，unit的基本结构如下：
```pascal
unit Unit1;  

interface  

implementation  

end.
```

在千年游戏中每一个互动单位（比如一个NPC）都是一个单元unit，对应Script目录下一个文件,不过文件不是以.pas为扩展名，而是直接用.txt为扩展名。我们写的所有脚本都是单元脚本，然后通过配置在游戏中调用。

千年单元基本格式如下：

```pascal
unit 单元名称;

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

{ 过程或函数声明 }

implementation

{ 过程或函数实现 }

end.
```