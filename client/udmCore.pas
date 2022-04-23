unit udmCore;

interface

uses
  System.SysUtils,
  System.Classes,
  System.UITypes,
  Vcl.ExtCtrls,
  ufmLogin, FMX.Types, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope,
  System.JSON,
  System.RegularExpressions;

type
  TdmCore = class(TDataModule)
    ti_userAuthenticated: TTimer;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTClient2: TRESTClient;
    RESTRequest2: TRESTRequest;
    RESTResponse2: TRESTResponse;
    la_idiomas: TLang;
    procedure DataModuleCreate(Sender: TObject);
    procedure ti_userAuthenticatedTimer(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    fUserAuthenticated: Boolean;
    fFmLogin: TfmLogin;
    fBaseURL_REST_SERVER: String; // URL base del servidor REST
    function getlocalLang: String; // Obtiene el idioma local del dispositivo (es o en cualquier otro caso devolverá en)
  public
    { Public declarations }
    property BaseURL_REST_SERVER: String read fBaseURL_REST_SERVER;
    property idiomas: TLang read la_idiomas;
    //
    procedure DoPostRequest(const p_URL_MAPPING: String; const p_JSON_BODY: String; var p_OUT_JSONValue: TJSONValue);
    function ValidateEmail(const p_email: String): boolean;
    procedure SetLanguage(const p_lang: String); // Cambia el idioma de la aplicación (por ahora "es" o "en")
    function getAppMessage(const p_msg_code: String): String; // Para recuperar mensajes de aplicación
    //
    constructor Create(AOwner: TComponent); override;
  end;

var
  dmCore: TdmCore;

implementation

uses FMX.Platform, FMX.Dialogs;


{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TdmCore }
constructor TdmCore.Create(AOwner: TComponent);
begin
  inherited;
  fBaseURL_REST_SERVER := 'http://localhost:8080';
  SetLanguage(getlocalLang); // Inicializa con el idioma "local" de la máquina ("es" o cualquier otro caso "en")
end;

procedure TdmCore.DataModuleCreate(Sender: TObject);
begin
  fFmLogin := NIL;
end;

// TIMER que fuerzar el LOGIN si el usuario no está logeado o ha cerrado sesión
procedure TdmCore.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(fFmLogin);
end;

//
procedure TdmCore.DoPostRequest(const p_URL_MAPPING: String; const p_JSON_BODY: String; var p_OUT_JSONValue: TJSONValue);
begin
  RESTClient1.BaseURL := fBaseURL_REST_SERVER+p_URL_MAPPING;
  RESTRequest1.Method := rmPOST;
  RESTRequest1.AddBody(p_JSON_BODY,ctAPPLICATION_JSON);
  RESTRequest1.Execute;
  p_OUT_JSONValue := RESTResponse1.JSONValue;
end;

// Para recuperar mensajes de aplicación
// { TODO : Extraer a otra clase y fichero con los textos. No es la mejor forma de implementarlo, pero es la opción más rápida }
function TdmCore.getAppMessage(const p_msg_code: String): String;
begin
  result := '???';
  if la_idiomas.Lang = 'es' then // *** IDIOMA ESPAÑOL
  begin
    if p_msg_code = 'MSG0001' then result := 'Email vacío'
    else if p_msg_code = 'MSG0002' then result := 'Email incorrecto'
    else if p_msg_code = 'MSG0003' then result := 'Password vacío'
    ;
  end
  else
  begin // *** IDIOMA inglés
    if p_msg_code = 'MSG0001' then result := 'Email is empty'
    else if p_msg_code = 'MSG0002' then result := 'Wrong email'
    else if p_msg_code = 'MSG0003' then result := 'Password vacío'
    ;
  end;

end;


// Obtiene el idioma local del dispositivo (es o en cualquier otro caso devolverá en)
function TdmCore.getlocalLang: String;
var
  localeSrv: IFMXLocaleService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXLocaleService, localeSrv) then // Verifica si para la plataforma soporta esta consulta
  begin
    Result := localeSrv.GetCurrentLangID; // Devuelve el ID de idioma
  end;

  if Result <> 'es' then
    Result := 'en'; // Cualquier otra cosa diferente a "es" lo devolvemos como "en"
end;

// Cambia el idioma de la aplicación (por ahora "es" o "en")
procedure TdmCore.SetLanguage(const p_lang: String);
begin
  la_idiomas.Lang := p_lang;
  LoadLangFromStrings(la_idiomas.LangStr[p_lang]);
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


// Valida que el email es correcto (TRUE)
function TdmCore.ValidateEmail(const p_email: String): boolean;
const
  patron_email_regex = '^((?>[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+\x20*|"((?=[\x01-\x7f])'
             +'[^"\\]|\\[\x01-\x7f])*"\x20*)*(?<angle><))?((?!\.)'
             +'(?>\.?[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+)+|"((?=[\x01-\x7f])'
             +'[^"\\]|\\[\x01-\x7f])*")@(((?!-)[a-zA-Z\d\-]+(?<!-)\.)+[a-zA-Z]'
             +'{2,}|\[(((?(?<!\[)\.)(25[0-5]|2[0-4]\d|[01]?\d?\d))'
             +'{4}|[a-zA-Z\d\-]*[a-zA-Z\d]:((?=[\x01-\x7f])[^\\\[\]]|\\'
             +'[\x01-\x7f])+)\])(?(angle)>)$';
begin
  Result := TRegEx.IsMatch(p_email, patron_email_regex);
end;

end.
