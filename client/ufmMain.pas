unit ufmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.MultiView,
  FMX.StdCtrls, FMX.TabControl, FMX.Layouts, FMX.Controls.Presentation,
  udmCore, FMX.Objects, FMX.DateTimeCtrls, FMX.ListBox, FMX.ExtCtrls,
  System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, System.JSON;

type
  TfmMain = class(TForm)
    tb_main: TToolBar;
    Layout1: TLayout;
    bt_open_multiview: TButton;
    bt_doBack: TButton;
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
    BT_NUEVO_TICKET: TButton;
    Image3: TImage;
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
    Grid1: TGrid;
    StringColumn1: TStringColumn;
    DateColumn1: TDateColumn;
    StringColumn2: TStringColumn;
    procedure bt_exitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BT_NUEVO_TICKETClick(Sender: TObject);
    procedure BT_MNT_USUARIOSClick(Sender: TObject);
    procedure BT_MNT_PROYECTOSClick(Sender: TObject);
    procedure pb_selector_idiomaChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SB_FILTRO_LIMPIA_ESTADOClick(Sender: TObject);
    procedure SB_FILTRO_LIMPIA_TIPOClick(Sender: TObject);
    procedure SB_FILTRO_LIMPIA_PROYECTOClick(Sender: TObject);
    procedure SB_FILTRO_LIMPIA_ASIGNADOClick(Sender: TObject);
    procedure SB_FILTRO_LIMPIA_REPORTADOClick(Sender: TObject);
  private
    { Private declarations }
    ticketsJsonArray: TJSONArray;
    procedure PostLoginInicialations;
    procedure LoadTickets;
  public
    { Public declarations }
    procedure LoginDone; // Para configura el formulario tras el login
  end;

var
  fmMain: TfmMain;

implementation

uses ufmTicket, ufmMntUsuarios, ufmMntProyectos;

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
  dmCore.Free;
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

// Algunas inicializaciones al crear el formulario
procedure TfmMain.BT_NUEVO_TICKETClick(Sender: TObject);
var
  ticket: TfmTicket;
begin
  ticket := TfmTicket.Create(nil);
  ticket.DoConfigureINSERT;
  ticket.ShowModal(procedure(ModalResult: TModalResult)  // Modal http://docwiki.embarcadero.com/RADStudio/Sydney/en/Using_FireMonkey_Modal_Dialog_Boxes
      begin // Esto es el "back-call" del ticket
        if ModalResult = mrOk then
          // [TO-DO]
        else
          ; // [TO-DO]
      end
    );
end;


procedure TfmMain.bt_exitClick(Sender: TObject);
begin
  Application.Terminate;
end;

// Configura el formulario tras el login
procedure TfmMain.LoadTickets;
var
  resultado: TJSONValue;

  elementoJSON: TJSonValue;
  i: integer;
begin
  i := 0;
  dmCore.CommunicationManager.DoRequestGet('/ticket/','',resultado);
  ticketsJsonArray := resultado as TJsonArray;
  Grid1.RowCount := ticketsJsonArray.Count;
//  Grid1.UpdateColumns;


end;

procedure TfmMain.LoginDone;
begin
  LA_NOMBRE_USUARIO.Text := dmCore.CommunicationManager.ClientSession.NAME;
  PostLoginInicialations;
end;

procedure TfmMain.pb_selector_idiomaChange(Sender: TObject);
begin
  dmCore.SetLanguage(pb_selector_idioma.Text);
end;



end.
