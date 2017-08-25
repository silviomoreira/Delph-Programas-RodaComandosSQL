unit UntRodaComandosSQL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, Db, DBTables, Grids, DBGrids, Spin;

type
  TFrmRodaComandosSQL = class(TForm)
    dba: TDatabase;
    qeSQL: TQuery;
    bbExecuta: TBitBtn;
    sbStatus: TStatusBar;
    sbLimpa: TSpeedButton;
    pcSQL: TPageControl;
    tsComandosExecute: TTabSheet;
    tsLog: TTabSheet;
    meSQL: TMemo;
    meLog: TMemo;
    gbAlias: TGroupBox;
    cbAlias: TComboBox;
    sbHelp: TSpeedButton;
    tsComandosSelect: TTabSheet;
    meSQLSel: TMemo;
    DBGrid1: TDBGrid;
    dsSQLSel: TDataSource;
    qeSQLSel: TQuery;
    gbConfiguracoes: TGroupBox;
    chExecutaScript: TCheckBox;
    chDebuga: TCheckBox;
    chNaoInterromper: TCheckBox;
    SpinButton1: TSpinButton;
    procedure bbExecutaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbAliasChange(Sender: TObject);
    procedure sbHelpClick(Sender: TObject);
    procedure sbLimpaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chExecutaScriptClick(Sender: TObject);
    procedure pcSQLChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure meSQLKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    function FConectaBD: Boolean;
    function FCriticaEPrepara: Boolean;
    function FExecutaComandosEmScript(): Boolean;
    function FExecutaComandosLinhaALinha(): Boolean;
    function FExecutaSelects: Boolean;
    procedure PGuardaComandosBemSucedidos;
    procedure PAtribuiVetorExec;
    procedure PAtribuiVetorSel;
  public
    { Public declarations }
  end;

type
   TArrayStrings = array[0..9] of String;
var
  FrmRodaComandosSQL: TFrmRodaComandosSQL;
  uinLinhaMemoSQLExec, uinLinhaArrayExec, uinCicloExec, uinLinhaMemoSQLSel, uinLinhaArraySel, uinCicloSel, uinUltimaLinhaExecutada: Integer;
  uarMemo:    TArrayStrings = ( '', '', '', '', '', '', '', '', '', '' );
  uarMemoSel: TArrayStrings = ( '', '', '', '', '', '', '', '', '', '' );

implementation

{$R *.DFM}

procedure TFrmRodaComandosSQL.bbExecutaClick(Sender: TObject);
var lboErro: Boolean;
begin
   if not FConectaBD() then Exit;

   if pcSQL.ActivePage = tsComandosExecute then
   begin
      if not FCriticaEPrepara() then Exit;
      meLog.Lines.Clear;
      qeSQL.Close;
      qeSQL.SQL.Clear;
      qeSQL.SQL.Add('');
      if chExecutaScript.Checked then
         lboErro := FExecutaComandosEmScript()
      else // Executa linha a linha
         lboErro := FExecutaComandosLinhaALinha();
      qeSQL.Close;
      if (lboErro) and (uinUltimaLinhaExecutada < meSql.Lines.Count-1) then
         ShowMessage('Interrompido devido a erros.')
      else
      if lboErro then
         ShowMessage('Concluído, mas com erros.')
      else
         ShowMessage('Concluído.');
   end
   else if pcSQL.ActivePage = tsComandosSelect then
   begin
      lboErro := FExecutaSelects();
   end;
   if lboErro then Exit;
   PGuardaComandosBemSucedidos();
end;

function TFrmRodaComandosSQL.FConectaBD: Boolean;
var bRetorno: Boolean;
begin
   bRetorno := True;
   try
      if not dba.Connected then
         dba.Connected := True;
   except on e:exception do
      begin
         ShowMessage('Erro ao conectar banco: '+e.Message);
         bRetorno := False;
      end;
   end;

   Result := bRetorno;
end;

function TFrmRodaComandosSQL.FCriticaEPrepara: Boolean;
begin
   if (Pos(';', meSQL.Lines.Text) > 0) and (not chExecutaScript.Checked) then
   begin
      ShowMessage('Foi verificada a existência de ";". Marque a opção "Executa comandos a cada ;" ou retire-os.');
      Result := False;
      Exit;
   end;
   // Apaga a última linha se estiver em branco
   if (meSql.Lines.Count > 0) and ( Trim(meSql.Lines[meSql.Lines.Count-1]) = '') then
      meSql.Lines.Delete(meSql.Lines.Count-1);
   Result := True;
end;

function TFrmRodaComandosSQL.FExecutaComandosEmScript(): Boolean;
var i,nc: Integer;
    lboErro: Boolean;
begin
   lboErro := False;
   nc := 0;
   For i:=0 to meSql.Lines.Count-1 do
   begin
      if chDebuga.Checked then
         ShowMessage( 'Ultima col. da linha: ' + Copy(Trim(meSQL.Lines[i]),Length(Trim(meSQL.Lines[i])),1) + #13 +
                      'Linha: ' + meSQL.Lines[i]);
      if (Trim(meSQL.Lines[i]) <> '')        and
         (Copy(meSQL.Lines[i],1,3) <> 'REM') and
         (Copy(meSQL.Lines[i],1,1) <> ';')   and
         (Copy(Trim(meSQL.Lines[i]),Length(Trim(meSQL.Lines[i])),1) <> ';') then
         qeSQL.SQL[0] := qeSQL.SQL[0] + ' ' + meSQL.Lines[i];
      if Copy(Trim(meSQL.Lines[i]),Length(Trim(meSQL.Lines[i])),1) = ';' then
      begin //
         Inc(nc);
         if Length(Trim(meSQL.Lines[i])) > 1 then
            qeSQL.SQL[0] := qeSQL.SQL[0] + Copy(Trim(meSQL.Lines[i]),1,Length(Trim(meSQL.Lines[i]))-1);
         sbStatus.Panels[1].Text := 'Executando comando '+InttoStr(nc)+', linha '+InttoStr(i+1)+' das '+IntToStr(meSQL.Lines.Count)+' linhas no total.';
         Application.ProcessMessages;
         try
            qeSQL.ExecSQL;
            meLog.Lines.Add( 'Linhas afetadas: '+IntToStr(qeSQL.RowsAffected) );
         except on e:exception do
            begin
               ShowMessage('Erro ao rodar comando: '+qeSQL.SQL[0]+'. Erro: '+e.Message);
               meLog.Lines.Add('Erro no comando: '+qeSQL.SQL[0]);
               lboErro := True;
               if not chNaoInterromper.Checked then
                  Break;
            end;
         end;
         qeSQL.SQL[0] := '';
      end;
   end; // Fim <For>
   uinUltimaLinhaExecutada := i;

   Result := lboErro;
end;

function TFrmRodaComandosSQL.FExecutaComandosLinhaALinha: Boolean;
var i: Integer;
    lboErro: Boolean;
begin
   lboErro := False;
   For i:=0 to meSql.Lines.Count-1 do
   begin
      qeSQL.SQL[0] := meSQL.Lines[i];
      sbStatus.Panels[1].Text := 'Executando comando '+InttoStr(i+1)+' de '+IntToStr(meSQL.Lines.Count);
      Application.ProcessMessages;
      try
         qeSQL.ExecSQL;
         meLog.Lines.Add( 'Linhas afetadas: '+IntToStr(qeSQL.RowsAffected) );
      except on e:exception do
         begin
            ShowMessage('Erro ao rodar comando: '+meSQL.Lines[i]+'. Erro: '+e.Message);
            meLog.Lines.Add('Erro no comando: '+meSQL.Lines[i]+' | Linha do comando: '+InttoStr(i+1));
            lboErro := True;
            if not chNaoInterromper.Checked then
               Break;
         end;
      end;
   end; // Fim <For>
   uinUltimaLinhaExecutada := i;

   Result := lboErro;
end;

function TFrmRodaComandosSQL.FExecutaSelects: Boolean;
var lboErro: Boolean;
begin
   lboErro := False;
   qeSQLSel.Close;
   // Apaga a última linha se estiver em branco
   if (meSqlSel.Lines.Count > 0) and ( Trim(meSqlSel.Lines[meSqlSel.Lines.Count-1]) = '') then
      meSqlSel.Lines.Delete(meSqlSel.Lines.Count-1);
   //
   meLog.Lines.Clear;
   qeSQLSel.SQL.Clear;
   qeSQLSel.SQL.Add('');
   qeSQLSel.SQL.Assign(meSQLSel.Lines);
   sbStatus.Panels[1].Text := 'Executando comando SELECT';
   Application.ProcessMessages;
   try
      qeSQLSel.ExecSQL;
      meLog.Lines.Add( 'Linhas afetadas: '+IntToStr(qeSQLSel.RowsAffected) );
      try
         qeSQLSel.Open;
      except
      end;
   except on e:exception do
      begin
         ShowMessage('Erro ao rodar comando. Erro: '+e.Message);
         meLog.Lines.Add('Erro no comando.');
         lboErro := True;
      end;
   end;

   Result := lboErro;
end;

procedure TFrmRodaComandosSQL.PGuardaComandosBemSucedidos;
var i: Integer;
begin
   // Guarda no vetor os comandos bem sucedidos - uinCiclo inicia c/ 0 e vai até 9
   if pcSQL.ActivePage = tsComandosExecute then
   begin
      for i := 9-uinCicloExec to 8 do
         uarMemo[i] := uarMemo[i+1];
      uarMemo[9] := uarMemo[0];
      PAtribuiVetorExec;
      if uinCicloExec < 9 then
         Inc(uinCicloExec)
      else
         uinCicloExec := 0;
   end
   else
   if pcSQL.ActivePage = tsComandosSelect then
   begin
      for i := 9-uinCicloSel to 8 do
         uarMemoSel[i] := uarMemoSel[i+1];
      uarMemoSel[9] := uarMemoSel[0];
      PAtribuiVetorSel;
      if uinCicloSel < 9 then
         Inc(uinCicloSel)
      else
         uinCicloSel := 0;
   end;
end;

procedure TFrmRodaComandosSQL.FormCreate(Sender: TObject);
begin
   Session.GetAliasNames(cbAlias.Items);
   cbAlias.Sorted := True;
   uinLinhaMemoSQLExec := 1;
   uinLinhaArrayExec := 0;
   uinCicloExec := 0;
   uinLinhaMemoSQLSel := 1;
   uinLinhaArraySel := 0;
   uinCicloSel := 0;

end;

procedure TFrmRodaComandosSQL.cbAliasChange(Sender: TObject);
begin
   if cbAlias.Text <> '' then
   begin
      qeSQL.Close;
      dba.Connected := False;
      dba.AliasName := cbAlias.Text;
      try
         dba.Connected := True;
      except on e:exception do
         ShowMessage('Erro ao conectar banco: '+e.Message);
      end;
   end;
end;

procedure TFrmRodaComandosSQL.sbHelpClick(Sender: TObject);
begin
   if pcSQL.ActivePage = tsComandosExecute then
   begin
      ShowMessage('Executa comandos SQL CREATE, DROP, INSERT, UPDATE, DELETE e outros, menos o SELECT, um após o outro.');
      ShowMessage('Cada comando deve ser colocado inteiramente em uma linha, se não tiver marcada a opção "Executa comandos a cada ;"');
   end
   else
   if pcSQL.ActivePage = tsComandosSelect then
      ShowMessage('Executa comandos SQL SELECT.');
end;

procedure TFrmRodaComandosSQL.sbLimpaClick(Sender: TObject);
begin
   if Application.MessageBox('Limpa área de comandos ?','Consulta',MB_YESNO + MB_DEFBUTTON1) = IDYES then
   begin
      if pcSQL.ActivePage = tsComandosExecute then
      begin
         meSql.Clear;
         uinLinhaMemoSQLExec := 1;
      end
      else
      if pcSQL.ActivePage = tsComandosSelect then
      begin
         meSqlSel.Clear;
         uinLinhaMemoSQLSel := 1;
      end;
   end;
end;

procedure TFrmRodaComandosSQL.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   dba.Connected := False;
end;

procedure TFrmRodaComandosSQL.chExecutaScriptClick(Sender: TObject);
begin
   chDebuga.Enabled := chExecutaScript.Checked;
end;

procedure TFrmRodaComandosSQL.pcSQLChange(Sender: TObject);
begin
   gbConfiguracoes.Visible := (pcSQL.ActivePage = tsComandosExecute);
end;

procedure TFrmRodaComandosSQL.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key=VK_F5 then
      bbExecutaClick(nil);
end;

// ====================================================================================================== //
// * Lógica - Atualmente ao clicar nas setas:                                                             //
// * 1)Atribui sql ao elemento corrente do vetor                                   | VETOR[E] := MEMO.SQL //
// * 2)Incrementa/decrementa valor da var. que indica o elemento corrente do vetor | E++ ou E--           //
// * 3)Atribui ao memo o conteúdo(sql) do elemento atual do vetor                  | MEMO.SQL := VETOR[E] //
// ====================================================================================================== //
procedure TFrmRodaComandosSQL.SpinButton1DownClick(Sender: TObject);
begin
   if pcSQL.ActivePage = tsComandosExecute then
   begin
      PAtribuiVetorExec;
      if uinLinhaArrayExec < 9 then
         Inc(uinLinhaArrayExec)
      else
         uinLinhaArrayExec := 0;
      meSQL.Clear;
      meSQL.Lines[0] := uarMemo[uinLinhaArrayExec];
   end
   else
   if pcSQL.ActivePage = tsComandosSelect then
   begin
      PAtribuiVetorSel;
      if uinLinhaArraySel < 9 then
         Inc(uinLinhaArraySel)
      else
         uinLinhaArraySel := 0;
      meSQLSel.Clear;
      meSQLSel.Lines[0] := uarMemoSel[uinLinhaArraySel];
   end;
end;

procedure TFrmRodaComandosSQL.SpinButton1UpClick(Sender: TObject);
begin
   if pcSQL.ActivePage = tsComandosExecute then
   begin
      PAtribuiVetorExec;
      if uinLinhaArrayExec > 0 then
         Dec(uinLinhaArrayExec)
      else
         uinLinhaArrayExec := 9;
      meSQL.Clear;
      meSQL.Lines[0] := uarMemo[uinLinhaArrayExec];
   end
   else
   if pcSQL.ActivePage = tsComandosSelect then
   begin
      PAtribuiVetorSel;
      if uinLinhaArraySel > 0 then
         Dec(uinLinhaArraySel)
      else
         uinLinhaArraySel := 9;
      meSQLSel.Clear;
      meSQLSel.Lines[0] := uarMemoSel[uinLinhaArraySel];
   end;
end;

procedure TFrmRodaComandosSQL.PAtribuiVetorExec;
var i: Integer;
begin
   uarMemo[uinLinhaArrayExec] := '';
   for i:=0 to meSQL.Lines.Count do
      if i = 0 then
         uarMemo[uinLinhaArrayExec] := meSQL.Lines[i]
      else
         uarMemo[uinLinhaArrayExec] := uarMemo[uinLinhaArrayExec] + #13#10 + meSQL.Lines[i];
end;

procedure TFrmRodaComandosSQL.PAtribuiVetorSel;
var i: Integer;
begin
   uarMemoSel[uinLinhaArraySel] := '';
   for i:=0 to meSQLSel.Lines.Count do
      if i = 0 then
         uarMemoSel[uinLinhaArraySel] := meSQLSel.Lines[i]
      else
         uarMemoSel[uinLinhaArraySel] := uarMemoSel[uinLinhaArraySel] + #13#10 + meSQLSel.Lines[i];
end;

procedure TFrmRodaComandosSQL.meSQLKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var coluna: Integer;
begin
   With meSQL do
   begin
      uinLinhaMemoSQLExec:= Perform(EM_LINEFROMCHAR,SelStart, 0);
      coluna:= SelStart - Perform(EM_LINEINDEX, uinLinhaMemoSQLExec, 0);
   end;
   sbStatus.Panels[0].Text := 'linha '+InttoStr(uinLinhaMemoSQLExec)+'| coluna '+InttoStr(coluna);
   Application.ProcessMessages;
end;

{
// --------------------------------------------------------------------------------------------------- //
// * Lógica da pilha de comandos bem sucedidos                                                         //
// --------------------------------------------------------------------------------------------------- //
1)Inicializa no ONCREATE()
uinCiclo := 0
2)Move a pilha
for i := 9-uinCiclo to 8 do
    VETOR[uinCiclo] := VETOR[uinCiclo+1]
VETOR[9] := VETOR[0]
3)Atribui sql ao elemento corrente do vetor
VETOR[E] := MEMO.SQL
4)Incrementa/decrementa valor da var. que indica o elemento corrente do vetor
if uinCiclo < 9 then
  Inc(uinCiclo);
else
  uinCiclo := 0;

// =================================================================================================== //
// ao clicar no <F5>, procura elemento anterior do vetor                                               //
// enquanto n não atingir o tamanho do vetor, preenche até n, o elemento com o elemento posterior      //
// =================================================================================================== //
* primeiro ciclo:
9 = 0
---------
0 - atual

* no proximo ciclo(2o):
8 = 9
9 = 0
---------
0 - atual

* no proximo ciclo(3o):
7 = 8
8 = 9
9 = 0
---------
0 - atual
// --------------------------------------------------------------------------------------------------- //
}

end.
