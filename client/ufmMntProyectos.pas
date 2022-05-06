unit ufmMntProyectos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uTParentForm,
  FMX.Layouts, FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TfmMntProyectos = class(TParentForm)
    LY_MAIN: TLayout;
    tb_main: TToolBar;
    Layout1: TLayout;
    TITULO_VENTANA: TText;
    BT_CREA_NUEVO: TButton;
    BT_BACK: TButton;
    LV_PROYECTOS: TListView;
    procedure BT_BACKClick(Sender: TObject);
    procedure BT_CREA_NUEVOClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LV_PROYECTOSItemClick(const Sender: TObject;  const AItem: TListViewItem);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure formInsercionEdicion(item: TListViewItem);
  public
    { Public declarations }
  end;

var
  fmMntProyectos: TfmMntProyectos;

implementation

uses
  udmCore, System.JSON, ufmMntProyectos_EDITA;

{$R *.fmx}

procedure TfmMntProyectos.BT_BACKClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMntProyectos.BT_CREA_NUEVOClick(Sender: TObject);
begin
  formInsercionEdicion(nil);
end;

// Determinará si es modificación porque el paármetro "item" vendrá instnaciado, si es inseción será NIL
procedure TfmMntProyectos.formInsercionEdicion(item: TListViewItem);
var
  proyecto: TfmMntProyectos_EDITA;
  vModalResult: TModalResult;
begin
  proyecto := TfmMntProyectos_EDITA.Create(item);
  // Muestra el formulario y provee un bloque anónimo que se lanzará a modo "callback" cuando el formulario se cierre
  proyecto.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
        if (ModalResult = mrOK) AND (NOT Assigned(item)) then // Añade el registro nuevo creado
          with LV_PROYECTOS.items.Add do begin
            Text := proyecto.ED_NAME.Text;
            Tag := proyecto.ProjectID;
          end;
    end
  );
end;



// Evento que se produce al abrir el formulario y que utilizaremos para cargar los datos
procedure TfmMntProyectos.FormCreate(Sender: TObject);
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
begin
  dmCore.CommunicationManager.DoRequestGet('/global/project/','',resultado);
  JsonArray := resultado as TJsonArray;
  // Recorre el array y rellena combos ASIGNADO y REPORTADO
  for elementoJSON in JsonArray do begin
    with LV_PROYECTOS.items.Add do begin
      Text := elementoJSON.GetValue<String>('name');
      Tag := elementoJSON.GetValue<integer>('projectId');
    end;
  end;
end;

procedure TfmMntProyectos.LV_PROYECTOSItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  formInsercionEdicion(AItem);
end;

procedure TfmMntProyectos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;


end.
