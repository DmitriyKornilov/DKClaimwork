unit UNoticeEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, rxcurredit, DateTimePicker, DividerBevel, FileUtil,

  DK_Vector, DK_Dialogs, DK_StrUtils, DK_PriceUtils,

  USQLite, UUtils;

type

  { TNoticeEditForm }

  TNoticeEditForm = class(TForm)
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    NotChangeFileCheckBox: TCheckBox;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    Label6: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    FileNameEdit: TEdit;
    Label8: TLabel;
    MotorNameLabel: TLabel;
    LocationNameComboBox: TComboBox;
    MoneyEdit: TCurrencyEdit;
    OpenButton: TSpeedButton;
    OpenDialog1: TOpenDialog;
    UserNameComboBox: TComboBox;
    Label5: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    LetterNumEdit: TEdit;
    SaveButton: TSpeedButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NotChangeFileCheckBoxChange(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    CanFormClose: Boolean;
    LetterType: Byte;
    UserIDs: TIntVector;
    LocationIDs: TIntVector;

    MotorName, MotorNum: String;
    MotorDate: TDate;

    OldLetterNum: String;
    OldLetterDate: TDate;

    procedure DataLoad;
    procedure DocFileOpen;
  public
    Category: Byte;
    LogID: Integer;

  end;

var
  NoticeEditForm: TNoticeEditForm;

implementation

{$R *.lfm}

{ TNoticeEditForm }

procedure TNoticeEditForm.FormCreate(Sender: TObject);
begin
  CanFormClose:= True;
  DT1.Date:= Date;
  SQLite.LocationIDsAndNamesLoad(LocationNameComboBox, LocationIDs);
  SQLite.UserIDsAndNamesLoad(UserNameComboBox, UserIDs);
end;

procedure TNoticeEditForm.CancelButtonClick(Sender: TObject);
begin
  CanFormClose:= True;
  ModalResult:= mrCancel;
end;

procedure TNoticeEditForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= CanFormClose;
end;

procedure TNoticeEditForm.FormShow(Sender: TObject);
begin
  Height:= 500;

  case Category of
  1: LetterType:= 0;
  2: LetterType:= 6;
  3: LetterType:= 10;
  end;

  Caption:= LETTER_NAMES[LetterType];
  Label1.Caption:= LETTER_NAMES[LetterType];

  Label6.Visible:= Category=1;
  LocationNameComboBox.Visible:= Category=1;

  Label7.Visible:= Category=3;
  MoneyEdit.Visible:= Category=3;

  DataLoad;
end;

procedure TNoticeEditForm.NotChangeFileCheckBoxChange(Sender: TObject);
begin
  if NotChangeFileCheckBox.Checked then
    FileNameEdit.Clear;
  FileNameEdit.Enabled:= not NotChangeFileCheckBox.Checked;
  OpenButton.Enabled:= FileNameEdit.Enabled;
end;

procedure TNoticeEditForm.OpenButtonClick(Sender: TObject);
begin
  DocFileOpen;
end;

procedure TNoticeEditForm.SaveButtonClick(Sender: TObject);
var
  SrcFileName: String;
  LocationID, UserID: Integer;
  LetterNum: String;
  LetterDate: TDate;
  MoneyValue: Int64;
begin
  CanFormClose:= False;

  if UserNameComboBox.Text=EmptyStr then
  begin
    ShowInfo('Не указан отправитель!');
    Exit;
  end;

  LetterNum:= STrim(LetterNumEdit.Text);
  if SEmpty(LetterNum) then
  begin
    ShowInfo('Не указан номер письма!');
    Exit;
  end;

  if Category = 1 then
  begin
    if LocationNameComboBox.Text=EmptyStr then
    begin
      ShowInfo('Не указано предприятие!');
      Exit;
    end;
    LocationID:= LocationIDs[LocationNameComboBox.ItemIndex];
  end
  else if Category = 3 then
  begin
    MoneyValue:= Trunc(100*MoneyEdit.Value);
    if MoneyValue=0 then
    begin
      ShowInfo('Не указана сумма к возмещению!');
      Exit;
    end;
  end;

  UserID:= UserIDs[UserNameComboBox.ItemIndex];
  LetterDate:= DT1.Date;

  if not NotChangeFileCheckBox.Checked then
  begin
    SrcFileName:= STrim(FileNameEdit.Text);
    DocumentSave(LetterType, SrcFileName, MotorDate, MotorName, MotorNum,
                 OldLetterDate, OldLetterNum, LetterDate, LetterNum);
  end;

  if Category = 1 then
    SQLite.ReclamationNoticeUpdate(LogID, UserID, LocationID, LetterNum, LetterDate)
  else if Category = 2 then
    SQLite.RepairNoticeUpdate(LogID, UserID, LetterNum, LetterDate)
  else if Category = 3 then
    SQLite.PretensionNoticeUpdate(LogID, UserID, MoneyValue, LetterNum, LetterDate);

  CanFormClose:= True;
  ModalResult:= mrOK;
end;

procedure TNoticeEditForm.DataLoad;
var
  Ind, UserID, LocationID: Integer;
  MoneyValue: Int64;
begin
  if LogID=0 then Exit;

  SQLite.MotorLoad(LogID, Ind, MotorName, MotorNum, MotorDate);
  MotorNameLabel.Caption:= MotorFullName(MotorName, MotorNum, MotorDate);

  SQLite.LetterLoad(LogID, LetterType, OldLetterNum, OldLetterDate);
  LetterNumEdit.Text:= OldLetterNum;
  if OldLetterDate>0 then
    DT1.Date:= OldLetterDate;

  if Category=1 then
  begin
    SQLite.ReclamationInfoLoad(LogID, UserID, LocationID);
    Ind:= VIndexOf(LocationIDs, LocationID);
    if Ind>=0 then
      LocationNameComboBox.ItemIndex:= Ind;
  end
  else if Category=2 then
  begin
    SQLite.RepairInfoLoad(LogID, UserID);
  end
  else if Category=3 then
  begin
    SQLite.PretensionInfoLoad(LogID, UserID, MoneyValue);
    if MoneyValue>0 then
      MoneyEdit.Text:= PriceIntToStr(MoneyValue);
  end;

  Ind:= VIndexOf(UserIDs, UserID);
  if Ind>=0 then
    UserNameComboBox.ItemIndex:= Ind;
end;

procedure TNoticeEditForm.DocFileOpen;
begin
  if not OpenDialog1.Execute then Exit;
  FileNameEdit.ReadOnly:= False;
  FileNameEdit.Text:= OpenDialog1.FileName;
  FileNameEdit.ReadOnly:= True;
end;

end.

