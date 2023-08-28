unit UMileageEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Spin, Buttons, DividerBevel,

  USQLite;

type

  { TMileageEditForm }

  TMileageEditForm = class(TForm)
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    Label1: TLabel;
    SaveButton: TSpeedButton;
    MileageEdit: TSpinEdit;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private

  public
    LogID: Integer;
  end;

var
  MileageEditForm: TMileageEditForm;

implementation

{$R *.lfm}

{ TMileageEditForm }

procedure TMileageEditForm.SaveButtonClick(Sender: TObject);
begin
  SQLite.MileageUpdate(LogID, MileageEdit.Value);
  ModalResult:= mrOK;
end;

procedure TMileageEditForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TMileageEditForm.FormShow(Sender: TObject);
begin
  MileageEdit.Value:= SQLite.MileageLoad(LogID);
end;

end.

