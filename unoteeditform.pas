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
    LogID: Integer;
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
  SQLite.NoteUpdate(LogID, Category, Note);
  ModalResult:= mrOK;
end;

procedure TNoteEditForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TNoteEditForm.FormShow(Sender: TObject);
var
  Note: String;
begin
  SQLite.NoteLoad(LogID, Category, Note);
  Memo1.Text:= Note;
end;

end.

