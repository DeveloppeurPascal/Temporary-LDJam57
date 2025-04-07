/// <summary>
/// ***************************************************************************
///
/// Zomcave
///
/// Copyright 2025 Patrick PREMARTIN under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://zomcave.gamolf.fr
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Zomcave-LudumDare57
///
/// ***************************************************************************
/// File last update : 2025-04-07T08:49:27.749+02:00
/// Signature : c11a87c1e6b2ce4caa0395e7ad63d714ca3bf588
/// ***************************************************************************
/// </summary>

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
