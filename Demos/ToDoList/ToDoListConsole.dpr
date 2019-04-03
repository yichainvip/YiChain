(*
  Copyright 2016, Yichain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Yichain
*)
program ToDoListConsole;
{$APPTYPE CONSOLE}

{$I Yichain.inc}

uses
{$ifdef DelphiXE3_UP}
  System.SysUtils,
  System.Types,
  IPPeerServer,
  IPPeerAPI,
  IdHTTPWebBrokerBridge,
  IdSchedulerOfThreadPool,
  Web.WebReq,
  Web.WebBroker,
{$else}
  SysUtils, StrUtils,
  Types,
  IdHTTPWebBrokerBridge,
  IdSchedulerOfThreadPool,
  WebReq,
  WebBroker,
{$endif}
  ServerConst in 'ServerConst.pas',
  Server.WebModule in 'Server.WebModule.pas' {ServerWebModule: TWebModule},
  Server.Ignition in 'Server.Ignition.pas';

{$R *.res}

procedure StartServer(const AServer: TIdHTTPWebBrokerBridge);
begin
  if not (AServer.Active) then
  begin
    AServer.DefaultPort := TServerEngine.Default.Port;
    Writeln(Format(sStartingServer, [AServer.DefaultPort]));
    AServer.Active := True;
  end
  else
    Writeln(sServerRunning);
  Write(cArrow);
end;

procedure StopServer(const AServer: TIdHTTPWebBrokerBridge);
begin
  if AServer.Active  then
  begin
    Writeln(sStoppingServer);
    AServer.Active := False;
    Writeln(sServerStopped);
  end
  else
    Writeln(sServerNotRunning);
  Write(cArrow);
end;

procedure SetPort(const AServer: TIdHTTPWebBrokerBridge; const APort: string);
var
  LPort: Integer;
  LWasActive: Boolean;
begin
  LPort := StrToIntDef(APort, -1);
  if LPort = -1 then
  begin
    Writeln('Port should be an integer number. Try again.');
    Exit;
  end;

  LWasActive := AServer.Active;
  if LWasActive  then
    StopServer(AServer);
  TServerEngine.Default.Port := LPort;
  if LWasActive then
    StartServer(AServer);
  Writeln(Format(sPortSet, [IntToStr(TServerEngine.Default.Port)]));
  Write(cArrow);
end;

procedure  WriteCommands;
begin
  Writeln(sCommands);
  Write(cArrow);
end;

procedure  WriteStatus(const AServer: TIdHTTPWebBrokerBridge);
begin
  Writeln(sIndyVersion + AServer.SessionList.Version);
  Writeln(sActive + BoolToStr(AServer.Active, True));
  Writeln(sPort + IntToStr(TServerEngine.Default.Port));
  Write(cArrow);
end;

procedure RunServer();
var
  LServer: TIdHTTPWebBrokerBridge;
  LScheduler: TIdSchedulerOfThreadPool;
  LResponse: string;
begin
  WriteCommands;
  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.DefaultPort := TServerEngine.Default.Port;

    LScheduler := TIdSchedulerOfThreadPool.Create(LServer);
    try
      LScheduler.PoolSize := TServerEngine.Default.ThreadPoolSize;
      LServer.Scheduler := LScheduler;
      LServer.MaxConnections := LScheduler.PoolSize;
    except
      LServer.Scheduler.Free;
      LServer.Scheduler := nil;
      raise;
    end;



    while True do
    begin
      Readln(LResponse);
      LResponse := LowerCase(LResponse);
      if sametext(LResponse, cCommandStart) then
        StartServer(LServer)
      else if sametext(LResponse, cCommandStatus) then
        WriteStatus(LServer)
      else if sametext(LResponse, cCommandStop) then
        StopServer(LServer)
{$ifdef DelphiXE3_UP}
      else if LResponse.StartsWith(cCommandSetPort, True) then
        SetPort(LServer, LResponse.Split([' '])[2])
{$else}
      else if AnsiStartsText(cCommandSetPort, LResponse) then
        SetPort(LServer, Copy(LResponse, Length(cCommandSetPort)+1, MAXINT))
{$endif}

      else if sametext(LResponse, cCommandHelp) then
        WriteCommands
      else if sametext(LResponse, cCommandExit) then
        if LServer.Active then
        begin
          StopServer(LServer);
          break
        end
        else
          break
      else
      begin
        Writeln(sInvalidCommand);
        Write(cArrow);
      end;
    end;
  finally
    LServer.Free;
  end;
end;

begin
  try
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
    RunServer();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end
end.
