unit ULetterCustomForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DateTimePicker, DividerBevel,

  DK_Vector, DK_StrUtils, DK_Dialogs,

  USQLite, ULetters, Uutils;

type

  { TLetterCustomForm }

  TLetterCustomForm = class(TForm)
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
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LetterNumEdit: TEdit;
    Memo1: TMemo;
    PerformerComboBox: TComboBox;
    SaveDialog1: TSaveDialog;
    SenderComboBox: TComboBox;
    SenderSignCheckBox: TCheckBox;
    StampCheckBox: TCheckBox;
    SubjectEdit: TEdit;
    OrganizationComboBox: TComboBox;
    ReceiverComboBox: TComboBox;
    SaveButton: TSpeedButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure DT1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LetterNumEditChange(Sender: TObject);
    procedure OrganizationComboBoxChange(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SubjectEditChange(Sender: TObject);
  private
    CanFormClose: Boolean;
    OrganizationType: Byte;
    OrganizationIDs, OrganizationTypes: TIntVector;
    OrganizationNames, OrganizationTitles:  TStrVector;
    SenderIDs: TIntVector;
    SenderNames, SenderPosts: TStrVector;
    ReceiverNames, ReceiverPosts, ReceiverAppeals:  TStrVector;
    PerformerNames, PerformerPhones, PerformerMails: TStrVector;
    UserID: Integer;
    procedure DataLoad;
    procedure ThisLetterInfoLoad;
    procedure OrganizationsLoad;
    procedure ReceiversLoad;
    procedure SendersLoad;
    procedure PerformersLoad;

    procedure LetterFileNameSet;
  public
    LogID: Integer;
    LetterType: Byte;
    Category: Byte;
  end;

var
  LetterCustomForm: TLetterCustomForm;

implementation

{$R *.lfm}

{ TLetterCustomForm }

procedure TLetterCustomForm.CancelButtonClick(Sender: TObject);
begin
  CanFormClose:= True;
  ModalResult:= mrCancel;
end;

procedure TLetterCustomForm.DT1Change(Sender: TObject);
begin
  LetterFileNameSet;
end;

procedure TLetterCustomForm.FormCloseQuery(Sender: TObject;  var CanClose: Boolean);
begin
  CanClose:= CanFormClose;
end;

procedure TLetterCustomForm.FormCreate(Sender: TObject);
begin
  LetterType:= 0;
  LogID:= 0;
  Category:= 0;
  UserID:= 0;
  DT1.Date:= Date;
  CanFormClose:= True;
end;

procedure TLetterCustomForm.FormShow(Sender: TObject);
begin
  DataLoad;
end;

procedure TLetterCustomForm.LetterNumEditChange(Sender: TObject);
begin
  LetterFileNameSet;
end;

procedure TLetterCustomForm.OrganizationComboBoxChange(Sender: TObject);
begin
  ReceiversLoad;
  LetterFileNameSet;
end;

procedure TLetterCustomForm.SaveButtonClick(Sender: TObject);
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

  if SEmpty(STrim(SubjectEdit.Text)) then
  begin
    ShowInfo('Не указана тема письма!');
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
  ModalResult:= mrOk;
end;

procedure TLetterCustomForm.SubjectEditChange(Sender: TObject);
begin
  LetterFileNameSet;
end;

procedure TLetterCustomForm.DataLoad;
begin
  Caption:= 'Новое письмо';
  if LetterType>0 then
    Caption:= LETTER_NAMES[LetterType];
  FileNameLabel.Caption:= EmptyStr;

  OrganizationType:= OrganizationTypeGet(LetterType);

  ThisLetterInfoLoad;

  OrganizationsLoad;
  ReceiversLoad;
  SendersLoad;
  PerformersLoad;

  LetterFileNameSet;
end;

procedure TLetterCustomForm.ThisLetterInfoLoad;
var
  m: Int64;
  l: Integer;
begin
  if OrganizationType<>1 then Exit;
  case Category of
  1: SQLite.ReclamationInfoLoad(LogID, UserID, l);
  2: SQLite.RepairInfoLoad(LogID, UserID);
  3: SQLite.PretensionInfoLoad(LogID, UserID, m);
  end;
end;

procedure TLetterCustomForm.OrganizationsLoad;
var
  IntV1, IntV2: TIntVector;
  StrV1, StrV2: TStrVector;
  Ind: Integer;
begin
  if OrganizationType=0 then //все
  begin
    //потребители
    SQLite.OrganizationListLoad(1, OrganizationIDs, OrganizationNames, OrganizationTitles);
    VDim(OrganizationTypes, Length(OrganizationIDs), 1);
    //производители
    SQLite.OrganizationListLoad(2, IntV1, StrV1, StrV2);
    VDim(IntV2{%H-}, Length(IntV1), 1);
    //объединяем списки
    OrganizationIDs:= VAdd(OrganizationIDs, IntV1);
    OrganizationNames:= VAdd(OrganizationNames, StrV1);
    OrganizationTitles:= VAdd(OrganizationTitles, StrV2);
    //сортировка по наименованию
    VSort(OrganizationNames, IntV1);
    VReplace(OrganizationIDs, IntV1);
    VReplace(OrganizationNames, IntV1);
    VReplace(OrganizationTitles, IntV1);
    //к показу
    VToStrings(OrganizationNames, OrganizationComboBox.Items);
    if not VIsNil(OrganizationNames) then
      OrganizationComboBox.ItemIndex:= 0;
  end
  else if OrganizationType=1 then //потребители
  begin
    SQLite.OrganizationListLoad(1, OrganizationIDs, OrganizationNames, OrganizationTitles);
    VDim(OrganizationTypes, Length(OrganizationIDs), 1);
    VToStrings(OrganizationNames, OrganizationComboBox.Items);
    if not VisNil(OrganizationNames) then
    begin
      Ind:= VIndexOf(OrganizationIDs, UserID);
      if Ind<0 then Ind:= 0;
      OrganizationComboBox.ItemIndex:= Ind;
    end;
  end
  else if OrganizationType=2 then //производители
  begin
    SQLite.OrganizationListLoad(2, OrganizationIDs, OrganizationNames, OrganizationTitles);
    VDim(OrganizationTypes, Length(OrganizationIDs), 2);
    VToStrings(OrganizationNames, OrganizationComboBox.Items);
    if not VIsNil(OrganizationNames) then
      OrganizationComboBox.ItemIndex:= 0;
  end;
end;

procedure TLetterCustomForm.ReceiversLoad;
var
  IntV: TIntVector;
  StrV: TStrVector;
begin
  if not VisNil(OrganizationNames) then
  begin
    SQLite.ReceiverListLoad(OrganizationTypes[OrganizationComboBox.ItemIndex],
                      OrganizationIDs[OrganizationComboBox.ItemIndex],
                      IntV, ReceiverNames, ReceiverPosts, ReceiverAppeals);
    StrV:= VStringReplace(ReceiverPosts, STRING_VECTOR_DELIMITER, ' ');
    StrV:= VSum(' - ', StrV);
    StrV:= VSum(ReceiverNames, StrV);
    VToStrings(StrV, ReceiverComboBox.Items);
    if not VisNil(ReceiverNames) then
      ReceiverComboBox.ItemIndex:= 0;
  end;
end;

procedure TLetterCustomForm.SendersLoad;
var
  StrV: TStrVector;
begin
  SQLite.SenderListLoad(SenderIDs, SenderNames, SenderPosts);
  StrV:= VStringReplace(SenderPosts, STRING_VECTOR_DELIMITER, ' ');
  StrV:= VSum(' - ', StrV);
  StrV:= VSum(SenderNames, StrV);
  VToStrings(StrV, SenderComboBox.Items);
  if not VisNil(SenderNames) then
    SenderComboBox.ItemIndex:= 0;
end;

procedure TLetterCustomForm.PerformersLoad;
var
  PerfIDs: TIntVector;
  PerfNames, PerfPhones, PerfMails: TStrVector;
begin
  VDim(PerfNames{%H-}, 1, 'нет');
  VDim(PerfPhones{%H-}, 1, EmptyStr);
  VDim(PerfMails{%H-}, 1, EmptyStr);

  SQLite.PerformerListLoad(PerfIDs, PerformerNames,
                           PerformerPhones, PerformerMails);

  if not VIsNil(PerformerNames) then
  begin
    PerformerNames:= VAdd(PerfNames, PerformerNames);
    PerformerPhones:= VAdd(PerfPhones, PerformerPhones);
    PerformerMails:= VAdd(PerfMails, PerformerMails);
  end;

  VToStrings(PerformerNames, PerformerComboBox.Items);
  PerformerComboBox.ItemIndex:= 0;
end;

procedure TLetterCustomForm.LetterFileNameSet;
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
  S:= S + '_' + STrim(SubjectEdit.Text);
  S:= S + '.pdf';
  FileNameLabel.Caption:= S;
end;

end.

