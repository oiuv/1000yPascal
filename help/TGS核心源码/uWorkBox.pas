unit uWorkBox;

interface

uses
   Windows, SysUtils, Classes, uAnsTick;

const
   CMD_NONE          = 0;
   CMD_ATTACK        = 1;
   CMD_GOTOXY        = 2;
   CMD_SAY           = 3;
   CMD_SOUND         = 4;
   CMD_SELFKILL      = 5;
   CMD_CHANGESTATE   = 6;
   CMD_SENDCENTERMSG = 7;
   CMD_CHANGESTEP    = 8;
   CMD_MOVESPACE     = 9;
   CMD_MAPREGEN      = 10;
   CMD_MOVEATTACK    = 11;
   CMD_ALLOWHIT      = 12;
   CMD_ADDMOP        = 13;     

type
   TWorkState = ( ws_none, ws_ing, ws_done, ws_giveup );
   TWorkSetPriority = ( wsp_byte, wsp_kilo, wsp_mega, wsp_giga, wsp_tera );
   TWorkParamType = ( wpt_integer, wpt_string );
   TWorkControlMode = ( wcm_manual, wcm_auto );
   TWorkParam = record
      ParamType : TWorkParamType;
      iValue : Integer;
      sValue : String [80];
   end;
   PTWorkParam = ^TWorkParam;

   TWorkSet = class
   private
      FCommand : Byte;
      FPriority : TWorkSetPriority;

      FTick, FInterval : Integer;
      ParamList : TList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      procedure AddiParam (aType : TWorkParamType; iValue : Integer);
      procedure AddsParam (aType : TWorkParamType; sValue : String);

      function GetParam (aIndex : Integer) : PTWorkParam;

      function isTimeOver (CurTick : Integer) : Boolean;

      property Cmd : byte read FCommand write FCommand;
      property Priority : TWorkSetPriority read FPriority write FPriority;
      property Interval : Integer read FInterval write FInterval;
   end;

   TWorkBox = class
   private
      DataList : TList;
      FWorkState : TWorkState;
      FAutoMode : TWorkControlMode;

      function GetCount : Integer;
   private
      FCurWorkSet : TWorkSet;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      procedure Push (aWorkSet : TWorkSet);

      procedure WorkOver;

      property Count : Integer read GetCount;
      property WorkSet : TWorkSet read FCurWorkSet;
      property WorkState : TWorkState read FWorkState write FWorkState;
      property AutoMode : TWorkControlMode read FAutoMode write FAutoMode;
   end;

implementation

// TWorkSet;
constructor TWorkSet.Create;
begin
   FCommand := CMD_NONE;
   FTick := mmAnsTick;
   FInterval := 0;
   ParamList := TList.Create;
end;

destructor TWorkSet.Destroy;
begin
   Clear;
   ParamList.Free;

   inherited Destroy;
end;

procedure TWorkSet.Clear;
var
   i : Integer;
   pWorkParam : PTWorkParam;
begin
   for i := 0 to ParamList.Count - 1 do begin
      pWorkParam := ParamList.Items [i];
      DisPose (pWorkParam);
   end;
   ParamList.Clear;
end;

procedure TWorkSet.AddiParam (aType : TWorkParamType; iValue : Integer);
var
   pWorkParam : PTWorkParam;
begin
   New (pWorkParam);
   FillChar (pWorkParam^, SizeOf (TWorkParam), 0);
   pWorkParam^.ParamType := aType;
   pWorkParam^.iValue := iValue;

   ParamList.Add (pWorkParam);
end;

procedure TWorkSet.AddsParam (aType : TWorkParamType; sValue : String);
var
   pWorkParam : PTWorkParam;
begin
   New (pWorkParam);
   FillChar (pWorkParam^, SizeOf (TWorkParam), 0);
   pWorkParam^.ParamType := aType;
   pWorkParam^.sValue := sValue;

   ParamList.Add (pWorkParam);
end;

function TWorkSet.GetParam (aIndex : Integer) : PTWorkParam;
begin
   Result := ParamList.Items [aIndex];
end;

function TWorkSet.isTimeOver (CurTick : Integer) : Boolean;
begin
   Result := false;
   if CurTick >= FTick + FInterval then Result := true;
end;

// TWorkBox;
constructor TWorkBox.Create;
begin
   DataList := TList.Create;
   FWorkState := ws_none;
   FAutoMode := wcm_manual;

   FCurWorkSet := nil;
end;

destructor TWorkBox.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

procedure TWorkBox.Clear;
var
   i : Integer;
   WorkSet : TWorkSet;
begin
   for i := 0 to DataList.Count - 1 do begin
      WorkSet := DataList.Items [i];
      WorkSet.Free;
   end;
   DataList.Clear;

   FWorkState := ws_none;
   FCurWorkSet := nil;
end;

procedure TWorkBox.Push (aWorkSet : TWorkSet);
var
   i : Integer;
   WorkSet : TWorkSet;
begin
   if aWorkSet = nil then exit;

   for i := DataList.Count - 1 downto 0 do begin
      WorkSet := DataList.Items [i];
      if WorkSet.FPriority >= aWorkSet.FPriority then begin
         if i = DataList.Count - 1 then DataList.Add (aWorkSet)
         else DataList.Insert (i + 1, aWorkSet);
         exit;
      end;
   end;

   if DataList.Count > 0 then DataList.Insert (0, aWorkSet)
   else DataList.Add (aWorkSet);

   FWorkState := ws_none;
   FCurWorkSet := DataList.Items [0];
end;

procedure TWorkBox.WorkOver;
var
   WorkSet : TWorkSet;
begin
   if FWorkState = ws_ing then begin
      FWorkState := ws_done;
      if DataList.Count > 0 then begin
         WorkSet := DataList.Items [0];
         WorkSet.Free;
         DataList.Delete (0);
      end;
      if DataList.Count > 0 then begin
         FWorkState := ws_none;
         FCurWorkSet := DataList.Items [0];
      end else begin
         FCurWorkSet := nil;
      end;
   end;
end;

function TWorkBox.GetCount : Integer;
begin
   Result := DataList.Count;
end;

end.
