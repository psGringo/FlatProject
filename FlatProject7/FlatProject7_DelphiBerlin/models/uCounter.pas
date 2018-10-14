unit uCounter;

interface

uses
  System.Classes, uCounterData;

type
  TCounter = class(TComponent)
  private
    FNextCheckDate: TDateTime;
    FSerialNumber: string;
    FLastCheckDate: TDateTime;
    FId: integer;
    FCounterDataLastRecord: TCounterData;
    procedure SetLastCheckDate(const Value: TDateTime);
    procedure SetNextCheckDate(const Value: TDateTime);
    procedure SetSerialNumber(const Value: string);
    procedure SetId(const Value: integer);
    procedure SetCounterDataLastRecord(const Value: TCounterData);
  { private declarations }
  protected
  { protected declarations }
  public
  { public declarations }
    constructor Create(AOwner: TComponent); override;
    property Id: integer read FId write SetId;
    property SerialNumber: string read FSerialNumber write SetSerialNumber;
    property LastCheckDate: TDateTime read FLastCheckDate write SetLastCheckDate;
    property NextCheckDate: TDateTime read FNextCheckDate write SetNextCheckDate;
    property CounterDataLastRecord: TCounterData read FCounterDataLastRecord write SetCounterDataLastRecord;
  published
  { published declarations }
  end;

implementation

{ TCounter }

constructor TCounter.Create(AOwner: TComponent);
begin
  inherited;
  FCounterDataLastRecord := TCounterData.Create(Self);
end;

procedure TCounter.SetCounterDataLastRecord(const Value: TCounterData);
begin
  FCounterDataLastRecord := Value;
end;

procedure TCounter.SetId(const Value: integer);
begin
  FId := Value;
end;

procedure TCounter.SetLastCheckDate(const Value: TDateTime);
begin
  FLastCheckDate := Value;
end;

procedure TCounter.SetNextCheckDate(const Value: TDateTime);
begin
  FNextCheckDate := Value;
end;

procedure TCounter.SetSerialNumber(const Value: string);
begin
  FSerialNumber := Value;
end;

end.

