unit uDoorGen;

interface

uses
   Classes, SysUtils, BasicObj, DefType, UserSDB, AUtil32, uManager,
   uMonster, AnsStringCls;

type
   TSoundObj = class (TBasicObject)
   private
      SoundName : String;

      UpdatedTick : Integer;
      PlayedTick : Integer;
      PlayInterval : Integer;
   protected
      function FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Initial (pd : PTCreateSoundObjData);
      procedure StartProcess; override;
      procedure EndProcess; override;

      procedure Update (CurTick: integer); override;
   end;

   TSoundObjList = class
   private
      DataList : TList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      function LoadFromFile (aFileName : String) : Boolean;
      
      procedure Update (CurTick : Integer);
   end;



var
   SoundObjList : TSoundObjList;

implementation

uses
   svClass, SubUtil;

// TSoundObj
constructor TSoundObj.Create;
begin
   inherited Create;

   SoundName := '';

   UpdatedTick := 0;
   PlayedTick := 0;
   PlayInterval := 0;
end;

destructor TSoundObj.Destroy;
begin
   inherited Destroy;
end;

procedure TSoundObj.Initial (pd : PTCreateSoundObjData);
begin
   inherited Initial (pd^.Name, '');

   BasicData.id := GetNewItemId;

   BasicData.x := pd^.X;
   BasicData.y := pd^.Y;
   BasicData.nx := pd^.X;
   BasicData.ny := pd^.Y;
   BasicData.ClassKind := CLASS_SERVEROBJ;
   BasicData.Feature.rRace := RACE_ITEM;
   BasicData.Feature.rImageNumber := 0;
   BasicData.Feature.rImageColorIndex := 0;

   SoundName := pd^.SoundName;

   UpdatedTick := 0;
   PlayedTick := 0;
   PlayInterval := pd^.PlayInterval;
end;

procedure TSoundObj.StartProcess;
var
   SubData : TSubData;
begin
   inherited StartProcess;

   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (0, FM_CREATE, BasicData, SubData);
end;

procedure TSoundObj.EndProcess;
var
   SubData : TSubData;
begin
   Phone.SendMessage (0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

function TSoundObj.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
begin
   Result := PROC_FALSE;

   if isRangeMessage (hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;
end;

procedure TSoundObj.Update (CurTick: integer);
var
   SubData : TSubData;
begin
   if CurTick < UpdatedTick + 100 then exit;
   UpdatedTick := CurTick;

   if CurTick >= PlayedTick + PlayInterval then begin
      SetWordString (SubData.SayString, SoundName + '.wav'); 
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      PlayedTick := CurTick;
   end;
end;

// TSoundObjList
constructor TSoundObjList.Create;
begin
   DataList := TList.Create;
   LoadFromFile ('.\Setting\CreateSoundObject.SDB');
end;

destructor TSoundObjList.Destroy;
begin
   Clear;
   DataList.Free;
   
   inherited Destroy;
end;

procedure TSoundObjList.Clear;
var
   i : Integer;
   SoundObj : TSoundObj;
begin
   for i := 0 to DataList.Count - 1 do begin
      SoundObj := DataList.Items [i];
      SoundObj.EndProcess;
      SoundObj.Free;
   end;

   DataList.Clear;
end;

function TSoundObjList.LoadFromFile (aFileName : String) : Boolean;
var
   i : Integer;
   iName : String;
   DB : TUserStringDB;
   SoundObj : TSoundObj;
   csod : TCreateSoundObjData;
   Manager : TManager;
begin
   Result := false;

   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);
   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      csod.Name := iName;
      csod.SoundName := DB.GetFieldValueString (iName, 'SoundName');
      csod.MapID := DB.GetFieldValueInteger (iName, 'MapID');
      csod.X := DB.GetFieldValueInteger (iName, 'X');
      csod.Y := DB.GetFieldValueInteger (iName, 'Y');
      csod.PlayInterval := DB.GetFieldValueInteger (iName, 'PlayInterval');

      Manager := ManagerList.GetManagerByServerID (csod.MapID);
      if Manager <> nil then begin
         SoundObj := TSoundObj.Create;
         SoundObj.SetManagerClass (Manager);
         SoundObj.Initial (@csod);
         SoundObj.StartProcess;

         DataList.Add (SoundObj);
      end;
   end;
   DB.Free;

   Result := true;
end;

procedure TSoundObjList.Update (CurTick : Integer);
var
   i : Integer;
   SoundObj : TSoundObj;
begin
   for i := 0 to DataList.Count - 1 do begin
      SoundObj := DataList.Items [i];
      SoundObj.Update (CurTick);
   end;
end;


end.
