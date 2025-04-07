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
/// File last update : 2025-04-07T08:49:27.607+02:00
/// Signature : 9cd1f5406a8aa094489fb7047192e37f9753f7b2
/// ***************************************************************************
/// </summary>

unit USVGWall;

// ****************************************
// * SVG from folder :
// * /Users/patrickpremartin/Downloads/dossier sans titre/used/Kenney.nl/Platformer Assets Tile Extensions/Wall/uSVGWall.pas
// ****************************************
//
// This file contains a list of contants and 
// an enumeration to access to SVG source codes 
// from the generated array of strings.
//
// ****************************************
// File generator : SVG Folder to Delphi Unit v1.0
// Website : https://svgfolder2delphiunit.olfsoftware.fr/
// Generation date : 2025-04-05T15:40:32.818Z
//
// Don't do any change on this file.
// They will be erased by next generation !
// ****************************************

interface

const
  CSVGWallChoco = 0;
  CSVGWallSand = 1;

type
{$SCOPEDENUMS ON}
  TSVGWallIndex = (
    WallChoco = CSVGWallChoco,
    WallSand = CSVGWallSand);

  TSVGWall = class
  private
  class var
    FTag: integer;
    FTagBool: Boolean;
    FTagFloat: Single;
    FTagObject: TObject;
    FTagString: string;
    class procedure SetTag(const Value: integer); static;
    class procedure SetTagBool(const Value: Boolean); static;
    class procedure SetTagFloat(const Value: Single); static;
    class procedure SetTagObject(const Value: TObject); static;
    class procedure SetTagString(const Value: string); static;
  public const
    WallChoco = CSVGWallChoco;
    WallSand = CSVGWallSand;
    class property Tag: integer read FTag write SetTag;
    class property TagBool: Boolean read FTagBool write SetTagBool;
    class property TagFloat: Single read FTagFloat write SetTagFloat;
    class property TagObject: TObject read FTagObject write SetTagObject;
    class property TagString: string read FTagString write SetTagString;
    class function SVG(const Index: Integer): string; overload;
    class function SVG(const Index: TSVGWallIndex) : string; overload;
    class function Count : Integer;
    class constructor Create;
  end;

var
  SVGWall : array of String;

implementation

uses
  System.SysUtils;

{ TSVGWall }

class constructor TSVGWall.Create;
begin
  inherited;
  FTag := 0;
  FTagBool := false;
  FTagFloat := 0;
  FTagObject := nil;
  FTagString := '';
end;

class procedure TSVGWall.SetTag(const Value: integer);
begin
  FTag := Value;
end;

class procedure TSVGWall.SetTagBool(const Value: Boolean);
begin
  FTagBool := Value;
end;

class procedure TSVGWall.SetTagFloat(const Value: Single);
begin
  FTagFloat := Value;
end;

class procedure TSVGWall.SetTagObject(const Value: TObject);
begin
  FTagObject := Value;
end;

class procedure TSVGWall.SetTagString(const Value: string);
begin
  FTagString := Value;
end;

class function TSVGWall.SVG(const Index: Integer): string;
begin
  if (index < Count) then
    result := SVGWall[index]
  else
    raise Exception.Create('SVG not found. Index out of range.');
end;

class function TSVGWall.SVG(const Index : TSVGWallIndex): string;
begin
  result := SVG(ord(index));
end;

class function TSVGWall.Count: Integer;
begin
  result := length(SVGWall);
end;

initialization

SetLength(SVGWall, 2);

{$TEXTBLOCK NATIVE XML}
SVGWall[CSVGWallChoco] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 70 70"><g id="Calque_1-2"><path
d="M0,23.3V0h70v23.3l-11.65-11.5-11.7,11.5-11.6-11.5-11.7,11.5-11.7-11.5-1.45,1.45L.05,23.3h-.05M70,38.5v31.5H0v-31.5l11.65-11.5,11.7,11.5,11.7-11.5,11.6,11.5,11.7-11.5,11.65,11.5M59.8,45.15c.73.73,1.62,1.1,2.65,1.1s1.92-.37,2.65-1.1,1.1-1.6,1.1-2.6c0-1.03-.37-1.92-1.1-2.65s-1.62-1.1-2.65-1.1-1.92.37-2.65,1.1c-.7.73-1.05,1.62-1.05,2.65s.35,1.87,1.05,2.6M53.45,58.8c0-1.03-.37-1.92-1.1-2.65s-1.62-1.1-2.65-1.1-1.92.37-2.65,1.1c-.7.73-1.05,1.62-1.05,2.65s.35,1.87,1.05,2.6c.73.73,1.62,1.1,2.65,1.1s1.92-.37,2.65-1.1,1.1-1.6,1.1-2.6M33.95,43.45c0-1.03-.37-1.92-1.1-2.65-.73-.73-1.62-1.1-2.65-1.1s-1.92.37-2.65,1.1c-.7.73-1.05,1.62-1.05,2.65s.35,1.87,1.05,2.6c.73.73,1.62,1.1,2.65,1.1s1.92-.37,2.65-1.1c.73-.73,1.1-1.6,1.1-2.6M18,47.7c1.37-1.33,2.05-2.95,2.05-4.85,0-1.9-.68-3.53-2.05-4.9-1.33-1.33-2.95-2-4.85-2s-3.53.67-4.9,2c-1.33,1.37-2,3-2,4.9s.67,3.52,2,4.85c1.37,1.37,3,2.05,4.9,2.05s3.52-.68,4.85-2.05M24.95,47.95c-1.03,0-1.92.37-2.65,1.1-.7.73-1.05,1.62-1.05,2.65s.35,1.87,1.05,2.6c.73.73,1.62,
1.1,2.65,1.1s1.92-.37,2.65-1.1c.73-.73,1.1-1.6,1.1-2.6,0-1.03-.37-1.92-1.1-2.65-.73-.73-1.62-1.1-2.65-1.1M51.7,9.25c0-1.03-.37-1.92-1.1-2.65s-1.62-1.1-2.65-1.1-1.92.37-2.65,1.1c-.7.73-1.05,1.62-1.05,2.65s.35,1.87,1.05,2.6c.73.73,1.62,1.1,2.65,1.1s1.92-.37,2.65-1.1,1.1-1.6,1.1-2.6" fill="#917052"/><path d="M51.7,9.25c0,1-.37,1.87-1.1,2.6s-1.62,1.1-2.65,1.1-1.92-.37-2.65-1.1c-.7-.73-1.05-1.6-1.05-2.6s.35-1.92,1.05-2.65c.73-.73,1.62-1.1,2.65-1.1s1.92.37,2.65,1.1,1.1,1.62,1.1,2.65M70,23.3v15.2l-11.65-11.5-11.7,11.5-11.6-11.5-11.7,11.5-11.7-11.5L0,38.5v-15.2h.05l10.15-10.05,1.45-1.45,11.7,11.5,11.7-11.5,11.6,11.5,11.7-11.5,11.65,11.5M24.95,47.95c1.03,0,1.92.37,2.65,1.1.73.73,1.1,1.62,1.1,2.65,0,1-.37,1.87-1.1,2.6-.73.73-1.62,1.1-2.65,1.1s-1.92-.37-2.65-1.1c-.7-.73-1.05-1.6-1.05-2.6s.35-1.92,1.05-2.65c.73-.73,1.62-1.1,2.65-1.1M18,47.7c-1.33,1.37-2.95,2.05-4.85,2.05s-3.53-.68-4.9-2.05c-1.33-1.33-2-2.95-2-4.85s.67-3.53,2-4.9c1.37-1.33,3-2,4.9-2s3.52.67,4.85,2c1.37,1.37,2.05,3,2.05,4.9,0,
1.9-.68,3.52-2.05,4.85M33.95,43.45c0,1-.37,1.87-1.1,2.6-.73.73-1.62,1.1-2.65,1.1s-1.92-.37-2.65-1.1c-.7-.73-1.05-1.6-1.05-2.6s.35-1.92,1.05-2.65c.73-.73,1.62-1.1,2.65-1.1s1.92.37,2.65,1.1c.73.73,1.1,1.62,1.1,2.65M53.45,58.8c0,1-.37,1.87-1.1,2.6s-1.62,1.1-2.65,1.1-1.92-.37-2.65-1.1c-.7-.73-1.05-1.6-1.05-2.6s.35-1.92,1.05-2.65c.73-.73,1.62-1.1,2.65-1.1s1.92.37,2.65,1.1,1.1,1.62,1.1,2.65M59.8,45.15c-.7-.73-1.05-1.6-1.05-2.6s.35-1.92,1.05-2.65c.73-.73,1.62-1.1,2.65-1.1s1.92.37,2.65,1.1,1.1,1.62,1.1,2.65c0,1-.37,1.87-1.1,2.6s-1.62,1.1-2.65,1.1-1.92-.37-2.65-1.1" fill="#876748"/></g></svg>
''';
SVGWall[CSVGWallSand] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 70 70"><g id="Calque_1-2"><path d="M70,23.3l-11.65-11.5-11.7,11.5-11.6-11.5-11.7,11.5-11.7-11.5-1.45,1.45L.05,23.3h-.05V0h70v23.3M0,38.5l11.65-11.5,11.7,11.5,11.7-11.5,11.6,11.5,11.7-11.5,11.65,11.5v15l-11.65-11.5-11.7,11.5-11.6-11.5-11.7,11.5-11.7-11.5-1.45,1.45L.05,53.5h-.05v-15M0,68.7l1.8-1.8-.05-.05,9.95-9.85,11.7,11.5,11.7-11.5,11.6,11.5,11.7-11.5,9.9,9.8-.05.05,1.75,1.75v1.4H0v-1.3" fill="#c99869"/><path d="M0,23.3h.05l10.15-10.05,1.45-1.45,11.7,11.5,11.7-11.5,11.6,11.5,11.7-11.5,11.65,11.5v15.2l-11.65-11.5-11.7,11.5-11.6-11.5-11.7,11.5-11.7-11.5L0,38.5v-15.2M0,53.5h.05l10.15-10.05,1.45-1.45,11.7,11.5,11.7-11.5,11.6,11.5,11.7-11.5,11.65,11.5v15.1l-1.75-1.75.05-.05-9.9-9.8-11.7,11.5-11.6-11.5-11.7,11.5-11.7-11.5-9.95,9.85.05.05-1.8,1.8v-15.2" fill="#c58f5c"/></g></svg>
''';

end.
