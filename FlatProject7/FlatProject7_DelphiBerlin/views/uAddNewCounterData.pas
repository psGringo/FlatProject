unit uAddNewCounterData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls, Vcl.Buttons, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids;

type
  TAddNewCounterData = class(TForm)
    seInt: TSpinEdit;
    seFrac: TSpinEdit;
    lInt: TLabel;
    Label1: TLabel;
    pBottom: TPanel;
    bOk: TBitBtn;
    bCancel: TBitBtn;
    DBGrid1: TDBGrid;
    Label2: TLabel;
    FDConnectionTemp: TFDConnection;
    qCounterData: TFDQuery;
    DSCounterData: TDataSource;
    procedure bOkClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
  private
    FCounterID: integer;
    procedure SetCounterID(const Value: integer);
    { Private declarations }

  public
    { Public declarations }
    procedure Init();
    property CounterID: integer read FCounterID write SetCounterID;
  end;

implementation

uses
  uDb, uCommon;

{$R *.dfm}

procedure TAddNewCounterData.bCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TAddNewCounterData.bOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TAddNewCounterData.Init;
begin
  FDConnectionTemp.Connected := false;
  with qCounterData do
  begin
    Connection := Db.FDCOnnection;
    params.ParamValues['counters_id'] := FCounterID;
    Disconnect();
    Open();
  end;
  seInt.Value := trunc(qCounterData.FieldByName('value').AsFloat);
  seFrac.Value := TCommon.GetRestOfFloat(qCounterData.FieldByName('value').AsFloat);
end;

procedure TAddNewCounterData.SetCounterID(const Value: integer);
begin
  FCounterID := Value;
end;

end.

