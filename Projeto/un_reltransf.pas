unit un_reltransf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Mask, Data.DB;

type
  Tfrm_reltransf = class(TForm)
    Label1: TLabel;
    DatIni: TMaskEdit;
    Label2: TLabel;
    DatFim: TMaskEdit;
    Label3: TLabel;
    Edit1: TEdit;
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    sButton1: TSpeedButton;
    procedure sButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_reltransf: Tfrm_reltransf;

implementation

{$R *.dfm}

uses un_entrega, un_pagtransf;

procedure Tfrm_reltransf.DBGrid1CellClick(Column: TColumn);
begin
   ShowScrollBar(DBGrid1.Handle,SB_HORZ,true);
end;

procedure Tfrm_reltransf.Edit1Change(Sender: TObject);
Var
  Sql: string; // Pesquisando registros na tabela
begin
   Dtm_Entrega.Qry_Vendedor.close;
   Dtm_Entrega.Qry_Vendedor.Sql.Clear;
   Dtm_Entrega.Qry_Vendedor.Sql.Add('select * from CAD_VENDEDOR');
   Sql := 'where NOME like ' + QuotedStr('%' + Edit1.Text + '%');
   Dtm_Entrega.Qry_Vendedor.Sql.Add(Sql);
   Dtm_Entrega.Qry_Vendedor.Sql.Add('order by NOME');
   Dtm_Entrega.Qry_Vendedor.open;
end;

procedure Tfrm_reltransf.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then
    Selectnext(ActiveControl, true, true);
end;

procedure Tfrm_reltransf.FormShow(Sender: TObject);
begin
   Dtm_Entrega.Qry_vendedor.Open;
end;

procedure Tfrm_reltransf.sButton1Click(Sender: TObject);
begin
   Dtm_Entrega.Qry_vendedor.Close;
   close;
end;

procedure Tfrm_reltransf.SpeedButton1Click(Sender: TObject);
begin
    Try
       with Dtm_Entrega.Qry_Trans do
          begin
              SQL.Clear;
              SQL.Text:='SELECT REGISTRO, CLIENTE, DATA, VALOR, VENDEDOR, BANCO, GERENCIA FROM CAD_PAGTRANSF '+
              'WHERE DATA >= :DTINI AND DATA <= :DTFIM AND VENDEDOR = :CD';
              Parameters.ParamByName('dtini').Value := StrToDate(DatIni.Text);
              Parameters.ParamByName('dtfim').Value := StrToDate(DatFim.Text);
              Parameters.ParamByName('cd').Value := Dtm_Entrega.qry_vendedor.FieldByName('NOME').AsString;
              Open;
              if RecordCount > 0 Then
              begin
                 frm_pagTransf.Rel_CompPag.loadfromfile('C:\projeto_entregas\relatorios\rel_compPag.fr3');
                 frm_pagTransf.Rel_CompPag.ShowReport();
              end
              else
              Showmessage('N�o existe pagamentos / transfer�ncias para esse vendedor !!!');
          end;
       except
           Showmessage('Existe(m) Erro(s) no Relatorio!!');
       end;
     end;
end.
