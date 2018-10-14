unit uCounterData;

interface

uses
  System.Classes;

type
  TCounterData = class(TComponent)
  private
    FMeasureDateTime: TDateTime;
    FId: integer;
    FValue: double;
    FCounterId: integer;
    procedure SetCounterId(const Value: integer);
    procedure SetId(const Value: integer);
    procedure SetMeasureDateTime(const Value: TDateTime);
    procedure SetValue(const Value: double);
  protected
  public
    property Id: integer read FId write SetId;
    property CounterId: integer read FCounterId write SetCounterId;
    property Value: double read FValue write SetValue;
    property MeasureDateTime: TDateTime read FMeasureDateTime write SetMeasureDateTime;
  end;

implementation

{ TCounterData }

procedure TCounterData.SetCounterId(const Value: integer);
begin
  FCounterId := Value;
end;

procedure TCounterData.SetId(const Value: integer);
begin
  FId := Value;
end;

procedure TCounterData.SetMeasureDateTime(const Value: TDateTime);
begin
  FMeasureDateTime := Value;
end;

procedure TCounterData.SetValue(const Value: double);
begin
  FValue := Value;
end;

end.

