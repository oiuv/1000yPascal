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
