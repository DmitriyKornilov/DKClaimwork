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
    BeginCheckBox: TCheckBox;
    NotNeedCheckBox: TCheckBox;
    SaveButton: TSpeedButton;
    procedure BeginCheckBoxChange(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure EndCheckBoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NotNeedCheckBoxChange(Sender: TObject);
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

procedure TRepairDatesEditForm.BeginCheckBoxChange(Sender: TObject);
begin
  DT1.Enabled:= BeginCheckBox.Checked;
  EndCheckBox.Enabled:= BeginCheckBox.Checked;
  if not BeginCheckBox.Checked then
    EndCheckBox.Checked:= False;
end;

procedure TRepairDatesEditForm.EndCheckBoxChange(Sender: TObject);
begin
  DT2.Enabled:= EndCheckBox.Checked;
end;

procedure TRepairDatesEditForm.FormShow(Sender: TObject);
begin
  DataLoad;
end;

procedure TRepairDatesEditForm.NotNeedCheckBoxChange(Sender: TObject);
begin
  if NotNeedCheckBox.Checked then
    BeginCheckBox.Checked:= False;
  BeginCheckBox.Enabled:= not NotNeedCheckBox.Checked;
end;

procedure TRepairDatesEditForm.SaveButtonClick(Sender: TObject);
var
  BD, ED: TDate;
  Status: Integer;
begin
  BD:= 0;
  ED:= 0;
  Status:= 0; //не указано
  if NotNeedCheckBox.Checked then
    Status:= 3 //отказано
  else begin
    if BeginCheckBox.Checked then
    begin
      BD:= DT1.Date;
      Status:= 1; //в работе
    end;
    if EndCheckBox.Checked then
    begin
      ED:= DT2.Date;
      Status:= 2; //завершено
    end;
  end;

  if Status=0 then
    SQLite.RepairDatesDelete(LogID)
  else
    SQLite.RepairDatesUpdate(LogID, Status, BD, ED);
  ModalResult:= mrOK;
end;

procedure TRepairDatesEditForm.DataLoad;
var
  BD, ED: TDate;
  Status: Integer;
begin
  DT1.Date:= Date;
  DT2.Date:= Date;

  SQLite.RepairDatesLoad(LogID, Status, BD, ED);

  BeginCheckBox.Checked:= BD>0;
  if BD>0 then
    DT1.Date:= BD;
  EndCheckBox.Checked:= ED>0;
  if ED>0 then
    DT2.Date:= ED;

  NotNeedCheckbox.Checked:= Status=3;
  BeginCheckBox.Enabled:= not NotNeedCheckBox.Checked;
  DT1.Enabled:= (not NotNeedCheckBox.Checked) and BeginCheckBox.Checked;
  EndCheckBox.Enabled:= DT1.Enabled;
  DT2.Enabled:= (not NotNeedCheckBox.Checked) and EndCheckBox.Checked;
end;

end.

