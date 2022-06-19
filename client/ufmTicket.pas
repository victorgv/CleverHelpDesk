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
    LA_INFO: TLabel;
    LV_COMMENT: TListView;
    Layout5: TLayout;
    BT_CREA_NUEVO: TButton;
    ME_CARGA_COMMENT: TMemo;
    Splitter1: TSplitter;
    procedure FL_PANEL_CAMPOSResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SB_CANCELARClick(Sender: TObject);
    procedure SB_GRABARClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BT_CREA_NUEVOClick(Sender: TObject);
  private
    fTickeID: integer; // Almacena el ID del ticket que estamos modificando o -1 si es inserción
    fitemListView: TListViewItem; // Para identificar si estamos creando (NIL) o modificando un ticket (instanciará al item que estamos modificando)
    //
    function ValidateFields: boolean;
    procedure SaveChanges;
    procedure LoadComments;
  public
    { Public declarations }
    procedure DoConfigureINSERT;
    procedure DoConfigureUPDATE(AItemListView: TListViewItem);
    //
    property TickeID: integer read fTickeID;
    property ItemListView: TListViewItem read fitemListView;
  end;



implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses
  udmCore,
  System.JSON,
  uConstant,
  System.DateUtils;


// Inicializaciones del formulario
procedure TfmTicket.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfmTicket.FormCreate(Sender: TObject);
begin
  LA_INFO.Text := '';
  dmCore.FillCombosWith_Users(CB_REPORTADO, CB_ASIGNADO);
  dmCore.FillCombosWith_MasterTypes(CB_TIPO);
  dmCore.FillCombosWith_MasterStatus(CB_ESTADO);
  dmCore.FillCombosWith_Projects(CB_PROYECTOS);
  // Inicializaciones según perfil usuario
  CB_ESTADO.Enabled := dmCore.CommunicationManager.ClientSession.ROLE <> 'USER';
  CB_ASIGNADO.Enabled := dmCore.CommunicationManager.ClientSession.ROLE <> 'USER';
  CB_REPORTADO.Enabled := dmCore.CommunicationManager.ClientSession.ROLE <> 'USER';
  CB_TIPO.Enabled := dmCore.CommunicationManager.ClientSession.ROLE <> 'USER';
  CB_PROYECTOS.Enabled := dmCore.CommunicationManager.ClientSession.ROLE <> 'USER';
  if dmCore.CommunicationManager.ClientSession.ROLE = 'USER' then
    CB_REPORTADO.ItemIndex := CB_REPORTADO.items.IndexOf(dmCore.CommunicationManager.ClientSession.NAME);
end;


// Añade un nuevo comentario
procedure TfmTicket.BT_CREA_NUEVOClick(Sender: TObject);
var
  vBody: String;
   JSONResult: TJSONValue;
begin
  vBody := '{"user":{"userId":'+dmCore.CommunicationManager.ClientSession.UserID.ToString+'},'+
            '"ticket":{"ticketId":'+fTickeID.ToString+'},'+
            '"text":"'+ME_CARGA_COMMENT.Text.Replace(#13#10,'\n')+'"}';
  dmCore.CommunicationManager.DoRequestPost('/ticket/comment',vBody,JSONResult);

  LV_COMMENT.items.Add.Text := JSONResult.GetValue<String>('text');

  ME_CARGA_COMMENT.Text := '';
end;

// Configuración formulario cuando queremos INTERTAR
procedure TfmTicket.DoConfigureINSERT;
begin
  fTickeID := -1;
  fitemListView := NIL;
  Caption := 'Creación Nuevo Ticket';
  ED_ID.Visible := FALSE;
  ED_ABIERTO.Date := Now;
  ED_CERRADO.IsEmpty := true;
  CB_ESTADO.ItemIndex := CB_ESTADO.Items.IndexOfObject(Pointer(1)); // Seleccionamos "REGISTRADO"
  CB_PRIORIDAD.ItemIndex := integer(priNormal);
  TI_COMENTARIOS.Enabled := FALSE;
  TI_HISTORICO.Enabled := FALSE;
end;

// Configuración formulario cuando queremos MODIFICAR
procedure TfmTicket.DoConfigureUPDATE(AItemListView: TListViewItem);
var
  JSONResult: TJSONValue;
begin
  fTickeID := AItemListView.Tag;
  fitemListView := AItemListView;
  Caption := 'Gestión de Ticket';

  // Recuperamos la información del ticket
  dmCore.CommunicationManager.DoRequestGet('/ticket/id',fTickeID.ToString,JSONResult);
  // Volcamos los datos
  ED_ASUNTO.Text := JSONResult.GetValue<String>('subject');
  ED_ID.Text := JSONResult.GetValue<String>('ticketId');
  ED_ABIERTO.Date := JSONResult.GetValue<TDateTime>('opened');
  if NOT JSONResult.GetValue<String>('closed').IsEmpty then
    ED_CERRADO.Date := JSONResult.GetValue<TDateTime>('closed')
  else
    ED_CERRADO.IsEmpty := true;
  if JSONResult.FindValue('masterStatus').ToString='null' then CB_ESTADO.ItemIndex := -1
  else CB_ESTADO.ItemIndex := CB_ESTADO.items.IndexOf(JSONResult.GetValue<TJSONObject>('masterStatus').GetValue<String>('name'));
  //ShowMessage(JSONResult.FindValue('masterType').ToString);
  if JSONResult.FindValue('masterType').ToString='null' then CB_TIPO.ItemIndex := -1
  else CB_TIPO.ItemIndex := CB_TIPO.items.IndexOf(JSONResult.GetValue<TJSONObject>('masterType').GetValue<String>('name'));
  if JSONResult.FindValue('userOpenedId').ToString='null' then CB_REPORTADO.ItemIndex := -1
  else CB_REPORTADO.ItemIndex := CB_REPORTADO.items.IndexOf(JSONResult.GetValue<TJSONObject>('userOpenedId').GetValue<String>('name'));
  if JSONResult.FindValue('userAssignedId').ToString='null' then CB_Asignado.ItemIndex := -1
  else CB_Asignado.ItemIndex := CB_Asignado.items.IndexOf(JSONResult.GetValue<TJSONObject>('userAssignedId').GetValue<String>('name'));
  if JSONResult.FindValue('relatedProjectId').ToString='null' then CB_PROYECTOS.ItemIndex := -1
  else CB_PROYECTOS.ItemIndex := CB_PROYECTOS.items.IndexOf(JSONResult.GetValue<TJSONObject>('relatedProjectId').GetValue<String>('name'));
  if JSONResult.FindValue('priority').ToString='null' then CB_PRIORIDAD.ItemIndex := -1
  else CB_PRIORIDAD.ItemIndex := JSONResult.GetValue<Integer>('priority');
  ME_DESCRIPCION.Text := JSONResult.GetValue<String>('description');
  // Recupera sus comentarios
  LoadComments;
  // Si está cerrado o cancelado ya no dejaremos modificar
  // [TO-DO]
end;

// Carga los comentarios para este tickect
procedure TfmTicket.LoadComments;
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
begin
  dmCore.CommunicationManager.DoRequestGet('/ticket/comment',fTickeID.ToString,resultado);
  if Assigned(resultado) then
  begin
    JsonArray := resultado as TJsonArray;
    for elementoJSON in JsonArray do begin
      with LV_COMMENT.items.Add do begin
        Text := elementoJSON.GetValue<String>('text');
      end;
    end;
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
  if ValidateFields then
  begin
    // (2) Grabamos en BD
    SaveChanges;
    // (3) Finalmente cerramos el formulario
    close;
  end;
end;


// Validamos campos obligatorios
function TfmTicket.ValidateFields: boolean;
begin
  result := true;
  LA_INFO.Visible := false;
  if ED_ASUNTO.Text.Trim.Length = 0 then
  begin
    result := false;
    LA_INFO.Visible := true;
    LA_INFO.Text := dmCore.getAppMessage('MSG0016');
    ED_ASUNTO.SetFocus;
  end
  else
  if CB_ESTADO.ItemIndex = -1 then // Valida que hay un estado seleccionado
  begin
    result := false;
    LA_INFO.Visible := true;
    LA_INFO.Text := dmCore.getAppMessage('MSG0010');
    CB_ESTADO.SetFocus;
  end
  else if CB_TIPO.ItemIndex = -1 then //
  begin
    result := false;
    LA_INFO.Visible := true;
    LA_INFO.Text := dmCore.getAppMessage('MSG0011');
    CB_TIPO.SetFocus;
  end
  else if CB_PRIORIDAD.ItemIndex = -1 then //
  begin
    result := false;
    LA_INFO.Visible := true;
    LA_INFO.Text := dmCore.getAppMessage('MSG0012');
    CB_PRIORIDAD.SetFocus;
  end
  else if ME_DESCRIPCION.Text.Trim.Length = 0 then //
  begin
    result := false;
    LA_INFO.Visible := true;
    LA_INFO.Text := dmCore.getAppMessage('MSG0013');
    ME_DESCRIPCION.SetFocus;
  end;
end;

// Método que hace la grabación
procedure TfmTicket.SaveChanges;
var
  JSONResult: TJSONValue;
  vBody: String;
begin
  if ValidateFields then
  begin
    if fTickeID = -1 then // Caso inserción
    begin
      vBody := '{"opened":"'+DateToISO8601(Now)+
             '","subject":"'+ED_ASUNTO.Text+
             '","description":"'+ME_DESCRIPCION.Text.Replace(#13#10,'\n')+
             '","priority":"'+CB_PRIORIDAD.Selected.Index.ToString+ '"';
      // Parte condicional
      if CB_REPORTADO.ItemIndex <> -1 then
        vBody := vBody + ',"userOpenedId":{"userId":'+dmCore.GetIdValueFromComboBox_ToRestValue(CB_REPORTADO)+'}';
      if CB_ASIGNADO.ItemIndex <> -1 then
        vBody := vBody + ',"userAssignedId":{"userId":'+dmCore.GetIdValueFromComboBox_ToRestValue(CB_ASIGNADO)+'}';
      if CB_PROYECTOS.ItemIndex <> -1 then
        vBody := vBody + ',"relatedProjectId":{"projectId":'+dmCore.GetIdValueFromComboBox_ToRestValue(CB_PROYECTOS)+'}';
      if CB_ESTADO.ItemIndex <> -1 then
        vBody := vBody + ',"masterStatus":{"statusId":'+dmCore.GetIdValueFromComboBox_ToRestValue(CB_ESTADO)+'}';
      if CB_TIPO.ItemIndex <> -1 then
        vBody := vBody + ',"masterType":{"typeId":'+dmCore.GetIdValueFromComboBox_ToRestValue(CB_TIPO)+'}';
      vBody := vBody + '}';
      dmCore.CommunicationManager.DoRequestPost('/ticket/',vBody,JSONResult);
    end
    else // Caso modificación
    begin
       vBody := '{"ticketId":"'+fTickeID.ToString+
                  '","subject":"'+ED_ASUNTO.Text+
                  '","description":"'+ME_DESCRIPCION.Text.Replace(#13#10,'\n')+
                  '","priority":"'+CB_PRIORIDAD.ItemIndex.ToString+
                  '","masterType_typeId":'+dmCore.GetIdValueFromComboBox_ToRestValue(CB_TIPO)+
                  ',"masterStatus_statusId":'+dmCore.GetIdValueFromComboBox_ToRestValue(CB_ESTADO)+
                  ',"userOpenedId_userId":'+dmCore.GetIdValueFromComboBox_ToRestValue(CB_REPORTADO)+
                  ',"userAssignedId_userId":'+dmCore.GetIdValueFromComboBox_ToRestValue(CB_ASIGNADO)+
                  ',"relatedProjectId":'+dmCore.GetIdValueFromComboBox_ToRestValue(CB_PROYECTOS)+
                  '}';
      dmCore.CommunicationManager.DoRequestPut('/ticket/','',vBody,JSONResult);
    end;
  end;
end;


end.
