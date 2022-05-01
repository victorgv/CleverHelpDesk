unit ufmPruebas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.DateTimeCtrls, FMX.ListBox,
  FMX.StdCtrls, FMX.Layouts, FMX.ListView, FMX.Objects,
  FMX.Controls.Presentation;

type
  TfmPruebas = class(TForm)
    VertScrollBox1: TVertScrollBox;
    Layout5: TLayout;
    LA_COMENTARIOS: TLayout;
    Layout8: TLayout;
    Layout15: TLayout;
    SpeedButton1: TSpeedButton;
    MailImage: TImage;
    ListView1: TListView;
    FL_PANEL_CAMPOS: TFlowLayout;
    Layout6: TLayout;
    Label1: TLabel;
    ComboBox2: TComboBox;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    Layout7: TLayout;
    Label3: TLabel;
    DateEdit3: TDateEdit;
    Layout10: TLayout;
    Label4: TLabel;
    DateEdit4: TDateEdit;
    Layout2: TLayout;
    Label2: TLabel;
    ComboBox1: TComboBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    Layout9: TLayout;
    Asignado: TLabel;
    ComboBox3: TComboBox;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    ListBoxItem17: TListBoxItem;
    ListBoxItem18: TListBoxItem;
    LA_DESCRIPCION: TLayout;
    Layout11: TLayout;
    Layout12: TLayout;
    Label5: TLabel;
    Memo1: TMemo;
    LA_PIE: TLayout;
    Layout17: TLayout;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    SpeedButton3: TSpeedButton;
    bt_cancelar: TImage;
    Rectangle1: TRectangle;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPruebas: TfmPruebas;

implementation

{$R *.fmx}

end.
