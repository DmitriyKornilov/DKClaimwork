unit UReclamationEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, EditBtn, DateTimePicker, VirtualTrees, DividerBevel,

  DK_Vector, DK_StrUtils, DK_VSTTables, DK_Dialogs,

  USQlite, UUtils;

type

  { TReclamationEditForm }

  TReclamationEditForm = class(TForm)
    AddButton: TSpeedButton;
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    WithNoticeCheckBox: TCheckBox;
    ChoosePanel: TPanel;
    DelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    FileNameEdit: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LetterNumEdit: TEdit;
    LocationNameComboBox: TComboBox;
    NotChangeFileCheckBox: TCheckBox;
    OpenButton: TSpeedButton;
    Panel1: TPanel;
    SaveButton: TSpeedButton;
    SearchLabel: TLabel;
    SearchNumEdit: TEditButton;
    SearchPanel: TPanel;
    UserNameComboBox: TComboBox;
    VT1: TVirtualStringTree;
    VT2: TVirtualStringTree;
    procedure AddButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SearchNumEditButtonClick(Sender: TObject);
    procedure SearchNumEditChange(Sender: TObject);
    procedure VT1DblClick(Sender: TObject);
    procedure VT2DblClick(Sender: TObject);
    procedure WithNoticeCheckBoxChange(Sender: TObject);
  private
    CanFormClose: Boolean;

    UserIDs: TIntVector;
    LocationIDs: TIntVector;

    OldLetterNum: String;
    OldLetterDate: TDate;
    OldMotorIDs: TIntVector;
    OldMotorNames, OldMotorNums: TStrVector;
    OldMotorDates: TDateVector;

    VSTFreeMotorList: TVSTTable;
    FreeMotorIDs: TIntVector;
    FreeMotors, FreeMotorNames, FreeMotorNums: TStrVector;
    FreeMotorDates: TDateVector;

    VSTBusyMotorList: TVSTTable;
    BusyMotorIDs: TIntVector;
    BusyMotors, BusyMotorNames, BusyMotorNums: TStrVector;
    BusyMotorDates: TDateVector;

    procedure DataLoad;

    procedure FreeMotorListCreate;
    procedure FreeMotorsLoad(const ASelectedMotorID: Integer = 0);
    procedure FreeMotorSelect;

    procedure BusyMotorListCreate;
    procedure BusyMotorsLoad(const ASelectedMotorID: Integer = 0);
    procedure BusyMotorSelect;

    procedure MotorFreeToBusy;
    procedure MotorBusyToFree;
  public
    ReclamationID: Integer;
  end;

var
  ReclamationEditForm: TReclamationEditForm;

implementation

{$R *.lfm}

{ TReclamationEditForm }

procedure TReclamationEditForm.FormCreate(Sender: TObject);
begin
  CanFormClose:= True;
  DT1.Date:= Date;
  AddButton.Enabled:= False;
  DelButton.Enabled:= False;
  SQLite.LocationIDsAndNamesLoad(LocationNameComboBox, LocationIDs);
  SQLite.UserIDsAndNamesLoad(UserNameComboBox, UserIDs);
  FreeMotorListCreate;
  BusyMotorListCreate;
end;

procedure TReclamationEditForm.FormShow(Sender: TObject);
begin
  DataLoad;
  FreeMotorsLoad;
end;

procedure TReclamationEditForm.OpenButtonClick(Sender: TObject);
begin
  DocumentChoose(FileNameEdit);
end;

procedure TReclamationEditForm.CancelButtonClick(Sender: TObject);
begin
  CanFormClose:= True;
  ModalResult:= mrCancel;
end;

procedure TReclamationEditForm.DelButtonClick(Sender: TObject);
begin
  MotorBusyToFree;
end;

procedure TReclamationEditForm.AddButtonClick(Sender: TObject);
begin
  MotorFreeToBusy;
end;

procedure TReclamationEditForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= CanFormClose;
end;

procedure TReclamationEditForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VSTFreeMotorList);
  FreeAndNil(VSTBusyMotorList);
end;

procedure TReclamationEditForm.SaveButtonClick(Sender: TObject);
var
  LetterNum, SrcFileName: String;
  LetterDate: TDate;
  LocationID, UserID, i, j, n: Integer;
  AddMotorIDs, DelMotorIDs: TIntVector;
begin
  CanFormClose:= False;

  if VIsNil(BusyMotorIDs) then
  begin
    ShowInfo('Не выбран ни один электродвигатель!');
    Exit;
  end;

  if UserNameComboBox.Text=EmptyStr then
  begin
    ShowInfo('Не указан отправитель уведомления!');
    Exit;
  end;

  LetterNum:= STrim(LetterNumEdit.Text);
  if SEmpty(LetterNum) then
  begin
    ShowInfo('Не указан номер письма!');
    Exit;
  end;

  if LocationNameComboBox.Text=EmptyStr then
  begin
    ShowInfo('Не указано предприятие!');
    Exit;
  end;

  LetterDate:= DT1.Date;
  LocationID:= LocationIDs[LocationNameComboBox.ItemIndex];
  UserID:= UserIDs[UserNameComboBox.ItemIndex];

  SrcFileName:= STrim(FileNameEdit.Text);
  if not DocumentsUpdate(not NotChangeFileCheckBox.Checked, 0 {увед о рекл}, SrcFileName,
                  BusyMotorDates, BusyMotorNames, BusyMotorNums,
                  OldLetterDate, OldLetterNum, LetterDate, LetterNum) then Exit;

  if ReclamationID=0 then
    SQLite.ReclamationNoticeAdd(BusyMotorIDs, UserID, LocationID, LetterNum, LetterDate)
  else begin
    AddMotorIDs:= nil;
    for i:= 0 to High(BusyMotorIDs) do
    begin
      n:= VIndexOf(OldMotorIDs, BusyMotorIDs[i]);
      if n<0 then
        VAppend(AddMotorIDs, BusyMotorIDs[i]);
    end;
    DelMotorIDs:= nil;
    for i:= 0 to High(OldMotorIDs) do
    begin
      n:= VIndexOf(BusyMotorIDs, OldMotorIDs[i]);
      if n<0 then
      begin
        VAppend(DelMotorIDs, OldMotorIDs[i]);
        for j:= 0 to 5 do
          DocumentDelete(j, OldLetterDate, OldLetterNum,
                         OldMotorDates[i], OldMotorNames[i], OldMotorNums[i]);
      end;
    end;

    SQLite.ReclamationNoticeUpdate(ReclamationID, UserID,
                                   LocationID, LetterNum, LetterDate,
                                   AddMotorIDs, DelMotorIDs);
  end;

  CanFormClose:= True;
  ModalResult:= mrOK;
end;

procedure TReclamationEditForm.SearchNumEditButtonClick(Sender: TObject);
begin
  SearchNumEdit.Clear;
end;

procedure TReclamationEditForm.SearchNumEditChange(Sender: TObject);
begin
  FreeMotorsLoad;
end;

procedure TReclamationEditForm.VT1DblClick(Sender: TObject);
begin
  MotorFreeToBusy;
end;

procedure TReclamationEditForm.VT2DblClick(Sender: TObject);
begin
  MotorBusyToFree;
end;

procedure TReclamationEditForm.WithNoticeCheckBoxChange(Sender: TObject);
begin
  FreeMotorsLoad;
end;

procedure TReclamationEditForm.DataLoad;
var
  Ind, UserID, LocationID: Integer;
begin
  SQLite.ReclamationInfoLoad(ReclamationID, UserID, LocationID, OldLetterNum, OldLetterDate);

  LetterNumEdit.Text:= OldLetterNum;
  if OldLetterDate>0 then
    DT1.Date:= OldLetterDate;

  Ind:= VIndexOf(LocationIDs, LocationID);
  if Ind>=0 then
    LocationNameComboBox.ItemIndex:= Ind;

  Ind:= VIndexOf(UserIDs, UserID);
  if Ind>=0 then
    UserNameComboBox.ItemIndex:= Ind;

  SQLite.ReclamationMotorsLoad(ReclamationID, BusyMotorIDs, BusyMotorNames,
                               BusyMotorNums, BusyMotorDates);
  BusyMotors:= VMotorFullName(BusyMotorNames, BusyMotorNums, BusyMotorDates);
  BusyMotorsLoad;

  if ReclamationID>0 then
  begin
    OldMotorIDs:= VCut(BusyMotorIDs);
    OldMotorNames:= VCut(BusyMotorNames);
    OldMotorNums:= VCut(BusyMotorNums);
    OldMotorDates:= VCut(BusyMotorDates);
  end;
end;



procedure TReclamationEditForm.FreeMotorsLoad(const ASelectedMotorID: Integer = 0);
var
  S: String;
  i: Integer;
begin
  S:= STrim(SearchNumEdit.Text);
  SQLite.MotorsForReclamationLoad(WithNoticeCheckBox.CHecked, S, BusyMotorIDs, FreeMotorIDs,
                               FreeMotorNames, FreeMotorNums, FreeMotorDates);
  FreeMotors:= VMotorFullName(FreeMotorNames, FreeMotorNums, FreeMotorDates);

  VSTFreeMotorList.UnSelect;
  VSTFreeMotorList.SetColumn('Список', FreeMotors, taLeftJustify);
  VSTFreeMotorList.Draw;

  i:= -1;
  if ASelectedMotorID>0 then
    i:= VIndexOf(FreeMotorIDs, ASelectedMotorID);
  if i>=0 then
    VSTFreeMotorList.Select(i);
end;

procedure TReclamationEditForm.FreeMotorListCreate;
begin
  VSTFreeMotorList:= TVSTTable.Create(VT1);
  VSTFreeMotorList.CanSelect:= True;
  VSTFreeMotorList.OnSelect:= @FreeMotorSelect;
  VSTFreeMotorList.HeaderVisible:= False;
  VSTFreeMotorList.AddColumn('Список');
end;

procedure TReclamationEditForm.FreeMotorSelect;
begin
  AddButton.Enabled:= VSTFreeMotorList.IsSelected;
  if VSTFreeMotorList.IsSelected then
    VSTBusyMotorList.UnSelect;
end;

procedure TReclamationEditForm.BusyMotorListCreate;
begin
  VSTBusyMotorList:= TVSTTable.Create(VT2);
  VSTBusyMotorList.CanSelect:= True;
  VSTBusyMotorList.OnSelect:= @BusyMotorSelect;
  VSTBusyMotorList.HeaderVisible:= False;
  VSTBusyMotorList.AddColumn('Список');
end;

procedure TReclamationEditForm.BusyMotorsLoad(const ASelectedMotorID: Integer = 0);
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

procedure TReclamationEditForm.BusyMotorSelect;
begin
  DelButton.Enabled:= VSTBusyMotorList.IsSelected;
  if VSTBusyMotorList.IsSelected then
    VSTFreeMotorList.UnSelect;
end;

procedure TReclamationEditForm.MotorFreeToBusy;
var
  i, SelectedMotorID: Integer;
begin
  if not VSTFreeMotorList.IsSelected then Exit;
  i:= VSTFreeMotorList.SelectedIndex;
  SelectedMotorID:= FreeMotorIDs[i];
  VAppend(BusyMotorIDs, SelectedMotorID);
  VAppend(BusyMotors, FreeMotors[i]);
  VAppend(BusyMotorNames, FreeMotorNames[i]);
  VAppend(BusyMotorNums, FreeMotorNums[i]);
  VAppend(BusyMotorDates, FreeMotorDates[i]);
  BusyMotorsLoad(SelectedMotorID);
  FreeMotorsLoad;
end;

procedure TReclamationEditForm.MotorBusyToFree;
var
  i, SelectedMotorID: Integer;
begin
  if not VSTBusyMotorList.IsSelected then Exit;
  i:= VSTBusyMotorList.SelectedIndex;
  SelectedMotorID:= BusyMotorIDs[i];
  VDel(BusyMotorIDs, i);
  VDel(BusyMotors, i);
  VDel(BusyMotorNames, i);
  VDel(BusyMotorNums, i);
  VDel(BusyMotorDates, i);
  BusyMotorsLoad;
  FreeMotorsLoad(SelectedMotorID);
end;

end.

