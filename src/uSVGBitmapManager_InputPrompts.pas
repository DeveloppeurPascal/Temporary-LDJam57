unit uSVGBitmapManager_InputPrompts;

interface

// TODO : retirer les blocs de code commentés si inutilisés
uses
  FMX.Graphics,
  USVGInputPrompts,
  USVGCharacters,
  USVGDoors,
  USVGIcons,
  USVGJumperPack,
  USVGPhysicsAssets,
  USVGWall;

/// <summary>
/// Returns a bitmap from a SVG image
/// </summary>
function getBitmapFromSVG(const Index: TSVGInputPromptsIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
function getBitmapFromSVG(const Index: TSVGWallIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
// function getBitmapFromSVG(const Index: TSVGUIPackIndex;
// const width, height: single; const BitmapScale: single): tbitmap; overload;
// function getBitmapFromSVG(const Index: TSVGPuzzleAssets2Index;
// const width, height: single; const BitmapScale: single): tbitmap; overload;
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

// function getBitmapFromSVG(const Index: TSVGUIPackIndex;
// const width, height: single; const BitmapScale: single): tbitmap; overload;
// begin
// result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGUIPack.Tag, round(width),
// round(height), BitmapScale);
// end;
//
// function getBitmapFromSVG(const Index: TSVGPuzzleAssets2Index;
// const width, height: single; const BitmapScale: single): tbitmap; overload;
// begin
// result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGPuzzleAssets2.Tag,
// round(width), round(height), BitmapScale);
// end;

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

procedure RegisterSVGImages;
begin
  TSVGWall.Tag := TOlfSVGBitmapList.AddItem(SVGWall);
//  TSVGUIPack.Tag := TOlfSVGBitmapList.AddItem(SVGUIPack);
//  TSVGPuzzleAssets2.Tag := TOlfSVGBitmapList.AddItem(SVGPuzzleAssets2);
  TSVGPhysicsAssets.Tag := TOlfSVGBitmapList.AddItem(SVGPhysicsAssets);
  TSVGJumperPack.Tag := TOlfSVGBitmapList.AddItem(SVGJumperPack);
  TSVGIcons.Tag := TOlfSVGBitmapList.AddItem(SVGIcons);
  TSVGDoors.Tag := TOlfSVGBitmapList.AddItem(SVGDoors);
  TSVGCharacters.Tag := TOlfSVGBitmapList.AddItem(SVGCharacters);
  TSVGInputPrompts.Tag := TOlfSVGBitmapList.AddItem(SVGInputPrompts);
end;

initialization

RegisterSVGImages;

end.
