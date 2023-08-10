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
    CheckBox1: TCheckBox;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    DT2: TDateTimePicker;
    Label1: TLabel;
    SaveButton: TSpeedButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
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

procedure TRepairDatesEditForm.CheckBox1Change(Sender: TObject);
begin
  DT2.Enabled:= CheckBox1.Checked;
end;

procedure TRepairDatesEditForm.FormShow(Sender: TObject);
begin
  DataLoad;
end;

procedure TRepairDatesEditForm.SaveButtonClick(Sender: TObject);
var
  BD, ED: TDate;
begin
  BD:= DT1.Date;
  if CheckBox1.Checked then
    ED:= DT2.Date
  else
    ED:= 0;
  SQLite.RepairDatesUpdate(LogID, BD, ED);
  ModalResult:= mrOK;
end;

procedure TRepairDatesEditForm.DataLoad;
var
  BD, ED: TDate;
begin
  SQLite.RepairDatesLoad(LogID, BD, ED);
  if BD>0 then
    DT1.Date:= BD
  else
    DT1.Date:= Date;
  if ED>0 then
  begin
    DT2.Date:= ED;
    CheckBox1.Checked:= True;
  end
  else begin
    DT2.Date:= Date;
    DT2.Enabled:= False;
  end;
end;

end.

