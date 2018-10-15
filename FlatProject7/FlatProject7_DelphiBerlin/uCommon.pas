unit uCommon;

interface

uses
  System.SysUtils, System.Classes;

type
  TCommon = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
    class function GetDoubleFromIntAndFrac(aInt, aFrac: integer): double;
    class function GetLastInsertID(): integer;
    class function GetRestOfFloat(ASomeFloat: real): integer; static;
  end;

implementation

uses
  FireDAC.Comp.Client, uDb;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
class function TCommon.GetDoubleFromIntAndFrac(aInt, aFrac: integer): double;
begin
  Result := StrToFloat((aInt.ToString)) + StrToFloat((aFrac / 100).ToString); // Целая + дробная части
end;

class function TCommon.GetLastInsertID: integer;
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  try
    with q do
    begin
      Connection := Db.FDConnection;
      sql.Text := 'select LAST_INSERT_ID() as lastId';
      Disconnect();
      Open();
      result := FieldByName('lastId').AsInteger;
      Close();
    end;
  finally
    q.Free();
  end;
end;

class function TCommon.GetRestOfFloat(ASomeFloat: real): integer;
var
  s: string;
begin
  ASomeFloat := frac(ASomeFloat);
  str(ASomeFloat: 0: 2, s);
  Result := strtoint(copy(s, pos('.', s) + 1, 6));
end;

end.

