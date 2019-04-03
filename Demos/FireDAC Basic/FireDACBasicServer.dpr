(*
  Copyright 2016, Yichain-Curiosity library

  Home: https://github.com/andrea-magni/Yichain
*)

program FireDACBasicServer;

uses
  Vcl.Forms,
  Server.Forms.Main in 'Server.Forms.Main.pas' {MainForm},
  Yiver.MainData in 'Server.MainData.pas' {MainDataYiource: TDataModule},Yi
  Yichain.Data.FireDAC.DataModule in '..\..\Source\Yichain.Data.FireDAC.DataModule.pas' {YichainFDDataModuleResource: TDataModule},
  Server.Resources in 'Server.Resources.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
