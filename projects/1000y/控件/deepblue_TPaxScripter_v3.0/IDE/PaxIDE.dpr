program PaxIDE;

uses
  ShareMem,
{$IFDEF LINUX}
  QForms,
{$ELSE}
  Forms,
{$ENDIF}
  fmMain in 'fmMain.pas' {FormMain},
  fmAbout in 'fmAbout.pas' {FormAbout},
  fmCompiling in 'fmCompiling.pas' {Compiling},
  fmConsole in 'fmConsole.pas' {FormConsole},
  fmDelete in 'fmDelete.pas' {FormDelete},
  fmNewProject in 'fmNewProject.pas' {FormNew},
  fmExplorer;

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TCompiling, Compiling);
  Application.CreateForm(TFormConsole, FormConsole);
  Application.CreateForm(TFormDelete, FormDelete);
  Application.CreateForm(TFormNew, FormNew);
  Application.Run;
end.
