unit ufmTicket;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uTParentForm,
  FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation, FMX.Edit, System.Actions,
  FMX.ActnList, FMX.DateTimeCtrls, FMX.StdCtrls, FMX.Objects, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.TabControl;

type
  TfmTicket = class(TParentForm)
    LA_CABECERA: TLayout;
    Rectangle1: TRectangle;
    ED_ID: TEdit;
    ED_ASUNTO: TEdit;
    TC_TICKET_MAIN: TTabControl;
    TI_DATOS: TTabItem;
    TI_COMENTARIOS: TTabItem;
    TI_HISTORICO: TTabItem;
    LA_DATOS_MAIN: TLayout;
    FL_PANEL_CAMPOS: TFlowLayout;
    Layout6: TLayout;
    Label1: TLabel;
    CB_ESTADO: TComboBox;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    Layout7: TLayout;
    Label3: TLabel;
    ED_ABIERTO: TDateEdit;
    Layout10: TLayout;
    Label4: TLabel;
    ED_CERRADO: TDateEdit;
    Layout2: TLayout;
    Label2: TLabel;
    CB_TIPO: TComboBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    Layout9: TLayout;
    Asignado: TLabel;
    CB_ASIGNADO: TComboBox;
    LA_DESCRIPCION: TLayout;
    Layout11: TLayout;
    Layout12: TLayout;
    Label5: TLabel;
    ME_DESCRIPCION: TMemo;
    LA_PIE: TLayout;
    Layout17: TLayout;
    SB_GRABAR: TSpeedButton;
    SB_GRABAR_IMAGEN: TImage;
    SB_CANCELAR: TSpeedButton;
    SB_CANCELAR_IMAGEN: TImage;
    FlowLayoutBreak1: TFlowLayoutBreak;
    StyleBook1: TStyleBook;
    Layout1: TLayout;
    Label6: TLabel;
    CB_REPORTADO: TComboBox;
    Layout3: TLayout;
    Label7: TLabel;
    CB_PROYECTOS: TComboBox;
    Layout4: TLayout;
    Label8: TLabel;
    CB_PRIORIDAD: TComboBox;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    ListBoxItem17: TListBoxItem;
    procedure FL_PANEL_CAMPOSResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SB_CANCELARClick(Sender: TObject);
    procedure SB_GRABARClick(Sender: TObject);
  private
    fTickeID: integer; // Almacena el ID del ticket que estamos modificando o -1 si es inserción
    //
    procedure FillCombosWith_MasterStatus;
    procedure FillCombosWith_MasterTypes;
    procedure FillCombosWith_Users;
    procedure FillCombosWith_Projects;
    procedure ValidateFields;
    procedure SaveChanges;
  public
    { Public declarations }
    procedure DoConfigureINSERT;
    procedure DoConfigureUPDATE(p_ID: integer);

  end;



implementation

{$R *.fmx}

uses
  udmCore,
  System.JSON,
  uConstant,
  System.DateUtils;


// Inicializaciones del formulario
procedure TfmTicket.FormCreate(Sender: TObject);
begin
  FillCombosWith_Users;
  FillCombosWith_MasterTypes;
  FillCombosWith_MasterStatus;
end;

// Configuración formulario cuando queremos INTERTAR
procedure TfmTicket.DoConfigureINSERT;
begin
  fTickeID := -1;
  ED_ID.Visible := FALSE;
  ED_ABIERTO.Date := Now;
  ED_CERRADO.IsEmpty := true;
  CB_ESTADO.ItemIndex := CB_ESTADO.Items.IndexOfObject(Pointer(1)); // Seleccionamos "REGISTRADO"
  CB_PRIORIDAD.ItemIndex := integer(priNormal);
  TI_COMENTARIOS.Enabled := FALSE;
  TI_HISTORICO.Enabled := FALSE;
end;

// Configuración formulario cuando queremos MODIFICAR
procedure TfmTicket.DoConfigureUPDATE(p_ID: integer);
begin
  fTickeID := p_ID;

end;


// Cargamos los diferentes tipos de estados
procedure TfmTicket.FillCombosWith_MasterStatus;
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
begin
  dmCore.CommunicationManager.DoRequestGet('/global/status/','',resultado);
  CB_ESTADO.Clear;
  JsonArray := resultado as TJsonArray;
  // Recorre el array y rellena combos ASIGNADO y REPORTADO
  for elementoJSON in JsonArray do begin
    CB_ESTADO.Items.AddObject(elementoJSON.GetValue<String>('name'), pointer(elementoJSON.GetValue<integer>('statusId')));
  end;
end;

// Cargamos el combo con los tipos de incidencia reportadas
procedure TfmTicket.FillCombosWith_MasterTypes;
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
begin
  dmCore.CommunicationManager.DoRequestGet('/global/type/','',resultado);
  CB_TIPO.Clear;
  JsonArray := resultado as TJsonArray;
  // Recorre el array y rellena combos ASIGNADO y REPORTADO
  for elementoJSON in JsonArray do begin
    CB_TIPO.Items.AddObject(elementoJSON.GetValue<String>('name'), pointer(elementoJSON.GetValue<integer>('typeId')));
  end;
end;

procedure TfmTicket.FillCombosWith_Projects;
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
begin
  dmCore.CommunicationManager.DoRequestGet('/global/proyect/','',resultado);
  CB_PROYECTOS.Clear;
  JsonArray := resultado as TJsonArray;
  // Recorre el array y rellena combos ASIGNADO y REPORTADO
  for elementoJSON in JsonArray do begin
    CB_TIPO.Items.AddObject(elementoJSON.GetValue<String>('name'), pointer(elementoJSON.GetValue<integer>('projectId')));
  end;
end;

// Cargamos los combos ASIGNADO y REPORTADO
procedure TfmTicket.FillCombosWith_Users;
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
  role: String;
begin
  dmCore.CommunicationManager.DoRequestGet('/user/','',resultado);
  JsonArray := resultado as TJsonArray;
  // Recorre el array y rellena combos ASIGNADO y REPORTADO
  for elementoJSON in JsonArray do begin
    CB_REPORTADO.Items.AddObject(elementoJSON.GetValue<String>('name'), pointer(elementoJSON.GetValue<integer>('userId')));
    role := elementoJSON.GetValue<TJSONObject>('role').GetValue<String>('code');
    if (role = 'ADMIN') OR (role = 'AGENT') then // Solo son asignables los que tienen ROL=ADMIN o AGENT
      CB_ASIGNADO.Items.AddObject(elementoJSON.GetValue<String>('name'), pointer(elementoJSON.GetValue<integer>('userId')));
  end;
end;

// Asegura que se amplia el tamaño del contenedor en el caso de modificar el tamaño del formulario para que se muestren todos los elementos
procedure TfmTicket.FL_PANEL_CAMPOSResize(Sender: TObject);
begin
  dmCore.WPResizeTControlToContents( Sender as TControl );
end;

// Cancela cambios y sale del formulario
procedure TfmTicket.SB_CANCELARClick(Sender: TObject);
begin
  Close;
end;

// Grabamos los cambios
procedure TfmTicket.SB_GRABARClick(Sender: TObject);
begin
  // (1) Validamos campos obligatorios
  ValidateFields;

  // (2) Grabamos en BD
  SaveChanges;

  // (3) Finalmente cerramos el formulario
  close;
end;


// Validamos campos obligatorios
procedure TfmTicket.ValidateFields;
begin




end;

// Método que hace la grabación
procedure TfmTicket.SaveChanges;
var
  JSONResult: TJSONValue;
  vBody: String;
begin
  vBody := '{"opened":"'+DateToISO8601(Now)+
           '","subject":"'+ED_ASUNTO.Text+
           '","description":"'+ME_DESCRIPCION.Text+
           '","priority":"'+CB_PRIORIDAD.Selected.Index.ToString+'"}';

  if fTickeID = -1 then // Caso inserción
  begin
    dmCore.CommunicationManager.DoRequestPost('/ticket/',vBody,JSONResult);
    ShowMessage(JSONResult.ToString );



  end
  else // Caso modificación
  begin

  end;

end;


end.
