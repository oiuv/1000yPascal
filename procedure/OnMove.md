```pascal
procedure OnMove (aStr : String);
var
   Str, Name : String;
begin
   

end;
```

## 示例

```pascal
unit gateA;

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

function OnMove (aStr : String) : String;

implementation

procedure OnMove (aStr : String);
var
   Str : String;
begin
   Result := 'false';

   Str := callfunc ('checkalivemopcount 93 monster 忍者A');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 93 monster 火狐狸A');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 93 monster 白狐狸A');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 93 monster 老虎A');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 93 monster 白老虎A');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 93 monster 蝎子A');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 93 monster 犀牛A');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 93 monster 石巨人A');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 93 monster 僵尸A');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 93 monster 投石女A');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 93 monster 山贼A');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 93 monster 豺狼A');
   if Str <> '0' then exit;
   
   Result := 'true';
end;

end.
```
