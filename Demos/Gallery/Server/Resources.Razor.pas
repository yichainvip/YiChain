unit Resources.Razor;

interface

uses
  Classes, SysUtils
  , Yichain.Core.Attributes
  , Yichain.Core.MediaType
  , Yichain.Core.Response

  , Yichain.Core.URL

  , Yichain.Core.Classes
  , Yichain.Core.Engine
  , Yichain.Core.Application

  , Yichain.DelphiRazor.Resources
;

type
  [Path('razor')]
  TGalleryRazorResource = class(TRazorResource)
  protected
    [Context] App: TYichainApplication;
    function GetRootFolder: string;
    function CategoryFolder(const ACategoryName: string): string;

    function DoProvideContext(const APathInfo: string;
      const APathParam: string): TArray<TContextEntry>; override;
  public
  end;


implementation

uses
    IOUtils, DateUtils, Contnrs
  , Yichain.Core.Registry
  , Yichain.Core.Exceptions
  , Yichain.Core.Utils
  , Yichain.Rtti.Utils
  , Gallery.Model
  , Generics.Collections
;

{ TGalleryRazorResource }

function TGalleryRazorResource.CategoryFolder(
  const ACategoryName: string): string;
begin
  Result := TPath.Combine(GetRootFolder, ACategoryName);
end;

function TGalleryRazorResource.DoProvideContext(const APathInfo,
  APathParam: string): TArray<TContextEntry>;
var
  LListObject: TList<TObject>;
  LCategoryList: TCategoryList;
  LItemsList: TItemList;
begin
  Result := inherited DoProvideContext(APathInfo, APathParam);

  if SameText(APathInfo, 'categories') then
  begin
    LCategoryList := TCategoryList.CreateFromFolder(GetRootFolder);
    try
      LListObject := LCategoryList.ToTListObject;
      Result := Result + [TContextEntry.Create('categories', LListObject)];
    finally
      LCategoryList.Free;
    end;
  end
  else if SameText(APathInfo, 'items') then
  begin
    LItemsList := TItemList.CreateFromFolder(CategoryFolder(APathParam));
    try
      LListObject := LItemsList.ToTListObject;
      Result := Result + [TContextEntry.Create('items', LListObject)];
    finally
      LItemsList.Free;
    end;
  end;
end;

function TGalleryRazorResource.GetRootFolder: string;
begin
  Result := App.Parameters.ByName('RootFolder'
    , TPath.Combine(ExtractFilePath(ParamStr(0)), 'root')).AsString;
end;

initialization
  TYichainResourceRegistry.Instance.RegisterResource<TGalleryRazorResource>(
    function: TObject
    begin
      Result := TGalleryRazorResource.Create;
    end
  );

end.
