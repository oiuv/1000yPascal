千年脚本开发中使用的函数并不多，除了7个固定功能的函数外，只有`OnDanger`和`OnMove`二个判断函数。

```pascal
function  GetToken (aStr, aToken, aSep : String) : String;
function  CompareStr (aStr1, aStr2 : String) : Boolean;
function  callfunc (aText: string): string;
function  Random (aScope: integer): integer;
function  Length (aText: string): integer;
function  StrToInt (astr: string): integer;
function  IntToStr (aInt: integer): string;

function OnMove (aStr : String) : String;
function OnDanger (aStr : String) : String;
```