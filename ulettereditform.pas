unit ULetterEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DateTimePicker, DividerBevel,

  DK_Vector, DK_StrUtils, DK_Dialogs,

  USQLite, UUtils,

  ULetterStandardForm, ULetterCustomForm;

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
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LetterCustomCreateButtonClick(Sender: TObject);
    procedure LetterStandardCreateButtonClick(Sender: TObject);
    procedure NotChangeFileCheckBoxChange(Sender: TObject);
    procedure NotNeedCheckBoxChange(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    CanFormClose: Boolean;
    LogIDs: TIntVector;
    MotorReturn: Boolean;
    procedure DataLoad;
    procedure DocFileOpen;
    procedure DocFileNameSet(const AFileName: String);
    procedure LetterStandardFormOpen;
    procedure LetterCustomFormOpen;

    function ReclamationStatusGet: Integer;
    procedure ReclamationStatusSet(const AStatus: Integer);
    function RepairStatusGet: Integer;
    procedure RepairStatusSet(const AStatus: Integer);
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
  SrcFileName, OldLetterNum, LetterNum, MotorName, MotorNum: String;
  OldLetterDate, LetterDate, MotorDate: TDate;
  i, k: Integer;
begin
  CanFormClose:= False;

  if NotNeedCheckBox.Checked then //документ не требуется
  begin
    //удаляем файл, если есть
    if not NotChangeFileCheckBox.Checked then
    begin
      SQLite.MotorLoad(LogID, k, MotorName, MotorNum, MotorDate);
      SQLite.LetterLoad(LogID, LetterType, OldLetterNum, OldLetterDate);
      DocumentDelete(LetterType, OldLetterDate, OldLetterNum,
                     MotorDate, MotorName, MotorNum);
    end;
    //записываем в базу
    if LetterType=5 then {Отзыв рекламации}
      SQLite.ReclamationCancelNotNeed(LogID)
    else if LetterType=4 then {Акт осмотра двигателя}
      SQLite.ReclamationReportNotNeed(LogID, ReclamationStatusGet)
    else
      SQLite.LetterNotNeed(LogID, LetterType);
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
      for i:= 0 to High(LogIDs) do
      begin
        SQLite.MotorLoad(LogIDs[i], k, MotorName, MotorNum, MotorDate);
        for k:= 6 to 9 do
        begin
          SQLite.LetterLoad(LogIDs[i], k, OldLetterNum, OldLetterDate);
          DocumentDelete(k, OldLetterDate, OldLetterNum, MotorDate, MotorName, MotorNum);
        end;
      end;
      //записываем в базу данные по возврату
      SQLite.MotorsReturn(LogIDs, LetterNum, LetterDate);
    end
    else begin // другие письма
      //пересохраняем файлы писем, если нужно
      if not NotChangeFileCheckBox.Checked then
      begin
        SrcFileName:= STrim(FileNameEdit.Text);
        for i:= 0 to High(LogIDs) do
        begin
          SQLite.MotorLoad(LogIDs[i], k, MotorName, MotorNum, MotorDate);
          SQLite.LetterLoad(LogIDs[i], LetterType, OldLetterNum, OldLetterDate);
          DocumentSave(LetterType, SrcFileName, MotorDate, MotorName, MotorNum,
                     OldLetterDate, OldLetterNum, LetterDate, LetterNum);
        end;
      end;
      //записываем в базу данные
      if LetterType=5 then {Отзыв рекламации}
        SQLite.ReclamationCancelUpdate(LogID, LetterNum, LetterDate)
      else if LetterType=4 then {Акт осмотра двигателя}
        SQLite.ReclamationReportUpdate(LogID, LetterNum, LetterDate, ReclamationStatusGet)
      else if LetterType=9 then {Ответ на запрос о ремонте Потребителю}
        SQLite.RepairAnswersToUserUpdate(LogIDs, LetterNum, LetterDate, RepairStatusGet)
      else
        SQLite.LettersUpdate(LogIDs, LetterType, LetterNum, LetterDate);
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

procedure TLetterEditForm.DataLoad;
var
  LetterNum: String;
  LetterDate: TDate;
  Status: Integer;
begin
  Height:= 450;

  Caption:= LETTER_NAMES[LetterType];
  LetterNameLabel.Caption:= LETTER_NAMES[LetterType];

  LogIDs:= nil;
  VAppend(LogIDs, LogID);

  SQLite.LetterLoad(LogID, LetterType, LetterNum, LetterDate);
  if LetterNum<>LETTER_NOTNEED_MARK then
    LetterNumEdit.Text:= LetterNum;
  if LetterDate>0 then
    DT1.Date:= LetterDate;

  //combobox статуса рекламации и ремонта
  if (LetterType=4) or    {Акт осмотра двигателя}
     (LetterType=9) then  {Ответ о ремонте потребителю}
  begin
    Label3.Visible:= True;
    StatusCombobox.Visible:= True;
    if (LetterType=4) then
    begin
      Label3.Caption:= 'Статус рекламации';
      Status:= SQLite.ReclamationStatusLoad(LogID);
      ReclamationStatusSet(Status);
    end;
    if (LetterType=9) then
    begin
      Label3.Caption:= 'Статус согласования';
      Status:= SQLite.RepairStatusLoad(LogID);
      RepairStatusSet(Status);
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
begin
  LetterStandardForm:= TLetterStandardForm.Create(LetterEditForm);
  try
    LetterStandardForm.LogID:= LogID;
    LetterStandardForm.Category:= Category;
    LetterStandardForm.LetterType:= LetterType;
    LetterStandardForm.LetterNumEdit.Text:= LetterNumEdit.Text;
    LetterStandardForm.DT1.Date:= DT1.Date;
    LogIDs:= nil;
    MotorReturn:= False;
    if LetterStandardForm.ShowModal=mrOK then
    begin
      NotNeedCheckBox.Checked:= False;
      LetterNumEdit.Text:= STrim(LetterStandardForm.LetterNumEdit.Text);
      DT1.Date:= LetterStandardForm.DT1.Date;
      LogIDs:= VCut(LetterStandardForm.SaveLogIDs);
      DocFileNameSet(LetterStandardForm.FileNameLabel.Caption);
      MotorReturn:= SSame(LetterStandardForm.SubjectComboBox.Text, LETTER_SUBJECTS[7]);
    end
    else
      VAppend(LogIDs, LogID);
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

