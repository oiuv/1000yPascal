unit MapUnit;

interface

uses
  Windows, Classes, SysUtils, DefType, subutil, autil32;

const
   ImageLibID = 'ATZMAP2';

type
   TMapCellArr = array [0..MaxListSize] of Byte;
   PTMapCellArr = ^TMapCellArr;

   TMapUser = record
      Id : LongInt;
   end;

   PTMapUser = ^TMapUser;
   TMapUserArr = array[0..MaxListSize] of TMapUser;
   PTMapUserArr = ^TMapUserArr;

   TMaper = Class
    private
     FWidth, FHeight : integer;
     MapFileName : string;
     MapCellArr : PTMapCellArr;
     MapUserArr : PTMapUserArr;
     MapAreaArr : PTMapCellArr;

     procedure  LoadMapFromFile (aFileName: string);
     procedure  LoadSMAFromFile (aFileName: string);
    public
     constructor Create (aMapFileName: string);
     destructor Destroy; override;

     function   GetMoveableXy (var ax, ay: integer; aw : word): Boolean;
     function   GetAreaIndex (x, y : Integer) : Byte;

     function   GetObjectID (ax, ay: integer) : Integer;
     function   GetNearXy (var ax, ay: integer): Boolean;
     function   isMoveable ( x, y: Integer) : Boolean;
     function   isMoveable2 ( x, y: Integer; var hfu : Integer) : Boolean;
     function   isMoveTile ( x, y: Integer) : Boolean;
     function   isObjectArea (x, y : Integer) : Boolean;
     function   isGuildStoneArea (x, y : Integer) : Boolean;
     function   MapProc (Id: LongInt; Msg, x1, y1, x2, y2: word; var SenderInfo : TBasicData): Integer;
     property   Width : integer read FWidth;
     property   Height : integer read FHeight;
   end;

implementation

uses
   uUser, FieldMsg;

function  TMaper.GetMoveableXy (var ax, ay: integer; aw : word) : Boolean;
var
   i : Integer;
   xx, yy : Integer;
   ww : Integer;
   boFlag : Boolean;
begin
   xx := ax; yy := ay;
   ww := aw;
   boFlag := false;

   if isMoveable (xx, yy) then begin
      Result := true;
      exit;
   end;
   while ww > 0 do begin
      for i := ww to aw do begin
         xx := xx - 1;
         if isMoveable (xx, yy) then begin boFlag := true; break; end;
      end;
      if boFlag = true then break;
      for i := ww to aw do begin
         yy := yy - 1;
         if isMoveable (xx, yy) then begin boFlag := true; break; end;
      end;
      if boFlag = true then break;
      ww := ww - 1;
      for i := ww to aw do begin
         xx := xx + 1;
         if isMoveable (xx, yy) then begin boFlag := true; break; end;
      end;
      if boFlag = true then break;
      for i := ww to aw do begin
         yy := yy + 1;
         if isMoveable (xx, yy) then begin boFlag := true; break; end;
      end;
      if boFlag = true then break;
      ww := ww - 1;
   end;

   if boFlag = true then begin
      ax := xx; ay := yy;
   end;

   Result := boFlag;
end;

function  TMaper.GetNearXy (var ax, ay: integer): Boolean;
var
   i, xx, yy, tempx, tempy : integer;
begin
   Result := TRUE;

   xx := ax; yy := ay;
   tempx := 0; tempy := 0;

   // 2000.09.19 시작위치가 한칸위 또는 한칸왼쪽으로 바뀌어 시작되는
   // 현상수정 현재위치가 Movable한가를 먼저 체크 by Lee.S.G
   if not isMoveable (xx + tempx, yy + tempy) then begin
      for i := 0 to 32 do begin
         GetNearPosition (tempx, tempy);
         if isMoveable (xx + tempx, yy + tempy) then break;
      end;
      if not isMoveable (xx + tempx, yy + tempy) then begin tempx := 0; tempy := 0; Result := FALSE; end;
   end;

   ax := ax + tempx; ay := ay + tempy;
end;

constructor TMaper.Create (aMapFileName: string);
begin
   MapFileName := aMapFileName;
   MapCellArr := nil;
   MapUserArr := nil;
   MapAreaArr := nil;
   LoadMapFromFile ( MapFileName);
end;

destructor TMaper.Destroy;
begin
   if MapAreaArr <> nil then FreeMem (MapAreaArr);
   if MapCellArr <> nil then FreeMem (MapCellArr);
   if MapUserArr <> nil then FreeMem (MapUserArr);

   MapCellArr := nil;
   MapUserArr := nil;
   MapAreaArr := nil;

   inherited Destroy;
end;

type
   TMapServerFileHeader = record
      IDent : array [0..7] of char;
      Width : integer;
      Height: integer;
   end;

   TSMAFileHeader = record
      IDent : array [0..7] of Char;
      Width : Integer;
      Height : Integer;
   end;

procedure TMaper.LoadMapFromFile (aFileName: string);
var
   fh : integer;
   MapServerFileHeader : TMapServerFileHeader;
   SMAFileName : String;
begin
   fh := FileOpen (aFileName, fmOpenRead);
   try
      FileRead (fh, MapServerfileHeader, sizeof(MapServerFileHeader));
      if StrLIComp(PChar(ImageLibID), MapServerFileHeader.Ident, 4) = 0 then begin
         FWidth := MapServerFileHeader.Width;
         FHeight := MapServerFileHeader.Height;

         if MapCellArr <> nil then FreeMem (MapCellArr);
         if MapUserArr <> nil then FreeMem (MapUserArr);
         
         MapCellArr := nil; MapUserArr := nil;
         GetMem ( MapCellArr, FWidth * FHeight);
         GetMem ( MapUserArr, sizeof(TMapUser)*FWidth * FHeight);
         FillChar (MapCellArr^, FWidth * FHeight, 0);
         FillChar (MapUserArr^, sizeof(TMapUser) * FWidth * FHeight, 0);

         FileRead (fh, MapCellArr^, FWidth * FHeight);
      end;
      FileClose(fh);
   except
      FileClose(fh);
      raise;
   end;

   SMAFileName := ChangeFileExt (aFileName, '.SMA');
   LoadSMAFromFile (SMAFileName);
end;

procedure TMaper.LoadSMAFromFile (aFileName: String);
var
   SMAHeader : TSMAFileHeader;
   Stream : TFileStream;
begin
   if not FileExists (aFileName) then exit;

   Stream := TFileStream.Create (aFileName, fmOpenRead);
   Stream.ReadBuffer (SMAHeader, SizeOf (TSMAFileHeader));

   if (SMAHeader.Width <> FWidth) or (SMAHeader.Height <> FHeight) then begin
      Stream.Free;
      exit;
   end;

   if MapAreaArr <> nil then FreeMem (MapAreaArr);
   GetMem (MapAreaArr, FWidth * FHeight);

   Stream.ReadBuffer (MapAreaArr^, FWidth * FHeight);

   Stream.Free;
end;

function TMaper.GetAreaIndex (x, y : Integer) : Byte;
var
   ReadPos : Integer;
begin
   Result := 0;

   if MapAreaArr = nil then exit;
   if (x < 0 ) or (y < 0) or (x >= FWidth) or (y >= FHeight) then exit;
   ReadPos := y * FWidth + x;

   Result := MapAreaArr[ReadPos];
end;

function TMaper.GetObjectID (ax, ay: integer) : Integer;
begin
   Result := MapUserArr[ay * FWidth + ax].id;
end;

function   TMaper.isMoveable ( x, y: Integer) : Boolean;
begin
   Result := TRUE;
   if (x < 0 ) or (y < 0) or (x >= FWidth) or (y >= FHeight) then begin
      Result := FALSE;
      exit;
   end;

   if (MapCellArr[y*FWidth+x] and 1 <> 0) or (MapCellArr[y*FWidth+x] and 2 <> 0) then begin
      Result := FALSE;
      exit;
   end;

   // 유저가 진짜 있는지 확인하고 없으면 허용 해야 됨.
   if MapUserArr[y*FWidth+x].id <> 0 then begin
      Result := FALSE;
      exit;
   end;
end;

function   TMaper.isMoveable2 ( x, y: Integer; var hfu : Integer) : Boolean;
begin
   Result := TRUE;
   if (x < 0 ) or (y < 0) or (x >= FWidth) or (y >= FHeight) then begin
      Result := FALSE;
      hfu := -1;
      exit;
   end;

   if (MapCellArr[y*FWidth+x] and 1 <> 0) or (MapCellArr[y*FWidth+x] and 2 <> 0) then begin
      Result := FALSE;
      hfu := -1;
      exit;
   end;

   // 유저가 진짜 있는지 확인하고 없으면 허용 해야 됨.
   if MapUserArr[y*FWidth+x].id <> 0 then begin
      Result := FALSE;
      hfu := MapUserArr[y*FWidth+x].Id;
      exit;
   end;
end;


function TMaper.isMoveTile ( x, y: Integer) : Boolean;
begin
   Result := TRUE;
   if (x < 0 ) or (y < 0) or (x >= FWidth) or (y >= FHeight) then begin
      Result := FALSE;
      exit;
   end;

   if (MapCellArr[y*FWidth+x] and 1 <> 0) or (MapCellArr[y*FWidth+x] and 2 <> 0) then begin
      Result := FALSE;
      exit;
   end;
end;

function TMaper.isGuildStoneArea (x, y : Integer) : Boolean;
var
   i, j : Integer;
begin
   Result := false;

   if (x < 0 ) or (y < 0) or (x >= FWidth) or (y >= FHeight) then begin
      Result := true;
      exit;
   end;
   
   for i := -1 to 1 do begin
      for j := -1 to 1 do begin
         if (i + y >= 0) and (j + x >= 0) and (i + y < FHeight) and (j + x < FWidth) then begin
            if isStaticItemId (MapUserArr[(i + y) * FWidth + (j + x)].id) then begin
               Result := true;
               exit;
            end;
         end;
      end;
   end;
end;

function TMaper.isObjectArea (x, y : Integer) : Boolean;
var
   i, j : Integer;
begin
   Result := false;

   if (x < 0 ) or (y < 0) or (x >= FWidth) or (y >= FHeight) then begin
      Result := true;
      exit;
   end;
   if (MapCellArr[y*FWidth+x] and 1 <> 0) or (MapCellArr[y*FWidth+x] and 2 <> 0) then begin
      Result := true;
      exit;
   end;

   for i := -2 to 2 do begin
      for j := -2 to 2 do begin
         if (i + y >= 0) and (j + x >= 0) and (i + y < FHeight) and (j + x < FWidth) then begin
            if (MapCellArr[(i+y)*FWidth + (j+x)] and 2 <> 0) then begin
               Result := true;
               exit;
            end; 
         end;
      end;
   end;
end;

function TMaper.MapProc (Id: LongInt; Msg, x1, y1, x2, y2: Word; var SenderInfo : TBasicData): Integer;
var
   i : Integer;
   xx, yy : Integer;
begin
   Result := 0;

   if isObjectItemId ( Id) then exit;

   if (x1 >= FWidth) or (y1 >= FHeight) then begin Result := -1; exit; end;
   if (x2 >= FWidth) or (y2 >= FHeight) then begin Result := -1; exit; end;

   case Msg of
      MM_MOVE :
         begin
            if MapUserArr[y1*FWidth + x1].id = id then begin
               for i := 0 to 20 - 1 do begin
                  xx := SenderInfo.GuardX[i];
                  yy := SenderInfo.GuardY[i];
                  MapUserArr[(y1 + yy) * FWidth + (x1 + xx)].id := 0;
                  if (xx = 0) and (yy = 0) then break;
               end;
            end;
            for i := 0 to 20 - 1 do begin
               xx := SenderInfo.GuardX[i];
               yy := SenderInfo.GuardY[i];
               MapUserArr[(y2 + yy) * FWidth + (x2 + xx)].id := Id;
               if (xx = 0) and (yy = 0) then break;
            end;
         end;
      MM_SHOW  :
         begin
            for i := 0 to 20 - 1 do begin
               xx := SenderInfo.GuardX[i];
               yy := SenderInfo.GuardY[i];
               MapUserArr[(y1 + yy) * FWidth + (x1 + xx)].id := Id;
               if (xx = 0) and (yy = 0) then break;
            end;
         end;
      MM_HIDE :
         begin
            for i := 0 to 20 - 1 do begin
               xx := SenderInfo.GuardX[i];
               yy := SenderInfo.GuardY[i];
               if MapUserArr[(y1 + yy) * FWidth + (x1 + xx)].id = id then MapUserArr[(y1 + yy) * FWidth + (x1 + xx)].id := 0;
               if (xx = 0) and (yy = 0) then break;
            end;
         end;
      else Result := -1;
   end;
end;


end.
