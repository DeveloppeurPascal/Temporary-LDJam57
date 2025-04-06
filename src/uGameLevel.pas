unit uGameLevel;

interface

uses
  System.Generics.Collections,
  System.Classes;

type
{$SCOPEDENUMS ON}
  TGameLevelCharacterLook = (None, Zombie);

  TGameLevelPlatformLook = (None, Castle, Dirt, Grass, Sand, Snow, Stone);
  TGameLevelPlatformEndType = (None, Bloc, Cliff);

  // TODO : add XML Doc comments

  // TODO : sécuriser le chargement et la sauvegarde des niveaux de jeu

  // TODO : ajouter un mot de passe facultatif pour jouer à un niveau de jeu

  // TODO : ajouter un mot de passe facultatif pour accéder à un niveau de jeu depuis l'éditeur de niveaux (en mise à jour)

  // TODO : ajouter un chargement des portes liées à une salle depuis la liste domplète des portes afin d'optimiser les affichages et tests de collision en cours de partie

  // TODO : remplacer le load/save des types énumérés par une valeur dont la taille est maîtrisée (par mesure de précaution)

  TGameLevelPlatform = class
  private
    FX: cardinal;
    FY: cardinal;
    FNbBloc: cardinal;
    FLeftBlocType: TGameLevelPlatformEndType;
    FLook: TGameLevelPlatformLook;
    FRightBlocType: TGameLevelPlatformEndType;
    procedure SetX(const Value: cardinal);
    procedure SetY(const Value: cardinal);
    procedure SetLook(const Value: TGameLevelPlatformLook);
    procedure SetLeftBlocType(const Value: TGameLevelPlatformEndType);
    procedure SetNbBloc(const Value: cardinal);
    procedure SetRightBlocType(const Value: TGameLevelPlatformEndType);
  protected
  public
    property X: cardinal read FX write SetX;
    property Y: cardinal read FY write SetY;
    property NbBloc: cardinal read FNbBloc write SetNbBloc;
    property Look: TGameLevelPlatformLook read FLook write SetLook;
    property LeftBlocType: TGameLevelPlatformEndType read FLeftBlocType
      write SetLeftBlocType;
    property RightBlocType: TGameLevelPlatformEndType read FRightBlocType
      write SetRightBlocType;
    constructor Create; virtual;
    procedure SaveToStream(const AStream: TStream);
    procedure LoadFromStream(const AStream: TStream);
  end;

  TGameLevelPlatformList = class(TObjectList<TGameLevelPlatform>)
  private
  protected
  public
    procedure SaveToStream(const AStream: TStream);
    procedure LoadFromStream(const AStream: TStream);
  end;

  TGameLevelRoom = class
  private
    FPlatforms: TGameLevelPlatformList;
    FId: cardinal;
    procedure SetId(const Value: cardinal);
    procedure SetPlatforms(const Value: TGameLevelPlatformList);
  protected
  public
    property Id: cardinal read FId write SetId;
    property Platforms: TGameLevelPlatformList read FPlatforms
      write SetPlatforms;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SaveToStream(const AStream: TStream);
    procedure LoadFromStream(const AStream: TStream);
  end;

  TGameLevelRoomList = class(TObjectDictionary<cardinal, TGameLevelRoom>)
  private
  protected
  public
    procedure SaveToStream(const AStream: TStream);
    procedure LoadFromStream(const AStream: TStream);
  end;

  TGameLevelDoorLook = (None, BrownUsed, Brown, GreyUsed, Grey);

  TGameLevelDoorDirection = (None, Back, Front);

  TGameLevelDoor = class
  private
    FDirection: TGameLevelDoorDirection;
    FRoom: cardinal;
    FLook: TGameLevelDoorLook;
    FId: cardinal;
    FLinkedDoor: cardinal;
    FX: cardinal;
    FY: cardinal;
    procedure SetDirection(const Value: TGameLevelDoorDirection);
    procedure SetId(const Value: cardinal);
    procedure SetLinkedDoor(const Value: cardinal);
    procedure SetLook(const Value: TGameLevelDoorLook);
    procedure SetRoom(const Value: cardinal);
    procedure SetX(const Value: cardinal);
    procedure SetY(const Value: cardinal);
  protected
  public
    property Id: cardinal read FId write SetId;
    property X: cardinal read FX write SetX;
    property Y: cardinal read FY write SetY;
    property Room: cardinal read FRoom write SetRoom;
    property Look: TGameLevelDoorLook read FLook write SetLook;
    property Direction: TGameLevelDoorDirection read FDirection
      write SetDirection;
    property LinkedDoor: cardinal read FLinkedDoor write SetLinkedDoor;
    constructor Create; virtual;
    procedure SaveToStream(const AStream: TStream);
    procedure LoadFromStream(const AStream: TStream);
  end;

  TGameLevelDoorList = class(TObjectDictionary<cardinal, TGameLevelDoor>)
  private
  protected
  public
    procedure SaveToStream(const AStream: TStream);
    procedure LoadFromStream(const AStream: TStream);
  end;

  TGameLevel = class
  private
    FDoors: TGameLevelDoorList;
    FRooms: TGameLevelRoomList;
    FStartX: cardinal;
    FStartY: cardinal;
    FStartRoom: cardinal;
    FFileName: string;
    procedure SetDoors(const Value: TGameLevelDoorList);
    procedure SetRooms(const Value: TGameLevelRoomList);
    procedure SetStartRoom(const Value: cardinal);
    procedure SetStartX(const Value: cardinal);
    procedure SetStartY(const Value: cardinal);
  protected
  public
    property Rooms: TGameLevelRoomList read FRooms write SetRooms;
    property Doors: TGameLevelDoorList read FDoors write SetDoors;
    property StartX: cardinal read FStartX write SetStartX;
    property StartY: cardinal read FStartY write SetStartY;
    property StartRoom: cardinal read FStartRoom write SetStartRoom;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SaveToStream(const AStream: TStream);
    procedure LoadFromStream(const AStream: TStream);
    procedure SaveToFile(const AFilename: string = '');
    procedure LoadFromFile(const AFilename: string);
    procedure Clear;
    procedure Initialize;
    function LastRoomId: cardinal;
    function LastDoorId: cardinal;
  end;

implementation

uses
  System.IOUtils,
  System.SysUtils;
{ TGameLevelPlatform }

constructor TGameLevelPlatform.Create;
begin
  inherited;
  FX := 0;
  FY := 0;
  FNbBloc := 0;
  FLook := TGameLevelPlatformLook.None;
  FLeftBlocType := TGameLevelPlatformEndType.None;
  FRightBlocType := TGameLevelPlatformEndType.None;
end;

procedure TGameLevelPlatform.LoadFromStream(const AStream: TStream);
begin
  // TODO : ajouter la vérification du numéro de version de cette classe
  if (AStream.Read(FNbBloc, sizeof(FNbBloc)) <> sizeof(FNbBloc)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FLook, sizeof(FLook)) <> sizeof(FLook)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FLeftBlocType, sizeof(FLeftBlocType)) <>
    sizeof(FLeftBlocType)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FRightBlocType, sizeof(FRightBlocType)) <>
    sizeof(FRightBlocType)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Wrong file format !');
end;

procedure TGameLevelPlatform.SaveToStream(const AStream: TStream);
begin
  // TODO : ajouter un numéro de version pour cette classe
  AStream.Write(FNbBloc, sizeof(FNbBloc));
  AStream.Write(FLook, sizeof(FLook));
  AStream.Write(FLeftBlocType, sizeof(FLeftBlocType));
  AStream.Write(FRightBlocType, sizeof(FRightBlocType));
  AStream.Write(FX, sizeof(FX));
  AStream.Write(FY, sizeof(FY));
end;

procedure TGameLevelPlatform.SetLook(const Value: TGameLevelPlatformLook);
begin
  FLook := Value;
end;

procedure TGameLevelPlatform.SetLeftBlocType(const Value
  : TGameLevelPlatformEndType);
begin
  FLeftBlocType := Value;
end;

procedure TGameLevelPlatform.SetNbBloc(const Value: cardinal);
begin
  FNbBloc := Value;
end;

procedure TGameLevelPlatform.SetRightBlocType(const Value
  : TGameLevelPlatformEndType);
begin
  FRightBlocType := Value;
end;

procedure TGameLevelPlatform.SetX(const Value: cardinal);
begin
  FX := Value;
end;

procedure TGameLevelPlatform.SetY(const Value: cardinal);
begin
  FY := Value;
end;

{ TGameLevelRoom }

constructor TGameLevelRoom.Create;
begin
  inherited;
  FPlatforms := TGameLevelPlatformList.Create;
  FId := 0;
end;

destructor TGameLevelRoom.Destroy;
begin
  FPlatforms.Free;
  inherited;
end;

procedure TGameLevelRoom.LoadFromStream(const AStream: TStream);
begin
  // TODO : ajouter la vérification du numéro de version de cette classe
  if (AStream.Read(FId, sizeof(FId)) <> sizeof(FId)) then
    raise exception.Create('Wrong file format !');
  FPlatforms.LoadFromStream(AStream);
end;

procedure TGameLevelRoom.SaveToStream(const AStream: TStream);
begin
  // TODO : ajouter un numéro de version pour cette classe
  AStream.Write(FId, sizeof(FId));
  FPlatforms.SaveToStream(AStream);
end;

procedure TGameLevelRoom.SetId(const Value: cardinal);
begin
  FId := Value;
end;

procedure TGameLevelRoom.SetPlatforms(const Value: TGameLevelPlatformList);
begin
  FPlatforms := Value;
end;

{ TGameLevelDoor }

constructor TGameLevelDoor.Create;
begin
  inherited;
  FDirection := TGameLevelDoorDirection.None;
  FRoom := 0;
  FLook := TGameLevelDoorLook.None;
  FId := 0;
  FLinkedDoor := 0;
  FX := 0;
  FY := 0;
end;

procedure TGameLevelDoor.LoadFromStream(const AStream: TStream);
begin
  // TODO : ajouter la vérification du numéro de version de cette classe
  if (AStream.Read(FId, sizeof(FId)) <> sizeof(FId)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FRoom, sizeof(FRoom)) <> sizeof(FRoom)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FLook, sizeof(FLook)) <> sizeof(FLook)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FDirection, sizeof(FDirection)) <> sizeof(FDirection)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FLinkedDoor, sizeof(FLinkedDoor)) <> sizeof(FLinkedDoor))
  then
    raise exception.Create('Wrong file format !');
end;

procedure TGameLevelDoor.SaveToStream(const AStream: TStream);
begin
  // TODO : ajouter un numéro de version pour cette classe
  AStream.Write(FId, sizeof(FId));
  AStream.Write(FRoom, sizeof(FRoom));
  AStream.Write(FX, sizeof(FX));
  AStream.Write(FY, sizeof(FY));
  AStream.Write(FLook, sizeof(FLook));
  AStream.Write(FDirection, sizeof(FDirection));
  AStream.Write(FLinkedDoor, sizeof(FLinkedDoor));
end;

procedure TGameLevelDoor.SetDirection(const Value: TGameLevelDoorDirection);
begin
  FDirection := Value;
end;

procedure TGameLevelDoor.SetId(const Value: cardinal);
begin
  FId := Value;
end;

procedure TGameLevelDoor.SetLinkedDoor(const Value: cardinal);
begin
  FLinkedDoor := Value;
end;

procedure TGameLevelDoor.SetLook(const Value: TGameLevelDoorLook);
begin
  FLook := Value;
end;

procedure TGameLevelDoor.SetRoom(const Value: cardinal);
begin
  FRoom := Value;
end;

procedure TGameLevelDoor.SetX(const Value: cardinal);
begin
  FX := Value;
end;

procedure TGameLevelDoor.SetY(const Value: cardinal);
begin
  FY := Value;
end;

{ TGameLevel }

procedure TGameLevel.Clear;
begin
  FDoors.Clear;
  FRooms.Clear;
  Initialize;
end;

constructor TGameLevel.Create;
begin
  inherited;
  FDoors := TGameLevelDoorList.Create([doOwnsValues]);
  FRooms := TGameLevelRoomList.Create([doOwnsValues]);
  Initialize;
end;

destructor TGameLevel.Destroy;
begin
  FDoors.Free;
  FRooms.Free;
  inherited;
end;

procedure TGameLevel.Initialize;
begin
  FFileName := '';
  FStartX := 0;
  FStartY := 0;
  FStartRoom := 0;
end;

function TGameLevel.LastDoorId: cardinal;
begin
  result := 0;
  for var Value in FDoors.Values do
    if Value.Id > result then
      result := Value.Id;
end;

function TGameLevel.LastRoomId: cardinal;
begin
  result := 0;
  for var Value in FRooms.Values do
    if Value.Id > result then
      result := Value.Id;
end;

procedure TGameLevel.LoadFromFile(const AFilename: string);
var
  fs: TFileStream;
begin
  if tfile.Exists(AFilename) then
  begin
    fs := TFileStream.Create(AFilename, fmInput);
    try
      Clear;
      LoadFromStream(fs);
      // TODO : ajouter le déchiffrement du fichier
    finally
      fs.Free;
      FFileName := AFilename;
    end;
  end;
end;

procedure TGameLevel.LoadFromStream(const AStream: TStream);
begin
  // TODO : ajouter la vérification de l'un identifiant de fichier
  // TODO : ajouter la vérification du numéro de version de cette classe
  if (AStream.Read(FStartX, sizeof(FStartX)) <> sizeof(FStartX)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FStartY, sizeof(FStartY)) <> sizeof(FStartY)) then
    raise exception.Create('Wrong file format !');

  if (AStream.Read(FStartRoom, sizeof(FStartRoom)) <> sizeof(FStartRoom)) then
    raise exception.Create('Wrong file format !');

  FDoors.LoadFromStream(AStream);
  FRooms.LoadFromStream(AStream);
end;

procedure TGameLevel.SaveToFile(const AFilename: string);
var
  LFileName: string;
  fs: TFileStream;
begin
  if AFilename.IsEmpty then
  begin
    if FFileName.IsEmpty then
      raise exception.Create('Empty file name.')
    else
      LFileName := FFileName;
  end
  else
    LFileName := AFilename;

  fs := TFileStream.Create(LFileName, fmOutput);
  try
    // TODO : ajouter le chiffrement du fichier
    SaveToStream(fs);
  finally
    fs.Free;
    FFileName := LFileName;
  end;
end;

procedure TGameLevel.SaveToStream(const AStream: TStream);
begin
  // TODO : ajouter un identifiant de fichier
  // TODO : ajouter un numéro de version pour cette classe
  AStream.Write(FStartX, sizeof(FStartX));
  AStream.Write(FStartY, sizeof(FStartY));
  AStream.Write(FStartRoom, sizeof(FStartRoom));
  FDoors.SaveToStream(AStream);
  FRooms.SaveToStream(AStream);
end;

procedure TGameLevel.SetDoors(const Value: TGameLevelDoorList);
begin
  FDoors := Value;
end;

procedure TGameLevel.SetRooms(const Value: TGameLevelRoomList);
begin
  FRooms := Value;
end;

procedure TGameLevel.SetStartRoom(const Value: cardinal);
begin
  FStartRoom := Value;
end;

procedure TGameLevel.SetStartX(const Value: cardinal);
begin
  FStartX := Value;
end;

procedure TGameLevel.SetStartY(const Value: cardinal);
begin
  FStartY := Value;
end;

{ TGameLevelDoorList }

procedure TGameLevelDoorList.LoadFromStream(const AStream: TStream);
var
  nb, i: cardinal;
  item: TGameLevelDoor;
begin
  // TODO : ajouter la vérification du numéro de version de cette classe
  if (AStream.Read(nb, sizeof(nb)) <> sizeof(nb)) then
    raise exception.Create('Wrong file format !');
  for i := 0 to nb - 1 do
  begin
    item := TGameLevelDoor.Create;
    item.LoadFromStream(AStream);
    add(item.Id, item);
  end;
end;

procedure TGameLevelDoorList.SaveToStream(const AStream: TStream);
var
  nb, i: cardinal;
begin
  // TODO : ajouter un numéro de version pour cette classe
  nb := count;
  write(nb, sizeof(nb));
  for i := 0 to nb - 1 do
    items[i].SaveToStream(AStream);
end;

{ TGameLevelRoomList }

procedure TGameLevelRoomList.LoadFromStream(const AStream: TStream);
var
  nb, i: cardinal;
  item: TGameLevelRoom;
begin
  // TODO : ajouter la vérification du numéro de version de cette classe
  if (AStream.Read(nb, sizeof(nb)) <> sizeof(nb)) then
    raise exception.Create('Wrong file format !');
  for i := 0 to nb - 1 do
  begin
    item := TGameLevelRoom.Create;
    item.LoadFromStream(AStream);
    add(item.Id, item);
  end;
end;

procedure TGameLevelRoomList.SaveToStream(const AStream: TStream);
var
  nb, i: cardinal;
begin
  // TODO : ajouter un numéro de version pour cette classe
  nb := count;
  write(nb, sizeof(nb));
  for i := 0 to nb - 1 do
    items[i].SaveToStream(AStream);
end;

{ TGameLevelPlatformList }

procedure TGameLevelPlatformList.LoadFromStream(const AStream: TStream);
var
  nb, i: cardinal;
  item: TGameLevelPlatform;
begin
  // TODO : ajouter la vérification du numéro de version de cette classe
  if (AStream.Read(nb, sizeof(nb)) <> sizeof(nb)) then
    raise exception.Create('Wrong file format !');
  for i := 0 to nb - 1 do
  begin
    item := TGameLevelPlatform.Create;
    item.LoadFromStream(AStream);
    add(item);
  end;
end;

procedure TGameLevelPlatformList.SaveToStream(const AStream: TStream);
var
  nb, i: cardinal;
begin
  // TODO : ajouter un numéro de version pour cette classe
  nb := count;
  write(nb, sizeof(nb));
  for i := 0 to nb - 1 do
    items[i].SaveToStream(AStream);
end;

end.
