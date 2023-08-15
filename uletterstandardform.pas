unit ULetterStandardForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DateTimePicker, VirtualTrees, DateUtils, DividerBevel,

  DK_Vector, DK_StrUtils, DK_Dialogs,

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
    procedure CancelButtonClick(Sender: TObject);
    procedure DelegateComboBoxChange(Sender: TObject);
    procedure DT1Change(Sender: TObject);
    procedure DT2Change(Sender: TObject);
    procedure DT3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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

    procedure DataLoad;
    procedure OrganizationsLoad;
    procedure ReceiversLoad;
    procedure SendersLoad;
    procedure PerformersLoad;
    procedure SubjectsLoad;
    procedure DelegatesLoad;

    procedure WarrantyControlsEnabled;

    procedure LetterFileNameSet;
    procedure LetterTextCreate;

    procedure ProxyDocCreate;
  public
    Category: Byte;
    LetterType: Byte;
    LocationName: String;
    UserID: Integer;
    UserNameR: String;
    MoneyValue: Int64;
    MotorNames: TStrVector;
    MotorNums: TStrVector;
    MotorDates: TDateVector;
    NoticeNums: TStrVector;
    NoticeDates: TDateVector;
    AnswerNums: TStrVector;
    AnswerDates: TDateVector;
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

  OrganizationsLoad;
  ReceiversLoad;
  SendersLoad;
  PerformersLoad;
  SubjectsLoad;
  DelegatesLoad;

  LetterFileNameSet;
  LetterTextCreate;
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
  S:= S + ' ' + MotorsFullName(MotorNames, MotorNums);
  S:= S + '.pdf';
  FileNameLabel.Caption:= S;
end;



procedure TLetterStandardForm.LetterTextCreate;
var
  IsSeveralMotors, IsSeveralNotices, IsSeveralAnswers: Boolean;
  Notices, Motors, DelegateName, DelegatePhone, ArrivalDate: String;
  WarrantyType: Byte;
  WarrantyMileage, WarrantyUseDate, WarrantyBuildDate: String;
  Txt: TStrVector;
begin
  Notices:= LettersUniqueFullName(NoticeDates, NoticeNums, IsSeveralNotices);
  Motors:= MotorsFullName(MotorNames, MotorNums);
  IsSeveralMotors:= Length(MotorNames)>1;
  LettersUniqueFullName(AnswerDates, AnswerNums, IsSeveralAnswers);

  if (DelegateComboBox.Visible) and (not VIsNil(DelegateNameIs)) then
  begin
    DelegateName:= DelegateNameIs[DelegateComboBox.ItemIndex];
    DelegatePhone:= DelegatePhones[DelegateComboBox.ItemIndex];
    ArrivalDate:= FormatDateTime('dd.mm.yyyy', DT2.Date);
  end;

  if MileageEdit.Visible then
  begin
    Notices:= LetterFullName(NoticeDates[0], NoticeNums[0], False {no check bad symbols});
    WarrantyType:= Ord(RadioButton1.Checked) + 2*Ord(RadioButton2.Checked) +
                   3*Ord(RadioButton3.Checked);
    WarrantyMileage:= STrim(MileageEdit.Text);
    WarrantyUseDate:= FormatDateTime('dd.mm.yyyy', DT3.Date);
    WarrantyBuildDate:= FormatDateTime('dd.mm.yyyy', MotorDates[0]);
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
    Txt:= Letter6ReclamationToUser(LocationName, Notices, MotorNames[0], MotorNums[0],
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

  IsSeveralMotors:= Length(MotorNames)>1;
  DelegateName:= DelegateNameRs[DelegateComboBox.ItemIndex];
  DelegatePassport:= DelegatePassports[DelegateComboBox.ItemIndex];
  Motors:= MotorsFullName(MotorNames, MotorNums);

  ProxyCreate(FileName, ProxyNum, DT4.Date, DT5.Date, IsSeveralMotors,
              DelegateName, DelegatePassport, Motors, LocationName);

end;



end.

