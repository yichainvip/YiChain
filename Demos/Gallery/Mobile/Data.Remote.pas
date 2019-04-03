unit Data.Remote;

interface

uses
  System.SysUtils, System.Classes, Yichain.Client.SubResource,
  Yichain.Client.SubResource.JSON, System.JSON, Yichain.Client.CustomResource,
  Yichain.Client.Resource, Yichain.Client.Resource.JSON, Yichain.Client.Client,
  Yichain.Client.SubResource.Stream, Yichain.Client.Application,
  Yichain.Utils.Parameters, Yichain.Client.Token, Yichain.Client.Client.Indy
;

type
  TJSONArrayProc = TProc<TJSONArray>;
  TStreamProc = TProc<TStream>;

  TRemoteData = class(TDataModule)
    YichainClient: TYichainClient;
    CategoriesResource: TYichainClientResourceJSON;
    GalleryApplication: TYichainClientApplication;
    CategoryItemsSubResource: TYichainClientSubResourceJSON;
    ItemSubResource: TYichainClientSubResourceStream;
    Token: TYichainClientToken;
    procedure GalleryApplicationError(AResource: TObject; AException: Exception;
      AVerb: TYichainHttpVerb; const AAfterExecute: TProc<System.Classes.TStream>;
      var AHandled: Boolean);
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    procedure GetCategories(const AOnSuccess: TJSONArrayProc);
    procedure GetItems(const ACategory: string; const AOnSuccess: TJSONArrayProc);
    procedure GetItem(const ACategory, AItem: string; const AOnSuccess: TStreamProc);
  end;

var
  RemoteData: TRemoteData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Data.Main;

{$R *.dfm}

{ TRemoteData }

procedure TRemoteData.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF ANDROID} // tethering
  YichainClient.YichainEngineURL := 'http://192.168.43.152:8080/';
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  YichainClient.YichainEngineURL := 'http://localhost:8080/';
  {$ENDIF}
end;

procedure TRemoteData.GalleryApplicationError(AResource: TObject;
  AException: Exception; AVerb: TYichainHttpVerb;
  const AAfterExecute: TProc<System.Classes.TStream>; var AHandled: Boolean);
var
  LMessage: string;
begin
  LMessage := AException.Message;
  AHandled := True;

  TThread.Queue(nil,
    procedure
    begin
      MainData.ShowError(LMessage);
    end
  );
end;

procedure TRemoteData.GetCategories(const AOnSuccess: TJSONArrayProc);
begin
  CategoriesResource.GETAsync(
    procedure (AResource: TYichainClientCustomResource)
    var
      LResponse: TJSONValue;
    begin
      LResponse := (AResource as TYichainClientResourceJSON).Response;
      if Assigned(AOnSuccess) and (LResponse is TJSONArray) then
        AOnSuccess(TJSONArray(LResponse));
    end
  );
end;

procedure TRemoteData.GetItem(const ACategory, AItem: string;
  const AOnSuccess: TStreamProc);
begin
  ItemSubResource.Resource := '';
  ItemSubResource.PathParamsValues.Clear;
  ItemSubResource.PathParamsValues.Add(ACategory);
  ItemSubResource.PathParamsValues.Add(AItem);
  ItemSubResource.GETAsync(
    procedure (AResource: TYichainClientCustomResource)
    var
      LResponse: TStream;
    begin
      LResponse := (AResource as TYichainClientSubResourceStream).Response;
      if Assigned(AOnSuccess) then
        AOnSuccess(LResponse);
    end
  );
end;

procedure TRemoteData.GetItems(const ACategory: string; const AOnSuccess: TJSONArrayProc);
begin
  CategoryItemsSubResource.Resource := ACategory;
  CategoryItemsSubResource.GETAsync(
    procedure (AResource: TYichainClientCustomResource)
    var
      LResponse: TJSONValue;
    begin
      LResponse := (AResource as TYichainClientSubResourceJSON).Response;
      if Assigned(AOnSuccess) and (LResponse is TJSONArray) then
        AOnSuccess(TJSONArray(LResponse));
    end
  );
end;

end.
