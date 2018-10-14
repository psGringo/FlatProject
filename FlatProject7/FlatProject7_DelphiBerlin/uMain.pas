unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  // my
  uDb, //
  uFlatsFrame, //
  uCountersFrame, Vcl.ExtCtrls; //

type
  TMainForm = class(TForm)
    PageControl1: TPageControl;
    tsFlats: TTabSheet;
    tsCounters: TTabSheet;
    StatusBar: TStatusBar;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    FlatsFrame: TFlatsFrame;
    CountersFrame: TCountersFrame;
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited;
  ReportMemoryLeaksOnShutdown := true;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  db: TDb;
begin
  //flatsFrame
  db := Tdb.Create(Self);
  FlatsFrame := TFlatsFrame.Create(Self);
  FlatsFrame.Parent := tsFlats;
  FlatsFrame.Align := alClient;
  FlatsFrame.Init;
  FlatsFrame.Show();
  //countersFrame
  CountersFrame := TCountersFrame.Create(Self);
  CountersFrame.Parent := tsCounters;
  CountersFrame.Align := alClient;
  CountersFrame.Init;
  CountersFrame.Show();
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  StatusBar.Panels[0].Text := DateTimeToStr(Now());
end;

end.

