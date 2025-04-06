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
  protected
  public
    constructor Create(AOwner: TComponent); override;
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
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; ALook: TGameLevelDoorLook); overload;
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
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent;
      ALook: TGameLevelPlatformLook); overload;
    procedure RefreshImage; override;
  end;

  TCharacterSprite = class(TSprite)
  private
    FLook: TGameLevelCharacterLook;
    procedure SetLook(const Value: TGameLevelCharacterLook);
  protected
  public
    property Look: TGameLevelCharacterLook read FLook write SetLook;
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent;
      const ALook: TGameLevelCharacterLook); overload;
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
  protected
  public
  end;

function GetBitmapScale: single;

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
  USVGCharacters;

function GetBitmapScale: single;
var
  svc: IFMXScreenService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, svc)
  then
    result := svc.GetScreenScale
  else
    result := 1;
end;

constructor TDoorSprite.Create(AOwner: TComponent);
begin
  inherited;
  FLook := TGameLevelDoorLook.None;
  FDirection := TGameLevelDoorDirection.Back;
  FId := 0;
end;

constructor TDoorSprite.Create(AOwner: TComponent; ALook: TGameLevelDoorLook);
begin
  TDoorSprite.Create(AOwner);
  Look := ALook;
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
    wrapmode := timagewrapmode.Original;
    bitmap.assign(TOlfSVGBitmapList.bitmap(TSVGDoors.tag + SVG,
      CDefaultSpriteSize, CDefaultSpriteSize, GetBitmapScale));
  finally
    EndUpdate;
  end;
end;

procedure TDoorSprite.SetDirection(const Value: TGameLevelDoorDirection);
begin
  FDirection := Value;
  RefreshImage;
end;

procedure TDoorSprite.SetId(const Value: cardinal);
begin
  FId := Value;
end;

procedure TDoorSprite.SetLook(const Value: TGameLevelDoorLook);
begin
  FLook := Value;
  RefreshImage;
end;

{ TPlatformSprite }

constructor TPlatformSprite.Create(AOwner: TComponent);
begin
  inherited;
  FNbBloc := 1;
  FLeftBlocType := TGameLevelPlatformEndType.None;
  FRightBlocType := TGameLevelPlatformEndType.None;
  FLook := TGameLevelPlatformLook.None;
end;

constructor TPlatformSprite.Create(AOwner: TComponent;
  ALook: TGameLevelPlatformLook);
begin
  TPlatformSprite.Create(AOwner);
  Look := ALook;
end;

procedure TPlatformSprite.RefreshImage;
var
  SVG, SVGBis: integer;
  I: integer;
  LCanvas: TCanvas;
  BitmapScale: single;
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
    wrapmode := timagewrapmode.Original;
    Width := CDefaultSpriteSize * FNbBloc;
    bitmap.SetSize(trunc(Width * BitmapScale), trunc(height * BitmapScale));
    if FNbBloc = 1 then
      bitmap.assign(TOlfSVGBitmapList.bitmap(TSVGPlatformerAssetsBase.tag + SVG,
        CDefaultSpriteSize, CDefaultSpriteSize, BitmapScale))
    else
    begin
      LCanvas := bitmap.Canvas;
      LCanvas.BeginScene;
      try
        // Left bloc
        if FLeftBlocType = TGameLevelPlatformEndType.Cliff then
          SVGBis := SVG + CSVGCastleCliffLeft - CSVGCastle
        else
          SVGBis := SVG + CSVGCastleLeft - CSVGCastle;
        LCanvas.DrawBitmap(TOlfSVGBitmapList.bitmap(TSVGPlatformerAssetsBase.tag
          + SVGBis, CDefaultSpriteSize, CDefaultSpriteSize, BitmapScale),
          trectf.Create(0, 0, CDefaultSpriteSize, CDefaultSpriteSize),
          trectf.Create(0, 0, CDefaultSpriteSize, CDefaultSpriteSize), 1);
        // Middle bloc(s)
        SVGBis := SVG + CSVGCastleMid - CSVGCastle;
        for I := 1 to FNbBloc - 2 do
          LCanvas.DrawBitmap
            (TOlfSVGBitmapList.bitmap(TSVGPlatformerAssetsBase.tag + SVGBis,
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
        LCanvas.DrawBitmap(TOlfSVGBitmapList.bitmap(TSVGPlatformerAssetsBase.tag
          + SVGBis, CDefaultSpriteSize, CDefaultSpriteSize, BitmapScale),
          trectf.Create(0, 0, CDefaultSpriteSize, CDefaultSpriteSize),
          trectf.Create(Width - CDefaultSpriteSize-1, 0, Width,
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
  RefreshImage;
end;

procedure TPlatformSprite.SetLook(const Value: TGameLevelPlatformLook);
begin
  FLook := Value;
  RefreshImage;
end;

procedure TPlatformSprite.SetNbBloc(const Value: cardinal);
begin
  if (Value < 1) then
    FNbBloc := 1
  else
    FNbBloc := Value;
  RefreshImage;
end;

procedure TPlatformSprite.SetRightBlocType(const Value
  : TGameLevelPlatformEndType);
begin
  FRightBlocType := Value;
  RefreshImage;
end;

{ TSprite }

constructor TSprite.Create(AOwner: TComponent);
begin
  inherited;
  Width := CDefaultSpriteSize;
  height := CDefaultSpriteSize;
end;

{ TCharacterSprite }

constructor TCharacterSprite.Create(AOwner: TComponent);
begin
  inherited;
  FLook := TGameLevelCharacterLook.None;
end;

constructor TCharacterSprite.Create(AOwner: TComponent;
  const ALook: TGameLevelCharacterLook);
begin
  TCharacterSprite.Create(AOwner);
  Look := ALook;
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
    wrapmode := timagewrapmode.Original;
    bitmap.assign(TOlfSVGBitmapList.bitmap(TSVGCharacters.tag + SVG,
      CDefaultSpriteSize, CDefaultSpriteSize, GetBitmapScale));
  finally
    EndUpdate;
  end;
end;

procedure TCharacterSprite.SetLook(const Value: TGameLevelCharacterLook);
begin
  FLook := Value;
  RefreshImage;
end;

{ TPlayerSprite }

procedure TPlayerSprite.AfterConstruction;
begin
  inherited;
  Look := TGameLevelCharacterLook.Zombie;
end;

end.
