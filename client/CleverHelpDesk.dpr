program CleverHelpDesk;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufmMain in 'ufmMain.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
