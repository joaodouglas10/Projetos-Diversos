unit U_Senha;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, StdCtrls, Buttons, Mask, DB, DBTables, ExtCtrls, jpeg,
  Vcl.Themes, Vcl.Styles, sBitBtn, sPanel, sSkinManager, sLabel, Vcl.ComCtrls, IniFiles;
type
  TFm_Senha = class(TForm)
    Image1: TImage;
    Label4: TLabel;
    codigo: TEdit;
    SpeedButton1: TSpeedButton;
    nome: TEdit;
    editsenha: TEdit;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    Label3: TLabel;
    Label5: TLabel;
    StatusBar1: TStatusBar;
    Label6: TLabel;
    Label7: TLabel;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure codigoExit(Sender: TObject);
  private
     tentativas: Smallint;
     { Private declarations }
  public
    { Public declarations }
  end;

var
  Fm_Senha: TFm_Senha;

implementation

uses un_principal, un_entrega, un_cadusu, un_consusu, un_provisorios;

{$R *.dfm}

procedure TFm_Senha.BitBtn2Click(Sender: TObject);
begin
//fechando o formul�rio com o bot�o cancelar//
  close;
end;

procedure TFm_Senha.codigoExit(Sender: TObject);
begin// Comando para filtrar por codigo do cliente
   if Dtm_Entrega.qry_cadusu.Locate('COD_USU', codigo.text, [loPartialKey]) and (Trim(Dtm_Entrega.qry_cadusu.FieldByName('USUARIO').AsString) <> '') then
     begin
        nome.text := Dtm_Entrega.qry_cadusu.FieldByName('USUARIO').AsString;
        editsenha.SetFocus;
     end;
end;

procedure TFm_Senha.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then
    Selectnext(ActiveControl, true, true);
end;

procedure TFm_Senha.FormShow(Sender: TObject);
var
  file_config : TIniFile;
  path_db : string;
  pass_db : string;
begin
//abrindo a tabela na base de dados//
   codigo.SetFocus;
   Dtm_Entrega.qry_cadusu.open;
   file_config := TIniFile.Create('C:\Projeto_Studio Atraente\Projeto\Win32\Debug\config.ini');
   path_db := file_config.ReadString('Conexao','Banco','');
   pass_db := file_config.ReadString('Conexao','Senha','');
end;

procedure TFm_Senha.sBitBtn1Click(Sender: TObject);
Var
   sql : String; //Vari�vel de entrada//
begin//login do sistema
  If (nome.Text <> '') and (editsenha.Text = Dtm_Entrega.qry_cadusuSENHA.AsString) Then
     begin
         sql := 'select * from TRF_CAD_USU where USUARIO = ' + QuotedStr(nome.Text);
         sql := sql + ' and senha = ' + QuotedStr(editsenha.Text);
         Dtm_Entrega.qry_cadusu.Active := True;
         fm_senha.hide;
         frm_principal.Showmodal;
         fm_senha.Close;
     end;
     inc(tentativas); //tentativas de acesso ao sistema//
     if tentativas < 3 then
        begin
            MessageDlg(Format('Tentativa %d de 3', [tentativas]), mtError, [mbOk], 0);
        end
     else
         begin
             MessageDlg(Format('%d� tentativa de acesso ao sistema.',
             [tentativas]) + #13 + 'A aplica��o ser� fechada voc� n�o tem acesso ao sistema!', mtError,[mbOk], 0);
             ModalResult := mrCancel;
             close;
         end;
         MessageDlg('Usu�rio n�o cadastrado ou senha inv�lida', mtInformation, [mbOK], 0);
         editsenha.Text := '';
end;

procedure TFm_Senha.sBitBtn2Click(Sender: TObject);
begin
   close;
end;

procedure TFm_Senha.SpeedButton1Click(Sender: TObject);
begin
  frm_consusu.cod := 1;
  editsenha.SetFocus;
  frm_consusu.showmodal;
end;

end.
