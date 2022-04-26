unit uTCommunicationManager;

interface

uses
  REST.Client,
  System.JSON;


type
  TClientSession = class(TObject) // Guarda información de la sesión del cliente (token)
  private
    fToken: String;
    fUserName: String;
    fPassword: String;
    fClientSession: TClientSession;
  public
    property Token: String read fToken;
    property UserName: String read fUserName;

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

// Realiza la autenticación y genera el TOKEN necesario para el resto de peticiones
function TCommunicationManager.DoRequestAuth(const p_userName, p_password: String): boolean;
begin
  reset;

  fRESTClient.BaseURL := c_URL_REST_SERVER+'/auth/login';
  fRESTRequest.Method := rmPOST;
  fRESTRequest.AddBody('{"userName":"'+p_userName+'","password":"'+p_password+'"}"',ctAPPLICATION_JSON);
  fRESTRequest.Execute;

  if fRESTResponse.StatusCode = 200 then
  begin
    if Assigned(fClientSession) then FreeAndNil(fClientSession); // Si ya tenía algo asignado lo liberamos
    fClientSession := TClientSession.create((fRESTResponse.JSONValue).GetValue<String>('token'), p_userName, p_password);
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
  fRESTRequest.AddParameter('Authorization','Bearer '+ClientSession.Token, TRESTRequestParameterKind.pkHTTPHEADER,[TRESTRequestParameterOption.poDoNotEncode]);
  fRESTRequest.Execute;
  p_OUT_JSONValue := fRESTResponse.JSONValue;
end;


procedure TCommunicationManager.DoRequestPost(const p_URL_MAPPING, p_JSON_BODY: String; var p_OUT_JSONValue: TJSONValue);
begin
  reset;

  fRESTClient.BaseURL := c_URL_REST_SERVER+p_URL_MAPPING;
  fRESTRequest.Method := rmPOST;
  fRESTRequest.AddBody(p_JSON_BODY,ctAPPLICATION_JSON);
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
