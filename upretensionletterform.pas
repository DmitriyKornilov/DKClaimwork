unit UPretensionLetterForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, EditBtn, DateTimePicker, DividerBevel, VirtualTrees,

  DK_Vector, DK_Matrix, DK_StrUtils, DK_Dialogs, DK_VSTTables,

  USQLite, UUtils,

  UPretensionLetterStandardForm, ULetterCustomForm;

type

  { TPretensionLetterForm }

  TPretensionLetterForm = class(TForm)
    AddButton: TSpeedButton;
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    ChoosePanel: TPanel;
    DelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    FileNameEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LetterCustomCreateButton: TButton;
    LetterNameLabel: TLabel;
    LetterNumEdit: TEdit;
    LetterStandardCreateButton: TButton;
    NotChangeFileCheckBox: TCheckBox;
    NotNeedCheckBox: TCheckBox;
    OpenButton: TSpeedButton;
    Panel1: TPanel;
    SaveButton: TSpeedButton;
    SearchLabel: TLabel;
    SearchNumEdit: TEditButton;
    SearchPanel: TPanel;
    StatusComboBox: TComboBox;
    VT1: TVirtualStringTree;
    VT2: TVirtualStringTree;
    procedure AddButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LetterCustomCreateButtonClick(Sender: TObject);
    procedure LetterStandardCreateButtonClick(Sender: TObject);
    procedure NotNeedCheckBoxChange(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SearchNumEditButtonClick(Sender: TObject);
    procedure SearchNumEditChange(Sender: TObject);
    procedure VT1DblClick(Sender: TObject);
    procedure VT2DblClick(Sender: TObject);
  private
    CanFormClose: Boolean;

    UserID: Integer;
    UserNameR: String;
    OldLetterNum: String;
    OldLetterDate: TDate;
    OldPretensionIDs: TIntVector;
    OldMotorNames, OldMotorNums: TStrMatrix;
    OldMotorDates: TDateMatrix;

    VSTFreeMotorList: TVSTTable;
    FreePretensionIDs: TIntVector;
    FreeMotors: TStrVector;
    FreeNoticeNums: TStrVector;
    FreeNoticeDates: TDateVector;
    FreeMoneyValues: TInt64Vector;
    FreeMotorNames, FreeMotorNums: TStrMatrix;
    FreeMotorDates: TDateMatrix;

    VSTBusyMotorList: TVSTTable;
    BusyPretensionIDs: TIntVector;
    BusyMotors: TStrVector;
    BusyNoticeNums: TStrVector;
    BusyNoticeDates: TDateVector;
    BusyMoneyValues: TInt64Vector;
    BusyMotorNames, BusyMotorNums: TStrMatrix;
    BusyMotorDates: TDateMatrix;

    procedure DataLoad;

    procedure LetterStandardFormOpen;
    procedure LetterCustomFormOpen;

    function PretensionStatusGet: Integer;
    procedure PretensionStatusSet(const AStatus: Integer);

    procedure FreeMotorListCreate;
    procedure FreeMotorsLoad(const ASelectedPretensionID: Integer = 0);
    procedure FreeMotorSelect;

    procedure BusyMotorListCreate;
    procedure BusyMotorsLoad(const ASelectedPretensionID: Integer = 0);
    procedure BusyMotorSelect;

    procedure MotorFreeToBusy;
    procedure MotorBusyToFree;
  public
    LetterType: Byte;
    PretensionID: Integer;
  end;

var
  PretensionLetterForm: TPretensionLetterForm;

implementation

{$R *.lfm}

{ TPretensionLetterForm }

procedure TPretensionLetterForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= CanFormClose;
end;

procedure TPretensionLetterForm.CancelButtonClick(Sender: TObject);
begin
  CanFormClose:= True;
  ModalResult:= mrCancel;
end;

procedure TPretensionLetterForm.DelButtonClick(Sender: TObject);
begin
  MotorBusyToFree;
end;

procedure TPretensionLetterForm.AddButtonClick(Sender: TObject);
begin
  MotorFreeToBusy;
end;

procedure TPretensionLetterForm.FormCreate(Sender: TObject);
begin
  CanFormClose:= True;
  DT1.Date:= Date;
  AddButton.Enabled:= False;
  DelButton.Enabled:= False;

  FreeMotorListCreate;
  BusyMotorListCreate;
end;

procedure TPretensionLetterForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VSTFreeMotorList);
  FreeAndNil(VSTBusyMotorList);
end;

procedure TPretensionLetterForm.FormShow(Sender: TObject);
begin
  DataLoad;
  FreeMotorsLoad;
end;

procedure TPretensionLetterForm.LetterCustomCreateButtonClick(Sender: TObject);
begin
  LetterCustomFormOpen;
end;

procedure TPretensionLetterForm.LetterStandardCreateButtonClick(Sender: TObject);
begin
  LetterStandardFormOpen;
end;

procedure TPretensionLetterForm.NotNeedCheckBoxChange(Sender: TObject);
begin
  if NotNeedCheckBox.Checked then
    FileNameEdit.Clear;
  Label1.Enabled:= not NotNeedCheckBox.Checked;
  LetterNumEdit.Enabled:= Label1.Enabled;
  Label2.Enabled:= Label1.Enabled;
  DT1.Enabled:= Label1.Enabled;
  LetterStandardCreateButton.Enabled:= Label1.Enabled;
  LetterCustomCreateButton.Enabled:= Label1.Enabled;
  Label4.Enabled:= Label1.Enabled;
  FileNameEdit.Enabled:= Label1.Enabled;
  OpenButton.Enabled:= Label1.Enabled;
end;

procedure TPretensionLetterForm.OpenButtonClick(Sender: TObject);
begin
  DocumentChoose(FileNameEdit);
end;

procedure TPretensionLetterForm.SaveButtonClick(Sender: TObject);
var
  SrcFileName, LetterNum: String;
  LetterDate: TDate;
  i, n: Integer;
  MotorNames, MotorNums: TStrVector;
  MotorDates: TDateVector;
  DelPretensionIDs: TIntVector;
begin
  CanFormClose:= False;

  if VIsNil(BusyPretensionIDs) then
  begin
    ShowInfo('Не выбрана ни одна претензия для ответа!');
    Exit;
  end;

  MotorNames:= nil;
  MotorNums:= nil;
  MotorDates:= nil;
  for i:=0 to High(BusyPretensionIDs) do
  begin
    MotorNames:= VAdd(MotorNames, BusyMotorNames[i]);
    MotorNums:= VAdd(MotorNums, BusyMotorNums[i]);
    MotorDates:= VAdd(MotorDates, BusyMotorDates[i]);
  end;

  //списки на удаление
  DelPretensionIDs:= nil;
  for i:= 0 to High(OldPretensionIDs) do
  begin
    n:= VIndexOf(BusyPretensionIDs, OldPretensionIDs[i]);
    if n<0 then
    begin
      VAppend(DelPretensionIDs, OldPretensionIDs[i]);
      DocumentsDelete(LetterType, OldLetterDate, OldLetterNum,
                     OldMotorDates[i], OldMotorNames[i], OldMotorNums[i]);
    end;
  end;

  if NotNeedCheckBox.Checked then //документ не требуется
  begin
    //удаляем файлы, если есть
    if not NotChangeFileCheckBox.Checked then
      DocumentsDelete(LetterType, OldLetterDate, OldLetterNum, MotorDates, MotorNames, MotorNums);
    if LetterType=13  then    {Ответ потребителю}
      SQLite.PretensionAnswerToUserNotNeed(BusyPretensionIDs, DelPretensionIDs, PretensionStatusGet)
    else
      SQLite.PretensionLetterNotNeed(BusyPretensionIDs, DelPretensionIDs, LetterType);
  end
  else begin  //документ требуется - запись документа
    LetterNum:= STrim(LetterNumEdit.Text);
    if SEmpty(LetterNum) then
    begin
      ShowInfo('Не указан номер письма!');
      Exit;
    end;
    LetterDate:= DT1.Date;
    //пересохраняем файлы писем, если нужно
    SrcFileName:= STrim(FileNameEdit.Text);
    if not DocumentsUpdate(not NotChangeFileCheckBox.Checked, LetterType, SrcFileName,
                MotorDates, MotorNames, MotorNums,
                OldLetterDate, OldLetterNum, LetterDate, LetterNum) then Exit;
    //записываем в базу данные
    if LetterType=13  then    {Ответ потребителю}
      SQLite.PretensionAnswersToUserUpdate(BusyPretensionIDs, DelPretensionIDs, LetterNum, LetterDate, PretensionStatusGet)
    else
      SQLite.PretensionLetterUpdate(BusyPretensionIDs, DelPretensionIDs, LetterType, LetterNum, LetterDate);
  end;

  CanFormClose:= True;
  ModalResult:= mrOK;
end;

procedure TPretensionLetterForm.SearchNumEditButtonClick(Sender: TObject);
begin
  SearchNumEdit.Clear;
end;

procedure TPretensionLetterForm.SearchNumEditChange(Sender: TObject);
begin
  FreeMotorsLoad;
end;

procedure TPretensionLetterForm.VT1DblClick(Sender: TObject);
begin
  MotorFreeToBusy;
end;

procedure TPretensionLetterForm.VT2DblClick(Sender: TObject);
begin
  MotorBusyToFree;
end;

procedure TPretensionLetterForm.DataLoad;
var
  Status: Integer;
begin
  Caption:= LETTER_NAMES[LetterType];
  LetterNameLabel.Caption:= LETTER_NAMES[LetterType];

  SQLite.PretensionLetterLoad(PretensionID, LetterType, OldLetterNum, OldLetterDate);

  if OldLetterNum<>LETTER_NOTNEED_MARK then
    LetterNumEdit.Text:= OldLetterNum;
  if OldLetterDate>0 then
    DT1.Date:= OldLetterDate;

  UserID:= SQLite.LetterUserIDLoad(LetterType, PretensionID);
  UserNameR:= SQLite.UserNameRLoad(UserID);

  //combobox статуса
  if LetterType=13  then    {Ответ потребителю}
  begin
    Label3.Visible:= True;
    StatusCombobox.Visible:= True;
    Status:= SQLite.PretensionStatusLoad(PretensionID);
    PretensionStatusSet(Status);
  end;

  //видимость кнопок создания документа
  if (LetterType=11)  or     {Уведомление Производителю}
     (LetterType=13)  then   {Ответ Потребителю}
  begin
    LetterStandardCreateButton.Visible:= True;
    LetterCustomCreateButton.Visible:= True;
  end;

  SQLite.MotorsInPretensionLetterLoad(LetterType, OldLetterNum, OldLetterDate,
                                      BusyPretensionIDs, BusyNoticeNums, BusyNoticeDates, BusyMoneyValues,
                                      BusyMotorNames, BusyMotorNums, BusyMotorDates);
  BusyMotors:= VPretensionMotorsStr(BusyMotorNames, BusyMotorNums, BusyMotorDates,
                                    BusyNoticeNums, BusyNoticeDates, BusyMoneyValues);
  BusyMotorsLoad;

  OldPretensionIDs:= VCut(BusyPretensionIDs);
  OldMotorNames:= MCut(BusyMotorNames);
  OldMotorNums:= MCut(BusyMotorNums);
  OldMotorDates:= MCut(BusyMotorDates);
end;

procedure TPretensionLetterForm.LetterStandardFormOpen;
var
  LetterStandardForm: TPretensionLetterStandardForm;
begin
  if VIsNil(BusyPretensionIDs) then
  begin
    ShowInfo('Не выбрана ни одна претензия для ответа!');
    Exit;
  end;

  LetterStandardForm:= TPretensionLetterStandardForm.Create(nil);
  try
    LetterStandardForm.LetterType:= LetterType;
    LetterStandardForm.LetterNumEdit.Text:= STrim(LetterNumEdit.Text);
    LetterStandardForm.DT1.Date:= DT1.Date;
    LetterStandardForm.UserNameR:= UserNameR;
    LetterStandardForm.UserID:= UserID;
    LetterStandardForm.MotorNames:= BusyMotorNames;
    LetterStandardForm.MotorNums:= BusyMotorNums;
    LetterStandardForm.MotorDates:= BusyMotorDates;
    LetterStandardForm.NoticeNums:= BusyNoticeNums;
    LetterStandardForm.NoticeDates:= BusyNoticeDates;
    LetterStandardForm.MoneyValues:= BusyMoneyValues;

    if LetterStandardForm.ShowModal=mrOK then
    begin
      LetterNumEdit.Text:= STrim(LetterStandardForm.LetterNumEdit.Text);
      DT1.Date:= LetterStandardForm.DT1.Date;
      DocumentSet(LetterStandardForm.FileNameLabel.Caption, FileNameEdit);
    end;

  finally
    FreeAndNil(LetterStandardForm);
  end;
end;

procedure TPretensionLetterForm.LetterCustomFormOpen;
var
  LetterCustomForm: TLetterCustomForm;
begin
  LetterCustomForm:= TLetterCustomForm.Create(nil);
  try
    LetterCustomForm.UserID:= UserID;
    LetterCustomForm.LetterType:= LetterType;
    LetterCustomForm.LetterNumEdit.Text:= Strim(LetterNumEdit.Text);
    LetterCustomForm.DT1.Date:= DT1.Date;
    if LetterCustomForm.ShowModal=mrOK then
    begin
      NotNeedCheckBox.Checked:= False;
      LetterNumEdit.Text:= STrim(LetterCustomForm.LetterNumEdit.Text);
      DT1.Date:= LetterCustomForm.DT1.Date;
      DocumentSet(LetterCustomForm.FileNameLabel.Caption, FileNameEdit);
    end;
  finally
    FreeAndNil(LetterCustomForm);
  end;
end;

function TPretensionLetterForm.PretensionStatusGet: Integer;
begin
  if StatusComboBox.ItemIndex = 0 then
    Result:= 2
  else
    Result:= 4;
end;

procedure TPretensionLetterForm.PretensionStatusSet(const AStatus: Integer);
begin
  if AStatus=4 then
    StatusComboBox.ItemIndex:= 1
  else
    StatusComboBox.ItemIndex:= 0;
end;

procedure TPretensionLetterForm.FreeMotorListCreate;
begin
  VSTFreeMotorList:= TVSTTable.Create(VT1);
  VSTFreeMotorList.CanSelect:= True;
  VSTFreeMotorList.OnSelect:= @FreeMotorSelect;
  VSTFreeMotorList.HeaderVisible:= False;
  VSTFreeMotorList.AddColumn('Список');
end;

procedure TPretensionLetterForm.FreeMotorsLoad(const ASelectedPretensionID: Integer);
var
  S: String;
  i: Integer;
begin
  S:= STrim(SearchNumEdit.Text);

  SQLite.MotorsEmptyPretensionLetterLoad(LetterType, S, BusyPretensionIDs, UserID,
                               FreePretensionIDs, FreeNoticeNums, FreeNoticeDates, FreeMoneyValues,
                               FreeMotorNames, FreeMotorNums, FreeMotorDates);

  FreeMotors:= VPretensionMotorsStr(FreeMotorNames, FreeMotorNums, FreeMotorDates,
                                    FreeNoticeNums, FreeNoticeDates, FreeMoneyValues);

  VSTFreeMotorList.UnSelect;
  VSTFreeMotorList.SetColumn('Список', FreeMotors, taLeftJustify);
  VSTFreeMotorList.Draw;

  i:= -1;
  if ASelectedPretensionID>0 then
    i:= VIndexOf(FreePretensionIDs, ASelectedPretensionID);
  if i>=0 then
    VSTFreeMotorList.Select(i);
end;

procedure TPretensionLetterForm.FreeMotorSelect;
begin
  AddButton.Enabled:= VSTFreeMotorList.IsSelected;
  if VSTFreeMotorList.IsSelected then
    VSTBusyMotorList.UnSelect;
end;

procedure TPretensionLetterForm.BusyMotorListCreate;
begin
  VSTBusyMotorList:= TVSTTable.Create(VT2);
  VSTBusyMotorList.CanSelect:= True;
  VSTBusyMotorList.OnSelect:= @BusyMotorSelect;
  VSTBusyMotorList.HeaderVisible:= False;
  VSTBusyMotorList.AddColumn('Список');
end;

procedure TPretensionLetterForm.BusyMotorsLoad(const ASelectedPretensionID: Integer);
var
  i: Integer;
begin
  VSTBusyMotorList.UnSelect;
  VSTBusyMotorList.SetColumn('Список', BusyMotors, taLeftJustify);
  VSTBusyMotorList.Draw;

  i:= -1;
  if ASelectedPretensionID>0 then
    i:= VIndexOf(BusyPretensionIDs, ASelectedPretensionID);
  if i>=0 then
    VSTBusyMotorList.Select(i);
end;

procedure TPretensionLetterForm.BusyMotorSelect;
begin
  DelButton.Enabled:= VSTBusyMotorList.IsSelected;
  if VSTBusyMotorList.IsSelected then
    VSTFreeMotorList.UnSelect;
end;

procedure TPretensionLetterForm.MotorFreeToBusy;
var
  i, SelectedPretensionID: Integer;
begin
  if not VSTFreeMotorList.IsSelected then Exit;
  i:= VSTFreeMotorList.SelectedIndex;
  SelectedPretensionID:= FreePretensionIDs[i];
  VAppend(BusyPretensionIDs, SelectedPretensionID);
  VAppend(BusyNoticeNums, FreeNoticeNums[i]);
  VAppend(BusyNoticeDates, FreeNoticeDates[i]);
  VAppend(BusyMoneyValues, FreeMoneyValues[i]);
  VAppend(BusyMotors, FreeMotors[i]);
  MAppend(BusyMotorNames, FreeMotorNames[i]);
  MAppend(BusyMotorNums, FreeMotorNums[i]);
  MAppend(BusyMotorDates, FreeMotorDates[i]);
  BusyMotorsLoad(SelectedPretensionID);
  FreeMotorsLoad;
end;

procedure TPretensionLetterForm.MotorBusyToFree;
var
  i, SelectedPretensionID: Integer;
begin
  if not VSTBusyMotorList.IsSelected then Exit;
  i:= VSTBusyMotorList.SelectedIndex;
  SelectedPretensionID:= BusyPretensionIDs[i];
  VDel(BusyPretensionIDs, i);
  VDel(BusyMotors, i);
  VDel(BusyNoticeNums, i);
  VDel(BusyNoticeDates, i);
  VDel(BusyMoneyValues, i);
  MDel(BusyMotorNames, i);
  MDel(BusyMotorNums, i);
  MDel(BusyMotorDates, i);
  BusyMotorsLoad;
  FreeMotorsLoad(SelectedPretensionID);
end;

end.

