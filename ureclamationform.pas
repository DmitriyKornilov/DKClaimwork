unit UReclamationForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, Menus, BCButton, fpspreadsheetgrid, DividerBevel,
  VirtualTrees,

  DK_Zoom, DK_Vector, DK_Matrix, DK_StrUtils, DK_Dialogs, DK_Const, DK_VSTTables,

  USQLite, UUtils, USheets;

type

  { TReclamationForm }

  TReclamationForm = class(TForm)
    AddButton: TSpeedButton;
    AddAttButton: TSpeedButton;
    AttachmentPanel: TPanel;
    DelAttButton: TSpeedButton;
    DividerBevel3: TDividerBevel;
    EditAttButton: TSpeedButton;
    AttachmentLabel: TLabel;
    ListTypePanel1: TPanel;
    PDFCopyButton: TSpeedButton;
    PDFCopyAttButton: TSpeedButton;
    PDFShowButton: TSpeedButton;
    PDFShowAttButton: TSpeedButton;
    Splitter1: TSplitter;
    AttachmentToolPanel: TPanel;
    ViewTypeComboBox: TComboBox;
    DelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    EditButton: TSpeedButton;
    ExportButton: TBCButton;
    GridPanel: TPanel;
    Label1: TLabel;
    LogGrid: TsWorksheetGrid;
    ListTypePanel: TPanel;
    StatisticButton: TBCButton;
    ToolPanel: TPanel;
    VT1: TVirtualStringTree;
    ZoomBevel: TBevel;
    ZoomPanel: TPanel;
    procedure AddAttButtonClick(Sender: TObject);
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
    Sheet: TSheetReclamation;
    ZoomPercent: Integer;
    BeginDate, EndDate: TDate;
    MotorNumLike: String;

    VSTAttachmentList: TVSTTable;
    AttachmentIDs: TIntVector;
    AttachmentNames: TStrVector;
    SelectedReclamationIndex, SelectedMotorIndex: Integer;

    //данные из базы
    ReclamationIDs: TIntVector;
    UserNames, UserTitles: TStrVector;
    LocationNames, LocationTitles: TStrVector;
    NoticeDates: TDateVector;
    NoticeNums: TStrVector;

    ToBuilderDates: TDateMatrix;
    ToBuilderNums: TStrMatrix;
    FromBuilderDates: TDateMatrix;
    FromBuilderNums: TStrMatrix;
    ToUserDates: TDateMatrix;
    ToUserNums: TStrMatrix;
    CancelDates: TDateMatrix;
    CancelNums: TStrMatrix;
    ReportDates: TDateMatrix;
    ReportNums: TStrMatrix;
    LogIDs, Mileages, Statuses: TIntMatrix;
    Notes, MotorNames, MotorNums: TStrMatrix;
    MotorDates: TDateMatrix;

    //данные для отрисовки
    Users, Notices, Locations: TStrVector;
    ToBuilders, FromBuilders, ToUsers: TStrMatrix;
    StrStatuses, Motors: TStrMatrix;
    Cancels, Reports: TStrMatrix;

    procedure ButtonsEnabled;

    procedure DataDraw(const AZoomPercent: Integer);
    procedure DataSelect;
    procedure DataEdit;
    procedure DataDelete;

    procedure AttachmentShow;
    procedure AttachmentLoad;
    procedure AttachmentSelect;
  public
    procedure DataLoad(const AMotorNumLike: String;
                        const ABeginDate: TDate;
                        const AEndDate: TDate);
  end;

var
  ReclamationForm: TReclamationForm;

implementation

{$R *.lfm}

{ TReclamationForm }

procedure TReclamationForm.AddButtonClick(Sender: TObject);
var
  ReclamationID, NoticeIndex: Integer;
begin
  if not ReclamationEdit(0) then Exit;

  DataLoad(MotorNumLike, BeginDate, EndDate);
  ReclamationID:= SQLite.ReclamationMaxID;
  NoticeIndex:= VIndexOf(ReclamationIDs, ReclamationID);
  if NoticeIndex<0 then Exit;

  Sheet.Select(NoticeIndex, 0, Sheet.MainColIndex);
end;

procedure TReclamationForm.AddAttButtonClick(Sender: TObject);
var
  LogID: Integer;
begin
  LogID:= LogIDs[Sheet.SelectedNoticeIndex, Sheet.SelectedMotorIndex];
  if AttachmentEdit(1{рекл}, LogID, 0 {new}) then
    AttachmentLoad;
end;

procedure TReclamationForm.DataEdit;
var
  IsChanged: Boolean;
  i, j, k: Integer;
begin
  if not Sheet.IsSelected then Exit;

  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;
  k:= Sheet.SelectedColIndex;

  case k of
  0: IsChanged:= MileageEdit(LogIDs[i,j]);                       // пробег
  1: IsChanged:= ReclamationEdit(ReclamationIDs[i]);             // уведомление
  2: IsChanged:= LetterEdit(1, ReclamationIDs[i], LogIDs[i,j]);  // письмо производителю
  3: IsChanged:= LetterEdit(2, ReclamationIDs[i], LogIDs[i,j]);  // ответ от производителя
  4: IsChanged:= LetterEdit(3, ReclamationIDs[i], LogIDs[i,j]);  // ответ потребителю
  5: IsChanged:= LetterEdit(4, ReclamationIDs[i], LogIDs[i,j]);  // акт осмотра двигателя
  6: IsChanged:= LetterEdit(5, ReclamationIDs[i], LogIDs[i,j]);  // отзыв рекламации потребителем
  7: IsChanged:= NoteEdit(1{реклам}, LogIDs[i,j]);               // примечание
  end;

  if not IsChanged then Exit;

  DataLoad(MotorNumLike, BeginDate, EndDate);
  Sheet.Select(i, j, k);
end;

procedure TReclamationForm.DataDelete;
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
  if k=1 then
    S:= 'Внимание!' + SYMBOL_BREAK +
        'Будут удалены без возможности восстановления все данные и файлы, ' +
        'касающиеся электродвигателей, указанных в этом уведомлении о неисправности!' +
         SYMBOL_BREAK + 'Продолжить удаление?'
  else begin
    case k of
    0: S:= 'Пробег';        // пробег
    //1: S:= LETTER_NAMES[0]; // уведомление
    2: S:= LETTER_NAMES[1]; // письмо производителю
    3: S:= LETTER_NAMES[2]; // ответ от производителя
    4: S:= LETTER_NAMES[3]; // ответ потребителю
    5: S:= LETTER_NAMES[4]; // акт осмотра двигателя
    6: S:= LETTER_NAMES[5]; // отзыв рекламации потребителем
    7: S:= 'Примечание';    // примечание
    end;
    S:= 'Удалить "' + S + '"?';
  end;

  //запрос на подтверждение удаления
  if not Confirm(S) then Exit;

  //удаление файлов
  if k=1 then
  begin
    //все файлы, каксающиеся этой рекламации (в том числе по ремонтам и претензиям)
    V:= SQLite.AllFileNamesLoad(ReclamationIDs[i]);
    DocumentsDelete(V);
  end
  else begin
    case k of
    //0: ;                                                               // пробег
    //1: ;                                                               // уведомление
    2: DocumentDelete(1, ToBuilderDates[i,j], ToBuilderNums[i,j],        // письмо производителю
                      MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
    3: DocumentDelete(2, FromBuilderDates[i,j], FromBuilderNums[i,j],    // ответ от производителя
                      MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
    4: DocumentDelete(3, ToUserDates[i,j], ToUserNums[i,j],              // ответ потребителю
                      MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
    5: DocumentDelete(4, ReportDates[i,j], ReportNums[i,j],              // акт осмотра двигателя
                      MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
    6: DocumentDelete(5, CancelDates[i,j], CancelNums[i,j],              // отзыв рекламации потребителем
                      MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
    //7: ;                                                               // примечание
    end;
  end;

  //удаление данных из базы
  case k of
  0: SQLite.MileageDelete(LogIDs[i,j]);                 // пробег
  1: SQLite.ReclamationNoticeDelete(ReclamationIDs[i]); // уведомление
  2: SQLite.LetterDelete(LogIDs[i,j], 1);               // письмо производителю
  3: SQLite.LetterDelete(LogIDs[i,j], 2);               // ответ от производителя
  4: SQLite.ReclamationAnswerToUserDelete(LogIDs[i,j]); // ответ потребителю
  5: SQLite.ReclamationReportDelete(LogIDs[i,j]);       // акт осмотра двигателя
  6: SQLite.ReclamationCancelDelete(LogIDs[i,j]);       // отзыв рекламации потребителем
  7: SQLite.NoteDelete(LogIDs[i,j], 1{реклам});         // примечание
  end;

  DataLoad(MotorNumLike, BeginDate, EndDate);
  if k<>1 then
    Sheet.Select(i, j, k);
end;

procedure TReclamationForm.AttachmentShow;
var
  i,j: Integer;
begin
  AddAttButton.Enabled:= Sheet.IsSelected;
  AttachmentLabel.Caption:= 'Приложения к рекламации';
  if not AddAttButton.Enabled then Exit;

  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;
  AttachmentLabel.Caption:= 'Приложения к рекламации ' +
    MotorFullName(MotorNames[i,j], MotorNums[i,j],  MotorDates[i,j]);

  if (SelectedReclamationIndex=i) and (SelectedMotorIndex=j) then Exit;

  SelectedReclamationIndex:= i;
  SelectedMotorIndex:= j;

  AttachmentLoad;
end;

procedure TReclamationForm.AttachmentLoad;
var
  i,j: Integer;
begin
  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;
  SQLite.AttachmentListLoad(1{реклам}, LogIDs[i,j], AttachmentIDs, AttachmentNames);
  VSTAttachmentList.UnSelect;
  VSTAttachmentList.SetColumn('Список', AttachmentNames, taLeftJustify);
  VSTAttachmentList.Draw;
end;

procedure TReclamationForm.AttachmentSelect;
begin

end;

procedure TReclamationForm.DelButtonClick(Sender: TObject);
begin
  DataDelete;
end;

procedure TReclamationForm.EditButtonClick(Sender: TObject);
begin
  DataEdit;
end;

procedure TReclamationForm.FormCreate(Sender: TObject);
begin
  ZoomPercent:= 100;
  CreateZoomControls(50, 150, ZoomPercent, ZoomPanel, @DataDraw, True);

  Sheet:= TSheetReclamation.Create(LogGrid.Worksheet, LogGrid);
  Sheet.OnSelect:= @DataSelect;

  SelectedReclamationIndex:= -1;
  SelectedMotorIndex:= -1;

  VSTAttachmentList:= TVSTTable.Create(VT1);
  VSTAttachmentList.CanSelect:= True;
  VSTAttachmentList.OnSelect:= @AttachmentSelect;
  VSTAttachmentList.HeaderVisible:= False;
  VSTAttachmentList.AddColumn('Список');
end;

procedure TReclamationForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Sheet);
  FreeAndNil(VSTAttachmentList);
end;

procedure TReclamationForm.LogGridDblClick(Sender: TObject);
begin
  if EditButton.Enabled then DataEdit;
end;

procedure TReclamationForm.PDFCopyButtonClick(Sender: TObject);
var
  i, j: Integer;
begin
  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;

  case Sheet.SelectedColIndex of
  1: DocumentCopy(0, NoticeDates[i], NoticeNums[i],                  // уведомление
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  2: DocumentCopy(1, ToBuilderDates[i,j], ToBuilderNums[i,j],        // письмо производителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  3: DocumentCopy(2, FromBuilderDates[i,j], FromBuilderNums[i,j],    // ответ от производителя
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  4: DocumentCopy(3, ToUserDates[i,j], ToUserNums[i,j],              // ответ потребителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  5: DocumentCopy(4, ReportDates[i,j], ReportNums[i,j],              // акт осмотра двигателя
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  6: DocumentCopy(5, CancelDates[i,j], CancelNums[i,j],              // отзыв рекламации потребителем
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  end;
end;

procedure TReclamationForm.PDFShowButtonClick(Sender: TObject);
var
  i, j: Integer;
begin
  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;

  case Sheet.SelectedColIndex of
  1: DocumentOpen(0, NoticeDates[i], NoticeNums[i],                  // уведомление
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  2: DocumentOpen(1, ToBuilderDates[i,j], ToBuilderNums[i,j],        // письмо производителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  3: DocumentOpen(2, FromBuilderDates[i,j], FromBuilderNums[i,j],    // ответ от производителя
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  4: DocumentOpen(3, ToUserDates[i,j], ToUserNums[i,j],              // ответ потребителю
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  5: DocumentOpen(4, ReportDates[i,j], ReportNums[i,j],              // акт осмотра двигателя
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  6: DocumentOpen(5, CancelDates[i,j], CancelNums[i,j],              // отзыв рекламации потребителем
                  MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  end;
end;

procedure TReclamationForm.ViewTypeComboBoxChange(Sender: TObject);
begin
  DataLoad(MotorNumLike, BeginDate, EndDate);
end;

procedure TReclamationForm.DataLoad(const AMotorNumLike: String;
                                    const ABeginDate: TDate;
                                    const AEndDate: TDate);
var
  i: Integer;
begin
  BeginDate:= ABeginDate;
  EndDate:= AEndDate;
  MotorNumLike:= AMotorNumLike;

  Sheet.Unselect;

  SQLite.ReclamationListLoad(MotorNumLike, ABeginDate, AEndDate,
                ViewTypeComboBox.ItemIndex,
                ReclamationIDs, UserNames, UserTitles, LocationNames, LocationTitles,
                NoticeDates, NoticeNums, ToBuilderDates, ToBuilderNums,
                FromBuilderDates, FromBuilderNums, ToUserDates, ToUserNums,
                CancelDates, CancelNums, ReportDates, ReportNums,
                LogIDs, Mileages, Statuses, Notes, MotorNames, MotorNums, MotorDates);

  Users:= VCut(UserTitles);  //UserNames
  Locations:= VCut(LocationTitles); //LocationNames
  Notices:= VLetterFullName(NoticeDates, NoticeNums);

  ToBuilders:= MLetterFullName(ToBuilderDates, ToBuilderNums);
  FromBuilders:= MLetterFullName(FromBuilderDates, FromBuilderNums);
  ToUsers:= MLetterFullName(ToUserDates, ToUserNums);
  Cancels:= MLetterFullName(CancelDates, CancelNums);
  MChangeIf(Cancels, EmptyStr, LETTER_NOTNEED_MARK);
  Reports:= MLetterFullName(ReportDates, ReportNums);

  StrStatuses:= MReclamationStatusIntToStr(Statuses);
  Motors:= MMotorFullName(MotorNames, MotorNums, MotorDates);


  Sheet.Update(Locations, Users, Notices, ToBuilders, FromBuilders, ToUsers,
               Notes, StrStatuses, Motors, Reports, Cancels, Mileages);
  Sheet.Draw;
end;

procedure TReclamationForm.DataDraw(const AZoomPercent: Integer);
begin
  ZoomPercent:= AZoomPercent;
  Sheet.Zoom:= ZoomPercent;
  Sheet.Draw;
end;

procedure TReclamationForm.ButtonsEnabled;
var
  i, j, k: Integer;
  b: Boolean;
begin
  DelButton.Enabled:= False;
  EditButton.Enabled:= False;
  PDFShowButton.Enabled:= False;
  PDFCopyButton.Enabled:= False;

  if VIsNil(ReclamationIDs) then Exit;
  if not Sheet.IsSelected then Exit;

  i:= Sheet.SelectedNoticeIndex;
  j:= Sheet.SelectedMotorIndex;
  k:= Sheet.SelectedColIndex;

  //EditButton
  b:= False;
  case k of
  0: b:= True;                                                               // пробег
  1: b:= True;                                                               // уведомление
  2: b:= (IsDocumentExists(ToBuilderDates[i,j], ToBuilderNums[i,j]) or       // письмо производителю
          IsDocumentEmpty(ToBuilderDates[i,j], ToBuilderNums[i,j]));
  3: b:= (IsDocumentExists(FromBuilderDates[i,j], FromBuilderNums[i,j]) or   // ответ от производителя
          IsDocumentEmpty(FromBuilderDates[i,j], FromBuilderNums[i,j])) and
         (not IsDocumentEmpty(ToBuilderDates[i,j], ToBuilderNums[i,j]));
  4: b:= (IsDocumentExists(ToUserDates[i,j], ToUserNums[i,j]) or             // ответ потребителю
          IsDocumentEmpty(ToUserDates[i,j], ToUserNums[i,j])) and
         (not IsDocumentEmpty(FromBuilderDates[i,j], FromBuilderNums[i,j]));
  5: b:= (IsDocumentExists(ReportDates[i,j], ReportNums[i,j]) or             // акт осмотра двигателя
          IsDocumentEmpty(ReportDates[i,j], ReportNums[i,j])) and
         (not IsDocumentEmpty(ToUserDates[i,j], ToUserNums[i,j]));
  6: b:= (IsDocumentExists(CancelDates[i,j], CancelNums[i,j]) or             // отзыв рекламации потребителем
          IsDocumentEmpty(CancelDates[i,j], CancelNums[i,j])) and
         (not IsDocumentEmpty(ToUserDates[i,j], ToUserNums[i,j]));
  7: b:= True;                                                               // примечание
  end;
  EditButton.Enabled:= b;

  //DelButton
  b:= False;
  case k of
  0: b:= Mileages[i,j]>=0;                                                 // пробег
  1: b:= True;                                                             // уведомление
  2: b:= not IsDocumentEmpty(ToBuilderDates[i,j], ToBuilderNums[i,j]);     // письмо производителю
  3: b:= not IsDocumentEmpty(FromBuilderDates[i,j], FromBuilderNums[i,j]); // ответ от производителя
  4: b:= not IsDocumentEmpty(ToUserDates[i,j], ToUserNums[i,j]);           // ответ потребителю
  5: b:= not IsDocumentEmpty(ReportDates[i,j], ReportNums[i,j]);           // акт осмотра двигателя
  6: b:= not IsDocumentEmpty(CancelDates[i,j], CancelNums[i,j]);           // отзыв рекламации потребителем
  7: b:= not SEmpty(Notes[i,j]);                                           // примечание
  end;
  DelButton.Enabled:= b;

  //PDFShowButton, PDFCopyButton
  b:= False;
  case k of
  1: b:= IsDocumentFileExists(0, NoticeDates[i], NoticeNums[i],                  // уведомление
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  2: b:= IsDocumentFileExists(1, ToBuilderDates[i,j], ToBuilderNums[i,j],        // письмо производителю
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  3: b:= IsDocumentFileExists(2, FromBuilderDates[i,j], FromBuilderNums[i,j],    // ответ от производителя
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  4: b:= IsDocumentFileExists(3, ToUserDates[i,j], ToUserNums[i,j],              // ответ потребителю
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  5: b:= IsDocumentFileExists(4, ReportDates[i,j], ReportNums[i,j],              // акт осмотра двигателя
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  6: b:= IsDocumentFileExists(5, CancelDates[i,j], CancelNums[i,j],              // отзыв рекламации потребителем
                              MotorDates[i,j], MotorNames[i,j], MotorNums[i,j]);
  7: b:= False;                                                                  // примечание
  end;
  PDFShowButton.Enabled:= b;
  PDFCopyButton.Enabled:= b;
end;

procedure TReclamationForm.DataSelect;
begin
  ButtonsEnabled;
  //AttachmentShow;
end;

end.

