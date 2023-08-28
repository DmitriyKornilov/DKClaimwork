unit UNoteEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, DividerBevel,

  DK_StrUtils,

  USQLite;

type

  { TNoteEditForm }

  TNoteEditForm = class(TForm)
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    LetterNameLabel: TLabel;
    Memo1: TMemo;
    SaveButton: TSpeedButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private

  public
    Category: Byte; //1-по расследованию, 2-по ремонту, 3-по возмещению затрат
    ID: Integer;
  end;

var
  NoteEditForm: TNoteEditForm;

implementation

{$R *.lfm}

{ TNoteEditForm }

procedure TNoteEditForm.SaveButtonClick(Sender: TObject);
var
  Note: String;
begin
  Note:= SFromStrings(Memo1.Lines);
  if Category=3 then
    SQLite.PretensionNoteUpdate(ID, Note)
  else
    SQLite.NoteUpdate(ID, Category, Note);
  ModalResult:= mrOK;
end;

procedure TNoteEditForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TNoteEditForm.FormShow(Sender: TObject);
begin
  if Category=3 then
    Memo1.Text:= SQLite.PretensionNoteLoad(ID)
  else
    Memo1.Text:= SQLite.NoteLoad(ID, Category);
end;

end.

