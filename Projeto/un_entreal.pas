unit un_entreal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons,
  Vcl.StdCtrls, Vcl.Mask;

type
  Tfrm_entreal = class(TForm)
    DatIni: TMaskEdit;
    Label1: TLabel;
    Label2: TLabel;
    DatFim: TMaskEdit;
    Label3: TLabel;
    Edit1: TEdit;
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    sButton1: TSpeedButton;
    procedure sButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_entreal: Tfrm_entreal;

implementation

{$R *.dfm}

uses un_entrega, un_cadmov, un_movrealizadas;

procedure Tfrm_entreal.Edit1Change(Sender: TObject);
begin
    Dtm_Entrega.qry_cadcondutor.close;
    Dtm_Entrega.qry_cadcondutor.Sql.Clear;
    Dtm_Entrega.qry_cadcondutor.Sql.Add('select * from CAD_CONDUTOR');
    Dtm_Entrega.qry_cadcondutor.Sql.Add('where CONDUTOR like ' + QuotedStr('%' + Edit1.Text + '%'));
    Dtm_Entrega.qry_cadcondutor.Sql.Add('order by CONDUTOR');
    Dtm_Entrega.qry_cadcondutor.open;
end;

procedure Tfrm_entreal.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then
    Selectnext(ActiveControl, true, true);
end;

procedure Tfrm_entreal.FormShow(Sender: TObject);
begin
   Dtm_Entrega.qry_cadcondutor.Open;
   datini.setfocus;
end;

procedure Tfrm_entreal.sButton1Click(Sender: TObject);
begin
   Dtm_Entrega.qry_cadcondutor.Close;
   close;
end;

procedure Tfrm_entreal.SpeedButton1Click(Sender: TObject);
begin
    Try
       with Dtm_Entrega.query_real do
          begin
              SQL.Clear;
              SQL.Text:='SELECT DESTINO, VALOR, PAGAMENTO FROM MOV_ENT_REALIZADAS '+
              'WHERE DATA >= :DTINI AND DATA <= :DTFIM AND ID_CONDUTOR = :CD '+
              'ORDER BY DESTINO';
              Parameters.ParamByName('dtini').Value := StrToDate(DatIni.Text);
              Parameters.ParamByName('dtfim').Value := StrToDate(DatFim.Text);
              Parameters.ParamByName('cd').Value := Dtm_Entrega.qry_cadcondutor.FieldByName('ID_CONDUTOR').AsInteger;
              Open;
              if RecordCount > 0 Then
              begin
                 frm_realizadas.rv_entregas_real.SetParam('periodo' , Datini.Text + ' at� ' + DatFim.Text);
                 frm_realizadas.rv_entregas_real.SetParam('codcondutor' , Dtm_Entrega.qry_cadcondutor.FieldByName('ID_CONDUTOR').AsString+' - '+
                 Dtm_Entrega.qry_cadcondutor.FieldByName('CONDUTOR').AsString);
                 frm_realizadas.rv_entregas_real.ProjectFile:=('C:\Projeto_Entregas\Relatorios\rel_entregas_real.rav');
                 frm_realizadas.rv_entregas_real.Execute;
              end
              else
              Showmessage('N�o existe Entregas para esse motorista !!!');
          end;
       except
           Showmessage('Existe(m) Erro(s) no Relatorio!!');
       end;
     end;
end.
