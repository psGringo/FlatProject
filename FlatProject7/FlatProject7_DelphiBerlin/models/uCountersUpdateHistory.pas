unit uCountersUpdateHistory;

interface

uses
  System.Classes, uFlat, uCounter, uCounterData;

type
  TCountersUpdateHistory = class(TComponent)
  private
    FCounterOld: TCounter;
    FCounter: TCounter;
    FId: integer;
    FFlat: TFlat;
    procedure SetCounter(const Value: TCounter);
    procedure SetCounterOld(const Value: TCounter);
    procedure SetFlat(const Value: TFlat);
    procedure SetId(const Value: integer);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property Id: integer read FId write SetId;
    property CounterOld: TCounter read FCounterOld write SetCounterOld;
    property Counter: TCounter read FCounter write SetCounter;
    property Flat: TFlat read FFlat write SetFlat;
  end;

implementation

{ TCountersUpdateHistory }

constructor TCountersUpdateHistory.Create(AOwner: TComponent);
begin
  inherited;
  FCounterOld := TCounter.Create(Self);
  FCounter := TCounter.Create(Self);
  FFlat := TFlat.Create(Self);
end;

procedure TCountersUpdateHistory.SetCounter(const Value: TCounter);
begin
  FCounter := Value;
end;

procedure TCountersUpdateHistory.SetCounterOld(const Value: TCounter);
begin
  FCounterOld := Value;
end;

procedure TCountersUpdateHistory.SetFlat(const Value: TFlat);
begin
  FFlat := Value;
end;

procedure TCountersUpdateHistory.SetId(const Value: integer);
begin
  FId := Value;
end;

end.

