unit ufmTicket;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uTParentForm,
  FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation, FMX.Edit, System.Actions,
  FMX.ActnList, FMX.DateTimeCtrls, FMX.StdCtrls, FMX.Objects, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  TfmTicket = class(TParentForm)
    Layout1: TLayout;
    FlowLayout1: TFlowLayout;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    Layout3: TLayout;
    Edit2: TEdit;
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
    Label4: TLabel;
    DateEdit4: TDateEdit;
    Layout4: TLayout;
    Layout11: TLayout;
    Layout12: TLayout;
    Label5: TLabel;
    Memo1: TMemo;
    Layout5: TLayout;
    Layout13: TLayout;
    Layout14: TLayout;
    Layout8: TLayout;
    Layout15: TLayout;
    SpeedButton1: TSpeedButton;
    MailImage: TImage;
    ListView1: TListView;
    Layout16: TLayout;
    Layout17: TLayout;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Image1: TImage;
    Image2: TImage;
    procedure Action1Execute(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.fmx}

procedure TfmTicket.Action1Execute(Sender: TObject);
begin
  //Close;
end;

procedure TfmTicket.SpeedButton3Click(Sender: TObject);
begin
  Close;
end;

end.
