unit UMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  Buttons, StdCtrls, EditBtn, BCButton, DividerBevel, DateTimePicker,

  DK_LCLStrRus, DK_HeapTrace, DK_Const, DK_Vector, DK_CtrlUtils,
  DK_StrUtils, DK_DateUtils,

  USQLite, UUtils,

  USenderEditForm, UReceiverEditForm, UImageEditForm, ULetterCustomForm,
  UAboutForm, UMotorListForm, UReclamationForm, URepairForm, UPretensionForm;

type

  { TMainForm }

  TMainForm = class(TForm)
    AboutButton: TSpeedButton;
    DividerBevel2: TDividerBevel;
    DividerBevel6: TDividerBevel;
    DT1: TDateTimePicker;
    DT2: TDateTimePicker;
    PeriodLeftLabel: TLabel;
    PeriodMiddleLabel: TLabel;
    PeriodPanel: TPanel;
    SearchLabel: TLabel;
    SearchNumEdit: TEditButton;
    SearchPanel: TPanel;
    LetterButton: TBCButton;
    MotorListMenuItem: TMenuItem;
    MainPanel: TPanel;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    Separator4: TMenuItem;
    Panel3: TPanel;
    ReclamationButton: TBCButton;
    DelegateListMenuItem: TMenuItem;
    BuilderDelegateMenuItem: TMenuItem;
    BuilderListMenuItem: TMenuItem;
    DividerBevel1: TDividerBevel;
    DividerBevel3: TDividerBevel;
    DividerBevel4: TDividerBevel;
    DividerBevel5: TDividerBevel;
    ExitButton: TSpeedButton;
    UserListMenuItem: TMenuItem;
    ImageListMenuItem: TMenuItem;
    ImagesEdit24x24: TImageList;
    ImagesMain24x24: TImageList;
    PretensionButton: TBCButton;
    MotorNameMenuItem: TMenuItem;
    Panel1: TPanel;
    PerformerListMenuItem: TMenuItem;
    LocationListMenuItem: TMenuItem;
    PopupMenu1: TPopupMenu;
    ReceiverListMenuItem: TMenuItem;
    RefreshButton: TSpeedButton;
    RepairButton: TBCButton;
    SenderListMenuItem: TMenuItem;
    SettingsButton: TBCButton;
    ToolPanel: TPanel;

    procedure AboutButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure LetterButtonClick(Sender: TObject);
    procedure RefreshButtonClick(Sender: TObject);
    procedure ReclamationButtonClick(Sender: TObject);
    procedure PretensionButtonClick(Sender: TObject);
    procedure RepairButtonClick(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);

    procedure BuilderDelegateMenuItemClick(Sender: TObject);
    procedure BuilderListMenuItemClick(Sender: TObject);
    procedure DelegateListMenuItemClick(Sender: TObject);
    procedure ImageListMenuItemClick(Sender: TObject);
    procedure MotorListMenuItemClick(Sender: TObject);
    procedure PerformerListMenuItemClick(Sender: TObject);
    procedure ReceiverListMenuItemClick(Sender: TObject);
    procedure SenderListMenuItemClick(Sender: TObject);
    procedure MotorNameMenuItemClick(Sender: TObject);
    procedure UserListMenuItemClick(Sender: TObject);
    procedure LocationListMenuItemClick(Sender: TObject);

    procedure DT1Change(Sender: TObject);
    procedure DT2Change(Sender: TObject);

    procedure SearchNumEditButtonClick(Sender: TObject);
    procedure SearchNumEditChange(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    ReclamationForm: TForm;
    RepairForm: TForm;
    PretensionForm: TForm;
    Category: Byte;

    procedure MotorNamesEdit;
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
    procedure CategoryFormsFree;
    procedure ReclamationFormOpen;
    procedure RepairFormOpen;
    procedure PretensionFormOpen;

    procedure DataLoad;

    procedure LetterCreate;
  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  HeapTraceOutputFile('trace.trc');

  //for normal form maximizing
  Height:= 300;
  Width:= 500;

  DT1.Date:= FirstDayInYear(Date);
  DT2.Date:= LastDayInYear(Date);

  SQLite:= TSQLite.Create;
  SQLite.SetColors(DefaultSelectionBGColor, clWindowText);
  SQLite.SetNavigatorGlyphs(ImagesEdit24x24);
  ConnectDB;

  CategorySelect(1);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  CategoryFormsFree;
  FreeAndNil(SQLite);
end;

procedure TMainForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.MotorNameMenuItemClick(Sender: TObject);
begin
  MotorNamesEdit;
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

procedure TMainForm.MotorListMenuItemClick(Sender: TObject);
begin
  MotorListEdit;
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
  SearchNumEdit.Clear;
end;

procedure TMainForm.SearchNumEditChange(Sender: TObject);
begin
  DataLoad;
end;

procedure TMainForm.SenderListMenuItemClick(Sender: TObject);
begin
  SenderListEdit;
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

procedure TMainForm.DelegateListMenuItemClick(Sender: TObject);
begin
  DelegateListEdit;
end;

procedure TMainForm.AboutButtonClick(Sender: TObject);
begin
  FormModalShow(TAboutForm);
end;

procedure TMainForm.DT1Change(Sender: TObject);
begin
  DataLoad;
end;

procedure TMainForm.DT2Change(Sender: TObject);
begin
  DataLoad;
end;

procedure TMainForm.SettingsButtonClick(Sender: TObject);
begin
  ControlPopupMenuShow(Sender, PopupMenu1);
end;

procedure TMainForm.MotorNamesEdit;
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
    MotorNameDirectoryRename(OldMotorNameIDs, NewMotorNameIDs, OldMotorNames, NewMotorNames);
    //обновляем основной список
    DataLoad;
  end;
end;

procedure TMainForm.MotorListEdit;
begin
  FormModalShow(TMotorListForm);
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
begin
  FormModalShow(TSenderEditForm);
end;

procedure TMainForm.ReceiverListEdit;
begin
  FormModalShow(TReceiverEditForm);
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
begin
  FormModalShow(TImageEditForm);
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
begin
  if ACategory=Category then Exit;
  Category:= ACategory;
  Screen.Cursor:= crHourGlass;
  try
    ReclamationButton.Down:= ACategory=1;
    RepairButton.Down:= ACategory=2;
    PretensionButton.Down:= ACategory=3;
    CategoryFormsFree;
    case Category of
    1: ReclamationFormOpen;
    2: RepairFormOpen;
    3: PretensionFormOpen;
    end;
    DataLoad;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TMainForm.CategoryFormsFree;
begin
  if Assigned(ReclamationForm) then FreeAndNil(ReclamationForm);
  if Assigned(RepairForm) then FreeAndNil(RepairForm);
  if Assigned(PretensionForm) then FreeAndNil(PretensionForm);
end;

procedure TMainForm.ReclamationFormOpen;
begin
  ReclamationForm:= FormOnPanelCreate(TReclamationForm, MainPanel);
  ReclamationForm.Show;
end;

procedure TMainForm.RepairFormOpen;
begin
  RepairForm:= FormOnPanelCreate(TRepairForm, MainPanel);
  RepairForm.Show;
end;

procedure TMainForm.PretensionFormOpen;
begin
  PretensionForm:= FormOnPanelCreate(TPretensionForm, MainPanel);
  PretensionForm.Show;
end;

procedure TMainForm.DataLoad;
var
  MotorNumLike: String;
begin
  MotorNumLike:= STrim(SearchNumEdit.Text);
  case Category of
  1: (ReclamationForm as TReclamationForm).DataLoad(MotorNumLike, DT1.Date, DT2.Date);
  2: (RepairForm as TRepairForm).DataLoad(MotorNumLike, DT1.Date, DT2.Date);
  3: (PretensionForm as TPretensionForm).DataLoad(MotorNumLike, DT1.Date, DT2.Date);
  end;
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

end.

