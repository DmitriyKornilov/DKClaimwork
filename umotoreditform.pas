unit UMotorEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DateTimePicker, DividerBevel,

  DK_Vector, DK_Dialogs, DK_StrUtils, DK_Const,

  USQLite, UUtils;

type

  { TMotorEditForm }

  TMotorEditForm = class(TForm)
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MotorNameComboBox: TComboBox;
    MotorNumEdit: TEdit;
    SaveButton: TSpeedButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    CanFormClose: Boolean;
    MotorNameIDs: TIntVector;
    procedure DataLoad;
  public
    LogID: Integer;
  end;

var
  MotorEditForm: TMotorEditForm;

implementation

{$R *.lfm}

{ TMotorEditForm }

procedure TMotorEditForm.FormCreate(Sender: TObject);
begin
  CanFormClose:= True;
  DT1.Date:= Date;
  SQLite.MotorIDsAndNamesLoad(MotorNameComboBox, MotorNameIDs);
end;

procedure TMotorEditForm.CancelButtonClick(Sender: TObject);
begin
  CanFormClose:= True;
  ModalResult:= mrCancel;
end;

procedure TMotorEditForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= CanFormClose;
end;

procedure TMotorEditForm.FormShow(Sender: TObject);
begin
  DataLoad;
end;

procedure TMotorEditForm.SaveButtonClick(Sender: TObject);
var
  MotorNameID: Integer;
  MotorNum: String;
  MotorDate: TDate;

  CanAdd: Boolean;

  ExistingLogID: Integer;
  ExistingMotorName, ExistingMotorNum: String;
  ExistingMotorDate: TDate;
begin
  CanFormClose:= False;

  if MotorNameComboBox.Text=EmptyStr then
  begin
    ShowInfo('Не указано наименование двигателя!');
    Exit;
  end;

  MotorNum:= STrim(MotorNumEdit.Text);
  if SEmpty(MotorNum) then
  begin
    ShowInfo('Не указан номер электродвигателя!');
    Exit;
  end;

  MotorNameID:= MotorNameIDs[MotorNameComboBox.ItemIndex];
  MotorDate:= DT1.Date;

  if LogID=0 then  //new
  begin
    CanAdd:= True;
    if SQLite.MotorFind(MotorNameID, MotorNum, MotorDate,
    ExistingLogID, ExistingMotorName, ExistingMotorNum, ExistingMotorDate) then
      if not Confirm('В базе есть похожий электродвигатель' +
        SYMBOL_BREAK +
        MotorFullName(ExistingMotorName, ExistingMotorNum, ExistingMotorDate) + '!' +
        SYMBOL_BREAK +
        'Записать новый электродвигатель' +
        SYMBOL_BREAK +
        MotorFullName(ExistingMotorName, MotorNum, MotorDate) + '?') then
        CanAdd:= False;
    if CanAdd then
    begin
      SQLite.MotorAdd(MotorNameID, MotorNum, MotorDate);
      LogID:= SQLite.MotorLastWritedLogID;
    end
    else
      LogID:= ExistingLogID;
  end
  else //edit
    SQLite.MotorUpdate(LogID, MotorNameID, MotorNum, MotorDate);

  CanFormClose:= True;
  ModalResult:= mrOK;
end;

procedure TMotorEditForm.DataLoad;
var
  MotorNameID, Ind: Integer;
  MotorNum, S: String;
  MotorDate: TDate;
begin
  if LogID=0 then Exit;
  SQLite.MotorLoad(LogID, MotorNameID, S, MotorNum, MotorDate);
  MotorNumEdit.Text:= MotorNum;
  Ind:= VIndexOf(MotorNameIDs, MotorNameID);
  if Ind>=0 then
    MotorNameComboBox.ItemIndex:= Ind;
  DT1.Date:= MotorDate;
end;

end.

