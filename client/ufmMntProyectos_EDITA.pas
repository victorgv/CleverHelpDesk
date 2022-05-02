unit ufmMntProyectos_EDITA;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uTParentForm,
  FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Edit,
  FMX.ListView.Appearances;

type
  TfmMntProyectos_EDITA = class(TParentForm)
    tb_main: TToolBar;
    Layout1: TLayout;
    TITULO_VENTANA: TText;
    LA_PIE: TLayout;
    Layout17: TLayout;
    SB_GRABAR: TSpeedButton;
    SB_GRABAR_IMAGEN: TImage;
    SB_CANCELAR: TSpeedButton;
    SB_CANCELAR_IMAGEN: TImage;
    Layout2: TLayout;
    Layout3: TLayout;
    ED_NAME: TEdit;
    procedure SB_GRABARClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SB_CANCELARClick(Sender: TObject);
  private
    { Private declarations }
    fProjectID: integer;
    fitemListView: TListViewItem;
  public
    { Public declarations }
    constructor create(item: TListViewItem); virtual;
    property ProjectID: Integer read  fProjectID;
  end;

var
  fmMntProyectos_EDITA: TfmMntProyectos_EDITA;

implementation

uses
  System.JSON, udmCore;

{$R *.fmx}

constructor TfmMntProyectos_EDITA.create(item: TListViewItem);
begin
  inherited create(nil);

  fitemListView := item;

  if Assigned(fitemListView) then // Es edición
    ED_NAME.Text := item.Text;
end;

procedure TfmMntProyectos_EDITA.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfmMntProyectos_EDITA.SB_CANCELARClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  close;
end;

procedure TfmMntProyectos_EDITA.SB_GRABARClick(Sender: TObject);
var
  JSONResult: TJSONValue;
  vBody: String;
begin
  if Assigned(fitemListView) then // Es edición
  begin
      vBody := '{"name":"'+ED_NAME.Text+'"}';
    dmCore.CommunicationManager.DoRequestPut('/global/project/', fitemListView.Tag.ToString, vBody, JSONResult);
    fitemListView.Text := ED_NAME.Text;
    ShowMessage(JSONResult.ToString );

  end
  else // Es inserción
  begin
    vBody := '{"name":"'+ED_NAME.Text+'"}';
    dmCore.CommunicationManager.DoRequestPost('/global/project/',vBody,JSONResult);
    fProjectID := JSONResult.GetValue<integer>('projectId');
    ShowMessage(JSONResult.ToString );
  end;
  close;
  ModalResult := mrOK;
{  if fTickeID = -1 then // Caso inserción
  begin

var
  respuesta: TJSONValue;
begin
  dmCore.CommunicationManager.DoRequestPost('/global/project/', '{"name":"(ATR) Asignación Trabajadores en Tiempo Real"}//', respuesta);
{  ShowMessage(respuesta.ToString);


  end
  else // Caso modificación
  begin

  end;}
end;

end.
