unit un_cadusu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Mask, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Buttons, Data.DB;

type
  Tfrm_cadusu = class(TForm)
    Panel2: TPanel;
    novo: TSpeedButton;
    editar: TSpeedButton;
    excluir: TSpeedButton;
    cancelar: TSpeedButton;
    gravar: TSpeedButton;
    sair: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    cod: TDBEdit;
    nome: TDBEdit;
    Label3: TLabel;
    senha: TDBEdit;
    confirma: TDBEdit;
    Label4: TLabel;
    data: TDBEdit;
    Label5: TLabel;
    DBGrid1: TDBGrid;
    procedure novoClick(Sender: TObject);
    procedure editarClick(Sender: TObject);
    procedure excluirClick(Sender: TObject);
    procedure cancelarClick(Sender: TObject);
    procedure gravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sairClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure confirmaExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_cadusu: Tfrm_cadusu;

implementation

{$R *.dfm}

uses un_entrega;

procedure Tfrm_cadusu.cancelarClick(Sender: TObject);
begin
   If Application.Messagebox('Confirma Cancelamento? ', 'Confirma��o',
      mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
   else
   exit;
   cod.ReadOnly := true;
   data.ReadOnly := true;
   nome.ReadOnly := true;
   senha.ReadOnly := true;
   confirma.ReadOnly := true;
   novo.Enabled := true;
   editar.Enabled := true;
   excluir.Enabled := true;
   cancelar.Enabled := false;
   gravar.Enabled := false;
   sair.Enabled := true;
   Dtm_Entrega.qry_cadusu.Cancel;
   nome.setfocus;
end;

procedure Tfrm_cadusu.confirmaExit(Sender: TObject);
begin
  if Dtm_Entrega.qry_cadusuconfirma.Value <> Dtm_Entrega.qry_cadususenha.Value then
  begin
    showmessage('SENHA DE CONFIRMA��O N�O PODE SER DIFERENTE DA SENHA');
    confirma.setfocus;
  end
  else
    dbgrid1.setfocus;
end;

procedure Tfrm_cadusu.editarClick(Sender: TObject);
begin
   If Application.Messagebox('Confirma Altera��o? ', 'Confirma��o',
      mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
   else
   exit;
   cod.ReadOnly := false;
   data.ReadOnly := true;
   nome.ReadOnly := false;
   senha.ReadOnly := false;
   confirma.ReadOnly := false;
   novo.Enabled := false;
   editar.Enabled := false;
   excluir.Enabled := false;
   cancelar.Enabled := true;
   gravar.Enabled := true;
   sair.Enabled := false;
   Dtm_Entrega.qry_cadusu.Edit;
   nome.setfocus;
end;

procedure Tfrm_cadusu.excluirClick(Sender: TObject);
begin
   If Dtm_Entrega.qry_cadusu.RecordCount <> 0 then
      If Application.MessageBox('Confirma Exclus�o?','Confirmar',Mb_IconQuestion+MB_YesNo+MB_DefButton1)=IdYes Then
      begin
        Dtm_Entrega.qry_cadusu.delete;
        cod.SetFocus;
      end;
      If Dtm_Entrega.qry_cadusu.RecordCount = 0 then
         showmessage('Todos os Registro Foram Excluidos com Sucesso!!');
end;

procedure Tfrm_cadusu.FormKeyPress(Sender: TObject; var Key: Char);
begin
   If Key=#13 Then
      Selectnext(ActiveControl,True,True);
end;

procedure Tfrm_cadusu.FormShow(Sender: TObject);
begin
    Dtm_Entrega.qry_cadusu.Open;
end;

procedure Tfrm_cadusu.gravarClick(Sender: TObject);
begin
   If Application.Messagebox('Confirma Grava��o? ', 'Confirma��o',
      mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
   else
   exit;
   cod.ReadOnly := true;
   data.ReadOnly := true;
   nome.ReadOnly := true;
   senha.ReadOnly := true;
   confirma.ReadOnly := true;
   novo.Enabled := true;
   editar.Enabled := true;
   excluir.Enabled := true;
   cancelar.Enabled := false;
   gravar.Enabled := false;
   sair.Enabled := true;
   Dtm_Entrega.qry_cadusu.Post;
   nome.setfocus;
end;

procedure Tfrm_cadusu.novoClick(Sender: TObject);
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
   If Application.Messagebox('Confirma Inclus�o? ', 'Confirma��o',
      mb_Iconquestion + Mb_OkCancel + Mb_DefButton1) = IdOk then
   else
   exit;
   cod.ReadOnly := false;
   data.ReadOnly := true;
   nome.ReadOnly := false;
   senha.ReadOnly := false;
   confirma.ReadOnly := false;
   novo.Enabled := false;
   editar.Enabled := false;
   excluir.Enabled := false;
   cancelar.Enabled := true;
   gravar.Enabled := true;
   sair.Enabled := false;
   if Dtm_Entrega.qry_cadusu.RecordCount = 0 Then
      codigo := 1
   else
   begin
     Dtm_Entrega.qry_cadusu.Last;
     codigo := Dtm_Entrega.qry_cadusuCOD_USU.Asinteger + 1;
   end;
   Dtm_Entrega.qry_cadusu.Append;
   Dtm_Entrega.qry_cadusuCOD_USU.asstring := StrZero(codigo, 1);
   Dtm_Entrega.qry_cadusuDATA.asstring := DateTimetoStr(now());
   nome.setfocus;
end;

procedure Tfrm_cadusu.sairClick(Sender: TObject);
begin
   Dtm_Entrega.qry_cadusu.Close;
   Close;
end;

end.
