unit ufmLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, uTParentForm,
  FMX.ExtCtrls, FMX.ListBox;

type
  TfmLogin = class(TParentForm)
    Layout1: TLayout;
    ed_userName: TEdit;
    ed_password: TEdit;
    Rectangle1: TRectangle;
    sb_Login: TSpeedButton;
    LA_INFO: TLabel;
    MailImage: TImage;
    LockImage: TImage;
    TitleText: TText;
    Layout2: TLayout;
    sb_Forgot_Password: TSpeedButton;
    Layout3: TLayout;
    pb_selector_idioma: TPopupBox;
    procedure sb_LoginClick(Sender: TObject);
    procedure pb_selector_idiomaChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function validate_fields: boolean;
  public
    { Public declarations }
    constructor create(AOwner: TComponent);
  end;


implementation

uses udmCore, System.JSON, REST.Types;

{$R *.fmx}

constructor TfmLogin.create(AOwner: TComponent);
begin
  inherited;
  pb_selector_idioma.ItemIndex := pb_selector_idioma.Items.IndexOf(dmCore.idiomas.lang);
  LA_INFO.text := '';
end;

procedure TfmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Al salir del login sin tener sesión activa finalizamos la aplicación
  if not Assigned(dmCore.CommunicationManager.ClientSession) then
    Application.Terminate;
end;

procedure TfmLogin.pb_selector_idiomaChange(Sender: TObject);
begin
  dmCore.SetLanguage(pb_selector_idioma.Text);
end;

procedure TfmLogin.sb_LoginClick(Sender: TObject);
var
  respuestaJSON: TJSONValue;
begin
  if validate_fields then
  begin
    if dmCore.CommunicationManager.DoRequestAuth(ed_userName.text, ed_password.Text) then
    begin

      dmCore.CommunicationManager.DoRequestGet('/user/',  dmCore.CommunicationManager.ClientSession.UserName ,respuestaJSON);
      ShowMessage(respuestaJSON.ToString);

      Close;
    end
    else
    begin
      LA_INFO.TextSettings.FontColor := TAlphaColorRec.Red;
      LA_INFO.Text := dmCore.getAppMessage('MSG0004');
    end;
  end;
end;

// Valida que se ha introducido un email o passw correcto
function TfmLogin.validate_fields: boolean;
begin
  if ed_userName.Text.Trim.Length = 0 then // Valida que se ha introducido algo en userName
  begin
    result := false;
    LA_INFO.TextSettings.FontColor := TAlphaColorRec.Red;
    LA_INFO.Text := dmCore.getAppMessage('MSG0001');
    ed_userName.SetFocus;
  end
  else if ed_password.Text.Trim.Length = 0 then
  begin
    result := false;
    LA_INFO.TextSettings.FontColor := TAlphaColorRec.Red;
    LA_INFO.Text := dmCore.getAppMessage('MSG0003'); // Valida que se haya introducido algo en el campo "password"
    ed_password.SetFocus;
  end
  else
  begin
    result := true;
    LA_INFO.Text := '';
  end;

end;

end.
