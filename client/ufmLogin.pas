unit ufmLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, uSuperForm;

type
  TfmLogin = class(TSuperForm)
    Layout1: TLayout;
    ed_username: TEdit;
    ed_password: TEdit;
    Rectangle1: TRectangle;
    sb_Login: TSpeedButton;
    LA_INFO: TLabel;
    MailImage: TImage;
    LockImage: TImage;
    TitleText: TText;
    Layout2: TLayout;
    sb_Forgot_Password: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.fmx}

end.
