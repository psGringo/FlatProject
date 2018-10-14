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
  uCountersUpdateHistory; //

procedure TCountersFrame.bAddClick(Sender: TObject);
var
  f: TAddEditCounterForm;
  c: TCounter;
  fh: TFLatCounter;
  h: TCountersUpdateHistory;
begin
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
        TCountersController.AssociateFlatToCounter(fh);
        // add history
        h.Counter := c;
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
        Application.MessageBox('����� �������� ������ ���� ������ �����������', //
          '��������� �������', MB_OK + MB_ICONSTOP);
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
  case Application.MessageBox('������� ������� � ��� ��� ������?', '��������� �������', MB_YESNO + MB_ICONQUESTION) of
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
  oldC: TCounter;
  f: TAddEditCounterForm;
  fc: TFLatCounter;
  h, h2: TCountersUpdateHistory;
  anotherCounterId: integer;
  counterId: Integer;
  anotherFlatId: integer;
begin
  // current counterId
  counterId := qCounters.FieldByName('id').AsInteger;
  //
  c := TCountersController.GetCounter(counterId);
  f := TAddEditCounterForm.Create(Self);
  h := TCountersUpdateHistory.Create(Self);
  h2 := TCountersUpdateHistory.Create(Self);
  oldC := nil;
  fc := nil;
  try
    f.Init();
    // ��������� ���������� �������� � ���������
    fc := TCountersController.GetAssociationToFlat(c);
    if fc.IsFlatCounterAssociated then
    begin
      f.cbIsAssociateToFlat.Checked := true;
      f.cbStreets.KeyValue := fc.Street.Id;
      // ����
      f.LoadHouseNumbersInList(fc.Street.Id);
      f.cbHouseNumbers.KeyValue := fc.HouseNumber.Id;
      // ��������
      f.LoadFlatsInList(fc.HouseNumber.Id);
      f.cbFlatNumbers.KeyValue := fc.Flat.Id;
      // ��� ���� ������
      h.Counter := c; // new counter
    end;
    with f do
    begin
      // update view
      eSerialNumber.Text := c.SerialNumber;
      dtpLast.DateTime := c.LastCheckDate;
      dtpNext.DateTime := c.NextCheckDate;
      if f.ShowModal = mrOk then
      begin
      // ��������� ������ �������� �� �������������
        c.SerialNumber := eSerialNumber.Text;
        c.LastCheckDate := dtpLast.DateTime;
        c.NextCheckDate := dtpNext.DateTime;
        TCountersController.Update(c, qCounters.FieldByName('id').AsInteger);
        qCounters.Disconnect();
        qCounters.Open();
        DSCounters.DataSet := qCounters;
        // log in history
        // take counter from new flat - this will be old counter in our model
        // if new counter for this flat
        if f.qFlatNumbers.FieldByName('counters_id').IsNull then
          anotherCounterId := -1
        else
          anotherCounterId := f.qFlatNumbers.FieldByName('counters_id').AsInteger;
        // ���� ������� ������ �������� - ����������� ������� � ����� ���������
        // ���������
        if ((anotherCounterId <> c.id) and (f.cbIsAssociateToFlat.Checked)) then
        begin
          // updating association
          anotherFlatId := f.qFlatNumbers.FieldByName('id').AsInteger;
         // C�����
         // 1) ������� ������� ��� ������������ � ���������, � � ���������
         // �������� ��� ���� ��������������� �������, ����� ����������
         // �� �������� �������
          if (fc.IsFlatCounterAssociated) //
            and (TCountersController.IsFlatHasCounter(anotherFlatId)) then //
          begin
            case Application.MessageBox('� ��������� �������� ��� ���� ������ �������. �������� �������� �������?', '��������� �������', MB_YESNO + MB_ICONQUESTION) of
              IDYES:
                begin
                  // exchange counters in flats
                  TCountersController.ExchangeCountersInFlats(c.id, anotherCounterId);
                  // ���������� ������� ������ ������ ��������
                  oldC := TCountersController.GetCounter(anotherCounterId);
                  h.CounterOld := oldC;
                  h.Flat.Id := f.qFlatNumbers.FieldByName('id').AsInteger;
                  TCountersController.LogAssociatonFlatToCounter(h);
                  // � ������ ��������
                  h2.Counter := oldC;
                  h2.CounterOld := c;
                  h2.Flat.Id := fc.Flat.Id;
                  TCountersController.LogAssociatonFlatToCounter(h2);
                end;
              IDNO:
                begin
                  exit;
                end;
            end;
          end
          else
         // 2) ������� ������� �� ������������ � ���������,
         // � ��������� �������� ��� ���� �������, ����� ����������
         // ������������
if (not fc.IsFlatCounterAssociated) //
  and (TCountersController.IsFlatHasCounter(anotherFlatId)) then //
          begin
            case Application.MessageBox('� ��������� �������� ��� ���� �������, ������������ �������?', '��������� �������', MB_YESNO + MB_ICONQUESTION) of
              IDYES:
                begin
                  // rewrite counter un another flat
                  TCountersController.UpdateCounterInFlat(c.Id, anotherFlatId);
                  // ���������� ������� ������ ���������
                  oldC := TCountersController.GetCounter(anotherCounterId);
                  h.CounterOld := oldC;
                  h.Counter := c;
                  h.Flat.Id := f.qFlatNumbers.FieldByName('id').AsInteger;
                  TCountersController.LogAssociatonFlatToCounter(h);
                end;
              IDNO:
                begin
                  exit;
                end;
            end;

          end
          //3) ������� ������� �� ������������ � ���������,
          //� ��������� �������� ��� ��������, ����� ������ ����������
          else if (not TCountersController.IsCounterAssociated(counterId)) //
            and (not TCountersController.IsFlatHasCounter(fc.Flat.Id)) then //
          begin
            //TCountersController.AssociateFlatToCounter(fc);
            TCountersController.UpdateCounterInFlat(c.Id, anotherFlatId);
          // ���������� ������� ������ ���������
            h.Counter := c;
            if anotherCounterId = -1 then
              oldC := nil
            else
              oldC := TCountersController.GetCounter(anotherCounterId);
            h.CounterOld := oldC;
            h.Flat.Id := f.qFlatNumbers.FieldByName('id').AsInteger;
            TCountersController.LogAssociatonFlatToCounter(h);
          end;
        end;
      end;
      qCounters.Disconnect();
      qCounters.Open();
    end;
  finally
    c.Free;
    f.Free();
    h.Free();
    if oldC <> nil then
      oldC.Free();
    if fc <> nil then
      fc.Free();
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
