(*
  Copyright 2016, Yichain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Yichain
*)
library JsonDataObjectsApacheModule;

uses
  {$IFDEF MSWINDOWS}
  Winapi.ActiveX,
  System.Win.ComObj,
  {$ENDIF }
  Web.WebBroker,
  Web.ApacheApp,
  Web.HTTPD24Impl,
  Server.WebModule in 'Server.WebModule.pas' {ServerWebModule: TWebModule},
  Server.Ignition in 'Server.Ignition.pas',
  Server.Resources in 'Server.Resources.pas';

{$R *.res}

// httpd.conf entries:
//
(*
 LoadModule Yichaintemplate_module modules/mod_Yichaintemplate.dll

 <Location /xyz>
    SetHandler mod_Yichaintemplate-handler
 </Location>
*)
//
// These entries assume that the output directory for this project is the apache/modules directory.
//
// httpd.conf entries should be different if the project is changed in these ways:
//   1. The TApacheModuleData variable name is changed
//   2. The project is renamed. //AM mod_Yichaintemplate
//   3. The output directory is not the apache/modules directory
//

// Declare exported variable so that Apache can access this module.
var
  GModuleData: TApacheModuleData;
exports
  GModuleData name 'Yichaintemplate_module';

begin
{$IFDEF MSWINDOWS}
  CoInitFlags := COINIT_MULTITHREADED;
{$ENDIF}
  Web.ApacheApp.InitApplication(@GModuleData);
  Application.Initialize;
  Application.WebModuleClass := WebModuleClass;
  Application.Run;
end.
