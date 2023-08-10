unit USenderEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ExtDlgs, VirtualTrees,

  DK_Vector, DK_VSTTools, DK_Dialogs, DK_StrUtils,

  USQlite, ULetters;

type

  { TSenderEditForm }

  TSenderEditForm = class(TForm)
    AddButton: TSpeedButton;
    CancelButton: TSpeedButton;
    DelButton: TSpeedButton;
    EditButtonPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OPDialog1: TOpenPictureDialog;
    OpenSignButton: TSpeedButton;
    Panel1: TPanel;
    MainPanel: TPanel;
    Panel3: TPanel;
    LeftPanel: TPanel;
    SaveButton: TSpeedButton;
    SenderNameEdit: TEdit;
    SenderPostMemo: TMemo;
    SenderSignImage: TImage;
    SignFileNameLabel: TLabel;
    Splitter1: TSplitter;
    VT1: TVirtualStringTree;
    procedure CancelButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OpenSignButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SenderNameEditChange(Sender: TObject);
    procedure SenderPostMemoChange(Sender: TObject);
  private
    VST: TVSTStringList;

    SenderIDs: TIntVector;
    SenderNames: TStrVector;
    SenderPosts: TStrVector;


    procedure SenderListLoad(const ASelectedID: Integer = 0);
    procedure SenderSelect;

    procedure SenderClear;
    procedure SenderSet;
  public

  end;

var
  SenderEditForm: TSenderEditForm;

implementation

{$R *.lfm}

{ TSenderEditForm }


procedure TSenderEditForm.FormCreate(Sender: TObject);
begin
  SignFileNameLabel.Caption:= EmptyStr;
  VST:= TVSTStringList.Create(VT1, EmptyStr, @SenderSelect);
  SenderListLoad;
end;

procedure TSenderEditForm.FormShow(Sender: TObject);
begin
  VT1.SetFocus;
end;

procedure TSenderEditForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VST);
end;

procedure TSenderEditForm.CancelButtonClick(Sender: TObject);
var
  SelectedIndex: Integer;
begin
  SelectedIndex:= 0;
  if VLast(SenderNames)='Новый отправитель' then
    VDel(SenderNames, High(SenderNames))
  else if VST.IsSelected then
    SelectedIndex:= VST.SelectedIndex;
  VST.Update(SenderNames, SelectedIndex);
  SignFileNameLabel.Caption:= EmptyStr;
  MainPanel.Visible:= not VIsNil(SenderNames);
end;

procedure TSenderEditForm.DelButtonClick(Sender: TObject);
begin
  if not Confirm('Удалить "' + SenderNames[VST.SelectedIndex] + '"?') then Exit;
  SQLite.SenderDelete(SenderIDs[VST.SelectedIndex]);
  SenderListLoad;
end;

procedure TSenderEditForm.AddButtonClick(Sender: TObject);
begin
  MainPanel.Visible:= True;
  VAppend(SenderNames, 'Новый отправитель');
  VST.Update(SenderNames, High(SenderNames));
  SenderNameEdit.SetFocus;
  CancelButton.Enabled:= True;
end;

procedure TSenderEditForm.OpenSignButtonClick(Sender: TObject);
begin
  if not OPDialog1.Execute then Exit;
  SignFileNameLabel.Caption:= OPDialog1.FileName;
  SenderSignImage.Picture.LoadFromFile(OPDialog1.FileName);
  SaveButton.Enabled:= not SEmpty(SignFileNameLabel.Caption);
  CancelButton.Enabled:= True;
end;

procedure TSenderEditForm.SaveButtonClick(Sender: TObject);
var
  SenderID: Integer;
  SenderName, SenderPost: String;
  V: TStrVector;
begin
  SenderName:= STrim(SenderNameEdit.Text);
  if SEmpty(SenderName) then
  begin
    ShowInfo('Не указаны Ф.И.О.!');
    Exit;
  end;

  SenderPost:= STrim(SenderPostMemo.Text);
  if SEmpty(SenderPost) then
  begin
    ShowInfo('Не указана должность!');
    Exit;
  end;

  V:= VFromStrings(SenderPostMemo.Lines);
  SenderPost:= VVectorToStr(V, STRING_VECTOR_DELIMITER);

  if VLast(SenderNames)='Новый отправитель' then
  begin
    SQLite.SenderAdd(SenderName, SenderPost);
    SenderID:= SQLite.SenderLastWritedID;
  end
  else begin
    SenderID:= SenderIDs[VST.SelectedIndex];
    SQLite.SenderUpdate(SenderID, SenderName, SenderPost);
  end;

  if not SEmpty(SignFileNameLabel.Caption) then
    SQLite.SenderSignUpdate(SenderID, SignFileNameLabel.Caption);

  SenderListLoad(SenderID);

  SignFileNameLabel.Caption:= EmptyStr;
end;

procedure TSenderEditForm.SenderNameEditChange(Sender: TObject);
begin
  SaveButton.Enabled:= True;
  CancelButton.Enabled:= True;
end;

procedure TSenderEditForm.SenderPostMemoChange(Sender: TObject);
begin
  SaveButton.Enabled:= True;
  CancelButton.Enabled:= True;
end;

procedure TSenderEditForm.SenderListLoad(const ASelectedID: Integer = 0);
var
  SelectedIndex: Integer;
begin
  SQLite.SenderListLoad(SenderIDs, SenderNames, SenderPosts);

  SelectedIndex:= VIndexOf(SenderIDs, ASelectedID);
  if SelectedIndex<0 then
    SelectedIndex:= 0;

  VST.Update(SenderNames, SelectedIndex);

  DelButton.Enabled:= not VIsNil(SenderNames);
  MainPanel.Visible:= not VIsNil(SenderNames);
end;

procedure TSenderEditForm.SenderSelect;
begin
  SenderClear;
  SenderSet;
end;

procedure TSenderEditForm.SenderClear;
begin
  SenderNameEdit.Text:= EmptyStr;
  SenderPostMemo.Text:= EmptyStr;
  SenderSignImage.Picture.Clear;

  SaveButton.Enabled:= False;
  CancelButton.Enabled:= False;
end;

procedure TSenderEditForm.SenderSet;
var
  V: TStrVector;
  S: String;
  MS: TMemoryStream;
begin
  if not VST.IsSelected then Exit;
  if VST.SelectedIndex>High(SenderIDs) then Exit;

  SenderNameEdit.Text:= SenderNames[VST.SelectedIndex];
  V:= VStrToVector(SenderPosts[VST.SelectedIndex], STRING_VECTOR_DELIMITER);
  VToStrings(V, SenderPostMemo.Lines);
  SenderPostMemo.SelStart:= 1;
  MS:= TMemoryStream.Create;
  try
    if SQLite.SenderSignLoad(SenderIDs[VST.SelectedIndex], S, MS) then
      SenderSignImage.Picture.LoadFromStream(MS);
  finally
    FreeAndNil(MS);
  end;

  SaveButton.Enabled:= False;
  CancelButton.Enabled:= False;
end;

end.

