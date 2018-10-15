program FlatProject;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {MainForm},
  uDb in 'uDb.pas' {Db: TDataModule},
  uFlatsFrame in 'views\uFlatsFrame.pas' {FlatsFrame: TFrame},
  uCountersFrame in 'views\uCountersFrame.pas' {CountersFrame: TFrame},
  uAddEditCounterForm in 'views\uAddEditCounterForm.pas' {AddEditCounterForm},
  uCounter in 'models\uCounter.pas',
  uCountersController in 'controllers\uCountersController.pas',
  uAddNewCounterData in 'views\uAddNewCounterData.pas' {AddNewCounterData},
  uCommon in 'uCommon.pas' {Common: TDataModule},
  uFlat in 'models\uFlat.pas',
  uHouseNumber in 'models\uHouseNumber.pas',
  uFLatCounter in 'models\uFLatCounter.pas',
  uStreet in 'models\uStreet.pas',
  uCountersUpdateHistory in 'models\uCountersUpdateHistory.pas',
  uCounterData in 'models\uCounterData.pas',
  uChangeCountersHistoryForm in 'views\uChangeCountersHistoryForm.pas' {ChangeCountersHistoryForm},
  Vcl.Themes,
  Vcl.Styles,
  LDSLogger in 'LDSLogger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Turquoise Gray');
  Application.CreateForm(TDb, Db);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

