```pascal
function OnMove (aStr : String) : String;
```

## 示例

```pascal
unit gateB_C;

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

function OnMove (aStr : String) : String;
var
   Str : String;
begin
   Result := 'false';

   Str := callfunc ('checkalivemopcount 94 monster 近距离野神族B');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 94 monster 石谷野神族B');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 94 monster 野兽族B');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 94 monster 首领级野兽族B1');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 94 monster 首领级雪巨人B1');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 94 monster 雪巨人B');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 94 monster 蜘蛛女王B');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 94 monster 金毛狮王B');
   if Str <> '0' then exit;
   Str := callfunc ('checkalivemopcount 94 monster 蝎子女王B');
   if Str <> '0' then exit;

   Result := 'true';
end;

end.
```