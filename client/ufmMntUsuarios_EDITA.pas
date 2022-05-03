unit ufmMntUsuarios_EDITA;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uTParentForm,
  FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.ListView.Appearances, FMX.Edit, FMX.DateTimeCtrls, FMX.ListBox;

type
  TfmMntUsuarios_EDITA = class(TParentForm)
    tb_main: TToolBar;
    Layout1: TLayout;
    TITULO_VENTANA: TText;
    BT_BACK: TButton;
    LA_PIE: TLayout;
    Layout17: TLayout;
    SB_GRABAR: TSpeedButton;
    SB_GRABAR_IMAGEN: TImage;
    SB_CANCELAR: TSpeedButton;
    SB_CANCELAR_IMAGEN: TImage;
    Layout2: TLayout;
    Layout3: TLayout;
    FlowLayout1: TFlowLayout;
    Layout7: TLayout;
    Label3: TLabel;
    ED_ID: TEdit;
    Layout5: TLayout;
    Label2: TLabel;
    ED_NOMBRE: TEdit;
    Layout6: TLayout;
    Label5: TLabel;
    ED_EMAIL: TEdit;
    Layout8: TLayout;
    Label4: TLabel;
    ED_USUARIO: TEdit;
    Label7: TLabel;
    ED_PASSWORD: TEdit;
    Layout9: TLayout;
    Label6: TLabel;
    CB_PERFIL: TComboBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Layout4: TLayout;
    Label1: TLabel;
    ED_BAJA: TDateEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SB_CANCELARClick(Sender: TObject);
  private
    { Private declarations }
    fidUsuario: integer;
    fitemListView: TListViewItem;
  public
    { Public declarations }
    constructor create(item: TListViewItem); virtual;
    property UserID: Integer read  fidUsuario;
  end;

var
  fmMntUsuarios_EDITA: TfmMntUsuarios_EDITA;

implementation

uses
  udmCore, System.JSON;

{$R *.fmx}

{ TfmMntUsuarios_EDITA }

constructor TfmMntUsuarios_EDITA.create(item: TListViewItem);
var
  JSONResult: TJSONValue;
begin
  inherited create(nil);
  fidUsuario := item.Tag;

  if not Assigned(item) then // Modo inserción
  begin
    TITULO_VENTANA.Text := 'Usuario nuevo';

  end
  else // Modo MODIFICACIÓN
  begin
    TITULO_VENTANA.Text := 'Modificar usuario';
    dmCore.CommunicationManager.DoRequestGet('/user/id',fIdUsuario.ToString,JSONResult);
    ED_ID.Text := JSONResult.GetValue<String>('userId');
    ED_NOMBRE.Text := JSONResult.GetValue<String>('name');
    ED_USUARIO.Text := JSONResult.GetValue<String>('userName');
    ED_EMAIL.Text := JSONResult.GetValue<String>('email');
    if JSONResult.GetValue<String>('deletedDate') = '' then ED_BAJA.IsEmpty := true
    else ED_BAJA.Date := JSONResult.GetValue<TDateTime>('deletedDate');
    CB_PERFIL.ItemIndex := CB_PERFIL.items.IndexOfName(JSONResult.GetValue<TJSONObject>('role').GetValue<String>('code'));
  end;
end;

procedure TfmMntUsuarios_EDITA.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfmMntUsuarios_EDITA.SB_CANCELARClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  close;
end;

end.
