unit un_cadmov;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Data.DB,
  Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, frxClass,
  frxDBSet, RpCon, RpConDS, RpDefine, RpRave, sGauge, sButton, RpBase, RpSystem,
  Vcl.Imaging.jpeg, Vcl.Menus, Vcl.Samples.Gauges, RxToolEdit, RxDBCtrl;

type
  Tfrm_cadmov = class(TForm)
    DBGrid1: TDBGrid;
    Rv_Entregas: TRvProject;
    RvData_Entregas: TRvDataSetConnection;
    Panel2: TPanel;
    Label20: TLabel;
    RvSystem1: TRvSystem;
    Panel3: TPanel;
    Label24: TLabel;
    Panel4: TPanel;
    Label25: TLabel;
    Panel5: TPanel;
    novo: TSpeedButton;
    editar: TSpeedButton;
    gravar: TSpeedButton;
    cancelar: TSpeedButton;
    sair: TSpeedButton;
    Panel1: TPanel;
    Label1: TLabel;
    reg: TDBEdit;
    Label7: TLabel;
    cliente: TDBEdit;
    bairro: TDBEdit;
    Label10: TLabel;
    Label5: TLabel;
    data: TDBEdit;
    hora: TDBEdit;
    Label27: TLabel;
    vendedor: TDBLookupComboBox;
    Label17: TLabel;
    Label18: TLabel;
    valor: TDBEdit;
    Label8: TLabel;
    cod: TDBEdit;
    nome: TDBEdit;
    Label2: TLabel;
    veiculo: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    placa: TDBEdit;
    Label6: TLabel;
    loja: TDBLookupComboBox;
    Label19: TLabel;
    situacao: TDBLookupComboBox;
    Label15: TLabel;
    gerencia: TDBLookupComboBox;
    Label16: TLabel;
    memo: TDBMemo;
    Radio: TRadioGroup;
    Edit1: TEdit;
    sButton1: TSpeedButton;
    relatorio: TSpeedButton;
    DBNavigator1: TDBNavigator;
    Label9: TLabel;
    Label11: TLabel;
    Tipo: TDBLookupComboBox;
    Shape1: TShape;
    Shape2: TShape;
    Label12: TLabel;
    Label23: TLabel;
    Panel7: TPanel;
    Label21: TLabel;
    data_ent: TDBDateEdit;
    procedure novoClick(Sender: TObject);
    procedure editarClick(Sender: TObject);
    procedure gravarClick(Sender: TObject);
    procedure cancelarClick(Sender: TObject);
    procedure sairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure codExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lojaClick(Sender: TObject);
    procedure memoKeyPress(Sender: TObject; var Key: Char);
    procedure relatorioClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure situacaoKeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
    procedure RadioClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure situacaoClick(Sender: TObject);
    procedure DeletarRegistro1Click(Sender: TObject);
    procedure saidaClick(Sender: TObject);
    procedure chegadaClick(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure TipoClick(Sender: TObject);
    procedure vendedorClick(Sender: TObject);
    procedure gerenciaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_cadmov: Tfrm_cadmov;

implementation

{$R *.dfm}

uses un_entrega, un_chama_servcli, un_conscond, un_conscli, dt_entregas;

procedure Tfrm_cadmov.cancelarClick(Sender: TObject);
begin
    If Application.Messagebox('Confirma Cancelamento de Entregas? ', 'Confirma��o',
    mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
    else
    exit;
    reg.ReadOnly := true;
    cod.ReadOnly := true;
    memo.ReadOnly := true;
    nome.ReadOnly := true;
    tipo.ReadOnly := true;
    data_ent.ReadOnly := true;
    veiculo.ReadOnly := true;
    data.ReadOnly := true;
    placa.ReadOnly := true;
    loja.ReadOnly := true;
    cliente.ReadOnly := true;
    bairro.ReadOnly := true;
    gerencia.ReadOnly := true;
    vendedor.ReadOnly := true;
    valor.ReadOnly := true;
    novo.Enabled := true;
    editar.Enabled := true;
    relatorio.Enabled := true;
    cancelar.Enabled := false;
    gravar.Enabled := false;
    sair.Enabled := true;
    Dtm_Entrega.qry_moventrega.Cancel;
    reg.setfocus;
end;

procedure Tfrm_cadmov.chegadaClick(Sender: TObject);
begin
   Dtm_Entrega.qry_moventrega.Edit;
   Dtm_Entrega.qry_moventregaHORARIO_CHEGADA.Value := '';
   Dtm_Entrega.qry_moventrega.Post;
end;

procedure Tfrm_cadmov.codExit(Sender: TObject);
var
  condutor: string;
  codigo: integer;
  transp: string;
  id_placa: string;
begin
   with Dtm_Entrega.qry_cadcondutor do
     begin
        Dtm_Entrega.qry_cadcondutor.Close;
        sql.Clear;
        sql.Add('SELECT * FROM CAD_CONDUTOR WHERE ID_CONDUTOR = :C');
        Parameters[0].Value:=cod.Text;
        Dtm_Entrega.qry_cadcondutor.Open;
     end;
     codigo:= Dtm_Entrega.qry_cadcondutor.Fields[0].AsInteger;
     condutor:= Dtm_Entrega.qry_cadcondutor.Fields[1].AsString;
     transp:= Dtm_Entrega.qry_cadcondutor.Fields[2].Asstring;
     id_placa:= Dtm_Entrega.qry_cadcondutor.Fields[3].Asstring;
     if condutor = '' then
     begin
        Application.MessageBox('C�digo Informado n�o Existe!','Erro',MB_ICONERROR);
        cod.Clear;
        cod.SetFocus;
        Abort;
     end
     else
       begin
          nome.Text := condutor;
          veiculo.Text := transp;
          placa.Text := id_placa;
          bairro.SetFocus;
       end;
end;

procedure Tfrm_cadmov.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
    If odd(Dtm_Entrega.qry_moventrega.RecNo) then
        begin
            dbgrid1.Canvas.Font.Color:= clBlack;
            dbgrid1.Canvas.Brush.Color:= $00FFEFCE;
        end;
    if Dtm_Entrega.qry_moventregaSITUACAO.asstring = 'ENTREGA REALIZADA' then
       dbgrid1.Canvas.Font.Color := clGreen
    else
    if Dtm_Entrega.qry_moventregaSITUACAO.asstring = 'NAO REALIZADA' then
       dbgrid1.Canvas.Font.Color := clRed;
       dbgrid1.Canvas.FillRect(Rect);
       dbgrid1.DefaultDrawDataCell(Rect, dbgrid1.columns[DataCol].Field, State);
end;

procedure Tfrm_cadmov.DeletarRegistro1Click(Sender: TObject);
begin
  If Dtm_Entrega.qry_moventrega.RecordCount <> 0 then
  If Application.Messagebox('Confirma Exclus�o?', 'Confirmar',
     mb_Iconquestion + MB_YesNo + Mb_DefButton1) = IdYes Then
     begin
        Dtm_Entrega.qry_moventrega.Delete;
        nome.setfocus;
     end;
     If Dtm_Entrega.qry_moventrega.RecordCount = 0 then
        showmessage('Nao Existe Registro para Excluir');
end;

procedure Tfrm_cadmov.Edit1Change(Sender: TObject);
var
  Sql: string; // Pesquisando registros na tabela
  total :  currency;
begin
  Dtm_Entrega.qry_moventrega.Close;
  Dtm_Entrega.qry_moventrega.Sql.Clear;
  Dtm_Entrega.qry_moventrega.Sql.Add('select * from MOV_ENTREGAS');
  if (radio.ItemIndex = 0) then
    Sql := 'where CONDUTOR like ' + QuotedStr('%' + Edit1.Text + '%')
  else if (radio.ItemIndex = 1) then
    Sql := 'where DESTINO like ' + QuotedStr('%' + Edit1.Text + '%')
  else if (radio.ItemIndex = 2) then
    Sql := 'where SITUACAO like ' + QuotedStr('%' + Edit1.Text + '%');
    Dtm_Entrega.qry_moventrega.Sql.Add(Sql);
    Dtm_Entrega.qry_moventrega.Sql.Add('order by registro');
    Dtm_Entrega.qry_moventrega.open;
    total := 0;
    Dtm_Entrega.qry_moventrega.First;
    Dtm_Entrega.qry_moventrega.DisableControls;
    try
      while not Dtm_Entrega.qry_moventrega.eof do
      begin
         total := total + Dtm_Entrega.qry_moventrega.FieldByName('VALOR').AsCurrency;
         Dtm_Entrega.qry_moventrega.next;
      end;
      Dtm_Entrega.qry_moventrega.EnableControls;
      Label21.Caption := FormatFloat('#,###,###,##0.00', total);
    finally
    end;
end;

procedure Tfrm_cadmov.editarClick(Sender: TObject);
begin
    If Application.Messagebox('Confirma Altera��o de Entregas? ', 'Confirma��o',
    mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
    else
    exit;
//    Gauge1.Progress:=0;
    reg.ReadOnly := true;
    cod.ReadOnly := false;
    memo.ReadOnly := false;
    nome.ReadOnly := true;
    veiculo.ReadOnly := true;
    data_ent.ReadOnly := false;
    tipo.ReadOnly := false;
    data.ReadOnly := false;
    placa.ReadOnly := true;
    loja.ReadOnly := false;
    situacao.ReadOnly := false;
    cliente.ReadOnly := false;
    bairro.ReadOnly := false;
    gerencia.ReadOnly := false;
    vendedor.ReadOnly := false;
    valor.ReadOnly := false;
    novo.Enabled := false;
    relatorio.Enabled := false;
    editar.Enabled := false;
    cancelar.Enabled := true;
    gravar.Enabled := true;
    sair.Enabled := false;
    Dtm_Entrega.qry_moventrega.Edit;
    reg.setfocus;
end;

procedure Tfrm_cadmov.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  codigo: Integer; // Vari�vel do tipo integer
  x:integer;
  Function StrZero(Num: Real; Tam: Integer): String;
  // Fun��o para colocar zeros a esquerda
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
   Case Key of
        VK_F2: //Comando para teclas de atalho//
       begin
           If Application.Messagebox('Confirma Inclus�o de Entregas? ', 'Confirma��o',
              mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
           else
           exit;
           reg.ReadOnly := true;
           cod.ReadOnly := true;
           nome.ReadOnly := true;
           veiculo.ReadOnly := true;
           memo.ReadOnly := false;
           tipo.ReadOnly := false;
           data.ReadOnly := true;
           data_ent.ReadOnly := true;
           placa.ReadOnly := true;
           loja.ReadOnly := false;
           cliente.ReadOnly := false;
           bairro.ReadOnly := false;
           situacao.ReadOnly := true;
           gerencia.ReadOnly := true;
           vendedor.ReadOnly := true;
           valor.ReadOnly := false;
           novo.Enabled := false;
           editar.Enabled := false;
           relatorio.Enabled := false;
           cancelar.Enabled := true;
           gravar.Enabled := true;
           sair.Enabled := false;
           if Dtm_Entrega.qry_moventrega.RecordCount = 0 Then
              codigo := 1
           else
           begin
              Dtm_Entrega.qry_moventrega.Last;
              codigo := Dtm_Entrega.qry_moventregaREGISTRO.Asinteger + 1;
           end;
           Dtm_Entrega.qry_moventrega.Append;
           Dtm_Entrega.qry_moventregaREGISTRO.asstring := StrZero(codigo, 1);
           Dtm_Entrega.qry_moventregaDATA.asstring := DatetoStr(now());
           Dtm_Entrega.qry_moventregaHORA.asstring := TimetoStr(now());
           Dtm_Entrega.qry_moventregaLOJA.asstring := 'LOJA 5';
           Dtm_Entrega.qry_moventregaSITUACAO.asstring := 'EM PROCESSO';
           Dtm_Entrega.qry_moventregaVALOR.Value := 0.00;
           Dtm_Entrega.qry_moventregaKM_INICIAL.Value := 0;
           Dtm_Entrega.qry_moventregaKM_FINAL.Value := 0;
           cliente.setfocus;
       end;
    end;
    Case Key of
        VK_F3: //Comando para teclas de atalho//
           begin
             If Application.Messagebox('Confirma Grava��o de Entregas? ', 'Confirma��o',
             mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
             else
             exit;
             reg.ReadOnly := true;
             cod.ReadOnly := true;
             memo.ReadOnly := false;
             nome.ReadOnly := true;
             veiculo.ReadOnly := true;
             tipo.ReadOnly := true;
             data.ReadOnly := true;
             data_ent.ReadOnly := false;
             placa.ReadOnly := true;
             loja.ReadOnly := false;
             cliente.ReadOnly := true;
             bairro.ReadOnly := true;
             gerencia.ReadOnly := true;
             vendedor.ReadOnly := true;
             valor.ReadOnly := true;
             novo.Enabled := true;
             editar.Enabled := true;
             cancelar.Enabled := false;
             gravar.Enabled := false;
             relatorio.Enabled := true;
             sair.Enabled := true;
             Dtm_Entrega.qry_moventrega.Post;
             dbgrid1.setfocus;
           end;
    end;
end;
procedure Tfrm_cadmov.FormKeyPress(Sender: TObject; var Key: Char);
begin
   If Key=#13 Then
      Selectnext(ActiveControl,True,True);
end;

procedure Tfrm_cadmov.FormShow(Sender: TObject);
Var
  total : currency;
begin
//   Gauge1.Progress:=0;
   Dtm_Entrega.qry_moventrega.Open;
   Dtm_Entrega.qry_cadcondutor.Open;
   Dtm_Entrega.query_cli.Open;
   Dtm_Entrega.qry_realizadas.Open;
   Dtm_Entrega.qry_gerencia.Open;
   Dtm_Entrega.qry_lojas.Open;
   Dtm_Entrega.qry_vendedor.Open;
   Dtm_Entrega.qry_situacao.Open;
   Dtm_Entrega.qry_cadtipo.Open;
   Dtm_Entrega.tipo_pag.Open;
   reg.ReadOnly := true;
//   codcli.ReadOnly := true;
   cliente.ReadOnly := true;
   bairro.ReadOnly := true;
   vendedor.ReadOnly := true;
   tipo.ReadOnly:=true;
   cod.ReadOnly := true;
   nome.ReadOnly := true;
   veiculo.ReadOnly := true;
   placa.ReadOnly := true;
   loja.ReadOnly := true;
   situacao.ReadOnly := true;
   gerencia.ReadOnly := true;
   memo.ReadOnly := true;
   novo.Enabled := true;
   editar.Enabled := true;
   relatorio.Enabled := true;
   cancelar.Enabled := false;
   gravar.Enabled := false;
   sair.Enabled := true;
   total := 0;
   Dtm_Entrega.qry_moventrega.First;
   Dtm_Entrega.qry_moventrega.DisableControls;
   try
     while not Dtm_Entrega.qry_moventrega.eof do
     begin
        total := total + Dtm_Entrega.qry_moventrega.FieldByName('VALOR').AsCurrency;
        Dtm_Entrega.qry_moventrega.next;
     end;
     Dtm_Entrega.qry_moventrega.EnableControls;
     Label21.Caption := FormatFloat('#,###,###,##0.00', total);
   finally
   end;
end;

procedure Tfrm_cadmov.gerenciaClick(Sender: TObject);
var
   NomeCampo: String;
   a: integer;
   i: integer;
   total : currency;
begin
   if Dtm_Entrega.qry_moventregaSITUACAO.AsString = 'ENTREGA REALIZADA' then
     begin
         Dtm_Entrega.qry_realizadas.Append;
         For i := 0 To Dtm_Entrega.qry_moventrega.FieldCount - 1 Do
         begin
            NomeCampo := Dtm_Entrega.qry_moventrega.Fields[i].FieldName;
            Dtm_Entrega.qry_realizadas.FieldbyName(NomeCampo).value :=
            Dtm_Entrega.qry_moventrega.FieldbyName(NomeCampo).value;
         end;
         Dtm_Entrega.qry_realizadas.post;
      end;
     if Dtm_Entrega.qry_moventregaSITUACAO.AsString = 'ENTREGA REALIZADA' then
        begin
            Dtm_Entrega.qry_moventrega.Delete;
            showmessage('ENTREGA REALIZADA COM SUCESSO!');
            sair.Enabled := true;
            gravar.Enabled := false;
            cancelar.Enabled := false;
            novo.Enabled := true;
            editar.Enabled := true;
        end
     else
     Showmessage('ENTREGA AINDA N�O FOI REALIZADA, VERIFIQUE !');
     total := 0;
     Dtm_Entrega.qry_moventrega.First;
     Dtm_Entrega.qry_moventrega.DisableControls;
     try
       while not Dtm_Entrega.qry_moventrega.eof do
       begin
          total := total + Dtm_Entrega.qry_moventrega.FieldByName('VALOR').AsCurrency;
          Dtm_Entrega.qry_moventrega.next;
       end;
       Dtm_Entrega.qry_moventrega.EnableControls;
       Label21.Caption := FormatFloat('#,###,###,##0.00', total);
     finally
     end;
end;

procedure Tfrm_cadmov.gravarClick(Sender: TObject);
var
  x : integer;
  total : currency;
begin
    If Application.Messagebox('Confirma Grava��o de Entregas? ', 'Confirma��o',
    mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
    else
    exit;
    reg.ReadOnly := true;
    cod.ReadOnly := true;
    memo.ReadOnly := true;
    nome.ReadOnly := true;
    veiculo.ReadOnly := true;
    data_ent.ReadOnly := true;
    tipo.ReadOnly := true;
    data.ReadOnly := true;
    placa.ReadOnly := true;
    loja.ReadOnly := true;
    cliente.ReadOnly := true;
    bairro.ReadOnly := true;
    gerencia.ReadOnly := true;
    vendedor.ReadOnly := true;
    valor.ReadOnly := true;
    novo.Enabled := true;
    editar.Enabled := true;
    cancelar.Enabled := false;
    gravar.Enabled := false;
    relatorio.Enabled := true;
    sair.Enabled := true;
    Dtm_Entrega.qry_moventrega.Post;
    dbgrid1.setfocus;
    total := 0;
    Dtm_Entrega.qry_moventrega.First;
    Dtm_Entrega.qry_moventrega.DisableControls;
    try
      while not Dtm_Entrega.qry_moventrega.eof do
      begin
         total := total + Dtm_Entrega.qry_moventrega.FieldByName('VALOR').AsCurrency;
         Dtm_Entrega.qry_moventrega.next;
      end;
      Dtm_Entrega.qry_moventrega.EnableControls;
      Label21.Caption := FormatFloat('#,###,###,##0.00', total);
    finally
    end;
    Dtm_Entrega.qry_moventrega.Open;
 end;

procedure Tfrm_cadmov.lojaClick(Sender: TObject);
begin
   cliente.SetFocus;
end;

procedure Tfrm_cadmov.memoKeyPress(Sender: TObject; var Key: Char);
begin
   Key := AnsiUpperCase( Key )[1];
end;

procedure Tfrm_cadmov.novoClick(Sender: TObject);
var
  codigo: Integer; // Vari�vel do tipo integer
  Function StrZero(Num: Real; Tam: Integer): String;
  // Fun��o para colocar zeros a esquerda
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
    If Application.Messagebox('Confirma Inclus�o de Entregas? ', 'Confirma��o',
    mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
    else
    exit;
//    Gauge1.Progress:=0;
    reg.ReadOnly := true;
    cod.ReadOnly := true;
    nome.ReadOnly := true;
    veiculo.ReadOnly := true;
    data_ent.ReadOnly := true;
    memo.ReadOnly := false;
    tipo.ReadOnly := false;
    data.ReadOnly := true;
    placa.ReadOnly := true;
    loja.ReadOnly := false;
    tipo.ReadOnly := false;
    cliente.ReadOnly := false;
    bairro.ReadOnly := false;
    situacao.ReadOnly := true;
    gerencia.ReadOnly := true;
    vendedor.ReadOnly := false;
    valor.ReadOnly := false;
    novo.Enabled := false;
    editar.Enabled := false;
    relatorio.Enabled := false;
    cancelar.Enabled := true;
    gravar.Enabled := true;
    sair.Enabled := false;
    if Dtm_Entrega.qry_moventrega.RecordCount = 0 Then
       codigo := 1
    else
        begin
           Dtm_Entrega.qry_moventrega.Last;
           codigo := Dtm_Entrega.qry_moventregaREGISTRO.Asinteger + 1;
        end;
        Dtm_Entrega.qry_moventrega.Append;
        Dtm_Entrega.qry_moventregaREGISTRO.asstring := StrZero(codigo, 1);
        Dtm_Entrega.qry_moventregaDATA.asstring := DatetoStr(now());
        Dtm_Entrega.qry_moventregaHORA.asstring := TimetoStr(now());
        Dtm_Entrega.qry_moventregaLOJA.asstring := 'LOJA 5';
        Dtm_Entrega.qry_moventregaSITUACAO.asstring := 'EM PROCESSO';
        Dtm_Entrega.qry_moventregaVALOR.Value := 0.00;
        Dtm_Entrega.qry_moventregaKM_INICIAL.Value := 0;
        Dtm_Entrega.qry_moventregaKM_FINAL.Value := 0;
        Dtm_Entrega.qry_moventregaDATA_ENTREGA.AsString := DatetoStr(now());
        cliente.SetFocus;
end;

procedure Tfrm_cadmov.RadioClick(Sender: TObject);
begin
   Edit1.SetFocus;
end;

procedure Tfrm_cadmov.saidaClick(Sender: TObject);
begin
   Dtm_Entrega.qry_moventrega.Edit;
   Dtm_Entrega.qry_moventregaHORARIO_SAIDA.Value := '';
   Dtm_Entrega.qry_moventrega.Post;
end;

procedure Tfrm_cadmov.sairClick(Sender: TObject);
begin
   Dtm_Entrega.qry_moventrega.Close;
   Dtm_Entrega.qry_situacao.Close;
   Dtm_Entrega.qry_gerencia.Close;
   Dtm_Entrega.query_cli.Close;
   Dtm_Entrega.qry_cadcondutor.Close;
   Dtm_Entrega.qry_lojas.Close;
   Dtm_Entrega.qry_vendedor.Close;
   Dtm_Entrega.qry_realizadas.Close;
   Dtm_Entrega.qry_cadtipo.Close;
   Dtm_Entrega.tipo_pag.Close;
   Close;
end;

procedure Tfrm_cadmov.sButton1Click(Sender: TObject);
begin
   frm_conscond.cod := 1;
   bairro.SetFocus;
   frm_conscond.showmodal;
end;

procedure Tfrm_cadmov.sButton2Click(Sender: TObject);
begin
{   frm_conscli.cod := 1;
   vendedor.SetFocus;
   frm_conscli.showmodal;}
end;

procedure Tfrm_cadmov.situacaoClick(Sender: TObject);
begin
   gerencia.SetFocus;
end;

procedure Tfrm_cadmov.situacaoKeyPress(Sender: TObject; var Key: Char);
begin
   Dtm_Entrega.qry_moventrega.Edit;
   situacao.ReadOnly := false;
end;

procedure Tfrm_cadmov.SpeedButton1Click(Sender: TObject);
begin
   Dtm_Entrega.qry_moventrega.Edit;
   Dtm_Entrega.qry_moventregaHORARIO_SAIDA.asstring := TimetoStr(now());
   Dtm_Entrega.qry_moventrega.Post;
end;

procedure Tfrm_cadmov.SpeedButton2Click(Sender: TObject);
begin
   Dtm_Entrega.qry_moventrega.Edit;
   Dtm_Entrega.qry_moventregaHORARIO_CHEGADA.asstring := TimetoStr(now());
   Dtm_Entrega.qry_moventrega.Post;
end;

procedure Tfrm_cadmov.TipoClick(Sender: TObject);
begin
   valor.SetFocus;
end;

procedure Tfrm_cadmov.vendedorClick(Sender: TObject);
begin
   nome.SetFocus;
end;

procedure Tfrm_cadmov.relatorioClick(Sender: TObject);
begin
   frm_rel_servcli.showmodal;
end;

end.
