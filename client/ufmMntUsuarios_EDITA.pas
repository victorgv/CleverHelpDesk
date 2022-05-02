unit ufmMntUsuarios_EDITA;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uTParentForm,
  FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TfmMntUsuarios_EDITA = class(TParentForm)
    tb_main: TToolBar;
    Layout1: TLayout;
    TITULO_VENTANA: TText;
    BT_CREA_NUEVO: TButton;
    BT_BACK: TButton;
    LA_PIE: TLayout;
    Layout17: TLayout;
    SB_GRABAR: TSpeedButton;
    SB_GRABAR_IMAGEN: TImage;
    SB_CANCELAR: TSpeedButton;
    SB_CANCELAR_IMAGEN: TImage;
    Layout2: TLayout;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fidUsuario: integer;
  public
    { Public declarations }
    constructor create(aowner: TComponent; p_idUsuario: integer); virtual;
  end;

var
  fmMntUsuarios_EDITA: TfmMntUsuarios_EDITA;

implementation

{$R *.fmx}

{ TfmMntUsuarios_EDITA }

constructor TfmMntUsuarios_EDITA.create(aowner: TComponent; p_idUsuario: integer);
begin
  inherited create(aowner);

  fidUsuario := p_idUsuario;
end;

procedure TfmMntUsuarios_EDITA.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

end.
