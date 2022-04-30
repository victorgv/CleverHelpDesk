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
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    SpeedButton1: TSpeedButton;
    TabItem2: TTabItem;
    mv_main: TMultiView;
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
    Button1: TButton;
    Button2: TButton;
    MailImage: TImage;
    Button3: TButton;
    TitleText: TText;
    procedure bt_exitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoginDone; // Para configura el formulario tras el login
  end;

var
  fmMain: TfmMain;

implementation

uses ufmTicket;

{$R *.fmx}

// Algunas inicializaciones al crear el formulario
procedure TfmMain.Button3Click(Sender: TObject);
var
  ticket: TfmTicket;
  vModalResult: TModalResult;
begin
  ticket := TfmTicket.Create(nil);
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
