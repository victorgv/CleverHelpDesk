unit udmCore;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Types,
  REST.Client,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  System.UITypes,
  ufmLogin,
  System.RegularExpressions,
  uTCommunicationManager,
  REST.Types,
  System.Actions,
  FMX.ActnList,
  FMX.Controls,
  FMX.ListBox, FMX.ListView.Types, System.ImageList, FMX.ImgList;

type
  TdmCore = class(TDataModule)
    ti_userAuthenticated: TTimer;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    la_idiomas: TLang;
    AL_GLOBAL: TActionList;
    AC_HardwareBack: TAction;
    IL_LISTA_IMAGENES: TImageList;
    procedure DataModuleCreate(Sender: TObject);
    procedure ti_userAuthenticatedTimer(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure AC_HardwareBackExecute(Sender: TObject);
  private
    { Private declarations }
    fCommunicationManager: TCommunicationManager;
    fFmLogin: TfmLogin;
    fBaseURL_REST_SERVER: String; // URL base del servidor REST
    function getlocalLang: String; // Obtiene el idioma local del dispositivo (es o en cualquier otro caso devolverá en)
  public
    { Public declarations }
    property BaseURL_REST_SERVER: String read fBaseURL_REST_SERVER;
    property idiomas: TLang read la_idiomas;
    property CommunicationManager: TCommunicationManager read fCommunicationManager;
    //
    function ValidateEmail(const p_email: String): boolean;
    procedure SetLanguage(const p_lang: String); // Cambia el idioma de la aplicación (por ahora "es" o "en")
    function GetAppMessage(const p_msg_code: String): String; // Para recuperar mensajes de aplicación
    procedure WPResizeTControlToContents( AControl : TControl; Width : Boolean  = true; Height : Boolean = true ); // Ajusta el tamaño del contenedor al contenido (cuando hay un "resize" y el contenedor es TFlowLayout)
    procedure FillCombosWith_MasterStatus(combo: TComboBox); // Rellena combos Status
    procedure FillCombosWith_MasterTypes(combo: TComboBox); // Rellena combos types
    procedure FillCombosWith_Users(comboReportado, comboAsignado: TComboBox); // Rellena combos usuarios
    procedure FillCombosWith_Projects(combo: TComboBox); // Rellena combos proyectos
    function ListViewItemGetTextHeight(const D: TListItemText; const Width: Single; const Text: string): Integer;
    procedure DoLogOut;
    function GetIdValueFromComboBox_ToRestValue(cb: TComboBox): string; // Obtiene el ID del elemento seleccionado y lo devuelve o null (texto) si no hay selección, para incluirlo en un campo del json
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  dmCore: TdmCore;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  FMX.Platform,
  FMX.Dialogs,
  System.Types,
  FMX.Forms,
  System.JSON,
  FMX.TextLayout;

{ TdmCore }
// Constructor de la clase
constructor TdmCore.Create(AOwner: TComponent);
begin
  inherited;
  fCommunicationManager := TCommunicationManager.create;
  SetLanguage(getlocalLang); // Inicializa con el idioma "local" de la máquina ("es" o cualquier otro caso "en")
end;

// Destructor
destructor TdmCore.Destroy;
begin
  fCommunicationManager.Free;
  inherited;
end;

// Al hacer LOGOUT solicita de nuevo credenciales
procedure TdmCore.DoLogOut;
begin
  sleep(300);
  FreeAndNil(fCommunicationManager.ClientSession);
end;

// Cargamos los diferentes tipos de estados
procedure TdmCore.FillCombosWith_MasterStatus(combo: TComboBox);
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
begin
  dmCore.CommunicationManager.DoRequestGet('/global/status/','',resultado);
  combo.Clear;
  JsonArray := resultado as TJsonArray;
  // Recorre el array y rellena combos ASIGNADO y REPORTADO
  for elementoJSON in JsonArray do begin
    combo.Items.AddObject(elementoJSON.GetValue<String>('name'), pointer(elementoJSON.GetValue<integer>('statusId')));
  end;
end;

// Cargamos el combo con los tipos de incidencia reportadas
procedure TdmCore.FillCombosWith_MasterTypes(combo: TComboBox);
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
begin
  dmCore.CommunicationManager.DoRequestGet('/global/type/','',resultado);
  combo.Clear;
  JsonArray := resultado as TJsonArray;
  // Recorre el array y rellena combos ASIGNADO y REPORTADO
  for elementoJSON in JsonArray do begin
    combo.Items.AddObject(elementoJSON.GetValue<String>('name'), pointer(elementoJSON.GetValue<integer>('typeId')));
  end;
end;


procedure TdmCore.FillCombosWith_Projects(combo: TComboBox);
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
begin
  dmCore.CommunicationManager.DoRequestGet('/global/project/','',resultado);
  combo.Clear;
  JsonArray := resultado as TJsonArray;
  // Recorre el array y rellena combos ASIGNADO y REPORTADO
  for elementoJSON in JsonArray do begin
    combo.Items.AddObject(elementoJSON.GetValue<String>('name'), pointer(elementoJSON.GetValue<integer>('projectId')));
  end;
end;

// Cargamos los combos ASIGNADO y REPORTADO
procedure TdmCore.FillCombosWith_Users(comboReportado, comboAsignado: TComboBox);
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
  role: String;
begin
  dmCore.CommunicationManager.DoRequestGet('/user/','',resultado);
  comboReportado.Clear;
  comboAsignado.Clear;
  JsonArray := resultado as TJsonArray;
  // Recorre el array y rellena combos ASIGNADO y REPORTADO
  for elementoJSON in JsonArray do begin
    comboReportado.Items.AddObject(elementoJSON.GetValue<String>('name'), pointer(elementoJSON.GetValue<integer>('userId')));
    role := elementoJSON.GetValue<TJSONObject>('role').GetValue<String>('code');
    if (role = 'ADMIN') OR (role = 'AGENT') then // Solo son asignables los que tienen ROL=ADMIN o AGENT
      comboAsignado.Items.AddObject(elementoJSON.GetValue<String>('name'), pointer(elementoJSON.GetValue<integer>('userId')));
  end;
end;

// Implementa la funcionalidad del botón "atras" de android
procedure TdmCore.AC_HardwareBackExecute(Sender: TObject);
begin
  if Sender is TForm then
    TForm(Sender).close;
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


// Para recuperar mensajes de aplicación
// { TODO : Extraer a otra clase y fichero con los textos. No es la mejor forma de implementarlo, pero es la opción más rápida }
function TdmCore.GetAppMessage(const p_msg_code: String): String;
begin
  result := '???';
  if la_idiomas.Lang = 'es' then // *** IDIOMA ESPAñOL
  begin
    if p_msg_code = 'MSG0001' then result := 'Usuario vacío'
    else if p_msg_code = 'MSG0002' then result := 'Email incorrecto'
    else if p_msg_code = 'MSG0003' then result := 'Password vacío'
    else if p_msg_code = 'MSG0004' then result := 'Usuario y/o password incorrecto'
    else if p_msg_code = 'MSG0005' then result := 'Nombre es obligatorio'
    else if p_msg_code = 'MSG0006' then result := 'Email es obligatorio'
    else if p_msg_code = 'MSG0007' then result := 'Email formato incorrecto'
    else if p_msg_code = 'MSG0008' then result := 'Password es obligatorio'
    else if p_msg_code = 'MSG0009' then result := 'Perfil requerido'
    else if p_msg_code = 'MSG0010' then result := 'Debe seleccionar un estado'
    else if p_msg_code = 'MSG0011' then result := 'Debe seleccionar un tipo'
    else if p_msg_code = 'MSG0012' then result := 'Debe seleccionar una prioridad'
    else if p_msg_code = 'MSG0013' then result := 'Introduzca una breve descripción'
    else if p_msg_code = 'MSG0014' then result := 'UNAUTHORIZED Su token ha expirado'
    else if p_msg_code = 'MSG0015' then result := 'BAD_REQUEST Petición incorrecta'
    else if p_msg_code = 'MSG0016' then result := 'Debe introducir un asunto'
    ;
  end
  else
  begin // *** IDIOMA inglés
    if p_msg_code = 'MSG0001' then result := 'User is empty'
    else if p_msg_code = 'MSG0002' then result := 'Wrong email'
    else if p_msg_code = 'MSG0003' then result := 'Password is empty'
    else if p_msg_code = 'MSG0004' then result := 'Wrong user/password'
    else if p_msg_code = 'MSG0005' then result := 'Name is required'
    else if p_msg_code = 'MSG0006' then result := 'Email is required'
    else if p_msg_code = 'MSG0007' then result := 'Email wrong format'
    else if p_msg_code = 'MSG0008' then result := 'Password required'
    else if p_msg_code = 'MSG0009' then result := 'Role required'
    else if p_msg_code = 'MSG0010' then result := 'Status is required'
    else if p_msg_code = 'MSG0011' then result := 'Type is required'
    else if p_msg_code = 'MSG0012' then result := 'Priority is required'
    else if p_msg_code = 'MSG0013' then result := 'Enter a short description'
    else if p_msg_code = 'MSG0014' then result := 'UNAUTHORIZED token has expired'
    else if p_msg_code = 'MSG0015' then result := 'BAD_REQUEST wrong request'
    else if p_msg_code = 'MSG0016' then result := 'Subject is required'
    ;
  end;
end;

// Obtiene el ID del elemento seleccionado y lo devuelve o null (texto) si no hay selección, para incluirlo en un campo del json
function TdmCore.GetIdValueFromComboBox_ToRestValue(cb: TComboBox): string;
begin
  if cb.ItemIndex = -1 then // No hay nada seleccionado
    result := 'null'
  else
    result := integer(cb.items.objects[cb.ItemIndex] ).ToString;
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

// Nos permitirá calcular el HEIGHT de un campo de texto dentro de un TListItem y así poder redimensionar dicho campo asegurando que cabe todo el contenido
function TdmCore.ListViewItemGetTextHeight(const D: TListItemText; const Width: Single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

// Cambia el idioma de la aplicación (por ahora "es" o "en")
procedure TdmCore.SetLanguage(const p_lang: String);
begin
  la_idiomas.Lang := p_lang;
  LoadLangFromStrings(la_idiomas.LangStr[p_lang]);
end;

procedure TdmCore.ti_userAuthenticatedTimer(Sender: TObject);
begin
  // Si el usuario no está autenticado y el formulario de login ya está abierto abrimos pantalla LOGIN
  if (not Assigned(CommunicationManager.ClientSession))  AND (NOT Assigned(fFmLogin)) then
  begin
    fFmLogin := TfmLogin.Create(nil);
    fFmLogin.ShowModal(procedure(ModalResult: TModalResult)  // Modal http://docwiki.embarcadero.com/RADStudio/Sydney/en/Using_FireMonkey_Modal_Dialog_Boxes
      begin
        if ModalResult = mrOk then
        begin
          fFmLogin := nil; // La liberación la hace el propio formulario "caFree"
        end;
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


// Ajusta el tamaño del contenedor al contenido (cuando hay un "resize" y el contenedor es TFlowLayout)
procedure TdmCore.WPResizeTControlToContents(AControl: TControl; Width, Height: Boolean);
var I : Integer; r : TRectF;
begin
  if AControl.Align in [TAlignLayout.Top, TAlignLayout.Bottom, TAlignLayout.MostTop, TAlignLayout.MostBottom, TAlignLayout.Client, TAlignLayout.Scale, TAlignLayout.Fit] then
    Width := false;
  if AControl.Align in [TAlignLayout.Left, TAlignLayout.Right, TAlignLayout.MostLeft, TAlignLayout.MostRight, TAlignLayout.Client, TAlignLayout.Scale, TAlignLayout.Fit] then
    Height := false;
  r := TRectF.Empty;
  for I := 0 to AControl.ChildrenCount-1 do
    if AControl.Children[I] is TControl then
      UnionRect(r, r, TControl(AControl.Children[I]).BoundsRect );
  if Width and Height then
    AControl.Size.Size := TSizeF.Create(r.Width, r.Height)
  else if Width then
    AControl.Width := r.Width
  else if Height then
    AControl.Height := r.Height;
end;

end.
