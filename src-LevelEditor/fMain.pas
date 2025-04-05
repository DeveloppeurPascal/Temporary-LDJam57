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
  FMX.Effects;

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
    Image1: TImage;
    GlowEffect1: TGlowEffect;
    BackgroundWall: TRectangle;
    sbRoom: TScrollBox;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbRoomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    FSelectedItem: integer;
    FSelectedItemWidth, FSelectedItemHeight: Single;
  protected
    procedure CalcBottomPanelHeight;
    procedure FillBottomPanel;
    /// <summary>
    /// Click on elements in the bottom panel
    /// </summary>
    procedure SelectImage(Sender: TObject);
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  uGameLevel,
  USVGCharacters,
  USVGDoors,
  USVGJumperPack,
  USVGPhysicsAssets,
  USVGWall,
  Olf.Skia.SVGToBitmap,
  uSVGBitmapManager_InputPrompts;

{ TForm1 }

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
      if H < C.position.Y + C.height + C.Margins.Bottom then
        H := C.position.Y + C.height + C.Margins.Bottom;
    end;
  flBottom.height := H;
end;

procedure TfrmMain.FillBottomPanel;
  procedure AddImage(const W, H, BitmapScale: Single; const SVGId: integer);
  var
    img: TImage;
  begin
    img := TImage.create(self);
    img.Margins.Bottom := 5;
    img.Margins.right := 5;
    img.onclick := SelectImage;
    img.width := W;
    img.height := H;
    img.tag := SVGId;
    img.bitmap.assign(TOlfSVGBitmapList.bitmap(SVGId, round(W), round(H),
      BitmapScale));
    img.parent := flBottom;
  end;

var
  BitmapScale, W, H: Single;
begin
  while flBottom.ChildrenCount > 0 do
    flBottom.Children[0].Free;

  BitmapScale := Image1.bitmap.BitmapScale;
  W := 50;
  H := 50;

  // Doors
  AddImage(W, H, BitmapScale, TSVGDoors.tag + CSVGDoor10);
  AddImage(W, H, BitmapScale, TSVGDoors.tag + CSVGDoor20);
  AddImage(W, H, BitmapScale, TSVGDoors.tag + CSVGDoor30);
  AddImage(W, H, BitmapScale, TSVGDoors.tag + CSVGDoor40);

  // Platforms
  AddImage(W * 2, H, BitmapScale, TSVGJumperPack.tag + CSVGPlatformGreyLarge);
  AddImage(W * 2, H, BitmapScale, TSVGJumperPack.tag +
    CSVGPlatformGreyLargeBroken);
  AddImage(W, H, BitmapScale, TSVGJumperPack.tag + CSVGPlatformGreyShort);
  AddImage(W, H, BitmapScale, TSVGJumperPack.tag + CSVGPlatformGreyShortBroken);
  AddImage(W * 2, H, BitmapScale, TSVGJumperPack.tag + CSVGPlatformMaroonLarge);
  AddImage(W * 2, H, BitmapScale, TSVGJumperPack.tag +
    CSVGPlatformMaroonLargeBroken);
  AddImage(W, H, BitmapScale, TSVGJumperPack.tag + CSVGPlatformMaroonShort);
  AddImage(W, H, BitmapScale, TSVGJumperPack.tag +
    CSVGPlatformMaroonShortBroken);

  // Player
  AddImage(W, H, BitmapScale, TSVGCharacters.tag + CSVGZombieIdle);

  CalcBottomPanelHeight;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FSelectedItem := -1;

  tthread.ForceQueue(nil,
    procedure
    begin
      FillBottomPanel;
      BackgroundWall.fill.bitmap.bitmap.assign
        (getBitmapFromSVG(TSVGWallIndex.WallChoco, 50, 50,
        Image1.bitmap.BitmapScale));
      with TRectangle.create(self) do
      begin
        width := 1;
        height := 1;
        position.X := 10000;
        position.Y := 10000;
        parent := sbRoom;
      end;
    end);
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  CalcBottomPanelHeight;
end;

procedure TfrmMain.sbRoomMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
var
  img: TImage;
begin
  if FSelectedItem < 0 then
    exit;

  img := TImage.create(self);
  // img.onclick :=
  img.width := FSelectedItemWidth;
  img.height := FSelectedItemHeight;
  img.position.X := X + sbRoom.ViewportPosition.X;
  img.position.Y := Y + sbRoom.ViewportPosition.Y;
  img.bitmap.assign(TOlfSVGBitmapList.bitmap(FSelectedItem, round(img.width),
    round(img.height), Image1.bitmap.BitmapScale));
  img.parent := sbRoom;
end;

procedure TfrmMain.SelectImage(Sender: TObject);
var
  img: TImage;
begin
  if assigned(Sender) and (Sender is TImage) then
    if (FSelectedItem = img.tag) then
    begin
      GlowEffect1.enabled := false;
      FSelectedItem := -1;
    end
    else
    begin
      img := Sender as TImage;
      GlowEffect1.parent := img;
      GlowEffect1.enabled := true;
      FSelectedItem := img.tag;
      FSelectedItemWidth := img.width;
      FSelectedItemHeight := img.height;
    end;
end;

end.
