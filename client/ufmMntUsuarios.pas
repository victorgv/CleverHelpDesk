unit ufmMntUsuarios;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uTParentForm,
  FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TfmMntUsuarios = class(TParentForm)
    tb_main: TToolBar;
    Layout1: TLayout;
    TITULO_VENTANA: TText;
    BT_CREA_NUEVO: TButton;
    BT_BACK: TButton;
    LV_USUARIOS: TListView;
    procedure BT_BACKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LV_USUARIOSItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure formInsercionEdicion(item: TListViewItem);
  end;

var
  fmMntUsuarios: TfmMntUsuarios;

implementation

uses
  ufmMntUsuarios_EDITA, System.JSON, udmCore;

{$R *.fmx}

procedure TfmMntUsuarios.BT_BACKClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMntUsuarios.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfmMntUsuarios.FormCreate(Sender: TObject);
var
  resultado: TJSONValue;
  JsonArray: TJSONArray;
  elementoJSON: TJSonValue;
begin
  dmCore.CommunicationManager.DoRequestGet('/user/','',resultado);
  JsonArray := resultado as TJsonArray;
  LV_USUARIOS.BeginUpdate;
  try
    // Recorre el array y rellena combos ASIGNADO y REPORTADO
    for elementoJSON in JsonArray do begin
      with LV_USUARIOS.items.Add do begin
        Data['name'] := elementoJSON.GetValue<String>('name');
        Data['userName'] := elementoJSON.GetValue<String>('userName');
        Data['email'] := elementoJSON.GetValue<String>('email');
        Data['role'] := elementoJSON.GetValue<TJSONObject>('role').GetValue<String>('code');
        Tag := elementoJSON.GetValue<integer>('userId');
      end;
    end;
  finally
    LV_USUARIOS.EndUpdate;
  end;
end;

// Determinará si es modificación porque el paármetro "item" vendrá instnaciado, si es inseción será NIL
procedure TfmMntUsuarios.formInsercionEdicion(item: TListViewItem);
var
  usuario: TfmMntUsuarios_EDITA;
  vModalResult: TModalResult;
begin
  usuario := TfmMntUsuarios_EDITA.Create(item);
  // Muestra el formulario y provee un bloque anónimo que se lanzará a modo "callback" cuando el formulario se cierre
  usuario.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
        if (ModalResult = mrOK) AND (NOT Assigned(item)) then // Añade el registro nuevo creado
          with LV_USUARIOS.items.Add do begin
       { Data['name'] := elementoJSON.GetValue<String>('name');
        Data['userName'] := elementoJSON.GetValue<String>('userName');
        Data['email'] := elementoJSON.GetValue<String>('email');
        Data['role'] := elementoJSON.GetValue<TJSONObject>('role').GetValue<String>('code');
        Tag := elementoJSON.GetValue<integer>('userId');    }
            //^***Text := usuario.ED_NAME.Text;
            //****Tag := usuario.UserID;
          end;
    end
  );

end;

procedure TfmMntUsuarios.LV_USUARIOSItemClick(const Sender: TObject;  const AItem: TListViewItem);
begin
  formInsercionEdicion(AItem);
end;

end.
