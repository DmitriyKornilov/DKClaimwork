unit UMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  Buttons, StdCtrls, EditBtn, fpspreadsheetgrid, BCButton, DividerBevel,
  LCLIntf, FileUtil, DateTimePicker, VirtualTrees,

  DK_LCLStrRus, DK_HeapTrace, DK_Const, DK_Vector, DK_Zoom, DK_CtrlUtils,
  DK_SheetExporter, DK_StrUtils, DK_Dialogs, DK_VSTTools, DK_DateUtils,

  USQLite, USheets, UUtils,

  UMotorEditForm, USenderEditForm, UReceiverEditForm, UImageEditForm,
  UNoticeEditForm, UNoteEditForm, ULetterEditForm, URepairDatesEditForm,
  ULetterCustomForm, UAboutForm, UMoneyDatesEditForm, UStatisticForm;

type

  { TMainForm }

  TMainForm = class(TForm)
    AboutButton: TSpeedButton;
    AddMotorButton: TSpeedButton;
    Bevel10: TBevel;
    Bevel11: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    DT1: TDateTimePicker;
    DT2: TDateTimePicker;
    DelMotorButton: TSpeedButton;
    EditMotorButton: TSpeedButton;
    EditMotorPanel: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    LetterButton: TBCButton;
    CopyMenuItem: TMenuItem;
    ShowOneMenuItem: TMenuItem;
    ShowAllMenuItem: TMenuItem;
    OpenMenuItem: TMenuItem;
    PeriodPanel: TPanel;
    Panel3: TPanel;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    StatisticButton: TBCButton;
    ReclamationButton: TBCButton;
    DelCancelButton: TSpeedButton;
    SaveDialog1: TSaveDialog;
    ShowCancelButton: TSpeedButton;
    DelReportOrRepDatesOrMoneyDatesButton: TSpeedButton;
    ShowReportButton: TSpeedButton;
    DelFromBuilderButton: TSpeedButton;
    DelFromUserButton: TSpeedButton;
    ShowToUserButton: TSpeedButton;
    DelNoteButton: TSpeedButton;
    ShowFromBuilderButton: TSpeedButton;
    ShowFromUserButton: TSpeedButton;
    DelToBuilderButton: TSpeedButton;
    DelToUserButton: TSpeedButton;
    DelegateListMenuItem: TMenuItem;
    BuilderDelegateMenuItem: TMenuItem;
    BuilderListMenuItem: TMenuItem;
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    DividerBevel3: TDividerBevel;
    DividerBevel4: TDividerBevel;
    DividerBevel5: TDividerBevel;
    EditCancelButton: TSpeedButton;
    EditReportOrRepDatesOrMoneyDatesButton: TSpeedButton;
    EditFromBuilderButton: TSpeedButton;
    EditFromUserButton: TSpeedButton;
    EditNoteButton: TSpeedButton;
    EditFromBuilderPanel: TPanel;
    EditFromUserPanel: TPanel;
    EditNotePanel: TPanel;
    EditCancelPanel: TPanel;
    EditReportOrRepDatesOrSendMoneyPanel: TPanel;
    EditToBuilderPanel: TPanel;
    EditToUserPanel: TPanel;
    EditToBuilderButton: TSpeedButton;
    EditToUserButton: TSpeedButton;
    EditLeftPanel: TPanel;
    ExitButton: TSpeedButton;
    ExportButton: TBCButton;
    UserListMenuItem: TMenuItem;
    ImageListMenuItem: TMenuItem;
    ImagesEdit24x24: TImageList;
    ImagesMain24x24: TImageList;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LeftPanel: TPanel;
    LogGrid: TsWorksheetGrid;
    MainPanel: TPanel;
    PretensionButton: TBCButton;
    MotorListMenuItem: TMenuItem;
    Panel1: TPanel;
    PerformerListMenuItem: TMenuItem;
    LocationListMenuItem: TMenuItem;
    PopupMenu1: TPopupMenu;
    ReceiverListMenuItem: TMenuItem;
    RefreshButton: TSpeedButton;
    RepairButton: TBCButton;
    SearchLabel: TLabel;
    SearchNumEdit: TEditButton;
    SearchPanel: TPanel;
    SenderListMenuItem: TMenuItem;
    SettingsButton: TBCButton;
    ShowToBuilderButton: TSpeedButton;
    Splitter1: TSplitter;
    ToolPanel: TPanel;
    VT1: TVirtualStringTree;
    VT2: TVirtualStringTree;
    ZoomPanel: TPanel;
    procedure AboutButtonClick(Sender: TObject);
    procedure AddMotorButtonClick(Sender: TObject);
    procedure BuilderDelegateMenuItemClick(Sender: TObject);
    procedure BuilderListMenuItemClick(Sender: TObject);
    procedure CopyMenuItemClick(Sender: TObject);
    procedure DelCancelButtonClick(Sender: TObject);
    procedure DelegateListMenuItemClick(Sender: TObject);
    procedure DelFromBuilderButtonClick(Sender: TObject);
    procedure DelFromUserButtonClick(Sender: TObject);
    procedure DelMotorButtonClick(Sender: TObject);
    procedure DelNoteButtonClick(Sender: TObject);
    procedure DelReportOrRepDatesOrMoneyDatesButtonClick(Sender: TObject);
    procedure DelToBuilderButtonClick(Sender: TObject);
    procedure DelToUserButtonClick(Sender: TObject);
    procedure EditCancelButtonClick(Sender: TObject);
    procedure EditFromBuilderButtonClick(Sender: TObject);
    procedure EditFromUserButtonClick(Sender: TObject);
    procedure EditMotorButtonClick(Sender: TObject);
    procedure EditNoteButtonClick(Sender: TObject);
    procedure EditReportOrRepDatesOrMoneyDatesButtonClick(Sender: TObject);
    procedure EditToBuilderButtonClick(Sender: TObject);
    procedure EditToUserButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure ExportButtonClick(Sender: TObject);
    procedure ImageListMenuItemClick(Sender: TObject);
    procedure LetterButtonClick(Sender: TObject);
    procedure OpenMenuItemClick(Sender: TObject);
    procedure PerformerListMenuItemClick(Sender: TObject);
    procedure ReceiverListMenuItemClick(Sender: TObject);
    procedure RefreshButtonClick(Sender: TObject);
    procedure SearchNumEditButtonClick(Sender: TObject);
    procedure SearchNumEditChange(Sender: TObject);
    procedure SenderListMenuItemClick(Sender: TObject);
    procedure ShowAllMenuItemClick(Sender: TObject);
    procedure ShowCancelButtonClick(Sender: TObject);
    procedure ShowFromBuilderButtonClick(Sender: TObject);
    procedure ShowFromUserButtonClick(Sender: TObject);
    procedure ShowOneMenuItemClick(Sender: TObject);
    procedure ShowReportButtonClick(Sender: TObject);
    procedure ShowToBuilderButtonClick(Sender: TObject);
    procedure ShowToUserButtonClick(Sender: TObject);
    procedure StatisticButtonClick(Sender: TObject);
    procedure UserListMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MotorListMenuItemClick(Sender: TObject);
    procedure LocationListMenuItemClick(Sender: TObject);
    procedure ReclamationButtonClick(Sender: TObject);
    procedure PretensionButtonClick(Sender: TObject);
    procedure RepairButtonClick(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);
  private
    VSTOrderList: TVSTStringList;
    VSTViewList: TVSTStringList;
    LogTable: TLogTable;
    ZoomPercent: Integer;
    KeepLogID: Integer;
    Category: Byte;
    SelectedLetterType: Byte;
    CanDataLoad: Boolean;

    LogIDs: TIntVector;
    MotorNames: TStrVector;
    MotorNums: TStrVector;
    MotorDates: TDateVector;

    ReclamationUserNames: TStrVector;
    ReclamationUserTitles: TStrVector;
    ReclamationLocationNames: TStrVector;
    ReclamationLocationTitles: TStrVector;
    ReclamationNoticeFromUserDates: TDateVector;
    ReclamationNoticeFromUserNums: TStrVector;
    ReclamationNoticeToBuilderDates: TDateVector;
    ReclamationNoticeToBuilderNums: TStrVector;
    ReclamationAnswerFromBuilderDates: TDateVector;
    ReclamationAnswerFromBuilderNums: TStrVector;
    ReclamationAnswerToUserDates: TDateVector;
    ReclamationAnswerToUserNums: TStrVector;
    ReclamationCancelDates: TDateVector;
    ReclamationCancelNums: TStrVector;
    ReclamationReportDates: TDateVector;
    ReclamationReportNums: TStrVector;
    ReclamationNotes: TStrVector;
    ReclamationStatuses: TIntVector;

    RepairUserNames: TStrVector;
    RepairUserTitles: TStrVector;
    RepairNoticeFromUserDates: TDateVector;
    RepairNoticeFromUserNums: TStrVector;
    RepairNoticeToBuilderDates: TDateVector;
    RepairNoticeToBuilderNums: TStrVector;
    RepairAnswerFromBuilderDates: TDateVector;
    RepairAnswerFromBuilderNums: TStrVector;
    RepairAnswerToUserDates: TDateVector;
    RepairAnswerToUserNums: TStrVector;
    RepairBeginDates: TDateVector;
    RepairEndDates: TDateVector;
    RepairNotes: TStrVector;
    RepairStatuses: TIntVector;

    PretensionUserNames: TStrVector;
    PretensionUserTitles: TStrVector;
    PretensionNoticeFromUserDates: TDateVector;
    PretensionNoticeFromUserNums: TStrVector;
    PretensionMoneyValues: TInt64Vector;
    PretensionNoticeToBuilderDates: TDateVector;
    PretensionNoticeToBuilderNums: TStrVector;
    PretensionAnswerFromBuilderDates: TDateVector;
    PretensionAnswerFromBuilderNums: TStrVector;
    PretensionAnswerToUserDates: TDateVector;
    PretensionAnswerToUserNums: TStrVector;
    PretensionMoneySendDates: TDateVector;
    PretensionMoneySendValues: TInt64Vector;
    PretensionMoneyGetDates: TDateVector;
    PretensionMoneyGetValues: TInt64Vector;
    PretensionNotes: TStrVector;
    PretensionStatuses: TIntVector;

    MotorDateStrs: TStrVector;
    ReclamationUserStrs: TStrVector;
    ReclamationLocationStrs: TStrVector;
    ReclamationNoticeFromUserStrs: TStrVector;
    ReclamationNoticeToBuilderStrs: TStrVector;
    ReclamationAnswerFromBuilderStrs: TStrVector;
    ReclamationAnswerToUserStrs: TStrVector;
    ReclamationCancelStrs: TStrVector;
    ReclamationStatusStrs: TStrVector;
    ReclamationReportStrs: TStrVector;

    RepairUserStrs: TStrVector;
    RepairNoticeFromUserStrs: TStrVector;
    RepairNoticeToBuilderStrs: TStrVector;
    RepairAnswerFromBuilderStrs: TStrVector;
    RepairAnswerToUserStrs: TStrVector;
    RepairBeginDatesStrs: TStrVector;
    RepairEndDatesStrs: TStrVector;
    RepairStatusStrs: TStrVector;

    PretensionUserStrs: TStrVector;
    PretensionNoticeFromUserStrs: TStrVector;
    PretensionMoneyValueStrs: TStrVector;
    PretensionNoticeToBuilderStrs: TStrVector;
    PretensionAnswerFromBuilderStrs: TStrVector;
    PretensionAnswerToUserStrs: TStrVector;
    PretensionMoneySendDatesStrs: TStrVector;
    PretensionMoneySendValuesStrs: TStrVector;
    PretensionMoneyGetDatesStrs: TStrVector;
    PretensionMoneyGetValuesStrs: TStrVector;
    PretensionStatusStrs: TStrVector;

    procedure MotorListEdit;
    procedure LocationListEdit;
    procedure UserListEdit;
    procedure BuilderListEdit;
    procedure SenderListEdit;
    procedure ReceiverListEdit;
    procedure PerformerListEdit;
    procedure DelegateListEdit;
    procedure DelegateBuilderListEdit;
    procedure ImageListEdit;

    procedure ConnectDB;

    procedure CategorySelect(const ACategory: Byte);

    procedure ButtonsEnable;

    procedure KeepLogIDStore;
    procedure KeepLogIDRestore;

    procedure DataLoad;
    procedure DataSelect;
    procedure DataDraw(const AZoomPercent: Integer);
    procedure DataExport(const AShowAllCategories: Boolean);

    procedure PDFOpen(const ALetterType: Byte);
    procedure PDFCopy(const ALetterType: Byte);

    procedure SelectedLetterProperties(const ALetterType: Byte;
                                       out ALetterDate: TDate;
                                       out ALetterNum: String);
    procedure SelectedMotorProperties(out AMotorName, AMotorNum: String;
                                      out AMotorDate: TDate);

    procedure MotorEdit(const AEditMode: Byte); //1 - new, 2  edit
    procedure NoticeEdit;
    procedure NoticeDelete;

    procedure LetterEdit(const ALetterType: Byte);
    procedure LetterDelete(const ALetterType: Byte);
    procedure LetterFileDelete(const ALetterType: Byte);
    procedure LetterCreate;

    procedure ReportDelete;
    procedure CancelDelete;

    procedure RepairDatesEdit;
    procedure RepairDatesDelete;

    procedure MoneyDatesEdit;
    procedure MoneyDatesDelete;

    procedure NoteEdit;
    procedure NoteDelete;

    procedure OrderListCreate;
    procedure OrderItemSelect;

    procedure ViewListCreate;
    procedure ViewItemSelect;
  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  CanDataLoad:= False;
  HeapTraceOutputFile('trace.trc');

  //for normal form maximizing
  Height:= 300;
  Width:= 500;

  DT1.Date:= FirstDayInYear(Date);
  DT2.Date:= Date;

  SQLite:= TSQLite.Create;
  SQLite.SetColors(DefaultSelectionBGColor, clWindowText);
  SQLite.SetNavigatorGlyphs(ImagesEdit24x24);
  ConnectDB;

  KeepLogID:= -1;

  LogTable:= TLogTable.Create(LogGrid, @DataSelect);
  LogTable.IsEmptyDraw:= True;
  LogTable.Draw;

  ZoomPercent:= 100;
  CreateZoomControls(50, 150, ZoomPercent, ZoomPanel, @DataDraw, True);

  OrderListCreate;
  ViewListCreate;
  CategorySelect(1);
  CanDataLoad:= True;
  DataLoad;

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(LogTable);
  FreeAndNil(SQLite);
  FreeAndNil(VSTOrderList);
  FreeAndNil(VSTViewList);
end;

procedure TMainForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.ExportButtonClick(Sender: TObject);
begin
  ControlPopupMenuShow(Sender, PopupMenu3);
end;

procedure TMainForm.MotorListMenuItemClick(Sender: TObject);
begin
  MotorListEdit;
end;

procedure TMainForm.LocationListMenuItemClick(Sender: TObject);
begin
  LocationListEdit;
end;

procedure TMainForm.ImageListMenuItemClick(Sender: TObject);
begin
  ImageListEdit;
end;

procedure TMainForm.LetterButtonClick(Sender: TObject);
begin
  LetterCreate;
end;

procedure TMainForm.OpenMenuItemClick(Sender: TObject);
begin
  PDFOpen(SelectedLetterType);
end;

procedure TMainForm.PerformerListMenuItemClick(Sender: TObject);
begin
  PerformerListEdit;
end;

procedure TMainForm.ReceiverListMenuItemClick(Sender: TObject);
begin
  ReceiverListEdit;
end;

procedure TMainForm.RefreshButtonClick(Sender: TObject);
begin
  SQLite.Reconnect;
  DataLoad;
end;

procedure TMainForm.SearchNumEditButtonClick(Sender: TObject);
begin
  SearchNumEdit.Text:= EmptyStr;
end;

procedure TMainForm.SearchNumEditChange(Sender: TObject);
begin
  DataLoad;
end;

procedure TMainForm.SenderListMenuItemClick(Sender: TObject);
begin
  SenderListEdit;
end;



procedure TMainForm.ShowCancelButtonClick(Sender: TObject);
begin
  SelectedLetterType:= 5;
  ControlPopupMenuShow(Sender, PopupMenu2);
end;

procedure TMainForm.ShowFromBuilderButtonClick(Sender: TObject);
begin
  case Category of
  1: SelectedLetterType:= 2;
  2: SelectedLetterType:= 8;
  3: SelectedLetterType:= 12;
  end;
  ControlPopupMenuShow(Sender, PopupMenu2);
end;

procedure TMainForm.ShowFromUserButtonClick(Sender: TObject);
begin
  case Category of
  1: SelectedLetterType:= 0;
  2: SelectedLetterType:= 6;
  3: SelectedLetterType:=10;
  end;
  ControlPopupMenuShow(Sender, PopupMenu2);
end;

procedure TMainForm.ShowOneMenuItemClick(Sender: TObject);
begin
  DataExport(False);
end;

procedure TMainForm.ShowAllMenuItemClick(Sender: TObject);
begin
  DataExport(True);
end;

procedure TMainForm.ShowReportButtonClick(Sender: TObject);
begin
  SelectedLetterType:= 4;
  ControlPopupMenuShow(Sender, PopupMenu2);
end;

procedure TMainForm.ShowToBuilderButtonClick(Sender: TObject);
begin
  case Category of
  1: SelectedLetterType:= 1;
  2: SelectedLetterType:= 7;
  3: SelectedLetterType:= 11;
  end;
  ControlPopupMenuShow(Sender, PopupMenu2);
end;

procedure TMainForm.ShowToUserButtonClick(Sender: TObject);
begin
  case Category of
  1: SelectedLetterType:= 3;
  2: SelectedLetterType:= 9;
  3: SelectedLetterType:= 13;
  end;
  ControlPopupMenuShow(Sender, PopupMenu2);
end;

procedure TMainForm.StatisticButtonClick(Sender: TObject);
var
  StatisticForm: TStatisticForm;
begin
  StatisticForm:= TStatisticForm.Create(MainForm);
  try
    StatisticForm.ShowModal;
  finally
    FreeAndNil(StatisticForm);
  end;
end;

procedure TMainForm.UserListMenuItemClick(Sender: TObject);
begin
  UserListEdit;
end;

procedure TMainForm.BuilderDelegateMenuItemClick(Sender: TObject);
begin
  DelegateBuilderListEdit;
end;

procedure TMainForm.BuilderListMenuItemClick(Sender: TObject);
begin
  BuilderListEdit;
end;

procedure TMainForm.CopyMenuItemClick(Sender: TObject);
begin
  PDFCopy(SelectedLetterType);
end;

procedure TMainForm.DelCancelButtonClick(Sender: TObject);
begin
 CancelDelete;
end;

procedure TMainForm.DelegateListMenuItemClick(Sender: TObject);
begin
  DelegateListEdit;
end;

procedure TMainForm.DelFromBuilderButtonClick(Sender: TObject);
var
  LetterType: Byte;
begin
  case Category of
  1: LetterType:= 2;
  2: LetterType:= 8;
  3: LetterType:= 12;
  end;
  LetterDelete(LetterType);
end;

procedure TMainForm.DelFromUserButtonClick(Sender: TObject);
begin
  NoticeDelete;
end;

procedure TMainForm.DelMotorButtonClick(Sender: TObject);
var
  MotorName: String;
  MotorNum: String;
  MotorDate: TDate;
begin
  SelectedMotorProperties(MotorName, MotorNum, MotorDate);
  if not Confirm('Внимание!' + SYMBOL_BREAK +
                 'Все данные о переписке по двигателю ' +
                 MotorFullName(MotorName, MotorNum, MotorDate) +
                 ' будут удалены без возможности восстановления!' + SYMBOL_BREAK +
                 'Удалить запись?') then Exit;
  SQLite.MotorDelete(LogIDs[LogTable.SelectedIndex]);
  MotorNumDirectoryDelete(MotorName, MotorNum, MotorDate);
  DataLoad;
end;

procedure TMainForm.EditFromUserButtonClick(Sender: TObject);
begin
  NoticeEdit;
end;

procedure TMainForm.AddMotorButtonClick(Sender: TObject);
begin
  MotorEdit(1);
end;

procedure TMainForm.AboutButtonClick(Sender: TObject);
var
  AboutForm: TAboutForm;
begin
  AboutForm:= TAboutForm.Create(MainForm);
  try
    AboutForm.ShowModal;
  finally
    FreeAndNil(AboutForm);
  end;
end;

procedure TMainForm.EditMotorButtonClick(Sender: TObject);
var
  OldMotorName, NewMotorName: String;
  OldMotorNum, NewMotorNum: String;
  OldMotorDate, NewMotorDate: TDate;
begin
  //запоминаем старые данные по двигателю
  SelectedMotorProperties(OldMotorName, OldMotorNum, OldMotorDate);
  //редактируем
  MotorEdit(2);
  //получаем новые данные по двигателю
  SelectedMotorProperties(NewMotorName, NewMotorNum, NewMotorDate);
  //переименовываем папку для этого двигателя
  MotorNumDirectoryCheck(OldMotorName, NewMotorName, OldMotorNum, NewMotorNum,
                         OldMotorDate, NewMotorDate);
end;

procedure TMainForm.EditNoteButtonClick(Sender: TObject);
begin
  NoteEdit;
end;

procedure TMainForm.EditReportOrRepDatesOrMoneyDatesButtonClick(Sender: TObject);
begin
  case Category of
  1: LetterEdit(4 {акт осмотра});
  2: RepairDatesEdit;
  3: MoneyDatesEdit;
  end;
end;

procedure TMainForm.EditToBuilderButtonClick(Sender: TObject);
var
  LetterType: Byte;
begin
  case Category of
  1: LetterType:= 1;
  2: LetterType:= 7;
  3: LetterType:= 11;
  end;
  LetterEdit(LetterType);
end;

procedure TMainForm.EditToUserButtonClick(Sender: TObject);
var
  LetterType: Byte;
begin
  case Category of
  1: LetterType:= 3;
  2: LetterType:= 9;
  3: LetterType:= 13;
  end;
  LetterEdit(LetterType);
end;

procedure TMainForm.DelNoteButtonClick(Sender: TObject);
begin
  NoteDelete;
end;

procedure TMainForm.DelReportOrRepDatesOrMoneyDatesButtonClick(Sender: TObject);
begin
  case Category of
  1: ReportDelete;
  2: RepairDatesDelete;
  3: MoneyDatesDelete;
  end;
end;

procedure TMainForm.DelToBuilderButtonClick(Sender: TObject);
var
  LetterType: Byte;
begin
  case Category of
  1: LetterType:= 1;
  2: LetterType:= 7;
  3: LetterType:= 11;
  end;
  LetterDelete(LetterType);
end;

procedure TMainForm.DelToUserButtonClick(Sender: TObject);
var
  LetterType: Byte;
begin
  case Category of
  1: LetterType:= 3;
  2: LetterType:= 9;
  3: LetterType:= 13;
  end;
  LetterDelete(LetterType);
end;

procedure TMainForm.EditCancelButtonClick(Sender: TObject);
begin
  LetterEdit(5) {отзыв рекл.};
end;

procedure TMainForm.EditFromBuilderButtonClick(Sender: TObject);
var
  LetterType: Byte;
begin
  case Category of
  1: LetterType:= 2;
  2: LetterType:= 8;
  3: LetterType:= 12;
  end;
  LetterEdit(LetterType);
end;

procedure TMainForm.SettingsButtonClick(Sender: TObject);
begin
  ControlPopupMenuShow(Sender, PopupMenu1);
end;

procedure TMainForm.MotorListEdit;
var
  OldMotorNameIDs, NewMotorNameIDs: TIntVector;
  OldMotorNames, NewMotorNames: TStrVector;
begin
  //запоминаем старый список наименований двигателей
  SQLite.MotorIDsAndNamesLoad(OldMotorNameIDs, OldMotorNames);
  //редактируем
  if SQLite.EditList('Наименования электродвигателей',
    'MOTORNAMES', 'MotorNameID', 'MotorName', False, True) then
  begin
    //получаем новый список наименований двигателей
    SQLite.MotorIDsAndNamesLoad(NewMotorNameIDs, NewMotorNames);
    //переименовываем папки с наименованиями двигателей файлового хранилища
    MotorNameDirectoryCheck(OldMotorNameIDs, NewMotorNameIDs, OldMotorNames, NewMotorNames);
    //обновляем основной список
    DataLoad;
  end;
end;

procedure TMainForm.LocationListEdit;
begin
  if SQLite.EditTable('Список предприятий', 'LOCATIONS', 'LocationID',
    ['LocationName', 'LocationTitle'],
    ['Полное наименование', 'Краткое наименование'],
    [550, 250], True, ['LocationName']) then
      DataLoad;
end;

procedure TMainForm.UserListEdit;
begin
  if SQLite.EditTable('Список потребителей', 'USERS', 'UserID',
    ['UserNameI', 'UserNameR', 'UserTitle'],
    ['Полное наименование (в именительном падеже)', 'Полное наименование (в родительном падеже)', 'Краткое наименование'],
    [400, 400, 200], True, nil) then
      DataLoad;
end;

procedure TMainForm.BuilderListEdit;
begin
  SQLite.EditTable('Список производителей', 'BUILDERS', 'BuilderID',
    ['BuilderName', 'BuilderTitle'],
    ['Полное наименование', 'Краткое наименование'],
    [400, 200], True, nil);
end;

procedure TMainForm.SenderListEdit;
var
  SenderEditForm: TSenderEditForm;
begin
  SenderEditForm:= TSenderEditForm.Create(MainForm);
  try
    SenderEditForm.ShowModal;
  finally
    FreeAndNil(SenderEditForm);
  end;
end;

procedure TMainForm.ReceiverListEdit;
var
  ReceiverEditForm: TReceiverEditForm;
begin
  ReceiverEditForm:= TReceiverEditForm.Create(MainForm);
  try
    ReceiverEditForm.ShowModal;
  finally
    FreeAndNil(ReceiverEditForm);
  end;
end;

procedure TMainForm.PerformerListEdit;
begin
  SQLite.EditTable('Список исполнителей', 'EJDMPERFORMERS', 'PerformerID',
    ['PerformerName', 'PerformerPhone', 'PerformerMail'],
    ['Ф.И.О.', 'Телефон', 'Почта'],
    [300, 200, 200], True, ['PerformerName']);
end;

procedure TMainForm.DelegateListEdit;
begin
  SQLite.EditTable('Список представителей', 'EJDMDELEGATES', 'DelegateID',
    ['DelegateNameI', 'DelegatePhone', 'DelegateNameR', 'DelegatePassport'],
    ['Ф.И.О. (в именительном падеже)', 'Номер телефона', 'Ф.И.О. (в родительном падеже)', 'Паспортные данные'],
    [270, 150, 270, 170], True, nil);
end;

procedure TMainForm.DelegateBuilderListEdit;
begin
  SQLite.EditTable('Список представителей', 'BUILDERDELEGATES', 'DelegateID',
    ['DelegateNameI', 'DelegatePhone', 'DelegateNameR', 'DelegatePassport'],
    ['Ф.И.О. (в именительном падеже)', 'Номер телефона', 'Ф.И.О. (в родительном падеже)', 'Паспортные данные'],
    [270, 150, 270, 170], True, nil);
end;

procedure TMainForm.ImageListEdit;
var
  ImageEditForm: TImageEditForm;
begin
  ImageEditForm:= TImageEditForm.Create(MainForm);
  try
    ImageEditForm.ShowModal;
  finally
    FreeAndNil(ImageEditForm);
  end;
end;

procedure TMainForm.ConnectDB;
var
  DBPath, DBName, DDLName: String;
begin
  ApplicationDirectoryName:= ExtractFilePath(Application.ExeName);
  DBPath:= ApplicationDirectoryName + DirectorySeparator + 'db' + DirectorySeparator;
  DBName:= DBPath + 'base.db';
  DDLName:= DBPath + 'ddl.sql';
  SQLite.Connect(DBName);
  SQLite.ExecuteScript(DDLName);
  DDLName:= DBPath + 'exists.sql';
  SQLite.ExecuteScript(DDLName);
end;

procedure TMainForm.ReclamationButtonClick(Sender: TObject);
begin
  CategorySelect(1);
end;

procedure TMainForm.RepairButtonClick(Sender: TObject);
begin
  CategorySelect(2);
end;

procedure TMainForm.PretensionButtonClick(Sender: TObject);
begin
  CategorySelect(3);
end;

procedure TMainForm.CategorySelect(const ACategory: Byte);

  procedure ReclamationVisible(const AVisible: Boolean);
    var
      i: Integer;
    begin
      ReclamationButton.Down:= AVisible;
      ShowReportButton.Visible:= AVisible;
      ShowCancelButton.Visible:= AVisible;
      EditCancelPanel.Visible:= AVisible;
      for i:= 5 to 14 do
        LogTable.ColumnVisible[i]:= AVisible;
      if not AVisible then Exit;
      Label1.Caption:= 'Уведомление о неисправности';
      Label2.Caption:= 'от Потребителя';
      Label3.Caption:= 'Уведомление о неисправности';
      Label4.Caption:= 'Производителю';
      Label5.Caption:= 'Решение Производителя';
      Label6.Caption:= 'о выезде представителя';
      Label7.Caption:= 'Ответ Потребителю';
      Label8.Caption:= 'о выезде представителя';
      Label9.Caption:= 'Акт осмотра';
      Label10.Caption:= 'электродвигателя';
      Label11.Caption:= 'Отзыв рекламации';
      Label12.Caption:= 'Потребителем';
      Label13.Caption:= 'Примечание';
      Label14.Caption:= 'по ходу расследования';
    end;

    procedure RepairVisible(const AVisible: Boolean);
    var
      i: Integer;
    begin
      RepairButton.Down:= AVisible;
      for i:= 15 to 23 do
        LogTable.ColumnVisible[i]:= AVisible;

      if not AVisible then Exit;
      Label1.Caption:= 'Запрос о ремонте';
      Label2.Caption:= 'от Потребителя';
      Label3.Caption:= 'Запрос о ремонте';
      Label4.Caption:= 'Производителю';
      Label5.Caption:= 'Ответ на запрос';
      Label6.Caption:= 'от Производителя';
      Label7.Caption:= 'Ответ на запрос';
      Label8.Caption:= 'Потребителю';
      Label9.Caption:= 'Гарантийный ремонт';
      Label10.Caption:= 'электродвигателя';
      Label13.Caption:= 'Примечание';
      Label14.Caption:= 'по ходу ремонта';
    end;

    procedure PretensionVisible(const AVisible: Boolean);
    var
      i: Integer;
    begin
      PretensionButton.Down:= AVisible;
      for i:= 24 to 35 do
        LogTable.ColumnVisible[i]:= AVisible;

      if not AVisible then Exit;
      Label1.Caption:= 'Претензия на возмещение';
      Label2.Caption:= 'затрат от Потребителя';
      Label3.Caption:= 'Уведомление о претензии';
      Label4.Caption:= 'Производителю';
      Label5.Caption:= 'Ответ на претензию';
      Label6.Caption:= 'от Производителя';
      Label7.Caption:= 'Ответ на претензию';
      Label8.Caption:= 'Потребителю';
      Label9.Caption:= 'Возмещение затрат';
      Label10.Caption:= 'по претензии';
      Label13.Caption:= 'Примечание';
      Label14.Caption:= 'по возмещению затрат';
    end;
  begin
    if ACategory=Category then Exit;
    Category:= ACategory;
    //0 - показать все категории
    ReclamationVisible((ACategory=1) or (ACategory=0));  //рекламации
    RepairVisible((ACategory=2) or (ACategory=0));       //гарантийный ремонт
    PretensionVisible((ACategory=3) or (ACategory=0));   //гарантийный ремонт

    ButtonsEnable;
end;

procedure TMainForm.DataLoad;
var
  MotorNumLike: String;
begin
  if not CanDataLoad then Exit;

  MotorNumLike:= STrim(SearchNumEdit.Text);
  SQLite.DataLoad(MotorNumLike,
              VSTOrderList.SelectedIndex, VSTViewList.SelectedIndex,
              DT1.Date, DT2.Date,
              LogIDs, MotorNames, MotorNums, MotorDates,
              ReclamationUserNames, ReclamationUserTitles,
              ReclamationLocationNames, ReclamationLocationTitles,
              ReclamationNoticeFromUserDates, ReclamationNoticeFromUserNums,
              ReclamationNoticeToBuilderDates, ReclamationNoticeToBuilderNums,
              ReclamationAnswerFromBuilderDates, ReclamationAnswerFromBuilderNums,
              ReclamationAnswerToUserDates, ReclamationAnswerToUserNums,
              ReclamationCancelDates, ReclamationCancelNums,
              ReclamationReportDates, ReclamationReportNums,
              ReclamationNotes, ReclamationStatuses,
              RepairUserNames, RepairUserTitles,
              RepairNoticeFromUserDates, RepairNoticeFromUserNums,
              RepairNoticeToBuilderDates, RepairNoticeToBuilderNums,
              RepairAnswerFromBuilderDates, RepairAnswerFromBuilderNums,
              RepairAnswerToUserDates, RepairAnswerToUserNums,
              RepairBeginDates, RepairEndDates,
              RepairNotes, RepairStatuses,
              PretensionUserNames, PretensionUserTitles,
              PretensionNoticeFromUserDates, PretensionNoticeFromUserNums,
              PretensionMoneyValues,
              PretensionNoticeToBuilderDates, PretensionNoticeToBuilderNums,
              PretensionAnswerFromBuilderDates, PretensionAnswerFromBuilderNums,
              PretensionAnswerToUserDates, PretensionAnswerToUserNums,
              PretensionMoneySendDates, PretensionMoneySendValues,
              PretensionMoneyGetDates, PretensionMoneyGetValues,
              PretensionNotes, PretensionStatuses);

  MotorDateStrs:= MotorDatesToStr(MotorDates);
  ReclamationUserStrs:= VCut(ReclamationUserTitles); //VCut(ReclamationUserNames);
  VChangeIf(ReclamationUserStrs, '<?>', EmptyStr);
  ReclamationLocationStrs:= VCut(ReclamationLocationTitles); //VCut(ReclamationLocationNames);
  VChangeIf(ReclamationLocationStrs, '<?>', EmptyStr);
  ReclamationNoticeFromUserStrs:= LetterFullNames(ReclamationNoticeFromUserDates, ReclamationNoticeFromUserNums);
  ReclamationNoticeToBuilderStrs:= LetterFullNames(ReclamationNoticeToBuilderDates, ReclamationNoticeToBuilderNums);
  ReclamationAnswerFromBuilderStrs:= LetterFullNames(ReclamationAnswerFromBuilderDates, ReclamationAnswerFromBuilderNums);
  ReclamationAnswerToUserStrs:= LetterFullNames(ReclamationAnswerToUserDates, ReclamationAnswerToUserNums);
  ReclamationCancelStrs:= LetterFullNames(ReclamationCancelDates, ReclamationCancelNums);
  VChangeIf(ReclamationCancelStrs, EmptyStr, '—');
  ReclamationReportStrs:= LetterFullNames(ReclamationReportDates, ReclamationReportNums);
  ReclamationStatusStrs:= ReclamationStatusIntToStr(ReclamationStatuses);

  RepairUserStrs:= VCut(RepairUserTitles); // VCut(RepairUserNames);
  VChangeIf(RepairUserStrs, '<?>', EmptyStr);
  RepairNoticeFromUserStrs:= LetterFullNames(RepairNoticeFromUserDates, RepairNoticeFromUserNums);
  RepairNoticeToBuilderStrs:= LetterFullNames(RepairNoticeToBuilderDates, RepairNoticeToBuilderNums);
  RepairAnswerFromBuilderStrs:= LetterFullNames(RepairAnswerFromBuilderDates, RepairAnswerFromBuilderNums);
  RepairAnswerToUserStrs:= LetterFullNames(RepairAnswerToUserDates, RepairAnswerToUserNums);
  RepairBeginDatesStrs:= VFormatDateTime('dd.mm.yyyy', RepairBeginDates, True);
  VChangeIf(RepairBeginDatesStrs, LETTER_NOTNEED_MARK, RepairStatuses, 3{отказано});
  RepairEndDatesStrs:= VFormatDateTime('dd.mm.yyyy', RepairEndDates, True);
  VChangeIf(RepairEndDatesStrs, LETTER_NOTNEED_MARK, RepairStatuses, 3{отказано});
  RepairStatusStrs:= RepairStatusIntToStr(RepairStatuses);

  PretensionUserStrs:= VCut(PretensionUserTitles); // VCut(PretensionUserNames);
  VChangeIf(PretensionUserStrs, '<?>', EmptyStr);
  PretensionNoticeFromUserStrs:= LetterFullNames(PretensionNoticeFromUserDates, PretensionNoticeFromUserNums);
  PretensionMoneyValueStrs:= VPriceIntToStr(PretensionMoneyValues, True, True);
  PretensionNoticeToBuilderStrs:= LetterFullNames(PretensionNoticeToBuilderDates, PretensionNoticeToBuilderNums);
  PretensionAnswerFromBuilderStrs:= LetterFullNames(PretensionAnswerFromBuilderDates, PretensionAnswerFromBuilderNums);
  PretensionAnswerToUserStrs:= LetterFullNames(PretensionAnswerToUserDates, PretensionAnswerToUserNums);
  PretensionMoneySendDatesStrs:= VFormatDateTime('dd.mm.yyyy', PretensionMoneySendDates, True);
  VChangeIf(PretensionMoneySendDatesStrs, LETTER_NOTNEED_MARK, PretensionStatuses, 3{отказано});
  PretensionMoneySendValuesStrs:= VPriceIntToStr(PretensionMoneySendValues, True, True);
  VChangeIf(PretensionMoneySendValuesStrs, LETTER_NOTNEED_MARK, PretensionStatuses, 3{отказано});
  PretensionMoneyGetDatesStrs:= VFormatDateTime('dd.mm.yyyy', PretensionMoneyGetDates, True);
  VChangeIf(PretensionMoneyGetDatesStrs, LETTER_NOTNEED_MARK, PretensionStatuses, 3{отказано});
  PretensionMoneyGetValuesStrs:= VPriceIntToStr(PretensionMoneyGetValues, True, True);
  VChangeIf(PretensionMoneyGetValuesStrs, LETTER_NOTNEED_MARK, PretensionStatuses, 3{отказано});
  PretensionStatusStrs:= PretensionStatusIntToStr(PretensionStatuses);

  KeepLogIDStore;
  LogTable.Update(MotorNames, MotorNums, MotorDateStrs,
                  ReclamationLocationStrs, ReclamationUserStrs,
                  ReclamationNoticeFromUserStrs,
                  ReclamationNoticeToBuilderStrs,
                  ReclamationAnswerFromBuilderStrs,
                  ReclamationAnswerToUserStrs,
                  ReclamationCancelStrs,
                  ReclamationReportStrs,
                  ReclamationNotes, ReclamationStatusStrs,
                  RepairUserStrs,
                  RepairNoticeFromUserStrs,
                  RepairNoticeToBuilderStrs,
                  RepairAnswerFromBuilderStrs,
                  RepairAnswerToUserStrs,
                  RepairBeginDatesStrs, RepairEndDatesStrs,
                  RepairNotes, RepairStatusStrs,
                  PretensionUserStrs,
                  PretensionNoticeFromUserStrs, PretensionMoneyValueStrs,
                  PretensionNoticeToBuilderStrs,
                  PretensionAnswerFromBuilderStrs,
                  PretensionAnswerToUserStrs,
                  PretensionMoneySendDatesStrs, PretensionMoneySendValuesStrs,
                  PretensionMoneyGetDatesStrs, PretensionMoneyGetValuesStrs,
                  PretensionNotes, PretensionStatusStrs);
  KeepLogIDRestore;

  ButtonsEnable;
end;

procedure TMainForm.DataSelect;
begin
  ButtonsEnable;
end;

procedure TMainForm.ButtonsEnable;
var
  IsPrevDocExists, IsNoticeExists, bb: Boolean;
  MotorDate: TDate;
  MotorName, MotorNum: String;

  procedure SetEnbld(const ALetterType: Byte;
                     var AIsPrevDocExists: Boolean;
                     const AEditButton, ADeleteButton, AShowButton: TSpeedButton);
  var
    LetterDate: TDate;
    LetterNum: String;
    b: Boolean;
  begin
    AEditButton.Enabled:= AIsPrevDocExists;
    SelectedLetterProperties(ALetterType, LetterDate, LetterNum);
    if Assigned(AShowButton) then
    begin
      b:= IsDocumentFileExists(ALetterType, LetterDate, LetterNum,  MotorDate, MotorName, MotorNum);
      AShowButton.Enabled:= b;
    end;
    b:= not IsDocumentEmpty(LetterDate, LetterNum);
    ADeleteButton.Enabled:= b;
    AIsPrevDocExists:= b;
  end;

  procedure SetNoteButtonsEnbld;
  var
    b: Boolean;
  begin
    b:= (not VIsNil(LogIDs)) and LogTable.IsSelected;
    EditNoteButton.Enabled:= b;
    case Category of
    1: b:= b and (not SEmpty(ReclamationNotes[LogTable.SelectedIndex]));
    2: b:= b and (not SEmpty(RepairNotes[LogTable.SelectedIndex]));
    3: b:= b and (not SEmpty(PretensionNotes[LogTable.SelectedIndex]));
    end;
    DelNoteButton.Enabled:= b;
  end;

begin
  DelMotorButton.Enabled:= (not VIsNil(LogIDs)) and LogTable.IsSelected;
  EditMotorButton.Enabled:= DelMotorButton.Enabled;

  SelectedMotorProperties(MotorName, MotorNum, MotorDate);

  IsPrevDocExists:= (not VIsNil(LogIDs)) and LogTable.IsSelected;

  if Category = 1 then
  begin
    SetEnbld(0, IsPrevDocExists, EditFromUserButton, DelFromUserButton, ShowFromUserButton);
    IsNoticeExists:= IsPrevDocExists;
    SetEnbld(1, IsPrevDocExists, EditToBuilderButton, DelToBuilderButton, ShowToBuilderButton);
    SetEnbld(2, IsPrevDocExists, EditFromBuilderButton, DelFromBuilderButton, ShowFromBuilderButton);
    SetEnbld(3, IsPrevDocExists, EditToUserButton, DelToUserButton, ShowToUserButton);
    SetEnbld(4, IsPrevDocExists, EditReportOrRepDatesOrMoneyDatesButton, DelReportOrRepDatesOrMoneyDatesButton, ShowReportButton);
    IsPrevDocExists:= IsNoticeExists;
    SetEnbld(5, IsPrevDocExists, EditCancelButton, DelCancelButton, ShowCancelButton);
  end
  else if Category = 2 then
  begin
    SetEnbld(6, IsPrevDocExists, EditFromUserButton, DelFromUserButton, ShowFromUserButton);
    IsNoticeExists:= IsPrevDocExists;
    SetEnbld(7, IsPrevDocExists, EditToBuilderButton, DelToBuilderButton, ShowToBuilderButton);
    SetEnbld(8, IsPrevDocExists, EditFromBuilderButton, DelFromBuilderButton, ShowFromBuilderButton);
    SetEnbld(9, IsPrevDocExists, EditToUserButton, DelToUserButton, ShowToUserButton);
    bb:= IsPrevDocExists;
    EditReportOrRepDatesOrMoneyDatesButton.Enabled:= bb;
    bb:= bb and (not VIsNil(RepairBeginDates)) and (not VIsNil(RepairEndDates));
    bb:= bb and ((RepairBeginDates[LogTable.SelectedIndex]>0) or
                 (RepairEndDates[LogTable.SelectedIndex]>0));
    DelReportOrRepDatesOrMoneyDatesButton.Enabled:= bb;
  end
  else if Category = 3 then
  begin
    SetEnbld(10, IsPrevDocExists, EditFromUserButton, DelFromUserButton, ShowFromUserButton);
    IsNoticeExists:= IsPrevDocExists;
    SetEnbld(11, IsPrevDocExists, EditToBuilderButton, DelToBuilderButton, ShowToBuilderButton);
    SetEnbld(12, IsPrevDocExists, EditFromBuilderButton, DelFromBuilderButton, ShowFromBuilderButton);
    SetEnbld(13, IsPrevDocExists, EditToUserButton, DelToUserButton, ShowToUserButton);

    bb:= IsPrevDocExists;
    EditReportOrRepDatesOrMoneyDatesButton.Enabled:= bb;
    bb:= LogTable.IsSelected;
    bb:= bb and
         ((not VIsNil(PretensionMoneySendDates)) and
          (PretensionMoneySendDates[LogTable.SelectedIndex]>0)) or
         ((not VIsNil(PretensionMoneyGetDates)) and
          (PretensionMoneyGetDates[LogTable.SelectedIndex]>0));
    DelReportOrRepDatesOrMoneyDatesButton.Enabled:= bb;
  end;

  SetNoteButtonsEnbld;
end;

procedure TMainForm.KeepLogIDStore;
begin
  if KeepLogID>0 then Exit; //уже сохранен
  KeepLogID:= -1;
  if VIsNil(LogIDs) or (not LogTable.IsSelected) then Exit;
  KeepLogID:= LogIDs[LogTable.SelectedIndex];
end;

procedure TMainForm.KeepLogIDRestore;
var
  Ind: Integer;
begin
  if KeepLogID<0 then Exit;
  Ind:= VIndexOf(LogIDs, KeepLogID);
  if Ind<0 then Exit;
  LogTable.SelectIndex(Ind);
  KeepLogID:= -1;
end;

procedure TMainForm.DataDraw(const AZoomPercent: Integer);
var
  SelectedIndex: Integer;
begin
  ZoomPercent:= AZoomPercent;
  LogTable.Zoom(ZoomPercent);
  SelectedIndex:= -1;
  if (not VIsNil(LogIDs)) and LogTable.IsSelected then
    SelectedIndex:= LogTable.SelectedIndex;
  LogTable.Draw;
  if SelectedIndex>=0 then
    LogTable.SelectIndex(SelectedIndex);
end;

procedure TMainForm.DataExport(const AShowAllCategories: Boolean);
var
  OldCategory: Byte;
begin
  if AShowAllCategories then
  begin
    LogGrid.Visible:= False;
    try
      OldCategory:= Category;
      CategorySelect(0);
      LogTable.Save('Выполнено!');
      CategorySelect(OldCategory);
    finally
      LogGrid.Visible:= True;
    end;
  end
  else
    LogTable.Save('Выполнено!');
end;

procedure TMainForm.PDFOpen(const ALetterType: Byte);
var
  FileName: String;
  LetterDate, MotorDate: TDate;
  LetterNum, MotorName, MotorNum: String;
begin
  SelectedLetterProperties(ALetterType, LetterDate, LetterNum);
  SelectedMotorProperties(MotorName, MotorNum, MotorDate);
  FileName:= FileNameFullGet(ALetterType, LetterDate, LetterNum,
                             MotorDate, MotorName, MotorNum);
  OpenDocument(FileName);
end;

procedure TMainForm.PDFCopy(const ALetterType: Byte);
var
  DestFileName, SrcFileName: string;
  LetterNum: String;
  MotorName, MotorNum: String;
  MotorDate, LetterDate: TDate;
begin
  SelectedLetterProperties(ALetterType, LetterDate, LetterNum);
  SelectedMotorProperties(MotorName, MotorNum, MotorDate);

  SrcFileName:= FileNameFullGet(ALetterType, LetterDate, LetterNum,
                                MotorDate, MotorName, MotorNum);

  DestFileName:= FileNameGet(ALetterType, LetterDate, LetterNum,
                             MotorDate, MotorName, MotorNum);
  SaveDialog1.FileName:= DestFileName;
  if not SaveDialog1.Execute then Exit;
  DestFileName:= SaveDialog1.FileName;

  CopyFile(SrcFileName, DestFileName, [cffOverwriteFile]);
end;

procedure TMainForm.SelectedMotorProperties(out AMotorName, AMotorNum: String;
                                            out AMotorDate: TDate);
var
  n: Integer;
begin
  AMotorName:= EmptyStr;
  AMotorNum:= EmptyStr;
  AMotorDate:= 0;
  if VIsNil(LogIDs) then Exit;
  if not LogTable.IsSelected then Exit;
  n:= LogTable.SelectedIndex;
  AMotorName:= MotorNames[n];
  AMotorNum:= MotorNums[n];
  AMotorDate:= MotorDates[n];
end;

procedure TMainForm.SelectedLetterProperties(const ALetterType: Byte;
                                     out ALetterDate: TDate;
                                     out ALetterNum: String);
var
  n: Integer;
begin
  ALetterDate:= 0;
  ALetterNum:= EmptyStr;
  if VIsNil(LogIDs) then Exit;
  if not LogTable.IsSelected then Exit;

  n:= LogTable.SelectedIndex;

  if ALetterType=0 then
  begin
    ALetterDate:= ReclamationNoticeFromUserDates[n];
    ALetterNum:= ReclamationNoticeFromUserNums[n];
  end
  else if ALetterType=1 then
  begin
    ALetterDate:= ReclamationNoticeToBuilderDates[n];
    ALetterNum:= ReclamationNoticeToBuilderNums[n];
  end
  else if ALetterType=2 then
  begin
    ALetterDate:= ReclamationAnswerFromBuilderDates[n];
    ALetterNum:= ReclamationAnswerFromBuilderNums[n];
  end
  else if ALetterType=3 then
  begin
    ALetterDate:= ReclamationAnswerToUserDates[n];
    ALetterNum:= ReclamationAnswerToUserNums[n];
  end
  else if ALetterType=4 then
  begin
    ALetterDate:= ReclamationReportDates[n];
    ALetterNum:= ReclamationReportNums[n];
  end
  else if ALetterType=5 then
  begin
    ALetterDate:= ReclamationCancelDates[n];
    ALetterNum:= ReclamationCancelNums[n];
  end
  else if ALetterType=6 then
  begin
    ALetterDate:= RepairNoticeFromUserDates[n];
    ALetterNum:= RepairNoticeFromUserNums[n];
  end
  else if ALetterType=7 then
  begin
    ALetterDate:= RepairNoticeToBuilderDates[n];
    ALetterNum:= RepairNoticeToBuilderNums[n];
  end
  else if ALetterType=8 then
  begin
    ALetterDate:= RepairAnswerFromBuilderDates[n];
    ALetterNum:= RepairAnswerFromBuilderNums[n];
  end
  else if ALetterType=9 then
  begin
    ALetterDate:= RepairAnswerToUserDates[n];
    ALetterNum:= RepairAnswerToUserNums[n];
  end
  else if ALetterType=10 then
  begin
    ALetterDate:= PretensionNoticeFromUserDates[n];
    ALetterNum:= PretensionNoticeFromUserNums[n];
  end
  else if ALetterType=11 then
  begin
    ALetterDate:= PretensionNoticeToBuilderDates[n];
    ALetterNum:= PretensionNoticeToBuilderNums[n];
  end
  else if ALetterType=12 then
  begin
    ALetterDate:= PretensionAnswerFromBuilderDates[n];
    ALetterNum:= PretensionAnswerFromBuilderNums[n];
  end
  else if ALetterType=13 then
  begin
    ALetterDate:= PretensionAnswerToUserDates[n];
    ALetterNum:= PretensionAnswerToUserNums[n];
  end;
end;



procedure TMainForm.MotorEdit(const AEditMode: Byte);
var
  MotorEditForm: TMotorEditForm;
begin
  MotorEditForm:= TMotorEditForm.Create(MainForm);
  try
    MotorEditForm.LogID:= 0;
    if LogTable.IsSelected and (AEditMode=2{edit}) then
      MotorEditForm.LogID:= LogIDs[LogTable.SelectedIndex];
    if MotorEditForm.ShowModal=mrOK then
    begin
      if AEditMode=1{new} then
        KeepLogID:= MotorEditForm.LogID;
      DataLoad;
    end;
  finally
    FreeAndNil(MotorEditForm);
  end;
end;

procedure TMainForm.NoticeEdit;
var
  NoticeEditForm: TNoticeEditForm;
begin
  NoticeEditForm:= TNoticeEditForm.Create(MainForm);
  try
    NoticeEditForm.LogID:= 0;
    if LogTable.IsSelected then
      NoticeEditForm.LogID:= LogIDs[LogTable.SelectedIndex];
    NoticeEditForm.Category:= Category;
    if NoticeEditForm.ShowModal=mrOK then
      DataLoad;
  finally
    FreeAndNil(NoticeEditForm);
  end;
end;

procedure TMainForm.NoticeDelete;
var
  LetterType: Byte;
  //S1, S2: String;
begin
  //S1:= 'Внимание! Буду удалены без возможности восстановления все данные по ';
  //S2:= ' для выбранного двигателя!' + SYMBOL_BREAK;
  //
  //case Category of
  //1: begin
  //     LetterType:= 0;
  //     if not Confirm(S1 + 'рекламации' + S2 +
  //       'Удалить "' + LETTER_NAMES[LetterType] + '"?') then Exit;
  //
  //   end;
  //2: begin
  //     LetterType:= 6;
  //     if not Confirm(S1 + 'гарантийному ремонту' + S2 +
  //       'Удалить "' + LETTER_NAMES[LetterType] + '"?') then Exit;
  //   end;
  //3: begin
  //     LetterType:= 10;
  //
  //   end;
  //end;

  case Category of
  1: LetterType:= 0;
  2: LetterType:= 6;
  3: LetterType:= 10;
  end;
  if not Confirm('Удалить "' + LETTER_NAMES[LetterType] + '"?') then Exit;
  case Category of
  1: SQLite.ReclamationNoticeDelete(LogIDs[LogTable.SelectedIndex]);
  2: SQLite.RepairNoticeDelete(LogIDs[LogTable.SelectedIndex]);
  3: SQLite.PretensionNoticeDelete(LogIDs[LogTable.SelectedIndex]);
  end;
  LetterFileDelete(LetterType);
  DataLoad;
end;

procedure TMainForm.LetterEdit(const ALetterType: Byte);
var
  LetterEditForm: TLetterEditForm;
begin
  LetterEditForm:= TLetterEditForm.Create(MainForm);
  try
    LetterEditForm.Category:= Category;
    LetterEditForm.LetterType:= ALetterType;
    LetterEditForm.LogID:= LogIDs[LogTable.SelectedIndex];
    if LetterEditForm.ShowModal=mrOk then
      DataLoad;
  finally
    FreeAndNil(LetterEditForm);
  end;
end;

procedure TMainForm.LetterDelete(const ALetterType: Byte);
begin
  if not Confirm('Удалить "' + LETTER_NAMES[ALetterType] + '"?') then Exit;
  SQLite.LetterDelete(LogIDs[LogTable.SelectedIndex], ALetterType);
  LetterFileDelete(ALetterType);
  DataLoad;
end;

procedure TMainForm.LetterFileDelete(const ALetterType: Byte);
var
  MotorName, MotorNum, LetterNum: String;
  MotorDate, LetterDate: TDate;
begin
  SelectedMotorProperties(MotorName, MotorNum, MotorDate);
  SelectedLetterProperties(ALetterType, LetterDate, LetterNum);
  DocumentDelete(ALetterType, LetterDate, LetterNum, MotorDate, MotorName, MotorNum);
end;

procedure TMainForm.LetterCreate;
var
  LetterCustomForm: TLetterCustomForm;
begin
  LetterCustomForm:= TLetterCustomForm.Create(MainForm);
  try
    LetterCustomForm.ShowModal;
  finally
    FreeAndNil(LetterCustomForm);
  end;
end;

procedure TMainForm.ReportDelete;
var
  LetterType: Byte;
begin
  LetterType:= 4;
  if not Confirm('Удалить "' + LETTER_NAMES[LetterType] + '"?') then Exit;
  SQLite.ReclamationReportDelete(LogIDs[LogTable.SelectedIndex]);
  LetterFileDelete(LetterType);
  DataLoad;
end;

procedure TMainForm.CancelDelete;
var
  LetterType: Byte;
begin
  LetterType:= 5;
  if not Confirm('Удалить "' + LETTER_NAMES[LetterType] + '"?') then Exit;
  SQLite.ReclamationCancelDelete(LogIDs[LogTable.SelectedIndex]);
  LetterFileDelete(LetterType);
  DataLoad;
end;

procedure TMainForm.RepairDatesEdit;
var
  RepairDatesEditForm: TRepairDatesEditForm;
begin
  RepairDatesEditForm:= TRepairDatesEditForm.Create(MainForm);
  try
    RepairDatesEditForm.LogID:= LogIDs[LogTable.SelectedIndex];
    if RepairDatesEditForm.ShowModal=mrOk then
      DataLoad;
  finally
    FreeAndNil(RepairDatesEditForm);
  end;
end;

procedure TMainForm.RepairDatesDelete;
begin
  if not Confirm('Удалить даты ремонта?') then Exit;
  SQLite.RepairDatesDelete(LogIDs[LogTable.SelectedIndex]);
  DataLoad;
end;

procedure TMainForm.MoneyDatesEdit;
var
  MoneyDatesEditForm: TMoneyDatesEditForm;
begin
  MoneyDatesEditForm:= TMoneyDatesEditForm.Create(MainForm);
  try
    MoneyDatesEditForm.LogID:= LogIDs[LogTable.SelectedIndex];
    if MoneyDatesEditForm.ShowModal=mrOk then
      DataLoad;
  finally
    FreeAndNil(MoneyDatesEditForm);
  end;
end;

procedure TMainForm.MoneyDatesDelete;
begin
  if not Confirm('Удалить данные по возмещению?') then Exit;
  SQLite.PretensionMoneyDelete(LogIDs[LogTable.SelectedIndex]);
  DataLoad;
end;

procedure TMainForm.NoteEdit;
var
  NoteEditForm: TNoteEditForm;
begin
  NoteEditForm:= TNoteEditForm.Create(MainForm);
  try
    NoteEditForm.LogID:= LogIDs[LogTable.SelectedIndex];
    NoteEditForm.Category:= Category;
    if NoteEditForm.ShowModal=mrOk then
      DataLoad;
  finally
    FreeAndNil(NoteEditForm);
  end;
end;

procedure TMainForm.NoteDelete;
begin
  if not Confirm('Удалить примечание?') then Exit;
  SQLite.NoteDelete(LogIDs[LogTable.SelectedIndex], Category);
  DataLoad;
end;

procedure TMainForm.OrderListCreate;
var
  S: String;
  V: TStrVector;
begin
  S:= 'Упорядочить список электродвигателей по:';
  V:= VCreateStr([
    'дате/номеру уведомления о неисправности',
    'дате/номеру запроса о гарантийном ремонте',
    'дате/номеру претензии на возмещение затрат',
    'наименованию Потребителя',
    'наименованию/номеру электродвигателя',
    'дате изготовления электродвигателя'
  ]);
  VSTOrderList:= TVSTStringList.Create(VT1, S, @OrderItemSelect);
  VSTOrderList.Update(V);
end;

procedure TMainForm.OrderItemSelect;
begin
  DataLoad;
end;

procedure TMainForm.ViewListCreate;
var
  S: String;
  V: TStrVector;
begin
  S:= 'Включить в список электродвигатели:';
  V:= VCreateStr([
    'в процессе рекламационной работы',
    'ожидающие согласования отправки в ремонт',
    'в процессе гарантийного ремонта',
    'в процессе претензионной работы',
    'все электродвигатели'
  ]);
  VSTViewList:= TVSTStringList.Create(VT2, S, @ViewItemSelect);
  VSTViewList.Update(V);
end;

procedure TMainForm.ViewItemSelect;
begin
  PeriodPanel.Visible:= VSTViewList.SelectedIndex=4;
  DataLoad;
end;

end.

