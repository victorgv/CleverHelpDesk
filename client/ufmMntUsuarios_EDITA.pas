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
    LA_INFO: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SB_CANCELARClick(Sender: TObject);
    procedure SB_GRABARClick(Sender: TObject);
    procedure BT_BACKClick(Sender: TObject);
  private
    { Private declarations }
    fidUsuario: integer;
    fitemListView: TListViewItem;
    function ValidacionCampos: boolean;
  public
    { Public declarations }
    constructor create(item: TListViewItem); virtual;
    property UserID: Integer read  fidUsuario;
  end;

var
  fmMntUsuarios_EDITA: TfmMntUsuarios_EDITA;

implementation

uses
  udmCore,
  System.JSON,
  System.DateUtils;

{$R *.fmx}

{ TfmMntUsuarios_EDITA }

procedure TfmMntUsuarios_EDITA.BT_BACKClick(Sender: TObject);
begin
  close;
end;

constructor TfmMntUsuarios_EDITA.create(item: TListViewItem);
var
  JSONResult: TJSONValue;
begin
  inherited create(nil);
  LA_INFO.Visible := false;

  if not Assigned(item) then // Modo inserción
  begin
    TITULO_VENTANA.Text := 'Usuario nuevo';
    fidUsuario := -1;
    ED_BAJA.Enabled := false;
    ED_PASSWORD.Text := '';
  end
  else // Modo MODIFICACIÓN
  begin
    fidUsuario := item.Tag;
    fitemListView := item;
    ED_USUARIO.Enabled := FALSE;
    TITULO_VENTANA.Text := 'Modificar usuario';
    dmCore.CommunicationManager.DoRequestGet('/user/id',fIdUsuario.ToString,JSONResult);
    ED_ID.Text := JSONResult.GetValue<String>('userId');
    ED_PASSWORD.Text := '*#no modificado#*';
    ED_NOMBRE.Text := JSONResult.GetValue<String>('name');
    ED_USUARIO.Text := JSONResult.GetValue<String>('userName');
    ED_EMAIL.Text := JSONResult.GetValue<String>('email');
    if JSONResult.GetValue<String>('deletedDate') = '' then ED_BAJA.IsEmpty := true
    else ED_BAJA.Date := JSONResult.GetValue<TDateTime>('deletedDate');
    CB_PERFIL.ItemIndex := CB_PERFIL.items.IndexOf(JSONResult.GetValue<TJSONObject>('role').GetValue<String>('code'));
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

procedure TfmMntUsuarios_EDITA.SB_GRABARClick(Sender: TObject);
var
  JSONResult: TJSONValue;
  vBody: String;
begin
  if ValidacionCampos then
  begin
    if Assigned(fitemListView) then // Es edición
    begin
      var passCambiado: String := ''; // Determina si se ha cambiado el PASSW, solo se enviará si se modifica
      if ED_PASSWORD.Text <> '*#no modificado#*' then passCambiado := ED_PASSWORD.Text;
      vBody := '{"userId":"'+fidUsuario.ToString+'","userName":"'+ED_USUARIO.Text+'","name":"'+ED_NOMBRE.Text+'","email":"'+ED_EMAIL.Text+
               '","newPassword":"'+passCambiado+'","roleCode":"'+CB_PERFIL.selected.Text+'","LocalDate":"'+DateToISO8601(ED_BAJA.Date)+'"}';
      dmCore.CommunicationManager.DoRequestPut('/user/', fidUsuario.ToString, vBody, JSONResult);
      fitemListView.Data['name'] := ED_NOMBRE.Text;
      fitemListView.Data['userName'] := ED_USUARIO.Text;
      fitemListView.Data['email'] := ED_EMAIL.Text;
      fitemListView.Data['role'] := CB_PERFIL.selected.Text;
    end
    else // Es inserción
    begin
      vBody := '{"userName":"'+ED_USUARIO.Text+'","name":"'+ED_NOMBRE.text+'","email":"'+ED_EMAIL.text+'","password":"'+ED_PASSWORD.text+'","roleCode":"'+CB_PERFIL.selected.Text+'"}';
      dmCore.CommunicationManager.DoRequestPost('/user/',vBody,JSONResult);
      fidUsuario := JSONResult.GetValue<integer>('userId');
    end;
    close;
    ModalResult := mrOK;
  end;
end;

// Valida que los campos obligatorios están cargados
function TfmMntUsuarios_EDITA.ValidacionCampos: boolean;
begin
  result := true;
  LA_INFO.Visible := false;
  if ED_USUARIO.Text.Trim.Length = 0 then // Valida que se ha introducido algo en userName
  begin
    result := false;
    LA_INFO.TextSettings.FontColor := TAlphaColorRec.Red;
    LA_INFO.Visible := true;
    LA_INFO.Text := dmCore.getAppMessage('MSG0001');
    ED_USUARIO.SetFocus;
  end
  else if ED_EMAIL.Text.Trim.Length = 0 then //
  begin
    result := false;
    LA_INFO.TextSettings.FontColor := TAlphaColorRec.Red;
    LA_INFO.Text := dmCore.getAppMessage('MSG0006');
    LA_INFO.Visible := true;
    ED_EMAIL.SetFocus;
  end
  else if NOT dmCore.ValidateEmail(ED_EMAIL.Text) then //
  begin
    result := false;
    LA_INFO.TextSettings.FontColor := TAlphaColorRec.Red;
    LA_INFO.Text := dmCore.getAppMessage('MSG0007');
    LA_INFO.Visible := true;
    ED_EMAIL.SetFocus;
  end
  else if ED_NOMBRE.Text.Trim.Length = 0 then //
  begin
    result := false;
    LA_INFO.TextSettings.FontColor := TAlphaColorRec.Red;
    LA_INFO.Text := dmCore.getAppMessage('MSG0005');
    LA_INFO.Visible := true;
    ED_NOMBRE.SetFocus;
  end
  else if ED_PASSWORD.Text.Trim.Length = 0 then //
  begin
    result := false;
    LA_INFO.TextSettings.FontColor := TAlphaColorRec.Red;
    LA_INFO.Text := dmCore.getAppMessage('MSG0008');
    LA_INFO.Visible := true;
    ED_PASSWORD.SetFocus;
  end
  else if CB_PERFIL.ItemIndex = -1 then //
  begin
    result := false;
    LA_INFO.TextSettings.FontColor := TAlphaColorRec.Red;
    LA_INFO.Text := dmCore.getAppMessage('MSG0009');
    LA_INFO.Visible := true;
    CB_PERFIL.SetFocus;
  end
end;

end.
