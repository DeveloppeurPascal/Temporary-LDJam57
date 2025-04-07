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
/// File last update : 2025-04-07T08:49:27.510+02:00
/// Signature : 62e02a6d0afe45bc9ccde3c58c4457a7cbf3ea0f
/// ***************************************************************************
/// </summary>

unit USVGIcons;

// ****************************************
// * SVG from folder :
// * /Users/patrickpremartin/Downloads/dossier sans titre/used/Kenney.nl/Game Icons/Icons/uSVGIcons.pas
// ****************************************
//
// This file contains a list of contants and 
// an enumeration to access to SVG source codes 
// from the generated array of strings.
//
// ****************************************
// File generator : SVG Folder to Delphi Unit v1.0
// Website : https://svgfolder2delphiunit.olfsoftware.fr/
// Generation date : 2025-04-05T15:40:05.697Z
//
// Don't do any change on this file.
// They will be erased by next generation !
// ****************************************

interface

const
  CSVGMusicOffBlack = 0;
  CSVGMusicOffWhite = 1;
  CSVGMusicOnBlack = 2;
  CSVGMusicOnWhite = 3;
  CSVGPauseBlack = 4;
  CSVGPauseWhite = 5;
  CSVGSoudsOffBlack = 6;
  CSVGSoundsOffWhite = 7;
  CSVGSoundsOnBlack = 8;
  CSVGSoundsOnWhite = 9;

type
{$SCOPEDENUMS ON}
  TSVGIconsIndex = (
    MusicOffBlack = CSVGMusicOffBlack,
    MusicOffWhite = CSVGMusicOffWhite,
    MusicOnBlack = CSVGMusicOnBlack,
    MusicOnWhite = CSVGMusicOnWhite,
    PauseBlack = CSVGPauseBlack,
    PauseWhite = CSVGPauseWhite,
    SoudsOffBlack = CSVGSoudsOffBlack,
    SoundsOffWhite = CSVGSoundsOffWhite,
    SoundsOnBlack = CSVGSoundsOnBlack,
    SoundsOnWhite = CSVGSoundsOnWhite);

  TSVGIcons = class
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
    MusicOffBlack = CSVGMusicOffBlack;
    MusicOffWhite = CSVGMusicOffWhite;
    MusicOnBlack = CSVGMusicOnBlack;
    MusicOnWhite = CSVGMusicOnWhite;
    PauseBlack = CSVGPauseBlack;
    PauseWhite = CSVGPauseWhite;
    SoudsOffBlack = CSVGSoudsOffBlack;
    SoundsOffWhite = CSVGSoundsOffWhite;
    SoundsOnBlack = CSVGSoundsOnBlack;
    SoundsOnWhite = CSVGSoundsOnWhite;
    class property Tag: integer read FTag write SetTag;
    class property TagBool: Boolean read FTagBool write SetTagBool;
    class property TagFloat: Single read FTagFloat write SetTagFloat;
    class property TagObject: TObject read FTagObject write SetTagObject;
    class property TagString: string read FTagString write SetTagString;
    class function SVG(const Index: Integer): string; overload;
    class function SVG(const Index: TSVGIconsIndex) : string; overload;
    class function Count : Integer;
    class constructor Create;
  end;

var
  SVGIcons : array of String;

implementation

uses
  System.SysUtils;

{ TSVGIcons }

class constructor TSVGIcons.Create;
begin
  inherited;
  FTag := 0;
  FTagBool := false;
  FTagFloat := 0;
  FTagObject := nil;
  FTagString := '';
end;

class procedure TSVGIcons.SetTag(const Value: integer);
begin
  FTag := Value;
end;

class procedure TSVGIcons.SetTagBool(const Value: Boolean);
begin
  FTagBool := Value;
end;

class procedure TSVGIcons.SetTagFloat(const Value: Single);
begin
  FTagFloat := Value;
end;

class procedure TSVGIcons.SetTagObject(const Value: TObject);
begin
  FTagObject := Value;
end;

class procedure TSVGIcons.SetTagString(const Value: string);
begin
  FTagString := Value;
end;

class function TSVGIcons.SVG(const Index: Integer): string;
begin
  if (index < Count) then
    result := SVGIcons[index]
  else
    raise Exception.Create('SVG not found. Index out of range.');
end;

class function TSVGIcons.SVG(const Index : TSVGIconsIndex): string;
begin
  result := SVG(ord(index));
end;

class function TSVGIcons.Count: Integer;
begin
  result := length(SVGIcons);
end;

initialization

SetLength(SVGIcons, 10);

{$TEXTBLOCK NATIVE XML}
SVGIcons[CSVGMusicOffBlack] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 29.94 30.98"><g id="Layer_1"><path d="M8.19,1.5C8.49.47,9.24-.03,10.44,0h13.55c2,0,3,.97,3,2.9v15.45l-.3,1.65-6.8-6.8.75-.2h1.35v-5h-7.3L8.19,1.5M3.49,2.55c.4-.4.88-.6,1.45-.6s1.03.2,1.4.6l23,23c.4.37.6.83.6,1.4s-.2,1.05-.6,1.45c-.37.37-.83.55-1.4.55s-1.05-.18-1.45-.55L3.49,5.4c-.37-.4-.55-.88-.55-1.45s.18-1.03.55-1.4M1.99,20.95l.1-.05c1.1-1.07,2.3-1.73,3.6-2h.05l2.25.1v-6.3l4,4v8.3c.07,1.27-.62,2.53-2.05,3.8l-.05.15c-1.2,1.17-2.58,1.83-4.15,2h-.05c-1.73.17-3.15-.32-4.25-1.45C.31,28.4-.16,27,.04,25.3c.13-1.67.78-3.12,1.95-4.35M14.94,19.65l5.45,5.45c-1.63.07-2.98-.47-4.05-1.6-1-.97-1.47-2.25-1.4-3.85"/></g></svg>
''';
SVGIcons[CSVGMusicOffWhite] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 29.94 30.98"><g id="Layer_1"><path d="M8.19,1.5C8.49.47,9.24-.03,10.44,0h13.55c2,0,3,.97,3,2.9v15.45l-.3,1.65-6.8-6.8.75-.2h1.35v-5h-7.3L8.19,1.5M3.49,2.55c.4-.4.88-.6,1.45-.6s1.03.2,1.4.6l23,23c.4.37.6.83.6,1.4s-.2,1.05-.6,1.45c-.37.37-.83.55-1.4.55s-1.05-.18-1.45-.55L3.49,5.4c-.37-.4-.55-.88-.55-1.45s.18-1.03.55-1.4M1.99,20.95l.1-.05c1.1-1.07,2.3-1.73,3.6-2h.05l2.25.1v-6.3l4,4v8.3c.07,1.27-.62,2.53-2.05,3.8l-.05.15c-1.2,1.17-2.58,1.83-4.15,2h-.05c-1.73.17-3.15-.32-4.25-1.45C.31,28.4-.16,27,.04,25.3c.13-1.67.78-3.12,1.95-4.35M14.94,19.65l5.45,5.45c-1.63.07-2.98-.47-4.05-1.6-1-.97-1.47-2.25-1.4-3.85" fill="#fff"/></g></svg>
''';
SVGIcons[CSVGMusicOnBlack] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 26.99 30.99"><g id="Layer_1"><path d="M26.99,2.9v15.45c-.2,1.83-.87,3.33-2,4.5h-.1c-1.2,1.33-2.62,2.07-4.25,2.2h-.05c-1.7.17-3.12-.35-4.25-1.55-1.1-1.07-1.57-2.5-1.4-4.3.17-1.6.83-3,2-4.2,1.13-1.13,2.37-1.8,3.7-2h1.35v-5h-10v17c.07,1.27-.62,2.53-2.05,3.8l-.05.15c-1.2,1.17-2.58,1.83-4.15,2h-.05c-1.73.17-3.15-.32-4.25-1.45C.31,28.4-.16,27,.04,25.3c.13-1.67.78-3.12,1.95-4.35l.1-.05c1.1-1.07,2.3-1.73,3.6-2h.05l2.25.1V3C7.93.94,8.74-.06,10.44,0h13.55c2,0,3,.97,3,2.9"/></g></svg>
''';
SVGIcons[CSVGMusicOnWhite] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 26.99 30.99"><g id="Layer_1"><path d="M26.99,2.9v15.45c-.2,1.83-.87,3.33-2,4.5h-.1c-1.2,1.33-2.62,2.07-4.25,2.2h-.05c-1.7.17-3.12-.35-4.25-1.55-1.1-1.07-1.57-2.5-1.4-4.3.17-1.6.83-3,2-4.2,1.13-1.13,2.37-1.8,3.7-2h1.35v-5h-10v17c.07,1.27-.62,2.53-2.05,3.8l-.05.15c-1.2,1.17-2.58,1.83-4.15,2h-.05c-1.73.17-3.15-.32-4.25-1.45C.31,28.4-.16,27,.04,25.3c.13-1.67.78-3.12,1.95-4.35l.1-.05c1.1-1.07,2.3-1.73,3.6-2h.05l2.25.1V3C7.93.94,8.74-.06,10.44,0h13.55c2,0,3,.97,3,2.9" fill="#fff"/></g></svg>
''';
SVGIcons[CSVGPauseBlack] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 28 32"><g id="Layer_1"><path d="M28,2v28c0,.57-.2,1.05-.6,1.45-.4.37-.87.55-1.4.55h-8c-.57,0-1.05-.18-1.45-.55-.37-.4-.55-.88-.55-1.45V2.05c0-.57.18-1.05.55-1.45.4-.4.88-.6,1.45-.6h8c.53,0,1,.2,1.4.6s.6.87.6,1.4M11.4.6c.4.4.6.87.6,1.4v28c0,.57-.2,1.05-.6,1.45-.4.37-.87.55-1.4.55H2c-.57,0-1.05-.18-1.45-.55-.37-.4-.55-.88-.55-1.45V2.05c0-.57.18-1.05.55-1.45.4-.4.88-.6,1.45-.6h8c.53,0,1,.2,1.4.6"/></g></svg>
''';
SVGIcons[CSVGPauseWhite] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 28 32"><g id="Layer_1"><path d="M28,2v28c0,.57-.2,1.05-.6,1.45-.4.37-.87.55-1.4.55h-8c-.57,0-1.05-.18-1.45-.55-.37-.4-.55-.88-.55-1.45V2.05c0-.57.18-1.05.55-1.45.4-.4.88-.6,1.45-.6h8c.53,0,1,.2,1.4.6s.6.87.6,1.4M11.4.6c.4.4.6.87.6,1.4v28c0,.57-.2,1.05-.6,1.45-.4.37-.87.55-1.4.55H2c-.57,0-1.05-.18-1.45-.55-.37-.4-.55-.88-.55-1.45V2.05c0-.57.18-1.05.55-1.45.4-.4.88-.6,1.45-.6h8c.53,0,1,.2,1.4.6" fill="#fff"/></g></svg>
''';
SVGIcons[CSVGSoudsOffBlack] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 32"><g id="Layer_1"><path d="M18,0c.53,0,1,.2,1.4.6s.6.87.6,1.4v28c0,.57-.2,1.05-.6,1.45-.4.37-.87.55-1.4.55h-2l-12-12H0v-8h4L16,0h2"/></g></svg>
''';
SVGIcons[CSVGSoundsOffWhite] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 32"><g id="Layer_1"><path d="M18,0c.53,0,1,.2,1.4.6s.6.87.6,1.4v28c0,.57-.2,1.05-.6,1.45-.4.37-.87.55-1.4.55h-2l-12-12H0v-8h4L16,0h2" fill="#fff"/></g></svg>
''';
SVGIcons[CSVGSoundsOnBlack] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 31.95 32"><g id="Layer_1"><path d="M24.8,10.05l2.3-3.3,1.5,1.3.05.05c2.2,2.23,3.3,4.92,3.3,8.05s-1.1,5.85-3.3,8.05l-.1.1-1.45,1.25-2.3-3.3.9-.75.05-.05c1.47-1.47,2.2-3.23,2.2-5.3s-.73-3.78-2.2-5.25l-.05-.1-.9-.75M18,0c.53,0,1,.2,1.4.6s.6.87.6,1.4v28c0,.57-.2,1.05-.6,1.45-.4.37-.87.55-1.4.55h-2l-12-12H0v-8h4L16,0h2"/></g></svg>
''';
SVGIcons[CSVGSoundsOnWhite] := '''
<?xml version="1.0" encoding="UTF-8"?><svg id="Calque_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 31.95 32"><g id="Layer_1"><path d="M24.8,10.05l2.3-3.3,1.5,1.3.05.05c2.2,2.23,3.3,4.92,3.3,8.05s-1.1,5.85-3.3,8.05l-.1.1-1.45,1.25-2.3-3.3.9-.75.05-.05c1.47-1.47,2.2-3.23,2.2-5.3s-.73-3.78-2.2-5.25l-.05-.1-.9-.75M18,0c.53,0,1,.2,1.4.6s.6.87.6,1.4v28c0,.57-.2,1.05-.6,1.45-.4.37-.87.55-1.4.55h-2l-12-12H0v-8h4L16,0h2" fill="#fff"/></g></svg>
''';

end.
