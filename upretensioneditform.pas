unit UPretensionEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, EditBtn, VirtualTrees, rxcurredit, DateTimePicker, DividerBevel,

  DK_Vector, DK_StrUtils, DK_VSTTables, DK_Dialogs, DK_PriceUtils,

  USQlite, UUtils;

type

  { TPretensionEditForm }

  TPretensionEditForm = class(TForm)
    AddButton: TSpeedButton;
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    ChoosePanel: TPanel;
    DelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    DT1: TDateTimePicker;
    FileNameEdit: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LetterNumEdit: TEdit;
    MoneyEdit: TCurrencyEdit;
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
  private
    CanFormClose: Boolean;

    UserIDs: TIntVector;

    OldLetterNum: String;
    OldLetterDate: TDate;
    OldRecLogIDs, OldMotorIDs: TIntVector;
    OldMotorNames, OldMotorNums: TStrVector;
    OldMotorDates: TDateVector;

    VSTFreeMotorList: TVSTTable;
    FreeMotorIDs, FreeRecLogIDs: TIntVector;
    FreeMotors, FreeMotorNames, FreeMotorNums: TStrVector;
    FreeMotorDates: TDateVector;

    VSTBusyMotorList: TVSTTable;
    BusyMotorIDs, BusyRecLogIDs: TIntVector;
    BusyMotors, BusyMotorNames, BusyMotorNums: TStrVector;
    BusyMotorDates: TDateVector;

    procedure DataLoad;

    procedure FreeMotorListCreate;
    procedure FreeMotorsLoad(const ASelectedRecLogID: Integer = 0);
    procedure FreeMotorSelect;

    procedure BusyMotorListCreate;
    procedure BusyMotorsLoad(const ASelectedRecLogID: Integer = 0);
    procedure BusyMotorSelect;

    procedure MotorFreeToBusy;
    procedure MotorBusyToFree;
  public
    PretensionID: Integer;
  end;

var
  PretensionEditForm: TPretensionEditForm;

implementation

{$R *.lfm}

{ TPretensionEditForm }

procedure TPretensionEditForm.SaveButtonClick(Sender: TObject);
var
  LetterNum, SrcFileName: String;
  LetterDate: TDate;
  UserID, i, j, n: Integer;
  AddRecLogIDs, DelRecLogIDs: TIntVector;
  AddMotorIDs: TIntVector;
  MoneyValue: Int64;
begin
  CanFormClose:= False;

  if VIsNil(BusyMotorIDs) then
  begin
    ShowInfo('Не выбран ни один электродвигатель!');
    Exit;
  end;

  MoneyValue:= Trunc(100*MoneyEdit.Value);
  if MoneyValue=0 then
  begin
    ShowInfo('Не указана сумма к возмещению!');
    Exit;
  end;

  if UserNameComboBox.Text=EmptyStr then
  begin
    ShowInfo('Не указан отправитель претензии!');
    Exit;
  end;

  LetterNum:= STrim(LetterNumEdit.Text);
  if SEmpty(LetterNum) then
  begin
    ShowInfo('Не указан номер письма!');
    Exit;
  end;

  LetterDate:= DT1.Date;
  UserID:= UserIDs[UserNameComboBox.ItemIndex];

  SrcFileName:= STrim(FileNameEdit.Text);
  if not DocumentsUpdate(not NotChangeFileCheckBox.Checked, 10 {претензия}, SrcFileName,
                  BusyMotorDates, BusyMotorNames, BusyMotorNums,
                  OldLetterDate, OldLetterNum, LetterDate, LetterNum) then Exit;

  if PretensionID=0 then
    SQLite.PretensionNoticeAdd(BusyRecLogIDs, BusyMotorIDs, UserID, MoneyValue, LetterNum, LetterDate)
  else begin
    AddRecLogIDs:= nil;
    AddMotorIDs:= nil;
    for i:= 0 to High(BusyRecLogIDs) do
    begin
      n:= VIndexOf(OldRecLogIDs, BusyRecLogIDs[i]);
      if n<0 then begin
        VAppend(AddRecLogIDs, BusyRecLogIDs[i]);
        VAppend(AddMotorIDs, BusyMotorIDs[i]);
      end;
    end;
    DelRecLogIDs:= nil;
    for i:= 0 to High(OldRecLogIDs) do
    begin
      n:= VIndexOf(BusyRecLogIDs, OldRecLogIDs[i]);
      if n<0 then
      begin
        VAppend(DelRecLogIDs, OldRecLogIDs[i]);
        for j:= 10 to 13 do
          DocumentDelete(j, OldLetterDate, OldLetterNum,
                         OldMotorDates[i], OldMotorNames[i], OldMotorNums[i]);
      end;
    end;

    SQLite.PretensionNoticeUpdate(PretensionID, UserID, MoneyValue, LetterNum, LetterDate,
                                 AddRecLogIDs, AddMotorIDs, DelRecLogIDs);
  end;

  CanFormClose:= True;
  ModalResult:= mrOK;
end;

procedure TPretensionEditForm.CancelButtonClick(Sender: TObject);
begin
  CanFormClose:= True;
  ModalResult:= mrCancel;
end;

procedure TPretensionEditForm.AddButtonClick(Sender: TObject);
begin
  MotorFreeToBusy;
end;

procedure TPretensionEditForm.DelButtonClick(Sender: TObject);
begin
  MotorBusyToFree;
end;

procedure TPretensionEditForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= CanFormClose;
end;

procedure TPretensionEditForm.FormCreate(Sender: TObject);
begin
  CanFormClose:= True;
  DT1.Date:= Date;
  AddButton.Enabled:= False;
  DelButton.Enabled:= False;
  SQLite.UserIDsAndNamesLoad(UserNameComboBox, UserIDs);
  FreeMotorListCreate;
  BusyMotorListCreate;
end;

procedure TPretensionEditForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VSTFreeMotorList);
  FreeAndNil(VSTBusyMotorList);
end;

procedure TPretensionEditForm.FormShow(Sender: TObject);
begin
  DataLoad;
  FreeMotorsLoad;
end;

procedure TPretensionEditForm.OpenButtonClick(Sender: TObject);
var
  D: TDate;
begin
  DocumentChoose(FileNameEdit);
  if DocumentDate(FileNameEdit.Text, D) then
    DT1.Date:= D;
end;

procedure TPretensionEditForm.SearchNumEditButtonClick(Sender: TObject);
begin
  SearchNumEdit.Clear;
end;

procedure TPretensionEditForm.SearchNumEditChange(Sender: TObject);
begin
  FreeMotorsLoad;
end;

procedure TPretensionEditForm.VT1DblClick(Sender: TObject);
begin
  MotorFreeToBusy;
end;

procedure TPretensionEditForm.VT2DblClick(Sender: TObject);
begin
  MotorBusyToFree;
end;

procedure TPretensionEditForm.DataLoad;
var
  Ind, UserID: Integer;
  RecNoticeNums: TStrVector;
  RecNoticeDates: TDateVector;
  MoneyValue: Int64;
begin
  SQLite.PretensionInfoLoad(PretensionID, UserID, MoneyValue, OldLetterNum, OldLetterDate);

  if MoneyValue>0 then
    MoneyEdit.Text:= PriceIntToStr(MoneyValue);

  LetterNumEdit.Text:= OldLetterNum;
  if OldLetterDate>0 then
    DT1.Date:= OldLetterDate;

  Ind:= VIndexOf(UserIDs, UserID);
  if Ind>=0 then
    UserNameComboBox.ItemIndex:= Ind;

  SQLite.PretensionMotorsLoad(PretensionID, BusyRecLogIDs, BusyMotorIDs,
                          RecNoticeNums, BusyMotorNames, BusyMotorNums,
                          RecNoticeDates, BusyMotorDates);
  BusyMotors:= VReclamationMotorStr(BusyMotorNames, BusyMotorNums, BusyMotorDates,
                                    RecNoticeNums, RecNoticeDates);
  BusyMotorsLoad;

  if PretensionID>0 then
  begin
    OldRecLogIDs:= VCut(BusyRecLogIDs);
    OldMotorIDs:= VCut(BusyMotorIDs);
    OldMotorNames:= VCut(BusyMotorNames);
    OldMotorNums:= VCut(BusyMotorNums);
    OldMotorDates:= VCut(BusyMotorDates);
  end;
end;

procedure TPretensionEditForm.FreeMotorListCreate;
begin
  VSTFreeMotorList:= TVSTTable.Create(VT1);
  VSTFreeMotorList.CanSelect:= True;
  VSTFreeMotorList.OnSelect:= @FreeMotorSelect;
  VSTFreeMotorList.HeaderVisible:= False;
  VSTFreeMotorList.AddColumn('Список');
end;

procedure TPretensionEditForm.FreeMotorsLoad(const ASelectedRecLogID: Integer);
var
  S: String;
  i: Integer;
  RecNoticeNums: TStrVector;
  RecNoticeDates: TDateVector;
begin
  S:= STrim(SearchNumEdit.Text);

  SQLite.MotorsForPretensionLoad(S, BusyRecLogIDs, FreeRecLogIDs, FreeMotorIDs,
                            RecNoticeNums, FreeMotorNames, FreeMotorNums,
                            RecNoticeDates, FreeMotorDates);
  FreeMotors:= VReclamationMotorStr(FreeMotorNames, FreeMotorNums, FreeMotorDates,
                                    RecNoticeNums, RecNoticeDates);

  VSTFreeMotorList.UnSelect;
  VSTFreeMotorList.SetColumn('Список', FreeMotors, taLeftJustify);
  VSTFreeMotorList.Draw;

  i:= -1;
  if ASelectedRecLogID>0 then
    i:= VIndexOf(FreeRecLogIDs, ASelectedRecLogID);
  if i>=0 then
    VSTFreeMotorList.Select(i);
end;

procedure TPretensionEditForm.FreeMotorSelect;
begin
  AddButton.Enabled:= VSTFreeMotorList.IsSelected;
  if VSTFreeMotorList.IsSelected then
    VSTBusyMotorList.UnSelect;
end;

procedure TPretensionEditForm.BusyMotorListCreate;
begin
  VSTBusyMotorList:= TVSTTable.Create(VT2);
  VSTBusyMotorList.CanSelect:= True;
  VSTBusyMotorList.OnSelect:= @BusyMotorSelect;
  VSTBusyMotorList.HeaderVisible:= False;
  VSTBusyMotorList.AddColumn('Список');
end;

procedure TPretensionEditForm.BusyMotorsLoad(const ASelectedRecLogID: Integer);
var
  i: Integer;
begin
  VSTBusyMotorList.UnSelect;
  VSTBusyMotorList.SetColumn('Список', BusyMotors, taLeftJustify);
  VSTBusyMotorList.Draw;

  i:= -1;
  if ASelectedRecLogID>0 then
    i:= VIndexOf(BusyRecLogIDs, ASelectedRecLogID);
  if i>=0 then
    VSTBusyMotorList.Select(i);
end;

procedure TPretensionEditForm.BusyMotorSelect;
begin
  DelButton.Enabled:= VSTBusyMotorList.IsSelected;
  if VSTBusyMotorList.IsSelected then
    VSTFreeMotorList.UnSelect;
end;

procedure TPretensionEditForm.MotorFreeToBusy;
var
  i, SelectedRecLogID: Integer;
begin
  if not VSTFreeMotorList.IsSelected then Exit;
  i:= VSTFreeMotorList.SelectedIndex;
  SelectedRecLogID:= FreeRecLogIDs[i];
  VAppend(BusyRecLogIDs, SelectedRecLogID);
  VAppend(BusyMotorIDs, FreeMotorIDs[i]);
  VAppend(BusyMotors, FreeMotors[i]);
  VAppend(BusyMotorNames, FreeMotorNames[i]);
  VAppend(BusyMotorNums, FreeMotorNums[i]);
  VAppend(BusyMotorDates, FreeMotorDates[i]);
  BusyMotorsLoad(SelectedRecLogID);
  FreeMotorsLoad;
end;

procedure TPretensionEditForm.MotorBusyToFree;
var
  i, SelectedRecLogID: Integer;
begin
  if not VSTBusyMotorList.IsSelected then Exit;
  i:= VSTBusyMotorList.SelectedIndex;
  SelectedRecLogID:= BusyRecLogIDs[i];
  VDel(BusyRecLogIDs, i);
  VDel(BusyMotorIDs, i);
  VDel(BusyMotors, i);
  VDel(BusyMotorNames, i);
  VDel(BusyMotorNums, i);
  VDel(BusyMotorDates, i);
  BusyMotorsLoad;
  FreeMotorsLoad(SelectedRecLogID);

end;

end.

