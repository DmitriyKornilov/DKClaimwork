unit URepairForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, DividerBevel,

  DK_Zoom, DK_Vector, DK_Matrix, DK_StrUtils, DK_Dialogs, DK_Const,

  USQLite, UUtils, USheets, fpspreadsheetgrid, BCButton;

type

  { TRepairForm }

  TRepairForm = class(TForm)
    AddButton: TSpeedButton;
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
    StatisticButton: TBCButton;
    ToolPanel: TPanel;
    ViewTypeComboBox: TComboBox;
    ZoomBevel: TBevel;
    ZoomPanel: TPanel;
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LogGridDblClick(Sender: TObject);
    procedure PDFCopyButtonClick(Sender: TObject);
    procedure PDFShowButtonClick(Sender: TObject);
    procedure ViewTypeComboBoxChange(Sender: TObject);
  private
    Sheet: TSheetRepair;
    ZoomPercent: Integer;

    //данные из базы
    RepairIDs: TIntVector;
    UserNames, UserTitles: TStrVector;
    NoticeDates: TDateVector;
    NoticeNums: TStrVector;

    ToBuilderDates: TDateMatrix;
    ToBuilderNums: TStrMatrix;
    FromBuilderDates: TDateMatrix;
    FromBuilderNums: TStrMatrix;
    ToUserDates: TDateMatrix;
    ToUserNums: TStrMatrix;
    BeginDates: TDateMatrix;
    EndDates: TDateMatrix;
    ReclamationIDs, LogIDs, Statuses: TIntMatrix;
    Notes, MotorNames, MotorNums: TStrMatrix;
    MotorDates: TDateMatrix;

    //данные для отрисовки
    Users, Notices: TStrVector;
    ToBuilders, FromBuilders, ToUsers: TStrMatrix;
    StrStatuses, Motors: TStrMatrix;

    procedure ButtonsEnabled;

    procedure DataDraw(const AZoomPercent: Integer);
    procedure DataSelect;
    procedure DataEdit;
    procedure DataDelete;
  public
    procedure DataLoad(const AMotorNumLike: String = '';
                       const ABeginDate: TDate = 0;
                       const AEndDate: TDate = 0);
  end;

var
  RepairForm: TRepairForm;

implementation

{$R *.lfm}

{ TRepairForm }

procedure TRepairForm.FormCreate(Sender: TObject);
begin
  ZoomPercent:= 100;
  CreateZoomControls(50, 150, ZoomPercent, ZoomPanel, @DataDraw, True);

  Sheet:= TSheetRepair.Create(LogGrid.Worksheet, LogGrid);
  Sheet.OnSelect:= @DataSelect;
end;

procedure TRepairForm.AddButtonClick(Sender: TObject);
var
  RepairID, NoticeIndex: Integer;
begin
  if not RepairEdit(0) then Exit;

  DataLoad;
  RepairID:= SQLite.RepairMaxID;
  NoticeIndex:= VIndexOf(RepairIDs, RepairID);
  if NoticeIndex<0 then Exit;

  Sheet.Select(NoticeIndex, 0, Sheet.MainColIndex);

end;

procedure TRepairForm.DelButtonClick(Sender: TObject);
begin
  DataDelete;
end;

procedure TRepairForm.EditButtonClick(Sender: TObject);
begin
  DataEdit;
end;

procedure TRepairForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Sheet);
end;

procedure TRepairForm.LogGridDblClick(Sender: TObject);
begin
  if EditButton.Enabled then DataEdit;
end;

procedure TRepairForm.PDFCopyButtonClick(Sender: TObject);
var
  i, j: Integer;
begin
  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;

  case Sheet.SelectedColIndex of
  0: DocumentCopy(6, NoticeDates[i], NoticeNums[i],                  // уведомление
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  1: DocumentCopy(7, ToBuilderDates[i,j], ToBuilderNums[i,j],        // письмо производителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  2: DocumentCopy(8, FromBuilderDates[i,j], FromBuilderNums[i,j],    // ответ от производителя
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  3: DocumentCopy(9, ToUserDates[i,j], ToUserNums[i,j],              // ответ потребителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  //4: ;                                                             // даты ремонта
  //5: ;                                                             // отзыв рекламации потребителем
  end;
end;

procedure TRepairForm.PDFShowButtonClick(Sender: TObject);
var
  i, j: Integer;
begin
  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;

  case Sheet.SelectedColIndex of
  0: DocumentOpen(6, NoticeDates[i], NoticeNums[i],                  // уведомление
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  1: DocumentOpen(7, ToBuilderDates[i,j], ToBuilderNums[i,j],        // письмо производителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  2: DocumentOpen(8, FromBuilderDates[i,j], FromBuilderNums[i,j],    // ответ от производителя
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  3: DocumentOpen(9, ToUserDates[i,j], ToUserNums[i,j],              // ответ потребителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  //4: ;                                                             // даты ремонта
  //5: ;                                                             // отзыв рекламации потребителем
  end;
end;

procedure TRepairForm.ViewTypeComboBoxChange(Sender: TObject);
begin
  DataLoad;
end;

procedure TRepairForm.ButtonsEnabled;
var
  i, j, k: Integer;
  b: Boolean;
begin
  DelButton.Enabled:= False;
  EditButton.Enabled:= False;
  PDFShowButton.Enabled:= False;
  PDFCopyButton.Enabled:= False;

  if VIsNil(RepairIDs) then Exit;
  if not Sheet.IsSelected then Exit;

  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;
  k:= Sheet.SelectedColIndex;

  //EditButton
  case k of
  0: b:= True;                                                               // уведомление
  1: b:= (IsDocumentExists(ToBuilderDates[i,j], ToBuilderNums[i,j]) or       // письмо производителю
          IsDocumentEmpty(ToBuilderDates[i,j], ToBuilderNums[i,j]));
  2: b:= (IsDocumentExists(FromBuilderDates[i,j], FromBuilderNums[i,j]) or   // ответ от производителя
          IsDocumentEmpty(FromBuilderDates[i,j], FromBuilderNums[i,j])) and
         (not IsDocumentEmpty(ToBuilderDates[i,j], ToBuilderNums[i,j]));
  3: b:= (IsDocumentExists(ToUserDates[i,j], ToUserNums[i,j]) or             // ответ потребителю
          IsDocumentEmpty(ToUserDates[i,j], ToUserNums[i,j])) and
         (not IsDocumentEmpty(FromBuilderDates[i,j], FromBuilderNums[i,j]));
  4: b:= (not IsDocumentEmpty(ToUserDates[i,j], ToUserNums[i,j]));           // даты ремонта
  5: b:= True;                                                               // примечание
  end;
  EditButton.Enabled:= b;

  //DelButton
  case k of
  0: b:= True;                                                             // уведомление
  1: b:= not IsDocumentEmpty(ToBuilderDates[i,j], ToBuilderNums[i,j]);     // письмо производителю
  2: b:= not IsDocumentEmpty(FromBuilderDates[i,j], FromBuilderNums[i,j]); // ответ от производителя
  3: b:= not IsDocumentEmpty(ToUserDates[i,j], ToUserNums[i,j]);           // ответ потребителю
  4: b:= (BeginDates[i,j]>0) or (EndDates[i,j]>0);                         // даты ремонта
  5: b:= not SEmpty(Notes[i,j]);                                           // примечание
  end;
  DelButton.Enabled:= b;

  //PDFShowButton, PDFCopyButton
  case k of
  0: b:= IsDocumentFileExists(6, NoticeDates[i], NoticeNums[i],                  // уведомление
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  1: b:= IsDocumentFileExists(7, ToBuilderDates[i,j], ToBuilderNums[i,j],        // письмо производителю
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  2: b:= IsDocumentFileExists(8, FromBuilderDates[i,j], FromBuilderNums[i,j],    // ответ от производителя
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  3: b:= IsDocumentFileExists(9, ToUserDates[i,j], ToUserNums[i,j],              // ответ потребителю
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  4: b:= False;                                                                  // даты ремонта
  5: b:= False;                                                                  // примечание
  end;
  PDFShowButton.Enabled:= b;
  PDFCopyButton.Enabled:= b;
end;

procedure TRepairForm.DataDraw(const AZoomPercent: Integer);
begin
  ZoomPercent:= AZoomPercent;
  Sheet.Zoom:= ZoomPercent;
  Sheet.Draw;
end;

procedure TRepairForm.DataSelect;
begin
  ButtonsEnabled;
end;

procedure TRepairForm.DataEdit;
var
  IsChanged: Boolean;
  i, j, k: Integer;
begin
  if not Sheet.IsSelected then Exit;

  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;
  k:= Sheet.SelectedColIndex;

  case k of
  0: IsChanged:= RepairEdit(RepairIDs[i]);                  // уведомление
  1: IsChanged:= LetterEdit(7, RepairIDs[i], LogIDs[i,j]);  // письмо производителю
  2: IsChanged:= LetterEdit(8, RepairIDs[i], LogIDs[i,j]);  // ответ от производителя
  3: IsChanged:= LetterEdit(9, RepairIDs[i], LogIDs[i,j]);  // ответ потребителю
  4: IsChanged:= RepairDatesEdit(LogIDs[i,j]);              // даты ремонта
  5: IsChanged:= NoteEdit(2{ремонты}, LogIDs[i,j]);          // примечание
  end;

  if not IsChanged then Exit;

  DataLoad;
  Sheet.Select(i, j, k);
end;

procedure TRepairForm.DataDelete;
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
        'Будут удалены без возможности восстановления все данные и файлы по ремонту, ' +
        'касающиеся электродвигателей, указанных в этом запросе!' +
         SYMBOL_BREAK + 'Продолжить удаление?'
  else begin
    case k of
    1: S:= LETTER_NAMES[7]; // письмо производителю
    2: S:= LETTER_NAMES[8]; // ответ от производителя
    3: S:= LETTER_NAMES[9]; // ответ потребителю
    4: S:= 'Даты ремонта';  // даты ремонта
    5: S:= 'Примечание';    // примечание
    end;
    S:= 'Удалить "' + S + '"?';
  end;

  //запрос на подтверждение удаления
  if not Confirm(S) then Exit;

  //удаление файлов
  if k=0 then
  begin
    V:= SQLite.RepairFileNamesLoad(RepairIDs[i]);
    DocumentsDelete(V);
  end
  else begin
    case k of
    //0: ;                                                               // уведомление
    1: DocumentDelete(7, ToBuilderDates[i,j], ToBuilderNums[i,j],        // письмо производителю
                      MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
    2: DocumentDelete(8, FromBuilderDates[i,j], FromBuilderNums[i,j],    // ответ от производителя
                      MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
    3: DocumentDelete(9, ToUserDates[i,j], ToUserNums[i,j],              // ответ потребителю
                      MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
    //4: ;                                                               // даты ремонта
    //5: ;                                                               // примечание
    end;
  end;

  //удаление данных из базы
  case k of
  0: SQLite.RepairNoticeDelete(RepairIDs[i]);      // уведомление
  1: SQLite.LetterDelete(LogIDs[i,j], 7);          // письмо производителю
  2: SQLite.LetterDelete(LogIDs[i,j], 8);          // ответ от производителя
  3: SQLite.RepairAnswerToUserDelete(LogIDs[i,j]); // ответ потребителю
  4: SQLite.RepairDatesDelete(LogIDs[i,j]);        // даты ремонта
  5: SQLite.NoteDelete(LogIDs[i,j], 2{ремонт});    // примечание
  end;

  DataLoad;
  if k<>1 then
    Sheet.Select(i, j, k);

end;

procedure TRepairForm.DataLoad(const AMotorNumLike: String = '';
                       const ABeginDate: TDate = 0;
                       const AEndDate: TDate = 0);
begin
  Sheet.Unselect;

  SQLite.RepairListLoad(AMotorNumLike, ABeginDate, AEndDate,
                ViewTypeComboBox.ItemIndex,
                RepairIDs, UserNames, UserTitles,
                NoticeDates, NoticeNums, ToBuilderDates, ToBuilderNums,
                FromBuilderDates, FromBuilderNums, ToUserDates, ToUserNums,
                BeginDates, EndDates, ReclamationIDs,
                LogIDs, Statuses, Notes, MotorNames, MotorNums, MotorDates);

  Users:= VCut(UserTitles);  //UserNames
  Notices:= VLetterFullName(NoticeDates, NoticeNums);

  ToBuilders:= MLetterFullName(ToBuilderDates, ToBuilderNums);
  FromBuilders:= MLetterFullName(FromBuilderDates, FromBuilderNums);
  ToUsers:= MLetterFullName(ToUserDates, ToUserNums);

  StrStatuses:= MRepairStatusIntToStr(Statuses);
  Motors:= MMotorFullName(MotorNames, MotorNums, MotorDates);

  Sheet.Update(Users, Notices, ToBuilders, FromBuilders, ToUsers,
               Notes, StrStatuses, Motors, BeginDates, EndDates);
  Sheet.Draw;
end;

end.

