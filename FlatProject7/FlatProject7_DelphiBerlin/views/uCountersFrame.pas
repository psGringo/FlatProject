unit uCountersFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons;

type
  TCountersFrame = class(TFrame)
    DBGrid: TDBGrid;
    FDConnectionTemp: TFDConnection;
    tbit: TPanel;
    qFlatNumbers: TFDQuery;
    qCounters: TFDQuery;
    qHouseNumbers: TFDQuery;
    qStreets: TFDQuery;
    bAdd: TBitBtn;
    bEdit: TBitBtn;
    bDelete: TBitBtn;
    DSCounters: TDataSource;
    pCountersToCheck: TPanel;
    cbStreets: TDBLookupComboBox;
    cbHouseNumbers: TDBLookupComboBox;
    lStreets: TLabel;
    lHouseNumbers: TLabel;
    bFilter: TButton;
    bFlushFilter: TButton;
    DSStreets: TDataSource;
    DSHouseNumbers: TDataSource;
    qCountersFilter: TFDQuery;
    bAddNewData: TBitBtn;
    procedure bAddClick(Sender: TObject);
    procedure bEditClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure cbStreetsCloseUp(Sender: TObject);
    procedure cbHouseNumbersCloseUp(Sender: TObject);
    procedure bFilterClick(Sender: TObject);
    procedure bFlushFilterClick(Sender: TObject);
    procedure bAddNewDataClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init();
  end;

implementation

{$R *.dfm}

uses
  uAddEditCounterForm, //
  uDB, //
  uCounter, //
  uCountersController, //
  uAddNewCounterData, //
  uCommon, //
  uFlatCounter, //
  uCountersUpdateHistory, uFlat; //

procedure TCountersFrame.bAddClick(Sender: TObject);
var
  c: TCounter;
  f: TAddEditCounterForm;
  fc: TFLatCounter;
  fcChosen: TFLatCounter;
  counterId: Integer;
  flatChosen: TFlat;
begin
  flatChosen := TFlat.Create(Self);
  f := TAddEditCounterForm.Create(Self);
  c := TCounter.Create(Self);
  try
    f.Init();
    with f do
    begin
      // update view
     // eSerialNumber.Text := fc.Counter.SerialNumber;
      dtpLast.DateTime := Now(); // fc.Counter.LastCheckDate;
      dtpNext.DateTime := Now(); //fc.Counter.NextCheckDate;
      if f.ShowModal = mrOk then
      begin
      // updating model
        c.SerialNumber := eSerialNumber.Text;
        c.LastCheckDate := dtpLast.DateTime;
        c.NextCheckDate := dtpNext.DateTime;
        counterId := TCountersController.InsertCounter(c);
        c.Id := counterId;
        //
        if f.cbIsAssociateToFlat.Checked then
        begin
          fc := TCountersController.GetAssociationToFlat(counterId);
          flatChosen.Id := f.qFlatNumbers.FieldByName('id').AsInteger;
          fcChosen := TCountersController.GetAssociationToCounter(flatChosen);
          TCountersController.AssociateFlatToCounter(fc, fcChosen);
        // associating flat and counter
        end;
      end;
      qCounters.Disconnect();
      qCounters.Open();
      DSCounters.DataSet := qCounters;
    end;
  finally
    c.Free();
    flatChosen.Free();
    fc.Free();
    fcChosen.Free();
    f.Free();
    fc.Free(); // << Error here
  end;

 {
  f := TAddEditCounterForm.Create(Self);
  f.Init();
  c := TCounter.Create(Self);
  fh := TFLatCounter.Create(Self);
  h := TCountersUpdateHistory.Create(Self);
  try
    if f.ShowModal = mrOK then
    begin
      // updating model
      c.SerialNumber := f.eSerialNumber.Text;
      c.LastCheckDate := f.dtpLast.DateTime;
      c.NextCheckDate := f.dtpNext.DateTime;
      c.Id := TCountersController.InsertCounter(c); //


      // association to flat
      if f.cbIsAssociateToFlat.Checked then
      begin
        fh.Flat.Id := f.qFlatNumbers.FieldByName('id').AsInteger;
        fh.Counter.Id := c.Id;
//        TCountersController.AssociateFlatToCounter(fh);
        // add history
        h.CounterNew := c;
        h.Flat.Id := f.qFlatNumbers.FieldByName('id').AsInteger;
        h.CounterOld.Id := -1; // no old counter
        TCountersController.LogAssociatonFlatToCounter(h);
      end;
      //updating dataset
      qCounters.Disconnect();
      qCounters.Open();
      DSCounters.DataSet := qCounters;
    end;
  finally
    f.Free();
    c.Free();
    fh.Free();
    h.Free();
  end;
}

end;

procedure TCountersFrame.bAddNewDataClick(Sender: TObject);
var
  f: TAddNewCounterData;
  newValue: double;
begin
  f := TAddNewCounterData.Create(Self);
  try
    f.CounterID := qCounters.FieldByName('id').AsInteger;
    f.Init();
    if f.ShowModal = mrOk then
    begin
      newValue := TCommon.GetDoubleFromIntAndFrac(f.seInt.Value, f.seFrac.Value);
       // insert new record
      if (not TCountersController.IsNewValueOk(f.CounterID, newValue)) then
      begin
        Application.MessageBox('Íîâîå çíà÷åíèå äîëæíî áûòü áîëüøå ïðåäûäóùåãî', //
          'Ñîîáùåíèå ñèñòåìû', MB_OK + MB_ICONSTOP);
        exit;
      end;
      TCountersController.InsertCounterData(f.CounterID, newValue);
      qCounters.Disconnect();
      qCounters.Open();
    end;
  finally
    f.Free();
  end;
end;

procedure TCountersFrame.bDeleteClick(Sender: TObject);
var
  buttonSelected: Integer;
begin
  case Application.MessageBox('Óäàëèòü ñ÷åò÷èê è âñå åãî äàííûå?', 'Ñîîáùåíèå ñèñòåìû', MB_YESNO + MB_ICONQUESTION) of
    IDYES:
      begin
        TCountersController.Delete(qCounters.FieldByName('id').AsInteger);
        qCounters.Disconnect();
        qCounters.Open();
        DSCounters.DataSet := qCounters;
      end;
    IDNO:
      begin
        Exit();
      end;
  end;
end;

procedure TCountersFrame.bEditClick(Sender: TObject);
var
  c: TCounter;
  f: TAddEditCounterForm;
  fc: TFLatCounter;
  fcChosen: TFLatCounter;
  anotherCounterId: integer;
  counterId: Integer;
  flatChosen: TFlat;
begin
  flatChosen := TFlat.Create(Self);
  f := TAddEditCounterForm.Create(Self);
  try
    f.Init();
    // ïðîâåðÿåì àññîöèàöèþ ñ÷åò÷èêà ñ êâàðòèðîé
    counterId := qCounters.FieldByName('id').AsInteger;
    fc := TCountersController.GetAssociationToFlat(counterId);
    if (not fc.IsAssociated) then
      fc.Counter := TCountersController.GetCounter(counterId); // if no association
    if fc.IsAssociated then
    begin
      // Çàïîëíÿåì ñïèñêè
      f.cbIsAssociateToFlat.Checked := true;
      f.cbStreets.KeyValue := fc.Street.Id;
      // äîìà
      f.LoadHouseNumbersInList(fc.Street.Id);
      f.cbHouseNumbers.KeyValue := fc.HouseNumber.Id;
      // êâàðòèðû
      f.LoadFlatsInList(fc.HouseNumber.Id);
      f.cbFlatNumbers.KeyValue := fc.Flat.Id;
    end;
    with f do
    begin
      // update view
      eSerialNumber.Text := fc.Counter.SerialNumber;
      dtpLast.DateTime := fc.Counter.LastCheckDate;
      dtpNext.DateTime := fc.Counter.NextCheckDate;
      if f.ShowModal = mrOk then
      begin
      // updating model from view
        fc.Counter.SerialNumber := eSerialNumber.Text;
        fc.Counter.LastCheckDate := dtpLast.DateTime;
        fc.Counter.NextCheckDate := dtpNext.DateTime;
        TCountersController.Update(fc.Counter, qCounters.FieldByName('id').AsInteger);
        // associating flat and counter
        if f.cbIsAssociateToFlat.Checked then
        begin
          flatChosen.Id := f.qFlatNumbers.FieldByName('id').AsInteger;
          fcChosen := TCountersController.GetAssociationToCounter(flatChosen);
          TCountersController.AssociateFlatToCounter(fc, fcChosen);
        end
        else if (not f.cbIsAssociateToFlat.Checked) and (fc.IsAssociated) then
        begin
          // brake association
          TCountersController.BrakeAssociation(fc);
        end;
      end;
      qCounters.Disconnect();
      qCounters.Open();
      DSCounters.DataSet := qCounters;
    end;
  finally
    flatChosen.Free();
    f.Free();
    fc.Free();
    fcChosen.Free();
  end;
end;

procedure TCountersFrame.bFilterClick(Sender: TObject);
begin
  with qCountersFilter do
  begin
    Connection := Db.FDConnection;
    params.ParamValues['streetId'] := qStreets.FieldByName('id').AsInteger;
    params.ParamValues['houseNumberId'] := qHouseNumbers.FieldByName('id').AsInteger;
    Disconnect();
    Open();
    DSCounters.DataSet := qCountersFilter;
  end;
end;

procedure TCountersFrame.bFlushFilterClick(Sender: TObject);
begin
  with qCounters do
  begin
    Connection := Db.FDConnection;
    Disconnect();
    Open();
    DSCounters.DataSet := qCounters;
  end;
end;

procedure TCountersFrame.cbHouseNumbersCloseUp(Sender: TObject);
begin
  with qHouseNumbers do
  begin
    Connection := Db.FDConnection;
    CachedUpdates := true;
    params.ParamValues['streets_id'] := qStreets.FieldByName('id').AsInteger;
    Disconnect();
    Open();
    cbHouseNumbers.KeyValue := qHouseNumbers.FieldByName('id').AsInteger;
  end;

end;

procedure TCountersFrame.cbStreetsCloseUp(Sender: TObject);
begin
  with qHouseNumbers do
  begin
    Connection := Db.FDConnection;
    CachedUpdates := true;
    params.ParamValues['streets_id'] := qStreets.FieldByName('id').AsInteger;
    Disconnect();
    Open();
    cbHouseNumbers.KeyValue := qHouseNumbers.FieldByName('id').AsInteger;
  end;
end;

procedure TCountersFrame.Init;
begin
  FDConnectionTemp.Connected := false;
  with qCounters do
  begin
    Connection := Db.FDConnection;
    CachedUpdates := true;
    Disconnect();
    Open();
  end;
  with qStreets do
  begin
    Connection := Db.FDConnection;
    CachedUpdates := true;
    Disconnect();
    Open();
    cbStreets.KeyValue := qStreets.FieldByName('id').AsInteger;
  end;
  with qHouseNumbers do
  begin
    Connection := Db.FDConnection;
    CachedUpdates := true;
    params.ParamValues['streets_id'] := qStreets.FieldByName('id').AsInteger;
    Disconnect();
    Open();
    cbHouseNumbers.KeyValue := qHouseNumbers.FieldByName('id').AsInteger;
  end;
end;

end.

