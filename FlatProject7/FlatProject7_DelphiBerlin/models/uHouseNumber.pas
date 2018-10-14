unit uHouseNumber;

interface

uses
  System.Classes;

type
  THouseNumber = class(TComponent)
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

{ THouseNumber }

procedure THouseNumber.SetId(const Value: integer);
begin
  FId := Value;
end;

procedure THouseNumber.SetName(const Value: string);
begin
  FName := Value;
end;

end.

