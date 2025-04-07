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
/// File last update : 2025-04-07T08:49:27.734+02:00
/// Signature : d24afc7518d87e8f17ed17048b749184d0289e60
/// ***************************************************************************
/// </summary>

program LevelEditor;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  fMain in 'fMain.pas' {frmMain},
  uGameLevel in '..\src\uGameLevel.pas',
  Olf.Skia.SVGToBitmap in '..\lib-externes\librairies\src\Olf.Skia.SVGToBitmap.pas',
  USVGIcons in '..\assets\Kenney.nl\Game Icons\Icons\USVGIcons.pas',
  USVGJumperPack in '..\assets\Kenney.nl\Jumper Pack\JumperPack\USVGJumperPack.pas',
  USVGPhysicsAssets in '..\assets\Kenney.nl\Physics Assets\PhysicsAssets\USVGPhysicsAssets.pas',
  USVGWall in '..\assets\Kenney.nl\Platformer Assets Tile Extensions\Wall\USVGWall.pas',
  USVGCharacters in '..\assets\Kenney.nl\Platformer Characters 1\Characters\USVGCharacters.pas',
  uSVGBitmapManager_InputPrompts in '..\src\uSVGBitmapManager_InputPrompts.pas',
  USVGInputPrompts in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\assets\kenney_nl\InputPrompts\USVGInputPrompts.pas',
  USVGDoors in '..\_PRIVATE\assets\AdobeStock\AdobeStock_90592983\Doors\USVGDoors.pas',
  USVGPlatformerAssetsBase in '..\assets\Kenney.nl\Platformer Assets Base\PlatformerAssetsBase\USVGPlatformerAssetsBase.pas',
  uSprites in '..\src\uSprites.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
