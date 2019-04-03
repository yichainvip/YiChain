unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Yichain.Client.CustomResource, Yichain.Client.Resource,
  Yichain.Client.FireDAC, Yichain.Client.Application, Yichain.Client.Client, Vcl.StdCtrls,
  Yichain.Client.Client.Indy
;

type
  TForm1 = class(TForm)
    YichainClient1: TYichainClient;
    YichainClientApplication1: TYichainClientApplication;
    YichainDatamoduleResource: TYichainFDResource;
    employee1: TFDMemTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    SendToServerButton: TButton;
    FilterEdit: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure SendToServerButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  YichainDatamoduleResource.QueryParams.Values['filter'] := FilterEdit.Text;
  YichainDatamoduleResource.GET();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  YichainDatamoduleResource.GET();
end;

procedure TForm1.SendToServerButtonClick(Sender: TObject);
begin
  YichainDatamoduleResource.POST();
end;

end.
