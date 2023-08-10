unit UReceiverEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, VirtualTrees,

  DK_Vector, DK_VSTTools, DK_Dialogs, DK_StrUtils,

  USQlite, ULetters;

type

  { TReceiverEditForm }

  TReceiverEditForm = class(TForm)
    AddButton: TSpeedButton;
    CancelButton: TSpeedButton;
    DelButton: TSpeedButton;
    DeveloperRadioButton: TRadioButton;
    FactoryRadioButton: TRadioButton;
    Panel7: TPanel;
    EditButtonPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    ReceiverPanel: TPanel;
    OrganizationPanel: TPanel;
    Panel4: TPanel;
    MainPanel: TPanel;
    LeftPanel: TPanel;
    ReceiverAppealEdit: TEdit;
    ReceiverNameEdit: TEdit;
    ReceiverPostMemo: TMemo;
    SaveButton: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    TypeButtonPanel: TPanel;
    VT1: TVirtualStringTree;
    VT2: TVirtualStringTree;
    procedure AddButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure DeveloperRadioButtonClick(Sender: TObject);
    procedure FactoryRadioButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ReceiverAppealEditChange(Sender: TObject);
    procedure ReceiverNameEditChange(Sender: TObject);
    procedure ReceiverPostMemoChange(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    VSTOrganizations: TVSTStringList;
    VSTReceivers: TVSTStringList;

    OrganizationIDs: TIntVector;
    OrganizationNames:  TStrVector;
    OrganizationTitles:  TStrVector;

    ReceiverIDs:  TIntVector;
    ReceiverNames:  TStrVector;
    ReceiverPosts:  TStrVector;
    ReceiverAppeals:  TStrVector;

    function OrganizationType: Byte;
    procedure OrganizationsLoad(const ASelectedID: Integer=0);
    procedure OrganizationSelect;

    procedure ReceiversLoad(const ASelectedID: Integer=0);
    procedure ReceiverSelect;
    procedure ReceiverClear;
    procedure ReceiverSet;
  public

  end;

var
  ReceiverEditForm: TReceiverEditForm;

implementation

{$R *.lfm}

{ TReceiverEditForm }

procedure TReceiverEditForm.FormCreate(Sender: TObject);
begin
  VSTOrganizations:= TVSTStringList.Create(VT1, EmptyStr, @OrganizationSelect);
  VSTReceivers:= TVSTStringList.Create(VT2, EmptyStr, @ReceiverSelect);
  OrganizationsLoad;
end;

procedure TReceiverEditForm.FactoryRadioButtonClick(Sender: TObject);
begin
  OrganizationsLoad;
end;

procedure TReceiverEditForm.DeveloperRadioButtonClick(Sender: TObject);
begin
  OrganizationsLoad;
end;

procedure TReceiverEditForm.AddButtonClick(Sender: TObject);
begin
  MainPanel.Visible:= True;
  VAppend(ReceiverNames, 'Новый получатель');
  VSTReceivers.Update(ReceiverNames, High(ReceiverNames));
  ReceiverNameEdit.SetFocus;
  CancelButton.Enabled:= True;
end;

procedure TReceiverEditForm.CancelButtonClick(Sender: TObject);
var
  SelectedIndex: Integer;
begin
  SelectedIndex:= 0;
  if VLast(ReceiverNames)='Новый получатель' then
    VDel(ReceiverNames, High(ReceiverNames))
  else if VSTReceivers.IsSelected then
    SelectedIndex:= VSTReceivers.SelectedIndex;
  VSTReceivers.Update(ReceiverNames, SelectedIndex);
  MainPanel.Visible:= not VIsNil(ReceiverNames);
end;

procedure TReceiverEditForm.DelButtonClick(Sender: TObject);
begin
  if not Confirm('Удалить обращение "' + ReceiverNames[VSTReceivers.SelectedIndex] + '"?') then Exit;
  SQLite.ReceiverDelete(OrganizationType, ReceiverIDs[VSTReceivers.SelectedIndex]);
  ReceiversLoad;
end;

procedure TReceiverEditForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VSTOrganizations);
  FreeAndNil(VSTReceivers);
end;

procedure TReceiverEditForm.FormShow(Sender: TObject);
begin
  TypeButtonPanel.Height:= EditButtonPanel.Height;
  VT1.SetFocus;
end;

procedure TReceiverEditForm.ReceiverAppealEditChange(Sender: TObject);
begin
  SaveButton.Enabled:= True;
  CancelButton.Enabled:= True;
end;

procedure TReceiverEditForm.ReceiverNameEditChange(Sender: TObject);
begin
  SaveButton.Enabled:= True;
  CancelButton.Enabled:= True;
end;

procedure TReceiverEditForm.ReceiverPostMemoChange(Sender: TObject);
begin
  SaveButton.Enabled:= True;
  CancelButton.Enabled:= True;
end;

procedure TReceiverEditForm.SaveButtonClick(Sender: TObject);
var
  ReceiverID, OrganizationID: Integer;
  ReceiverName, ReceiverPost, ReceiverAppeal: String;
  V: TStrVector;
begin
  ReceiverName:= STrim(ReceiverNameEdit.Text);
  if SEmpty(ReceiverName) then
  begin
    ShowInfo('Не указаны Фамилия И.О.!');
    Exit;
  end;

  ReceiverAppeal:= STrim(ReceiverAppealEdit.Text);
  if SEmpty(ReceiverAppeal) then
  begin
    ShowInfo('Не указаны Имя Отчество!');
    Exit;
  end;

  ReceiverPost:= STrim(ReceiverPostMemo.Text);
  if SEmpty(ReceiverPost) then
  begin
    ShowInfo('Не указана должность!');
    Exit;
  end;

  V:= VFromStrings(ReceiverPostMemo.Lines);
  ReceiverPost:= VVectorToStr(V, STRING_VECTOR_DELIMITER);

  OrganizationID:= OrganizationIDs[VSTOrganizations.SelectedIndex];
  if VLast(ReceiverNames)='Новый получатель' then
  begin
    SQLite.ReceiverAdd(OrganizationType, OrganizationID,
                       ReceiverName, ReceiverPost, ReceiverAppeal);
    ReceiverID:= SQLite.ReceiverLastWritedID(OrganizationType);
  end
  else begin
    ReceiverID:= ReceiverIDs[VSTReceivers.SelectedIndex];
    SQLite.ReceiverUpdate(OrganizationType, ReceiverID,
                       ReceiverName, ReceiverPost, ReceiverAppeal);
  end;

  ReceiversLoad(ReceiverID);
end;

function TReceiverEditForm.OrganizationType: Byte;
begin
  Result:= 0;
  if FactoryRadioButton.Checked then
    Result:= 1
  else if DeveloperRadioButton.Checked then
    Result:= 2;
end;

procedure TReceiverEditForm.OrganizationsLoad(const ASelectedID: Integer = 0);
var
  SelectedIndex: Integer;
begin
  ReceiverClear;

  SQLite.OrganizationListLoad(OrganizationType, OrganizationIDs,
                              OrganizationNames, OrganizationTitles);

  SelectedIndex:= VIndexOf(OrganizationIDs, ASelectedID);
  if SelectedIndex<0 then
    SelectedIndex:= 0;

  VSTOrganizations.Update(OrganizationNames, SelectedIndex);

  ReceiverPanel.Visible:= not VIsNil(OrganizationNames);
end;

procedure TReceiverEditForm.OrganizationSelect;
begin
  ReceiversLoad;
end;

procedure TReceiverEditForm.ReceiversLoad(const ASelectedID: Integer = 0);
var
  SelectedIndex, OrganizationID: Integer;
begin
  ReceiverClear;
  OrganizationID:= -1;
  if (not VIsNil(OrganizationIDs)) and VSTOrganizations.IsSelected then
    OrganizationID:= OrganizationIDs[VSTOrganizations.SelectedIndex];

  SQLite.ReceiverListLoad(OrganizationType, OrganizationID,
                  ReceiverIDs, ReceiverNames, ReceiverPosts, ReceiverAppeals);

  SelectedIndex:= VIndexOf(ReceiverIDs, ASelectedID);
  if SelectedIndex<0 then
    SelectedIndex:= 0;

  VSTReceivers.Update(ReceiverNames, SelectedIndex);

  DelButton.Enabled:= not VIsNil(ReceiverNames);
  MainPanel.Visible:= not VIsNil(ReceiverNames);
end;

procedure TReceiverEditForm.ReceiverSelect;
begin
  ReceiverClear;
  ReceiverSet;
end;

procedure TReceiverEditForm.ReceiverClear;
begin
  ReceiverNameEdit.Text:= EmptyStr;
  ReceiverAppealEdit.Text:= EmptyStr;
  ReceiverPostMemo.Text:= EmptyStr;

  SaveButton.Enabled:= False;
  CancelButton.Enabled:= False;
end;

procedure TReceiverEditForm.ReceiverSet;
var
  V: TStrVector;

begin
  if not VSTReceivers.IsSelected then Exit;
  if VSTReceivers.SelectedIndex>High(ReceiverIDs) then Exit;

  ReceiverNameEdit.Text:= ReceiverNames[VSTReceivers.SelectedIndex];
  ReceiverAppealEdit.Text:= ReceiverAppeals[VSTReceivers.SelectedIndex];
  V:= VStrToVector(ReceiverPosts[VSTReceivers.SelectedIndex], STRING_VECTOR_DELIMITER);
  VToStrings(V, ReceiverPostMemo.Lines);
  ReceiverPostMemo.SelStart:= 1;

  SaveButton.Enabled:= False;
  CancelButton.Enabled:= False;
end;

end.

