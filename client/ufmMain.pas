unit ufmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.MultiView,
  FMX.StdCtrls, FMX.TabControl, FMX.Layouts, FMX.Controls.Presentation;

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
    procedure bt_exitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.fmx}

procedure TfmMain.bt_exitClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
