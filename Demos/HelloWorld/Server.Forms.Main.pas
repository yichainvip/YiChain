(*
  Copyright 2016, Yichain-Curiosity library

  Home: https://github.com/andrea-magni/Yichain
*)
unit Server.Forms.Main;

{$I Yichain.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls
  , ActnList

  , Diagnostics

  , Yichain.Core.Engine
  , Yichain.http.Server.Indy
  {$IFDEF MSWINDOWS}
  , Yichain.mORMotJWT.Token
  {$ELSE}
  , Yichain.JOSEJWT.Token
  {$ENDIF}
  , Yichain.Core.Application, System.Actions

;

type
  TMainForm = class(TForm)
    TopPanel: TPanel;
    StartButton: TButton;
    StopButton: TButton;
    MainActionList: TActionList;
    StartServerAction: TAction;
    StopServerAction: TAction;
    PortNumberEdit: TEdit;
    Label1: TLabel;
    procedure StartServerActionExecute(Sender: TObject);
    procedure StartServerActionUpdate(Sender: TObject);
    procedure StopServerActionExecute(Sender: TObject);
    procedure StopServerActionUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PortNumberEditChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
    Yichain.Core.MessageBodyWriter, Yichain.Core.MessageBodyWriters
  , Yichain.Core.URL
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
    FEngine.Parameters.LoadFromIniFile;
    FEngine.AddApplication('DefaultApp', '/default', ['Server.Resources.*']);
    PortNumberEdit.Text := IntToStr(FEngine.Port);

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
