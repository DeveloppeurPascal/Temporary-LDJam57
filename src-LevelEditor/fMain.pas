unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Objects,
  FMX.Effects,
  uSprites,
  uGameLevel;

type
  TfrmMain = class(TForm)
    lTop: TLayout;
    pnlRooms: TPanel;
    lblRooms: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    GridPanelLayout2: TGridPanelLayout;
    btnAddRoom: TButton;
    btnDeleteRoom: TButton;
    btnPrevRoom: TButton;
    lblRoomId: TLabel;
    btnNetxRoom: TButton;
    gplSaveClose: TGridPanelLayout;
    btnSave: TButton;
    btnTest: TButton;
    flBottom: TFlowLayout;
    BackgroundWall: TRectangle;
    sbRoom: TScrollBox;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbRoomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure RoomDragDrop(Sender: TObject; const Data: TDragObject;
      const Point: TPointF);
    procedure RoomDragOver(Sender: TObject; const Data: TDragObject;
      const Point: TPointF; var Operation: TDragOperation);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddRoomClick(Sender: TObject);
    procedure btnDeleteRoomClick(Sender: TObject);
    procedure btnPrevRoomClick(Sender: TObject);
    procedure btnNetxRoomClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    FSelectedSprite: TSprite;
    FSelectedGlowEffect: TGlowEffect;
    FCurrentRoom: TGameLevelRoom;
    procedure SetCurrentRoom(const Value: TGameLevelRoom);
  protected
    DragStartX, DragStartY: Single;
    CurrentGameLevel: TGameLevel;
    property CurrentRoom: TGameLevelRoom read FCurrentRoom write SetCurrentRoom;
    procedure CalcBottomPanelHeight;
    procedure FillBottomPanel;
    /// <summary>
    /// Click on elements in the bottom panel
    /// </summary>
    procedure SelectSprite(Sender: TObject);
    procedure ItemMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
  public
    function AddDoor(const Parent: TFMXObject; const Look: TGameLevelDoorLook;
      const IsInRoom: boolean = false; const X: Single = 0; const Y: Single = 0;
      const GameLevelDoor: TGameLevelDoor = nil): TDoorSprite;
    function AddPlatform(const Parent: TFMXObject;
      const Look: TGameLevelPlatformLook; const IsInRoom: boolean = false;
      const X: Single = 0; const Y: Single = 0;
      const GameLevelPlatform: TGameLevelPlatform = nil): TPlatformSprite;
    function AddPlayer(const Parent: TFMXObject;
      const IsInRoom: boolean = false; const X: Single = 0; const Y: Single = 0)
      : TPlayerSprite;
    function AddItem(const Parent: TFMXObject;
      const ItemType: TGameLevelItemType; const IsInRoom: boolean = false;
      const X: Single = 0; const Y: Single = 0;
      const GameLevelItem: TGameLevelItem = nil): TItemSprite;
    procedure ShowCurrentRoom;
    procedure AddARoom;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  USVGCharacters,
  USVGWall,
  Olf.Skia.SVGToBitmap,
  uSVGBitmapManager_InputPrompts,
  USVGPlatformerAssetsBase;

procedure TfrmMain.AddARoom;
begin
  CurrentRoom := CurrentGameLevel.Rooms.GetNewRoom;
end;

function TfrmMain.AddDoor(const Parent: TFMXObject;
  const Look: TGameLevelDoorLook; const IsInRoom: boolean; const X, Y: Single;
  const GameLevelDoor: TGameLevelDoor): TDoorSprite;
begin
  if assigned(GameLevelDoor) then
    GameLevelDoor.Room := CurrentRoom.id;

  Result := TDoorSprite.Create(self, GameLevelDoor);
  Result.BeginUpdate;
  try
    Result.Look := Look;
    Result.X := X;
    Result.Y := Y;
    if IsInRoom then
    begin
      Result.Direction := TGameLevelDoorDirection.back;
      Result.DragMode := TDragMode.dmAutomatic;
      Result.OnMouseMove := ItemMouseMove;
    end
    else
    begin
      Result.Direction := TGameLevelDoorDirection.none;
      Result.DragMode := TDragMode.dmManual;
      Result.onclick := SelectSprite;
      Result.Margins.Bottom := 5;
      Result.Margins.right := 5;
    end;
    Result.Parent := Parent;
  finally
    Result.EndUpdate;
  end;
end;

function TfrmMain.AddItem(const Parent: TFMXObject;
  const ItemType: TGameLevelItemType; const IsInRoom: boolean;
  const X, Y: Single; const GameLevelItem: TGameLevelItem): TItemSprite;
begin
  Result := TItemSprite.Create(self, GameLevelItem);
  Result.BeginUpdate;
  try
    Result.ItemType := ItemType;
    Result.X := X;
    Result.Y := Y;
    if IsInRoom then
    begin
      Result.DragMode := TDragMode.dmAutomatic;
      Result.OnMouseMove := ItemMouseMove;
    end
    else
    begin
      Result.DragMode := TDragMode.dmManual;
      Result.onclick := SelectSprite;
      Result.Margins.Bottom := 5;
      Result.Margins.right := 5;
    end;
    Result.Parent := Parent;
  finally
    Result.EndUpdate;
  end;
end;

function TfrmMain.AddPlatform(const Parent: TFMXObject;
  const Look: TGameLevelPlatformLook; const IsInRoom: boolean;
  const X, Y: Single; const GameLevelPlatform: TGameLevelPlatform)
  : TPlatformSprite;
begin
  Result := TPlatformSprite.Create(self, GameLevelPlatform);
  Result.BeginUpdate;
  try
    Result.Look := Look;
    Result.X := X;
    Result.Y := Y;
    if IsInRoom then
    begin
      Result.DragMode := TDragMode.dmAutomatic;
      Result.OnMouseMove := ItemMouseMove;
    end
    else
    begin
      Result.DragMode := TDragMode.dmManual;
      Result.onclick := SelectSprite;
      Result.Margins.Bottom := 5;
      Result.Margins.right := 5;
    end;
    Result.Parent := Parent;
  finally
    Result.EndUpdate;
  end;
end;

function TfrmMain.AddPlayer(const Parent: TFMXObject; const IsInRoom: boolean;
  const X, Y: Single): TPlayerSprite;
begin
  Result := TPlayerSprite.Create(self, nil); // TODO PP
  Result.BeginUpdate;
  try
    Result.X := X;
    Result.Y := Y;
    if IsInRoom then
    begin
      Result.DragMode := TDragMode.dmAutomatic;
      Result.OnMouseMove := ItemMouseMove;
      CurrentGameLevel.StartX := X;
      CurrentGameLevel.StartY := Y;
      CurrentGameLevel.StartRoom := CurrentRoom.id;
    end
    else
    begin
      Result.DragMode := TDragMode.dmManual;
      Result.onclick := SelectSprite;
      Result.Margins.Bottom := 5;
      Result.Margins.right := 5;
    end;
    Result.Parent := Parent;
  finally
    Result.EndUpdate;
  end;
end;

procedure TfrmMain.btnAddRoomClick(Sender: TObject);
begin
  AddARoom;
end;

procedure TfrmMain.btnDeleteRoomClick(Sender: TObject);
begin
  ShowMessage('not implemented');
  // TODO : à compléter
end;

procedure TfrmMain.btnNetxRoomClick(Sender: TObject);
var
  NewRoomId: cardinal;
  Room: TGameLevelRoom;
begin
  if not assigned(CurrentGameLevel) then
    exit;

  NewRoomId := high(cardinal);
  for Room in CurrentGameLevel.Rooms.Values do
    if (Room.id > CurrentRoom.id) and (Room.id < NewRoomId) then
      NewRoomId := Room.id;

  if (NewRoomId < high(cardinal)) and CurrentGameLevel.Rooms.TryGetValue
    (NewRoomId, Room) then
    CurrentRoom := Room;
end;

procedure TfrmMain.btnPrevRoomClick(Sender: TObject);
var
  NewRoomId: cardinal;
  Room: TGameLevelRoom;
begin
  if not assigned(CurrentGameLevel) then
    exit;

  NewRoomId := 0;
  for Room in CurrentGameLevel.Rooms.Values do
    if (Room.id < CurrentRoom.id) and (Room.id > NewRoomId) then
      NewRoomId := Room.id;

  if (NewRoomId > 0) and CurrentGameLevel.Rooms.TryGetValue(NewRoomId, Room)
  then
    CurrentRoom := Room;
end;

procedure TfrmMain.btnSaveClick(Sender: TObject);
begin
  if not assigned(CurrentGameLevel) then
    exit;

  CurrentGameLevel.SaveToFile(CDefaultLevelFilePath);
  ShowMessage('Game level saved');
end;

procedure TfrmMain.CalcBottomPanelHeight;
var
  I: integer;
  H: Single;
  C: tControl;
begin
  H := 10;
  for I := 0 to flBottom.ChildrenCount - 1 do
    if (flBottom.Children[I] is tControl) then
    begin
      C := flBottom.Children[I] as tControl;
      if H < C.Position.Y + C.height + C.Margins.Bottom then
        H := C.Position.Y + C.height + C.Margins.Bottom;
    end;
  flBottom.height := H;
end;

procedure TfrmMain.FillBottomPanel;
begin
  while flBottom.ChildrenCount > 0 do
    flBottom.Children[0].Free;

  // Doors
  AddDoor(flBottom, TGameLevelDoorLook.BrownUsed);
  AddDoor(flBottom, TGameLevelDoorLook.Brown);
  AddDoor(flBottom, TGameLevelDoorLook.GreyUsed);
  AddDoor(flBottom, TGameLevelDoorLook.Grey);

  // Platforms
  AddPlatform(flBottom, TGameLevelPlatformLook.Castle);
  AddPlatform(flBottom, TGameLevelPlatformLook.Dirt);
  AddPlatform(flBottom, TGameLevelPlatformLook.Grass);
  AddPlatform(flBottom, TGameLevelPlatformLook.Sand);
  AddPlatform(flBottom, TGameLevelPlatformLook.Snow);
  AddPlatform(flBottom, TGameLevelPlatformLook.Stone);

  // Player
  AddPlayer(flBottom);

  // "dead" items
  AddItem(flBottom, TGameLevelItemType.CoinBronze);
  AddItem(flBottom, TGameLevelItemType.CoinArgent);
  AddItem(flBottom, TGameLevelItemType.CoinGold);

  CalcBottomPanelHeight;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FSelectedSprite := nil;
  FSelectedGlowEffect := TGlowEffect.Create(self);
  CurrentGameLevel := TGameLevel.Create;
  CurrentRoom := nil;

  // Draw the screen (background + selector panel)
  tthread.ForceQueue(nil,
    procedure
    begin
      FillBottomPanel;
      BackgroundWall.fill.bitmap.bitmap.assign
        (getBitmapFromSVG(TSVGWallIndex.WallChoco, CDefaultSpriteSize,
        CDefaultSpriteSize, GetBitmapScale));
      with TRectangle.Create(self) do
      begin
        width := 1;
        height := 1;
        Position.X := 10000;
        Position.Y := 10000;
        Parent := sbRoom;
      end;
    end);

  // Load default game level and show it
  tthread.ForceQueue(nil,
    procedure
    var
      Room: TGameLevelRoom;
    begin
      CurrentGameLevel.LoadFromFile(CDefaultLevelFilePath);
      if CurrentGameLevel.Rooms.Count < 1 then
        AddARoom
      else if CurrentGameLevel.Rooms.TryGetValue(CurrentGameLevel.StartRoom,
        Room) then
        CurrentRoom := Room
      else if CurrentGameLevel.Rooms.TryGetValue
        (CurrentGameLevel.Rooms.LastRoomId, Room) then
        CurrentRoom := Room
      else
        raise Exception.Create('No room to show !');
    end);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  CurrentGameLevel.Free;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  CalcBottomPanelHeight;
end;

procedure TfrmMain.ItemMouseMove(Sender: TObject; Shift: TShiftState;
X, Y: Single);
begin
  DragStartX := X;
  DragStartY := Y;
end;

procedure TfrmMain.RoomDragDrop(Sender: TObject; const Data: TDragObject;
const Point: TPointF);
var
  Source: TSprite;
  Dest: TScrollBox;
begin
  if (Data.Source is TSprite) and assigned(Sender) and (Sender is TScrollBox)
  then
  begin
    Source := Data.Source as TSprite;
    Dest := Sender as TScrollBox;
    Source.BeginUpdate;
    try
      Source.X := Point.X + Dest.ViewportPosition.X - DragStartX;
      Source.Y := Point.Y + Dest.ViewportPosition.Y - DragStartY;
      if Source is TPlayerSprite then
      begin
        CurrentGameLevel.StartX := Source.X;
        CurrentGameLevel.StartY := Source.Y;
        CurrentGameLevel.StartRoom := CurrentRoom.id;
      end;
    finally
      Source.EndUpdate;
    end;
  end;
end;

procedure TfrmMain.RoomDragOver(Sender: TObject; const Data: TDragObject;
const Point: TPointF; var Operation: TDragOperation);
begin
  Operation := TDragOperation.none;
  if (Data.Source is TSprite) then
    Operation := TDragOperation.move;
end;

procedure TfrmMain.sbRoomMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
var
  Dest: TScrollBox;
  LX, LY: Single;
begin
  if assigned(Sender) and (Sender is TScrollBox) then
    Dest := Sender as TScrollBox
  else
    exit;

  if not assigned(FSelectedSprite) then
    exit;

  LX := X + Dest.ViewportPosition.X - DragStartX;
  LY := Y + Dest.ViewportPosition.Y - DragStartY;

  if FSelectedSprite is TDoorSprite then
    AddDoor(sbRoom, (FSelectedSprite as TDoorSprite).Look, true, LX, LY,
      CurrentGameLevel.Doors.GetNewDoor)
  else if FSelectedSprite is TPlatformSprite then
    AddPlatform(sbRoom, (FSelectedSprite as TPlatformSprite).Look, true, LX, LY,
      CurrentRoom.Platforms.GetNewPlatform)
  else if FSelectedSprite is TPlayerSprite then
    AddPlayer(sbRoom, true, LX, LY) // TODOPP
  else if FSelectedSprite is TItemSprite then
    AddItem(sbRoom, (FSelectedSprite as TItemSprite).ItemType, true, LX, LY,
      CurrentRoom.Items.GetNewItem)
  else
    raise Exception.Create('Unknown sprite type.');
end;

procedure TfrmMain.SelectSprite(Sender: TObject);
var
  Sprite: TSprite;
begin
  if assigned(Sender) and (Sender is TSprite) then
  begin
    Sprite := Sender as TSprite;
    if (FSelectedSprite = Sprite) then
    begin
      FSelectedGlowEffect.enabled := false;
      FSelectedSprite := nil;
    end
    else
    begin
      FSelectedGlowEffect.Parent := Sprite;
      FSelectedGlowEffect.enabled := true;
      FSelectedSprite := Sprite;
    end;
  end;
end;

procedure TfrmMain.SetCurrentRoom(const Value: TGameLevelRoom);
begin
  if not assigned(CurrentGameLevel) then
    exit;

  FCurrentRoom := Value;
  ShowCurrentRoom;
end;

procedure TfrmMain.ShowCurrentRoom;
var
  I: integer;
begin
  while sbRoom.Content.ChildrenCount > 0 do
    sbRoom.Content.Children[0].Free;

  if not assigned(CurrentGameLevel) then
    exit;

  if not assigned(CurrentRoom) then
    exit;

  for var Value in CurrentGameLevel.Doors.Values do
    if Value.Room = CurrentRoom.id then
      AddDoor(sbRoom, Value.Look, true, Value.X, Value.Y, Value);

  for I := 0 to CurrentRoom.Platforms.Count - 1 do
    AddPlatform(sbRoom, CurrentRoom.Platforms[I].Look, true,
      CurrentRoom.Platforms[I].X, CurrentRoom.Platforms[I].Y,
      CurrentRoom.Platforms[I]);

  for I := 0 to CurrentRoom.Items.Count - 1 do
    AddItem(sbRoom, CurrentRoom.Items[I].ItemType, true, CurrentRoom.Items[I].X,
      CurrentRoom.Items[I].Y, CurrentRoom.Items[I]);

  if CurrentGameLevel.StartRoom = CurrentRoom.id then
    AddPlayer(sbRoom, true, CurrentGameLevel.StartX, CurrentGameLevel.StartY);

  lblRooms.Text := 'Current room';
  lblRoomId.Text := CurrentRoom.id.ToString;
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
