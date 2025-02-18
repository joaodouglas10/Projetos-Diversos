unit un_provisorios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask, DateUtils, frxClass, frxDBSet;

type
  Tfrm_cadprov = class(TForm)
    Panel1: TPanel;
    novo: TSpeedButton;
    editar: TSpeedButton;
    excluir: TSpeedButton;
    gravar: TSpeedButton;
    cancelar: TSpeedButton;
    sair: TSpeedButton;
    Label1: TLabel;
    prov: TDBEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    valor: TDBEdit;
    memo: TDBMemo;
    Label6: TLabel;
    Label7: TLabel;
    cod: TDBEdit;
    Label8: TLabel;
    cliente: TDBEdit;
    DBGrid1: TDBGrid;
    combo: TDBLookupComboBox;
    entrada: TDBEdit;
    venc: TDBEdit;
    Label9: TLabel;
    prazo: TDBEdit;
    Label10: TLabel;
    memo2: TDBMemo;
    frx_Provisorios: TfrxReport;
    frxDB_Provisórios: TfrxDBDataset;
    Label11: TLabel;
    Edit1: TEdit;
    SpeedButton2: TSpeedButton;
    frxDB_Prov: TfrxDBDataset;
    Label12: TLabel;
    doc: TDBLookupComboBox;
    DBNavigator1: TDBNavigator;
    SpeedButton1: TSpeedButton;
    Label5: TLabel;
    gerente: TDBLookupComboBox;
    Label13: TLabel;
    nfe: TDBEdit;
    procedure FormShow(Sender: TObject);
    procedure sairClick(Sender: TObject);
    procedure novoClick(Sender: TObject);
    procedure editarClick(Sender: TObject);
    procedure excluirClick(Sender: TObject);
    procedure gravarClick(Sender: TObject);
    procedure cancelarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure comboClick(Sender: TObject);
    procedure valorExit(Sender: TObject);
    procedure prazoExit(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure docClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_cadprov: Tfrm_cadprov;

implementation

{$R *.dfm}

uses un_entrega, un_extenso, un_relprovisorios, un_conscli;

procedure Tfrm_cadprov.cancelarClick(Sender: TObject);
begin
   If Application.Messagebox('Confirma Cancelamento de Provisórios? ', 'Confirmação',
    mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
    else
    exit;
    prov.ReadOnly := true;
    entrada.ReadOnly := true;
    combo.ReadOnly := true;
    valor.ReadOnly := true;
    gerente.ReadOnly := true;
    nfe.ReadOnly := true;
    doc.ReadOnly := true;
    venc.ReadOnly := true;
    memo.ReadOnly := true;
    cliente.ReadOnly := true;
    cod.ReadOnly := true;
    novo.Enabled := true;
    editar.Enabled := true;
    excluir.Enabled := true;
    cancelar.Enabled := false;
    gravar.Enabled := false;
    sair.Enabled := true;
    Dtm_Entrega.Qry_provisorios.Cancel;
    prov.SetFocus;
end;

procedure Tfrm_cadprov.comboClick(Sender: TObject);
begin
   valor.SetFocus;
end;

procedure Tfrm_cadprov.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
    If odd(Dtm_Entrega.Qry_Provisorios.RecNo) then
        begin
            dbgrid1.Canvas.Font.Color:= clBlack;
            dbgrid1.Canvas.Brush.Color:= $00FFEFCE;
        end;
        dbgrid1.Canvas.FillRect(Rect);
        dbgrid1.DefaultDrawDataCell(Rect, dbgrid1.columns[DataCol].Field, State);
end;

procedure Tfrm_cadprov.docClick(Sender: TObject);
begin
   cod.SetFocus;
end;

procedure Tfrm_cadprov.Edit1Change(Sender: TObject);
var
  Sql: string; // Pesquisando registros na tabela
begin
   Dtm_Entrega.Qry_Provisorios.close;
   Dtm_Entrega.Qry_Provisorios.Sql.Clear;
   Dtm_Entrega.Qry_Provisorios.Sql.Add('select * from CAD_PROVISORIOS');
   Sql := 'where NOME_CLI like ' + QuotedStr('%' + Edit1.Text + '%');
   Dtm_Entrega.Qry_Provisorios.Sql.Add(Sql);
   Dtm_Entrega.Qry_Provisorios.Sql.Add('order by NOME_CLI');
   Dtm_Entrega.Qry_Provisorios.open;

end;

procedure Tfrm_cadprov.editarClick(Sender: TObject);
begin
    If Application.Messagebox('Confirma Alteração de Provisórios? ', 'Confirmação',
    mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
    else
    exit;
    prov.ReadOnly := true;
    entrada.ReadOnly := false;
    combo.ReadOnly := false;
    gerente.ReadOnly := false;
    valor.ReadOnly := false;
    nfe.ReadOnly := false;
    doc.ReadOnly := false;
    prazo.ReadOnly := false;
    venc.ReadOnly := true;
    memo.ReadOnly := true;
    cliente.ReadOnly := true;
    cod.ReadOnly := false;
    novo.Enabled := false;
    editar.Enabled := false;
    cancelar.Enabled := true;
    excluir.Enabled := false;
    gravar.Enabled := true;
    sair.Enabled := false;
    Dtm_Entrega.Qry_provisorios.Edit;
    valor.SetFocus;
end;

procedure Tfrm_cadprov.excluirClick(Sender: TObject);
begin
   If Dtm_Entrega.Qry_provisorios.RecordCount <> 0 then
   If Application.Messagebox('Confirma Exclusão?', 'Confirmar',
      mb_Iconquestion + MB_YesNo + Mb_DefButton1) = IdYes Then
      begin
         Dtm_Entrega.Qry_provisorios.Delete;
         valor.setfocus;
      end;
      If Dtm_Entrega.Qry_provisorios.RecordCount = 0 then
         showmessage('Nao Existe Registro para Excluir');
end;

procedure Tfrm_cadprov.FormKeyPress(Sender: TObject; var Key: Char);
begin
   If Key=#13 Then
      Selectnext(ActiveControl,True,True);
end;

procedure Tfrm_cadprov.FormShow(Sender: TObject);
begin
   Dtm_Entrega.Qry_Lojas.Open;
   Dtm_Entrega.Qry_Provisorios.Open;
   Dtm_Entrega.Query_Doc.Open;
   Dtm_Entrega.Qry_Gerencia.Open;
end;

procedure Tfrm_cadprov.gravarClick(Sender: TObject);
begin
    If Application.Messagebox('Confirma Gravação de Provisórios? ', 'Confirmação',
    mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
    else
    exit;
    prov.ReadOnly := true;
    entrada.ReadOnly := true;
    doc.ReadOnly := true;
    gerente.ReadOnly := true;
    combo.ReadOnly := true;
    valor.ReadOnly := true;
    nfe.ReadOnly := true;
    venc.ReadOnly := true;
    memo.ReadOnly := true;
    cliente.ReadOnly := true;
    cod.ReadOnly := true;
    novo.Enabled := true;
    excluir.Enabled := true;
    editar.Enabled := true;
    cancelar.Enabled := false;
    gravar.Enabled := false;
    sair.Enabled := true;
    Dtm_Entrega.Qry_provisoriosData_Extenso.value := '' + FormatDateTime ('dddd", "dd" de "mmmm" de "yyyy',Dtm_Entrega.Qry_provisoriosVencimento.value);
    Dtm_Entrega.Qry_provisorios.Post;
    valor.SetFocus;
end;

procedure Tfrm_cadprov.novoClick(Sender: TObject);
var
  codigo: Integer; // Variável do tipo integer
  Function StrZero(Num: Real; Tam: Integer): String;
  // Função para colocar zeros a esquerda
  var
    x, T: Integer;
    N, D: String;

  begin
    N := FloatToStr(Num);
    T := Pos('.', N);
    D := '';
    if T <> 0 then
    begin
      N := Copy(N, 1, T - 1);
      D := Copy(N, T, 3)
    end;
    for x := 1 to Tam - length(N) do
      N := '0' + N;
    result := N + D;
  end;
begin
    If Application.Messagebox('Confirma Inclusão de Provisórios? ', 'Confirmação',
    mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
    else
    exit;
    prov.ReadOnly := true;
    entrada.ReadOnly := false;
    combo.ReadOnly := false;
    valor.ReadOnly := false;
    doc.ReadOnly := false;
    nfe.ReadOnly := false;
    gerente.ReadOnly := false;
    prazo.ReadOnly := false;
    venc.ReadOnly := true;
    memo.ReadOnly := true;
    cliente.ReadOnly := true;
    cod.ReadOnly := false;
    novo.Enabled := false;
    editar.Enabled := false;
    excluir.Enabled := false;
    cancelar.Enabled := true;
    gravar.Enabled := true;
    sair.Enabled := false;
    if Dtm_Entrega.qry_provisorios.RecordCount = 0 Then
       codigo := 1
    else
        begin
           Dtm_Entrega.qry_provisorios.Last;
           codigo := Dtm_Entrega.qry_provisoriosPROVISORIO.Asinteger + 1;
        end;
        Dtm_Entrega.qry_provisorios.Append;
        Dtm_Entrega.qry_provisoriosPROVISORIO.asstring := StrZero(codigo, 1);
        Dtm_Entrega.qry_provisoriosENTRADA.asstring := DatetoStr(now());
        Dtm_Entrega.qry_provisoriosLOJA.asstring := 'LOJA 5';
        Dtm_Entrega.qry_provisoriosVALOR.Value := 0.00;
        doc.SetFocus;
end;

procedure Tfrm_cadprov.prazoExit(Sender: TObject);
begin
   Dtm_Entrega.Qry_Provisorios.Edit;
   Dtm_Entrega.Qry_ProvisoriosVencimento.Value := Dtm_Entrega.Qry_ProvisoriosEntrada.value + Dtm_Entrega.Qry_ProvisoriosPrazo.Value;
end;

procedure Tfrm_cadprov.sairClick(Sender: TObject);
begin
   Dtm_Entrega.Qry_Lojas.Close;
   Dtm_Entrega.Qry_Provisorios.Close;
   Dtm_Entrega.Query_Doc.Close;
   Dtm_Entrega.Qry_Gerencia.Close;
   Close;
end;

procedure Tfrm_cadprov.SpeedButton1Click(Sender: TObject);
begin
    frm_relprovisorios.showmodal;
end;

procedure Tfrm_cadprov.SpeedButton2Click(Sender: TObject);
begin
   frm_conscli.cod := 1;
   valor.SetFocus;
   frm_conscli.showmodal;
end;

procedure Tfrm_cadprov.valorExit(Sender: TObject);
begin
  Memo.Clear;
  try
     Dtm_Entrega.Qry_ProvisoriosExtenso.Asstring :=(valorPorExtenso(Dtm_Entrega.Qry_ProvisoriosValor.value));
  except
  end;
end;

end.
