unit uSprites;

interface

uses
  System.Classes,
  FMX.Objects,
  uGameLevel;

const
  /// <summary>
  /// Default width and height of each sprite
  /// </summary>
  CDefaultSpriteSize = 50;

Type
{$SCOPEDENUMS ON}
  TSprite = class(TImage)
  private
    FGameLevelControl: TGameLevelControl;
    procedure SetGameLevelControl(const Value: TGameLevelControl);
    /// <summary>
    /// Don't call this constructor, use
    /// Create(AOwner: TComponent; const AGameLevelControl: TGameLevelControl)
    /// </summary>
    constructor Create(AOwner: TComponent); overload; override;
    procedure SetX(const Value: Single);
    procedure SetY(const Value: Single);
    function GetX: Single;
    function GetY: Single;
  protected
  public
    property X: Single read GetX write SetX;
    property Y: Single read GetY write SetY;
    property GameLevelControl: TGameLevelControl read FGameLevelControl
      write SetGameLevelControl;
    constructor Create(AOwner: TComponent;
      const AGameLevelControl: TGameLevelControl); overload; virtual;
    procedure RefreshImage; virtual; abstract;
  end;

  TDoorSprite = class(TSprite)
  private
    FLook: TGameLevelDoorLook;
    FDirection: TGameLevelDoorDirection;
    FId: cardinal;
    procedure SetLook(const Value: TGameLevelDoorLook);
    procedure SetDirection(const Value: TGameLevelDoorDirection);
    procedure SetId(const Value: cardinal);
  protected
  public
    property Id: cardinal read FId write SetId;
    property Look: TGameLevelDoorLook read FLook write SetLook;
    property Direction: TGameLevelDoorDirection read FDirection
      write SetDirection;
    constructor Create(AOwner: TComponent;
      const AGameLevelControl: TGameLevelControl); override;
    procedure RefreshImage; override;
  end;

  TPlatformSprite = class(TSprite)
  private
    FNbBloc: cardinal;
    FLeftBlocType: TGameLevelPlatformEndType;
    FLook: TGameLevelPlatformLook;
    FRightBlocType: TGameLevelPlatformEndType;
    procedure SetLeftBlocType(const Value: TGameLevelPlatformEndType);
    procedure SetLook(const Value: TGameLevelPlatformLook);
    procedure SetNbBloc(const Value: cardinal);
    procedure SetRightBlocType(const Value: TGameLevelPlatformEndType);
  protected
  public
    property NbBloc: cardinal read FNbBloc write SetNbBloc;
    property Look: TGameLevelPlatformLook read FLook write SetLook;
    property LeftBlocType: TGameLevelPlatformEndType read FLeftBlocType
      write SetLeftBlocType;
    property RightBlocType: TGameLevelPlatformEndType read FRightBlocType
      write SetRightBlocType;
    constructor Create(AOwner: TComponent;
      const AGameLevelControl: TGameLevelControl); override;
    procedure RefreshImage; override;
  end;

  TCharacterSprite = class(TSprite)
  private
    FLook: TGameLevelCharacterLook;
    procedure SetLook(const Value: TGameLevelCharacterLook);
  protected
  public
    property Look: TGameLevelCharacterLook read FLook write SetLook;
    constructor Create(AOwner: TComponent;
      const AGameLevelControl: TGameLevelControl); override;
    procedure RefreshImage; override;
  end;

  TPlayerSprite = class(TCharacterSprite)
  private
  protected
  public
    procedure AfterConstruction; override;
  end;

  TItemSprite = class(TSprite)
  private
    FItemType: TGameLevelItemType;
    procedure SetItemType(const Value: TGameLevelItemType);
  protected
  public
    property ItemType: TGameLevelItemType read FItemType write SetItemType;
    // TODO : gérer animations
    // TODO : à ramasser ou pas, dangereux ou pas, bloquant ou pas
    constructor Create(AOwner: TComponent;
      const AGameLevelControl: TGameLevelControl); override;
    procedure RefreshImage; override;
  end;

function GetBitmapScale: Single;

implementation

{ TDoorSprite }

uses
  System.Types,
  System.SysUtils,
  Olf.Skia.SVGToBitmap,
  USVGDoors,
  FMX.Platform,
  FMX.Graphics,
  USVGPlatformerAssetsBase,
  USVGCharacters,
  USVGJumperPack;

function GetBitmapScale: Single;
var
  svc: IFMXScreenService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, svc)
  then
    result := svc.GetScreenScale
  else
    result := 1;
end;

constructor TDoorSprite.Create(AOwner: TComponent;
  const AGameLevelControl: TGameLevelControl);
begin
  inherited;
  if assigned(AGameLevelControl) then
  begin
    FLook := (AGameLevelControl as TGameLevelDoor).Look;
    FDirection := (AGameLevelControl as TGameLevelDoor).Direction;
    FId := (AGameLevelControl as TGameLevelDoor).Id;
  end
  else
  begin
    FLook := TGameLevelDoorLook.None;
    FDirection := TGameLevelDoorDirection.Back;
    FId := 0;
  end;
end;

procedure TDoorSprite.RefreshImage;
var
  SVG: integer;
begin
  case FLook of
    TGameLevelDoorLook.None:
      SVG := -1;
    TGameLevelDoorLook.BrownUsed:
      SVG := CSVGDoor10;
    TGameLevelDoorLook.Brown:
      SVG := CSVGDoor20;
    TGameLevelDoorLook.GreyUsed:
      SVG := CSVGDoor30;
    TGameLevelDoorLook.Grey:
      SVG := CSVGDoor40;
  else
    raise Exception.Create('Unknown door look.');
  end;

  BeginUpdate;
  try
    case FDirection of
      TGameLevelDoorDirection.Front:
        opacity := 0.5;
    else
      opacity := 1;
    end;
    WrapMode := TImageWrapMode.Original;
    Bitmap.Assign(TOlfSVGBitmapList.Bitmap(TSVGDoors.tag + SVG,
      CDefaultSpriteSize, CDefaultSpriteSize, GetBitmapScale));
  finally
    EndUpdate;
  end;
end;

procedure TDoorSprite.SetDirection(const Value: TGameLevelDoorDirection);
begin
  FDirection := Value;
  if assigned(FGameLevelControl) then
    (FGameLevelControl as TGameLevelDoor).Direction := FDirection;
  RefreshImage;
end;

procedure TDoorSprite.SetId(const Value: cardinal);
begin
  FId := Value;
  if assigned(FGameLevelControl) then
    (FGameLevelControl as TGameLevelDoor).Id := FId;
end;

procedure TDoorSprite.SetLook(const Value: TGameLevelDoorLook);
begin
  FLook := Value;
  if assigned(FGameLevelControl) then
    (FGameLevelControl as TGameLevelDoor).Look := FLook;
  RefreshImage;
end;

{ TPlatformSprite }

constructor TPlatformSprite.Create(AOwner: TComponent;
  const AGameLevelControl: TGameLevelControl);
begin
  inherited;
  if assigned(AGameLevelControl) then
  begin
    FNbBloc := (AGameLevelControl as TGameLevelPlatform).NbBloc;
    FLeftBlocType := (AGameLevelControl as TGameLevelPlatform).LeftBlocType;
    FRightBlocType := (AGameLevelControl as TGameLevelPlatform).RightBlocType;
    FLook := (AGameLevelControl as TGameLevelPlatform).Look;
  end
  else
  begin
    FNbBloc := 1;
    FLeftBlocType := TGameLevelPlatformEndType.None;
    FRightBlocType := TGameLevelPlatformEndType.None;
    FLook := TGameLevelPlatformLook.None;
  end;
end;

procedure TPlatformSprite.RefreshImage;
var
  SVG, SVGBis: integer;
  I: integer;
  LCanvas: TCanvas;
  BitmapScale: Single;
begin
  case FLook of
    TGameLevelPlatformLook.None:
      SVG := -1;
    TGameLevelPlatformLook.Castle:
      SVG := CSVGCastle;
    TGameLevelPlatformLook.Dirt:
      SVG := CSVGDirt;
    TGameLevelPlatformLook.Grass:
      SVG := CSVGGrass;
    TGameLevelPlatformLook.Sand:
      SVG := CSVGSand;
    TGameLevelPlatformLook.Snow:
      SVG := CSVGSnow;
    TGameLevelPlatformLook.Stone:
      SVG := CSVGStone;
  else
    raise Exception.Create('Unknown platform look.');
  end;

  BitmapScale := GetBitmapScale;

  BeginUpdate;
  try
    WrapMode := TImageWrapMode.Original;
    Width := CDefaultSpriteSize * FNbBloc;
    Bitmap.SetSize(trunc(Width * BitmapScale), trunc(height * BitmapScale));
    if FNbBloc = 1 then
      Bitmap.Assign(TOlfSVGBitmapList.Bitmap(TSVGPlatformerAssetsBase.tag + SVG,
        CDefaultSpriteSize, CDefaultSpriteSize, BitmapScale))
    else
    begin
      LCanvas := Bitmap.Canvas;
      LCanvas.BeginScene;
      try
        // Left bloc
        if FLeftBlocType = TGameLevelPlatformEndType.Cliff then
          SVGBis := SVG + CSVGCastleCliffLeft - CSVGCastle
        else
          SVGBis := SVG + CSVGCastleLeft - CSVGCastle;
        LCanvas.DrawBitmap(TOlfSVGBitmapList.Bitmap(TSVGPlatformerAssetsBase.tag
          + SVGBis, CDefaultSpriteSize, CDefaultSpriteSize, BitmapScale),
          trectf.Create(0, 0, CDefaultSpriteSize, CDefaultSpriteSize),
          trectf.Create(0, 0, CDefaultSpriteSize, CDefaultSpriteSize), 1);
        // Middle bloc(s)
        SVGBis := SVG + CSVGCastleMid - CSVGCastle;
        for I := 1 to FNbBloc - 2 do
          LCanvas.DrawBitmap
            (TOlfSVGBitmapList.Bitmap(TSVGPlatformerAssetsBase.tag + SVGBis,
            CDefaultSpriteSize, CDefaultSpriteSize, BitmapScale),
            trectf.Create(0, 0, CDefaultSpriteSize, CDefaultSpriteSize),
            trectf.Create(CDefaultSpriteSize * I - 1, 0,
            CDefaultSpriteSize * I - 1 + CDefaultSpriteSize,
            CDefaultSpriteSize), 1);
        // Right bloc
        if FRightBlocType = TGameLevelPlatformEndType.Cliff then
          SVGBis := SVG + CSVGCastleCliffRight - CSVGCastle
        else
          SVGBis := SVG + CSVGCastleRight - CSVGCastle;
        LCanvas.DrawBitmap(TOlfSVGBitmapList.Bitmap(TSVGPlatformerAssetsBase.tag
          + SVGBis, CDefaultSpriteSize, CDefaultSpriteSize, BitmapScale),
          trectf.Create(0, 0, CDefaultSpriteSize, CDefaultSpriteSize),
          trectf.Create(Width - CDefaultSpriteSize - 1, 0, Width,
          CDefaultSpriteSize), 1);
      finally
        LCanvas.EndScene;
      end;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TPlatformSprite.SetLeftBlocType(const Value
  : TGameLevelPlatformEndType);
begin
  FLeftBlocType := Value;
  if assigned(FGameLevelControl) then
    (FGameLevelControl as TGameLevelPlatform).LeftBlocType := FLeftBlocType;
  RefreshImage;
end;

procedure TPlatformSprite.SetLook(const Value: TGameLevelPlatformLook);
begin
  FLook := Value;
  if assigned(FGameLevelControl) then
    (FGameLevelControl as TGameLevelPlatform).Look := FLook;
  RefreshImage;
end;

procedure TPlatformSprite.SetNbBloc(const Value: cardinal);
begin
  if (Value < 1) then
    FNbBloc := 1
  else
    FNbBloc := Value;
  if assigned(FGameLevelControl) then
    (FGameLevelControl as TGameLevelPlatform).NbBloc := FNbBloc;
  RefreshImage;
end;

procedure TPlatformSprite.SetRightBlocType(const Value
  : TGameLevelPlatformEndType);
begin
  FRightBlocType := Value;
  if assigned(FGameLevelControl) then
    (FGameLevelControl as TGameLevelPlatform).RightBlocType := FRightBlocType;
  RefreshImage;
end;

{ TSprite }

constructor TSprite.Create(AOwner: TComponent;
  const AGameLevelControl: TGameLevelControl);
begin
  inherited Create(AOwner);
  Width := CDefaultSpriteSize;
  height := CDefaultSpriteSize;
  FGameLevelControl := AGameLevelControl;
  if assigned(AGameLevelControl) then
  begin
    position.X := AGameLevelControl.X;
    position.Y := AGameLevelControl.Y;
  end;
end;

function TSprite.GetX: Single;
begin
  result := position.X;
end;

function TSprite.GetY: Single;
begin
  result := position.Y;
end;

constructor TSprite.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TSprite.SetGameLevelControl(const Value: TGameLevelControl);
begin
  FGameLevelControl := Value;
end;

procedure TSprite.SetX(const Value: Single);
begin
  position.X := Value;
  if assigned(FGameLevelControl) then
    FGameLevelControl.X := position.X;
end;

procedure TSprite.SetY(const Value: Single);
begin
  position.Y := Value;
  if assigned(FGameLevelControl) then
    FGameLevelControl.Y := position.Y;
end;

{ TCharacterSprite }

constructor TCharacterSprite.Create(AOwner: TComponent;
  const AGameLevelControl: TGameLevelControl);
begin
  inherited;
  if assigned(AGameLevelControl) then
  begin
    // TODO : à compléter avec TGameLevelCharacter lorsqu'il existera
  end
  else
  begin
    FLook := TGameLevelCharacterLook.None;
  end;
end;

procedure TCharacterSprite.RefreshImage;
var
  SVG: integer;
begin
  case FLook of
    TGameLevelCharacterLook.None:
      SVG := -1;
    TGameLevelCharacterLook.Zombie:
      SVG := CSVGZombieIdle;
  else
    raise Exception.Create('Unknown character look.');
  end;

  BeginUpdate;
  try
    WrapMode := TImageWrapMode.Original;
    Bitmap.Assign(TOlfSVGBitmapList.Bitmap(TSVGCharacters.tag + SVG,
      CDefaultSpriteSize, CDefaultSpriteSize, GetBitmapScale));
  finally
    EndUpdate;
  end;
end;

procedure TCharacterSprite.SetLook(const Value: TGameLevelCharacterLook);
begin
  FLook := Value;
  // if assigned(FGameLevelControl) then
  // (FGameLevelControl as TGameLevelPlatform).LeftBlocType := FLeftBlocType;
  RefreshImage;
end;

{ TPlayerSprite }

procedure TPlayerSprite.AfterConstruction;
begin
  inherited;
  Look := TGameLevelCharacterLook.Zombie;
end;

{ TItemSprite }

constructor TItemSprite.Create(AOwner: TComponent;
  const AGameLevelControl: TGameLevelControl);
begin
  inherited;
  if assigned(AGameLevelControl) then
  begin
    FItemType := (AGameLevelControl as TGameLevelitem).ItemType;
  end
  else
  begin
    FItemType := TGameLevelItemType.None;
  end;
end;

procedure TItemSprite.RefreshImage;
var
  SVG: integer;
begin
  case FItemType of
    TGameLevelItemType.None:
      SVG := -1;
    TGameLevelItemType.CoinBronze:
      SVG := CSVGCoinBronze0;
    TGameLevelItemType.CoinArgent:
      SVG := CSVGCoinArgent0;
    TGameLevelItemType.CoinGold:
      SVG := CSVGCoinOr0;
  else
    raise Exception.Create('Unknown item type.');
  end;

  BeginUpdate;
  try
    WrapMode := TImageWrapMode.Original;
    Bitmap.Assign(TOlfSVGBitmapList.Bitmap(TSVGJumperPack.tag + SVG,
      CDefaultSpriteSize, CDefaultSpriteSize, GetBitmapScale));
  finally
    EndUpdate;
  end;
end;

procedure TItemSprite.SetItemType(const Value: TGameLevelItemType);
begin
  FItemType := Value;
  if assigned(FGameLevelControl) then
    (FGameLevelControl as TGameLevelitem).ItemType := FItemType;
  RefreshImage;
end;

end.
