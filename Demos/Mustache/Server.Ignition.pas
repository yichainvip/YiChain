(*
  Copyright 2016, Yichain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Yichain
*)
unit Server.Ignition;

interface

uses
  Classes, SysUtils
  , Yichain.Core.Engine
;

type
  TServerEngine=class
  private
    class var FEngine: TYichainEngine;
    class var FAvailableConnectionDefs: TArray<string>;
  public
    class constructor CreateEngine;
    class destructor DestroyEngine;
    class property Default: TYichainEngine read FEngine;
  end;


implementation

uses
    Yichain.Core.Application
  , Yichain.Core.Utils
  , Yichain.Core.MessageBodyWriter
  , Yichain.Core.MessageBodyWriters
  , Yichain.Core.MessageBodyReaders
  , Yichain.Utils.Parameters.IniFile
  , Yichain.Data.FireDAC
  {$IFDEF MSWINDOWS}
  , Yichain.mORMotJWT.Token
  {$ELSE}
  , Yichain.JOSEJWT.Token
  {$ENDIF}
  , Server.Resources
  ;

{ TServerEngine }

class constructor TServerEngine.CreateEngine;
begin
  FEngine := TYichainEngine.Create;
  try
    // Engine configuration
    FEngine.Parameters.LoadFromIniFile;

    // Application configuration
    FEngine.AddApplication('DefaultApp', '/default', [ 'Server.Resources.*']);
    FAvailableConnectionDefs := TYichainFireDAC.LoadConnectionDefs(FEngine.Parameters, 'FireDAC');
  except
    FreeAndNil(FEngine);
    raise;
  end;
end;

class destructor TServerEngine.DestroyEngine;
begin
  TYichainFireDAC.CloseConnectionDefs(FAvailableConnectionDefs);
  FreeAndNil(FEngine);
end;

end.
