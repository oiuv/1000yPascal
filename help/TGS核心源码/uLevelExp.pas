unit uLevelExp;

interface

uses
  Windows, SysUtils, Classes;

type
   TLevelData = record
     rlevel : integer;
     rexp : integer;
     rgap : integer;
     rGetMaxExp : integer;
   end;
   PTLevelData = ^TLevelData;

   function GetAgeLevel (aexp: integer): integer;
   function GetLevel (aexp: integer): integer;
   function GetLevelMaxExp (alevel: integer): integer;
   function GetLevelExp (alevel: integer): integer;
   function GetExpOverLevel (alevel: integer): integer;
   function Get10000To100 (avalue: integer): string;
   function Get10000To120 (avalue: integer): string;

   function GetLevelExpDetail (aMainValue, aSubValue : Integer) : Integer;  // MainValue : 99  SubValue : 98  (¿¹ : 99.98)

implementation

{$O+}

const
   LevelsArr : array [1..100*4] of integer = (
      1,-1,107,21,2,107,140,23,3,247,182,26,4,428,235,29,5,664,304,33,
      6,968,391,39,7,1358,501,45,8,1859,638,53,9,2497,811,62,10,3309,1027,68,
      11,4336,1295,86,12,5631,1628,101,13,7259,2040,127,14,9299,2546,149,15,11845,3169,186,
      16,15014,3931,218,17,18944,4860,270,18,23805,5992,315,19,29796,7365,387,20,37161,9025,451,
      21,46187,11029,525,22,57215,13439,584,23,70654,16329,680,24,86983,19787,761,25,106771,23912,885,
      26,130683,28821,993,27,159504,34645,1154,28,194148,41537,1298,29,235686,49674,1505,30,285359,59253,1692,
      31,344612,70503,1905,32,415115,83680,2145,33,498796,99078,2416,34,597873,117024,2721,35,714897,137888,3064,
      36,852785,162086,3448,37,1014871,190082,3879,38,1204953,222393,4360,39,1427346,259594,4898,40,1686940,302322,5496,
      41,1989262,351282,6056,42,2340544,407249,6568,43,2747793,471075,7247,44,3218867,543691,7879,45,3762558,626114,8696,
      46,4388672,719450,9466,47,5108122,824899,10441,48,5933021,943753,11370,49,6876774,1077408,12528,50,7954182,1227359,13637,
      51,9181541,1395203,14686,52,10576744,1582642,15669,53,12159386,1791483,16900,54,13950868,2023631,18068,55,15974500,2281096,19496,
      56,18255595,2565979,20861,57,20821574,2880474,22503,58,23702048,3226859,24081,59,26928907,3607485,25953,60,30536393,4024770,27757,
      61,34561163,4481182,29098,62,39042345,4979228,30547,63,44021573,5521438,32101,64,49543011,6110342,33758,65,55653353,6748455,35518,
      66,62401807,7438251,37378,67,69840059,8182141,39337,68,78022199,8982441,41393,69,87004640,9841350,43545,70,96845990,10760913,45791,
      71,107606903,11742996,47160,72,119349899,12789244,48444,73,132139142,13901053,50003,74,146040195,15079532,51465,75,161119727,16325465,53177,
      76,177445192,17639277,54780,77,195084469,19020997,56610,78,214105466,20470218,58319,79,234575684,21986069,60235,80,256561752,23567175,62018,
      81,280128928,25211630,63505,82,305340558,26916966,65016,83,332257524,28680123,66543,84,360937647,30497435,68074,85,391435082,32364602,69601,
      86,423799685,34276681,71113,87,458076366,36228076,72601,88,494304442,38212533,74055,89,532516975,40223140,75465,90,572740115,42252340,76822,
      91,614992455,44291942,79805,92,659284397,46333143,82590,93,705617540,48366557,85453,94,753984097,50382250,88080,95,804366346,52369783,90762,
      96,856736129,54318261,93170,97,911054390,56216393,95606,98,967270783,58052549,97731,99,1025323333,59814839,99691,100,1085138172,60000000,0
   );

   AgeLevelsArr : array [1..100*4] of integer = (
      1,-1,107,0,2,107,140,0,3,247,182,0,4,428,235,0,5,664,304,0,
      6,968,391,0,7,1358,501,0,8,1859,638,0,9,2497,811,0,10,3309,1027,0,
      11,4336,1295,0,12,5631,1628,0,13,7259,2040,0,14,9299,2546,0,15,11845,3169,0,
      16,15014,3931,0,17,18944,4860,0,18,23805,5992,0,19,29796,7365,0,20,37161,9025,0,
      21,46187,11029,0,22,57215,13439,0,23,70654,16329,0,24,86983,19787,0,25,106771,23912,0,
      26,130683,28821,0,27,159504,34645,0,28,194148,41537,0,29,235686,49674,0,30,285359,59253,0,
      31,344612,70503,0,32,415115,83680,0,33,498796,99078,0,34,597873,117024,0,35,714897,137888,0,
      36,852785,162086,0,37,1014871,190082,0,38,1204953,222393,0,39,1427346,259594,0,40,1686940,302322,0,
      41,1989262,351282,0,42,2340544,407249,0,43,2747793,471075,0,44,3218867,543691,0,45,3762558,626114,0,
      46,4388672,719450,0,47,5108122,824899,0,48,5933021,943753,0,49,6876774,1077408,0,50,7954182,1227359,0,
      51,9181541,1395203,0,52,10576744,1582642,0,53,12159386,1582642,0,54,13742028,1582642,0,55,15324670,1582642,0,
      56,16907312,1582642,0,57,18489954,1582642,0,58,20072596,1582642,0,59,21655238,1582642,0,60,23237880,1582642,0,
      61,24820522,1582642,0,62,26403164,1582642,0,63,27985806,1582642,0,64,29568448,1582642,0,65,31151090,1582642,0,
      66,32733732,1582642,0,67,34316374,1582642,0,68,35899016,1582642,0,69,37481658,1582642,0,70,39064300,1582642,0,
      71,40646942,1582642,0,72,42229584,1582642,0,73,43812226,1582642,0,74,45394868,1582642,0,75,46977510,1582642,0,
      76,48560152,1582642,0,77,50142794,1582642,0,78,51725436,1582642,0,79,53308078,1582642,0,80,54890720,1582642,0,
      81,56473362,1582642,0,82,58056004,1582642,0,83,59638646,1582642,0,84,61221288,1582642,0,85,62803930,1582642,0,
      86,64386572,1582642,0,87,65969214,1582642,0,88,67551856,1582642,0,89,69134498,1582642,0,90,70717140,1582642,0,
      91,72299782,1582642,0,92,73882424,1582642,0,93,75465066,1582642,0,94,77047708,1582642,0,95,78630350,1582642,0,
      96,80212992,1582642,0,97,81795634,1582642,0,98,83378276,1582642,0,99,84960918,20000000,0,100,104960918,20000000,0
   );
   

function Get10000To100 (avalue: integer): string;
var
   n : integer;
   str : string;
begin
   str := InttoStr (avalue div 100) + '.';
   n := avalue mod 100;
   if n >= 10 then str := str + IntToStr (n)
   else str := str + '0'+InttoStr(n);

   Result := str;
end;

function Get10000To120 (avalue: integer): string;
var
   n : integer;
   str : string;
begin
   avalue := avalue * 12 div 10;
   str := InttoStr (avalue div 100) + '.';
   n := avalue mod 100;
   if n >= 10 then str := str + IntToStr (n)
   else str := str + '0'+InttoStr(n);

   Result := str;
end;

function GetAgeLevel (aexp: integer): integer;
var
   i, rm : integer;
   p, pold : PTLevelData;
begin
   if aexp <= 0 then begin Result := 100; exit; end;
   if aexp >= 104960918 then begin Result := 9999; exit; end;

   p := PTLevelData(@AgeLevelsArr);
   pold := p;  inc (p);

   Result := 100;
   for i := 2 to 100 do begin
      if (aexp < p^.rexp) and (aexp >= pold^.rexp) then begin
         rm := aexp - pold^.rexp;
         Result := (i-1)*100 + rm*100 div pold^.rgap;
         exit;
      end;
      pold := p;
      inc (p);
   end;
end;

function GetLevel (aexp: integer): integer;
var
   i, rm, tempgap : integer;
   p, pold : PTLevelData;
begin
   if aexp <= 0 then begin Result := 100; exit; end;
   if aexp >= 1085138172 then begin Result := 9999; exit; end;

   p := PTLevelData(@LevelsArr);
   pold := p;  inc (p);

   Result := 100;
   for i := 2 to 100 do begin
      if (aexp < p^.rexp) and (aexp >= pold^.rexp) then begin
         rm := aexp - pold^.rexp;
         if pold^.rexp < 10000000 then begin
            Result := (i-1)*100 + rm*100 div pold^.rgap;
         end else begin
            tempgap := pold^.rgap div 100;
            rm := rm div 100;
            Result := (i-1)*100 + rm*100 div tempgap;
         end;
         exit;
      end;
      pold := p;
      inc (p);
   end;
end;

function GetLevelMaxExp (alevel: integer): integer;
var
   n : integer;
   p : PTLevelData;
begin
   Result := 0;
   if alevel < 100 then exit;
   if alevel >= 9999 then exit;
   n := alevel div 100;
   p := PTLevelData(@LevelsArr);
   inc (p,n-1);
   Result := p^.rGetMaxExp;
end;

function GetLevelExp (alevel: integer): integer;
var
   n : integer;
   p : PTLevelData;
begin
   Result := 0;
   if alevel < 100 then exit;
   if alevel > 9999 then exit;
   n := alevel div 100;
   p := PTLevelData(@LevelsArr);
   inc (p,n-1);
   Result := p^.rExp;
end;

function GetExpOverLevel (alevel: integer): integer;
var
   n : integer;
   p : PTLevelData;
begin
   Result := 0;
   if alevel < 100 then exit;
   if alevel > 9999 then exit;
   n := alevel div 100;
   p := PTLevelData(@LevelsArr);
   inc (p,n);
   Result := p^.rExp;
end;

function GetLevelExpDetail (aMainValue, aSubValue : Integer) : Integer;
var
   n, GapExp : integer;
   p : PTLevelData;
begin
   Result := 0;
   if aMainValue < 1 then exit;
   if aMainValue > 99 then exit;
   p := PTLevelData(@LevelsArr);
   inc (p, aMainValue-1);

   n := p^.rExp;
   GapExp := p^.rgap div 99;

   Result := n + (GapExp * aSubValue); 
end;

end.
