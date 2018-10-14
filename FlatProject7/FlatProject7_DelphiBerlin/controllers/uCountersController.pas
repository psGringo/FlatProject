unit uCountersController;

interface

uses
  uCounter, //
  uFLatCounter, uCountersUpdateHistory //
; //

type
  TCountersController = class
  private
  protected
  public
    class function GetCounter(aId: integer): TCounter;
    class function InsertCounter(var aC: TCounter): integer;
    class procedure Update(aC: TCounter; aId: integer);
    class procedure Delete(aId: integer);
    //
    class procedure InsertCounterData(aCounterId: integer; aValue: double);
    class function IsNewValueOk(aCounterId: integer; aNewValue: double): boolean; static;
    class procedure AssociateFlatToCounter(var aModel: TFLatCounter);
    class procedure LogAssociatonFlatToCounter(var aModel: TCountersUpdateHistory);
    class function GetAssociationToFlat(var aModel: TCounter): TFlatCounter;
    class function IsCounterAssociated(aCounterId: integer): boolean; static;
    class function IsFlatHasCounter(aFlatId: integer): boolean; static;
    class function ExchangeCountersInFlats(aCounterId, aAnotherCounterId: integer): boolean; static;
    class procedure UpdateCounterInFlat(aCounterId: integer; aFlatId: integer);
  end;

implementation

uses
  FireDAC.Comp.Client, uDB, System.SysUtils, uCommon;

{ TCountersController }

class procedure TCountersController.AssociateFlatToCounter(var aModel: TFLatCounter);
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      sql.Text := 'UPDATE `flat_db`.`flats` SET `counters_id`=:counters_id WHERE `id`=:id;';
      params.ParamValues['counters_id'] := aModel.Counter.Id;
      params.ParamValues['id'] := aModel.Flat.Id;
      ExecSQL();
    end;
  finally
    q.Free();
  end;
end;

class procedure TCountersController.Delete(aId: integer);
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      sql.Text := 'DELETE FROM `flat_db`.`counters` WHERE `id`=:id;';
      params.ParamValues['id'] := aId;
      ExecSQL();
    end;
  finally
    q.Free();
  end;
end;

class function TCountersController.ExchangeCountersInFlats(aCounterId, aAnotherCounterId: integer): boolean;
var
  fc: TFLatCounter;
  fcAnother: TFLatCounter;
  c: TCounter;
  cAnother: TCounter;
begin
  c := TCountersController.GetCounter(aCounterId);
  cAnother := TCountersController.GetCounter(aAnotherCounterId);
  //
  fc := TCountersController.GetAssociationToFlat(c);
  fcAnother := TCountersController.GetAssociationToFlat(cAnother);
  try
    if ((fc.IsFlatCounterAssociated) and (fcAnother.IsFlatCounterAssociated)) then
    begin
      UpdateCounterInFlat(fc.Counter.Id, fcAnother.Flat.Id);
      UpdateCounterInFlat(fcAnother.Counter.Id, fc.Flat.Id);
    end;
  finally
    c.Free;
    cAnother.Free;
    fc.Free;
    fcAnother.Free;
  end;
  //

end;

class function TCountersController.GetAssociationToFlat(var aModel: TCounter): TFlatCounter;
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  result := TFlatCounter.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      sql.Text := 'SELECT ' + //
        'f.id, ' + //
        'f.flatNumber, ' + //
        'f.houseNumbers_id, ' + //
        '(select name from housenumbers where id=f.houseNumbers_id) as houseNumbersName, ' + //
        'f.counters_id, ' + //
        '(select streets_id from housenumbers where id=f.houseNumbers_id) as streetId, ' + //
        '(select name from streets where id=(select streets_id from housenumbers where id=f.houseNumbers_id)) as streetName ' + //
        'FROM flat_db.flats f ' + //
        'where f.counters_id=:counters_id';
      params.ParamValues['counters_id'] := aModel.Id;
      Disconnect();
      Open();
      if (not IsEmpty) then
      begin
        result.Counter.Id := FieldByName('counters_id').AsInteger;
        result.Flat.Id := FieldByName('id').AsInteger;
        result.Street.Id := FieldByName('streetId').AsInteger;
        result.HouseNumber.Id := FieldByName('houseNumbers_id').AsInteger;
        result.isFlatCounterAssociated := true;
      end
      else
      begin
        result.isFlatCounterAssociated := false;
        //result.Free();
        //result := nil;
      end;
      Close();
    end;
  finally
    q.Free();
  end;
end;

class function TCountersController.GetCounter(aId: integer): TCounter;
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  Result := TCounter.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      sql.Text := 'SELECT ' + //
        'c.id, ' + //
        'c.serialNumber, ' + //
        'c.lastCheckDate, ' + //
        'c.nextCheckDate, ' + //
        '(select measureDateTime from counterdata cd where ' + //
        'counters_id=1 order by id desc limit 1) as measureDateTime, ' + //
        '(select value from counterdata cd where ' + //
        'counters_id=1 order by id desc limit 1) as value ' + //
        'FROM flat_db.counters c ' + //
        'where c.id=:id; '; //;

      params.ParamValues['id'] := aId;
      Disconnect();
      Open();
      Result.Id := FieldByName('id').AsInteger;
      Result.SerialNumber := FieldByName('serialNumber').AsString;
      Result.LastCheckDate := FieldByName('lastCheckDate').AsDateTime;
      Result.NextCheckDate := FieldByName('nextCheckDate').AsDateTime;
      if not (FieldByName('value').IsNull) then
        Result.CounterDataLastRecord.Value := FieldByName('value').AsFloat;
      if not (FieldByName('measureDateTime').IsNull) then
        Result.CounterDataLastRecord.MeasureDateTime := FieldByName('measureDateTime').AsDateTime;
      Close();
    end;
  finally
    q.Free();
  end;
end;

class function TCountersController.InsertCounter(var aC: TCounter): integer;
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      sql.Text := 'INSERT INTO `flat_db`.`counters` ' + //
        '(`serialNumber`, `lastCheckDate`, `nextCheckDate`) ' + //
        'VALUES (:serialNumber, :lastCheckDate, :nextCheckDate);';
      params.ParamValues['serialNumber'] := aC.SerialNumber;
      params.ParamValues['lastCheckDate'] := FormatDateTime('yyyy-mm-dd hh:mm:ss', aC.LastCheckDate);
      params.ParamValues['nextCheckDate'] := FormatDateTime('yyyy-mm-dd hh:mm:ss', aC.NextCheckDate);
      ExecSQL();
      result := TCommon.GetLastInsertID();
    end;
  finally
    q.Free();
  end;
end;

class procedure TCountersController.InsertCounterData(aCounterId: integer; aValue: double);
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      sql.Text := 'INSERT INTO `flat_db`.`counterdata` (`counters_id`, `value`) VALUES (:counters_id, :value);';
      params.ParamValues['counters_id'] := aCounterId;
      params.ParamValues['value'] := aValue;
      ExecSQL();
    end;
  finally
    q.Free();
  end;
end;

//
class function TCountersController.IsCounterAssociated(aCounterId: integer): boolean;
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      sql.Text := 'SELECT * FROM flat_db.flats where counters_id=:counters_id';
      params.ParamValues['counters_id'] := aCounterId;
      Disconnect();
      Open();
      result := not IsEmpty;
      Close();
    end;
  finally
    q.Free();
  end;
end;

class function TCountersController.IsFlatHasCounter(aFlatId: integer): boolean;
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      sql.Text := 'SELECT * FROM flat_db.flats where id=:id';
      params.ParamValues['id'] := aFlatId;
      Disconnect();
      Open();
      result := not FieldByName('counters_id').IsNull;
      Close();
    end;
  finally
    q.Free();
  end;
end;

class function TCountersController.IsNewValueOk(aCounterId: integer; aNewValue: double): boolean;

  function getLastValue(): double;
  var
    q: TFDQuery;
  begin
    q := TFDQuery.Create(nil);
    try
      with q do
      begin
        Connection := Db.FDConnection;
        sql.Text := 'SELECT * FROM flat_db.counterdata where counters_id=:counters_id order by id desc limit 1;';
        params.ParamValues['counters_id'] := aCounterId;
        Disconnect();
        Open();
        if (IsEmpty) or (FieldByName('value').IsNull) then
          result := -1
        else
          result := FieldByName('value').AsFloat;
        Close();
      end;
    finally
      q.Free();
    end;
  end;

var
  lastValue: Double;
begin
// get last value
  lastValue := getLastValue();
  if lastValue = -1 then
    result := true; // means no values in db
  result := (aNewValue > lastValue);
end;

class procedure TCountersController.LogAssociatonFlatToCounter(var aModel: TCountersUpdateHistory);
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      if (aModel.CounterOld = nil) then // 1st add of counter to flat
      begin
        sql.Text := 'INSERT INTO `flat_db`.`countersupdatehistory` ' + //
          '(`flats_id`, `counters_id`) ' + //
          'VALUES (:flats_id, :counters_id);'; //
        params.ParamValues['flats_id'] := aModel.Flat.Id;
        params.ParamValues['counters_id'] := aModel.Counter.Id;
      end
      else
      begin
        sql.Text := 'INSERT INTO `flat_db`.`countersupdatehistory` ' + //
          '(`counterOldValue`, `flats_id`, `counters_id`, `countersOld_id`) ' + //
          'VALUES (:counterOldValue, :flats_id, :counters_id, :countersOld_id);'; //
        params.ParamValues['countersOld_id'] := aModel.CounterOld.Id;
        params.ParamValues['counterOldValue'] := aModel.CounterOld.CounterDataLastRecord.Value;
        params.ParamValues['flats_id'] := aModel.Flat.Id;
        params.ParamValues['counters_id'] := aModel.Counter.Id;
      end;
      ExecSQL();
    end;
  finally
    q.Free();
  end;
end;

class procedure TCountersController.Update(aC: TCounter; aId: integer);
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      sql.Text := 'UPDATE `flat_db`.`counters` SET `serialNumber`=:serialNumber, ' + //
        '`lastCheckDate`=:lastCheckDate, `nextCheckDate`=:nextCheckDate WHERE `id`=:id;';
      params.ParamValues['serialNumber'] := aC.SerialNumber;
      params.ParamValues['lastCheckDate'] := FormatDateTime('yyyy-mm-dd hh:mm:ss', aC.LastCheckDate);
      params.ParamValues['nextCheckDate'] := FormatDateTime('yyyy-mm-dd hh:mm:ss', aC.NextCheckDate);
      params.ParamValues['id'] := aId;
      ExecSQL();
    end;
  finally
    q.Free();
  end;
end;

class procedure TCountersController.UpdateCounterInFlat(aCounterId, aFlatId: integer);
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      sql.Text := 'UPDATE `flat_db`.`flats` SET `counters_id`=:counters_id WHERE `id`=:id;';
      params.ParamValues['counters_id'] := aCounterId;
      params.ParamValues['id'] := aFlatId;
      ExecSQL;
    end;
  finally
    q.Free();
  end;
end;

end.

