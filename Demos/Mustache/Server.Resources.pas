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
  , Yichain.Core.JSON
  , Yichain.Core.Response

  , Yichain.Core.Token.Resource

  , Yichain.dmustache, Yichain.dmustache.InjectionService
  , Yichain.Metadata, Yichain.Metadata.JSON, Yichain.Metadata.InjectionService
  ;

type
  [Path('helloworld')]
  THelloWorldResource = class
  protected
    [Context] mustache: TYichaindmustache;
  public
    [GET, Produces(TMediaType.TEXT_PLAIN)]
    function SayHelloWorld: string;

    [GET, Path('/to/{Someone}'), Produces(TMediaType.TEXT_PLAIN)]
    function SayHelloTo([PathParam] Someone: string): string;

    [GET, Path('metadata/simple'), Produces(TMediaType.TEXT_HTML)]
    function MetadataSimple([Context] Metadata: TYichainApplicationMetadata): string;

    [GET, Path('metadata/bootstrap'), Produces(TMediaType.TEXT_HTML)]
    function MetadataBootstrap([Context] Metadata: TYichainApplicationMetadata): string;

    [GET, Path('metadata/json'), Produces(TMediaType.APPLICATION_JSON)]
    function MetadataJSON([Context] Metadata: TYichainApplicationMetadata): string;
  end;

  [Path('token')]
  TTokenResource = class(TYichainTokenResource)
  end;

implementation

uses
  Yichain.Core.Registry
, SynCommons
;

{ THelloWorldResource }

function THelloWorldResource.MetadataSimple(Metadata: TYichainApplicationMetadata): string;
begin
  Result := mustache.RenderTemplateWithJSON('metadata_simple.html', Metadata.ToJSON, True);
end;

function THelloWorldResource.MetadataBootstrap(
  Metadata: TYichainApplicationMetadata): string;
begin
  Result := mustache.RenderTemplateWithJSON('metadata_bootstrap.html', Metadata.ToJSON, True);
end;

function THelloWorldResource.MetadataJSON(
  Metadata: TYichainApplicationMetadata): string;
var
  LJSON: TJSONObject;
begin
  LJSON := Metadata.ToJSON;
  try
    Result := LJSON.ToJSON;
  finally
    LJSON.Free;
  end;
end;

function THelloWorldResource.SayHelloTo(Someone: string): string;
var
  LContext: Variant;
begin
  TDocVariant.New(LContext);
  LContext.Someone := Someone;
  LContext.Now := Now;
  Result := mustache.Render('Hello, {{Someone}}. Current time is: {{Now}}.', LContext);
end;

function THelloWorldResource.SayHelloWorld: string;
begin
  Result := 'Hello World!';
end;

initialization
  TYichainResourceRegistry.Instance.RegisterResource<THelloWorldResource>;
  TYichainResourceRegistry.Instance.RegisterResource<TTokenResource>;
end.
