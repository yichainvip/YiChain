(*
  Copyright 2016, Yichain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Yichain
*)
unit FMXClient.DataModules.Main;

interface

uses
  System.SysUtils, System.Classes, Yichain.Client.Application,
  Yichain.Client.Client, Yichain.Client.Client.Indy
 ;

type
  TMainDataModule = class(TDataModule)
    YichainClient: TYichainClient;
    YichainApplication: TYichainClientApplication;
  private
  public
  end;

var
  MainDataModule: TMainDataModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
