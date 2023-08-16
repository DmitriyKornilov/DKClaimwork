unit ULetterEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DateTimePicker, DividerBevel,

  DK_Vector, DK_StrUtils, DK_Dialogs, DK_VSTTables,

  USQLite, UUtils,

  ULetterStandardForm, ULetterCustomForm, VirtualTrees;

type

  { TLetterEditForm }

  TLetterEditForm = class(TForm)
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    FileNameEdit: TEdit;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    LetterCustomCreateButton: TButton;
    LetterNameLabel: TLabel;
    LetterNumEdit: TEdit;
    LetterStandardCreateButton: TButton;
    NotChangeFileCheckBox: TCheckBox;
    NotNeedCheckBox: TCheckBox;
    OpenButton: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveButton: TSpeedButton;
    StatusComboBox: TComboBox;
    VT1: TVirtualStringTree;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LetterCustomCreateButtonClick(Sender: TObject);
    procedure LetterStandardCreateButtonClick(Sender: TObject);
    procedure NotChangeFileCheckBoxChange(Sender: TObject);
    procedure NotNeedCheckBoxChange(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    CanFormClose: Boolean;
    VSTMotorList: TVSTCheckTable;

    MotorReturn: Boolean;

    UserNameR: String;
    UserID: Integer;
    LocationName: String;
    OldLetterNum: String;
    OldLetterDate: TDate;

    //список аналогичных писем
    LogIDs: TIntVector;
    MotorNames, MotorNums: TStrVector;
    MotorDates: TDateVector;
    NoticeNums: TStrVector;
    NoticeDates: TDateVector;
    AnswerNums: TStrVector;
    AnswerDates: TDateVector;
    LocationTitles, UserTitles: TStrVector;
    MoneyValues: TInt64Vector;


    procedure DataLoad;
    procedure MotorListLoad;
    procedure MotorListShow;

    procedure DocFileOpen;
    procedure DocFileNameSet(const AFileName: String);
    procedure LetterStandardFormOpen;
    procedure LetterCustomFormOpen;

    function ReclamationStatusGet: Integer;
    procedure ReclamationStatusSet(const AStatus: Integer);
    function RepairStatusGet: Integer;
    procedure RepairStatusSet(const AStatus: Integer);
    function PretensionStatusGet: Integer;
    procedure PretensionStatusSet(const AStatus: Integer);
  public
    Category: Byte;
    LetterType: Byte;
    LogID: Integer;
  end;

var
  LetterEditForm: TLetterEditForm;

implementation

{$R *.lfm}

{ TLetterEditForm }

procedure TLetterEditForm.NotNeedCheckBoxChange(Sender: TObject);
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

procedure TLetterEditForm.OpenButtonClick(Sender: TObject);
begin
  DocFileOpen;
end;

procedure TLetterEditForm.SaveButtonClick(Sender: TObject);
var
  SrcFileName, LetterNum: String;
  LetterDate: TDate;
  i, k: Integer;
  UsedLogIDs: TIntVector;
  UsedMotorNames, UsedMotorNums: TStrVector;
  UsedMotorDates: TDateVector;
begin
  CanFormClose:= False;

  if VSTMotorList.IsAllUnchecked then
  begin
    ShowInfo('Не выбран ни один электродвигатель!');
    Exit;
  end;

  UsedLogIDs:= nil;
  UsedMotorNames:= nil;
  UsedMotorNums:= nil;
  UsedMotorDates:= nil;
  for i:= 0 to High(LogIDs) do
  begin
    if not VSTMotorList.Checked[i] then continue;
    VAppend(UsedLogIDs, LogIDs[i]);
    VAppend(UsedMotorNames, MotorNames[i]);
    VAppend(UsedMotorNums, MotorNums[i]);
    VAppend(UsedMotorDates, MotorDates[i]);
  end;

  if NotNeedCheckBox.Checked then //документ не требуется
  begin
    //удаляем файлы, если есть
    if not NotChangeFileCheckBox.Checked then
      DocumentsDelete(LetterType, OldLetterDate, OldLetterNum,
                      UsedMotorDates, UsedMotorNames, UsedMotorNums);
    //записываем в базу
    if LetterType=5 then {Отзыв рекламации}
      SQLite.ReclamationCancelNotNeed(UsedLogIDs)
    else if LetterType=4 then {Акт осмотра двигателя}
      SQLite.ReclamationReportNotNeed(UsedLogIDs, ReclamationStatusGet)
    else
      SQLite.LettersNotNeed(UsedLogIDs, LetterType);
  end
  else begin  //документ требуется - запись документа
    LetterNum:= STrim(LetterNumEdit.Text);
    if SEmpty(LetterNum) and (LetterType=4 {Акт осмотра двигателя}) then
      LetterNum:= 'б/н';
    if SEmpty(LetterNum) then
    begin
      ShowInfo('Не указан номер!');
      Exit;
    end;
    LetterDate:= DT1.Date;

    if MotorReturn then //возврат двигателя на этапе расследования рекламации
    begin
      //удаляем все файлы по согласованию гарантийного ремонта (не требуются)
      for k:= 6 to 9 do
        DocumentsDelete(k, OldLetterDate, OldLetterNum,
                       UsedMotorDates, UsedMotorNames, UsedMotorNums);
      //записываем в базу данные по возврату
      SQLite.MotorsReturn(UsedLogIDs, LetterNum, LetterDate);
    end
    else begin // другие письма
      //пересохраняем файлы писем, если нужно
      SrcFileName:= STrim(FileNameEdit.Text);
      if not DocumentsUpdate(not NotChangeFileCheckBox.Checked, LetterType, SrcFileName,
                  UsedMotorDates, UsedMotorNames, UsedMotorNums,
                  OldLetterDate, OldLetterNum, LetterDate, LetterNum) then Exit;
      //записываем в базу данные
      if LetterType=5 then {Отзыв рекламации}
        SQLite.ReclamationCancelUpdate(UsedLogIDs, LetterNum, LetterDate)
      else if LetterType=4 then {Акт осмотра двигателя}
        SQLite.ReclamationReportUpdate(UsedLogIDs, LetterNum, LetterDate, ReclamationStatusGet)
      else if LetterType=9 then {Ответ на запрос о ремонте Потребителю}
        SQLite.RepairAnswersToUserUpdate(UsedLogIDs, LetterNum, LetterDate, RepairStatusGet)
      else if LetterType=13 then {Ответ на претензию Потребителю}
        SQLite.PretensionAnswersToUserUpdate(UsedLogIDs, LetterNum, LetterDate, PretensionStatusGet)
      else
        SQLite.LettersUpdate(UsedLogIDs, LetterType, LetterNum, LetterDate);
    end;
  end;

  CanFormClose:= True;
  ModalResult:= mrOK;
end;

function TLetterEditForm.ReclamationStatusGet: Integer;
begin
  if StatusComboBox.ItemIndex = 0 then
    Result:= 2
  else
    Result:= 3;
end;

procedure TLetterEditForm.ReclamationStatusSet(const AStatus: Integer);
begin
  StatusComboBox.Clear;
  StatusComboBox.Items.Add('принята');
  StatusComboBox.Items.Add('отклонена');
  if AStatus=3 then
    StatusComboBox.ItemIndex:= 1
  else
    StatusComboBox.ItemIndex:= 0;
end;

function TLetterEditForm.RepairStatusGet: Integer;
begin
  if StatusComboBox.ItemIndex = 0 then
    Result:= 2
  else
    Result:= 5;
end;

procedure TLetterEditForm.RepairStatusSet(const AStatus: Integer);
begin
  StatusComboBox.Clear;
  StatusComboBox.Items.Add('согласовано');
  StatusComboBox.Items.Add('отказано');
  if AStatus=5 then
    StatusComboBox.ItemIndex:= 1
  else
    StatusComboBox.ItemIndex:= 0;
end;

function TLetterEditForm.PretensionStatusGet: Integer;
begin
  if StatusComboBox.ItemIndex = 0 then
    Result:= 2
  else
    Result:= 4;
end;

procedure TLetterEditForm.PretensionStatusSet(const AStatus: Integer);
begin
  StatusComboBox.Clear;
  StatusComboBox.Items.Add('согласовано');
  StatusComboBox.Items.Add('отказано');
  if AStatus=4 then
    StatusComboBox.ItemIndex:= 1
  else
    StatusComboBox.ItemIndex:= 0;
end;

procedure TLetterEditForm.DataLoad;
var
  Status: Integer;
begin
  Caption:= LETTER_NAMES[LetterType];
  LetterNameLabel.Caption:= LETTER_NAMES[LetterType];

  SQLite.LetterLoad(LogID, LetterType, OldLetterNum, OldLetterDate);
  if OldLetterNum<>LETTER_NOTNEED_MARK then
    LetterNumEdit.Text:= OldLetterNum;
  if OldLetterDate>0 then
    DT1.Date:= OldLetterDate;

  MotorListLoad;
  MotorListShow;

  //combobox статуса рекламации и ремонта
  if (LetterType=4)  or    {Акт осмотра двигателя}
     (LetterType=9)  or    {Ответ о ремонте потребителю}
     (LetterType=13) then  {Ответ на претензию потребителю}
  begin
    Label3.Visible:= True;
    StatusCombobox.Visible:= True;
    if (LetterType=4) then
    begin
      Label3.Caption:= 'Статус рекламации';
      Status:= SQLite.ReclamationStatusLoad(LogID);
      ReclamationStatusSet(Status);
    end
    else if (LetterType=9) then
    begin
      Label3.Caption:= 'Статус согласования гарантийного ремонта';
      Status:= SQLite.RepairStatusLoad(LogID);
      RepairStatusSet(Status);
    end
    else if (LetterType=13) then
    begin
      Label3.Caption:= 'Статус согласования возмещения затрат';
      Status:= SQLite.PretensionStatusLoad(LogID);
      PretensionStatusSet(Status);
    end;
  end;

  //видимость кнопок создания документа
  if (LetterType=1)  or   {Уведомление о неисправности Производителю}
     (LetterType=3)  or   {Ответ Потребителю о выезде представителя}
     (LetterType=7)  or   {Запрос о ремонте двигателя Производителю}
     (LetterType=9)  or   {Ответ на запрос о ремонте Потребителю}
     (LetterType=11) or   {Уведомление о претензии Производителю}
     (LetterType=13)      {Ответ на Претензию Потребителю}
  then begin
    LetterStandardCreateButton.Visible:= True;
    LetterCustomCreateButton.Visible:= True;
  end;
end;

procedure TLetterEditForm.MotorListLoad;
var
  LocationID: Integer;
  MoneyValue: Int64;
  MotorName, MotorNum, NoticeNum, AnswerNum, LocationTitle, UserTitle: String;
  MotorDate, NoticeDate, AnswerDate: TDate;
begin
  LocationID:= 0;
  UserID:= 0;
  MoneyValue:= 0;
  SQLite.ReclamationInfoLoad(LogID, UserID, LocationID);
  case Category of
  2: SQLite.RepairInfoLoad(LogID, UserID);
  3: SQLite.PretensionInfoLoad(LogID, UserID, MoneyValue);
  end;

  UserNameR:= EmptyStr;
  UserNameR:= SQLite.UserNameRLoad(UserID);

  LocationName:= EmptyStr;
  LocationName:= SQLite.LocationNameLoad(LocationID);
  if Category<>1 then
    LocationID:= 0;

  SQLite.MotorNoticeAnswerLoad(LogID, LetterType,
                               MotorName, MotorNum, MotorDate,
                               NoticeNum, NoticeDate, AnswerNum, AnswerDate,
                               LocationTitle, UserTitle);

  if Category<>3 then  //для претензии не нужны данные по аналогичным письмам
    SQLite.MotorNoticeAnswerLoad(LogID, LocationID, UserID,
                         LetterType, OldLetterNum, OldLetterDate,
                         LogIDs, MotorNames, MotorNums, MotorDates,
                         NoticeNums, NoticeDates, AnswerNums, AnswerDates,
                         LocationTitles, UserTitles, MoneyValues);
  VIns(LogIDs, 0, LogID);
  VIns(MotorNames, 0, MotorName);
  VIns(MotorNums, 0, MotorNum);
  VIns(MotorDates, 0, MotorDate);
  VIns(NoticeNums, 0, NoticeNum);
  VIns(NoticeDates, 0, NoticeDate);
  VIns(AnswerNums, 0, AnswerNum);
  VIns(AnswerDates, 0, AnswerDate);
  VIns(LocationTitles, 0, LocationTitle);
  VIns(UserTitles, 0, UserTitle);
  VIns(MoneyValues, 0, MoneyValue);
end;

procedure TLetterEditForm.MotorListShow;
var
  NeedAnswers: Boolean;
  S: String;
  Motors, Notices, Moneys, Answers: TStrVector;
begin
  NeedAnswers:= LetterType in [3,9,13];

  case Category of
  1: S:= 'Уведомление ';
  2: S:= 'Запрос ';
  3: S:= 'Претензия ';
  end;

  VSTMotorList.Clear;
  VSTMotorList.AddColumn('Электродвигатель', 280);
  VSTMotorList.AddColumn('Потребитель', 100);
  if Category=1 then
    VSTMotorList.AddColumn('Предприятие', 150);
  VSTMotorList.AddColumn(S + 'от потребителя', 200);
  if Category=3 then
    VSTMotorList.AddColumn('Сумма', 100);

  if NeedAnswers then
    VSTMotorList.AddColumn('Ответ производителя');

  Motors:= MotorFullNames(MotorNames, MotorNums, MotorDates);
  Notices:= LetterFullNames(NoticeDates, NoticeNums);

  VSTMotorList.SetColumn('Электродвигатель', Motors, taLeftJustify);
  VSTMotorList.SetColumn('Потребитель', UserTitles);
  if Category=1 then
    VSTMotorList.SetColumn('Предприятие', LocationTitles);
  VSTMotorList.SetColumn(S + 'от потребителя', Notices, taLeftJustify);

  if Category=3 then
  begin
    Moneys:= VPriceIntToStr(MoneyValues, True);
    VSTMotorList.SetColumn('Сумма', Moneys);
  end;

  if NeedAnswers then
  begin
    Answers:= LetterFullNames(AnswerDates, AnswerNums);
    VSTMotorList.SetColumn('Ответ производителя', Answers, taLeftJustify);
  end;

  VSTMotorList.Draw;
  VSTMotorList.Checked[0]:= True;
end;

procedure TLetterEditForm.DocFileOpen;
begin
  if not OpenDialog1.Execute then Exit;
    DocFileNameSet(OpenDialog1.FileName);
end;

procedure TLetterEditForm.DocFileNameSet(const AFileName: String);
begin
  FileNameEdit.ReadOnly:= False;
  FileNameEdit.Text:= AFileName;
  FileNameEdit.ReadOnly:= True;
end;

procedure TLetterEditForm.LetterStandardFormOpen;
var
  LetterStandardForm: TLetterStandardForm;
  UsedMotorNames, UsedMotorNums, UsedNoticeNums, UsedAnswerNums: TStrVector;
  UsedMotorDates, UsedNoticeDates, UsedAnswerDates: TDateVector;
  i: Integer;
begin
  if VSTMotorList.IsAllUnchecked then
  begin
    ShowInfo('Не выбран ни один электродвигатель!');
    Exit;
  end;

  UsedMotorNames:= nil;
  UsedMotorNums:= nil;
  UsedMotorDates:= nil;
  UsedNoticeNums:= nil;
  UsedNoticeDates:= nil;
  UsedAnswerNums:= nil;
  UsedAnswerDates:= nil;
  for i:= 0 to High(LogIDs) do
  begin
    if not VSTMotorList.Checked[i] then continue;
    VAppend(UsedMotorNames, MotorNames[i]);
    VAppend(UsedMotorNums, MotorNums[i]);
    VAppend(UsedMotorDates, MotorDates[i]);
    VAppend(UsedNoticeNums, NoticeNums[i]);
    VAppend(UsedNoticeDates, NoticeDates[i]);
    VAppend(UsedAnswerNums, AnswerNums[i]);
    VAppend(UsedAnswerDates, AnswerDates[i]);
  end;

  LetterStandardForm:= TLetterStandardForm.Create(LetterEditForm);
  try
    LetterStandardForm.Category:= Category;
    LetterStandardForm.LetterType:= LetterType;
    LetterStandardForm.LetterNumEdit.Text:= LetterNumEdit.Text;
    LetterStandardForm.DT1.Date:= DT1.Date;
    LetterStandardForm.LocationName:= LocationName;
    LetterStandardForm.UserNameR:= UserNameR;
    LetterStandardForm.UserID:= UserID;
    LetterStandardForm.MoneyValue:= MoneyValues[0];
    LetterStandardForm.MotorNames:= UsedMotorNames;
    LetterStandardForm.MotorNums:= UsedMotorNums;
    LetterStandardForm.MotorDates:= UsedMotorDates;
    LetterStandardForm.NoticeNums:= UsedNoticeNums;
    LetterStandardForm.NoticeDates:= UsedNoticeDates;
    LetterStandardForm.AnswerNums:= UsedAnswerNums;
    LetterStandardForm.AnswerDates:= UsedAnswerDates;

    MotorReturn:= False;
    if LetterStandardForm.ShowModal=mrOK then
    begin
      LetterNumEdit.Text:= STrim(LetterStandardForm.LetterNumEdit.Text);
      DT1.Date:= LetterStandardForm.DT1.Date;
      DocFileNameSet(LetterStandardForm.FileNameLabel.Caption);
      MotorReturn:= SSame(LetterStandardForm.SubjectComboBox.Text, LETTER_SUBJECTS[7]);
    end;

  finally
    FreeAndNil(LetterStandardForm);
  end;
end;

procedure TLetterEditForm.LetterCustomFormOpen;
var
  LetterCustomForm: TLetterCustomForm;
begin
  LetterCustomForm:= TLetterCustomForm.Create(LetterEditForm);
  try
    LetterCustomForm.LogID:= LogID;
    LetterCustomForm.LetterType:= LetterType;
    LetterCustomForm.Category:= Category;
    LetterCustomForm.LetterNumEdit.Text:= LetterNumEdit.Text;
    LetterCustomForm.DT1.Date:= DT1.Date;
    LogIDs:= nil;
    if LetterCustomForm.ShowModal=mrOK then
    begin
      NotNeedCheckBox.Checked:= False;
      LetterNumEdit.Text:= STrim(LetterCustomForm.LetterNumEdit.Text);
      DT1.Date:= LetterCustomForm.DT1.Date;
      DocFileNameSet(LetterCustomForm.FileNameLabel.Caption);
    end
    else
      VAppend(LogIDs, LogID);
  finally
    FreeAndNil(LetterCustomForm);
  end;
end;

procedure TLetterEditForm.FormCreate(Sender: TObject);
begin
  CanFormClose:= True;
  LogIDs:= nil;
  MotorReturn:= False;
  DT1.Date:= Date;

  VSTMotorList:= TVSTCheckTable.Create(VT1);
  VSTMotorList.SelectedBGColor:= VT1.Color;
end;

procedure TLetterEditForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VSTMotorList);
end;

procedure TLetterEditForm.FormShow(Sender: TObject);
begin
  DataLoad;
end;

procedure TLetterEditForm.LetterCustomCreateButtonClick(Sender: TObject);
begin
  LetterCustomFormOpen;
end;

procedure TLetterEditForm.LetterStandardCreateButtonClick(Sender: TObject);
begin
  LetterStandardFormOpen;
end;

procedure TLetterEditForm.NotChangeFileCheckBoxChange(Sender: TObject);
begin
  if NotChangeFileCheckBox.Checked then
    FileNameEdit.Clear;
  FileNameEdit.Enabled:= not NotChangeFileCheckBox.Checked;
  OpenButton.Enabled:= FileNameEdit.Enabled;
end;

procedure TLetterEditForm.CancelButtonClick(Sender: TObject);
begin
  CanFormClose:= True;
  ModalResult:= mrCancel;
end;

procedure TLetterEditForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= CanFormClose;
end;

end.

