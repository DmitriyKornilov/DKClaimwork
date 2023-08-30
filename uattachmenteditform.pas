unit UAttachmentEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DividerBevel,

  DK_StrUtils, DK_Dialogs,

  USQLite, UUtils;

type

  { TAttachmentEditForm }

  TAttachmentEditForm = class(TForm)
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    AttachmentNameEdit: TEdit;
    FileNameEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    NotChangeFileCheckBox: TCheckBox;
    OpenButton: TSpeedButton;
    SaveButton: TSpeedButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    CanFormClose: Boolean;

    OldAttachmentName, NoticeNum, MotorName, MotorNum: String;
    NoticeDate, MotorDate: TDate;

    procedure DataLoad;
  public
    Category: Byte;
    LogID: Integer;
    AttachmentID: Integer;
  end;

var
  AttachmentEditForm: TAttachmentEditForm;

implementation

{$R *.lfm}

{ TAttachmentEditForm }

procedure TAttachmentEditForm.FormShow(Sender: TObject);
begin
  CanFormClose:= True;
  DataLoad;
end;

procedure TAttachmentEditForm.OpenButtonClick(Sender: TObject);
begin
  DocumentChoose(FileNameEdit);
end;

procedure TAttachmentEditForm.SaveButtonClick(Sender: TObject);
var
  DestFileName, SrcFileName, AttachmentName: String;
begin
  CanFormClose:= False;

  SrcFileName:= STrim(FileNameEdit.Text);
  if (not NotChangeFileCheckBox.Checked) and SEmpty(SrcFileName) then
  begin
    ShowInfo('Не указан файл приложения!');
    Exit;
  end;
  if (not SEmpty(SrcFileName)) and (not FileExists(SrcFileName)) then
  begin
    ShowInfo('Указанный файл приложения' + SrcFileName + 'не найден!');
    Exit;
  end;

  AttachmentName:= STrim(AttachmentNameEdit.Text);
  if SEmpty(AttachmentName) then
  begin
    ShowInfo('Не указано наименование приложения!');
    Exit;
  end;

  if SQLite.AttachmentFind(Category, AttachmentID, AttachmentName) then
  begin
    ShowInfo('Уже есть приложение с наименованием "'+ AttachmentName + '"!');
    Exit;
  end;

  if AttachmentID=0 then
  begin
    SQLite.AttachmentAdd(Category, LogID, AttachmentName);
    if not NotChangeFileCheckBox.Checked then
    begin
      DestFileName:= AttachmentFileFullNameGet(Category, AttachmentName,
                        NoticeDate, NoticeNum, MotorDate, MotorName, MotorNum);
      //DocumentCopy(SrcFileName, DestFileName);
    end;
  end
  else begin
    if not SSame(AttachmentName, OldAttachmentName, False) then
    begin

    end;
  end;


  CanFormClose:= True;
  ModalResult:= mrOK;
end;

procedure TAttachmentEditForm.DataLoad;
begin
  if AttachmentID=0 then Exit;

//
//  SQLite.AttachmentInfoLoad(Category, AttachmentID, OldAttachmentName,
//                           NoticeNum, NoticeDate, MotorName, MotorNum, MotorDate);

  AttachmentNameEdit.TExt:= OldAttachmentName;
end;

procedure TAttachmentEditForm.FormCloseQuery(Sender: TObject;  var CanClose: Boolean);
begin
  CanClose:= CanFormClose;
end;

procedure TAttachmentEditForm.CancelButtonClick(Sender: TObject);
begin
  CanFormClose:= True;
  ModalResult:= mrCancel;
end;

end.

