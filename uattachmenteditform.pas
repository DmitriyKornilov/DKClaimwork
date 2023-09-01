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

  public
    Category: Byte;
    LogID: Integer;
    AttachmentID: Integer;
    OldAttachmentName, OldAttachmentExtension: String;
    NoticeNum, MotorName, MotorNum: String;
    NoticeDate, MotorDate: TDate;
  end;

var
  AttachmentEditForm: TAttachmentEditForm;

implementation

{$R *.lfm}

{ TAttachmentEditForm }

procedure TAttachmentEditForm.FormShow(Sender: TObject);
begin
  CanFormClose:= True;
  AttachmentNameEdit.Text:= OldAttachmentName;
  NotChangeFileCheckBox.Visible:= AttachmentID>0;
end;

procedure TAttachmentEditForm.OpenButtonClick(Sender: TObject);
var
  FileName, FileExt: String;
begin
  FileChoose(FileNameEdit);
  if not SEmpty(Strim(AttachmentNameEdit.Text)) then Exit;

  FileName:= STrim(FileNameEdit.Text);
  if SEmpty(FileName) then Exit;

  FileExt:= ExtractFileExt(FileName);
  FileName:= ExtractFileName(FileName);
  AttachmentNameEdit.Text:= SCutRight(FileName, SLength(FileExt));
end;

procedure TAttachmentEditForm.SaveButtonClick(Sender: TObject);
var
  S, DestFileName, SrcFileName, AttachmentName, AttachmentExtension: String;
begin
  CanFormClose:= False;

  SrcFileName:= STrim(FileNameEdit.Text);
  if ((not NotChangeFileCheckBox.Checked) or (AttachmentID=0)) and SEmpty(SrcFileName) then
  begin
    ShowInfo('Не указан файл приложения!');
    Exit;
  end;
  if (not SEmpty(SrcFileName)) and (not FileExists(SrcFileName)) then
  begin
    ShowInfo('Указанный файл приложения' + SrcFileName + 'не найден!');
    Exit;
  end;
  AttachmentExtension:= ExtractFileExt(SrcFileName);

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

  DestFileName:= AttachmentFileFullNameGet(Category, AttachmentName, AttachmentExtension,
                        NoticeDate, NoticeNum, MotorDate, MotorName, MotorNum);

  if AttachmentID=0 then
  begin
    if not DocumentCopy(SrcFileName, DestFileName, False) then Exit;
    SQLite.AttachmentAdd(Category, LogID, AttachmentName, AttachmentExtension);
  end
  else begin
    if not SSame(AttachmentName, OldAttachmentName, False) then
    begin
      S:= AttachmentFileFullNameGet(Category, OldAttachmentName, OldAttachmentExtension,
                        NoticeDate, NoticeNum, MotorDate, MotorName, MotorNum);
      if (not NotChangeFileCheckBox.Checked) then
      begin
        if not DocumentDelete(S) then Exit;
        if not DocumentCopy(SrcFileName, DestFileName, False) then Exit;
      end
      else begin
        if not DocumentRename(S, DestFileName) then Exit;
      end;
      SQLite.AttachmentUpdate(Category, AttachmentID, AttachmentName, AttachmentExtension);
    end;
  end;

  CanFormClose:= True;
  ModalResult:= mrOK;
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

