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
  uGameLevel,
  FMX.ListBox,
  FMX.Edit;

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
    pnlDoors: TPanel;
    lblDoors: TLabel;
    pnlPlatforms: TPanel;
    lblPlatforms: TLabel;
    gplPlatforms: TGridPanelLayout;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    lblPlatformNbBlocks: TLabel;
    lblPlatformLeftBlock: TLabel;
    lblPlatformRightBlock: TLabel;
    edtPlatformNbBlocks: TEdit;
    rbPlatformLeftBloc: TRadioButton;
    rbPlatformLeftCliff: TRadioButton;
    rbPlatformRightBloc: TRadioButton;
    rbPlatformRightCliff: TRadioButton;
    GridPanelLayout3: TGridPanelLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    lblDoorDirection: TLabel;
    lblDoorLinked: TLabel;
    cbDoorLinkedDoor: TComboBox;
    rbDoorDirectionFront: TRadioButton;
    rbDoorDirectionBack: TRadioButton;
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
    procedure edtPlatformNbBlocksChange(Sender: TObject);
    procedure rbPlatformLeftBlocChange(Sender: TObject);
    procedure rbPlatformLeftCliffChange(Sender: TObject);
    procedure rbPlatformRightBlocChange(Sender: TObject);
    procedure rbPlatformRightCliffChange(Sender: TObject);
    procedure rbDoorDirectionFrontChange(Sender: TObject);
    procedure rbDoorDirectionBackChange(Sender: TObject);
    procedure cbDoorLinkedDoorChange(Sender: TObject);
  private
    FSelectedSprite: TSprite;
    FSelectedGlowEffect: TGlowEffect;
    FCurrentRoom: TGameLevelRoom;
    BlocCbDoorChange: boolean;
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
    procedure ClickOnSpriteInfoButton(Sender: TObject);
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
    procedure HideToolBarPanels;
    procedure AddARoom;
    procedure ShowPanelDoor(const ADoor: TDoorSprite);
    procedure ShowPanelPlatform(const APlatform: TPlatformSprite);
    procedure AddInfoButton(const AParent: TSprite);
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
      AddInfoButton(Result);
    end
    else
    begin
      Result.Direction := TGameLevelDoorDirection.none;
      Result.DragMode := TDragMode.dmManual;
      Result.OnClick := SelectSprite;
      Result.Margins.Bottom := 5;
      Result.Margins.right := 5;
    end;
    Result.Parent := Parent;
  finally
    Result.EndUpdate;
  end;
end;

procedure TfrmMain.AddInfoButton(const AParent: TSprite);
var
  btn: TButton;
begin
  btn := TButton.Create(self);
  btn.width := 20;
  btn.Height := 20;
  btn.Text := '?';
  btn.OnClick := ClickOnSpriteInfoButton;
  btn.Anchors := [TAnchorKind.akRight, TAnchorKind.akTop];
  btn.Position.X := -btn.width;
  btn.Position.Y := 0;
  btn.TagObject := AParent;
  btn.Parent := AParent;
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
      Result.OnClick := SelectSprite;
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
      AddInfoButton(Result);
    end
    else
    begin
      Result.DragMode := TDragMode.dmManual;
      Result.OnClick := SelectSprite;
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
  // TODO : lors de l'ajout s'assurer qu'un player n'est pas déjà sur le même salle et le masque (ou le déplacer) si c'est le cas
  Result := TPlayerSprite.Create(self, nil);
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
      Result.OnClick := SelectSprite;
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
      if H < C.Position.Y + C.Height + C.Margins.Bottom then
        H := C.Position.Y + C.Height + C.Margins.Bottom;
    end;
  flBottom.Height := H;
end;

procedure TfrmMain.cbDoorLinkedDoorChange(Sender: TObject);
var
  CurDoor, Door: TGameLevelDoor;
  OldLinkId, NewLinkId: cardinal;
begin
  if BlocCbDoorChange then
    exit;

  if not assigned(pnlDoors.TagObject) then
    exit;
  if not(pnlDoors.TagObject is TDoorSprite) then
    exit;
  if not assigned((pnlDoors.TagObject as TDoorSprite).GameLevelControl) then
    exit;
  if not((pnlDoors.TagObject as TDoorSprite).GameLevelControl is TGameLevelDoor)
  then
    exit;

  CurDoor := (pnlDoors.TagObject as TDoorSprite)
    .GameLevelControl as TGameLevelDoor;

  OldLinkId := ((pnlDoors.TagObject as TDoorSprite)
    .GameLevelControl as TGameLevelDoor).LinkedDoor;

  if (cbDoorLinkedDoor.ItemIndex >= 0) and
    assigned(cbDoorLinkedDoor.ListItems[cbDoorLinkedDoor.ItemIndex].TagObject)
    and (cbDoorLinkedDoor.ListItems[cbDoorLinkedDoor.ItemIndex]
    .TagObject is TGameLevelDoor) then
    NewLinkId := (cbDoorLinkedDoor.ListItems[cbDoorLinkedDoor.ItemIndex]
      .TagObject as TGameLevelDoor).id
  else
    NewLinkId := 0;

  if NewLinkId = OldLinkId then
    exit;

  // Old linked door from our door
  if CurrentGameLevel.Doors.TryGetValue(OldLinkId, Door) then
    Door.LinkedDoor := 0;

  if CurrentGameLevel.Doors.TryGetValue(NewLinkId, Door) then
  begin
    OldLinkId := Door.LinkedDoor;
    Door.LinkedDoor := CurDoor.id;
  end
  else
    exit;

  CurDoor.LinkedDoor := Door.id;

  // Old linked door from new linked door
  if CurrentGameLevel.Doors.TryGetValue(OldLinkId, Door) then
    Door.LinkedDoor := 0;
end;

procedure TfrmMain.edtPlatformNbBlocksChange(Sender: TObject);
var
  nb: integer;
begin
  try
    nb := edtPlatformNbBlocks.Text.ToInteger;
    if (nb > 0) and (nb < 50) and assigned(pnlPlatforms.TagObject) and
      (pnlPlatforms.TagObject is TPlatformSprite) then
      (pnlPlatforms.TagObject as TPlatformSprite).NbBloc := nb;
  except
  end;
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
  BlocCbDoorChange := false;

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
        Height := 1;
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

procedure TfrmMain.HideToolBarPanels;
begin
  pnlDoors.Visible := false;
  pnlPlatforms.Visible := false;
end;

procedure TfrmMain.ItemMouseMove(Sender: TObject; Shift: TShiftState;
X, Y: Single);
begin
  DragStartX := X;
  DragStartY := Y;
end;

procedure TfrmMain.rbDoorDirectionBackChange(Sender: TObject);
begin
  if rbDoorDirectionBack.IsChecked and assigned(pnlDoors.TagObject) and
    (pnlDoors.TagObject is TDoorSprite) then
    (pnlDoors.TagObject as TDoorSprite).Direction :=
      TGameLevelDoorDirection.back;
end;

procedure TfrmMain.rbDoorDirectionFrontChange(Sender: TObject);
begin
  if rbDoorDirectionFront.IsChecked and assigned(pnlDoors.TagObject) and
    (pnlDoors.TagObject is TDoorSprite) then
    (pnlDoors.TagObject as TDoorSprite).Direction :=
      TGameLevelDoorDirection.Front;
end;

procedure TfrmMain.rbPlatformLeftBlocChange(Sender: TObject);
begin
  if rbPlatformLeftBloc.IsChecked and assigned(pnlPlatforms.TagObject) and
    (pnlPlatforms.TagObject is TPlatformSprite) then
    (pnlPlatforms.TagObject as TPlatformSprite).LeftBlocType :=
      TGameLevelPlatformEndType.Bloc;
end;

procedure TfrmMain.rbPlatformLeftCliffChange(Sender: TObject);
begin
  if rbPlatformLeftCliff.IsChecked and assigned(pnlPlatforms.TagObject) and
    (pnlPlatforms.TagObject is TPlatformSprite) then
    (pnlPlatforms.TagObject as TPlatformSprite).LeftBlocType :=
      TGameLevelPlatformEndType.Cliff;
end;

procedure TfrmMain.rbPlatformRightBlocChange(Sender: TObject);
begin
  if rbPlatformRightBloc.IsChecked and assigned(pnlPlatforms.TagObject) and
    (pnlPlatforms.TagObject is TPlatformSprite) then
    (pnlPlatforms.TagObject as TPlatformSprite).RightBlocType :=
      TGameLevelPlatformEndType.Bloc;
end;

procedure TfrmMain.rbPlatformRightCliffChange(Sender: TObject);
begin
  if rbPlatformRightCliff.IsChecked and assigned(pnlPlatforms.TagObject) and
    (pnlPlatforms.TagObject is TPlatformSprite) then
    (pnlPlatforms.TagObject as TPlatformSprite).RightBlocType :=
      TGameLevelPlatformEndType.Cliff;
end;

procedure TfrmMain.ClickOnSpriteInfoButton(Sender: TObject);
var
  btn: TButton;
  obj: TObject;
begin
  if (Sender is TButton) then
  begin
    btn := Sender as TButton;
    if assigned(btn.TagObject) and (btn.TagObject is TSprite) then
    begin
      obj := btn.TagObject;
      if (obj is TPlatformSprite) then
        ShowPanelPlatform(obj as TPlatformSprite)
      else if (obj is TDoorSprite) then
        ShowPanelDoor(obj as TDoorSprite);
    end;
  end;
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
    AddPlayer(sbRoom, true, LX, LY)
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
  HideToolBarPanels;

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

procedure TfrmMain.ShowPanelDoor(const ADoor: TDoorSprite);
var
  item: TListBoxItem;
  glDoor: TGameLevelDoor;
begin
  HideToolBarPanels;
  lblDoors.Text := 'Door ' + CurrentRoom.id.ToString + '-' + ADoor.id.ToString;
  pnlDoors.TagObject := ADoor;

  rbDoorDirectionFront.IsChecked :=
    (ADoor.Direction in [TGameLevelDoorDirection.Front,
    TGameLevelDoorDirection.none]);
  rbDoorDirectionBack.IsChecked :=
    (ADoor.Direction = TGameLevelDoorDirection.back);

  if assigned(ADoor.GameLevelControl) and
    (ADoor.GameLevelControl is TGameLevelDoor) then
    glDoor := ADoor.GameLevelControl as TGameLevelDoor
  else
    glDoor := nil;

  // TODO : pouvoir détacher une porte sans l'attacher à autre chose (ou pouvoir la désactiver)
  BlocCbDoorChange := true;
  try
    cbDoorLinkedDoor.Items.Clear;
    for var Value in CurrentGameLevel.Doors.Values do
      if Value <> glDoor then
      begin
        item := TListBoxItem.Create(self);
        item.Text := Value.Room.ToString + '-' + Value.id.ToString;
        item.TagObject := Value;
        cbDoorLinkedDoor.AddObject(item);
        if (Value.id = glDoor.LinkedDoor) then
          cbDoorLinkedDoor.ItemIndex := item.Index;
      end;
  finally
    BlocCbDoorChange := false;
  end;

  pnlDoors.Visible := true;
end;

procedure TfrmMain.ShowPanelPlatform(const APlatform: TPlatformSprite);
begin
  HideToolBarPanels;
  lblPlatforms.Text := 'Platform';
  pnlPlatforms.TagObject := APlatform;
  edtPlatformNbBlocks.Text := APlatform.NbBloc.ToString;

  rbPlatformLeftBloc.IsChecked :=
    (APlatform.LeftBlocType in [TGameLevelPlatformEndType.Bloc,
    TGameLevelPlatformEndType.none]);
  rbPlatformLeftCliff.IsChecked :=
    (APlatform.LeftBlocType = TGameLevelPlatformEndType.Cliff);
  rbPlatformRightBloc.IsChecked :=
    (APlatform.RightBlocType in [TGameLevelPlatformEndType.Bloc,
    TGameLevelPlatformEndType.none]);
  rbPlatformRightCliff.IsChecked :=
    (APlatform.RightBlocType = TGameLevelPlatformEndType.Cliff);
  pnlPlatforms.Visible := true;
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
