program CleverHelpDesk;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufmMain in 'ufmMain.pas' {fmMain},
  ufmLogin in 'ufmLogin.pas' {fmLogin},
  udmCore in 'udmCore.pas' {dmCore: TDataModule},
  uTParentForm in 'uTParentForm.pas',
  uTCommunicationManager in 'uTCommunicationManager.pas',
  uConstant in 'uConstant.pas',
  ufmTicket in 'ufmTicket.pas' {fmTicket},
  uHelper in 'uHelper.pas',
  ufmPruebas in 'ufmPruebas.pas' {fmPruebas},
  ufmMntProyectos in 'ufmMntProyectos.pas' {fmMntProyectos},
  ufmMntUsuarios in 'ufmMntUsuarios.pas' {fmMntUsuarios},
  ufmMntProyectos_EDITA in 'ufmMntProyectos_EDITA.pas' {fmMntProyectos_EDITA},
  ufmMntUsuarios_EDITA in 'ufmMntUsuarios_EDITA.pas' {fmMntUsuarios_EDITA};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmCore, dmCore);
  Application.CreateForm(TfmMntProyectos_EDITA, fmMntProyectos_EDITA);
  Application.CreateForm(TfmMntUsuarios_EDITA, fmMntUsuarios_EDITA);
  Application.Run;
end.
