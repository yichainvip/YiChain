object MainDataModule: TMainDataModule
  OldCreateOrder = False
  Height = 394
  Width = 605
  object Client: TYichainClient
    YichainEngineURL = 'http://localhost:8080/rest'
    ConnectTimeout = 0
    ReadTimeout = -1
    ProtocolVersion = pv1_1
    HttpClient.AllowCookies = True
    HttpClient.ProxyParams.BasicAuthentication = False
    HttpClient.ProxyParams.ProxyPort = 0
    HttpClient.Request.ContentLength = -1
    HttpClient.Request.ContentRangeEnd = -1
    HttpClient.Request.ContentRangeStart = -1
    HttpClient.Request.ContentRangeInstanceLength = -1
    HttpClient.Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    HttpClient.Request.BasicAuthentication = False
    HttpClient.Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HttpClient.Request.Ranges.Units = 'bytes'
    HttpClient.Request.Ranges = <>
    HttpClient.HTTPOptions = [hoForceEncodeParams]
    Left = 280
    Top = 16
  end
  object DefaultApplication: TYichainClientApplication
    DefaultMediaType = 'application/json'
    AppName = 'default'
    Client = Client
    Left = 280
    Top = 72
  end
  object MetadataResource: TYichainClientResourceJSON
    Application = DefaultApplication
    Resource = 'metadata'
    Left = 280
    Top = 136
  end
end
