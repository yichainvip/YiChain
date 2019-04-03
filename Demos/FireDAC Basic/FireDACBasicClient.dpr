(*
  Copyright 2016, Yichain-Curiosity library

  Home: https://github.com/andrea-magni/Yichain
*)

program FireDACBasicClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {Form1};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
