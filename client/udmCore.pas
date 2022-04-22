unit udmCore;

interface

uses
  System.SysUtils,
  System.Classes,
  System.UITypes,
  Vcl.ExtCtrls,
  ufmLogin, FMX.Types;

type
  TdmCore = class(TDataModule)
    ti_userAuthenticated: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure ti_userAuthenticatedTimer(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    fUserAuthenticated: Boolean;
    fFmLogin: TfmLogin;
  public
    { Public declarations }
  end;

var
  dmCore: TdmCore;

implementation


{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TdmCore }
procedure TdmCore.DataModuleCreate(Sender: TObject);
begin
  fFmLogin := NIL;
end;

// TIMER que fuerzar el LOGIN si el usuario no está logeado o ha cerrado sesión
procedure TdmCore.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(fFmLogin);
end;

procedure TdmCore.ti_userAuthenticatedTimer(Sender: TObject);
var
  vModalResult: TModalResult;
begin
  // Si el usuario no está autenticado y el formulario de login ya está abierto abrimos pantalla LOGIN
  if (not fUserAuthenticated) AND (NOT Assigned(fFmLogin)) then
  begin
    fFmLogin := TfmLogin.Create(nil);
    fFmLogin.RunFormAsModal(procedure(pModalResult: TModalResult)  // Modal http://docwiki.embarcadero.com/RADStudio/Sydney/en/Using_FireMonkey_Modal_Dialog_Boxes
      begin
        vModalResult := pModalResult;
      end
    );
  end;
end;

end.
