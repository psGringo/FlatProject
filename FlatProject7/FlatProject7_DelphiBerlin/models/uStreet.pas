unit uStreet;

interface

uses
  System.Classes;

type
  TStreet = class(TComponent)
  private
    FName: string;
    FId: integer;
    procedure SetId(const Value: integer);
    procedure SetName(const Value: string);
  protected
  public
    property Id: integer read FId write SetId;
    property Name: string read FName write SetName;
  published
  end;

implementation

{ TStreet }

procedure TStreet.SetId(const Value: integer);
begin
  FId := Value;
end;

procedure TStreet.SetName(const Value: string);
begin
  FName := Value;
end;

end.

