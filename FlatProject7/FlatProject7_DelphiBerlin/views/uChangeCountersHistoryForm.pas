unit uChangeCountersHistoryForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TChangeCountersHistoryForm = class(TForm)
    FDConnectionTemp: TFDConnection;
    qHistory: TFDQuery;
    DSHistory: TDataSource;
    DBGrid: TDBGrid;
  private
    FFlatID: integer;
    procedure SetFlatID(const Value: integer);
    { Private declarations }
  public
    { Public declarations }
    property FlatID: integer read FFlatID write SetFlatID;
    procedure Init;
  end;

implementation

{$R *.dfm}

uses
  uDb;

{ TChangeCountersHistoryForm }

procedure TChangeCountersHistoryForm.Init;
begin
  FDConnectionTemp.Connected := false;
  with qHistory do
  begin
    Connection := db.FDConnection;
    params.ParamValues['flats_id'] := FFlatID;
    Disconnect();
    Open();
  end;
end;

procedure TChangeCountersHistoryForm.SetFlatID(const Value: integer);
begin
  FFlatID := Value;
end;

end.

