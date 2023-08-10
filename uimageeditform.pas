unit UImageEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ExtDlgs, VirtualTrees,

  DK_Vector, DK_VSTTools, DK_StrUtils,

  USQlite;

type

  { TImageEditForm }

  TImageEditForm = class(TForm)
    CancelButton: TSpeedButton;
    EditButtonPanel: TPanel;
    OPDialog1: TOpenPictureDialog;
    OpenButton: TSpeedButton;
    Panel3: TPanel;
    Panel4: TPanel;
    SaveButton: TSpeedButton;
    Image1: TImage;
    FileNameLabel: TLabel;
    Splitter1: TSplitter;
    VT1: TVirtualStringTree;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    VST: TVSTStringList;

    ImageIDs: TIntVector;
    ImageNames: TStrVector;

    procedure ImageListLoad(const ASelectedID: Integer = 0);
    procedure ImageSelect;
    procedure ImageClear;
    procedure ImageSet;
  public

  end;

var
  ImageEditForm: TImageEditForm;

implementation

{$R *.lfm}

{ TImageEditForm }

procedure TImageEditForm.FormCreate(Sender: TObject);
begin
  FileNameLabel.Caption:= EmptyStr;
  VST:= TVSTStringList.Create(VT1, EmptyStr, @ImageSelect);
  ImageListLoad;
end;

procedure TImageEditForm.CancelButtonClick(Sender: TObject);
var
  SelectedIndex: Integer;
begin
  SelectedIndex:= 0;
  if VST.IsSelected then
    SelectedIndex:= VST.SelectedIndex;
  VST.Update(ImageNames, SelectedIndex);
  FileNameLabel.Caption:= EmptyStr;
end;

procedure TImageEditForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VST);
end;

procedure TImageEditForm.OpenButtonClick(Sender: TObject);
begin
  if not OPDialog1.Execute then Exit;
  FileNameLabel.Caption:= OPDialog1.FileName;
  Image1.Picture.LoadFromFile(OPDialog1.FileName);
  SaveButton.Enabled:= not SEmpty(FileNameLabel.Caption);
  CancelButton.Enabled:= True;
end;

procedure TImageEditForm.SaveButtonClick(Sender: TObject);
var
  ImageID: Integer;
begin
  if SEmpty(FileNameLabel.Caption) then Exit;
  ImageID:= ImageIDs[VST.SelectedIndex];
  SQLite.ImageUpdate(ImageID, FileNameLabel.Caption);
  ImageListLoad(ImageID);
  FileNameLabel.Caption:= EmptyStr;
end;

procedure TImageEditForm.ImageListLoad(const ASelectedID: Integer);
var
  SelectedIndex: Integer;
begin
  SQLite.ImageListLoad(ImageIDs, ImageNames);
  SelectedIndex:= VIndexOf(ImageIDs, ASelectedID);
  if SelectedIndex<0 then
    SelectedIndex:= 0;
  VST.Update(ImageNames, SelectedIndex);
end;

procedure TImageEditForm.ImageSelect;
begin
  ImageClear;
  ImageSet;
end;

procedure TImageEditForm.ImageClear;
begin
  Image1.Picture.Clear;
  SaveButton.Enabled:= False;
  CancelButton.Enabled:= False;
end;

procedure TImageEditForm.ImageSet;
var
  S: String;
  MS: TMemoryStream;
begin
  MS:= TMemoryStream.Create;
  try
    if SQLite.ImageLoad(ImageIDs[VST.SelectedIndex], S, MS) then
      Image1.Picture.LoadFromStream(MS);
  finally
    FreeAndNil(MS);
  end;

  SaveButton.Enabled:= False;
  CancelButton.Enabled:= False;
end;

end.

