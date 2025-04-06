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
  private
    FSelectedSprite: TSprite;
    FSelectedGlowEffect: TGlowEffect;
  protected
    DragStartX, DragStartY: Single;
    procedure CalcBottomPanelHeight;
    procedure FillBottomPanel;
    /// <summary>
    /// Click on elements in the bottom panel
    /// </summary>
    procedure SelectSprite(Sender: TObject);
    procedure ItemMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
  public
    procedure AddItemToRoom(const Source: TSprite; const X, Y: Single);
    procedure AddDoor(const Parent: TFMXObject; const Look: TGameLevelDoorLook;
      const IsInRoom: boolean = false; const X: Single = 0;
      const Y: Single = 0);
    procedure AddPlatform(const Parent: TFMXObject;
      const Look: TGameLevelPlatformLook; const IsInRoom: boolean = false;
      const X: Single = 0; const Y: Single = 0);
    procedure AddPlayer(const Parent: TFMXObject;
      const IsInRoom: boolean = false; const X: Single = 0;
      const Y: Single = 0);
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

procedure TfrmMain.AddDoor(const Parent: TFMXObject;
  const Look: TGameLevelDoorLook; const IsInRoom: boolean; const X, Y: Single);
var
  Sprite: TDoorSprite;
begin
  Sprite := TDoorSprite.Create(self);
  Sprite.BeginUpdate;
  try
    Sprite.Margins.Bottom := 5;
    Sprite.Margins.right := 5;
    Sprite.Look := Look;
    Sprite.Position.X := X;
    Sprite.Position.Y := Y;
    if IsInRoom then
    begin
      Sprite.Direction := TGameLevelDoorDirection.back;
      Sprite.DragMode := TDragMode.dmAutomatic;
      Sprite.OnMouseMove := ItemMouseMove;
    end
    else
    begin
      Sprite.Direction := TGameLevelDoorDirection.none;
      Sprite.DragMode := TDragMode.dmManual;
      Sprite.onclick := SelectSprite;
    end;
    Sprite.Parent := Parent;
  finally
    Sprite.EndUpdate;
  end;
end;

procedure TfrmMain.AddItemToRoom(const Source: TSprite; const X, Y: Single);
begin
  if Source is TDoorSprite then
    AddDoor(sbRoom, (Source as TDoorSprite).Look, true, X, Y)
  else if Source is TPlatformSprite then
    AddPlatform(sbRoom, (Source as TPlatformSprite).Look, true, X, Y)
  else if Source is TPlayerSprite then
    AddPlayer(sbRoom, true, X, Y)
  else
    raise Exception.Create('Unknown sprite type.');
end;

procedure TfrmMain.AddPlatform(const Parent: TFMXObject;
  const Look: TGameLevelPlatformLook; const IsInRoom: boolean;
  const X, Y: Single);
var
  Sprite: TPlatformSprite;
begin
  Sprite := TPlatformSprite.Create(self);
  Sprite.BeginUpdate;
  try
    Sprite.Margins.Bottom := 5;
    Sprite.Margins.right := 5;
    Sprite.Look := Look;
    Sprite.Position.X := X;
    Sprite.Position.Y := Y;
    if IsInRoom then
    begin
      Sprite.DragMode := TDragMode.dmAutomatic;
      Sprite.OnMouseMove := ItemMouseMove;
      sprite.NbBloc := random(10);
    end
    else
    begin
      Sprite.DragMode := TDragMode.dmManual;
      Sprite.onclick := SelectSprite;
    end;
    Sprite.Parent := Parent;
  finally
    Sprite.EndUpdate;
  end;
end;

procedure TfrmMain.AddPlayer(const Parent: TFMXObject; const IsInRoom: boolean;
  const X, Y: Single);
var
  Sprite: TPlayerSprite;
begin
  Sprite := TPlayerSprite.Create(self);
  Sprite.BeginUpdate;
  try
    Sprite.Margins.Bottom := 5;
    Sprite.Margins.right := 5;
    Sprite.Position.X := X;
    Sprite.Position.Y := Y;
    if IsInRoom then
    begin
      Sprite.DragMode := TDragMode.dmAutomatic;
      Sprite.OnMouseMove := ItemMouseMove;
    end
    else
    begin
      Sprite.DragMode := TDragMode.dmManual;
      Sprite.onclick := SelectSprite;
    end;
    Sprite.Parent := Parent;
  finally
    Sprite.EndUpdate;
  end;
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

  CalcBottomPanelHeight;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FSelectedSprite := nil;
  FSelectedGlowEffect := TGlowEffect.Create(self);

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
      Source.Position.X := Point.X + Dest.ViewportPosition.X - DragStartX;
      Source.Position.Y := Point.Y + Dest.ViewportPosition.Y - DragStartY;
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
begin
  if assigned(Sender) and (Sender is TScrollBox) then
    Dest := Sender as TScrollBox
  else
    exit;

  if not assigned(FSelectedSprite) then
    exit;

  AddItemToRoom(FSelectedSprite, X + Dest.ViewportPosition.X - DragStartX,
    Y + Dest.ViewportPosition.Y - DragStartY);
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

end.
