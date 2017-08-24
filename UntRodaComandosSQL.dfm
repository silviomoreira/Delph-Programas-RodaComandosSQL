object FrmRodaComandosSQL: TFrmRodaComandosSQL
  Left = 192
  Top = 107
  Width = 725
  Height = 502
  Caption = 'Roda Comandos SQL - v2.4'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object sbLimpa: TSpeedButton
    Left = 392
    Top = 393
    Width = 23
    Height = 22
    Hint = 'Limpa a janela'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333000000000
      3333333777777777F3333330F777777033333337F3F3F3F7F3333330F0808070
      33333337F7F7F7F7F3333330F080707033333337F7F7F7F7F3333330F0808070
      33333337F7F7F7F7F3333330F080707033333337F7F7F7F7F3333330F0808070
      333333F7F7F7F7F7F3F33030F080707030333737F7F7F7F7F7333300F0808070
      03333377F7F7F7F773333330F080707033333337F7F7F7F7F333333070707070
      33333337F7F7F7F7FF3333000000000003333377777777777F33330F88877777
      0333337FFFFFFFFF7F3333000000000003333377777777777333333330777033
      3333333337FFF7F3333333333000003333333333377777333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = sbLimpaClick
  end
  object sbHelp: TSpeedButton
    Left = 275
    Top = 393
    Width = 23
    Height = 22
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333FFFFF3333333333F797F3333333333F737373FF333333BFB999BFB
      33333337737773773F3333BFBF797FBFB33333733337333373F33BFBFBFBFBFB
      FB3337F33333F33337F33FBFBFB9BFBFBF3337333337F333373FFBFBFBF97BFB
      FBF37F333337FF33337FBFBFBFB99FBFBFB37F3333377FF3337FFBFBFBFB99FB
      FBF37F33333377FF337FBFBF77BF799FBFB37F333FF3377F337FFBFB99FB799B
      FBF373F377F3377F33733FBF997F799FBF3337F377FFF77337F33BFBF99999FB
      FB33373F37777733373333BFBF999FBFB3333373FF77733F7333333BFBFBFBFB
      3333333773FFFF77333333333FBFBF3333333333377777333333}
    NumGlyphs = 2
    OnClick = sbHelpClick
  end
  object bbExecuta: TBitBtn
    Left = 307
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Executa'
    TabOrder = 0
    OnClick = bbExecutaClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333333333333333333EEEEEEEEEEEEEEE333FFFFFFFFFFFFF3E00000000000
      00E337777777777777F3E0F77777777770E337F33333333337F3E0F333333333
      70E337F3333F333337F3E0F33303333370E337F3337FF33337F3E0F333003333
      70E337F33377FF3337F3E0F33300033370E337F333777FF337F3E0F333000033
      70E337F33377773337F3E0F33300033370E337F33377733337F3E0F333003333
      70E337F33377333337F3E0F33303333370E337F33373333337F3E0F333333333
      70E337F33333333337F3E0FFFFFFFFFFF0E337FFFFFFFFFFF7F3E00000000000
      00E33777777777777733EEEEEEEEEEEEEEE33333333333333333}
    NumGlyphs = 2
  end
  object sbStatus: TStatusBar
    Left = 0
    Top = 445
    Width = 709
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 150
      end
      item
        Alignment = taCenter
        Width = 50
      end>
  end
  object pcSQL: TPageControl
    Left = 8
    Top = 5
    Width = 673
    Height = 366
    ActivePage = tsComandosExecute
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = pcSQLChange
    object tsComandosExecute: TTabSheet
      Caption = 'Comandos Execute'
      object meSQL: TMemo
        Left = 0
        Top = 0
        Width = 665
        Height = 337
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        OnKeyUp = meSQLKeyUp
      end
    end
    object tsLog: TTabSheet
      Caption = 'Log de Resultados'
      ImageIndex = 1
      object meLog: TMemo
        Left = 0
        Top = 0
        Width = 665
        Height = 337
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object tsComandosSelect: TTabSheet
      Caption = 'Comandos Select'
      ImageIndex = 2
      object meSQLSel: TMemo
        Left = 0
        Top = 0
        Width = 665
        Height = 113
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 116
        Width = 665
        Height = 221
        DataSource = dsSQLSel
        TabOrder = 1
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
  end
  object gbAlias: TGroupBox
    Left = 8
    Top = 374
    Width = 225
    Height = 62
    Caption = 'Selecione o Alias:'
    TabOrder = 3
    object cbAlias: TComboBox
      Left = 10
      Top = 24
      Width = 206
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbAliasChange
    end
  end
  object gbConfiguracoes: TGroupBox
    Left = 456
    Top = 374
    Width = 225
    Height = 62
    Caption = 'Configura'#231#245'es:'
    TabOrder = 4
    object chExecutaScript: TCheckBox
      Left = 8
      Top = 13
      Width = 156
      Height = 17
      Hint = 
        'Direcionado p/ a execu'#231#227'o de scripts. O ";" pode estar no final ' +
        'da '#250'ltima linha de cada comando ou na linha posterior a cada com' +
        'ando.'
      Caption = 'Executa comandos a cada ;'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = chExecutaScriptClick
    end
    object chDebuga: TCheckBox
      Left = 8
      Top = 27
      Width = 118
      Height = 17
      Hint = 
        'Cada linha processada internamente '#233' mostrada na tela no momento' +
        ' do seu tratamento.'
      Caption = 'Debuga(cada linha)'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object chNaoInterromper: TCheckBox
      Left = 8
      Top = 41
      Width = 213
      Height = 17
      Hint = 'N'#227'o interromper, ao dar erro em algum(ns) comando(s) '
      Caption = 'N'#227'o interromper, ao dar erro'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
  end
  object SpinButton1: TSpinButton
    Left = 685
    Top = 26
    Width = 20
    Height = 47
    DownGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000808000000000000080800000808000008080000080
      8000008080000080800000808000000000000000000000000000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000008080000080800000808000000000000000000000000000000000000000
      0000000000000000000000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    TabOrder = 5
    UpGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000080
      8000008080000080800000000000000000000000000000000000000000000080
      8000008080000080800000808000008080000000000000000000000000000080
      8000008080000080800000808000008080000080800000808000000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    OnDownClick = SpinButton1DownClick
    OnUpClick = SpinButton1UpClick
  end
  object dba: TDatabase
    AliasName = 'Fx Pessoal 001_26'
    DatabaseName = 'DBFluxus'
    SessionName = 'Default'
    Left = 362
    Top = 422
  end
  object qeSQL: TQuery
    DatabaseName = 'DBFluxus'
    Left = 396
    Top = 422
  end
  object dsSQLSel: TDataSource
    DataSet = qeSQLSel
    Left = 272
    Top = 422
  end
  object qeSQLSel: TQuery
    DatabaseName = 'DBFluxus'
    Left = 325
    Top = 422
  end
end
