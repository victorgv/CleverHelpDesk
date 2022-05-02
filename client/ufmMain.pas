unit ufmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.MultiView,
  FMX.StdCtrls, FMX.TabControl, FMX.Layouts, FMX.Controls.Presentation,
  udmCore, FMX.Objects;

type
  TfmMain = class(TForm)
    tb_main: TToolBar;
    Layout1: TLayout;
    bt_open_multiview: TButton;
    bt_doBack: TButton;
    ÿ: TMultiView;
    ly_header: TLayout;
    ly_body: TLayout;
    BT_Control_Panel: TButton;
    BT_Queries: TButton;
    BT_Users: TButton;
    Layout2: TLayout;
    BT_Channels: TButton;
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
    procedure bt_exitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BT_NUEVO_TICKETClick(Sender: TObject);
    procedure BT_MNT_USUARIOSClick(Sender: TObject);
    procedure BT_MNT_PROYECTOSClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoginDone; // Para configura el formulario tras el login
  end;

var
  fmMain: TfmMain;

implementation

uses ufmTicket, ufmMntUsuarios, ufmMntProyectos;

{$R *.fmx}


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
  vModalResult: TModalResult;
begin
  ticket := TfmTicket.Create(nil);
  ticket.DoConfigureINSERT;
  ticket.RunFormAsModal(procedure(pModalResult: TModalResult)  // Modal http://docwiki.embarcadero.com/RADStudio/Sydney/en/Using_FireMonkey_Modal_Dialog_Boxes
      begin
        vModalResult := pModalResult;
      end
    );
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  LA_NOMBRE_USUARIO.Text := '';
end;

procedure TfmMain.bt_exitClick(Sender: TObject);
begin
  Application.Terminate;
end;

// Configura el formulario tras el login
procedure TfmMain.LoginDone;
begin
  LA_NOMBRE_USUARIO.Text := dmCore.CommunicationManager.ClientSession.NAME;

end;

end.
