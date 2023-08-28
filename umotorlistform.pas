unit UMotorListForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls,
  StdCtrls, EditBtn, DividerBevel, VirtualTrees,

  DK_Vector, DK_VSTTables, DK_StrUtils, DK_Dialogs, DK_Const,

  USQLite, UUtils,

  UMotorEditForm;

type

  { TMotorListForm }

  TMotorListForm = class(TForm)
    AddButton: TSpeedButton;
    DelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    EditButton: TSpeedButton;
    ToolPanel: TPanel;
    Panel1: TPanel;
    SearchLabel: TLabel;
    SearchNumEdit: TEditButton;
    SearchPanel: TPanel;
    VT1: TVirtualStringTree;
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SearchNumEditButtonClick(Sender: TObject);
    procedure SearchNumEditChange(Sender: TObject);
  private
    VST: TVSTTable;

    MotorIDs: TIntVector;
    MotorNames: TStrVector;
    MotorNums: TStrVector;
    MotorDates: TDateVector;

    procedure DataLoad(const ASelectedMotorID: Integer=0);

    procedure MotorSelect;
    procedure MotorDelete;
    procedure MotorEdit(const AEditMode: Byte); //1 - new, 2  edit
    procedure MotorSelected(out AMotorName, AMotorNum: String; out AMotorDate: TDate);
  public

  end;

var
  MotorListForm: TMotorListForm;

implementation

{$R *.lfm}

{ TMotorListForm }

procedure TMotorListForm.FormCreate(Sender: TObject);
begin
  VST:= TVSTTable.Create(VT1);
  VST.CanSelect:= True;
  VST.OnSelect:= @MotorSelect;
  VST.AddColumn('№ п/п', 50);
  VST.AddColumn('Наименование', 250);
  VST.AddColumn('Номер', 100);
  VST.AddColumn('Дата изготовления', 100);
  DataLoad;
end;

procedure TMotorListForm.AddButtonClick(Sender: TObject);
begin
  MotorEdit(1);
end;

procedure TMotorListForm.DelButtonClick(Sender: TObject);
begin
  MotorDelete;
end;

procedure TMotorListForm.EditButtonClick(Sender: TObject);
var
  OldMotorName, NewMotorName: String;
  OldMotorNum, NewMotorNum: String;
  OldMotorDate, NewMotorDate: TDate;
begin
  //запоминаем старые данные по двигателю
  MotorSelected(OldMotorName, OldMotorNum, OldMotorDate);
  //редактируем
  MotorEdit(2);
  //получаем новые данные по двигателю
  MotorSelected(NewMotorName, NewMotorNum, NewMotorDate);
  //переименовываем папку для этого двигателя
  MotorNumDirectoryRename(OldMotorName, NewMotorName, OldMotorNum, NewMotorNum,
                         OldMotorDate, NewMotorDate);
end;

procedure TMotorListForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VST);
end;

procedure TMotorListForm.SearchNumEditButtonClick(Sender: TObject);
begin
  SearchNumEdit.Text:= EmptyStr;
end;

procedure TMotorListForm.SearchNumEditChange(Sender: TObject);
begin
  DataLoad;
end;

procedure TMotorListForm.DataLoad(const ASelectedMotorID: Integer = 0);
var
  S: String;
  i: Integer;
begin
  S:= STrim(SearchNumEdit.Text);
  SQLite.MotorsAllLoad(S, MotorIDs, MotorNames, MotorNums, MotorDates);

  VST.SetColumn('№ п/п', VIntToStr(VOrder(Length(MotorIDs))));
  VST.SetColumn('Наименование', MotorNames);
  VST.SetColumn('Номер', MotorNums);
  VST.SetColumn('Дата изготовления', VFormatDateTime('dd.mm.yyyy', MotorDates));
  VST.Draw;

  i:= -1;
  if ASelectedMotorID>0 then
    i:= VIndexOf(MotorIDs, ASelectedMotorID);
  if i>=0 then
    VST.Select(i);
end;

procedure TMotorListForm.MotorSelect;
begin
  DelButton.Enabled:= VST.IsSelected;
  EditButton.Enabled:= VST.IsSelected;
end;

procedure TMotorListForm.MotorDelete;
var
  MotorName: String;
  MotorNum: String;
  MotorDate: TDate;
begin
  MotorSelected(MotorName, MotorNum, MotorDate);
  if not Confirm('Внимание!' + SYMBOL_BREAK +
                 'Все данные о переписке по двигателю ' +
                 MotorFullName(MotorName, MotorNum, MotorDate)  + SYMBOL_BREAK +
                 'будут удалены без возможности восстановления!' + SYMBOL_BREAK +
                 'Удалить?') then Exit;
  SQLite.MotorDelete(MotorIDs[VST.SelectedIndex]);
  MotorNumDirectoryDelete(MotorName, MotorNum, MotorDate);
  DataLoad;
end;

procedure TMotorListForm.MotorEdit(const AEditMode: Byte);
var
  MotorEditForm: TMotorEditForm;
begin
  MotorEditForm:= TMotorEditForm.Create(nil);
  try
    MotorEditForm.MotorID:= 0;
    if VST.IsSelected and (AEditMode=2{edit}) then
      MotorEditForm.MotorID:= MotorIDs[VST.SelectedIndex];
    if MotorEditForm.ShowModal=mrOK then
      DataLoad(MotorEditForm.MotorID);
  finally
    FreeAndNil(MotorEditForm);
  end;
end;

procedure TMotorListForm.MotorSelected(out AMotorName, AMotorNum: String; out AMotorDate: TDate);
var
  i: Integer;
begin
  i:= VST.SelectedIndex;
  AMotorName:= MotorNames[i];
  AMotorNum:= MotorNums[i];
  AMotorDate:= MotorDates[i];
end;

end.

