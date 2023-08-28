unit UPretensionLetterStandardForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DateTimePicker, DividerBevel,

  DK_Vector, DK_Matrix, DK_StrUtils, DK_Dialogs,

  USQLite, UUtils, ULetters;

type

  { TPretensionLetterStandardForm }

  TPretensionLetterStandardForm = class(TForm)
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    FileNameLabel: TLabel;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LetterNumEdit: TEdit;
    Memo1: TMemo;
    OrganizationComboBox: TComboBox;
    PerformerComboBox: TComboBox;
    ReceiverComboBox: TComboBox;
    SaveButton: TSpeedButton;
    SaveDialog1: TSaveDialog;
    SenderComboBox: TComboBox;
    SenderSignCheckBox: TCheckBox;
    StampCheckBox: TCheckBox;
    SubjectComboBox: TComboBox;
    procedure CancelButtonClick(Sender: TObject);
    procedure DT1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure LetterNumEditChange(Sender: TObject);
    procedure OrganizationComboBoxChange(Sender: TObject);
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

    procedure DataLoad;

    procedure OrganizationsLoad;
    procedure ReceiversLoad;
    procedure SendersLoad;
    procedure PerformersLoad;
    procedure SubjectsLoad;

    procedure LetterFileNameSet;
    procedure LetterTextCreate;
  public
    LetterType: Byte;
    UserID: Integer;
    UserNameR: String;
    MoneyValues: TInt64Vector;
    MotorNames: TStrMatrix;
    MotorNums: TStrMatrix;
    MotorDates: TDateMatrix;
    NoticeNums: TStrVector;
    NoticeDates: TDateVector;
  end;

var
  PretensionLetterStandardForm: TPretensionLetterStandardForm;

implementation

{$R *.lfm}

{ TPretensionLetterStandardForm }

procedure TPretensionLetterStandardForm.CancelButtonClick(Sender: TObject);
begin
  CanFormClose:= True;
  ModalResult:= mrCancel;
end;

procedure TPretensionLetterStandardForm.DT1Change(Sender: TObject);
begin
  LetterFileNameSet;
end;

procedure TPretensionLetterStandardForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= CanFormClose;
end;

procedure TPretensionLetterStandardForm.FormShow(Sender: TObject);
begin
  CanFormClose:= True;
  DataLoad;
end;

procedure TPretensionLetterStandardForm.LetterNumEditChange(Sender: TObject);
begin
  LetterFileNameSet;
end;

procedure TPretensionLetterStandardForm.OrganizationComboBoxChange(Sender: TObject);
begin
  ReceiversLoad;
  LetterFileNameSet;
end;

procedure TPretensionLetterStandardForm.SaveButtonClick(Sender: TObject);
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

procedure TPretensionLetterStandardForm.SubjectComboBoxChange(Sender: TObject);
begin
  LetterFileNameSet;
  LetterTextCreate;
end;

procedure TPretensionLetterStandardForm.DataLoad;
begin
  Caption:= LETTER_NAMES[LetterType];
  DT1.Date:= Date;
  FileNameLabel.Caption:= EmptyStr;

  OrganizationsLoad;
  ReceiversLoad;
  SendersLoad;
  PerformersLoad;
  SubjectsLoad;

  LetterFileNameSet;
  LetterTextCreate;
end;

procedure TPretensionLetterStandardForm.OrganizationsLoad;
var
  Ind: Integer;
begin
  OrganizationType:= OrganizationTypeGet(LetterType);
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

procedure TPretensionLetterStandardForm.ReceiversLoad;
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

procedure TPretensionLetterStandardForm.SendersLoad;
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

procedure TPretensionLetterStandardForm.PerformersLoad;
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

procedure TPretensionLetterStandardForm.SubjectsLoad;
var
  V: TStrVector;
begin
  if LetterType=11 then
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
end;

procedure TPretensionLetterStandardForm.LetterFileNameSet;
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
  S:= S + '_' + SubjectComboBox.Text;
  //S:= S + ' ' + VMotorNameNumToString(MotorNames, MotorNums);
  S:= S + '.pdf';
  FileNameLabel.Caption:= S;
end;

procedure TPretensionLetterStandardForm.LetterTextCreate;
var
  IsSeveralNotices, IsSeveralMotors: Boolean;
  Notices, Motors: String;
  Txt: TStrVector;
begin
  IsSeveralMotors:= Length(MToVector(MotorNames))>1;
  Notices:= VLetterUniqueFullName(NoticeDates, NoticeNums, IsSeveralNotices);

  if LetterType = 11 then
    Motors:= VPretensionToString(MotorNames, MotorNums{, MotorDates}, MoneyValues, 'в размере');
  if LetterType = 13 then
    Motors:= VPretensionToString(MotorNames, MotorNums{, MotorDates}, MoneyValues, 'на сумму');

  Txt:= nil;
  if SubjectComboBox.Text=LETTER_SUBJECTS[10] then
    Txt:= Letter10PretensionToBuilder(Motors, UserNameR, IsSeveralMotors, IsSeveralNotices)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[11] then
    Txt:= Letter11PretensionToUser(Notices, Motors, IsSeveralMotors, IsSeveralNotices)
  else if SubjectComboBox.Text=LETTER_SUBJECTS[12] then
    Txt:= Letter12PretensionToUser(Notices, Motors, IsSeveralMotors, IsSeveralNotices);

  LetterTextToStrings(Txt, Memo1.Lines);
end;

end.

