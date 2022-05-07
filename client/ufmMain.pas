unit ufmMain;

interface

uses
  System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.MultiView,
  FMX.StdCtrls, FMX.TabControl, FMX.Layouts, FMX.Controls.Presentation,
  udmCore, FMX.Objects, FMX.DateTimeCtrls, FMX.ListBox, FMX.ExtCtrls,
  System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, System.JSON,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TfmMain = class(TForm)
    tb_main: TToolBar;
    Layout1: TLayout;
    bt_open_multiview: TButton;
    MV_MAIN: TMultiView;
    ly_header: TLayout;
    ly_body: TLayout;
    ly_foot: TLayout;
    bt_exit: TButton;
    LA_NOMBRE_USUARIO: TLabel;
    Layout3: TLayout;
    StyleBook1: TStyleBook;
    BT_CERRAR_SESION: TButton;
    MailImage: TImage;
    Z: TText;
    BT_MNT_PROYECTOS: TButton;
    Image1: TImage;
    BT_MNT_USUARIOS: TButton;
    Image2: TImage;
    FlowLayout1: TFlowLayout;
    Layout4: TLayout;
    Label1: TLabel;
    ED_FILTRO_DESDE: TDateEdit;
    Layout5: TLayout;
    CK_FILTRO_MIS_TICKETS: TCheckBox;
    Layout2: TLayout;
    Label2: TLabel;
    ED_FILTRO_HASTA: TDateEdit;
    Layout9: TLayout;
    Label6: TLabel;
    CB_FILTRO_ESTADO: TComboBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Layout6: TLayout;
    labelTipo: TLabel;
    CB_FILTRO_TIPO: TComboBox;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    Layout7: TLayout;
    Label3: TLabel;
    CB_FILTRO_PROYECTO: TComboBox;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    Layout8: TLayout;
    Label4: TLabel;
    CB_FILTRO_ASIGNADO: TComboBox;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    pb_selector_idioma: TPopupBox;
    Layout10: TLayout;
    SB_FILTRO_LIMPIA_ESTADO: TSpeedButton;
    SB_FILTRO_LIMPIA_TIPO: TSpeedButton;
    SB_FILTRO_LIMPIA_PROYECTO: TSpeedButton;
    SB_FILTRO_LIMPIA_ASIGNADO: TSpeedButton;
    Layout11: TLayout;
    Label5: TLabel;
    CB_FILTRO_REPORTADO: TComboBox;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    SB_FILTRO_LIMPIA_REPORTADO: TSpeedButton;
    LY_LISTVIEW: TLayout;
    LV_MAIN_TICKETS: TListView;
    BT_CREA_NUEVO: TButton;
    BT_RECARGAR: TButton;
    Image3: TImage;
    procedure bt_exitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BT_MNT_USUARIOSClick(Sender: TObject);
    procedure BT_MNT_PROYECTOSClick(Sender: TObject);
    procedure pb_selector_idiomaChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SB_FILTRO_LIMPIA_ESTADOClick(Sender: TObject);
    procedure SB_FILTRO_LIMPIA_TIPOClick(Sender: TObject);
    procedure SB_FILTRO_LIMPIA_PROYECTOClick(Sender: TObject);
    procedure SB_FILTRO_LIMPIA_ASIGNADOClick(Sender: TObject);
    procedure SB_FILTRO_LIMPIA_REPORTADOClick(Sender: TObject);
    procedure LV_MAIN_TICKETSUpdateObjects(const Sender: TObject; const AItem: TListViewItem);
    procedure BT_CREA_NUEVOClick(Sender: TObject);
    procedure BT_RECARGARClick(Sender: TObject);
    procedure LV_MAIN_TICKETSItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure BT_CERRAR_SESIONClick(Sender: TObject);
  private
    { Private declarations }
    procedure PostLoginInicialations;
    procedure LoadTickets;
    function GenerateParamsOfFilter: String;
    procedure formInsercionEdicion(item: TListViewItem);
  public
    { Public declarations }
    procedure LoginDone; // Para configura el formulario tras el login
  end;

var
  fmMain: TfmMain;

implementation

uses ufmTicket, ufmMntUsuarios, ufmMntProyectos, System.SysUtils;

{$R *.fmx}

// Inicializaciones al crear el proyecto
procedure TfmMain.FormCreate(Sender: TObject);
begin
  dmCore := TdmCore.Create(nil);
  pb_selector_idioma.ItemIndex := pb_selector_idioma.Items.IndexOf(dmCore.idiomas.lang);
  LA_NOMBRE_USUARIO.Text := '';
  ED_FILTRO_DESDE.Date := now-15;
  ED_FILTRO_HASTA.Date := now;
end;

// Libera recursos al finalizar la ejecución (cuando se cierra el form Main finaliza el programa)
procedure TfmMain.FormDestroy(Sender: TObject);
begin
  try
    dmCore.Free;
  except
  end;
end;


// Inicializaciones que se realizan una vez el usuario esté logueado
procedure TfmMain.PostLoginInicialations;
begin
  dmCore.FillCombosWith_Users(CB_FILTRO_REPORTADO, CB_FILTRO_ASIGNADO);
  dmCore.FillCombosWith_MasterTypes(CB_FILTRO_TIPO);
  dmCore.FillCombosWith_MasterStatus(CB_FILTRO_ESTADO);
  dmCore.FillCombosWith_Projects(CB_FILTRO_PROYECTO);
  //
  LoadTickets; // Hacemos la primera carga de registros
end;

procedure TfmMain.SB_FILTRO_LIMPIA_ASIGNADOClick(Sender: TObject);
begin
  CB_FILTRO_ASIGNADO.ItemIndex := -1;
end;

procedure TfmMain.SB_FILTRO_LIMPIA_ESTADOClick(Sender: TObject);
begin
  CB_FILTRO_ESTADO.ItemIndex := -1;
end;

procedure TfmMain.SB_FILTRO_LIMPIA_PROYECTOClick(Sender: TObject);
begin
  CB_FILTRO_PROYECTO.ItemIndex := -1;
end;

procedure TfmMain.SB_FILTRO_LIMPIA_REPORTADOClick(Sender: TObject);
begin
  CB_FILTRO_REPORTADO.ItemIndex := -1;
end;

procedure TfmMain.SB_FILTRO_LIMPIA_TIPOClick(Sender: TObject);
begin
  CB_FILTRO_TIPO.ItemIndex := -1;
end;


// Abre el mantenimiento de proyectos
procedure TfmMain.BT_MNT_PROYECTOSClick(Sender: TObject);
var
  proyectos: TfmMntProyectos;
begin
  proyectos := TfmMntProyectos.create(nil);
  proyectos.RunFormAsModal(procedure(pModalResult: TModalResult)  // Modal http://docwiki.embarcadero.com/RADStudio/Sydney/en/Using_FireMonkey_Modal_Dialog_Boxes
      begin
      end
    );
end;

// Abre el mantenimiento de usuarios
procedure TfmMain.BT_MNT_USUARIOSClick(Sender: TObject);
var
  usuarios: TfmMntUsuarios;
begin
  usuarios := TfmMntUsuarios.create(nil);
  usuarios.RunFormAsModal(procedure(pModalResult: TModalResult)  // Modal http://docwiki.embarcadero.com/RADStudio/Sydney/en/Using_FireMonkey_Modal_Dialog_Boxes
      begin
      end
    );
end;


procedure TfmMain.BT_RECARGARClick(Sender: TObject);
begin
  LoadTickets;
end;

// LOGOUT, solicitará nuevo usuario o volver a introducir credenciales para continuar
procedure TfmMain.BT_CERRAR_SESIONClick(Sender: TObject);
begin
  dmCore.DoLogOut;
end;

procedure TfmMain.BT_CREA_NUEVOClick(Sender: TObject);
begin
  formInsercionEdicion(nil);
end;

procedure TfmMain.bt_exitClick(Sender: TObject);
begin
  Application.Terminate;
end;


// Hace la carga de los tickets desde servidor y los muestra en pantalla
procedure TfmMain.LoadTickets;
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
  txtAux: String;
begin
  dmCore.CommunicationManager.DoRequestGet('/ticket',GenerateParamsOfFilter,resultado);
  JsonArray := resultado as TJsonArray;
  LV_MAIN_TICKETS.items.Clear;

  LV_MAIN_TICKETS.BeginUpdate;
  try
    // Recorre el array y rellena combos ASIGNADO y REPORTADO
    for elementoJSON in JsonArray do begin
      with LV_MAIN_TICKETS.items.Add do begin
        Data['txtSubject'] := '('+elementoJSON.GetValue<integer>('ticketId').ToString+') '+elementoJSON.GetValue<String>('subject');
        if elementoJSON.GetValue<TJSONValue>('masterStatus').ToString <> 'null' then txtAux := 'Estado='+ UpperCase(elementoJSON.GetValue<TJSONObject>('masterStatus').GetValue<String>('name'))
        else txtAux := 'Estado=NULL';
        txtAux := txtAux + ' | Creado='+FormatDateTime('dd-mm-yyyy',elementoJSON.GetValue<TDateTime>('opened'));
        if elementoJSON.GetValue<TJSONValue>('userAssignedId').ToString <> 'null' then txtAux := txtAux + ' | Asignado='+elementoJSON.GetValue<TJSONObject>('userAssignedId').GetValue<String>('userName')
        else txtAux := txtAux + ' | Asignado=NULL';
        Data['txtInfo'] := txtAux;
        Tag := elementoJSON.GetValue<integer>('ticketId');
      end;
    end;
  finally
    LV_MAIN_TICKETS.EndUpdate;
  end;
end;

// Genera string con los parámetros de la consulta que pasará la URL de la petición rest
function TfmMain.GenerateParamsOfFilter: String;
begin
  Result := '?from='+FormatDateTIme('yyyy-mm-dd',ED_FILTRO_DESDE.Date)+'&to='+FormatDateTime('yyyy-mm-dd',ED_FILTRO_HASTA.Date);
end;

// Configura el formulario tras el login
procedure TfmMain.LoginDone;
begin
  LA_NOMBRE_USUARIO.Text := dmCore.CommunicationManager.ClientSession.NAME;
  PostLoginInicialations;
end;

// Abre el formulario del ticket para inserción o modificación según la selección del usuario
procedure TfmMain.formInsercionEdicion(item: TListViewItem);
var
  ticket: TfmTicket;
  itemEdicionTemporal: TListViewItem; // Simplemente para tener una referencia temporal al registro del listView para cargar/recargar los datos
begin
  ticket := TfmTicket.Create(nil);
  if NOT Assigned(item) then ticket.DoConfigureINSERT
  else ticket.DoConfigureUPDATE(item);

  // Mostramos el formulario del ticket
  ticket.ShowModal(procedure(ModalResult: TModalResult)  // Modal http://docwiki.embarcadero.com/RADStudio/Sydney/en/Using_FireMonkey_Modal_Dialog_Boxes
      begin // Esto es el "back-call" del ticket
        if ModalResult = mrOk then
        begin
          if NOT Assigned(ticket.ItemListView) then // CASO INSERCIÓN
          begin
            itemEdicionTemporal := LV_MAIN_TICKETS.items.Add;
            Tag := ticket.TickeID;
          end
          else // CASO MODIFICACIÓN
          begin
            itemEdicionTemporal := ticket.ItemListView;
          end;
          // Cargamos/recargamos datos en el registro del ListView
          with itemEdicionTemporal do
          begin
            Data['txtSubject'] := '('+ticket.TickeID.ToString+') '+ticket.ED_ASUNTO.Text;
            Data['txtSubject'] := Data['txtSubject'].ToString  + ' | Estado= ' + UpperCase(ticket.CB_ESTADO.Selected.text);
            Data['txtSubject'] := Data['txtSubject'].ToString  + ' | Creado=' + FormatDateTime('dd-mm-yyyy', ticket.ED_ABIERTO.Date);
          end;
        end
        else
        begin
           // No hacemos nada ya que ha cancelado y no habrá cambios...
        end;
      end
    );

end;



procedure TfmMain.LV_MAIN_TICKETSItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  formInsercionEdicion(AItem);
end;

// Evento que se lanza cada vez que se actualiza un registro TListViewItem y lo utilzo para redimensionar el heigth en función del texto contenido
procedure TfmMain.LV_MAIN_TICKETSUpdateObjects(const Sender: TObject; const AItem: TListViewItem);
var
  DrawableTxtSubject: TListItemText;
  DrawableTxtStatus: TListItemText;
  SizeImg: TListItemImage;
  Text: string;
  AvailableWidth: Single;
begin
  AvailableWidth := TListView(Sender).Width; // - TListView(Sender).ItemSpaces.Left - TListView(Sender).ItemSpaces.Right - SizeImg.Width;
  // Obtiene los objetos donde se pinta el texto del item
  DrawableTxtSubject := TListItemText(AItem.View.FindDrawable('txtSubject'));
  DrawableTxtStatus := TListItemText(AItem.View.FindDrawable('txtInfo'));
  Text := DrawableTxtSubject.Text;
  DrawableTxtSubject.Font.Size := 17;
  DrawableTxtSubject.TagFloat := DrawableTxtSubject.Font.Size;
  DrawableTxtSubject.Font.Style := [TFontStyle.fsBold];

  // Calcula el tamaño basandose en el texto del Drawable
  DrawableTxtSubject.Height := dmCore.ListViewItemGetTextHeight(DrawableTxtSubject, AvailableWidth, Text);
  AItem.Height := Trunc(DrawableTxtSubject.Height+DrawableTxtStatus.Height);
  DrawableTxtStatus.PlaceOffset.Y := DrawableTxtSubject.Height;
  DrawableTxtSubject.Width := AvailableWidth;
end;

procedure TfmMain.pb_selector_idiomaChange(Sender: TObject);
begin
  dmCore.SetLanguage(pb_selector_idioma.Text);
end;



end.
