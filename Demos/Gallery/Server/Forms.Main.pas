(*
  Copyright 2016, Yichain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Yichain
*)
unit Forms.Main;

interface

uses Classes, SysUtils, Forms, ActnList, ComCtrls, StdCtrls, Controls, ExtCtrls
  , Diagnostics

  , Yichain.Core.Engine
  , Yichain.http.Server.Indy
  {$IFDEF MSWINDOWS}
  , Yichain.mORMotJWT.Token
  {$ELSE}
  , Yichain.JOSEJWT.Token
  {$ENDIF}
  , Yichain.Core.Application
  , System.Actions
  ;

type
  TMainForm = class(TForm)
    MainActionList: TActionList;
    StartServerAction: TAction;
    StopServerAction: TAction;
    TopPanel: TPanel;
    Label1: TLabel;
    StartButton: TButton;
    StopButton: TButton;
    PortNumberEdit: TEdit;
    procedure StartServerActionExecute(Sender: TObject);
    procedure StartServerActionUpdate(Sender: TObject);
    procedure StopServerActionExecute(Sender: TObject);
    procedure StopServerActionUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure PortNumberEditChange(Sender: TObject);
  private
    FServer: TYichainhttpServerIndy;
    FEngine: TYichainEngine;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Web.HttpApp
  , Yichain.Core.URL
  , Yichain.Core.MessageBodyWriter, Yichain.Core.MessageBodyWriters
  , Yichain.Core.MessageBodyReader, Yichain.Core.MessageBodyReaders
  , Yichain.Utils.Parameters.IniFile
  ;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopServerAction.Execute;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Yichain-Curiosity Engine
  FEngine := TYichainEngine.Create;
  try
    FEngine.BasePath := '';
    FEngine.Parameters.LoadFromIniFile;
    FEngine.AddApplication('Gallery', '/gallery', ['Resources.*']);
    PortNumberEdit.Text := FEngine.Port.ToString;

    // skip favicon requests (browser)
    FEngine.OnBeforeHandleRequest :=
      function (AEngine: TYichainEngine; AURL: TYichainURL;
        ARequest: TWebRequest; AResponse: TWebResponse; var Handled: Boolean
      ): Boolean
      begin
        Result := True;
        if SameText(AURL.Document, 'favicon.ico') then
        begin
          Result := False;
          Handled := True;
        end
      end;

    StartServerAction.Execute;
  except
    FreeAndNil(FEngine);
    raise;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEngine);
end;

procedure TMainForm.PortNumberEditChange(Sender: TObject);
begin
  FEngine.Port := StrToInt(PortNumberEdit.Text);
end;

procedure TMainForm.StartServerActionExecute(Sender: TObject);
begin
  // http server implementation
  FServer := TYichainhttpServerIndy.Create(FEngine);
  try
    FServer.DefaultPort := FEngine.Port;
    FServer.Active := True;
  except
    FServer.Free;
    raise;
  end;
end;

procedure TMainForm.StartServerActionUpdate(Sender: TObject);
begin
  StartServerAction.Enabled := (FServer = nil) or (FServer.Active = False);
end;

procedure TMainForm.StopServerActionExecute(Sender: TObject);
begin
  FServer.Active := False;
  FreeAndNil(FServer);
end;

procedure TMainForm.StopServerActionUpdate(Sender: TObject);
begin
  StopServerAction.Enabled := Assigned(FServer) and (FServer.Active = True);
end;

end.
