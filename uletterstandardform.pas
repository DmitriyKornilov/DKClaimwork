unit ULetterStandardForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DateTimePicker, VirtualTrees, DateUtils, DividerBevel,

  DK_Vector, DK_StrUtils, DK_Dialogs, DK_VSTTables,

  USQLite, UUtils, ULetters;

type

  { TLetterStandardForm }

  TLetterStandardForm = class(TForm)
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    DelegateComboBox: TComboBox;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    DT2: TDateTimePicker;
    DT3: TDateTimePicker;
    DT4: TDateTimePicker;
    DT5: TDateTimePicker;
    FileNameLabel: TLabel;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LetterNumEdit: TEdit;
    Memo1: TMemo;
    MileageEdit: TEdit;
    OrganizationComboBox: TComboBox;
    PerformerComboBox: TComboBox;
    ProxyButton: TButton;
    ProxyNumEdit: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    ReceiverComboBox: TComboBox;
    SaveButton: TSpeedButton;
    SaveDialog1: TSaveDialog;
    SenderComboBox: TComboBox;
    SenderSignCheckBox: TCheckBox;
    StampCheckBox: TCheckBox;
    SubjectComboBox: TComboBox;
    VT1: TVirtualStringTree;
    procedure CancelButtonClick(Sender: TObject);
    procedure DelegateComboBoxChange(Sender: TObject);
    procedure DT1Change(Sender: TObject);
    procedure DT2Change(Sender: TObject);
    procedure DT3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LetterNumEditChange(Sender: TObject);
    procedure MileageEditChange(Sender: TObject);
    procedure OrganizationComboBoxChange(Sender: TObject);
    procedure ProxyButtonClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SubjectComboBoxChange(Sender: TObject);

  private
    CanFormClose: Boolean;
    VST: TVSTCheckTable;

    //данные по этому письму
    MotorName, MotorNum: String;
    MotorDate: TDate;
    NoticeNum: String;
    NoticeDate: TDate;
    AnswerNum: String;
    AnswerDate: TDate;
    LocationID, UserID: Integer;
    LocationName, LocationTitle, UserTitle: String;
    MoneyValue: Int64;
    UserNameR: String;

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

    //реквизиты письма
    OrganizationType: Byte;
    OrganizationIDs: TIntVector;
    OrganizationNames, OrganizationTitles: TStrVector;
    ReceiverIDs: TIntVector;
    ReceiverNames, ReceiverPosts, ReceiverAppeals: TStrVector;
    SenderIDs: TIntVector;
    SenderNames, SenderPosts: TStrVector;
    PerformerIDs: TIntVector;
    PerformerNames, PerformerPhones, PerformerMails: TStrVector;
    DelegateIDs: TIntVector;
    DelegateNameIs, DelegateNameRs, DelegatePhones, DelegatePassports: TStrVector;

    //данные для записи
    SaveMotorNames: TStrVector;
    SaveMotorNums: TStrVector;
    SaveNoticeNums: TStrVector;
    SaveNoticeDates: TDateVector;
    SaveAnswerNums: TStrVector;
    SaveAnswerDates: TDateVector;

    procedure DataLoad;
    procedure ThisLetterInfoLoad;
    procedure LettersInfoLoad;
    procedure LettersListLoad;
    procedure OrganizationsLoad;
    procedure ReceiversLoad;
    procedure SendersLoad;
    procedure PerformersLoad;
    procedure SubjectsLoad;
    procedure DelegatesLoad;

    procedure WarrantyControlsEnabled;

    procedure SaveDataToWrite;
    procedure LetterFileNameSet;
    procedure LetterTextCreate;

    procedure ProxyDocCreate;

    procedure MotorSelect;
  public
    Category: Byte;
    LetterType: Byte;
    LogID: Integer;

    SaveLogIDs: TIntVector;
  end;

var
  LetterStandardForm: TLetterStandardForm;

implementation

{$R *.lfm}

{ TLetterStandardForm }

procedure TLetterStandardForm.CancelButtonClick(Sender: TObject);
begin
  CanFormClose:= True;
  ModalResult:= mrCancel;
end;

procedure TLetterStandardForm.DelegateComboBoxChange(Sender: TObject);
begin
  LetterTextCreate;
end;

procedure TLetterStandardForm.DT1Change(Sender: TObject);
begin
  LetterFileNameSet;
end;

procedure TLetterStandardForm.DT2Change(Sender: TObject);
begin
  LetterTextCreate;
end;

procedure TLetterStandardForm.DT3Click(Sender: TObject);
begin
  LetterTextCreate;
end;

procedure TLetterStandardForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= CanFormClose;
end;

procedure TLetterStandardForm.FormCreate(Sender: TObject);
begin
  VT1.Font.Assign(Label1.Font);
  VST:= TVSTCheckTable.Create(VT1);
  VST.SelectedBGColor:= VT1.Color;
  VST.OnSelect:= @MotorSelect;
end;

procedure TLetterStandardForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VST);
end;

procedure TLetterStandardForm.FormShow(Sender: TObject);
begin
  CanFormClose:= True;
  DataLoad;
end;

procedure TLetterStandardForm.LetterNumEditChange(Sender: TObject);
begin
  LetterFileNameSet;
end;

procedure TLetterStandardForm.MileageEditChange(Sender: TObject);
begin
  LetterTextCreate;
end;

procedure TLetterStandardForm.OrganizationComboBoxChange(Sender: TObject);
begin
  ReceiversLoad;
  LetterFileNameSet;
end;

procedure TLetterStandardForm.ProxyButtonClick(Sender: TObject);
begin
  ProxyDocCreate;
end;

procedure TLetterStandardForm.RadioButton1Click(Sender: TObject);
begin
  LetterTextCreate;
end;

procedure TLetterStandardForm.RadioButton2Click(Sender: TObject);
begin
  LetterTextCreate;
end;

procedure TLetterStandardForm.RadioButton3Click(Sender: TObject);
begin
  LetterTextCreate;
end;

procedure TLetterStandardForm.SaveButtonClick(Sender: TObject);
var
  SenderID: Integer;
  FileName, LetterNum, LetterDate: String;
  ReceiverPost, ReceiverName, ReceiverAppeal: String;
  SenderPost, SenderName: String;
  PerformerName, PerformerPhone, PerformerMail: String;
  SignStream: TMemoryStream;
  SignExt: String;
  Body: TStrVector;
begin
  CanFormClose:= False;

  if VST.IsAllUnchecked then
  begin
    ShowInfo('Не выбран ни один электродвигатель!');
    Exit;
  end;

  if SEmpty(OrganizationComboBox.Text) then
  begin
    ShowInfo('Не указана организация!');
    Exit;
  end;

  if SEmpty(ReceiverComboBox.Text) then
  begin
    ShowInfo('Не указан получатель!');
    Exit;
  end;

  if SEmpty(SenderComboBox.Text) then
  begin
    ShowInfo('Не указан автор письма!');
    Exit;
  end;

  LetterNum:= STrim(LetterNumEdit.Text);
  if SEmpty(LetterNum) then
    if not Confirm('Не указан исходящий номер письма! Сформировать письмо без номера?') then
      Exit;

  if PerformerComboBox.ItemIndex=0 then
    if not Confirm('Не указан исполнитель! Сформировать письмо без исполнителя?') then
      Exit;

  SaveDialog1.FileName:= FileNameLabel.Caption;
  if not SaveDialog1.Execute then Exit;
  FileName:= SaveDialog1.FileName;
  FileNameLabel.Caption:= FileName;

  LetterDate:= FormatDateTime('dd.mm.yyyy', DT1.Date);
  ReceiverPost:= ReceiverPosts[ReceiverComboBox.ItemIndex];
  ReceiverName:= ReceiverNames[ReceiverComboBox.ItemIndex];
  ReceiverAppeal:= ReceiverAppeals[ReceiverComboBox.ItemIndex];
  SenderPost:= SenderPosts[SenderComboBox.ItemIndex];
  SenderName:= SenderNames[SenderComboBox.ItemIndex];
  if PerformerComboBox.ItemIndex>0 then
  begin
    PerformerName:= PerformerNames[PerformerComboBox.ItemIndex];
    PerformerPhone:= PerformerPhones[PerformerComboBox.ItemIndex];
    PerformerMail:= PerformerMails[PerformerComboBox.ItemIndex];
  end;

  Body:= LetterTextFromStrings(Memo1.Lines);

  SignStream:= nil;
  SignExt:= EmptyStr;
  if SenderSignCheckBox.Checked then
    SignStream:= TMemoryStream.Create;
  try
    if SenderSignCheckBox.Checked then
    begin
      SenderID:= SenderIDs[SenderComboBox.ItemIndex];
      if not SQLite.SenderSignLoad(SenderID, SignExt, SignStream) then
        FreeAndNil(SignStream);
    end;

    LetterCreate(FileName, LetterNum, LetterDate,
                 ReceiverPost, ReceiverName, ReceiverAppeal,
                 Body, SenderPost, SenderName,
                 SignStream, SignExt, StampCheckBox.Checked,
                 PerformerName, PerformerPhone, PerformerMail);
  finally
    if Assigned(SignStream) then
      FreeAndNil(SignStream);
  end;

  CanFormClose:= True;
  ModalResult:= mrOK;
end;

procedure TLetterStandardForm.SubjectComboBoxChange(Sender: TObject);
begin
  DelegatesLoad;
  WarrantyControlsEnabled;

  if SubjectComboBox.Text = LETTER_SUBJECTS[6] then  //Об истечении срока гарантии
  begin
    VST.MaxCheckedCount:= 1;
    VST.Checked[0]:= True;
    SaveDataToWrite;
  end
  else
    VST.MaxCheckedCountClear;

  LetterFileNameSet;
  LetterTextCreate;
end;

procedure TLetterStandardForm.DataLoad;
begin
  Caption:= LETTER_NAMES[LetterType];
  DT1.Date:= Date;
  DT2.Date:= IncDay(Date);
  DT3.Date:= IncYear(Date, -2);
  DT4.Date:= Date;
  DT5.Date:= IncMonth(Date);
  FileNameLabel.Caption:= EmptyStr;

  OrganizationType:= OrganizationTypeGet(LetterType);

  ThisLetterInfoLoad;
  LettersInfoLoad;
  LettersListLoad;


  OrganizationsLoad;
  ReceiversLoad;
  SendersLoad;
  PerformersLoad;
  SubjectsLoad;
  DelegatesLoad;

  SaveDataToWrite;
  LetterFileNameSet;
  LetterTextCreate;
end;

procedure TLetterStandardForm.ThisLetterInfoLoad;
begin
  LocationID:= 0;
  UserID:= 0;
  MoneyValue:= 0;
  SQLite.ReclamationInfoLoad(LogID, UserID, LocationID);
  case Category of
  //1: SQLite.ReclamationInfoLoad(LogID, UserID, LocationID);
  2: SQLite.RepairInfoLoad(LogID, UserID);
  3: SQLite.PretensionInfoLoad(LogID, UserID, MoneyValue);
  end;

  UserNameR:= SQLite.UserNameRLoad(UserID);

  LocationName:= EmptyStr;
  //if LocationID>0 then
  LocationName:= SQLite.LocationNameLoad(LocationID);
  if Category<>1 then
    LocationID:= 0;

  SQLite.MotorNoticeAnswerLoad(LogID, LetterType,
                               MotorName, MotorNum, MotorDate,
                               NoticeNum, NoticeDate, AnswerNum, AnswerDate,
                               LocationTitle, UserTitle);
end;

procedure TLetterStandardForm.LettersInfoLoad;
begin
  if Category<>3 then  //для претензии не нужны данные по аналогичным письмам
    SQLite.MotorNoticeAnswerLoad(LogID, LocationID, UserID, LetterType,
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

procedure TLetterStandardForm.LettersListLoad;
var
  S: String;
  Motors, Notices, Answers, Moneys: TStrVector;
  NeedAnswers: Boolean;
begin
  NeedAnswers:= LetterType in [3,9,13];
  case Category of
  1: S:= 'Уведомление ';
  2: S:= 'Запрос ';
  3: S:= 'Претензия ';
  end;

  VST.AddColumn('Электродвигатель', 280);
  VST.AddColumn('Потребитель', 100);
  if Category=1 then
    VST.AddColumn('Предприятие', 100);
  VST.AddColumn(S + 'от потребителя', 200);
  if Category=3 then
    VST.AddColumn('Сумма', 100);

  if NeedAnswers then
    VST.AddColumn('Ответ производителя');

  Motors:= MotorFullNames(MotorNames, MotorNums, MotorDates);
  Notices:= LetterFullNames(NoticeDates, NoticeNums);

  VST.SetColumn('Электродвигатель', Motors, taLeftJustify);
  VST.SetColumn('Потребитель', UserTitles);
  if Category=1 then
    VST.SetColumn('Предприятие', LocationTitles);
  VST.SetColumn(S + 'от потребителя', Notices, taLeftJustify);

  if Category=3 then
  begin
    Moneys:= VPriceIntToStr(MoneyValues, True);
    VST.SetColumn('Сумма', Moneys);
  end;

  if NeedAnswers then
  begin
    Answers:= LetterFullNames(AnswerDates, AnswerNums);
    VST.SetColumn('Ответ производителя', Answers, taLeftJustify);
  end;

  VST.Draw;
  VST.Checked[0]:= True;
end;

procedure TLetterStandardForm.OrganizationsLoad;
var
  Ind: Integer;
begin
  if OrganizationType=2 then  //Уведомление производителю
  begin
    SQLite.OrganizationListLoad(OrganizationType, OrganizationIDs,
                                OrganizationNames, OrganizationTitles);
    VToStrings(OrganizationNames, OrganizationComboBox.Items);
    if not VisNil(OrganizationNames) then
      OrganizationComboBox.ItemIndex:= 0;
  end
  else if OrganizationType=1 then   //Ответ потребителю
  begin
    SQLite.OrganizationListLoad(OrganizationType, OrganizationIDs,
                                OrganizationNames, OrganizationTitles);
    VToStrings(OrganizationNames, OrganizationComboBox.Items);
    if not VisNil(OrganizationNames) then
    begin
      Ind:= VIndexOf(OrganizationIDs, UserID);
      if Ind<0 then Ind:= 0;
      OrganizationComboBox.ItemIndex:= Ind;
    end;
  end;
end;

procedure TLetterStandardForm.ReceiversLoad;
var
  V: TStrVector;
begin
  if VisNil(OrganizationNames) then Exit;

  SQLite.ReceiverListLoad(OrganizationType,
                    OrganizationIDs[OrganizationComboBox.ItemIndex],
                    ReceiverIDs, ReceiverNames, ReceiverPosts, ReceiverAppeals);
  V:= VStringReplace(ReceiverPosts, STRING_VECTOR_DELIMITER, ' ');
  V:= VSum(' - ', V);
  V:= VSum(ReceiverNames, V);
  VToStrings(V, ReceiverComboBox.Items);
  if not VisNil(ReceiverNames) then
    ReceiverComboBox.ItemIndex:= 0;
end;

procedure TLetterStandardForm.SendersLoad;
var
  V: TStrVector;
begin
  SQLite.SenderListLoad(SenderIDs, SenderNames, SenderPosts);
  V:= VStringReplace(SenderPosts, STRING_VECTOR_DELIMITER, ' ');
  V:= VSum(' - ', V);
  V:= VSum(SenderNames, V);
  VToStrings(V, SenderComboBox.Items);
  if not VisNil(SenderNames) then
    SenderComboBox.ItemIndex:= 0;
end;

procedure TLetterStandardForm.PerformersLoad;
var
  PerfIDs: TIntVector;
  PerfNames, PerfPhones, PerfMails: TStrVector;
begin
  VDim(PerfIDs{%H-}, 1, 0);
  VDim(PerfNames{%H-}, 1, 'нет');
  VDim(PerfPhones{%H-}, 1, EmptyStr);
  VDim(PerfMails{%H-}, 1, EmptyStr);

  SQLite.PerformerListLoad(PerformerIDs, PerformerNames,
                           PerformerPhones, PerformerMails);

  if not VIsNil(PerformerNames) then
  begin
    PerformerIDs:= VAdd(PerfIDs, PerformerIDs);
    PerformerNames:= VAdd(PerfNames, PerformerNames);
    PerformerPhones:= VAdd(PerfPhones, PerformerPhones);
    PerformerMails:= VAdd(PerfMails, PerformerMails);
  end;

  VToStrings(PerformerNames, PerformerComboBox.Items);
  PerformerComboBox.ItemIndex:= 0;
end;

procedure TLetterStandardForm.SubjectsLoad;
var
  V: TStrVector;
begin
  if LetterType=1 then
    V:= VCreateStr([
      LETTER_SUBJECTS[0],
      LETTER_SUBJECTS[1]
    ])
  else if LetterType=3 then
    V:= VCreateStr([
      LETTER_SUBJECTS[2],
      LETTER_SUBJECTS[3],
      LETTER_SUBJECTS[4],
      LETTER_SUBJECTS[5],
      LETTER_SUBJECTS[6],
      LETTER_SUBJECTS[7]
    ])

  else if LetterType=7 then
    V:= VCreateStr([
      LETTER_SUBJECTS[8]
    ])
  else if LetterType=9 then
    V:= VCreateStr([
      LETTER_SUBJECTS[8],
      LETTER_SUBJECTS[9],
      LETTER_SUBJECTS[6] //об истечении срока гарантии
    ])
  else if LetterType=11 then
    V:= VCreateStr([
      LETTER_SUBJECTS[10]
    ])
  else if LetterType=13 then
    V:= VCreateStr([
      LETTER_SUBJECTS[11],
      LETTER_SUBJECTS[12]
    ]);

  VToStrings(V, SubjectComboBox.Items);
  SubjectComboBox.ItemIndex:= 0;

  if Category<>1 then Exit;
  if SFind(LocationName, 'петроввальское', False) or
     SFind(LocationName, 'петров вал', False) then
  begin
    if (LetterType=1) then
      SubjectComboBox.ItemIndex:= 1
    else if (LetterType=3) then
      SubjectComboBox.ItemIndex:= 3;
  end;
end;

procedure TLetterStandardForm.DelegatesLoad;
var
  DelegateType: Byte; // 1 - представитель поставщика, 2 - представитель производителя
begin
  DelegateType:= 0;

  if SubjectComboBox.Text=LETTER_SUBJECTS[3] then
    DelegateType:= 1
  else if SubjectComboBox.Text=LETTER_SUBJECTS[4] then
    DelegateType:= 2;

  SQLite.DelegateListLoad(DelegateType, DelegateIDs, DelegateNameIs, DelegateNameRs,
                          DelegatePhones, DelegatePassports);
  VToStrings(DelegateNameIs, DelegateComboBox.Items);
  if not VIsNil(DelegateNameIs) then
    DelegateComboBox.ItemIndex:= 0;

  DelegateComboBox.Visible:= DelegateType>0;
  Label13.Visible:= DelegateComboBox.Visible;
  Label16.Visible:= DelegateComboBox.Visible;
  DT2.Visible:= DelegateComboBox.Visible;

  Label18.Visible:= DelegateComboBox.Visible;
  ProxyNumEdit.Visible:= DelegateComboBox.Visible;
  Label19.Visible:= DelegateComboBox.Visible;
  DT4.Visible:= DelegateComboBox.Visible;
  Label20.Visible:= DelegateComboBox.Visible;
  DT5.Visible:= DelegateComboBox.Visible;
  ProxyButton.Visible:= DelegateComboBox.Visible;
end;

procedure TLetterStandardForm.WarrantyControlsEnabled;
begin
  RadioButton1.Visible:= SubjectComboBox.Text=LETTER_SUBJECTS[6];
  RadioButton2.Visible:= RadioButton1.Visible;
  RadioButton3.Visible:= RadioButton1.Visible;
  MileageEdit.Visible:= RadioButton1.Visible;
  Label17.Visible:= RadioButton1.Visible;
  DT3.Visible:= RadioButton1.Visible;
end;

procedure TLetterStandardForm.LetterFileNameSet;
var
  S: String;
begin
  S:= STrim(LetterNumEdit.Text);
  if SEmpty(S) then
    S:= '_бн_';
  S:= 'Исх' + S + 'от' +
    FormatDateTime('dd.mm.yyyy', DT1.Date);
  if not VIsNil(OrganizationTitles) then
    S:= S + '_' + OrganizationTitles[OrganizationComboBox.ItemIndex];
  if SubjectComboBox.Text = LETTER_SUBJECTS[1] then //СЛД Петроввальское
    S:= S + '_' + 'О неисправности'
  else if SubjectComboBox.Text = LETTER_SUBJECTS[5] then //СЛД Петроввальское
    S:= S + '_' + 'О расследовании'
  else
    S:= S + '_' + SubjectComboBox.Text;
  S:= S + ' ' + MotorsFullName(SaveMotorNames, SaveMotorNums);
  S:= S + '.pdf';
  FileNameLabel.Caption:= S;
end;

procedure TLetterStandardForm.SaveDataToWrite;
var
  i: Integer;
begin
  SaveLogIDs:= nil;
  SaveMotorNames:= nil;
  SaveMotorNums:= nil;
  SaveNoticeNums:= nil;
  SaveNoticeDates:= nil;
  SaveAnswerNums:= nil;
  SaveAnswerDates:= nil;

  if VisNil(MotorNames) then Exit;
  if VST.IsAllUnchecked then Exit;

  for i:=0 to High(MotorNames) do
  begin
    if not VST.Checked[i] then continue;
    VAppend(SaveLogIDs, LogIDs[i]);
    VAppend(SaveMotorNames, MotorNames[i]);
    VAppend(SaveMotorNums, MotorNums[i]);
    VAppend(SaveNoticeNums, NoticeNums[i]);
    VAppend(SaveNoticeDates, NoticeDates[i]);
    VAppend(SaveAnswerNums, AnswerNums[i]);
    VAppend(SaveAnswerDates, AnswerDates[i]);
  end;
end;

procedure TLetterStandardForm.LetterTextCreate;
var
  IsSeveralMotors, IsSeveralNotices, IsSeveralAnswers: Boolean;
  Notices, Motors, DelegateName, DelegatePhone, ArrivalDate: String;
  WarrantyType: Byte;
  WarrantyMileage, WarrantyUseDate, WarrantyBuildDate: String;
  Txt: TStrVector;
begin
  Notices:= LettersUniqueFullName(SaveNoticeDates, SaveNoticeNums, IsSeveralNotices);
  Motors:= MotorsFullName(SaveMotorNames, SaveMotorNums);
  IsSeveralMotors:= Length(SaveMotorNames)>1;
  LettersUniqueFullName(SaveAnswerDates, SaveAnswerNums, IsSeveralAnswers);

  if (DelegateComboBox.Visible) and (not VIsNil(DelegateNameIs)) then
  begin
    DelegateName:= DelegateNameIs[DelegateComboBox.ItemIndex];
    DelegatePhone:= DelegatePhones[DelegateComboBox.ItemIndex];
    ArrivalDate:= FormatDateTime('dd.mm.yyyy', DT2.Date);
  end;

  if MileageEdit.Visible then
  begin
    Notices:= LetterFullName(NoticeDate, NoticeNum, False {no check bad symbols});
    WarrantyType:= Ord(RadioButton1.Checked) + 2*Ord(RadioButton2.Checked) +
                   3*Ord(RadioButton3.Checked);
    WarrantyMileage:= STrim(MileageEdit.Text);
    WarrantyUseDate:= FormatDateTime('dd.mm.yyyy', DT3.Date);
    WarrantyBuildDate:= FormatDateTime('dd.mm.yyyy', MotorDate);
  end;

  Txt:= nil;
  if SubjectComboBox.Text=LETTER_SUBJECTS[0] then
    Txt:= Letter0ReclamationToBuilder(LocationName, Motors, UserNameR,
            IsSeveralMotors, IsSeveralNotices)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[1] then
    Txt:= Letter1ReclamationToBuilder(LocationName, Motors, UserNameR,
            IsSeveralMotors, IsSeveralNotices)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[2] then
    Txt:= Letter2ReclamationToUser(Notices, Motors,
            IsSeveralMotors, IsSeveralNotices)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[3] then
    Txt:= Letter3ReclamationToUser(LocationName, Notices, Motors,
            ArrivalDate,DelegateName, DelegatePhone,
            IsSeveralMotors, IsSeveralNotices)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[4] then
    Txt:= Letter4ReclamationToUser(LocationName, Notices, Motors,
            ArrivalDate,DelegateName, DelegatePhone,
            IsSeveralMotors, IsSeveralNotices)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[5] then
    Txt:= Letter5ReclamationToUser(LocationName, Notices, Motors,
            IsSeveralMotors, IsSeveralNotices)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[6] then
    Txt:= Letter6ReclamationToUser(LocationName, Notices, MotorName, MotorNum,
            WarrantyBuildDate, WarrantyMileage, WarrantyUseDate, WarrantyType)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[7] then
    Txt:= Letter7ReclamationToUser(Notices, Motors,
            IsSeveralMotors, IsSeveralNotices, IsSeveralAnswers)
  else if (SubjectComboBox.Text=LETTER_SUBJECTS[8]) and (LetterType=7) then
    Txt:= Letter8RepairToBuilder(Motors, UserNameR,
            IsSeveralMotors, IsSeveralNotices)
  else if (SubjectComboBox.Text=LETTER_SUBJECTS[8]) and (LetterType=9) then
    Txt:= Letter8RepairToUser(Notices, Motors,
            IsSeveralMotors, IsSeveralNotices, IsSeveralAnswers)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[9] then
    Txt:= Letter9RepairToUser(Notices, Motors, IsSeveralMotors, IsSeveralNotices)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[10] then
    Txt:= Letter10PretensionToBuilder(Motors, UserNameR, MoneyValue)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[11] then
    Txt:= Letter11PretensionToUser(Notices, Motors, MoneyValue)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[12] then
    Txt:= Letter12PretensionToUser(Notices, Motors);

  LetterTextToStrings(Txt, Memo1.Lines);
end;

procedure TLetterStandardForm.ProxyDocCreate;
var
  FileName, ProxyNum, DelegateName, DelegatePassport, Motors: String;
  IsSeveralMotors: Boolean;
begin
  ProxyNum:= STrim(ProxyNumEdit.Text);
  if Sempty(ProxyNum) then
  begin
    ShowInfo('Не указан номер доверенности!');
    Exit;
  end;
  FileName:= 'Доверенность №' + ProxyNum + ' от ' +
             FormatDateTime('dd.mm.yyyy', DT4.Date) + ' ' +
             SNameShort(DelegateNameIs[DelegateComboBox.ItemIndex]);
  SaveDialog1.FileName:= FileName;
  if not SaveDialog1.Execute then Exit;
  FileName:= SaveDialog1.FileName;

  IsSeveralMotors:= Length(SaveMotorNames)>1;
  DelegateName:= DelegateNameRs[DelegateComboBox.ItemIndex];
  DelegatePassport:= DelegatePassports[DelegateComboBox.ItemIndex];
  Motors:= MotorsFullName(SaveMotorNames, SaveMotorNums);

  ProxyCreate(FileName, ProxyNum, DT4.Date, DT5.Date, IsSeveralMotors,
              DelegateName, DelegatePassport, Motors, LocationName);

end;

procedure TLetterStandardForm.MotorSelect;
begin
  SaveDataToWrite;
  LetterFileNameSet;
  LetterTextCreate;
end;

end.

