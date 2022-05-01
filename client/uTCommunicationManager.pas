unit uTCommunicationManager;

interface

uses
  REST.Client,
  System.JSON, FMX.Dialogs;


type
  TClientSession = class(TObject) // Guarda información de la sesión del cliente (token)
  private
    fToken: String;
    fUserName: String;
    fPassword: String;
    fUserID: integer; // ID único del usuario
    fNAME: String; // Nombre del usuario
    fROLE: String; // Role del usuario en la aplicación
  public
    property Token: String read fToken;
    property UserName: String read fUserName;
    property UserID: integer read fUserID;
    property NAME: String read fName;
    property ROLE: String read fROLE;

    constructor create(const p_token, p_userName, p_password: String);
  end;


// Clase que gestiona los métodos de comunicación contra el servidor rest
Type
  TCommunicationManager=class(TObject)
  private
    fClientSession: TClientSession;
    fRESTClient: TRESTClient;
    fRESTRequest: TRESTRequest;
    fRESTResponse: TRESTResponse;
    //
    procedure AddJWT_TokenToHeader;
  public
    property ClientSession: TClientSession read fClientSession;
    //
    constructor create;
    destructor destroy;
    //
    procedure reset; // Inicializa los componentes de conexión al servidor rest
    function DoRequestAuth(const p_userName: String; const p_password: String): boolean;
    procedure DoRequestPost(const p_URL_MAPPING: String; const p_JSON_BODY: String; var p_OUT_JSONValue: TJSONValue);
    procedure DoRequestGet(const p_URL_MAPPING: String; const p_param: String; var p_OUT_JSONValue: TJSONValue);
  end;

implementation

uses uConstant, System.SysUtils, REST.Types;

{ TCommunicationManager }

constructor TCommunicationManager.create;
begin
  inherited;
  fClientSession := NIL;
  fRESTClient := TRESTClient.Create(c_URL_REST_SERVER);
  fRESTRequest := TRESTRequest.Create(nil);
  fRESTResponse := TRESTResponse.Create(nil);

  fRESTRequest.Client := fRESTClient;
  fRESTRequest.Response := fRESTResponse;
end;

destructor TCommunicationManager.destroy;
begin
  freeAndNil(fClientSession);
  fRESTRequest.Free;
  fRESTResponse.Free;
  fRESTClient.Free;
  inherited;
end;

// Simplemente añade el header "Authorization" con el token JWT
procedure TCommunicationManager.AddJWT_TokenToHeader;
begin
  fRESTRequest.AddParameter
    (
       'Authorization',
       'Bearer ' + ClientSession.Token,
       TRESTRequestParameterKind.pkHTTPHEADER, // Indicar que es HEADER
       [TRESTRequestParameterOption.poDoNotEncode]
   );
end;


// Realiza la autenticación y genera el TOKEN necesario para el resto de peticiones
function TCommunicationManager.DoRequestAuth(const p_userName, p_password: String): boolean;
begin
  // (1) Resetea los componentes para lanzar la siguiente petición
  reset;
  // (2) Ataca a la ruta de login (es la única del servidor que está abierta para atacar sin TOKEN)
  fRESTClient.BaseURL := c_URL_REST_SERVER+'/auth/login';
  fRESTRequest.Method := rmPOST;
  fRESTRequest.AddBody('{"userName":"'+p_userName+'","password":"'+p_password+'"}"',ctAPPLICATION_JSON);
  fRESTRequest.Execute;

  // (3) Evalua el resutado, si es 200 es correcto y el servidor devolverá el TOKEN
  if fRESTResponse.StatusCode = 200 then
  begin
    // (3.1) Creamos una instancia a la clase que almacenará los datos del usuario para la sesión "interna" del cliente (es servidor es stateless)
    if Assigned(fClientSession) then FreeAndNil(fClientSession); // Si ya tenía algo asignado lo liberamos
    fClientSession := TClientSession.create(fRESTResponse.JSONValue.GetValue<String>('token'), p_userName, p_password);

    // (3.2) Recuperamos datos del usuario necesarios para la aplicación y los añadimos a la instancia de sesión
    var respuestaJSON: TJSONValue;
    DoRequestGet('/user',  p_userName , respuestaJSON);
    fClientSession.fNAME := respuestaJSON.GetValue<String>('name');
    fClientSession.fUserID := respuestaJSON.GetValue<integer>('userId');
    fClientSession.fROLE := respuestaJSON.GetValue<TJSONObject>('role').GetValue<String>('code');
    // (3.3) Devuelve true indicando que el login ha sigo satisfactorio
    result := true;
  end
  else
  begin
    result := false;
  end;
end;


// Inicializa los componentes de conexión al servidor rest
procedure TCommunicationManager.reset;
begin
  fRESTRequest.ResetToDefaults;
  fRESTClient.ResetToDefaults;
  fRESTResponse.ResetToDefaults;
//  RESTResponseDataSetAdapter.ResetToDefaults;
end;

procedure TCommunicationManager.DoRequestGet(const p_URL_MAPPING, p_param: String; var p_OUT_JSONValue: TJSONValue);
begin
  reset;

  fRESTClient.BaseURL := c_URL_REST_SERVER+p_URL_MAPPING+'/'+p_param;
  fRESTRequest.Method := rmGET;
  AddJWT_TokenToHeader;
  fRESTRequest.Execute;
  p_OUT_JSONValue := fRESTResponse.JSONValue;
end;


procedure TCommunicationManager.DoRequestPost(const p_URL_MAPPING, p_JSON_BODY: String; var p_OUT_JSONValue: TJSONValue);
begin
  reset;
  fRESTClient.BaseURL := c_URL_REST_SERVER+p_URL_MAPPING+'/';
  fRESTRequest.Method := rmPOST;
  fRESTRequest.AddBody(p_JSON_BODY,ctAPPLICATION_JSON);
  AddJWT_TokenToHeader;
  fRESTRequest.Execute;
  p_OUT_JSONValue := fRESTResponse.JSONValue;
end;

{ TClientSession }
constructor TClientSession.create(const p_token, p_userName, p_password: String);
begin
  inherited create;
  fToken := p_token;
  fUserName := p_userName;
  fPassword := p_password;
end;


end.
