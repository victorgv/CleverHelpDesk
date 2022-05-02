unit ufmMntUsuarios;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uTParentForm,
  FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TfmMntUsuarios = class(TParentForm)
    tb_main: TToolBar;
    Layout1: TLayout;
    TITULO_VENTANA: TText;
    BT_CREA_NUEVO: TButton;
    BT_BACK: TButton;
    procedure BT_BACKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMntUsuarios: TfmMntUsuarios;

implementation

{$R *.fmx}

procedure TfmMntUsuarios.BT_BACKClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMntUsuarios.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

end.
