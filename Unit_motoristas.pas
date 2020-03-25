unit Unit_motoristas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ADODB, Grids, DBGrids, ExtCtrls;

type
  Tform_motoristas = class(TForm)
    dbgrid_motoristas: TDBGrid;
    ds_motoristas: TDataSource;
    btn_fechar: TBitBtn;
    adoquery_motoristas: TADOQuery;
    edt_num: TEdit;
    edt_nome: TEdit;
    edt_idade: TEdit;
    edt_salario: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btn_inserir: TBitBtn;
    adoquery_aux: TADOQuery;
    rb_feminino: TRadioButton;
    rb_masculino: TRadioButton;
    btn_alterar: TBitBtn;
    btn_salvar: TBitBtn;
    btn_excluir: TBitBtn;
    procedure btn_fecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_inserirClick(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure btn_alterarClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_motoristas: Tform_motoristas;
  num_motorista: string;
  sexo: string;
implementation

uses Unit_menu;

{$R *.dfm}

procedure Tform_motoristas.btn_fecharClick(Sender: TObject);
begin
Close;
end;

procedure Tform_motoristas.FormShow(Sender: TObject);
begin
adoquery_motoristas.Open;
btn_salvar.Visible:=false;

end;

procedure Tform_motoristas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
adoquery_motoristas.Close;
end;

procedure Tform_motoristas.btn_inserirClick(Sender: TObject);
begin
  if  (trim(edt_num.Text)='') or (trim(edt_nome.Text)='') or
      (trim(edt_idade.Text)='') or (not rb_feminino.Checked and not rb_masculino.Checked) or
      (trim(edt_salario.Text)='') then
    begin
    ShowMessage('Preencha todos os campos!');
    end
  else
    begin
      Form_menu.ConexaoBD.BeginTrans;

      if rb_feminino.Checked then
        begin
         sexo:= 'F';
        end
      else
        begin
          sexo:= 'M';
        end;
      adoquery_aux.SQL.Text:=' INSERT INTO MOTORISTAS VALUES (' +
                              edt_num.Text + ',' + QuotedStr(edt_nome.Text) + ',' +
                             edt_idade.Text + ',' + QuotedStr(sexo) + ',' +
                             edt_salario.Text + ')';
      adoquery_aux.ExecSQL;
      Form_menu.ConexaoBD.CommitTrans;
      adoquery_motoristas.Close;
      adoquery_motoristas.Open;
      ShowMessage('Opera��o executada com sucesso!');
      edt_num.Clear;
      edt_nome.Clear;
      edt_idade.Clear;
      edt_salario.Clear;
      rb_masculino.Checked:=false;
      rb_feminino.Checked:=false;

    end;
end;

procedure Tform_motoristas.btn_alterarClick(Sender: TObject);
begin
  btn_inserir.Visible:=false;
  btn_excluir.Visible:=false;
  btn_salvar.Visible:=true;
  num_motorista:=adoquery_motoristas.fieldbyname('num_motorista').AsString;
  edt_num.Text:=num_motorista;
  edt_nome.Text:=adoquery_motoristas.fieldbyname('nome').AsString;
  edt_idade.Text:=adoquery_motoristas.fieldbyname('idade').AsString;
  edt_salario.Text:=adoquery_motoristas.fieldbyname('salario').AsString;
  if adoquery_motoristas.FieldByName('sexo').AsString ='F' then
    begin
      rb_feminino.Checked := true;
      rb_masculino.Checked := false;
    end
  else
    begin
      rb_masculino.Checked := true;
      rb_feminino.Checked := false;
    end;
end;

procedure Tform_motoristas.btn_salvarClick(Sender: TObject);
begin
  Form_menu.ConexaoBD.BeginTrans;
  if rb_feminino.Checked then
        begin
         sexo:= 'F';
        end
      else
        begin
          sexo:= 'M';
        end;
  adoquery_aux.SQL.Text:='UPDATE MOTORISTAS SET ' +
                          ' NUM_MOTORISTA = ' + edt_num.Text + ',' +
                          ' NOME = ' + QuotedStr(edt_nome.Text) + ',' +
                          ' IDADE = ' + edt_idade.Text + ',' +
                          ' SEXO = ' + QuotedStr(sexo) + ',' +
                          ' SALARIO = ' + edt_salario.Text +
                          ' WHERE NUM_MOTORISTA = ' + num_motorista;
  adoquery_aux.ExecSQL;
  Form_menu.ConexaoBD.CommitTrans;
  adoquery_motoristas.Close;
  adoquery_motoristas.Open;
  showmessage('Informa��es atualizadas com sucesso!');
  edt_num.Clear;
  edt_nome.Clear;
  edt_idade.Clear;
  rb_masculino.Checked:=false;
  rb_feminino.Checked:=false;
  edt_salario.Clear;
  btn_inserir.Visible:=true;
  btn_excluir.Visible:=true;
  btn_salvar.Visible:=false;


end;

procedure Tform_motoristas.btn_excluirClick(Sender: TObject);
begin
  num_motorista:=adoquery_motoristas.fieldbyname('num_motorista').AsString;
  Form_menu.ConexaoBD.BeginTrans;
  adoquery_aux.SQL.Text:='DELETE FROM MOTORISTAS ' +
                          ' WHERE NUM_MOTORISTA = ' + num_motorista;
  adoquery_aux.ExecSQL;
  Form_menu.ConexaoBD.CommitTrans;
  adoquery_motoristas.Close;
  adoquery_motoristas.Open;
  showmessage('Motorista excluido com sucesso!')

end;

end.
