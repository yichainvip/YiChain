(*
  Copyright 2016, Yichain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Yichain
*)
unit Server.Resources;

interface

uses
  SysUtils, Classes

  , Yichain.Core.Attributes
  , Yichain.Core.MediaType
  , Yichain.Core.Response

  , Yichain.Core.Token.Resource

  , JsonDataObjects
  , Yichain.JsonDataObjects.ReadersAndWriters
  ;

type
  [Path('helloworld')]
  THelloWorldResource = class
  public
    [GET]
    function HelloWorld: TJsonObject;
    [POST]
    function CountItems([BodyParam] AData: TJsonArray): Integer;
  end;

  [Path('token')]
  TTokenResource = class(TYichainTokenResource)

  end;

implementation

uses
    Yichain.Core.Registry
  ;

{ THelloWorldResource }

function THelloWorldResource.CountItems(AData: TJsonArray): Integer;
begin
  Result := AData.Count;
end;

function THelloWorldResource.HelloWorld: TJsonObject;
begin
  Result := TJsonObject.Create;
  Result.S['Message'] := 'Hello, world!';
end;

initialization
  TYichainResourceRegistry.Instance.RegisterResource<THelloWorldResource>;
  TYichainResourceRegistry.Instance.RegisterResource<TTokenResource>;
end.
