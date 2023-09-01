unit UPretensionForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, fpspreadsheetgrid, BCButton, DividerBevel,

  DK_Zoom, DK_Vector, DK_Matrix, DK_StrUtils, DK_Dialogs, DK_Const, DK_CtrlUtils,

  USQLite, UUtils, USheets,

  UAttachmentForm;

type

  { TPretensionForm }

  TPretensionForm = class(TForm)
    AddButton: TSpeedButton;
    AttachmentPanel: TPanel;
    DelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    EditButton: TSpeedButton;
    ExportButton: TBCButton;
    GridPanel: TPanel;
    Label1: TLabel;
    ListTypePanel: TPanel;
    LogGrid: TsWorksheetGrid;
    PDFCopyButton: TSpeedButton;
    PDFShowButton: TSpeedButton;
    Splitter1: TSplitter;
    StatisticButton: TBCButton;
    ToolPanel: TPanel;
    ViewTypeComboBox: TComboBox;
    ZoomBevel: TBevel;
    ZoomPanel: TPanel;
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure ExportButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LogGridDblClick(Sender: TObject);
    procedure PDFCopyButtonClick(Sender: TObject);
    procedure PDFShowButtonClick(Sender: TObject);
    procedure ViewTypeComboBoxChange(Sender: TObject);
  private
    AttachmentForm: TForm;

    Sheet: TSheetPretension;
    ZoomPercent: Integer;
    BeginDate, EndDate: TDate;
    MotorNumLike: String;

    //данные из базы
    PretensionIDs: TIntVector;
    UserNames, UserTitles: TStrVector;
    NoticeDates, ToBuilderDates, FromBuilderDates, ToUserDates: TDateVector;
    NoticeNums, ToBuilderNums, FromBuilderNums, ToUserNums: TStrVector;
    MoneyValues, SendValues, GetValues: TInt64Vector;
    SendDates, GetDates: TDateVector;
    Notes: TStrVector;
    Statuses: TIntVector;

    ReclamationIDs, LogIDs: TIntMatrix;
    MotorNames, MotorNums: TStrMatrix;
    MotorDates: TDateMatrix;

    //данные для отрисовки
    Users, Notices, StrStatuses: TStrVector;
    ToBuilders, FromBuilders, ToUsers: TStrVector;
    Motors: TStrMatrix;

    procedure ButtonsEnabled;

    procedure DataDraw(const AZoomPercent: Integer);
    procedure DataSelect;
    procedure DataEdit;
    procedure DataDelete;

    procedure AttachmentsLoad;
  public
    procedure DataLoad(const AMotorNumLike: String;
                      const ABeginDate: TDate;
                      const AEndDate: TDate);
  end;

var
  PretensionForm: TPretensionForm;

implementation

{$R *.lfm}

{ TPretensionForm }

procedure TPretensionForm.AddButtonClick(Sender: TObject);
var
  PretensionID, NoticeIndex: Integer;
begin
  if not PretensionEdit(0) then Exit;

  DataLoad(MotorNumLike, BeginDate, EndDate);
  PretensionID:= SQLite.PretensionMaxID;
  NoticeIndex:= VIndexOf(PretensionIDs, PretensionID);
  if NoticeIndex<0 then Exit;

  Sheet.Select(NoticeIndex, 0, Sheet.MainColIndex);
end;

procedure TPretensionForm.DelButtonClick(Sender: TObject);
begin
  DataDelete;
end;

procedure TPretensionForm.EditButtonClick(Sender: TObject);
begin
  DataEdit;
end;

procedure TPretensionForm.ExportButtonClick(Sender: TObject);
begin
  Sheet.Save('Выполнено!');
end;

procedure TPretensionForm.FormCreate(Sender: TObject);
begin
  ZoomPercent:= 100;
  CreateZoomControls(50, 150, ZoomPercent, ZoomPanel, @DataDraw, True);

  Sheet:= TSheetPretension.Create(LogGrid.Worksheet, LogGrid);
  Sheet.OnSelect:= @DataSelect;

  AttachmentForm:= FormOnPanelCreate(TAttachmentForm, AttachmentPanel);
  (AttachmentForm as TAttachmentForm).Category:= 3;
  AttachmentForm.Show;
end;

procedure TPretensionForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Sheet);
  FreeAndNil(AttachmentForm);
end;

procedure TPretensionForm.LogGridDblClick(Sender: TObject);
begin
  if EditButton.Enabled then DataEdit;
end;

procedure TPretensionForm.PDFCopyButtonClick(Sender: TObject);
var
  i, j: Integer;
begin
  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;

  case Sheet.SelectedColIndex of
  0: DocumentCopy(10, NoticeDates[i], NoticeNums[i],                  // уведомление
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  1: DocumentCopy(11, ToBuilderDates[i], ToBuilderNums[i],        // письмо производителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  2: DocumentCopy(12, FromBuilderDates[i], FromBuilderNums[i],    // ответ от производителя
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  3: DocumentCopy(13, ToUserDates[i], ToUserNums[i],              // ответ потребителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  end;
end;

procedure TPretensionForm.PDFShowButtonClick(Sender: TObject);
var
  i, j: Integer;
begin
  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;

  case Sheet.SelectedColIndex of
  0: DocumentOpen(10, NoticeDates[i], NoticeNums[i],                  // уведомление
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  1: DocumentOpen(11, ToBuilderDates[i], ToBuilderNums[i],        // письмо производителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  2: DocumentOpen(12, FromBuilderDates[i], FromBuilderNums[i],    // ответ от производителя
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  3: DocumentOpen(13, ToUserDates[i], ToUserNums[i],              // ответ потребителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  end;
end;

procedure TPretensionForm.ViewTypeComboBoxChange(Sender: TObject);
begin
  DataLoad(MotorNumLike, BeginDate, EndDate);
end;

procedure TPretensionForm.ButtonsEnabled;
var
  i, j, k: Integer;
  b: Boolean;
begin
  DelButton.Enabled:= False;
  EditButton.Enabled:= False;
  PDFShowButton.Enabled:= False;
  PDFCopyButton.Enabled:= False;

  if VIsNil(PretensionIDs) then Exit;
  if not Sheet.IsSelected then Exit;


  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;
  k:= Sheet.SelectedColIndex;

  //EditButton
  b:= False;
  case k of
  0: b:= True;                                                           // уведомление
  1: b:= (IsDocumentExists(ToBuilderDates[i], ToBuilderNums[i]) or       // письмо производителю
          IsDocumentEmpty(ToBuilderDates[i], ToBuilderNums[i]));
  2: b:= (IsDocumentExists(FromBuilderDates[i], FromBuilderNums[i]) or   // ответ от производителя
          IsDocumentEmpty(FromBuilderDates[i], FromBuilderNums[i])) and
         (not IsDocumentEmpty(ToBuilderDates[i], ToBuilderNums[i]));
  3: b:= (IsDocumentExists(ToUserDates[i], ToUserNums[i]) or             // ответ потребителю
          IsDocumentEmpty(ToUserDates[i], ToUserNums[i])) and
         (not IsDocumentEmpty(FromBuilderDates[i], FromBuilderNums[i]));
  4: b:= (not IsDocumentEmpty(ToUserDates[i], ToUserNums[i]));           // даты и суммы возмещения
  5: b:= True;                                                           // примечание
  end;
  EditButton.Enabled:= b;

  //DelButton
  b:= False;
  case k of
  0: b:= True;                                                         // уведомление
  1: b:= not IsDocumentEmpty(ToBuilderDates[i], ToBuilderNums[i]);     // письмо производителю
  2: b:= not IsDocumentEmpty(FromBuilderDates[i], FromBuilderNums[i]); // ответ от производителя
  3: b:= not IsDocumentEmpty(ToUserDates[i], ToUserNums[i]);           // ответ потребителю
  4: b:= (SendDates[i]>0) or (GetDates[i]>0);                          // даты и суммы возмещения
  5: b:= not SEmpty(Notes[i]);                                         // примечание
  end;
  DelButton.Enabled:= b;

  //PDFShowButton, PDFCopyButton
  b:= False;
  case k of
  0: b:= IsDocumentFileExists(10, NoticeDates[i], NoticeNums[i],                  // уведомление
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  1: b:= IsDocumentFileExists(11, ToBuilderDates[i], ToBuilderNums[i],        // письмо производителю
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  2: b:= IsDocumentFileExists(12, FromBuilderDates[i], FromBuilderNums[i],    // ответ от производителя
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  3: b:= IsDocumentFileExists(13, ToUserDates[i], ToUserNums[i],              // ответ потребителю
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  4: b:= False;                                                                   // даты и суммы возмещения
  5: b:= False;                                                                   // примечание
  end;
  PDFShowButton.Enabled:= b;
  PDFCopyButton.Enabled:= b;
end;

procedure TPretensionForm.DataDraw(const AZoomPercent: Integer);
begin
  ZoomPercent:= AZoomPercent;
  Sheet.Zoom:= ZoomPercent;
  Sheet.Draw;
end;

procedure TPretensionForm.DataSelect;
begin
  ButtonsEnabled;
  AttachmentsLoad;
end;

procedure TPretensionForm.DataEdit;
var
  IsChanged: Boolean;
  i, k: Integer;
  SelectedPretensionID: Integer;
begin
  if not Sheet.IsSelected then Exit;

  i:= Sheet.SelectedNoticeIndex;
  k:= Sheet.SelectedColIndex;

  SelectedPretensionID:= PretensionIDs[i];

  case k of
  0: IsChanged:= PretensionEdit(PretensionIDs[i]);            // уведомление
  1: IsChanged:= PretensionLetterEdit(11, PretensionIDs[i]);  // письмо производителю
  2: IsChanged:= PretensionLetterEdit(12, PretensionIDs[i]);  // ответ от производителя
  3: IsChanged:= PretensionLetterEdit(13, PretensionIDs[i]);  // ответ потребителю
  4: IsChanged:= PretensionMoneyDatesEdit(PretensionIDs[i]);  // возмещение затрат
  5: IsChanged:= NoteEdit(3{претензия}, PretensionIDs[i]);    // примечание
  end;

  if not IsChanged then Exit;

  DataLoad(MotorNumLike, BeginDate, EndDate);
  i:= VIndexOf(PretensionIDs, SelectedPretensionID);
  if i>=0 then
    Sheet.Select(i, 0, k);

end;

procedure TPretensionForm.DataDelete;
var
  i, j, k: Integer;
  S: String;
  V: TStrVector;
begin
  if not Sheet.IsSelected then Exit;

  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;
  k:= Sheet.SelectedColIndex;

  //текст запроса на подтверждение удаления
  if k=0 then
    S:= 'Внимание!' + SYMBOL_BREAK +
        'Будут удалены без возможности восстановления все данные и файлы по возмещению затрат, ' +
        'касающиеся электродвигателей, указанных в этой претензии!' +
         SYMBOL_BREAK + 'Продолжить удаление?'
  else begin
    case k of
    1: S:= LETTER_NAMES[11];                // письмо производителю
    2: S:= LETTER_NAMES[12];                // ответ от производителя
    3: S:= LETTER_NAMES[13];                // ответ потребителю
    4: S:= 'Данные по возмещению затрат';   // возмещение затрат
    5: S:= 'Примечание';                    // примечание
    end;
    S:= 'Удалить "' + S + '"?';
  end;

  //запрос на подтверждение удаления
  if not Confirm(S) then Exit;

  //удаление файлов
  if k=0 then
  begin
    V:= SQLite.PretensionFileNamesLoad(PretensionIDs[i]);
    DocumentsDelete(V);
  end
  else begin
    case k of
    //0: ;                                                                // уведомление
    1: DocumentDelete(11, ToBuilderDates[i], ToBuilderNums[i],        // письмо производителю
                      MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
    2: DocumentDelete(12, FromBuilderDates[i], FromBuilderNums[i],    // ответ от производителя
                      MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
    3: DocumentDelete(13, ToUserDates[i], ToUserNums[i],              // ответ потребителю
                      MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
    //4: ;                                                                // возмещение затрат
    //5: ;                                                                // примечание
    end;
  end;

  //удаление данных из базы
  case k of
  0: SQLite.PretensionNoticeDelete(PretensionIDs[i]);        // уведомление
  1: SQLite.PretensionLetterDelete(PretensionIDs[i], 11);    // письмо производителю
  2: SQLite.PretensionLetterDelete(PretensionIDs[i], 12);    // ответ от производителя
  3: SQLite.PretensionAnswerToUserDelete(PretensionIDs[i]);  // ответ потребителю
  4: SQLite.PretensionMoneyDatesDelete(PretensionIDs[i]);    // даты ремонта
  5: SQLite.PretensionNoteDelete(PretensionIDs[i]);          // примечание
  end;

  DataLoad(MotorNumLike, BeginDate, EndDate);
  if k>0 then
    Sheet.Select(i, j, k);
end;

procedure TPretensionForm.AttachmentsLoad;
var
  i, j: Integer;
begin
  if Sheet.IsSelected then
  begin
    i:= Sheet.SelectedNoticeIndex;
    j:= Sheet.SelectedMotorIndex;
    (AttachmentForm as TAttachmentForm).AttachmentsShow(LogIDs[i,j],
                        NoticeNums[i], NoticeDates[i],
                        MotorNums[i,j], MotorNames[i,j], MotorDates[i,j]);
  end
  else
    (AttachmentForm as TAttachmentForm).AttachmentsClear;
end;

procedure TPretensionForm.DataLoad(const AMotorNumLike: String;
                                    const ABeginDate: TDate;
                                    const AEndDate: TDate);
begin
  BeginDate:= ABeginDate;
  EndDate:= AEndDate;
  MotorNumLike:= AMotorNumLike;

  Sheet.Unselect;

  SQLite.PretensionListLoad(AMotorNumLike, ABeginDate, AEndDate,
                ViewTypeComboBox.ItemIndex,
                PretensionIDs, Statuses, UserNames, UserTitles, Notes,
                NoticeDates, NoticeNums,
                MoneyValues, SendValues, GetValues, SendDates, GetDates,
                ToBuilderDates, ToBuilderNums,
                FromBuilderDates, FromBuilderNums, ToUserDates, ToUserNums,
                ReclamationIDs, LogIDs, MotorNames, MotorNums, MotorDates);

  Users:= VCut(UserTitles);  //UserNames
  Notices:= VLetterFullName(NoticeDates, NoticeNums);
  StrStatuses:= VPretensionStatusIntToStr(Statuses);

  ToBuilders:= VLetterFullName(ToBuilderDates, ToBuilderNums);
  FromBuilders:= VLetterFullName(FromBuilderDates, FromBuilderNums);
  ToUsers:= VLetterFullName(ToUserDates, ToUserNums);

  Motors:= MMotorFullName(MotorNames, MotorNums, MotorDates);

  Sheet.Update(Users, Notices, ToBuilders, FromBuilders, ToUsers, Notes, StrStatuses,
               Motors, MoneyValues, SendValues, GetValues, SendDates, GetDates);
  Sheet.Draw;
end;

end.

