(*
  Copyright 2016, Yichain-Curiosity library

  Home: https://github.com/andrea-magni/Yichain
*)
unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, System.Rtti, FMX.Grid.Style,
  Data.Bind.Controls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Yichain.Client.CustomResource, Yichain.Client.Resource, Yichain.Client.FireDAC,
  Yichain.Client.Application, Yichain.Client.Client, FMX.StdCtrls, Fmx.Bind.Navigator,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  Fmx.Dialogs, Yichain.Client.Client.Indy
  ;

type
  TForm1 = class(TForm)
    YichainClient1: TYichainClient;
    YichainClientApplication1: TYichainClientApplication;
    StringGrid1: TStringGrid;
    ButtonPOST: TButton;
    BindNavigator1: TBindNavigator;
    Layout1: TLayout;
    ButtonGET: TButton;
    YichainFDResource1: TYichainFDResource;
    employee1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure FormCreate(Sender: TObject);
    procedure ButtonPOSTClick(Sender: TObject);
    procedure ButtonGETClick(Sender: TObject);
    procedure YichainFDResource1ApplyUpdatesError(const ASender: TObject;
      const AItem: TYichainFDResourceDatasetsItem; const AErrorCount: Integer;
      const AErrors: TArray<System.string>; var AHandled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.ButtonGETClick(Sender: TObject);
begin
  YichainFDResource1.GET();
end;

procedure TForm1.ButtonPOSTClick(Sender: TObject);
begin
  YichainFDResource1.POST();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ButtonGETClick(ButtonGET);
end;

procedure TForm1.YichainFDResource1ApplyUpdatesError(const ASender: TObject;
  const AItem: TYichainFDResourceDatasetsItem; const AErrorCount: Integer;
  const AErrors: TArray<System.string>; var AHandled: Boolean);
begin
  if AErrorCount > 0 then
    ShowMessage( string.Join(sLineBreak, AErrors) );
end;

end.
