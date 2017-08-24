program RodaComandosSQL;

uses
  Forms,
  UntRodaComandosSQL in 'UntRodaComandosSQL.pas' {FrmRodaComandosSQL};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmRodaComandosSQL, FrmRodaComandosSQL);
  Application.Run;
end.
