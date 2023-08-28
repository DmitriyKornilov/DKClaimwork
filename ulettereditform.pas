unit ULetterEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, EditBtn, DateTimePicker, DividerBevel, VirtualTrees,

  DK_Vector, DK_StrUtils, DK_Dialogs, DK_VSTTables,

  USQLite, UUtils,

  ULetterStandardForm, ULetterCustomForm;

type

  { TLetterEditForm }

  TLetterEditForm = class(TForm)
    AddButton: TSpeedButton;
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    ChoosePanel: TPanel;
    DelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    FileNameEdit: TEdit;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
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
    procedure NotChangeFileCheckBoxChange(Sender: TObject);
    procedure NotNeedCheckBoxChange(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SearchNumEditButtonClick(Sender: TObject);
    procedure SearchNumEditChange(Sender: TObject);
    procedure VT1DblClick(Sender: TObject);
    procedure VT2DblClick(Sender: TObject);
  private
    CanFormClose: Boolean;

    Category: Byte;
    UserNameR: String;
    UserID, LocationID: Integer;
    LocationName: String;
    MotorReturn: Boolean;

    OldLetterNum: String;
    OldLetterDate: TDate;
    OldLogIDs: TIntVector;
    OldMotorNames, OldMotorNums: TStrVector;
    OldMotorDates: TDateVector;
    OldNoticeNums: TStrVector;
    OldNoticeDates: TDateVector;

    VSTFreeMotorList: TVSTTable;
    FreeLogIDs, FreeMotorIDs: TIntVector;
    FreeMotors, FreeMotorNames, FreeMotorNums: TStrVector;
    FreeMotorDates: TDateVector;

    VSTBusyMotorList: TVSTTable;
    BusyLogIDs, BusyMotorIDs: TIntVector;
    BusyMotors, BusyMotorNames, BusyMotorNums: TStrVector;
    BusyMotorDates: TDateVector;

    procedure DataLoad;

    procedure LetterStandardFormOpen;
    procedure LetterCustomFormOpen;

    function ReclamationStatusGet: Integer;
    procedure ReclamationStatusSet(const AStatus: Integer);
    function RepairStatusGet: Integer;
    procedure RepairStatusSet(const AStatus: Integer);

    procedure FreeMotorListCreate;
    procedure FreeMotorsLoad(const ASelectedMotorID: Integer = 0);
    procedure FreeMotorSelect;

    procedure BusyMotorListCreate;
    procedure BusyMotorsLoad(const ASelectedMotorID: Integer = 0);
    procedure BusyMotorSelect;

    procedure MotorFreeToBusy;
    procedure MotorBusyToFree;
  public
    LetterType: Byte;
    ID, LogID: Integer;
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
  DocumentChoose(FileNameEdit);
end;

procedure TLetterEditForm.SaveButtonClick(Sender: TObject);
var
  SrcFileName, LetterNum: String;
  LetterDate: TDate;
  i, n: Integer;
  DelLogIDs: TIntVector;
begin
  CanFormClose:= False;

  if VIsNil(BusyMotorIDs) then
  begin
    ShowInfo('Не выбран ни один электродвигатель!');
    Exit;
  end;

  //списки на удаление
  DelLogIDs:= nil;
  for i:= 0 to High(OldLogIDs) do
  begin
    n:= VIndexOf(BusyLogIDs, OldLogIDs[i]);
    if n<0 then
    begin
      VAppend(DelLogIDs, OldLogIDs[i]);
      DocumentDelete(LetterType, OldLetterDate, OldLetterNum,
                     OldMotorDates[i], OldMotorNames[i], OldMotorNums[i]);
    end;
  end;

  if NotNeedCheckBox.Checked then //документ не требуется
  begin
    //удаляем файлы, если есть
    if not NotChangeFileCheckBox.Checked then
      DocumentsDelete(LetterType, OldLetterDate, OldLetterNum,
                      BusyMotorDates, BusyMotorNames, BusyMotorNums);
    //записываем в базу
    if LetterType=5 then {Отзыв рекламации}
      SQLite.ReclamationCancelNotNeed(BusyLogIDs, DelLogIDs)
    else if LetterType=4 then {Акт осмотра двигателя}
      SQLite.ReclamationReportNotNeed(BusyLogIDs, DelLogIDs, ReclamationStatusGet)
    else
      SQLite.LettersNotNeed(BusyLogIDs, DelLogIDs, LetterType);
  end
  else begin  //документ требуется - запись документа
    LetterNum:= STrim(LetterNumEdit.Text);
    if SEmpty(LetterNum) and (LetterType=4 {Акт осмотра двигателя}) then
      LetterNum:= 'б/н';
    if SEmpty(LetterNum) then
    begin
      ShowInfo('Не указан номер письма!');
      Exit;
    end;
    LetterDate:= DT1.Date;

    if MotorReturn then //возврат двигателя на этапе расследования рекламации
    begin
      //удаляем все файлы по согласованию гарантийного ремонта (не требуются)
      for i:= 6 to 9 do
        DocumentsDelete(i, OldLetterDate, OldLetterNum,
                       BusyMotorDates, BusyMotorNames, BusyMotorNums);
      //записываем в базу данные по возврату
      SQLite.MotorsReturn(BusyLogIDs, BusyMotorIDs, UserID, LetterNum, LetterDate);
    end
    else begin // другие письма
      //пересохраняем файлы писем, если нужно
      SrcFileName:= STrim(FileNameEdit.Text);
      if not DocumentsUpdate(not NotChangeFileCheckBox.Checked, LetterType, SrcFileName,
                  BusyMotorDates, BusyMotorNames, BusyMotorNums,
                  OldLetterDate, OldLetterNum, LetterDate, LetterNum) then Exit;
      //записываем в базу данные
      if LetterType=5 then {Отзыв рекламации}
        SQLite.ReclamationCancelUpdate(BusyLogIDs, DelLogIDs, LetterNum, LetterDate)
      else if LetterType=4 then {Акт осмотра двигателя}
        SQLite.ReclamationReportUpdate(BusyLogIDs, DelLogIDs, LetterNum, LetterDate, ReclamationStatusGet)
      else if LetterType=9 then {Ответ на запрос о ремонте Потребителю}
        SQLite.RepairAnswersToUserUpdate(BusyLogIDs, DelLogIDs, LetterNum, LetterDate, RepairStatusGet)
      else
        SQLite.LettersUpdate(BusyLogIDs, DelLogIDs, LetterType, LetterNum, LetterDate);
    end;
  end;

  CanFormClose:= True;
  ModalResult:= mrOK;
end;

procedure TLetterEditForm.SearchNumEditButtonClick(Sender: TObject);
begin
  SearchNumEdit.Clear;
end;

procedure TLetterEditForm.SearchNumEditChange(Sender: TObject);
begin
  FreeMotorsLoad;
end;

procedure TLetterEditForm.VT1DblClick(Sender: TObject);
begin
  MotorFreeToBusy;
end;

procedure TLetterEditForm.VT2DblClick(Sender: TObject);
begin
  MotorBusyToFree;
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

procedure TLetterEditForm.FreeMotorListCreate;
begin
  VSTFreeMotorList:= TVSTTable.Create(VT1);
  VSTFreeMotorList.CanSelect:= True;
  VSTFreeMotorList.OnSelect:= @FreeMotorSelect;
  VSTFreeMotorList.HeaderVisible:= False;
  VSTFreeMotorList.AddColumn('Список');
end;

procedure TLetterEditForm.FreeMotorsLoad(const ASelectedMotorID: Integer);
var
  S: String;
  i: Integer;
  NoticeNums: TStrVector;
  NoticeDates: TDateVector;
begin
  S:= STrim(SearchNumEdit.Text);
  SQLite.MotorsEmptyLetterLoad(LetterType, S, BusyLogIDs, UserID, FreeLogIDs, FreeMotorIDs,
                               FreeMotorNames, FreeMotorNums, FreeMotorDates,
                               NoticeNums, NoticeDates, LocationID);

  if Category=1 then
    FreeMotors:= VReclamationMotorStr(FreeMotorNames, FreeMotorNums, FreeMotorDates,
                                      NoticeNums, NoticeDates)
  else
    FreeMotors:= VRepairMotorStr(FreeMotorNames, FreeMotorNums, FreeMotorDates,
                                      NoticeNums, NoticeDates);

  VSTFreeMotorList.UnSelect;
  VSTFreeMotorList.SetColumn('Список', FreeMotors, taLeftJustify);
  VSTFreeMotorList.Draw;

  i:= -1;
  if ASelectedMotorID>0 then
    i:= VIndexOf(FreeMotorIDs, ASelectedMotorID);
  if i>=0 then
    VSTFreeMotorList.Select(i);
end;

procedure TLetterEditForm.FreeMotorSelect;
begin
  AddButton.Enabled:= VSTFreeMotorList.IsSelected;
  if VSTFreeMotorList.IsSelected then
    VSTBusyMotorList.UnSelect;
end;

procedure TLetterEditForm.BusyMotorListCreate;
begin
  VSTBusyMotorList:= TVSTTable.Create(VT2);
  VSTBusyMotorList.CanSelect:= True;
  VSTBusyMotorList.OnSelect:= @BusyMotorSelect;
  VSTBusyMotorList.HeaderVisible:= False;
  VSTBusyMotorList.AddColumn('Список');
end;

procedure TLetterEditForm.BusyMotorsLoad(const ASelectedMotorID: Integer);
var
  i: Integer;
begin
  VSTBusyMotorList.UnSelect;
  VSTBusyMotorList.SetColumn('Список', BusyMotors, taLeftJustify);
  VSTBusyMotorList.Draw;

  i:= -1;
  if ASelectedMotorID>0 then
    i:= VIndexOf(BusyMotorIDs, ASelectedMotorID);
  if i>=0 then
    VSTBusyMotorList.Select(i);
end;

procedure TLetterEditForm.BusyMotorSelect;
begin
  DelButton.Enabled:= VSTBusyMotorList.IsSelected;
  if VSTBusyMotorList.IsSelected then
    VSTFreeMotorList.UnSelect;
end;

procedure TLetterEditForm.MotorFreeToBusy;
var
  i, SelectedMotorID: Integer;
begin
  if not VSTFreeMotorList.IsSelected then Exit;
  i:= VSTFreeMotorList.SelectedIndex;
  SelectedMotorID:= FreeMotorIDs[i];
  VAppend(BusyMotorIDs, SelectedMotorID);
  VAppend(BusyLogIDs, FreeLogIDs[i]);
  VAppend(BusyMotors, FreeMotors[i]);
  VAppend(BusyMotorNames, FreeMotorNames[i]);
  VAppend(BusyMotorNums, FreeMotorNums[i]);
  VAppend(BusyMotorDates, FreeMotorDates[i]);
  BusyMotorsLoad(SelectedMotorID);
  FreeMotorsLoad;
end;

procedure TLetterEditForm.MotorBusyToFree;
var
  i, SelectedMotorID: Integer;
begin
  if not VSTBusyMotorList.IsSelected then Exit;
  i:= VSTBusyMotorList.SelectedIndex;
  SelectedMotorID:= BusyMotorIDs[i];
  VDel(BusyLogIDs, i);
  VDel(BusyMotorIDs, i);
  VDel(BusyMotors, i);
  VDel(BusyMotorNames, i);
  VDel(BusyMotorNums, i);
  VDel(BusyMotorDates, i);
  BusyMotorsLoad;
  FreeMotorsLoad(SelectedMotorID);
end;

procedure TLetterEditForm.DataLoad;
var
  Status: Integer;
begin
  Caption:= LETTER_NAMES[LetterType];
  LetterNameLabel.Caption:= LETTER_NAMES[LetterType];
  Category:= CategoryFromLetterType(LetterType);

  SQLite.LetterLoad(LogID, LetterType, OldLetterNum, OldLetterDate);
  if OldLetterNum<>LETTER_NOTNEED_MARK then
    LetterNumEdit.Text:= OldLetterNum;
  if OldLetterDate>0 then
    DT1.Date:= OldLetterDate;

  UserID:= SQLite.LetterUserIDLoad(LetterType, ID);
  UserNameR:= SQLite.UserNameRLoad(UserID);
  LocationID:= 0;
  if Category=1 then
  begin
    LocationID:= SQLite.ReclamationLocationIDLoad(ID);
    LocationName:= SQLite.LocationNameLoad(LocationID);
  end;

  //combobox статуса рекламации и ремонта
  if (LetterType=4)  or    {Акт осмотра двигателя}
     (LetterType=9)  then    {Ответ о ремонте потребителю}
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
    end;
  end;

  //видимость кнопок создания документа
  if (LetterType=1)  or   {Уведомление о неисправности Производителю}
     (LetterType=3)  or   {Ответ Потребителю о выезде представителя}
     (LetterType=7)  or   {Запрос о ремонте двигателя Производителю}
     (LetterType=9)       {Ответ на запрос о ремонте Потребителю}
  then begin
    LetterStandardCreateButton.Visible:= True;
    LetterCustomCreateButton.Visible:= True;
  end;

  SQLite.MotorsInLetterLoad(LetterType, OldLetterNum, OldLetterDate,
                            BusyLogIDs, BusyMotorIDs,
                            BusyMotorNames, BusyMotorNums, BusyMotorDates,
                            OldNoticeNums, OldNoticeDates);

  if Category=1 then
    BusyMotors:= VReclamationMotorStr(BusyMotorNames, BusyMotorNums, BusyMotorDates,
                                      OldNoticeNums, OldNoticeDates)
  else
    BusyMotors:= VRepairMotorStr(BusyMotorNames, BusyMotorNums, BusyMotorDates,
                                      OldNoticeNums, OldNoticeDates);


  BusyMotorsLoad;
  OldLogIDs:= VCut(BusyLogIDs);
  OldMotorNames:= VCut(BusyMotorNames);
  OldMotorNums:= VCut(BusyMotorNums);
  OldMotorDates:= VCut(BusyMotorDates);
end;

procedure TLetterEditForm.LetterStandardFormOpen;
var
  LetterStandardForm: TLetterStandardForm;
  MotorNames, MotorNums, NoticeNums, AnswerNums: TStrVector;
  MotorDates, NoticeDates, AnswerDates: TDateVector;
begin
  if VIsNil(BusyMotorIDs) then
  begin
    ShowInfo('Не выбран ни один электродвигатель!');
    Exit;
  end;

  SQLite.NoticeAndAnswersLoad(LetterType, BusyLogIDs,
                       MotorNames, MotorNums, MotorDates,
                       NoticeNums, NoticeDates, AnswerNums, AnswerDates);



  LetterStandardForm:= TLetterStandardForm.Create(LetterEditForm);
  try
    LetterStandardForm.Category:= Category;
    LetterStandardForm.LetterType:= LetterType;
    LetterStandardForm.LetterNumEdit.Text:= STrim(LetterNumEdit.Text);
    LetterStandardForm.DT1.Date:= DT1.Date;
    LetterStandardForm.LocationName:= LocationName;
    LetterStandardForm.UserNameR:= UserNameR;
    LetterStandardForm.UserID:= UserID;
    LetterStandardForm.MotorNames:= MotorNames;
    LetterStandardForm.MotorNums:= MotorNums;
    LetterStandardForm.MotorDates:= MotorDates;
    LetterStandardForm.NoticeNums:= NoticeNums;
    LetterStandardForm.NoticeDates:= NoticeDates;
    LetterStandardForm.AnswerNums:= AnswerNums;
    LetterStandardForm.AnswerDates:= AnswerDates;

    MotorReturn:= False;
    if LetterStandardForm.ShowModal=mrOK then
    begin
      LetterNumEdit.Text:= STrim(LetterStandardForm.LetterNumEdit.Text);
      DT1.Date:= LetterStandardForm.DT1.Date;
      DocumentSet(LetterStandardForm.FileNameLabel.Caption, FileNameEdit);
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

procedure TLetterEditForm.FormCreate(Sender: TObject);
begin
  CanFormClose:= True;
  MotorReturn:= False;

  DT1.Date:= Date;
  AddButton.Enabled:= False;
  DelButton.Enabled:= False;

  FreeMotorListCreate;
  BusyMotorListCreate;
end;

procedure TLetterEditForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VSTFreeMotorList);
  FreeAndNil(VSTBusyMotorList);
end;

procedure TLetterEditForm.FormShow(Sender: TObject);
begin
  DataLoad;
  FreeMotorsLoad;
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

procedure TLetterEditForm.DelButtonClick(Sender: TObject);
begin
  MotorBusyToFree;
end;

procedure TLetterEditForm.AddButtonClick(Sender: TObject);
begin
  MotorFreeToBusy;
end;

procedure TLetterEditForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= CanFormClose;
end;

end.

