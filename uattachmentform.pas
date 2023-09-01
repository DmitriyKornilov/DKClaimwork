unit UAttachmentForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  VirtualTrees,

  DK_Vector, DK_VSTTools, DK_Dialogs,

  USQLite, UUtils,

  UAttachmentEditForm;

type

  { TAttachmentForm }

  TAttachmentForm = class(TForm)
    AddButton: TSpeedButton;
    DelButton: TSpeedButton;
    EditButton: TSpeedButton;
    CopyButton: TSpeedButton;
    Panel1: TPanel;
    ViewButton: TSpeedButton;
    ToolPanel: TPanel;
    VT1: TVirtualStringTree;
    procedure AddButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ViewButtonClick(Sender: TObject);
  private
    VST: TVSTStringList;

    AttachmentIDs: TIntVector;
    AttachmentNames, AttachmentExtensions: TStrVector;

    LogID: Integer;
    NoticeNum: String;
    NoticeDate: TDate;
    MotorNum, MotorName: String;
    MotorDate: TDate;

    procedure ButtonsEnabled;

    procedure AttachmentSelect;
    procedure AttachmentEdit(const AEditMode: Byte); //1-new, 2-edit
    procedure AttachmentDelete;
    procedure AttachmentView;
    procedure AttachmentCopy;
    procedure AttachmentUpdate;
  public
    Category: Byte;
    procedure AttachmentsShow(const ALogID: Integer;
                              const ANoticeNum: String;
                              const ANoticeDate: TDate;
                              const AMotorNum, AMotorName: String;
                              const AMotorDate: TDate);
    procedure AttachmentsClear;
  end;

var
  AttachmentForm: TAttachmentForm;

implementation

{$R *.lfm}

{ TAttachmentForm }

procedure TAttachmentForm.AttachmentSelect;
begin
  ButtonsEnabled;
end;

procedure TAttachmentForm.AttachmentEdit(const AEditMode: Byte);
var
  AttachmentEditForm: TAttachmentEditForm;
begin
  AttachmentEditForm:= TAttachmentEditForm.Create(nil);
  try
    if AEditMode=1 then
      AttachmentEditForm.AttachmentID:= 0
    else begin
      AttachmentEditForm.AttachmentID:= AttachmentIDs[VST.SelectedIndex];
      AttachmentEditForm.OldAttachmentName:= AttachmentNames[VST.SelectedIndex];
      AttachmentEditForm.OldAttachmentExtension:= AttachmentExtensions[VST.SelectedIndex];
    end;
    AttachmentEditForm.Category:= Category;
    AttachmentEditForm.LogID:= LogID;
    AttachmentEditForm.NoticeNum:= NoticeNum;
    AttachmentEditForm.NoticeDate:= NoticeDate;
    AttachmentEditForm.MotorName:= MotorName;
    AttachmentEditForm.MotorNum:= MotorNum;
    AttachmentEditForm.MotorDate:= MotorDate;
    if AttachmentEditForm.ShowModal=mrOK then AttachmentUpdate;
  finally
    FreeAndNil(AttachmentEditForm);
  end;
end;

procedure TAttachmentForm.AttachmentDelete;
var
  i: Integer;
  FileName: String;
begin
  i:= VST.SelectedIndex;
  if not Confirm('Удалить "' + AttachmentNames[i]+'"?') then Exit;
  FileName:= AttachmentFileFullNameGet(Category,
                                       AttachmentNames[i], AttachmentExtensions[i],
                                       NoticeDate, NoticeNum,
                                       MotorDate, MotorName, MotorNum);
  DocumentDelete(FileName);
  SQLite.AttachmentDelete(Category, AttachmentIDs[i]);
  AttachmentUpdate;
end;

procedure TAttachmentForm.AttachmentView;
var
  i: Integer;
  FileName: String;
begin
  i:= VST.SelectedIndex;
  FileName:= AttachmentFileFullNameGet(Category,
                                       AttachmentNames[i], AttachmentExtensions[i],
                                       NoticeDate, NoticeNum,
                                       MotorDate, MotorName, MotorNum);
  DocumentOpen(FileName);
end;

procedure TAttachmentForm.AttachmentCopy;
var
  i: Integer;
  SrcFileName, DestFileName: String;
begin
  i:= VST.SelectedIndex;
  DestFileName:= AttachmentFileNameGet(Category, AttachmentNames[i], NoticeDate, NoticeNum);
  SrcFileName:= AttachmentFileFullNameGet(Category,
                                       AttachmentNames[i], AttachmentExtensions[i],
                                       NoticeDate, NoticeNum,
                                       MotorDate, MotorName, MotorNum);
  FileCopy(SrcFileName, DestFileName, AttachmentExtensions[i]);
end;

procedure TAttachmentForm.FormCreate(Sender: TObject);
begin
  VST:= TVSTStringList.Create(VT1, '', @AttachmentSelect);
end;

procedure TAttachmentForm.AddButtonClick(Sender: TObject);
begin
  AttachmentEdit(1);
end;

procedure TAttachmentForm.CopyButtonClick(Sender: TObject);
begin
  AttachmentCopy;
end;

procedure TAttachmentForm.DelButtonClick(Sender: TObject);
begin
  AttachmentDelete;
end;

procedure TAttachmentForm.EditButtonClick(Sender: TObject);
begin
  AttachmentEdit(2);
end;

procedure TAttachmentForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VST);
end;

procedure TAttachmentForm.ViewButtonClick(Sender: TObject);
begin
  AttachmentView;
end;

procedure TAttachmentForm.ButtonsEnabled;
begin
  DelButton.Enabled:= VST.IsSelected;
  EditButton.Enabled:= DelButton.Enabled;
  ViewButton.Enabled:= DelButton.Enabled;
  CopyButton.Enabled:= DelButton.Enabled;
end;

procedure TAttachmentForm.AttachmentsShow(const ALogID: Integer;
                              const ANoticeNum: String;
                              const ANoticeDate: TDate;
                              const AMotorNum, AMotorName: String;
                              const AMotorDate: TDate);
begin
  LogID:= ALogID;
  NoticeNum:= ANoticeNum;
  NoticeDate:= ANoticeDate;
  MotorNum:= AMotorNum;
  MotorName:= AMotorName;
  MotorDate:= AMotorDate;
  AttachmentUpdate;
  AddButton.Enabled:= True;
end;

procedure TAttachmentForm.AttachmentsClear;
begin
  VST.Update(nil);
  AddButton.Enabled:= False;
end;

procedure TAttachmentForm.AttachmentUpdate;
begin
  SQLite.AttachmentListLoad(Category, LogID, AttachmentIDs, AttachmentNames, AttachmentExtensions);
  VST.Update(AttachmentNames);
end;

end.

