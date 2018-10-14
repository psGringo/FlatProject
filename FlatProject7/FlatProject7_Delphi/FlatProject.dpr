program FlatProject;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {MainForm},
  uDB in 'uDB.pas' {DB: TDataModule},
  uFlatsFrame in 'uFlatsFrame.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
