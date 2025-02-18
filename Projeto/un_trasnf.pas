unit un_trasnf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Mask, RpCon, RpConDS, RpDefine, RpRave, Data.DB;

type
  Tfrm_transf = class(TForm)
    Label1: TLabel;
    DatIni: TMaskEdit;
    Label2: TLabel;
    DatFim: TMaskEdit;
    Label3: TLabel;
    Edit1: TEdit;
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    sButton1: TSpeedButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_transf: Tfrm_transf;

implementation

{$R *.dfm}

uses un_entrega, un_pagtransf;

procedure Tfrm_transf.Edit1Change(Sender: TObject);
begin
    Dtm_Entrega.qry_vendedor.close;
    Dtm_Entrega.qry_vendedor.Sql.Clear;
    Dtm_Entrega.qry_vendedor.Sql.Add('select * from CAD_VENDEDOR');
    Dtm_Entrega.qry_vendedor.Sql.Add('where NOME like ' + QuotedStr('%' + Edit1.Text + '%'));
    Dtm_Entrega.qry_vendedor.Sql.Add('order by NOME');
    Dtm_Entrega.qry_vendedor.open;
end;

procedure Tfrm_transf.FormKeyPress(Sender: TObject; var Key: Char);
begin
   If Key = #13 Then
     Selectnext(ActiveControl, true, true);
end;

procedure Tfrm_transf.FormShow(Sender: TObject);
begin
   Dtm_Entrega.qry_vendedor.Open;
   datini.setfocus;
end;

procedure Tfrm_transf.sButton1Click(Sender: TObject);
begin
   Close;
end;

procedure Tfrm_transf.SpeedButton1Click(Sender: TObject);
begin //Gerando Relat�rio
    Try
       with Dtm_Entrega.Qry_Trasf do
          begin
              SQL.Clear;
              SQL.Text:='SELECT CLIENTE, DATA, DATA_PAG, VALOR, TIPO_PAG, BANCO, GERENCIA, ID_VENDEDOR, VENDEDOR FROM CAD_PAGTRANSF '+
              'WHERE DATA >= :DTINI AND DATA <= :DTFIM AND ID_VENDEDOR = :CD '+
              'ORDER BY DATA';
              Parameters.ParamByName('dtini').Value := StrToDate(DatIni.Text);
              Parameters.ParamByName('dtfim').Value := StrToDate(DatFim.Text);
              Parameters.ParamByName('cd').Value := Dtm_Entrega.qry_vendedor.FieldByName('ID_VENDEDOR').AsInteger;
              Open;
              if RecordCount > 0 Then
              begin
                 frm_pagTransf.rv_transf.SetParam('periodo' , Datini.Text + ' at� ' + DatFim.Text);
                 frm_pagTransf.rv_transf.SetParam('codvendedor' , Dtm_Entrega.qry_vendedor.FieldByName('ID_VENDEDOR').AsString+' - '+
                                                                  Dtm_Entrega.qry_vendedor.FieldByName('NOME').AsString);
                 frm_pagTransf.rv_transf.ProjectFile:=('\\Douglas\Projeto_Pag Lj4\Relatorios\Rel_Transf.rav');
                 frm_pagTransf.rv_transf.Execute;
                 frm_transf.Close;
              end
              else
              Showmessage('N�o existe movimento para esse vendedor(a) !!!');
          end;
       except
           Showmessage('Existe(m) Erro(s) no Relatorio!!');
       end;
     end;
end.
