unit UNoticeEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, Spin, rxcurredit, DateTimePicker, DividerBevel, FileUtil,

  DK_Vector, DK_Dialogs, DK_StrUtils, DK_PriceUtils, DK_VSTTables,

  USQLite, UUtils, VirtualTrees;

type

  { TNoticeEditForm }

  TNoticeEditForm = class(TForm)
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    Label9: TLabel;
    NotChangeFileCheckBox: TCheckBox;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    Label6: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    FileNameEdit: TEdit;
    Label8: TLabel;
    LocationNameComboBox: TComboBox;
    MoneyEdit: TCurrencyEdit;
    OpenButton: TSpeedButton;
    OpenDialog1: TOpenDialog;
    MileageSpinEdit: TSpinEdit;
    UserNameComboBox: TComboBox;
    Label5: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    LetterNumEdit: TEdit;
    SaveButton: TSpeedButton;
    VT1: TVirtualStringTree;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NotChangeFileCheckBoxChange(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    CanFormClose: Boolean;

    VSTMotorList: TVSTCheckTable;
    LogIDs: TIntVector;
    MotorNames, MotorNums: TStrVector;
    MotorDates: TDateVector;

    LetterType: Byte;
    UserIDs: TIntVector;
    LocationIDs: TIntVector;

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

  VSTMotorList:= TVSTCheckTable.Create(VT1);
  VSTMotorList.SelectedBGColor:= VT1.Color;
  VSTMotorList.HeaderVisible:= False;
  VSTMotorList.AddColumn('Список');

  SQLite.LocationIDsAndNamesLoad(LocationNameComboBox, LocationIDs);
  SQLite.UserIDsAndNamesLoad(UserNameComboBox, UserIDs);
end;

procedure TNoticeEditForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VSTMotorList);
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
  //Height:= 500;

  case Category of
  1: LetterType:= 0;
  2: LetterType:= 6;
  3: LetterType:= 10;
  end;

  Caption:= LETTER_NAMES[LetterType];
  Label1.Caption:= LETTER_NAMES[LetterType];

  Label6.Visible:= Category=1;
  LocationNameComboBox.Visible:= Category=1;
  Label9.Visible:= Category=1;
  MileageSpinEdit.Visible:= Category=1;

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
  LocationID, UserID, Mileage, i: Integer;
  LetterNum: String;
  LetterDate: TDate;
  MoneyValue: Int64;
  UsedLogIDs: TIntVector;
  UsedMotorDates: TDateVector;
  UsedMotorNames, UsedMotorNums: TStrVector;
begin
  CanFormClose:= False;

  if VSTMotorList.IsAllUnchecked then
  begin
    ShowInfo('Не выбран ни один электродвигатель!');
    Exit;
  end;

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
    Mileage:= MileageSpinEdit.Value;
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

  UsedLogIDs:= nil;
  UsedMotorDates:= nil;
  UsedMotorNames:= nil;
  UsedMotorNums:= nil;
  for i:= 0 to High(LogIDs) do
  begin
    if not VSTMotorList.Checked[i] then continue;
    VAppend(UsedLogIDs, LogIDs[i]);
    VAppend(UsedMotorDates, MotorDates[i]);
    VAppend(UsedMotorNames, MotorNames[i]);
    VAppend(UsedMotorNums, MotorNums[i]);
  end;

  SrcFileName:= STrim(FileNameEdit.Text);
  if not DocumentsUpdate(not NotChangeFileCheckBox.Checked, LetterType, SrcFileName,
                  UsedMotorDates, UsedMotorNames, UsedMotorNums,
                  OldLetterDate, OldLetterNum, LetterDate, LetterNum) then Exit;

  if Category = 1 then
    SQLite.ReclamationNoticeUpdate(UsedLogIDs, UserID, LocationID, Mileage, LetterNum, LetterDate)
  else if Category = 2 then
    SQLite.RepairNoticeUpdate(UsedLogIDs, UserID, LetterNum, LetterDate)
  else if Category = 3 then
    SQLite.PretensionNoticeUpdate(UsedLogIDs, UserID, MoneyValue, LetterNum, LetterDate);

  CanFormClose:= True;
  ModalResult:= mrOK;
end;

procedure TNoticeEditForm.DataLoad;
var
  Ind, UserID, LocationID: Integer;
  MoneyValue: Int64;
  Motors: TStrVector;
begin
  SQLite.LetterLoad(LogID, LetterType, OldLetterNum, OldLetterDate);
  LetterNumEdit.Text:= OldLetterNum;
  if OldLetterDate>0 then
    DT1.Date:= OldLetterDate;

  SQLite.MotorsWithoutNoticeLoad(LogID, LetterType, Category<>3,
                                 LogIDs, MotorNames, MotorNums, MotorDates);
  Motors:= MotorFullNames(MotorNames, MotorNums, MotorDates);
  VSTMotorList.SetColumn('Список', Motors, taLeftJustify);
  VSTMotorList.Draw;
  if IsDocumentEmpty(OldLetterDate, OldLetterNum) then
    VSTMotorList.Checked[0]:= True
  else
    VSTMotorList.CheckAll(True);


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

