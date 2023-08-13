unit URepairDatesEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, DateTimePicker, DividerBevel,

  USQLite;

type

  { TRepairDatesEditForm }

  TRepairDatesEditForm = class(TForm)
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    EndCheckBox: TCheckBox;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    DT2: TDateTimePicker;
    Label1: TLabel;
    SaveButton: TSpeedButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure EndCheckBoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    procedure DataLoad;
  public
    LogID: Integer;
  end;

var
  RepairDatesEditForm: TRepairDatesEditForm;

implementation

{$R *.lfm}

{ TRepairDatesEditForm }

procedure TRepairDatesEditForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TRepairDatesEditForm.EndCheckBoxChange(Sender: TObject);
begin
  DT2.Enabled:= EndCheckBox.Checked;
end;

procedure TRepairDatesEditForm.FormShow(Sender: TObject);
begin
  DataLoad;
end;

procedure TRepairDatesEditForm.SaveButtonClick(Sender: TObject);
var
  BD, ED: TDate;
  Status: Integer;
begin
  ED:= 0;
  BD:= DT1.Date;
  Status:= 3; //в ремонте

  if EndCheckBox.Checked then
  begin
    ED:= DT2.Date;
    Status:= 4; //завершено
  end;

  SQLite.RepairDatesUpdate(LogID, Status, BD, ED);

  ModalResult:= mrOK;
end;

procedure TRepairDatesEditForm.DataLoad;
var
  BD, ED: TDate;
begin
  DT1.Date:= Date;
  DT2.Date:= Date;

  SQLite.RepairDatesLoad(LogID, BD, ED);

  if BD>0 then
    DT1.Date:= BD;
  EndCheckBox.Checked:= ED>0;
  if ED>0 then
    DT2.Date:= ED;
  DT2.Enabled:= EndCheckBox.Checked;
end;

end.

