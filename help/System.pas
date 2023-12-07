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
   FirstQuest : Integer;
begin
   // 因为1号系统脚本直接在玩家身上调用:
   // SetScript (1);
   // 所以callfunc不用加sender
   Str := callfunc ('getfirstquest');
   FirstQuest := StrToInt (Str);
   if FirstQuest < 1 then begin
      Str := callfunc ('getname');
      Str := 'sendsendertopmsg 欢迎新玩家[' + Str;
      Str := Str + '],来到云端千年的武侠世界';
      print (str);
      Str := 'changefirstquest 1';
      print (str);
      exit;
   end;
end;

procedure OnUserEnd (aStr : String);
begin

end;

end.
