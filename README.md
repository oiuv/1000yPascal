# 千年游戏开发手册
古老的千年使用的是pascal语言，开发相关目录结构如下：
```
├─event
├─Help
├─Init
├─NpcSetting
├─QuestNotice
├─Script
└─Setting
```

如果要在游戏中新增一个交易NPC，开发涉及如下目录：
```
名称：杂货商

Help\杂货商.txt           #交易界面内容
Init\Npc.sdb              #初始化NPC设置
NpcSetting\杂货商.sdb      #NPC自动说话内容（非必需）
NpcSetting\杂货商.txt       #买卖物品列表
Script\Script.sdb          #脚本索引
Script\杂货商.txt          #交易脚本代码
Setting\CreateNpc88.sdb   #在编号88的地图上生成NPC
```

本教程重点针对Script目录下的编程相关做说明，所有行为控制代码都在这里。

游戏中每一个互动模块（比如一个NPC）都是一个单元，对应Script目录下一个文件,在pascal语言中，unit的基本结构如下：
```pascal
unit Unit1;  

interface  

implementation  

end.
```

而在千年中，以游戏中的福袋为列，OnDblClick这个procedure（过程）为福袋功能，其它部分为所有单元都有的基本结构。
```pascal
unit 福袋;

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

procedure OnDblClick(aStr : String);

implementation

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

end.
```

从以上代码可见，基础语法和pascal一至，而游戏特定功能的语法可分为procedure过程、callfunc方法和print方法三大类。

pascal游戏开发基础说明：
* pascal除字符串变量外，不区分大小写
* pascal变量声明方法为：var Str:String;（好非主流的方法）
* pascal赋值为“:=”，而“=”为逻辑运算符（又是一种非主流的用法）
* 游戏主要要使用的数据类型：integer、string、boolean
* 游戏中使用_代替空格


