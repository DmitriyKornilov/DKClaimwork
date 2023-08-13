unit UStatisticForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  fpspreadsheetgrid, BCButton, DividerBevel;

type

  { TStatisticForm }

  TStatisticForm = class(TForm)
    Bevel3: TBevel;
    DividerBevel3: TDividerBevel;
    ExitButton: TSpeedButton;
    ExportButton: TBCButton;
    LogGrid: TsWorksheetGrid;
    MainPanel: TPanel;
    ToolPanel: TPanel;
    ZoomPanel: TPanel;
    procedure ExitButtonClick(Sender: TObject);
  private

  public

  end;

var
  StatisticForm: TStatisticForm;

implementation

{$R *.lfm}

{ TStatisticForm }

procedure TStatisticForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

end.

