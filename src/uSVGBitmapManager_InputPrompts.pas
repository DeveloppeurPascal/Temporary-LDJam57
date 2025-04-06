unit uSVGBitmapManager_InputPrompts;

interface

uses
  FMX.Graphics,
  USVGInputPrompts,
  USVGCharacters,
  USVGDoors,
  USVGIcons,
  USVGJumperPack,
  USVGPhysicsAssets,
  USVGWall,
  USVGPlatformerAssetsBase;

/// <summary>
/// Returns a bitmap from a SVG image
/// </summary>
function getBitmapFromSVG(const Index: TSVGInputPromptsIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
function getBitmapFromSVG(const Index: TSVGWallIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
function getBitmapFromSVG(const Index: TSVGPhysicsAssetsIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
function getBitmapFromSVG(const Index: TSVGJumperPackIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
function getBitmapFromSVG(const Index: TSVGIconsIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
function getBitmapFromSVG(const Index: TSVGDoorsIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
function getBitmapFromSVG(const Index: TSVGCharactersIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
function getBitmapFromSVG(const Index: TSVGPlatformerAssetsBaseIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;

implementation

uses
  Olf.Skia.SVGToBitmap;

function getBitmapFromSVG(const Index: TSVGInputPromptsIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
begin
  result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGInputPrompts.Tag,
    round(width), round(height), BitmapScale);
end;

function getBitmapFromSVG(const Index: TSVGWallIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
begin
  result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGWall.Tag, round(width),
    round(height), BitmapScale);
end;

function getBitmapFromSVG(const Index: TSVGPhysicsAssetsIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
begin
  result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGPhysicsAssets.Tag,
    round(width), round(height), BitmapScale);
end;

function getBitmapFromSVG(const Index: TSVGJumperPackIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
begin
  result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGJumperPack.Tag,
    round(width), round(height), BitmapScale);
end;

function getBitmapFromSVG(const Index: TSVGIconsIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
begin
  result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGIcons.Tag, round(width),
    round(height), BitmapScale);
end;

function getBitmapFromSVG(const Index: TSVGDoorsIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
begin
  result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGDoors.Tag, round(width),
    round(height), BitmapScale);
end;

function getBitmapFromSVG(const Index: TSVGCharactersIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
begin
  result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGCharacters.Tag,
    round(width), round(height), BitmapScale);
end;

function getBitmapFromSVG(const Index: TSVGPlatformerAssetsBaseIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
begin
  result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGPlatformerAssetsBase.Tag,
    round(width), round(height), BitmapScale);
end;

procedure RegisterSVGImages;
begin
  TSVGWall.Tag := TOlfSVGBitmapList.AddItem(SVGWall);
  TSVGPhysicsAssets.Tag := TOlfSVGBitmapList.AddItem(SVGPhysicsAssets);
  TSVGJumperPack.Tag := TOlfSVGBitmapList.AddItem(SVGJumperPack);
  TSVGIcons.Tag := TOlfSVGBitmapList.AddItem(SVGIcons);
  TSVGDoors.Tag := TOlfSVGBitmapList.AddItem(SVGDoors);
  TSVGCharacters.Tag := TOlfSVGBitmapList.AddItem(SVGCharacters);
  TSVGInputPrompts.Tag := TOlfSVGBitmapList.AddItem(SVGInputPrompts);
  TSVGPlatformerAssetsBase.Tag := TOlfSVGBitmapList.AddItem
    (SVGPlatformerAssetsBase);
end;

initialization

RegisterSVGImages;

end.
