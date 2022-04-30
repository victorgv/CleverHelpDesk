unit uTParentForm;

interface

uses
  FMX.Forms,
  System.UITypes,
  System.SysUtils, System.Classes;

// Clase base FORMULARIO a partir de la cual heredan todos los otros formularios, nos permite implementar
// métodos o funcionalidades comunes a todos los formularios de la aplicación.
type
  TParentForm = class(TForm)
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      //procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
      FSuccProc: TProc<TModalResult>;
  public
      procedure RunFormAsModal(const ResultProc: TProc<TModalResult>);
      constructor create(aowner: TComponent); virtual;
  end;

implementation

uses
  FMX.Dialogs;

{ TSuperForm }

constructor TParentForm.create(aowner: TComponent);
begin
  inherited;
end;

procedure TParentForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FSuccProc) then
  begin
    FSuccProc(ModalResult);
    FSuccProc:= nil;
  end;
end;

{procedure TParentForm.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkHardwareBack then // Captura el botón BACK de ANDROID
  begin
    close;
  end;
end;}

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
