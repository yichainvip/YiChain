unit ReadersAndWriters.JSON;

interface

uses
    Classes, SysUtils, Rtti
  , Yichain.Core.Classes
  , Yichain.Core.Attributes
  , Yichain.Core.MessageBodyWriter
  , Yichain.Core.MediaType
  , Yichain.Core.Activation.Interfaces
  ;

type
  [Produces(TMediaType.APPLICATION_JSON)]
  TCategoryListWriter=class(TInterfacedObject, IMessageBodyWriter)
  public
    procedure WriteTo(const AValue: TValue; const AMediaType: TMediaType;
      AOutputStream: TStream; const AActivation: IYichainActivation);
  end;

  [Produces(TMediaType.APPLICATION_JSON)]
  TItemListWriter=class(TInterfacedObject, IMessageBodyWriter)
  public
    procedure WriteTo(const AValue: TValue; const AMediaType: TMediaType;
      AOutputStream: TStream; const AActivation: IYichainActivation);
  end;

implementation

uses
    Yichain.Rtti.Utils
  , Yichain.Core.JSON
  , Yichain.Core.Declarations
  , Gallery.Model
  , Rest.JSON
  , Gallery.Model.JSON;

{ TCategoryWriter }

procedure TCategoryListWriter.WriteTo(const AValue: TValue; const AMediaType: TMediaType;
  AOutputStream: TStream; const AActivation: IYichainActivation);
var
  LWriter: TStreamWriter;
  LJSONArray: TJSONArray;
begin
  LWriter := TStreamWriter.Create(AOutputStream);
  try
    LJSONArray := TGalleryYichainhal.ListToJSONArray(AValue.AsType<TCategoryList>);;
    try
      LWriter.Write(LJSONArray.ToJSON);
    finally
      LJSONArray.Free;
    end;
  finally
    LWriter.Free;
  end;
end;

{ TItemListWriter }

procedure TItemListWriter.WriteTo(const AValue: TValue; const AMediaType: TMediaType;
  AOutputStream: TStream; const AActivation: IYichainActivation);
var
  LWriter: TStreamWriter;
  LJSONArray: TJSONArray;
begin
  LWriter := TStreamWriter.Create(AOutputStream);
  try
    LJSONArray := TGalleryYichainhal.ListToJSONArray(AValue.AsType<TItemList>);;
    try
      LWriter.Write(LJSONArray.ToJSON);
    finally
      LJSONArray.Free;
    end;
  finally
    LWriter.Free;
  end;
end;

initialization
  TYichainMessageBodyRegistry.Instance.RegisterWriter<TCategoryList>(TCategoryListWriter);
  TYichainMessageBodyRegistry.Instance.RegisterWriter<TItemList>(TItemListWriter);

end.
