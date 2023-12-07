unit ScriptCls;
//      raise Exception.Create('TAnsImage: GemMem Failed for Bits');

interface

uses
  Windows, SysUtils, Classes, ScriptBasic, aUtil32;

type
  TScriptClass = class;

  TFunctionClass = class
   private
    FName : string;
    FScriptClass : TScriptClass;
    ParamList : TList;
    VariableList : TList;
    DConstList : TList;
    FNewNameCount : integer;

    FResultType : TVariableType;

    CodeStringList : TStringList;
    procedure Clear;
    function  GetNewName: string;
    function  GetNameInterfaceType (aName: string): TInterfaceDefineType;
    procedure LoadCode (aSection: TScriptSection; aStringList: TStringList);
    procedure SaveCode (aFileName : String);
    function  ChangeConstToVariable (aValue: string): string;
    procedure AddVariableData (aName: string; aVariableType: TVariableType; aValue: string);
   public
    function  GetVariableData (aName: string): PTVariableData;
    constructor Create (aScriptClass: TScriptClass);
    destructor Destroy; override;
    procedure Assign (aClass: TFunctionClass);
    procedure LoadFromSection (aSection: TScriptSection);
    function  FuncCall: TVariableData;
    property Name: string read FName;
  end;

  TScriptClass = class
   private
    FName : string;
    FunctionList : TList;  // 함수들
    VariableList : TList;  // 전역변수
    ExternVariableList : TList;  // 외부전역변수
    FScriptStack : TScriptStack;

    FInterfaceDefineClass : TInterfaceDefineClass;

    ResultStringList : TStringList;

    procedure LoadInterface (aSection: TScriptSection);
    procedure LoadImplementation (aSection: TScriptSection);
   public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Assign (aClass: TScriptClass);
    function  GetFunctionClass (aName: string): TFunctionClass;
    function  GetVariableData (aName: string): PTVariableData;
    procedure LoadFromFile (aFileName: string);
    procedure LoadFromStream (aStream: TStream);

    function  SetExternVariable (aName, aValue: string): Boolean;
    function  FunctionCallbyName (aFuncName: string; aParams: array of string) : String;

    function  GetResult: string;
    procedure AddResult (astr: string);
  end;

  function GetToken (aStr : String; var aToken : String; aSep : String) : String;
  function ChangeScriptString (aStr, aSep, aChg : String) : String;

implementation

uses
   uScriptManager;

function GetToken (aStr : String; var aToken : String; aSep : String) : String;
var
   iPos, iLen : Integer;
begin
   Result := '';
   aToken := '';

   iLen := Length (aSep);
   iPos := Pos (aSep, aStr);
   if iPos > 0 then begin
      aToken := Copy (aStr, 1, iPos - 1);
      Result := Copy (aStr, iPos + iLen, Length (aStr));
   end else begin
      aToken := aStr;
      Result := '';
   end;
end;

function ChangeScriptString (aStr, aSep, aChg : String) : String;
var
   iPos : Integer;
   Str : String;
begin
   Result := aStr;
   
   if aSep = aChg then exit;
   
   Str := aStr;
   while true do begin
      iPos := Pos (aSep, Str);
      if iPos = 0 then break;
      Str := Copy (Str, 1, iPos - 1) + aChg + Copy (Str, iPos + Length (aSep), Length (Str));
   end;

   Result := Str;
end;

function LoadVariableFromSection (aSection: TScriptSection; aList: TList): Boolean;
var
   i, line : integer;
   str, valuestr, typestr: string;
   p : PTVariableData;
begin
   for line := 0 to aSection.GetLineCount -1 do begin
      aSection.LoadLine (line);
      if aSection.Line.IsToken (';') then aSection.Line.DeleteToken (aSection.Line.Count-1);
      if aSection.Line.IsToken ('=') then begin  //  aaa: integer = 10;
         valuestr := aSection.Line.View (aSection.Line.Count -1);
         typestr := aSection.Line.View (aSection.Line.Count -1-2);
      end else begin
         valuestr := '';
         typestr := aSection.Line.View (aSection.Line.Count -1);
      end;

      for i := 0 to aSection.Line.Count-1 do begin
         str := aSection.Line.View (i);
         if str = ':' then break;
         if str = ',' then continue;
         new (p);
         FillChar (p^, sizeof(TVariableData), 0);
         p^.rName := str;
         p^.rVariabletype := GetTypebyString (typestr);
         case p^.rVariabletype of
            vt_integer: p^.rInteger := _StrToInt (valuestr);
            vt_string: p^.rString := Copy (valuestr, 2, Length(valuestr)-2);
         end;
         aList.Add (p);
      end;
   end;
   Result := TRUE;
end;



////////////////////////////////
//
////////////////////////////////

constructor TFunctionClass.Create (aScriptClass: TScriptClass);
begin
   FName := '';
   FNewNameCount := 0;
   FScriptClass := aScriptClass;
   ParamList := TList.Create;
   VariableList := TList.Create;
   FResultType := vt_none;
   CodeStringList := TStringList.Create;
   DConstList := TList.Create;
end;

destructor TFunctionClass.Destroy;
begin
   Clear;
   DConstList.Free;
   CodeStringList.Free;
   VariableList.Free;
   ParamList.Free;
   inherited Destroy;
end;

procedure TFunctionClass.Clear;
var i: integer;
begin
   for i := 0 to DConstList.Count -1 do dispose (DConstList[i]);
   DConstList.Clear;
   for i := 0 to VariableList.Count -1 do dispose (VariableList[i]);
   VariableList.Clear;
   for i := 0 to ParamList.Count -1 do dispose (ParamList[i]);
   ParamList.Clear;
   CodeStringList.Clear;
end;

procedure TFunctionClass.Assign (aClass: TFunctionClass);
var
   i: integer;
   pv : PTVariableData;
begin
   Clear;
   FName := aClass.FName;
   FResultType := aClass.FResultType;

   for i := 0 to aClass.ParamList.Count -1 do begin
      new (pv);
      pv^ := PTVariableData (aClass.ParamList[i])^;
      ParamList.Add (pv);
   end;
   for i := 0 to aClass.VariableList.Count -1 do begin
      new (pv);
      pv^ := PTVariableData (aClass.VariableList[i])^;
      VariableList.Add (pv);
   end;

   for i := 0 to aClass.CodeStringList.Count -1 do begin
      CodeStringList.Add (aClass.CodeStringList[i]);
   end;
end;

function  TFunctionClass.GetNewName: string;
begin
   inc (FNewNameCount);
   Result := '#nn'+IntToStr (FNewNameCount);
end;

function  TFunctionClass.GetNameInterfaceType (aName: string): TInterfaceDefineType;
var p : PTVariableData;
begin
   Result := idef_none;
   p := GetVariableData (aName);

   if p <> nil then begin
      case p^.rVariabletype of
         vt_integer : Result := idef_integer;
         vt_string  : Result := idef_string;
         vt_boolean : Result := idef_boolean;
      end;
   end else Result := FScriptClass.FInterfaceDefineClass.GetDefineType (aName);
end;

procedure TFunctionClass.AddVariableData (aName: string; aVariableType: TVariableType; aValue: string);
var p : PTVariableData;
begin
   new (p);
   FillChar (p^, sizeof(TVariableData), 0);
   p^.rName := aName;
   p^.rVariabletype := aVariableType;
   case p^.rVariabletype of
      vt_integer: p^.rInteger := StrToInt (aValue);
      vt_string : p^.rString := aValue;
      vt_boolean : p^.rBoolean := CompareText (aValue, 'true') = 0;
   end;
   DConstList.Add (p);
end;

function  TFunctionClass.ChangeConstToVariable (aValue: string): string;
var p : PTVariableData;
begin
   new (p);
   FillChar (p^, sizeof(TVariableData), 0);
   p^.rName := GetNewName;
   if isIntegerConstant (aValue) then begin
      p^.rVariabletype := vt_integer;
      p^.rInteger := StrToInt (aValue);
   end else if (aValue = 'true') or (aValue = 'false') then begin
      p^.rVariabletype := vt_boolean;
      p^.rBoolean := CompareStr (aValue, 'true') = 0;
   end else begin
      p^.rVariabletype := vt_string;
      p^.rString := Copy (aValue, 2, Length(aValue)-2);
   end;
   DConstList.Add (p);
   Result := p^.rName;
end;

procedure TFunctionClass.LoadFromSection (aSection: TScriptSection);
var
   str: string;
   LocalSection : TScriptSection;
begin
   Clear;
   str := aSection.ViewToken;
   if (str <> 'procedure') and (str <> 'function') then exit;
   LocalSection := TScriptSection.Create;

   aSection.LoadLine (0);
   FName := aSection.Line.View (1);

   FResultType := vt_none;
   if aSection.Line.View (0) = 'function' then begin
      str := aSection.Line.View (aSection.Line.Count-1-1);
      FResultType := GetTypeByString (str);
   end;

   if aSection.Line.IsToken ('(') then begin
      LocalSection.LoadFromScriptSection (aSection, ['(']);
      aSection.GetToken;
      LocalSection.LoadFromScriptSection (aSection, [')']);
      LoadVariableFromSection (LocalSection, ParamList);
   end;

   LocalSection.LoadFromScriptSection (aSection, ['var', 'begin']);

   while TRUE do begin
      if aSection.ViewToken = '' then break;
      str := aSection.GetToken;

      if str = 'var' then begin
         LocalSection.LoadFromScriptSection (aSection, ['begin']);
         LoadVariableFromSection (LocalSection, VariableList);
      end else if str = 'begin' then begin
         LocalSection.LoadFromScriptSection (aSection, ['']);
         LocalSection.DeleteToken (LocalSection.Count-1); //;
         LocalSection.DeleteToken (LocalSection.Count-1); // end;
         CodeStringList.Clear;
         try
            LoadCode (LocalSection, CodeStringList);
         except
            SaveCode ('Error-' + FScriptClass.FName + '-' + FName + '.log');
         end;
      end;
   end;

   LocalSection.Free;
end;

function  TFunctionClass.GetVariableData (aName: string): PTVariableData;
var i: integer;
begin
   for i := 0 to VariableList.Count-1 do begin
      if PTVariableData (VariableList[i])^.rName = aName then begin
         Result := VariableList[i];
         exit;
      end;
   end;
   for i := 0 to ParamList.Count-1 do begin
      if PTVariableData (ParamList[i])^.rName = aName then begin
         Result := ParamList[i];
         exit;
      end;
   end;

   for i := 0 to DConstList.Count-1 do begin
      if PTVariableData (DConstList[i])^.rName = aName then begin
         Result := DConstList[i];
         exit;
      end;
   end;

   Result := FScriptClass.GetVariableData (aName);
end;

procedure TFunctionClass.SaveCode (aFileName : String);
begin
   CodeStringList.SaveToFile (aFileName);
end;

procedure TFunctionClass.LoadCode (aSection: TScriptSection; aStringList: TStringList);
var
   i, thenpos, topos, dopos: integer;
   str, lstr, bstr, estr : string;
   idt : TInterfaceDefineType;
   LineTokenClass, OneLine : TLineTokenClass;
   LocalSection: TScriptSection;
   LocalStringList : TStringList;
begin
   if aSection.ViewToken = 'begin' then begin
      aSection.DeleteToken (0);
      aSection.Position := aSection.Count-1;
      if aSection.ViewToken = ';' then aSection.DeleteToken (aSection.Count-1)
      else if aSection.ViewToken = 'end' then aSection.DeleteToken (aSection.Count-1);
      aSection.Position := 0;
   end;

   LineTokenClass := TLineTokenClass.Create;
   OneLine := TLineTokenClass.Create;
   LocalSection := TScriptSection.Create;
   LocalStringList := TStringList.Create;

   while TRUE do begin
      if LineTokenClass.Ended then LineTokenClass.Clear;

      if aSection.ViewToken = '' then break;
      str := aSection.GetToken;

      if isConstantToken (str) then str := ChangeConstToVariable (str);

      LineTokenClass.Add (str);
      if LineTokenClass.Ended then begin
         LocalStringList.Clear;
         LocalSection.Clear;
         if LinetokenClass.Tokens[0] = 'if' then begin
            thenpos := LineTokenClass.GetTokenIndex ('then');
            OneLine.Clear;
            bstr := GetNewName;
            AddVariableData (bstr, vt_boolean, 'false');
            OneLine.Add (bstr); OneLine.Add (':=');
            for i := 1 to thenpos-1 do OneLine.Add (LineTokenClass.Tokens[i]);
            OneLine.Add (';');
            aStringList.Add (OneLine.GetResult);

            lstr := GetNewName;
            aStringList.Add ( format ('#notifgoto %s %s',[bstr, lstr]));

            for i := thenpos + 1 to LineTokenClass.Count -1 do LocalSection.AddToken (lineTokenClass.Tokens[i]);
            LoadCode (LocalSection, LocalStringList);
            for i := 0 to LocalStringList.Count -1 do aStringList.Add (LocalStringList[i]);

            aStringList.Add ('#label ' + lstr);
            LineTokenClass.Clear;
            continue;
         end else if LinetokenClass.Tokens[0] = 'for' then begin
            topos := LineTokenClass.GetTokenIndex ('to');
            OneLine.Clear;
            for i := 1 to topos-1 do OneLine.Add (LineTokenClass.Tokens[i]);
            OneLine.Add (';');
            aStringList.Add (OneLine.GetResult);

            dopos := LineTokenClass.GetTokenIndex ('do');
            
            estr := GetNewName;
            AddVariableData (estr, vt_integer, '0');
            OneLine.Clear;
            OneLine.Add (estr); OneLine.Add (':=');
            for i := topos+1 to dopos-1 do OneLine.Add (LineTokenClass.Tokens[i]);
            OneLine.Add (';');
            aStringList.Add (OneLine.GetResult);

            lstr := GetNewName;
            aStringList.Add ('#label ' + lstr);
            
            for i := dopos +1 to LineTokenClass.Count -1 do LocalSection.AddToken (lineTokenClass.Tokens[i]);
            LoadCode (LocalSection, LocalStringList);
            for i := 0 to LocalStringList.Count -1 do aStringList.Add (LocalStringList[i]);

            bstr := GetNewName;
            AddVariableData (bstr, vt_boolean, 'false');
            aStringList.Add (format ('#largeequal %s %s %s', [bstr, LineTokenClass.Tokens[1], estr]));
            aStringList.Add (format ('#inc %s', [LineTokenClass.Tokens[1]]));

            aStringList.Add (format ('#notifgoto %s %s',[bstr, lstr]));

            LineTokenClass.Clear;
            continue;
         end;

         idt := idef_none;
         for i := 0 to LineTokenClass.Count -1 do begin
            if LineTokenClass.Idents[i] <> ti_name then continue;

            idt := GetNameInterfaceType (LineTokenClass.tokens[i]);

            case idt of
               idef_none : raise Exception.Create('Undeclared identifier: ' + LineTokenClass.Tokens[i]);
               idef_integer :;
               idef_string :;
               idef_boolean :;
               idef_procedure :;
               idef_ifunction :;
               idef_sfunction :;
               idef_bfunction :;
            end;
            if (idt = idef_procedure) or (idt = idef_ifunction) or (idt = idef_sfunction) or (idt = idef_bfunction) then break;
         end;

         if idt = idef_procedure then begin
            with LineTokenClass do begin
               str := '';
               if Tokens[0] = 'print' then begin
                  str := format ('#print %s', [Tokens[2]]);
               end else if Tokens[0] = 'inc' then begin
                  str := format ('#inc %s', [Tokens[2]]);
               end else if Tokens[0] = 'dec' then begin
                  str := format ('#dec %s', [Tokens[2]]);
               end else if Tokens[0] = 'exit' then begin
                  str := format ('#exit', []);
               end;
               if str = '' then begin
                  str := format ('#pcall #noreturn %s',[Tokens[0]]);
                  for i := 0 to LineTokenClass.GetParamsCount -1 do str := str + ' ' + Tokens[2+i*2];
               end else if str <> '' then aStringList.Add (str);
               continue;
            end;
         end;

         if (idt = idef_ifunction) or (idt = idef_sfunction) or (idt = idef_bfunction) then begin
            with LineTokenClass do begin
               str := '';
               if Tokens[2] = 'callfunc' then begin
                  str := format ('#callfunc %s %s', [Tokens[0], Tokens[4]]);
               end else if Tokens[2] = 'gettoken' then begin
                  str := format ('#gettoken %s %s %s %s', [Tokens[0], Tokens[4], Tokens[6], Tokens[8]]);
               end else if Tokens[2] = 'comparestr' then begin
                  str := format ('#comparestr %s %s %s', [Tokens[0], Tokens[4], Tokens[6]]);
               end else if Tokens[2] = 'inttostr' then begin
                  str := format ('#inttostr %s %s', [Tokens[0], Tokens[4]]);
               end else if Tokens[2] = 'strtoint' then begin
                  str := format ('#strtoint %s %s', [Tokens[0], Tokens[4]]);
               end else if Tokens[2] = 'random' then begin
                  str := format ('#random %s %s', [Tokens[0], Tokens[4]]);
               end else if Tokens[2] = 'length' then begin
                  str := format ('#length %s %s', [Tokens[0], Tokens[4]]);
               end;
               if str = '' then begin
                  str := format ('#fcall %s %s',[Tokens[0], Tokens[2]]);
                  for i := 0 to LineTokenClass.GetParamsCount -1 do str := str + ' ' + Tokens[4+i*2];
               end else if str <> '' then aStringList.Add (str);
            end;
            continue;
         end;

         str := LineTokenClass.GetResult;
         if str <> '' then aStringList.Add (str);
         LineTokenClass.Clear;
      end;
   end;

   LocalStringList.Free;
   LocalSection.Free;
   OneLine.Free;
   LineTokenClass.Free;
end;

function  TFunctionClass.FuncCall: TVariableData;
   function GetLabelIndex (alabel: string): integer;
   var i: integer;
   begin
      Result := -1;
      for i := 0 to CodeStringList.Count -1 do begin
         if CodeStringList[i] = ('#label ' + alabel) then begin
            Result := i;
            exit;
         end;
      end;
   end;
var
   i, n, ProcessIndex: integer;
   str, rdstr : string;
   strs: array [0..10-1] of string;
   VariableData : TVariableData;
   pVD : PTVariableData;
   p : array [0..10-1] of PTVariableData;
   FunctionClass: TFunctionClass;
begin
   FillChar (Result, SizeOf (TVariableData), 0);
   
   for i := ParamList.Count-1 downto 0 do begin
      pVD := ParamList[i];
      FScriptClass.FScriptStack.Pop (pVD^);
   end;

   ProcessIndex := 0;
   while TRUE do begin
      if ProcessIndex >= CodeStringList.Count then break;
      str := CodeStringList[ProcessIndex];
      inc (ProcessIndex);

      for i := 0 to 10 - 1 do begin
         str := GetValidStr3 (str, strs[i], ' ');
         if Strs [i] = '' then break;
         if i > 0 then begin
            p [i] := GetVariableData (strs[i]);
         end;
      end;

      if strs[0] = '#label' then begin
         continue;
      end else if strs[0] = '#exit' then begin
         break;
      end else if strs[0] = '#result' then begin
         Result := p[1]^;
      end else if strs[0] = '#notequal' then begin
         case p[2]^.rVariableType of
            vt_boolean : p[1]^.rBoolean := p[2]^.rBoolean <> p[3]^.rBoolean;
            vt_integer : p[1]^.rBoolean := p[2]^.rInteger <> p[3]^.rInteger;
            vt_string : p[1]^.rBoolean := p[2]^.rString <> p[3]^.rString;
         end;
      end else if strs[0] = '#equal' then begin
         case p[2]^.rVariableType of
            vt_boolean : p[1]^.rBoolean := p[2]^.rBoolean = p[3]^.rBoolean;
            vt_integer : p[1]^.rBoolean := p[2]^.rInteger = p[3]^.rInteger;
            vt_string : p[1]^.rBoolean := p[2]^.rString = p[3]^.rString;
         end;
      end else if strs[0] = '#large' then begin
         case p[2]^.rVariableType of
            vt_boolean : p[1]^.rBoolean := p[2]^.rBoolean > p[3]^.rBoolean;
            vt_integer : p[1]^.rBoolean := p[2]^.rInteger > p[3]^.rInteger;
            vt_string : p[1]^.rBoolean := p[2]^.rString > p[3]^.rString;
         end;
      end else if strs[0] = '#small' then begin
         case p[2]^.rVariableType of
            vt_boolean : p[1]^.rBoolean := p[2]^.rBoolean < p[3]^.rBoolean;
            vt_integer : p[1]^.rBoolean := p[2]^.rInteger < p[3]^.rInteger;
            vt_string : p[1]^.rBoolean := p[2]^.rString < p[3]^.rString;
         end;
      end else if strs[0] = '#largeequal' then begin
         case p[2]^.rVariableType of
            vt_boolean : p[1]^.rBoolean := p[2]^.rBoolean >= p[3]^.rBoolean;
            vt_integer : p[1]^.rBoolean := p[2]^.rInteger >= p[3]^.rInteger;
            vt_string : p[1]^.rBoolean := p[2]^.rString >= p[3]^.rString;
         end;
      end else if strs[0] = '#smallequal' then begin
         case p[2]^.rVariableType of
            vt_boolean : p[1]^.rBoolean := p[2]^.rBoolean <= p[3]^.rBoolean;
            vt_integer : p[1]^.rBoolean := p[2]^.rInteger <= p[3]^.rInteger;
            vt_string : p[1]^.rBoolean := p[2]^.rString <= p[3]^.rString;
         end;
      end else if strs[0] = '#notifgoto' then begin
         if not p[1]^.rBoolean then begin
            n := GetLabelIndex (strs[2]);
            if n <> -1 then ProcessIndex := n;
         end;
      end else if strs[0] = '#goto' then begin
         n := GetLabelIndex (strs[1]);
         if n <> -1 then ProcessIndex := n;
      end else if strs[0] = '#mov' then begin
         case p[1]^.rVariableType of
            vt_integer : p[1]^.rInteger := p[2]^.rInteger;
            vt_string : p[1]^.rString := p[2]^.rString;
            vt_boolean : p[1]^.rBoolean := p[2]^.rBoolean;
         end;
      end else if strs[0] = '#add' then begin
         if (p[1] = nil) or (p[2] = nil) or (p[3] = nil) then continue;
         case p[1]^.rVariableType of
            vt_integer : p[1]^.rInteger := p[2]^.rInteger + p[3]^.rInteger;
            vt_string : p[1]^.rString := p[2]^.rString + p[3]^.rString;
         end;
      end else if strs[0] = '#sub' then begin
         p[1]^.rInteger := p[2]^.rInteger - p[3]^.rInteger;
      end else if strs[0] = '#mul' then begin
         p[1]^.rInteger := p[2]^.rInteger * p[3]^.rInteger;
      end else if strs[0] = '#div' then begin
         p[1]^.rInteger := p[2]^.rInteger div p[3]^.rInteger;
      end else if strs[0] = '#mod' then begin
         p[1]^.rInteger := p[2]^.rInteger mod p[3]^.rInteger;
      end else if strs[0] = '#inc' then begin
         inc (p[1]^.rInteger);
      end else if strs[0] = '#dec' then begin
         dec (p[1]^.rInteger);
      end else if strs[0] = '#print' then begin
         FScriptClass.AddResult (p[1]^.rString);
      end else if Strs[0] = '#gettoken' then begin
         rdstr := p[3]^.rString;
         p[1]^.rString := GetToken (p[2]^.rString, rdstr, p[4]^.rString);
         p[3]^.rString := rdstr;
      end else if strs[0] = '#comparestr' then begin
         p[1]^.rBoolean := CompareStr (p[2]^.rString, p[3]^.rString) = 0;
      end else if strs[0] = '#inttostr' then begin
         p[1]^.rString := IntToStr (p[2]^.rInteger);
      end else if strs[0] = '#strtoint' then begin
         p[1]^.rInteger := _StrToInt (p[2]^.rString);
      end else if strs[0] = '#random' then begin
         Randomize;
         p[1]^.rInteger := Random (p[2]^.rInteger);
      end else if strs[0] = '#length' then begin
         p[1]^.rInteger := Length (p[2]^.rString);
      end else if strs[0] = '#callfunc' then begin
         p[1]^.rString := ScriptManager.CallFunction (p[2]^.rString);
      end else if (strs[0] = '#fcall') or (strs[0] = '#pcall') then begin
         FunctionClass := FScriptClass.GetFunctionClass (strs[2]);
         if FunctionClass <> nil then begin
            for i := 0 to FunctionClass.ParamList.Count -1 do begin
               pVD := GetVariableData (strs[3+i]);
               VariableData := pVD^;
               VariableData.rName := PTVariableData (FunctionClass.ParamList[i])^.rName;
               FScriptClass.FScriptStack.Push (VariableData);
            end;
            VariableData := FunctionClass.FuncCall;

            if strs[0] = '#fcall' then begin
               pVD := GetVariableData (strs[1]);
               case FunctionClass.FResultType of
                  vt_integer : pVD^.rInteger :=  VariableData.rInteger;
                  vt_string : pVD^.rString :=  VariableData.rString;
               end;
            end;
         end;
      end;
   end;
end;


////////////////////////////////
//
////////////////////////////////
constructor TScriptClass.Create;
begin
   FName := '';
   FunctionList := TList.Create;
   VariableList := TList.Create;
   ExternVariableList := TList.Create;
   ResultStringList := TStringList.Create;
   FScriptStack := TScriptStack.Create;
   FInterfaceDefineClass := TInterfaceDefineClass.Create;
end;

destructor TScriptClass.Destroy;
begin
   Clear;
   FInterfaceDefineClass.Free;
   FScriptStack.Free;

   ResultStringList.Free;
   VariableList.Free;
   ExternVariableList.Free;
   FunctionList.Free;
   inherited Destroy;
end;

procedure TScriptClass.Clear;
var i: integer;
begin
   FName := '';
   FInterfaceDefineClass.Clear;
   FScriptStack.Clear;
   ResultStringList.Clear;
   for i := 0 to FunctionList.Count -1 do TFunctionClass (FunctionList[i]).Free;
   FunctionList.Clear;
   for i := 0 to VariableList.Count -1 do dispose (VariableList[i]);
   VariableList.Clear;
   for i := 0 to ExternVariableList.Count -1 do dispose (ExternVariableList[i]);
   ExternVariableList.Clear;
end;

procedure TScriptClass.Assign (aClass: TScriptClass);
var
   i : integer;
   pv: PTVariableData;
   FunctionClass : TFunctionClass;
begin
   Clear;
   FName := aClass.FName;

   for i := 0 to aClass.VariableList.Count-1 do begin
      new (pv);
      pv^ := PTVariableData (aClass.VariableList[i])^;
      VariableList.Add (pv);
   end;
   for i := 0 to aClass.ExternVariableList.Count-1 do begin
      new (pv);
      pv^ := PTVariableData (aClass.ExternVariableList[i])^;
      ExternVariableList.Add (pv);
   end;
   for i := 0 to aClass.FunctionList.Count-1 do begin
      FunctionClass := TFunctionClass.Create (Self);
      FunctionClass.Assign ( TFunctionClass (aClass.FunctionList[i]) );
      FunctionList.Add (FunctionClass);
   end;
end;

function  TScriptClass.GetResult: string;
begin
   if ResultStringList.Count = 0 then Result := ''
   else begin
      Result := ResultStringList[0];
      ResultStringList.Delete (0);
   end;
end;

procedure TScriptClass.AddResult (astr: string);
begin
   ResultStringList.Add (astr);
end;

function  TScriptClass.GetFunctionClass (aName: string): TFunctionClass;
var i: integer;
begin
   Result := nil;
   for i := 0 to FunctionList.Count -1 do begin
      if TFunctionClass (FunctionList[i]).Name = LowerCase (aName) then begin
         Result := FunctionList[i];
         exit;
      end;
   end;
end;

function  TScriptClass.GetVariableData (aName: string): PTVariableData;
var i: integer;
begin
   Result := nil;
   for i := 0 to VariableList.Count -1 do begin
      if PTVariableData (VariableList[i])^.rName = LowerCase (aName) then begin
         Result := VariableList[i];
         exit;
      end;
   end;
end;

procedure TScriptClass.LoadFromFile (aFileName: string);
var Stream : TFileStream;
begin
   Stream := TFileStream.Create (aFileName, fmOpenRead);
   LoadFromStream (Stream);
   Stream.Free;
end;

procedure TScriptClass.LoadInterface (aSection: TScriptSection);
var
   i : integer;
   vt : TVariableType;
   str, Decription, typestr: string;
   LineTokenClass : TLineTokenClass;
begin
   LineTokenClass := TLineTokenClass.Create;
   while TRUE do begin
      if aSection.ViewToken = '' then break;
      str := aSection.GetToken;

      LineTokenClass.Add (str);

      if LineTokenClass.Ended then begin
         Decription := '';
         for i := 0 to LineTokenClass.count -1 do Decription := Decription + LineTokenClass.Tokens[i] + ' ';
         if LineTokenClass.Tokens[0] = 'procedure' then
            FInterfaceDefineClass.add ( LineTokenClass.Tokens[1], Decription, idef_procedure)
         else begin
            typestr := LineTokenClass.Tokens[ LineTokenClass.Count-1-1];
            vt := GetTypebyString (typestr);
            case vt of
               vt_integer : FInterfaceDefineClass.add ( LineTokenClass.Tokens[1], Decription, idef_ifunction);
               vt_string  : FInterfaceDefineClass.add ( LineTokenClass.Tokens[1], Decription, idef_sfunction);
               vt_boolean : FInterfaceDefineClass.add ( LineTokenClass.Tokens[1], Decription, idef_bfunction);
               else raise Exception.Create('Interface: VariableType Expected buf ' + typestr + ' found');
            end;
         end;
         LineTokenClass.Clear;
      end;
   end;
   LineTokenClass.Free;
end;

{
begin
//   FInterfaceDefineClass.Add ('Name', 'DecriptString', idef_none); // for syntex error
   // extern 변수들과 함수들
   // 정의된 함수들
   // 전역변수들
end;
}

procedure TScriptClass.LoadImplementation (aSection: TScriptSection);
var
   str: string;
   FunctionClass: TFunctionClass;
   LocalSection : TScriptSection;
begin
   LocalSection := TScriptSection.Create;
   while TRUE do begin
      if aSection.ViewToken = '' then break;
      str := aSection.GetToken;

      if (str = 'procedure') or (str = 'function') then begin
         LocalSection.LoadFromScriptSection (aSection, ['procedure', 'function']);
         LocalSection.InsertToken (0, str);

         FunctionClass := TFunctionClass.Create (Self);
         FunctionClass.LoadFromSection (LocalSection);
         FunctionList.Add (FunctionClass);
         continue;
      end;
   end;
   LocalSection.Free;
end;

procedure TScriptClass.LoadFromStream (aStream: TStream);
var
   str: string;
   Parser: TScriptParser;
   Section: TScriptSection;
begin
   Clear;
   Parser := TScriptParser.Create;
   Section := TScriptSection.Create;

   Parser.LoadFromStream (aStream);

   while TRUE do begin
      str := Parser.ViewToken;
      if str = '' then break;
      str := Parser.GetToken;
      if str = 'unit' then begin
         Section.LoadFromScriptParser (Parser, ['interface']);
         FName := Section.GetToken;
         continue;
      end else if str = 'interface' then begin
         Section.LoadFromScriptParser (Parser, ['extern', 'var','implementation']);
         LoadInterface (Section);
         continue;
      end else if str = 'extern' then begin
         Section.LoadFromScriptParser (Parser, ['extern', 'var','implementation','end.']);
         LoadVariableFromSection (Section, ExternVariableList);
         continue;
      end else if str = 'var' then begin
         Section.LoadFromScriptParser (Parser, ['extern', 'var','implementation','end.']);
         LoadVariableFromSection (Section, VariableList);
         continue;
      end else if str = 'implementation' then begin
         Section.LoadFromScriptParser (Parser, ['end.']);
         LoadImplementation (Section);
         continue;
      end else if str = 'end.' then begin
         break;
         continue;
      end;
   end;
   Parser.Free;
   Section.Free;
end;

function TScriptClass.FunctionCallbyName (aFuncName: string; aParams: array of string) : String;
var
   i, selfparamcount : integer;
   Ret : TVariableData;
   p : PTVariableData;
   VariableData: TVariableData;
   FunctionClass : TFunctionClass;
   Str : String;
begin
   Result := '';

   FunctionClass := GetFunctionClass (aFuncName);
   if FunctionClass = nil then exit;

   selfparamcount := High(aParams)+1;
   if FunctionClass.ParamList.Count <> selfparamcount then exit;

   for i := 0 to FunctionClass.ParamList.Count -1 do begin
       p := FunctionClass.ParamList[i];
       VariableData := p^;
       case VariableData.rVariabletype of
          vt_integer : VariableData.rInteger := StrToInt (aParams[i]);
          vt_string :
            begin
               Str := ChangeScriptString (aParams [i], ' ', '_');
               VariableData.rString := Str;
            end;
       end;
       FScriptStack.Push (VariableData);
   end;

   Ret := FunctionClass.FuncCall;

   case Ret.rVariabletype of
      vt_none: ;
      vt_integer : Result := IntToStr (Ret.rInteger);
      vt_string : Result := Ret.rString;
      vt_boolean : begin
         if Ret.rBoolean = true then Result := 'true'
         else Result := 'false';
      end;
   end;
end;

function  TScriptClass.SetExternVariable (aName, aValue: string): Boolean;
var
   i: integer;
   p : PTVariableData;
begin
   Result := FALSE;
   aName := lowercase (aName); aValue := lowercase (aValue);

   for i := 0 to ExternVariableList.Count -1 do begin
      p := PTVariableData (ExternVariableList[i]);
      if p^.rName = aName then begin
         case p^.rVariabletype of
            vt_none: ;
            vt_integer : p^.rInteger := StrToInt (aValue);
            vt_string : p^.rString := aValue;
            vt_boolean : p^.rBoolean := aValue = 'true';
         end;
         Result := TRUE;
         exit;
      end;
   end;
end;


end.
