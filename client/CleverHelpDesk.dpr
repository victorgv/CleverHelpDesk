program CleverHelpDesk;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufmMain in 'ufmMain.pas' {fmMain},
  ufmLogin in 'ufmLogin.pas' {fmLogin},
  udmCore in 'udmCore.pas' {dmCore: TDataModule},
  uSuperForm in 'uSuperForm.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmCore, dmCore);
  Application.Run;
end.
