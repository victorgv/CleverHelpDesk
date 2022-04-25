program CleverHelpDesk;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufmMain in 'ufmMain.pas' {fmMain},
  ufmLogin in 'ufmLogin.pas' {fmLogin},
  udmCore in 'udmCore.pas' {dmCore: TDataModule},
  uTParentForm in 'uTParentForm.pas',
  uTCommunicationManager in 'uTCommunicationManager.pas',
  uConstant in 'uConstant.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmCore, dmCore);
  Application.Run;
end.
