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
  USVGDoors in '..\_PRIVATE\assets\AdobeStock\AdobeStock_90592983\Doors\USVGDoors.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
