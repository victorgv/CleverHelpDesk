unit uTParentForm;

interface

uses
  FMX.Forms, System.UITypes, System.SysUtils;

// Clase base FORMULARIO a partir de la cual heredan todos los otros formularios, nos permite implementar
// métodos o funcionalidades comunes a todos los formularios de la aplicación.
type
  TParentForm = class(TForm)
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
      FSuccProc: TProc<TModalResult>;
  public
      procedure RunFormAsModal(const ResultProc: TProc<TModalResult>);
  end;

implementation

{ TSuperForm }

procedure TParentForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FSuccProc) then
  begin
    FSuccProc(ModalResult);
    FSuccProc:= nil;
  end;
end;

procedure TParentForm.RunFormAsModal(const ResultProc: TProc<TModalResult>);
begin
  FSuccProc:= ResultProc;
  {$IF DEFINED(Win64) or DEFINED(Win32)}
  ShowModal;
  {$ELSE}
  Self.Show;
  {$ENDIF}
end;

end.
